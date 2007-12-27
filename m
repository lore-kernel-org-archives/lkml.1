Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbXL0TCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbXL0TCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 14:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbXL0TBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 14:01:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:6066 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbXL0TBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 14:01:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KPJajbt1+FF7AIX2iBmFWMqmsfWWEq7I8jg92mOAJSMug+l0xTH0Dw2hhiRgKtBn/PujKjNPY1AtocXsAWlvvjJwFfGjpU9Prx3Ts88fYGbkA16UgboplFgiN+tKWMp6pscGfxZofwQ1+Nuc+J6iSx3MZfE2bYQu7VXl3UCa1l4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, bzolnier@gmail.com
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 27 Dec 2007 20:12:30 +0100
Message-Id: <20071227191230.1357.34822.sendpatchset@localhost.localdomain>
In-Reply-To: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/9] ide: keep pointer to struct device instead of struct pci_dev in ide_hwif_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep pointer to struct device instead of struct pci_dev in ide_hwif_t.

While on it:
* Use *dev->dma_mask instead of pci_dev->dma_mask in ide_toggle_bounce().

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c          |   23 ++++++++++--------
 drivers/ide/ide-lib.c          |    6 +++-
 drivers/ide/ide-probe.c        |    4 +--
 drivers/ide/ide.c              |    3 +-
 drivers/ide/pci/aec62xx.c      |    8 +++---
 drivers/ide/pci/alim15x3.c     |    9 ++++---
 drivers/ide/pci/amd74xx.c      |    7 ++++-
 drivers/ide/pci/atiixp.c       |    9 +++----
 drivers/ide/pci/cmd64x.c       |   14 +++++------
 drivers/ide/pci/cs5520.c       |    2 -
 drivers/ide/pci/cs5535.c       |    4 ++-
 drivers/ide/pci/cy82c693.c     |    5 ++--
 drivers/ide/pci/delkin_cb.c    |    2 -
 drivers/ide/pci/hpt34x.c       |    2 -
 drivers/ide/pci/hpt366.c       |   29 +++++++++++++----------
 drivers/ide/pci/it8213.c       |    7 +++--
 drivers/ide/pci/it821x.c       |   47 ++++++++++++++++++++++---------------
 drivers/ide/pci/jmicron.c      |    2 -
 drivers/ide/pci/ns87415.c      |   14 +++++------
 drivers/ide/pci/pdc202xx_new.c |    6 +++-
 drivers/ide/pci/pdc202xx_old.c |   11 +++++---
 drivers/ide/pci/piix.c         |    6 ++--
 drivers/ide/pci/rz1000.c       |    2 -
 drivers/ide/pci/sc1200.c       |   12 ++++-----
 drivers/ide/pci/scc_pata.c     |   13 ++++------
 drivers/ide/pci/serverworks.c  |   18 ++++++++------
 drivers/ide/pci/sgiioc4.c      |   16 ++++++------
 drivers/ide/pci/siimage.c      |   51 ++++++++++++++++++++++++-----------------
 drivers/ide/pci/sis5513.c      |   22 ++++++++---------
 drivers/ide/pci/sl82c105.c     |   17 ++++++++-----
 drivers/ide/pci/slc90e66.c     |    7 +++--
 drivers/ide/pci/tc86c001.c     |    3 +-
 drivers/ide/pci/triflex.c      |    2 -
 drivers/ide/pci/trm290.c       |    2 -
 drivers/ide/pci/via82cxxx.c    |   12 +++++----
 drivers/ide/ppc/pmac.c         |   10 ++++----
 drivers/ide/setup-pci.c        |    6 ++--
 include/linux/ide.h            |    5 ++--
 38 files changed, 236 insertions(+), 182 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -184,6 +184,7 @@ static int ide_dma_good_drive(ide_drive_
 int ide_build_sglist(ide_drive_t *drive, struct request *rq)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	struct scatterlist *sg = hwif->sg_table;
 
 	ide_map_sg(drive, rq);
@@ -193,7 +194,7 @@ int ide_build_sglist(ide_drive_t *drive,
 	else
 		hwif->sg_dma_direction = PCI_DMA_TODEVICE;
 
-	return pci_map_sg(hwif->pci_dev, sg, hwif->sg_nents, hwif->sg_dma_direction);
+	return pci_map_sg(pdev, sg, hwif->sg_nents, hwif->sg_dma_direction);
 }
 
 EXPORT_SYMBOL_GPL(ide_build_sglist);
@@ -306,11 +307,11 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
  
 void ide_destroy_dmatable (ide_drive_t *drive)
 {
-	struct pci_dev *dev = HWIF(drive)->pci_dev;
-	struct scatterlist *sg = HWIF(drive)->sg_table;
-	int nents = HWIF(drive)->sg_nents;
+	ide_hwif_t *hwif = drive->hwif;
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 
-	pci_unmap_sg(dev, sg, nents, HWIF(drive)->sg_dma_direction);
+	pci_unmap_sg(pdev, hwif->sg_table, hwif->sg_nents,
+		     hwif->sg_dma_direction);
 }
 
 EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
@@ -845,10 +846,10 @@ EXPORT_SYMBOL(ide_dma_timeout);
 static void ide_release_dma_engine(ide_hwif_t *hwif)
 {
 	if (hwif->dmatable_cpu) {
-		pci_free_consistent(hwif->pci_dev,
-				    PRD_ENTRIES * PRD_BYTES,
-				    hwif->dmatable_cpu,
-				    hwif->dmatable_dma);
+		struct pci_dev *pdev = to_pci_dev(hwif->dev);
+
+		pci_free_consistent(pdev, PRD_ENTRIES * PRD_BYTES,
+				    hwif->dmatable_cpu, hwif->dmatable_dma);
 		hwif->dmatable_cpu = NULL;
 	}
 }
@@ -876,7 +877,9 @@ int ide_release_dma(ide_hwif_t *hwif)
 
 static int ide_allocate_dma_engine(ide_hwif_t *hwif)
 {
-	hwif->dmatable_cpu = pci_alloc_consistent(hwif->pci_dev,
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
+
+	hwif->dmatable_cpu = pci_alloc_consistent(pdev,
 						  PRD_ENTRIES * PRD_BYTES,
 						  &hwif->dmatable_dma);
 
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -358,8 +358,10 @@ void ide_toggle_bounce(ide_drive_t *driv
 	if (!PCI_DMA_BUS_IS_PHYS) {
 		addr = BLK_BOUNCE_ANY;
 	} else if (on && drive->media == ide_disk) {
-		if (HWIF(drive)->pci_dev)
-			addr = HWIF(drive)->pci_dev->dma_mask;
+		struct device *dev = drive->hwif->dev;
+
+		if (dev && dev->dma_mask)
+			addr = *dev->dma_mask;
 	}
 
 	if (drive->queue)
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -622,8 +622,8 @@ static void hwif_register (ide_hwif_t *h
 	strlcpy(hwif->gendev.bus_id,hwif->name,BUS_ID_SIZE);
 	hwif->gendev.driver_data = hwif;
 	if (hwif->gendev.parent == NULL) {
-		if (hwif->pci_dev)
-			hwif->gendev.parent = &hwif->pci_dev->dev;
+		if (hwif->dev)
+			hwif->gendev.parent = hwif->dev;
 		else
 			/* Would like to do = &device_legacy */
 			hwif->gendev.parent = NULL;
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -405,8 +405,9 @@ static void ide_hwif_restore(ide_hwif_t 
 	hwif->chipset			= tmp_hwif->chipset;
 	hwif->hold			= tmp_hwif->hold;
 
+	hwif->dev			= tmp_hwif->dev;
+
 #ifdef CONFIG_BLK_DEV_IDEPCI
-	hwif->pci_dev			= tmp_hwif->pci_dev;
 	hwif->cds			= tmp_hwif->cds;
 #endif
 
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -90,7 +90,7 @@ static u8 pci_bus_clock_list_ultra (u8 s
 static void aec6210_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u16 d_conf		= 0;
 	u8 ultra = 0, ultra_conf = 0;
 	u8 tmp0 = 0, tmp1 = 0, tmp2 = 0;
@@ -116,7 +116,7 @@ static void aec6210_set_mode(ide_drive_t
 static void aec6260_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 unit		= (drive->select.b.unit & 0x01);
 	u8 tmp1 = 0, tmp2 = 0;
 	u8 ultra = 0, drive_conf = 0, ultra_conf = 0;
@@ -170,7 +170,7 @@ static unsigned int __devinit init_chips
 
 static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
 	hwif->set_pio_mode = &aec_set_pio_mode;
 
@@ -188,7 +188,7 @@ static void __devinit init_hwif_aec62xx(
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
 		u8 ata66 = 0, mask = hwif->channel ? 0x02 : 0x01;
 
-		pci_read_config_byte(hwif->pci_dev, 0x49, &ata66);
+		pci_read_config_byte(dev, 0x49, &ata66);
 
 		hwif->cbl = (ata66 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 	}
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -293,7 +293,7 @@ static int ali_get_info (char *buffer, c
 static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	int s_time, a_time, c_time;
 	u8 s_clc, a_clc, r_clc;
 	unsigned long flags;
@@ -396,7 +396,7 @@ static u8 ali_udma_filter(ide_drive_t *d
 static void ali_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 speed1		= speed;
 	u8 unit			= (drive->select.b.unit & 0x01);
 	u8 tmpbyte		= 0x00;
@@ -625,7 +625,7 @@ static int ali_cable_override(struct pci
 
 static u8 __devinit ata66_ali15x3(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long flags;
 	u8 cbl = ATA_CBL_PATA40, tmpbyte;
 
@@ -688,12 +688,13 @@ static void __devinit init_hwif_common_a
 
 static void __devinit init_hwif_ali15x3 (ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 ideic, inmir;
 	s8 irq_routing_table[] = { -1,  9, 3, 10, 4,  5, 7,  6,
 				      1, 11, 0, 12, 0, 14, 0, 15 };
 	int irq = -1;
 
-	if (hwif->pci_dev->device == PCI_DEVICE_ID_AL_M5229)
+	if (dev->device == PCI_DEVICE_ID_AL_M5229)
 		hwif->irq = hwif->channel ? 15 : 14;
 
 	if (isa_dev) {
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -86,6 +86,7 @@ static void amd_set_speed(struct pci_dev
 static void amd_set_drive(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	ide_drive_t *peer = hwif->drives + (~drive->dn & 1);
 	struct ide_timing t, p;
 	int T, UT;
@@ -104,7 +105,7 @@ static void amd_set_drive(ide_drive_t *d
 	if (speed == XFER_UDMA_5 && amd_clock <= 33333) t.udma = 1;
 	if (speed == XFER_UDMA_6 && amd_clock <= 33333) t.udma = 15;
 
-	amd_set_speed(hwif->pci_dev, drive->dn, udma_mask, &t);
+	amd_set_speed(dev, drive->dn, udma_mask, &t);
 }
 
 /*
@@ -202,8 +203,10 @@ static unsigned int __devinit init_chips
 
 static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+
 	if (hwif->irq == 0) /* 0 is bogus but will do for now */
-		hwif->irq = pci_get_legacy_ide_irq(hwif->pci_dev, hwif->channel);
+		hwif->irq = pci_get_legacy_ide_irq(dev, hwif->channel);
 
 	hwif->set_pio_mode = &amd_set_pio_mode;
 	hwif->set_dma_mode = &amd_set_drive;
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -55,7 +55,7 @@ static DEFINE_SPINLOCK(atiixp_lock);
 
 static void atiixp_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	struct pci_dev *dev = drive->hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	unsigned long flags;
 	int timing_shift = (drive->dn & 2) ? 16 : 0 + (drive->dn & 1) ? 0 : 8;
 	u32 pio_timing_data;
@@ -88,7 +88,7 @@ static void atiixp_set_pio_mode(ide_driv
 
 static void atiixp_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	struct pci_dev *dev = drive->hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	unsigned long flags;
 	int timing_shift = (drive->dn & 2) ? 16 : 0 + (drive->dn & 1) ? 0 : 8;
 	u32 tmp32;
@@ -133,9 +133,8 @@ static void atiixp_set_dma_mode(ide_driv
 
 static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 {
-	u8 udma_mode = 0;
-	u8 ch = hwif->channel;
-	struct pci_dev *pdev = hwif->pci_dev;
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
+	u8 udma_mode = 0, ch = hwif->channel;
 
 	hwif->set_pio_mode = &atiixp_set_pio_mode;
 	hwif->set_dma_mode = &atiixp_set_dma_mode;
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -71,7 +71,7 @@ static u8 quantize_timing(int timing, in
  */
 static void program_cycle_times (ide_drive_t *drive, int cycle_time, int active_time)
 {
-	struct pci_dev *dev	= HWIF(drive)->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(drive->hwif->dev);
 	int clock_time		= 1000 / system_bus_clock();
 	u8  cycle_count, active_count, recovery_count, drwtim;
 	static const u8 recovery_values[] =
@@ -118,7 +118,7 @@ static void program_cycle_times (ide_dri
 static void cmd64x_tune_pio(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	unsigned int cycle_time;
 	u8 setup_count, arttim = 0;
 
@@ -183,7 +183,7 @@ static void cmd64x_set_pio_mode(ide_driv
 static void cmd64x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 unit			= drive->dn & 0x01;
 	u8 regU = 0, pciU	= hwif->channel ? UDIDETCR1 : UDIDETCR0;
 
@@ -245,7 +245,7 @@ static int cmd648_ide_dma_end (ide_drive
 static int cmd64x_ide_dma_end (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
 	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
 						  CFR_INTR_CH0;
@@ -285,7 +285,7 @@ static int cmd648_ide_dma_test_irq (ide_
 static int cmd64x_ide_dma_test_irq (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
 	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
 						  CFR_INTR_CH0;
@@ -375,7 +375,7 @@ static unsigned int __devinit init_chips
 
 static u8 __devinit ata66_cmd64x(ide_hwif_t *hwif)
 {
-	struct pci_dev  *dev	= hwif->pci_dev;
+	struct pci_dev  *dev	= to_pci_dev(hwif->dev);
 	u8 bmidecsr = 0, mask	= hwif->channel ? 0x02 : 0x01;
 
 	switch (dev->device) {
@@ -390,7 +390,7 @@ static u8 __devinit ata66_cmd64x(ide_hwi
 
 static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
 	hwif->set_pio_mode = &cmd64x_set_pio_mode;
 	hwif->set_dma_mode = &cmd64x_set_dma_mode;
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -69,7 +69,7 @@ static struct pio_clocks cs5520_pio_cloc
 static void cs5520_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct pci_dev *pdev = hwif->pci_dev;
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	int controller = drive->dn > 1 ? 1 : 0;
 
 	/* FIXME: if DMA = 1 do we need to set the DMA bit here ? */
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -177,13 +177,15 @@ static u8 __devinit cs5535_cable_detect(
  */
 static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+
 	hwif->set_pio_mode = &cs5535_set_pio_mode;
 	hwif->set_dma_mode = &cs5535_set_dma_mode;
 
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->cbl = cs5535_cable_detect(hwif->pci_dev);
+	hwif->cbl = cs5535_cable_detect(dev);
 }
 
 static const struct ide_port_info cs5535_chipset __devinitdata = {
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -228,7 +228,7 @@ static void cy82c693_set_dma_mode(ide_dr
 static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	pio_clocks_t pclk;
 	unsigned int addrCtrl;
 
@@ -397,8 +397,9 @@ static void __devinit init_hwif_cy82c693
 static void __devinit init_iops_cy82c693(ide_hwif_t *hwif)
 {
 	static ide_hwif_t *primary;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
-	if (PCI_FUNC(hwif->pci_dev->devfn) == 1)
+	if (PCI_FUNC(dev->devfn) == 1)
 		primary = hwif;
 	else {
 		hwif->mate = primary;
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -87,7 +87,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 		return -ENODEV;
 	}
 	pci_set_drvdata(dev, hwif);
-	hwif->pci_dev = dev;
+	hwif->dev = &dev->dev;
 	drive = &hwif->drives[0];
 	if (drive->present) {
 		drive->io_32bit = 1;
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -45,7 +45,7 @@
 
 static void hpt34x_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	struct pci_dev *dev	= HWIF(drive)->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u32 reg1= 0, tmp1 = 0, reg2 = 0, tmp2 = 0;
 	u8			hi_speed, lo_speed;
 
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -626,7 +626,8 @@ static int check_in_drive_list(ide_drive
 static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct hpt_info *info	= pci_get_drvdata(hwif->pci_dev);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	struct hpt_info *info	= pci_get_drvdata(dev);
 	u8 mask 		= hwif->ultra_mask;
 
 	switch (info->chip_type) {
@@ -665,7 +666,8 @@ static u8 hpt3xx_udma_filter(ide_drive_t
 static u8 hpt3xx_mdma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct hpt_info *info	= pci_get_drvdata(hwif->pci_dev);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	struct hpt_info *info	= pci_get_drvdata(dev);
 
 	switch (info->chip_type) {
 	case HPT372 :
@@ -699,7 +701,7 @@ static u32 get_speed_setting(u8 speed, s
 
 static void hpt3xx_set_mode(ide_drive_t *drive, const u8 speed)
 {
-	struct pci_dev  *dev	= HWIF(drive)->pci_dev;
+	struct pci_dev  *dev	= to_pci_dev(drive->hwif->dev);
 	struct hpt_info	*info	= pci_get_drvdata(dev);
 	struct hpt_timings *t	= info->timings;
 	u8  itr_addr		= 0x40 + (drive->dn * 4);
@@ -742,7 +744,7 @@ static void hpt3xx_quirkproc(ide_drive_t
 static void hpt3xx_maskproc(ide_drive_t *drive, int mask)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev	*dev	= hwif->pci_dev;
+	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= pci_get_drvdata(dev);
 
 	if (drive->quirk_list) {
@@ -774,7 +776,7 @@ static void hpt3xx_maskproc(ide_drive_t 
  */
 static void hpt366_dma_lost_irq(ide_drive_t *drive)
 {
-	struct pci_dev *dev = HWIF(drive)->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u8 mcr1 = 0, mcr3 = 0, scr1 = 0;
 
 	pci_read_config_byte(dev, 0x50, &mcr1);
@@ -790,18 +792,20 @@ static void hpt366_dma_lost_irq(ide_driv
 static void hpt370_clear_engine(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
-	pci_write_config_byte(hwif->pci_dev, hwif->select_data, 0x37);
+	pci_write_config_byte(dev, hwif->select_data, 0x37);
 	udelay(10);
 }
 
 static void hpt370_irq_timeout(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u16 bfifo		= 0;
 	u8  dma_cmd;
 
-	pci_read_config_word(hwif->pci_dev, hwif->select_data + 2, &bfifo);
+	pci_read_config_word(dev, hwif->select_data + 2, &bfifo);
 	printk(KERN_DEBUG "%s: %d bytes in FIFO\n", drive->name, bfifo & 0x1ff);
 
 	/* get DMA command mode */
@@ -844,10 +848,11 @@ static void hpt370_dma_timeout(ide_drive
 static int hpt374_ide_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u16 bfifo		= 0;
 	u8  dma_stat;
 
-	pci_read_config_word(hwif->pci_dev, hwif->select_data + 2, &bfifo);
+	pci_read_config_word(dev, hwif->select_data + 2, &bfifo);
 	if (bfifo & 0x1FF) {
 //		printk("%s: %d bytes in FIFO\n", drive->name, bfifo);
 		return 0;
@@ -867,7 +872,7 @@ static int hpt374_ide_dma_test_irq(ide_d
 static int hpt374_ide_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev	*dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 mcr	= 0, mcr_addr	= hwif->select_data;
 	u8 bwsr = 0, mask	= hwif->channel ? 0x02 : 0x01;
 
@@ -942,7 +947,7 @@ static void hpt3xxn_rw_disk(ide_drive_t 
 static int hpt3xx_busproc(ide_drive_t *drive, int state)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8  mcr_addr		= hwif->select_data + 2;
 	u8  resetmask		= hwif->channel ? 0x80 : 0x40;
 	u8  bsr2		= 0;
@@ -1278,7 +1283,7 @@ static unsigned int __devinit init_chips
 
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
-	struct pci_dev	*dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= pci_get_drvdata(dev);
 	int serialize		= HPT_SERIALIZE_IO;
 	u8  scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
@@ -1393,7 +1398,7 @@ static void __devinit init_hwif_hpt366(i
 
 static void __devinit init_dma_hpt366(ide_hwif_t *hwif, unsigned long dmabase)
 {
-	struct pci_dev	*dev		= hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 masterdma	= 0, slavedma	= 0;
 	u8 dma_new	= 0, dma_old	= 0;
 	unsigned long flags;
Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -28,7 +28,7 @@
 static void it8213_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int is_slave		= drive->dn & 1;
 	int master_port		= 0x40;
 	int slave_port		= 0x44;
@@ -85,7 +85,7 @@ static void it8213_set_pio_mode(ide_driv
 static void it8213_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 maslave		= 0x40;
 	int a_speed		= 3 << (drive->dn * 4);
 	int u_flag		= 1 << drive->dn;
@@ -152,6 +152,7 @@ static void it8213_set_dma_mode(ide_driv
 
 static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 reg42h = 0;
 
 	hwif->set_dma_mode = &it8213_set_dma_mode;
@@ -160,7 +161,7 @@ static void __devinit init_hwif_it8213(i
 	if (!hwif->dma_base)
 		return;
 
-	pci_read_config_byte(hwif->pci_dev, 0x42, &reg42h);
+	pci_read_config_byte(dev, 0x42, &reg42h);
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		hwif->cbl = (reg42h & 0x02) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -113,7 +113,8 @@ static int it8212_noraid;
 
 static void it821x_program(ide_drive_t *drive, u16 timing)
 {
-	ide_hwif_t *hwif	= drive->hwif;
+	ide_hwif_t *hwif = drive->hwif;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
 	int channel = hwif->channel;
 	u8 conf;
@@ -123,7 +124,8 @@ static void it821x_program(ide_drive_t *
 		conf = timing >> 8;
 	else
 		conf = timing & 0xFF;
-	pci_write_config_byte(hwif->pci_dev, 0x54 + 4 * channel, conf);
+
+	pci_write_config_byte(dev, 0x54 + 4 * channel, conf);
 }
 
 /**
@@ -137,7 +139,8 @@ static void it821x_program(ide_drive_t *
 
 static void it821x_program_udma(ide_drive_t *drive, u16 timing)
 {
-	ide_hwif_t *hwif	= drive->hwif;
+	ide_hwif_t *hwif = drive->hwif;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
 	int channel = hwif->channel;
 	int unit = drive->select.b.unit;
@@ -148,11 +151,12 @@ static void it821x_program_udma(ide_driv
 		conf = timing >> 8;
 	else
 		conf = timing & 0xFF;
-	if(itdev->timing10 == 0)
-		pci_write_config_byte(hwif->pci_dev, 0x56 + 4 * channel + unit, conf);
+
+	if (itdev->timing10 == 0)
+		pci_write_config_byte(dev, 0x56 + 4 * channel + unit, conf);
 	else {
-		pci_write_config_byte(hwif->pci_dev, 0x56 + 4 * channel, conf);
-		pci_write_config_byte(hwif->pci_dev, 0x56 + 4 * channel + 1, conf);
+		pci_write_config_byte(dev, 0x56 + 4 * channel, conf);
+		pci_write_config_byte(dev, 0x56 + 4 * channel + 1, conf);
 	}
 }
 
@@ -167,6 +171,7 @@ static void it821x_program_udma(ide_driv
 static void it821x_clock_strategy(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
 
 	u8 unit = drive->select.b.unit;
@@ -205,10 +210,11 @@ static void it821x_clock_strategy(ide_dr
 		itdev->clock_mode = ATA_50;
 		sel = 1;
 	}
-	pci_read_config_byte(hwif->pci_dev, 0x50, &v);
+
+	pci_read_config_byte(dev, 0x50, &v);
 	v &= ~(1 << (1 + hwif->channel));
 	v |= sel << (1 + hwif->channel);
-	pci_write_config_byte(hwif->pci_dev, 0x50, v);
+	pci_write_config_byte(dev, 0x50, v);
 
 	/*
 	 *	Reprogram the UDMA/PIO of the pair drive for the switch
@@ -282,7 +288,8 @@ static void it821x_set_pio_mode(ide_driv
 
 static void it821x_tune_mwdma (ide_drive_t *drive, byte mode_wanted)
 {
-	ide_hwif_t *hwif	= drive->hwif;
+	ide_hwif_t *hwif = drive->hwif;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = (void *)ide_get_hwifdata(hwif);
 	int unit = drive->select.b.unit;
 	int channel = hwif->channel;
@@ -297,12 +304,12 @@ static void it821x_tune_mwdma (ide_drive
 	itdev->udma[unit] = UDMA_OFF;
 
 	/* UDMA bits off - Revision 0x10 do them in pairs */
-	pci_read_config_byte(hwif->pci_dev, 0x50, &conf);
-	if(itdev->timing10)
+	pci_read_config_byte(dev, 0x50, &conf);
+	if (itdev->timing10)
 		conf |= channel ? 0x60: 0x18;
 	else
 		conf |= 1 << (3 + 2 * channel + unit);
-	pci_write_config_byte(hwif->pci_dev, 0x50, conf);
+	pci_write_config_byte(dev, 0x50, conf);
 
 	it821x_clock_strategy(drive);
 	/* FIXME: do we need to program this ? */
@@ -320,7 +327,8 @@ static void it821x_tune_mwdma (ide_drive
 
 static void it821x_tune_udma (ide_drive_t *drive, byte mode_wanted)
 {
-	ide_hwif_t *hwif	= drive->hwif;
+	ide_hwif_t *hwif = drive->hwif;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
 	int unit = drive->select.b.unit;
 	int channel = hwif->channel;
@@ -337,12 +345,12 @@ static void it821x_tune_udma (ide_drive_
 		itdev->udma[unit] |= 0x8080;	/* UDMA 5/6 select on */
 
 	/* UDMA on. Again revision 0x10 must do the pair */
-	pci_read_config_byte(hwif->pci_dev, 0x50, &conf);
-	if(itdev->timing10)
+	pci_read_config_byte(dev, 0x50, &conf);
+	if (itdev->timing10)
 		conf &= channel ? 0x9F: 0xE7;
 	else
 		conf &= ~ (1 << (3 + 2 * channel + unit));
-	pci_write_config_byte(hwif->pci_dev, 0x50, conf);
+	pci_write_config_byte(dev, 0x50, conf);
 
 	it821x_clock_strategy(drive);
 	it821x_program_udma(drive, itdev->udma[unit]);
@@ -520,6 +528,7 @@ static void __devinit it821x_quirkproc(i
 
 static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *idev = kzalloc(sizeof(struct it821x_dev), GFP_KERNEL);
 	u8 conf;
 
@@ -532,7 +541,7 @@ static void __devinit init_hwif_it821x(i
 
 	ide_set_hwifdata(hwif, idev);
 
-	pci_read_config_byte(hwif->pci_dev, 0x50, &conf);
+	pci_read_config_byte(dev, 0x50, &conf);
 	if (conf & 1) {
 		idev->smart = 1;
 		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
@@ -555,7 +564,7 @@ static void __devinit init_hwif_it821x(i
 	 *	this is necessary.
 	 */
 
-	pci_read_config_byte(hwif->pci_dev, 0x08, &conf);
+	pci_read_config_byte(dev, 0x08, &conf);
 	if (conf == 0x10) {
 		idev->timing10 = 1;
 		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -30,7 +30,7 @@ typedef enum {
 
 static u8 __devinit ata66_jmicron(ide_hwif_t *hwif)
 {
-	struct pci_dev *pdev = hwif->pci_dev;
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 
 	u32 control;
 	u32 control5;
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -71,10 +71,9 @@ static u8 superio_ide_inb (unsigned long
 
 static void __devinit superio_ide_init_iops (struct hwif_s *hwif)
 {
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	u32 base, dmabase;
-	u8 tmp;
-	struct pci_dev *pdev = hwif->pci_dev;
-	u8 port = hwif->channel;
+	u8 port = hwif->channel, tmp;
 
 	base = pci_resource_start(pdev, port * 2) & ~3;
 	dmabase = pci_resource_start(pdev, 4) & ~3;
@@ -93,10 +92,11 @@ static void __devinit superio_ide_init_i
 
 static void __devinit init_iops_ns87415(ide_hwif_t *hwif)
 {
-	if (PCI_SLOT(hwif->pci_dev->devfn) == 0xE) {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+
+	if (PCI_SLOT(dev->devfn) == 0xE)
 		/* Built-in - assume it's under superio. */
 		superio_ide_init_iops(hwif);
-	}
 }
 #endif
 
@@ -110,8 +110,8 @@ static unsigned int ns87415_count = 0, n
 static void ns87415_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned int bit, other, new, *old = (unsigned int *) hwif->select_data;
-	struct pci_dev *dev = hwif->pci_dev;
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -189,7 +189,7 @@ static int ns87415_ide_dma_setup(ide_dri
 
 static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned int ctrl, using_inta;
 	u8 progif;
 #ifdef __sparc_v9__
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -149,6 +149,7 @@ static struct udma_timing {
 static void pdcnew_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 adj			= (drive->dn & 1) ? 0x08 : 0x00;
 
 	/*
@@ -159,7 +160,7 @@ static void pdcnew_set_dma_mode(ide_driv
 	 * As we set up the PLL to output 133 MHz for UltraDMA/133 capable
 	 * chips, we must override the default register settings...
 	 */
-	if (max_dma_rate(hwif->pci_dev) == 4) {
+	if (max_dma_rate(dev) == 4) {
 		u8 mode = speed & 0x07;
 
 		if (speed >= XFER_UDMA_0) {
@@ -186,9 +187,10 @@ static void pdcnew_set_dma_mode(ide_driv
 static void pdcnew_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 adj = (drive->dn & 1) ? 0x08 : 0x00;
 
-	if (max_dma_rate(hwif->pci_dev) == 4) {
+	if (max_dma_rate(dev) == 4) {
 		set_indexed_reg(hwif, 0x0c + adj, pio_timings[pio].reg0c);
 		set_indexed_reg(hwif, 0x0d + adj, pio_timings[pio].reg0d);
 		set_indexed_reg(hwif, 0x13 + adj, pio_timings[pio].reg13);
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -66,7 +66,7 @@ static void pdc_old_disable_66MHz_clock(
 static void pdc202xx_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 drive_pci		= 0x60 + (drive->dn << 2);
 
 	u8			AP = 0, BP = 0, CP = 0;
@@ -144,9 +144,10 @@ static void pdc202xx_set_pio_mode(ide_dr
 
 static u8 pdc202xx_old_cable_detect (ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u16 CIS = 0, mask = (hwif->channel) ? (1<<11) : (1<<10);
 
-	pci_read_config_word(hwif->pci_dev, 0x50, &CIS);
+	pci_read_config_word(dev, 0x50, &CIS);
 
 	return (CIS & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 }
@@ -305,12 +306,14 @@ static unsigned int __devinit init_chips
 
 static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+
 	hwif->set_pio_mode = &pdc202xx_set_pio_mode;
 	hwif->set_dma_mode = &pdc202xx_set_mode;
 
 	hwif->quirkproc = &pdc202xx_quirkproc;
 
-	if (hwif->pci_dev->device != PCI_DEVICE_ID_PROMISE_20246)
+	if (dev->device != PCI_DEVICE_ID_PROMISE_20246)
 		hwif->resetproc = &pdc202xx_reset;
 
 	if (hwif->dma_base == 0)
@@ -319,7 +322,7 @@ static void __devinit init_hwif_pdc202xx
 	hwif->dma_lost_irq = &pdc202xx_dma_lost_irq;
 	hwif->dma_timeout = &pdc202xx_dma_timeout;
 
-	if (hwif->pci_dev->device != PCI_DEVICE_ID_PROMISE_20246) {
+	if (dev->device != PCI_DEVICE_ID_PROMISE_20246) {
 		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 			hwif->cbl = pdc202xx_old_cable_detect(hwif);
 
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -71,7 +71,7 @@ static int no_piix_dma;
 static void piix_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int is_slave		= drive->dn & 1;
 	int master_port		= hwif->channel ? 0x42 : 0x40;
 	int slave_port		= 0x44;
@@ -140,7 +140,7 @@ static void piix_set_pio_mode(ide_drive_
 static void piix_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 maslave		= hwif->channel ? 0x42 : 0x40;
 	int a_speed		= 3 << (drive->dn * 4);
 	int u_flag		= 1 << drive->dn;
@@ -260,7 +260,7 @@ static const struct ich_laptop ich_lapto
 
 static u8 __devinit piix_cable_detect(ide_hwif_t *hwif)
 {
-	struct pci_dev *pdev = hwif->pci_dev;
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	const struct ich_laptop *lap = &ich_laptop[0];
 	u8 reg54h = 0, mask = hwif->channel ? 0xc0 : 0x30;
 
Index: b/drivers/ide/pci/rz1000.c
===================================================================
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -32,8 +32,8 @@
 
 static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u16 reg;
-	struct pci_dev *dev = hwif->pci_dev;
 
 	if (!pci_read_config_word (dev, 0x40, &reg) &&
 	    !pci_write_config_word(dev, 0x40, reg & 0xdfff)) {
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -87,7 +87,7 @@ static const unsigned int sc1200_pio_tim
 static void sc1200_tunepio(ide_drive_t *drive, u8 pio)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct pci_dev *pdev = hwif->pci_dev;
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	unsigned int basereg = hwif->channel ? 0x50 : 0x40, format = 0;
 
 	pci_read_config_dword(pdev, basereg + 4, &format);
@@ -130,6 +130,7 @@ out:
 static void sc1200_set_dma_mode(ide_drive_t *drive, const u8 mode)
 {
 	ide_hwif_t		*hwif = HWIF(drive);
+	struct pci_dev		*dev = to_pci_dev(hwif->dev);
 	int			unit = drive->select.b.unit;
 	unsigned int		reg, timings;
 	unsigned short		pci_clock;
@@ -160,12 +161,11 @@ static void sc1200_set_dma_mode(ide_driv
 		timings = mwdma_timing[pci_clock][mode - XFER_MW_DMA_0];
 
 	if (unit == 0) {			/* are we configuring drive0? */
-		pci_read_config_dword(hwif->pci_dev, basereg+4, &reg);
+		pci_read_config_dword(dev, basereg + 4, &reg);
 		timings |= reg & 0x80000000;	/* preserve PIO format bit */
-		pci_write_config_dword(hwif->pci_dev, basereg+4, timings);
-	} else {
-		pci_write_config_dword(hwif->pci_dev, basereg+12, timings);
-	}
+		pci_write_config_dword(dev, basereg + 4, timings);
+	} else
+		pci_write_config_dword(dev, basereg + 12, timings);
 }
 
 /*  Replacement for the standard ide_dma_end action in
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -594,7 +594,7 @@ static int __devinit init_setup_scc(stru
 
 static void __devinit init_mmio_iops_scc(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct scc_ports *ports = pci_get_drvdata(dev);
 	unsigned long dma_base = ports->dma;
 
@@ -620,7 +620,7 @@ static void __devinit init_mmio_iops_scc
 	hwif->io_ports[IDE_STATUS_OFFSET] = dma_base + 0x3c;
 	hwif->io_ports[IDE_CONTROL_OFFSET] = dma_base + 0x40;
 
-	hwif->irq = hwif->pci_dev->irq;
+	hwif->irq = dev->irq;
 	hwif->dma_base = dma_base;
 	hwif->config_data = ports->ctl;
 	hwif->mmio = 1;
@@ -636,7 +636,8 @@ static void __devinit init_mmio_iops_scc
 
 static void __devinit init_iops_scc(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev =  hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+
 	hwif->hwif_data = NULL;
 	if (pci_get_drvdata(dev) == NULL)
 		return;
@@ -726,10 +727,8 @@ static void __devexit scc_remove(struct 
 	unsigned long dma_size = pci_resource_len(dev, 1);
 
 	if (hwif->dmatable_cpu) {
-		pci_free_consistent(hwif->pci_dev,
-				    PRD_ENTRIES * PRD_BYTES,
-				    hwif->dmatable_cpu,
-				    hwif->dmatable_dma);
+		pci_free_consistent(dev, PRD_ENTRIES * PRD_BYTES,
+				    hwif->dmatable_cpu, hwif->dmatable_dma);
 		hwif->dmatable_cpu = NULL;
 	}
 
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -67,7 +67,7 @@ static int check_in_drive_lists (ide_dri
 
 static u8 svwks_udma_filter(ide_drive_t *drive)
 {
-	struct pci_dev *dev     = HWIF(drive)->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u8 mask = 0;
 
 	if (dev->device == PCI_DEVICE_ID_SERVERWORKS_HT1000IDE)
@@ -130,7 +130,7 @@ static void svwks_set_pio_mode(ide_drive
 	static const u8 pio_modes[] = { 0x5d, 0x47, 0x34, 0x22, 0x20 };
 	static const u8 drive_pci[] = { 0x41, 0x40, 0x43, 0x42 };
 
-	struct pci_dev *dev = drive->hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 
 	pci_write_config_byte(dev, drive_pci[drive->dn], pio_modes[pio]);
 
@@ -153,7 +153,7 @@ static void svwks_set_dma_mode(ide_drive
 	static const u8 drive_pci2[]		= { 0x45, 0x44, 0x47, 0x46 };
 
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 unit			= (drive->select.b.unit & 0x01);
 
 	u8 ultra_enable	 = 0, ultra_timing = 0, dma_timing = 0;
@@ -287,7 +287,8 @@ static u8 __devinit ata66_svwks_svwks(id
  */
 static u8 __devinit ata66_svwks_dell(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+
 	if (dev->subsystem_vendor == PCI_VENDOR_ID_DELL &&
 	    dev->vendor	== PCI_VENDOR_ID_SERVERWORKS &&
 	    (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE ||
@@ -305,7 +306,8 @@ static u8 __devinit ata66_svwks_dell(ide
  */
 static u8 __devinit ata66_svwks_cobalt(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+
 	if (dev->subsystem_vendor == PCI_VENDOR_ID_SUN &&
 	    dev->vendor	== PCI_VENDOR_ID_SERVERWORKS &&
 	    dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE)
@@ -316,7 +318,7 @@ static u8 __devinit ata66_svwks_cobalt(i
 
 static u8 __devinit ata66_svwks(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
 	/* Server Works */
 	if (dev->subsystem_vendor == PCI_VENDOR_ID_SERVERWORKS)
@@ -340,6 +342,8 @@ static u8 __devinit ata66_svwks(ide_hwif
 
 static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+
 	hwif->set_pio_mode = &svwks_set_pio_mode;
 	hwif->set_dma_mode = &svwks_set_dma_mode;
 	hwif->udma_filter = &svwks_udma_filter;
@@ -347,7 +351,7 @@ static void __devinit init_hwif_svwks (i
 	if (!hwif->dma_base)
 		return;
 
-	if (hwif->pci_dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
+	if (dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
 		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 			hwif->cbl = ata66_svwks(hwif);
 	}
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -159,6 +159,7 @@ sgiioc4_clearirq(ide_drive_t * drive)
 		}
 
 		if (intr_reg & 0x02) {
+			struct pci_dev *dev = to_pci_dev(hwif->dev);
 			/* Error when transferring DMA data on PCI bus */
 			u32 pci_err_addr_low, pci_err_addr_high,
 			    pci_stat_cmd_reg;
@@ -167,7 +168,7 @@ sgiioc4_clearirq(ide_drive_t * drive)
 				readl((void __iomem *)hwif->io_ports[IDE_IRQ_OFFSET]);
 			pci_err_addr_high =
 				readl((void __iomem *)(hwif->io_ports[IDE_IRQ_OFFSET] + 4));
-			pci_read_config_dword(hwif->pci_dev, PCI_COMMAND,
+			pci_read_config_dword(dev, PCI_COMMAND,
 					      &pci_stat_cmd_reg);
 			printk(KERN_ERR
 			       "%s(%s) : PCI Bus Error when doing DMA:"
@@ -178,8 +179,7 @@ sgiioc4_clearirq(ide_drive_t * drive)
 			       __FUNCTION__, drive->name,
 			       pci_err_addr_high, pci_err_addr_low);
 			/* Clear the PCI Error indicator */
-			pci_write_config_dword(hwif->pci_dev, PCI_COMMAND,
-					       0x00000146);
+			pci_write_config_dword(dev, PCI_COMMAND, 0x00000146);
 		}
 
 		/* Clear the Interrupt, Error bits on the IOC4 */
@@ -334,6 +334,7 @@ sgiioc4_INB(unsigned long port)
 static int __devinit
 ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	void __iomem *virt_dma_base;
 	int num_ports = sizeof (ioc4_dma_regs_t);
 	void *pad;
@@ -359,7 +360,7 @@ ide_dma_sgiioc4(ide_hwif_t * hwif, unsig
 	}
 	hwif->dma_base = (unsigned long) virt_dma_base;
 
-	hwif->dmatable_cpu = pci_alloc_consistent(hwif->pci_dev,
+	hwif->dmatable_cpu = pci_alloc_consistent(dev,
 					  IOC4_PRD_ENTRIES * IOC4_PRD_BYTES,
 					  &hwif->dmatable_dma);
 
@@ -368,7 +369,7 @@ ide_dma_sgiioc4(ide_hwif_t * hwif, unsig
 
 	hwif->sg_max_nents = IOC4_PRD_ENTRIES;
 
-	pad = pci_alloc_consistent(hwif->pci_dev, IOC4_IDE_CACHELINE_SIZE,
+	pad = pci_alloc_consistent(dev, IOC4_IDE_CACHELINE_SIZE,
 				   (dma_addr_t *) &(hwif->dma_status));
 
 	if (pad) {
@@ -376,8 +377,7 @@ ide_dma_sgiioc4(ide_hwif_t * hwif, unsig
 		return 0;
 	}
 
-	pci_free_consistent(hwif->pci_dev,
-			    IOC4_PRD_ENTRIES * IOC4_PRD_BYTES,
+	pci_free_consistent(dev, IOC4_PRD_ENTRIES * IOC4_PRD_BYTES,
 			    hwif->dmatable_cpu, hwif->dmatable_dma);
 	printk(KERN_INFO
 	       "%s() -- Error! Unable to allocate DMA Maps for drive %s\n",
@@ -640,7 +640,7 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	hw.dev = &dev->dev;
 	ide_init_port_hw(hwif, &hw);
 
-	hwif->pci_dev = dev;
+	hwif->dev = &dev->dev;
 	hwif->channel = 0;	/* Single Channel chip */
 
 	/* The IOC4 uses MMIO rather than Port IO. */
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -79,7 +79,7 @@ static int pdev_is_sata(struct pci_dev *
  
 static inline int is_sata(ide_hwif_t *hwif)
 {
-	return pdev_is_sata(hwif->pci_dev);
+	return pdev_is_sata(to_pci_dev(hwif->dev));
 }
 
 /**
@@ -140,13 +140,14 @@ static inline unsigned long siimage_seld
 static u8 sil_pata_udma_filter(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long base = (unsigned long) hwif->hwif_data;
 	u8 mask = 0, scsc = 0;
 
 	if (hwif->mmio)
 		scsc = hwif->INB(base + 0x4A);
 	else
-		pci_read_config_byte(hwif->pci_dev, 0x8A, &scsc);
+		pci_read_config_byte(dev, 0x8A, &scsc);
 
 	if ((scsc & 0x30) == 0x10)	/* 133 */
 		mask = ATA_UDMA6;
@@ -219,19 +220,21 @@ static void sil_set_pio_mode(ide_drive_t
 		mode |= (unit ? 0x10 : 0x01);
 		hwif->OUTB(mode, base + addr_mask);
 	} else {
-		pci_write_config_word(hwif->pci_dev, addr, speedp);
-		pci_write_config_word(hwif->pci_dev, tfaddr, speedt);
-		pci_read_config_word(hwif->pci_dev, tfaddr-2, &speedp);
+		struct pci_dev *dev = to_pci_dev(hwif->dev);
+
+		pci_write_config_word(dev, addr, speedp);
+		pci_write_config_word(dev, tfaddr, speedt);
+		pci_read_config_word(dev, tfaddr - 2, &speedp);
 		speedp &= ~0x200;
 		/* Set IORDY for mode 3 or 4 */
 		if (pio > 2)
 			speedp |= 0x200;
-		pci_write_config_word(hwif->pci_dev, tfaddr-2, speedp);
+		pci_write_config_word(dev, tfaddr - 2, speedp);
 
-		pci_read_config_byte(hwif->pci_dev, addr_mask, &mode);
+		pci_read_config_byte(dev, addr_mask, &mode);
 		mode &= ~(unit ? 0x30 : 0x03);
 		mode |= (unit ? 0x10 : 0x01);
-		pci_write_config_byte(hwif->pci_dev, addr_mask, mode);
+		pci_write_config_byte(dev, addr_mask, mode);
 	}
 }
 
@@ -250,6 +253,7 @@ static void sil_set_dma_mode(ide_drive_t
 	u16 dma[]		= { 0x2208, 0x10C2, 0x10C1 };
 
 	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u16 ultra = 0, multi	= 0;
 	u8 mode = 0, unit	= drive->select.b.unit;
 	unsigned long base	= (unsigned long)hwif->hwif_data;
@@ -266,10 +270,10 @@ static void sil_set_dma_mode(ide_drive_t
 		multi = hwif->INW(ma);
 		ultra = hwif->INW(ua);
 	} else {
-		pci_read_config_byte(hwif->pci_dev, 0x8A, &scsc);
-		pci_read_config_byte(hwif->pci_dev, addr_mask, &mode);
-		pci_read_config_word(hwif->pci_dev, ma, &multi);
-		pci_read_config_word(hwif->pci_dev, ua, &ultra);
+		pci_read_config_byte(dev, 0x8A, &scsc);
+		pci_read_config_byte(dev, addr_mask, &mode);
+		pci_read_config_word(dev, ma, &multi);
+		pci_read_config_word(dev, ua, &ultra);
 	}
 
 	mode &= ~((unit) ? 0x30 : 0x03);
@@ -293,9 +297,9 @@ static void sil_set_dma_mode(ide_drive_t
 		hwif->OUTW(multi, ma);
 		hwif->OUTW(ultra, ua);
 	} else {
-		pci_write_config_byte(hwif->pci_dev, addr_mask, mode);
-		pci_write_config_word(hwif->pci_dev, ma, multi);
-		pci_write_config_word(hwif->pci_dev, ua, ultra);
+		pci_write_config_byte(dev, addr_mask, mode);
+		pci_write_config_word(dev, ma, multi);
+		pci_write_config_word(dev, ua, ultra);
 	}
 }
 
@@ -303,6 +307,7 @@ static void sil_set_dma_mode(ide_drive_t
 static int siimage_io_ide_dma_test_irq (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 dma_altstat		= 0;
 	unsigned long addr	= siimage_selreg(hwif, 1);
 
@@ -311,7 +316,7 @@ static int siimage_io_ide_dma_test_irq (
 		return 1;
 
 	/* return 1 if Device INTR asserted */
-	pci_read_config_byte(hwif->pci_dev, addr, &dma_altstat);
+	pci_read_config_byte(dev, addr, &dma_altstat);
 	if (dma_altstat & 8)
 		return 0;	//return 1;
 	return 0;
@@ -377,13 +382,14 @@ static int siimage_mmio_ide_dma_test_irq
 static int sil_sata_busproc(ide_drive_t * drive, int state)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u32 stat_config		= 0;
 	unsigned long addr	= siimage_selreg(hwif, 0);
 
 	if (hwif->mmio)
 		stat_config = readl((void __iomem *)addr);
 	else
-		pci_read_config_dword(hwif->pci_dev, addr, &stat_config);
+		pci_read_config_dword(dev, addr, &stat_config);
 
 	switch (state) {
 		case BUSSTATE_ON:
@@ -643,7 +649,7 @@ static unsigned int __devinit init_chips
 
 static void __devinit init_mmio_iops_siimage(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	void *addr		= pci_get_drvdata(dev);
 	u8 ch			= hwif->channel;
 	hw_regs_t		hw;
@@ -756,12 +762,14 @@ static void __devinit sil_quirkproc(ide_
 
 static void __devinit init_iops_siimage(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+
 	hwif->hwif_data = NULL;
 
 	/* Pessimal until we finish probing */
 	hwif->rqsize = 15;
 
-	if (pci_get_drvdata(hwif->pci_dev) == NULL)
+	if (pci_get_drvdata(dev) == NULL)
 		return;
 
 	init_mmio_iops_siimage(hwif);
@@ -777,11 +785,12 @@ static void __devinit init_iops_siimage(
 
 static u8 __devinit ata66_siimage(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned long addr = siimage_selreg(hwif, 0);
 	u8 ata66 = 0;
 
-	if (pci_get_drvdata(hwif->pci_dev) == NULL)
-		pci_read_config_byte(hwif->pci_dev, addr, &ata66);
+	if (pci_get_drvdata(dev) == NULL)
+		pci_read_config_byte(dev, addr, &ata66);
 	else
 		ata66 = hwif->INB(addr);
 
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -197,7 +197,7 @@ static char* chipset_capability[] = {
 
 static u8 sis_ata133_get_base(ide_drive_t *drive)
 {
-	struct pci_dev *dev = drive->hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u32 reg54 = 0;
 
 	pci_read_config_dword(dev, 0x54, &reg54);
@@ -207,7 +207,7 @@ static u8 sis_ata133_get_base(ide_drive_
 
 static void sis_ata16_program_timings(ide_drive_t *drive, const u8 mode)
 {
-	struct pci_dev *dev = drive->hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u16 t1 = 0;
 	u8 drive_pci = 0x40 + drive->dn * 2;
 
@@ -230,7 +230,7 @@ static void sis_ata16_program_timings(id
 
 static void sis_ata100_program_timings(ide_drive_t *drive, const u8 mode)
 {
-	struct pci_dev *dev = drive->hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u8 t1, drive_pci = 0x40 + drive->dn * 2;
 
 	/* timing bits: 7:4 active 3:0 recovery */
@@ -253,7 +253,7 @@ static void sis_ata100_program_timings(i
 
 static void sis_ata133_program_timings(ide_drive_t *drive, const u8 mode)
 {
-	struct pci_dev *dev = drive->hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u32 t1 = 0;
 	u8 drive_pci = sis_ata133_get_base(drive), clk, idx;
 
@@ -286,7 +286,7 @@ static void sis_program_timings(ide_driv
 static void config_drive_art_rwp (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 reg4bh		= 0;
 	u8 rw_prefetch		= 0;
 
@@ -307,7 +307,7 @@ static void sis_set_pio_mode(ide_drive_t
 
 static void sis_ata133_program_udma_timings(ide_drive_t *drive, const u8 mode)
 {
-	struct pci_dev *dev = drive->hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u32 regdw = 0;
 	u8 drive_pci = sis_ata133_get_base(drive), clk, idx;
 
@@ -326,7 +326,7 @@ static void sis_ata133_program_udma_timi
 
 static void sis_ata33_program_udma_timings(ide_drive_t *drive, const u8 mode)
 {
-	struct pci_dev *dev = drive->hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u8 drive_pci = 0x40 + drive->dn * 2, reg = 0, i = chipset_family;
 
 	pci_read_config_byte(dev, drive_pci + 1, &reg);
@@ -359,7 +359,7 @@ static void sis_set_dma_mode(ide_drive_t
 
 static u8 sis5513_ata133_udma_filter(ide_drive_t *drive)
 {
-	struct pci_dev *dev = drive->hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u32 regdw = 0;
 	u8 drive_pci = sis_ata133_get_base(drive);
 
@@ -530,7 +530,7 @@ static const struct sis_laptop sis_lapto
 
 static u8 __devinit ata66_sis5513(ide_hwif_t *hwif)
 {
-	struct pci_dev *pdev = hwif->pci_dev;
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	const struct sis_laptop *lap = &sis_laptop[0];
 	u8 ata66 = 0;
 
@@ -545,12 +545,12 @@ static u8 __devinit ata66_sis5513(ide_hw
 	if (chipset_family >= ATA_133) {
 		u16 regw = 0;
 		u16 reg_addr = hwif->channel ? 0x52: 0x50;
-		pci_read_config_word(hwif->pci_dev, reg_addr, &regw);
+		pci_read_config_word(pdev, reg_addr, &regw);
 		ata66 = (regw & 0x8000) ? 0 : 1;
 	} else if (chipset_family >= ATA_66) {
 		u8 reg48h = 0;
 		u8 mask = hwif->channel ? 0x20 : 0x10;
-		pci_read_config_byte(hwif->pci_dev, 0x48, &reg48h);
+		pci_read_config_byte(pdev, 0x48, &reg48h);
 		ata66 = (reg48h & mask) ? 0 : 1;
 	}
 
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -78,7 +78,7 @@ static unsigned int get_pio_timings(ide_
  */
 static void sl82c105_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	struct pci_dev *dev	= HWIF(drive)->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(drive->hwif->dev);
 	int reg			= 0x44 + drive->dn * 4;
 	u16 drv_ctrl;
 
@@ -147,7 +147,7 @@ static inline void sl82c105_reset_host(s
 static void sl82c105_dma_lost_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u32 val, mask		= hwif->channel ? CTRL_IDE_IRQB : CTRL_IDE_IRQA;
 	u8 dma_cmd;
 
@@ -184,7 +184,7 @@ static void sl82c105_dma_lost_irq(ide_dr
 static void sl82c105_dma_start(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int reg 		= 0x44 + drive->dn * 4;
 
 	DBG(("%s(drive:%s)\n", __FUNCTION__, drive->name));
@@ -197,15 +197,17 @@ static void sl82c105_dma_start(ide_drive
 
 static void sl82c105_dma_timeout(ide_drive_t *drive)
 {
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
+
 	DBG(("sl82c105_dma_timeout(drive:%s)\n", drive->name));
 
-	sl82c105_reset_host(HWIF(drive)->pci_dev);
+	sl82c105_reset_host(dev);
 	ide_dma_timeout(drive);
 }
 
 static int sl82c105_dma_end(ide_drive_t *drive)
 {
-	struct pci_dev *dev	= HWIF(drive)->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(drive->hwif->dev);
 	int reg 		= 0x44 + drive->dn * 4;
 	int ret;
 
@@ -224,7 +226,7 @@ static int sl82c105_dma_end(ide_drive_t 
  */
 static void sl82c105_resetproc(ide_drive_t *drive)
 {
-	struct pci_dev *dev = HWIF(drive)->pci_dev;
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
 	u32 val;
 
 	DBG(("sl82c105_resetproc(drive:%s)\n", drive->name));
@@ -293,6 +295,7 @@ static unsigned int __devinit init_chips
  */
 static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned int rev;
 
 	DBG(("init_hwif_sl82c105(hwif: ide%d)\n", hwif->index));
@@ -304,7 +307,7 @@ static void __devinit init_hwif_sl82c105
 	if (!hwif->dma_base)
 		return;
 
-	rev = sl82c105_bridge_revision(hwif->pci_dev);
+	rev = sl82c105_bridge_revision(dev);
 	if (rev <= 5) {
 		/*
 		 * Never ever EVER under any circumstances enable
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -26,7 +26,7 @@ static DEFINE_SPINLOCK(slc90e66_lock);
 static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	int is_slave		= drive->dn & 1;
 	int master_port		= hwif->channel ? 0x42 : 0x40;
 	int slave_port		= 0x44;
@@ -79,7 +79,7 @@ static void slc90e66_set_pio_mode(ide_dr
 static void slc90e66_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 maslave		= hwif->channel ? 0x42 : 0x40;
 	int sitre = 0, a_speed	= 7 << (drive->dn * 4);
 	int u_speed = 0, u_flag = 1 << drive->dn;
@@ -122,13 +122,14 @@ static void slc90e66_set_dma_mode(ide_dr
 
 static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 reg47 = 0;
 	u8 mask = hwif->channel ? 0x01 : 0x02;  /* bit0:Primary */
 
 	hwif->set_pio_mode = &slc90e66_set_pio_mode;
 	hwif->set_dma_mode = &slc90e66_set_dma_mode;
 
-	pci_read_config_byte(hwif->pci_dev, 0x47, &reg47);
+	pci_read_config_byte(dev, 0x47, &reg47);
 
 	if (hwif->dma_base == 0)
 		return;
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -164,7 +164,8 @@ static int tc86c001_busproc(ide_drive_t 
 
 static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 {
-	unsigned long sc_base	= pci_resource_start(hwif->pci_dev, 5);
+	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	unsigned long sc_base	= pci_resource_start(dev, 5);
 	u16 scr1		= inw(sc_base + 0x00);
 
 	/* System Control 1 Register bit 15 (Soft Reset) set */
Index: b/drivers/ide/pci/triflex.c
===================================================================
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -43,7 +43,7 @@
 static void triflex_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 channel_offset = hwif->channel ? 0x74 : 0x70;
 	u16 timing = 0;
 	u32 triflex_timings = 0;
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -242,10 +242,10 @@ static int trm290_ide_dma_test_irq (ide_
 
 static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	unsigned int cfgbase = 0;
 	unsigned long flags;
 	u8 reg = 0;
-	struct pci_dev *dev = hwif->pci_dev;
 
 	cfgbase = pci_resource_start(dev, 4);
 	if ((dev->class & 5) && cfgbase) {
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -121,8 +121,8 @@ struct via82cxxx_dev
 
 static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ide_timing *timing)
 {
-	struct pci_dev *dev = hwif->pci_dev;
-	struct via82cxxx_dev *vdev = pci_get_drvdata(hwif->pci_dev);
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	struct via82cxxx_dev *vdev = pci_get_drvdata(dev);
 	u8 t;
 
 	if (~vdev->via_config->flags & VIA_BAD_AST) {
@@ -159,8 +159,10 @@ static void via_set_speed(ide_hwif_t *hw
 
 static void via_set_drive(ide_drive_t *drive, const u8 speed)
 {
-	ide_drive_t *peer = HWIF(drive)->drives + (~drive->dn & 1);
-	struct via82cxxx_dev *vdev = pci_get_drvdata(drive->hwif->pci_dev);
+	ide_hwif_t *hwif = drive->hwif;
+	ide_drive_t *peer = hwif->drives + (~drive->dn & 1);
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	struct via82cxxx_dev *vdev = pci_get_drvdata(dev);
 	struct ide_timing t, p;
 	unsigned int T, UT;
 
@@ -408,7 +410,7 @@ static int via_cable_override(struct pci
 
 static u8 __devinit via82cxxx_cable_detect(ide_hwif_t *hwif)
 {
-	struct pci_dev *pdev = hwif->pci_dev;
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	struct via82cxxx_dev *vdev = pci_get_drvdata(pdev);
 
 	if (via_cable_override(pdev))
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1200,7 +1200,7 @@ pmac_ide_macio_attach(struct macio_dev *
 	base = ioremap(macio_resource_start(mdev, 0), 0x400);
 	regbase = (unsigned long) base;
 
-	hwif->pci_dev = mdev->bus->pdev;
+	hwif->dev = &mdev->bus->pdev->dev;
 
 	pmif->mdev = mdev;
 	pmif->node = mdev->ofdev.node;
@@ -1315,7 +1315,7 @@ pmac_ide_pci_attach(struct pci_dev *pdev
 		return -ENXIO;
 	}
 
-	hwif->pci_dev = pdev;
+	hwif->dev = &pdev->dev;
 	pmif->mdev = NULL;
 	pmif->node = np;
 
@@ -1725,10 +1725,12 @@ pmac_ide_dma_lost_irq (ide_drive_t *driv
 static void __init 
 pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+
 	/* We won't need pci_dev if we switch to generic consistent
 	 * DMA routines ...
 	 */
-	if (hwif->pci_dev == NULL)
+	if (dev == NULL)
 		return;
 	/*
 	 * Allocate space for the DBDMA commands.
@@ -1736,7 +1738,7 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif
 	 * aligning the start address to a multiple of 16 bytes.
 	 */
 	pmif->dma_table_cpu = (struct dbdma_cmd*)pci_alloc_consistent(
-		hwif->pci_dev,
+		dev,
 		(MAX_DCMDS + 2) * sizeof(struct dbdma_cmd),
 		&hwif->dmatable_dma);
 	if (pmif->dma_table_cpu == NULL) {
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -162,8 +162,8 @@ static void ide_pci_clear_simplex(unsign
 
 static unsigned long ide_get_or_set_dma_base(const struct ide_port_info *d, ide_hwif_t *hwif)
 {
-	unsigned long	dma_base = 0;
-	struct pci_dev	*dev = hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	unsigned long dma_base = 0;
 	u8 dma_stat = 0;
 
 	if (hwif->mmio)
@@ -391,7 +391,7 @@ static ide_hwif_t *ide_hwif_configure(st
 
 	hwif->noprobe = oldnoprobe;
 
-	hwif->pci_dev = dev;
+	hwif->dev = &dev->dev;
 	hwif->cds = d;
 	hwif->channel = port;
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -503,7 +503,8 @@ typedef struct hwif_s {
 
 	hwif_chipset_t chipset;	/* sub-module for tuning.. */
 
-	struct pci_dev  *pci_dev;	/* for pci chipsets */
+	struct device *dev;
+
 	const struct ide_port_info *cds;	/* chipset device struct */
 
 	ide_ack_intr_t *ack_intr;
@@ -1302,7 +1303,7 @@ static inline void ide_dump_identify(u8 
 
 static inline int hwif_to_node(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	return dev ? pcibus_to_node(dev->bus) : -1;
 }
 
