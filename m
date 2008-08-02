Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYHBRTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYHBRTv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYHBRTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:19:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:8181 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYHBRTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=DLeuUthZmTc6PRHLRzNVu2tEVmI/ERiSfWBS/oaoBWL2BSCP8g8MXXnzAz8XLa6mzj
         DWpEqMTXByLuD8WsPQ4jI1gnIxtfSrD853MvQMIj0TVD/V3lqOB7SxWbTkiHZUM3iWjk
         DlNIncURk067pS+2cKcSsRP5QvIQ268b/qOa0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] hpt366: add hpt3xx_disable_fast_irq() helper
Date: Sat, 2 Aug 2008 19:15:03 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808021915.03424.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out disabling of "fast interrupt" prediction from
  init_hwif_hpt366() to hpt3xx_disable_fast_irq() helper.

* Use hpt3xx_disable_fast_irq() in ->init_chipset instead of
  ->init_hwif method.

  This is a preparation for adding proper PCI PM support.

While at it:

* Cache chip type in chip_type variable in hpt3xx_disable_fast_irq().

There should be no functional changes caused by this patch.

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/hpt366.c |   58 ++++++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -969,6 +969,36 @@ static int __devinit hpt37x_calibrate_dp
 	return 1;
 }
 
+static void __devinit hpt3xx_disable_fast_irq(struct pci_dev *dev, u8 mcr_addr)
+{
+	struct ide_host *host	= pci_get_drvdata(dev);
+	struct hpt_info *info	= host->host_priv + (&dev->dev == host->dev[1]);
+	u8  chip_type		= info->chip_type;
+	u8  new_mcr, old_mcr	= 0;
+
+	/*
+	 * Disable the "fast interrupt" prediction.  Don't hold off
+	 * on interrupts. (== 0x01 despite what the docs say)
+	 */
+	pci_read_config_byte(dev, mcr_addr + 1, &old_mcr);
+
+	if (chip_type >= HPT374)
+		new_mcr = old_mcr & ~0x07;
+	else if (chip_type >= HPT370) {
+		new_mcr = old_mcr;
+		new_mcr &= ~0x02;
+#ifdef HPT_DELAY_INTERRUPT
+		new_mcr &= ~0x01;
+#else
+		new_mcr |=  0x01;
+#endif
+	} else					/* HPT366 and HPT368  */
+		new_mcr = old_mcr & ~0x80;
+
+	if (new_mcr != old_mcr)
+		pci_write_config_byte(dev, mcr_addr + 1, new_mcr);
+}
+
 static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev)
 {
 	unsigned long io_base	= pci_resource_start(dev, 4);
@@ -1207,9 +1237,11 @@ static unsigned int __devinit init_chips
 	 * NOTE: This register is only writeable via I/O space.
 	 */
 	if (chip_type == HPT371N && clock == ATA_CLOCK_66MHZ)
-
 		outb(inb(io_base + 0x9c) | 0x04, io_base + 0x9c);
 
+	hpt3xx_disable_fast_irq(dev, 0x50);
+	hpt3xx_disable_fast_irq(dev, 0x54);
+
 	return dev->irq;
 }
 
@@ -1265,7 +1297,6 @@ static void __devinit init_hwif_hpt366(i
 	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
 	int serialize		= HPT_SERIALIZE_IO;
 	u8  chip_type		= info->chip_type;
-	u8  new_mcr, old_mcr	= 0;
 
 	/* Cache the channel's MISC. control registers' offset */
 	hwif->select_data	= hwif->channel ? 0x54 : 0x50;
@@ -1288,29 +1319,6 @@ static void __devinit init_hwif_hpt366(i
 	/* Serialize access to this device if needed */
 	if (serialize && hwif->mate)
 		hwif->serialized = hwif->mate->serialized = 1;
-
-	/*
-	 * Disable the "fast interrupt" prediction.  Don't hold off
-	 * on interrupts. (== 0x01 despite what the docs say)
-	 */
-	pci_read_config_byte(dev, hwif->select_data + 1, &old_mcr);
-
-	if (info->chip_type >= HPT374)
-		new_mcr = old_mcr & ~0x07;
-	else if (info->chip_type >= HPT370) {
-		new_mcr = old_mcr;
-		new_mcr &= ~0x02;
-
-#ifdef HPT_DELAY_INTERRUPT
-		new_mcr &= ~0x01;
-#else
-		new_mcr |=  0x01;
-#endif
-	} else					/* HPT366 and HPT368  */
-		new_mcr = old_mcr & ~0x80;
-
-	if (new_mcr != old_mcr)
-		pci_write_config_byte(dev, hwif->select_data + 1, new_mcr);
 }
 
 static int __devinit init_dma_hpt366(ide_hwif_t *hwif,
