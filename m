Return-Path: <linux-kernel-owner+w=401wt.eu-S1764848AbXKOGo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764848AbXKOGo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760877AbXKOGmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:42:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55082 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760295AbXKOGmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:42:44 -0500
Date: Wed, 14 Nov 2007 22:40:18 -0800
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
       Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 06/16] TG3: Fix performance regression on 5705.
Message-ID: <20071115064018.GF18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tg3-fix-performance-regression-on-5705.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Chan <mchan@broadcom.com>

patch 114342f2d38439cb1a54f1f724fa38729b093c48 in mainline.

A performance regression was introduced by the following commit:

    commit ee6a99b539a50b4e9398938a0a6d37f8bf911550
    Author: Michael Chan <mchan@broadcom.com>
    Date:   Wed Jul 18 21:49:10 2007 -0700

    [TG3]: Fix msi issue with kexec/kdump.

In making that change, the PCI latency timer and cache line size
registers were not restored after chip reset.  On the 5705, the
latency timer gets reset to 0 during chip reset and this causes
very poor performance.

Update version to 3.81.1

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tg3.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -64,8 +64,8 @@
 
 #define DRV_MODULE_NAME		"tg3"
 #define PFX DRV_MODULE_NAME	": "
-#define DRV_MODULE_VERSION	"3.81"
-#define DRV_MODULE_RELDATE	"September 5, 2007"
+#define DRV_MODULE_VERSION	"3.81.1"
+#define DRV_MODULE_RELDATE	"October 18, 2007"
 
 #define TG3_DEF_MAC_MODE	0
 #define TG3_DEF_RX_MODE		0
@@ -4874,6 +4874,12 @@ static void tg3_restore_pci_state(struct
 
 	pci_write_config_dword(tp->pdev, TG3PCI_COMMAND, tp->pci_cmd);
 
+	if (!(tp->tg3_flags2 & TG3_FLG2_PCI_EXPRESS)) {
+		pci_write_config_byte(tp->pdev, PCI_CACHE_LINE_SIZE,
+				      tp->pci_cacheline_sz);
+		pci_write_config_byte(tp->pdev, PCI_LATENCY_TIMER,
+				      tp->pci_lat_timer);
+	}
 	/* Make sure PCI-X relaxed ordering bit is clear. */
 	pci_read_config_dword(tp->pdev, TG3PCI_X_CAPS, &val);
 	val &= ~PCIX_CAPS_RELAXED_ORDERING;

-- 
