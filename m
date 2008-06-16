Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYFPTYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYFPTYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYFPTYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:24:00 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:62095 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532AbYFPTX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=CFaUk6Jbizmx2leTwIHSky5xupfnz3kd0SW7Qv5pNuLdRQBfYVQgTbmuLgzVBWjv+E
         tVWQHMFMyDhwusGaay2c/Ud8HQz6PfmNMA5TBDXo5MtZHHPhERpJY+2pKkZbRKbm36cs
         9J/6vkKMd/BIrXyrVBLIQp0Nnbvv59fPH7yp8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/4] ide-pmac: store pmif instead of hwif in ->driver_data (take 2)
Date: Mon, 16 Jun 2008 21:24:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806162124.45651.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pass pmif instead of hwif to pmac_ide_do_{suspend,resume}().

* Store pmif instead of hwif in ->driver_data.

* Use dev_get_drvdata() instead of ->hwif_data to obtain pmif.

v2:
* Build fixes from Stephen Rothwell.

There should be no functional changes caused by this patch.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch

 drivers/ide/ppc/pmac.c |   97 ++++++++++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 40 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -424,7 +424,9 @@ static void pmac_ide_kauai_selectproc(id
 static void
 pmac_ide_selectproc(ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 
 	if (pmif == NULL)
 		return;
@@ -444,7 +446,9 @@ pmac_ide_selectproc(ide_drive_t *drive)
 static void
 pmac_ide_kauai_selectproc(ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 
 	if (pmif == NULL)
 		return;
@@ -465,7 +469,9 @@ pmac_ide_kauai_selectproc(ide_drive_t *d
 static void
 pmac_ide_do_update_timings(ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 
 	if (pmif == NULL)
 		return;
@@ -493,11 +499,13 @@ static void pmac_outbsync(ide_hwif_t *hw
 static void
 pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct ide_timing *tim = ide_timing_find_mode(XFER_PIO_0 + pio);
 	u32 *timings, t;
 	unsigned accessTicks, recTicks;
 	unsigned accessTime, recTime;
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
 	unsigned int cycle_time;
 
 	if (pmif == NULL)
@@ -778,9 +786,11 @@ set_timings_mdma(ide_drive_t *drive, int
 
 static void pmac_ide_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	int unit = (drive->select.b.unit & 0x01);
 	int ret = 0;
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
 	u32 *timings, *timings2, tl[2];
 
 	timings = &pmif->timings[unit];
@@ -852,11 +862,8 @@ sanitize_timings(pmac_ide_hwif_t *pmif)
 /* Suspend call back, should be called after the child devices
  * have actually been suspended
  */
-static int
-pmac_ide_do_suspend(ide_hwif_t *hwif)
+static int pmac_ide_do_suspend(pmac_ide_hwif_t *pmif)
 {
-	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
-	
 	/* We clear the timings */
 	pmif->timings[0] = 0;
 	pmif->timings[1] = 0;
@@ -884,11 +891,8 @@ pmac_ide_do_suspend(ide_hwif_t *hwif)
 /* Resume call back, should be called before the child devices
  * are resumed
  */
-static int
-pmac_ide_do_resume(ide_hwif_t *hwif)
+static int pmac_ide_do_resume(pmac_ide_hwif_t *pmif)
 {
-	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
-	
 	/* Hard reset & re-enable controller (do we really need to reset ? -BenH) */
 	if (!pmif->mediabay) {
 		ppc_md.feature_call(PMAC_FTR_IDE_RESET, pmif->node, pmif->aapl_bus_id, 1);
@@ -916,7 +920,8 @@ pmac_ide_do_resume(ide_hwif_t *hwif)
 
 static u8 pmac_ide_cable_detect(ide_hwif_t *hwif)
 {
-	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)ide_get_hwifdata(hwif);
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct device_node *np = pmif->node;
 	const char *cable = of_get_property(np, "cable-type", NULL);
 
@@ -1054,7 +1059,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	default_hwif_mmiops(hwif);
        	hwif->OUTBSYNC = pmac_outbsync;
 
-	hwif->hwif_data = pmif;
 	ide_init_port_hw(hwif, hw);
 
 	printk(KERN_INFO "ide%d: Found Apple %s controller, bus ID %d%s, irq %d\n",
@@ -1162,7 +1166,7 @@ pmac_ide_macio_attach(struct macio_dev *
 	} else
 		pmif->dma_regs = NULL;
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
-	dev_set_drvdata(&mdev->ofdev.dev, hwif);
+	dev_set_drvdata(&mdev->ofdev.dev, pmif);
 
 	memset(&hw, 0, sizeof(hw));
 	pmac_ide_init_ports(&hw, pmif->regbase);
@@ -1193,12 +1197,13 @@ out_free_pmif:
 static int
 pmac_ide_macio_suspend(struct macio_dev *mdev, pm_message_t mesg)
 {
-	ide_hwif_t	*hwif = (ide_hwif_t *)dev_get_drvdata(&mdev->ofdev.dev);
-	int		rc = 0;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(&mdev->ofdev.dev);
+	int rc = 0;
 
 	if (mesg.event != mdev->ofdev.dev.power.power_state.event
 			&& (mesg.event & PM_EVENT_SLEEP)) {
-		rc = pmac_ide_do_suspend(hwif);
+		rc = pmac_ide_do_suspend(pmif);
 		if (rc == 0)
 			mdev->ofdev.dev.power.power_state = mesg;
 	}
@@ -1209,11 +1214,12 @@ pmac_ide_macio_suspend(struct macio_dev 
 static int
 pmac_ide_macio_resume(struct macio_dev *mdev)
 {
-	ide_hwif_t	*hwif = (ide_hwif_t *)dev_get_drvdata(&mdev->ofdev.dev);
-	int		rc = 0;
-	
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(&mdev->ofdev.dev);
+	int rc = 0;
+
 	if (mdev->ofdev.dev.power.power_state.event != PM_EVENT_ON) {
-		rc = pmac_ide_do_resume(hwif);
+		rc = pmac_ide_do_resume(pmif);
 		if (rc == 0)
 			mdev->ofdev.dev.power.power_state = PMSG_ON;
 	}
@@ -1282,7 +1288,7 @@ pmac_ide_pci_attach(struct pci_dev *pdev
 	pmif->kauai_fcr = base;
 	pmif->irq = pdev->irq;
 
-	pci_set_drvdata(pdev, hwif);
+	pci_set_drvdata(pdev, pmif);
 
 	memset(&hw, 0, sizeof(hw));
 	pmac_ide_init_ports(&hw, pmif->regbase);
@@ -1308,12 +1314,12 @@ out_free_pmif:
 static int
 pmac_ide_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
-	ide_hwif_t	*hwif = (ide_hwif_t *)pci_get_drvdata(pdev);
-	int		rc = 0;
-	
+	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)pci_get_drvdata(pdev);
+	int rc = 0;
+
 	if (mesg.event != pdev->dev.power.power_state.event
 			&& (mesg.event & PM_EVENT_SLEEP)) {
-		rc = pmac_ide_do_suspend(hwif);
+		rc = pmac_ide_do_suspend(pmif);
 		if (rc == 0)
 			pdev->dev.power.power_state = mesg;
 	}
@@ -1324,11 +1330,11 @@ pmac_ide_pci_suspend(struct pci_dev *pde
 static int
 pmac_ide_pci_resume(struct pci_dev *pdev)
 {
-	ide_hwif_t	*hwif = (ide_hwif_t *)pci_get_drvdata(pdev);
-	int		rc = 0;
-	
+	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)pci_get_drvdata(pdev);
+	int rc = 0;
+
 	if (pdev->dev.power.power_state.event != PM_EVENT_ON) {
-		rc = pmac_ide_do_resume(hwif);
+		rc = pmac_ide_do_resume(pmif);
 		if (rc == 0)
 			pdev->dev.power.power_state = PMSG_ON;
 	}
@@ -1419,10 +1425,11 @@ out:
 static int
 pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 {
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct dbdma_cmd *table;
 	int i, count = 0;
-	ide_hwif_t *hwif = HWIF(drive);
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	struct scatterlist *sg;
 	int wr = (rq_data_dir(rq) == WRITE);
@@ -1518,7 +1525,8 @@ static int
 pmac_ide_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct request *rq = HWGROUP(drive)->rq;
 	u8 unit = (drive->select.b.unit & 0x01);
 	u8 ata4;
@@ -1558,7 +1566,9 @@ pmac_ide_dma_exec_cmd(ide_drive_t *drive
 static void
 pmac_ide_dma_start(ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	volatile struct dbdma_regs __iomem *dma;
 
 	dma = pmif->dma_regs;
@@ -1574,7 +1584,9 @@ pmac_ide_dma_start(ide_drive_t *drive)
 static int
 pmac_ide_dma_end (ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	volatile struct dbdma_regs __iomem *dma;
 	u32 dstat;
 	
@@ -1602,7 +1614,9 @@ pmac_ide_dma_end (ide_drive_t *drive)
 static int
 pmac_ide_dma_test_irq (ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	volatile struct dbdma_regs __iomem *dma;
 	unsigned long status, timeout;
 
@@ -1662,7 +1676,9 @@ static void pmac_ide_dma_host_set(ide_dr
 static void
 pmac_ide_dma_lost_irq (ide_drive_t *drive)
 {
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
+	ide_hwif_t *hwif = drive->hwif;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	volatile struct dbdma_regs __iomem *dma;
 	unsigned long status;
 
@@ -1692,7 +1708,8 @@ static const struct ide_dma_ops pmac_dma
 static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,
 				       const struct ide_port_info *d)
 {
-	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
+	pmac_ide_hwif_t *pmif =
+		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
 	/* We won't need pci_dev if we switch to generic consistent
