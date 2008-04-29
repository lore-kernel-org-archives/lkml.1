Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbYD2RVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbYD2RVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbYD2RUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:14 -0400
Received: from ns.suse.de ([195.135.220.2]:51778 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbYD2RUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:11 -0400
Date: Tue, 29 Apr 2008 10:18:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [04/37] tg3: 5701 DMA corruption fix
Message-ID: <20080429171800.GE14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tg3-5701-dma-corruption-fix.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Matt Carlson <mcarlson@broadcom.com>

[ Upstream commit: 41588ba1ae166eaba0a70abf2d7ff064ad9331d3 ]

Herbert Xu's commit fb93134dfc2a6e6fbedc7c270a31da03fce88db9, entitled
"[TCP]: Fix size calculation in sk_stream_alloc_pskb", has triggered a
bug in the 5701 where the 5701 DMA engine will corrupt outgoing
packets.  This problem only happens when the starting address of the
packet matches a certain range of offsets and only when the 5701 is
placed downstream of a particular Intel bridge.

This patch detects the problematic bridge and if present, readjusts the
starting address of the packet data to a dword aligned boundary.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tg3.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/net/tg3.h |    1 +
 2 files changed, 49 insertions(+), 4 deletions(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -64,8 +64,8 @@
 
 #define DRV_MODULE_NAME		"tg3"
 #define PFX DRV_MODULE_NAME	": "
-#define DRV_MODULE_VERSION	"3.90"
-#define DRV_MODULE_RELDATE	"April 12, 2008"
+#define DRV_MODULE_VERSION	"3.91"
+#define DRV_MODULE_RELDATE	"April 18, 2008"
 
 #define TG3_DEF_MAC_MODE	0
 #define TG3_DEF_RX_MODE		0
@@ -4135,11 +4135,21 @@ static int tigon3_dma_hwbug_workaround(s
 				       u32 last_plus_one, u32 *start,
 				       u32 base_flags, u32 mss)
 {
-	struct sk_buff *new_skb = skb_copy(skb, GFP_ATOMIC);
+	struct sk_buff *new_skb;
 	dma_addr_t new_addr = 0;
 	u32 entry = *start;
 	int i, ret = 0;
 
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) != ASIC_REV_5701)
+		new_skb = skb_copy(skb, GFP_ATOMIC);
+	else {
+		int more_headroom = 4 - ((unsigned long)skb->data & 3);
+
+		new_skb = skb_copy_expand(skb,
+					  skb_headroom(skb) + more_headroom,
+					  skb_tailroom(skb), GFP_ATOMIC);
+	}
+
 	if (!new_skb) {
 		ret = -1;
 	} else {
@@ -4462,7 +4472,9 @@ static int tg3_start_xmit_dma_bug(struct
 
 	would_hit_hwbug = 0;
 
-	if (tg3_4g_overflow_test(mapping, len))
+	if (tp->tg3_flags3 & TG3_FLG3_5701_DMA_BUG)
+		would_hit_hwbug = 1;
+	else if (tg3_4g_overflow_test(mapping, len))
 		would_hit_hwbug = 1;
 
 	tg3_set_txd(tp, entry, mapping, len, base_flags,
@@ -11339,6 +11351,38 @@ static int __devinit tg3_get_invariants(
 		}
 	}
 
+	if ((GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5701)) {
+		static struct tg3_dev_id {
+			u32	vendor;
+			u32	device;
+		} bridge_chipsets[] = {
+			{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PXH_0 },
+			{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PXH_1 },
+			{ },
+		};
+		struct tg3_dev_id *pci_id = &bridge_chipsets[0];
+		struct pci_dev *bridge = NULL;
+
+		while (pci_id->vendor != 0) {
+			bridge = pci_get_device(pci_id->vendor,
+						pci_id->device,
+						bridge);
+			if (!bridge) {
+				pci_id++;
+				continue;
+			}
+			if (bridge->subordinate &&
+			    (bridge->subordinate->number <=
+			     tp->pdev->bus->number) &&
+			    (bridge->subordinate->subordinate >=
+			     tp->pdev->bus->number)) {
+				tp->tg3_flags3 |= TG3_FLG3_5701_DMA_BUG;
+				pci_dev_put(bridge);
+				break;
+			}
+		}
+	}
+
 	/* The EPB bridge inside 5714, 5715, and 5780 cannot support
 	 * DMA addresses > 40-bit. This bridge may have other additional
 	 * 57xx devices behind it in some 4-port NIC designs for example.
--- a/drivers/net/tg3.h
+++ b/drivers/net/tg3.h
@@ -2476,6 +2476,7 @@ struct tg3 {
 #define TG3_FLG3_NO_NVRAM_ADDR_TRANS	0x00000001
 #define TG3_FLG3_ENABLE_APE		0x00000002
 #define TG3_FLG3_5761_5784_AX_FIXES	0x00000004
+#define TG3_FLG3_5701_DMA_BUG		0x00000008
 
 	struct timer_list		timer;
 	u16				timer_counter;

-- 
