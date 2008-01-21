Return-Path: <linux-kernel-owner+w=401wt.eu-S1761778AbYAUXVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761778AbYAUXVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760627AbYAUXSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:18:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:43625 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760398AbYAUXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:18:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=OMCd6oNput75N7VFqTlNQBMZh0tpV1gOHHSGo6mB+rnr+OOCAnylcapIjB5sZux1FfaiHHphc2OcWoaqg7cU9La51YGWY08ku+nY1F2YhDlLIKhSADzB9/Ys6ly5BbiZyiOP2M3OYpj/gQYBXSpCq0T5hWKWm8rqPTa18CsclsQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:31:37 +0100
Message-Id: <20080121233137.30311.8668.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/16] ide: remove SATA_*_REG macros
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* siimage.c: use hwif->sata_scr[SATA_{ERROR,STATUS}_OFFSET] instead of
  SATA_{ERROR,STATUS}_REG macros.

* Remove no longer needed SATA_*_REG macros.

While at it:

* Remove needless SATA Status register read from sil_sata_reset_poll().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/siimage.c |   25 ++++++++++++++++---------
 include/linux/ide.h       |    6 ------
 2 files changed, 16 insertions(+), 15 deletions(-)

Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -331,15 +331,18 @@ static int siimage_mmio_ide_dma_test_irq
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long addr	= siimage_selreg(hwif, 0x1);
+	void __iomem *sata_error_addr
+		= (void __iomem *)hwif->sata_scr[SATA_ERROR_OFFSET];
 
-	if (SATA_ERROR_REG) {
+	if (sata_error_addr) {
 		unsigned long base = (unsigned long)hwif->hwif_data;
-
 		u32 ext_stat = readl((void __iomem *)(base + 0x10));
 		u8 watchdog = 0;
+
 		if (ext_stat & ((hwif->channel) ? 0x40 : 0x10)) {
-			u32 sata_error = readl((void __iomem *)SATA_ERROR_REG);
-			writel(sata_error, (void __iomem *)SATA_ERROR_REG);
+			u32 sata_error = readl(sata_error_addr);
+
+			writel(sata_error, sata_error_addr);
 			watchdog = (sata_error & 0x00680000) ? 1 : 0;
 			printk(KERN_WARNING "%s: sata_error = 0x%08x, "
 				"watchdog = %d, %s\n",
@@ -418,13 +421,17 @@ static int sil_sata_busproc(ide_drive_t 
 
 static int sil_sata_reset_poll(ide_drive_t *drive)
 {
-	if (SATA_STATUS_REG) {
-		ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
+	void __iomem *sata_status_addr
+		= (void __iomem *)hwif->sata_scr[SATA_STATUS_OFFSET];
+
+	if (sata_status_addr) {
+		/* SATA Status is available only when in MMIO mode */
+		u32 sata_stat = readl(sata_status_addr);
 
-		/* SATA_STATUS_REG is valid only when in MMIO mode */
-		if ((readl((void __iomem *)SATA_STATUS_REG) & 0x03) != 0x03) {
+		if ((sata_stat & 0x03) != 0x03) {
 			printk(KERN_WARNING "%s: reset phy dead, status=0x%08x\n",
-				hwif->name, readl((void __iomem *)SATA_STATUS_REG));
+					    hwif->name, sata_stat);
 			HWGROUP(drive)->polling = 0;
 			return ide_started;
 		}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -112,18 +112,12 @@ typedef unsigned char	byte;	/* used ever
 #define SATA_NR_PORTS		(3)	/* 16 possible ?? */
 
 #define SATA_STATUS_OFFSET	(0)
-#define SATA_STATUS_REG		(HWIF(drive)->sata_scr[SATA_STATUS_OFFSET])
 #define SATA_ERROR_OFFSET	(1)
-#define SATA_ERROR_REG		(HWIF(drive)->sata_scr[SATA_ERROR_OFFSET])
 #define SATA_CONTROL_OFFSET	(2)
-#define SATA_CONTROL_REG	(HWIF(drive)->sata_scr[SATA_CONTROL_OFFSET])
 
 #define SATA_MISC_OFFSET	(0)
-#define SATA_MISC_REG		(HWIF(drive)->sata_misc[SATA_MISC_OFFSET])
 #define SATA_PHY_OFFSET		(1)
-#define SATA_PHY_REG		(HWIF(drive)->sata_misc[SATA_PHY_OFFSET])
 #define SATA_IEN_OFFSET		(2)
-#define SATA_IEN_REG		(HWIF(drive)->sata_misc[SATA_IEN_OFFSET])
 
 /*
  * Our Physical Region Descriptor (PRD) table should be large enough
