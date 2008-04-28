Return-Path: <linux-kernel-owner+w=401wt.eu-S936952AbYD1XvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936952AbYD1XvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935082AbYD1Xt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:49:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:25522 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628AbYD1Xt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gUc0hhd76v+r/CXjmwA5xuF5/K7LFxhb95tlnpbxVV783KbintpVdaKrYFiZ2D3UdlL+CPDOh37kR0uoN7e1fRa5p91xtp2nCLjlCudBbSIfWncGTIKHK5PkQlrNggp82dcMquEaqHStnpEb+mO3+JCMO62iiV+wYIYwB85PIBY=
Subject: [PATCH 3/3] drivers: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 16:50:04 -0700
Message-Id: <1209426605.24729.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/cs5535_gpio.c         |    2 +-
 drivers/char/n_hdlc.c              |    2 +-
 drivers/char/rio/rioroute.c        |    2 +-
 drivers/firmware/iscsi_ibft_find.c |    2 +-
 drivers/mtd/maps/plat-ram.c        |    2 +-
 drivers/pci/pcie/aer/aerdrv_acpi.c |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/cs5535_gpio.c b/drivers/char/cs5535_gpio.c
index c2d23ca..c0a4a0b 100644
--- a/drivers/char/cs5535_gpio.c
+++ b/drivers/char/cs5535_gpio.c
@@ -215,7 +215,7 @@ static int __init cs5535_gpio_init(void)
 	else
 		mask = 0x0b003c66;
 
-	if (request_region(gpio_base, CS5535_GPIO_SIZE, NAME) == 0) {
+	if (!request_region(gpio_base, CS5535_GPIO_SIZE, NAME)) {
 		printk(KERN_ERR NAME ": can't allocate I/O for GPIO\n");
 		return -ENODEV;
 	}
diff --git a/drivers/char/n_hdlc.c b/drivers/char/n_hdlc.c
index 82bcfb9..06803ed 100644
--- a/drivers/char/n_hdlc.c
+++ b/drivers/char/n_hdlc.c
@@ -501,7 +501,7 @@ static void n_hdlc_tty_receive(struct tty_struct *tty, const __u8 *data,
 			__FILE__,__LINE__, count);
 		
 	/* This can happen if stuff comes in on the backup tty */
-	if (n_hdlc == 0 || tty != n_hdlc->tty)
+	if (!n_hdlc || tty != n_hdlc->tty)
 		return;
 		
 	/* verify line is using HDLC discipline */
diff --git a/drivers/char/rio/rioroute.c b/drivers/char/rio/rioroute.c
index 85091ff..7a9df7d 100644
--- a/drivers/char/rio/rioroute.c
+++ b/drivers/char/rio/rioroute.c
@@ -526,7 +526,7 @@ void RIOFixPhbs(struct rio_info *p, struct Host *HostP, unsigned int unit)
 			 ** If RTA is not powered on, the tx packets will be
 			 ** unset, so go no further.
 			 */
-			if (PortP->TxStart == 0) {
+			if (!PortP->TxStart) {
 				rio_dprintk(RIO_DEBUG_ROUTE, "Tx pkts not set up yet\n");
 				rio_spin_unlock_irqrestore(&PortP->portSem, flags);
 				break;
diff --git a/drivers/firmware/iscsi_ibft_find.c b/drivers/firmware/iscsi_ibft_find.c
index d0e5fa4..11f1744 100644
--- a/drivers/firmware/iscsi_ibft_find.c
+++ b/drivers/firmware/iscsi_ibft_find.c
@@ -58,7 +58,7 @@ void __init reserve_ibft_region(void)
 	unsigned int len = 0;
 	void *virt;
 
-	ibft_addr = 0;
+	ibft_addr = NULL;
 
 	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
 		/* The table can't be inside the VGA BIOS reserved space,
diff --git a/drivers/mtd/maps/plat-ram.c b/drivers/mtd/maps/plat-ram.c
index f0b10ca..3eb2643 100644
--- a/drivers/mtd/maps/plat-ram.c
+++ b/drivers/mtd/maps/plat-ram.c
@@ -209,7 +209,7 @@ static int platram_probe(struct platform_device *pdev)
 	/* probe for the right mtd map driver
 	 * supplied by the platform_data struct */
 
-	if (pdata->map_probes != 0) {
+	if (pdata->map_probes) {
 		const char **map_probes = pdata->map_probes;
 
 		for ( ; !info->mtd && *map_probes; map_probes++)
diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 96ac540..d39a78d 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -31,7 +31,7 @@ int aer_osc_setup(struct pcie_device *pciedev)
 {
 	acpi_status status = AE_NOT_FOUND;
 	struct pci_dev *pdev = pciedev->port;
-	acpi_handle handle = 0;
+	acpi_handle handle = NULL;
 
 	if (acpi_pci_disabled)
 		return -1;
-- 
1.5.5.1.270.g89765

