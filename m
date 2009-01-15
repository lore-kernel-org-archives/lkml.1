Return-Path: <linux-kernel-owner+w=401wt.eu-S936109AbZAOWjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936109AbZAOWjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765453AbZAOWDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:49 -0500
Received: from kroah.org ([198.145.64.141]:38932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933788AbZAOWDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:40 -0500
Date: Thu, 15 Jan 2009 14:01:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Bryon Roche <kain@kain.org>
Subject: [patch 65/85] e1000e: fix IPMI traffic
Message-ID: <20090115220130.GN17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="e1000e-fix-ipmi-traffic.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

commit eb7c3adb1ca92450870dbb0d347fc986cd5e2af4 upstream.

Some users reported that they have machines with BMCs enabled that cannot
receive IPMI traffic after e1000e is loaded.
http://marc.info/?l=e1000-devel&m=121909039127414&w=2
http://marc.info/?l=e1000-devel&m=121365543823387&w=2

This fixes the issue if they load with the new parameter = 0 by disabling
crc stripping, but leaves the performance feature on for most users.
Based on work done by Hong Zhang.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Bryon Roche <kain@kain.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/e1000.h  |    5 +++++
 drivers/net/e1000e/netdev.c |   23 +++++++++++++++++++++--
 drivers/net/e1000e/param.c  |   25 +++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 2 deletions(-)

--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -283,6 +283,7 @@ struct e1000_adapter {
 	unsigned long led_status;
 
 	unsigned int flags;
+	unsigned int flags2;
 	struct work_struct downshift_task;
 	struct work_struct update_phy_task;
 };
@@ -290,6 +291,7 @@ struct e1000_adapter {
 struct e1000_info {
 	enum e1000_mac_type	mac;
 	unsigned int		flags;
+	unsigned int            flags2;
 	u32			pba;
 	s32			(*get_variants)(struct e1000_adapter *);
 	struct e1000_mac_operations *mac_ops;
@@ -330,6 +332,9 @@ struct e1000_info {
 #define FLAG_RX_RESTART_NOW               (1 << 30)
 #define FLAG_MSI_TEST_FAILED              (1 << 31)
 
+/* CRC Stripping defines */
+#define FLAG2_CRC_STRIPPING               (1 << 0)
+
 #define E1000_RX_DESC_PS(R, i)	    \
 	(&(((union e1000_rx_desc_packet_split *)((R).desc))[i]))
 #define E1000_GET_DESC(R, i, type)	(&(((struct type *)((R).desc))[i]))
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -497,6 +497,10 @@ static bool e1000_clean_rx_irq(struct e1
 			goto next_desc;
 		}
 
+		/* adjust length to remove Ethernet CRC */
+		if (!(adapter->flags2 & FLAG2_CRC_STRIPPING))
+			length -= 4;
+
 		total_rx_bytes += length;
 		total_rx_packets++;
 
@@ -802,6 +806,10 @@ static bool e1000_clean_rx_irq_ps(struct
 			pci_dma_sync_single_for_device(pdev, ps_page->dma,
 				PAGE_SIZE, PCI_DMA_FROMDEVICE);
 
+			/* remove the CRC */
+			if (!(adapter->flags2 & FLAG2_CRC_STRIPPING))
+				l1 -= 4;
+
 			skb_put(skb, l1);
 			goto copydone;
 		} /* if */
@@ -823,6 +831,12 @@ static bool e1000_clean_rx_irq_ps(struct
 			skb->truesize += length;
 		}
 
+		/* strip the ethernet crc, problem is we're using pages now so
+		 * this whole operation can get a little cpu intensive
+		 */
+		if (!(adapter->flags2 & FLAG2_CRC_STRIPPING))
+			pskb_trim(skb, skb->len - 4);
+
 copydone:
 		total_rx_bytes += skb->len;
 		total_rx_packets++;
@@ -1987,8 +2001,12 @@ static void e1000_setup_rctl(struct e100
 	else
 		rctl |= E1000_RCTL_LPE;
 
-	/* Enable hardware CRC frame stripping */
-	rctl |= E1000_RCTL_SECRC;
+	/* Some systems expect that the CRC is included in SMBUS traffic. The
+	 * hardware strips the CRC before sending to both SMBUS (BMC) and to
+	 * host memory when this is enabled
+	 */
+	if (adapter->flags2 & FLAG2_CRC_STRIPPING)
+		rctl |= E1000_RCTL_SECRC;
 
 	/* Setup buffer sizes */
 	rctl &= ~E1000_RCTL_SZ_4096;
@@ -4412,6 +4430,7 @@ static int __devinit e1000_probe(struct 
 	adapter->ei = ei;
 	adapter->pba = ei->pba;
 	adapter->flags = ei->flags;
+	adapter->flags2 = ei->flags2;
 	adapter->hw.adapter = adapter;
 	adapter->hw.mac.type = ei->mac;
 	adapter->msg_enable = (1 << NETIF_MSG_DRV | NETIF_MSG_PROBE) - 1;
--- a/drivers/net/e1000e/param.c
+++ b/drivers/net/e1000e/param.c
@@ -142,6 +142,16 @@ E1000_PARAM(KumeranLockLoss, "Enable Kum
  */
 E1000_PARAM(WriteProtectNVM, "Write-protect NVM [WARNING: disabling this can lead to corrupted NVM]");
 
+/*
+ * Enable CRC Stripping
+ *
+ * Valid Range: 0, 1
+ *
+ * Default Value: 1 (enabled)
+ */
+E1000_PARAM(CrcStripping, "Enable CRC Stripping, disable if your BMC needs " \
+                          "the CRC");
+
 struct e1000_option {
 	enum { enable_option, range_option, list_option } type;
 	const char *name;
@@ -377,6 +387,21 @@ void __devinit e1000e_check_options(stru
 				adapter->flags |= FLAG_SMART_POWER_DOWN;
 		}
 	}
+	{ /* CRC Stripping */
+		const struct e1000_option opt = {
+			.type = enable_option,
+			.name = "CRC Stripping",
+			.err  = "defaulting to enabled",
+			.def  = OPTION_ENABLED
+		};
+
+		if (num_CrcStripping > bd) {
+			unsigned int crc_stripping = CrcStripping[bd];
+			e1000_validate_option(&crc_stripping, &opt, adapter);
+			if (crc_stripping == OPTION_ENABLED)
+				adapter->flags2 |= FLAG2_CRC_STRIPPING;
+		}
+	}
 	{ /* Kumeran Lock Loss Workaround */
 		const struct e1000_option opt = {
 			.type = enable_option,

