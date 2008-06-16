Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbYFPTYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbYFPTYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbYFPTYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:24:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:10726 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202AbYFPTYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=xrbC+w/Gg3G5MYSuj9Ek5vXNtbnL0i3zElk3AcS7u00AtHN/WowlTzpH2cfgnGu58O
         6K1t306olZ4KimI+qITfG6niMsqAdAc/ahWAdsffRHtv5JejEFJUJcORMuPw3XCE4Ty+
         OHX8n/75jaMCcpWwVim0GunmDoKmIzdrtBA0U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/4] ide-pmac: move ide_find_port() call to pmac_ide_setup_device() (take 2)
Date: Mon, 16 Jun 2008 21:24:50 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806162124.50385.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ide_find_port() call to pmac_ide_setup_device().

While at it:

- fix return value (s/-ENODEV/-ENOENT/)

- add DRV_NAME define and use it to set name field of pmac_port_info

- use ide_find_port_slot() instead of ide_find_port()

- remove superfluous error message (ide_find_port_slot() takes care of it)

- drop IDE interface number from driver banner message (but include bus type)

v2:
* Build fix (thanks to Stephen Rothwell for noticing the issue).

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch

 drivers/ide/ppc/pmac.c |   42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -48,6 +48,8 @@
 #include <asm/mediabay.h>
 #endif
 
+#define DRV_NAME "ide-pmac"
+
 #undef IDE_PMAC_DEBUG
 
 #define DMA_WAIT_TIMEOUT	50
@@ -982,6 +984,7 @@ static const struct ide_port_ops pmac_id
 static const struct ide_dma_ops pmac_dma_ops;
 
 static const struct ide_port_info pmac_port_info = {
+	.name			= DRV_NAME,
 	.init_dma		= pmac_ide_init_dma,
 	.chipset		= ide_pmac,
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
@@ -1000,11 +1003,11 @@ static const struct ide_port_info pmac_p
  * Setup, register & probe an IDE channel driven by this driver, this is
  * called by one of the 2 probe functions (macio or PCI).
  */
-static int __devinit
-pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
+static int __devinit pmac_ide_setup_device(pmac_ide_hwif_t *pmif, hw_regs_t *hw)
 {
 	struct device_node *np = pmif->node;
 	const int *bidp;
+	ide_hwif_t *hwif;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	struct ide_port_info d = pmac_port_info;
 
@@ -1073,16 +1076,21 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 		msleep(jiffies_to_msecs(IDE_WAKEUP_DELAY));
 	}
 
+	printk(KERN_INFO DRV_NAME ": Found Apple %s controller (%s), "
+			 "bus ID %d%s, irq %d\n", model_name[pmif->kind],
+			 pmif->mdev ? "macio" : "PCI", pmif->aapl_bus_id,
+			 pmif->mediabay ? " (mediabay)" : "", hw->irq);
+
+	hwif = ide_find_port_slot(&d);
+	if (hwif == NULL)
+		return -ENOENT;
+
 	/* Setup MMIO ops */
 	default_hwif_mmiops(hwif);
        	hwif->OUTBSYNC = pmac_outbsync;
 
 	ide_init_port_hw(hwif, hw);
 
-	printk(KERN_INFO "ide%d: Found Apple %s controller, bus ID %d%s, irq %d\n",
-	       hwif->index, model_name[pmif->kind], pmif->aapl_bus_id,
-	       pmif->mediabay ? " (mediabay)" : "", hwif->irq);
-
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, &d);
@@ -1112,7 +1120,6 @@ pmac_ide_macio_attach(struct macio_dev *
 {
 	void __iomem *base;
 	unsigned long regbase;
-	ide_hwif_t *hwif;
 	pmac_ide_hwif_t *pmif;
 	int irq, rc;
 	hw_regs_t hw;
@@ -1121,14 +1128,6 @@ pmac_ide_macio_attach(struct macio_dev *
 	if (pmif == NULL)
 		return -ENOMEM;
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		printk(KERN_ERR "ide-pmac: MacIO interface attach with no slot\n");
-		printk(KERN_ERR "          %s\n", mdev->ofdev.node->full_name);
-		rc = -ENODEV;
-		goto out_free_pmif;
-	}
-
 	if (macio_resource_count(mdev) == 0) {
 		printk(KERN_WARNING "ide-pmac: no address for %s\n",
 				    mdev->ofdev.node->full_name);
@@ -1183,7 +1182,7 @@ pmac_ide_macio_attach(struct macio_dev *
 	hw.dev = &mdev->bus->pdev->dev;
 	hw.parent = &mdev->ofdev.dev;
 
-	rc = pmac_ide_setup_device(pmif, hwif, &hw);
+	rc = pmac_ide_setup_device(pmif, &hw);
 	if (rc != 0) {
 		/* The inteface is released to the common IDE layer */
 		dev_set_drvdata(&mdev->ofdev.dev, NULL);
@@ -1242,7 +1241,6 @@ pmac_ide_macio_resume(struct macio_dev *
 static int __devinit
 pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	ide_hwif_t *hwif;
 	struct device_node *np;
 	pmac_ide_hwif_t *pmif;
 	void __iomem *base;
@@ -1260,14 +1258,6 @@ pmac_ide_pci_attach(struct pci_dev *pdev
 	if (pmif == NULL)
 		return -ENOMEM;
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		printk(KERN_ERR "ide-pmac: PCI interface attach with no slot\n");
-		printk(KERN_ERR "          %s\n", np->full_name);
-		rc = -ENODEV;
-		goto out_free_pmif;
-	}
-
 	if (pci_enable_device(pdev)) {
 		printk(KERN_WARNING "ide-pmac: Can't enable PCI device for "
 				    "%s\n", np->full_name);
@@ -1304,7 +1294,7 @@ pmac_ide_pci_attach(struct pci_dev *pdev
 	hw.irq = pdev->irq;
 	hw.dev = &pdev->dev;
 
-	rc = pmac_ide_setup_device(pmif, hwif, &hw);
+	rc = pmac_ide_setup_device(pmif, &hw);
 	if (rc != 0) {
 		/* The inteface is released to the common IDE layer */
 		pci_set_drvdata(pdev, NULL);
