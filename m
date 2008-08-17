Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYHQT5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYHQT5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbYHQT42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:56:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:19610 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbYHQT40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:56:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=U4bVYZEZrtIVKUxZVOtrpXyeE//LTcuZywIPQJ5wAeok7rNWFAkyGzj3honP3yUKMt
         ENahFdeAESPxxqm4qQfXazC22JWr3QjgD/6cShROpzVd/SK3cRgvPjWiA3jWTLhwqBIF
         j6FqdmIZvqnoPgDpRQBZlKAviYL0kTVO9lEdo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 21:54:04 +0200
Message-Id: <20080817195404.13393.17.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
References: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/9] ide: use 'drive->dn & 1' instead of drive->select.b.unit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Call ide_port_init_devices() in ide_host_register()
  also if 'struct ide_port_info *d' is not available.

* Init drive->dn in ide_port_init_devices() instead of
  ide_probe_port() so it is valid also in ->init_dev.

* Pass device number to ide_dev_apply_params().

* Use 'drive->dn & 1' instead of drive->select.b.unit.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c         |    2 +-
 drivers/ide/ide-probe.c       |   26 ++++++++++++++------------
 drivers/ide/ide.c             |    6 +++---
 drivers/ide/legacy/ali14xx.c  |    2 +-
 drivers/ide/legacy/qd65xx.c   |    2 +-
 drivers/ide/pci/aec62xx.c     |    2 +-
 drivers/ide/pci/alim15x3.c    |    7 +++----
 drivers/ide/pci/cmd640.c      |    4 ++--
 drivers/ide/pci/cs5535.c      |    2 +-
 drivers/ide/pci/cy82c693.c    |    7 +++----
 drivers/ide/pci/it821x.c      |   36 ++++++++++++++++--------------------
 drivers/ide/pci/ns87415.c     |    4 ++--
 drivers/ide/pci/opti621.c     |    2 +-
 drivers/ide/pci/sc1200.c      |    3 +--
 drivers/ide/pci/scc_pata.c    |    2 +-
 drivers/ide/pci/serverworks.c |    2 +-
 drivers/ide/pci/siimage.c     |    9 +++++----
 drivers/ide/pci/triflex.c     |    9 ++++-----
 drivers/ide/ppc/pmac.c        |   11 +++++------
 19 files changed, 66 insertions(+), 72 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -370,7 +370,7 @@ static int dma_timer_expiry (ide_drive_t
 void ide_dma_host_set(ide_drive_t *drive, int on)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8 unit			= (drive->select.b.unit & 0x01);
+	u8 unit			= drive->dn & 1;
 	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
 
 	if (on)
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -447,7 +447,7 @@ static int do_probe (ide_drive_t *drive,
 	msleep(50);
 
 	if (ide_read_device(drive) != drive->select.all && present == 0) {
-		if (drive->select.b.unit != 0) {
+		if (drive->dn & 1) {
 			/* exit with drive0 selected */
 			SELECT_DRIVE(&hwif->drives[0]);
 			/* allow ATA_BUSY to assert & clear */
@@ -493,7 +493,7 @@ static int do_probe (ide_drive_t *drive,
 		/* not present or maybe ATAPI */
 		rc = 3;
 	}
-	if (drive->select.b.unit != 0) {
+	if (drive->dn & 1) {
 		/* exit with drive0 selected */
 		SELECT_DRIVE(&hwif->drives[0]);
 		msleep(50);
@@ -798,7 +798,7 @@ static int ide_probe_port(ide_hwif_t *hw
 	 */
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
-		drive->dn = (hwif->channel ? 2 : 0) + unit;
+
 		(void) probe_for_drive(drive);
 		if (drive->dev_flags & IDE_DFLAG_PRESENT)
 			rc = 0;
@@ -1357,6 +1357,8 @@ static void ide_port_init_devices(ide_hw
 	for (i = 0; i < MAX_DRIVES; i++) {
 		ide_drive_t *drive = &hwif->drives[i];
 
+		drive->dn = i + hwif->channel * 2;
+
 		if (hwif->host_flags & IDE_HFLAG_IO_32BIT)
 			drive->io_32bit = 1;
 		if (hwif->host_flags & IDE_HFLAG_UNMASK_IRQS)
@@ -1627,18 +1629,18 @@ int ide_host_register(struct ide_host *h
 
 		if (d == NULL) {
 			mate = NULL;
-			continue;
-		}
+		} else {
+			if ((i & 1) && mate) {
+				hwif->mate = mate;
+				mate->mate = hwif;
+			}
 
-		if ((i & 1) && mate) {
-			hwif->mate = mate;
-			mate->mate = hwif;
-		}
+			mate = (i & 1) ? NULL : hwif;
 
-		mate = (i & 1) ? NULL : hwif;
+			ide_init_port(hwif, i & 1, d);
+			ide_port_cable_detect(hwif);
+		}
 
-		ide_init_port(hwif, i & 1, d);
-		ide_port_cable_detect(hwif);
 		ide_port_init_devices(hwif);
 	}
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -713,9 +713,9 @@ static int ide_set_disk_chs(const char *
 module_param_call(chs, ide_set_disk_chs, NULL, NULL, 0);
 MODULE_PARM_DESC(chs, "force device as a disk (using CHS)");
 
-static void ide_dev_apply_params(ide_drive_t *drive)
+static void ide_dev_apply_params(ide_drive_t *drive, u8 unit)
 {
-	int i = drive->hwif->index * MAX_DRIVES + drive->select.b.unit;
+	int i = drive->hwif->index * MAX_DRIVES + unit;
 
 	if (ide_nodma & (1 << i)) {
 		printk(KERN_INFO "ide: disallowing DMA for %s\n", drive->name);
@@ -791,7 +791,7 @@ void ide_port_apply_params(ide_hwif_t *h
 	}
 
 	for (i = 0; i < MAX_DRIVES; i++)
-		ide_dev_apply_params(&hwif->drives[i]);
+		ide_dev_apply_params(&hwif->drives[i], i);
 }
 
 /*
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -131,7 +131,7 @@ static void ali14xx_set_pio_mode(ide_dri
 		drive->name, pio, time1, time2, param1, param2, param3, param4);
 
 	/* stuff timing parameters into controller registers */
-	driveNum = (HWIF(drive)->index << 1) + drive->select.b.unit;
+	driveNum = (drive->hwif->index << 1) + (drive->dn & 1);
 	spin_lock_irqsave(&ali14xx_lock, flags);
 	outb_p(regOn, basePort);
 	outReg(param1, regTab[driveNum].reg1);
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -305,7 +305,7 @@ static void __init qd6580_init_dev(ide_d
 	} else
 		t2 = t1 = hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA;
 
-	drive->drive_data = drive->select.b.unit ? t2 : t1;
+	drive->drive_data = (drive->dn & 1) ? t2 : t1;
 }
 
 static const struct ide_port_ops qd6500_port_ops = {
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -115,7 +115,7 @@ static void aec6260_set_mode(ide_drive_t
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct ide_host *host	= pci_get_drvdata(dev);
 	struct chipset_bus_clock_list_entry *bus_clock = host->host_priv;
-	u8 unit		= (drive->select.b.unit & 0x01);
+	u8 unit			= drive->dn & 1;
 	u8 tmp1 = 0, tmp2 = 0;
 	u8 ultra = 0, drive_conf = 0, ultra_conf = 0;
 	unsigned long flags;
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -77,8 +77,7 @@ static void ali_set_pio_mode(ide_drive_t
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	int port = hwif->channel ? 0x5c : 0x58;
 	int portFIFO = hwif->channel ? 0x55 : 0x54;
-	u8 cd_dma_fifo = 0;
-	int unit = drive->select.b.unit & 1;
+	u8 cd_dma_fifo = 0, unit = drive->dn & 1;
 
 	if ((s_clc = (s_time * bus_speed + 999) / 1000) >= 8)
 		s_clc = 0;
@@ -112,7 +111,7 @@ static void ali_set_pio_mode(ide_drive_t
 	}
 	
 	pci_write_config_byte(dev, port, s_clc);
-	pci_write_config_byte(dev, port+drive->select.b.unit+2, (a_clc << 4) | r_clc);
+	pci_write_config_byte(dev, port + unit + 2, (a_clc << 4) | r_clc);
 	local_irq_restore(flags);
 }
 
@@ -154,7 +153,7 @@ static void ali_set_dma_mode(ide_drive_t
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	u8 speed1		= speed;
-	u8 unit			= (drive->select.b.unit & 0x01);
+	u8 unit			= drive->dn & 1;
 	u8 tmpbyte		= 0x00;
 	int m5229_udma		= (hwif->channel) ? 0x57 : 0x56;
 
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -468,7 +468,7 @@ static void program_drive_counts(ide_dri
 	 */
 	if (index > 1) {
 		ide_hwif_t *hwif = drive->hwif;
-		ide_drive_t *peer = &hwif->drives[!drive->select.b.unit];
+		ide_drive_t *peer = &hwif->drives[!(drive->dn & 1)];
 		unsigned int mate = index ^ 1;
 
 		if (peer->dev_flags & IDE_DFLAG_PRESENT) {
@@ -607,7 +607,7 @@ static void cmd640_set_pio_mode(ide_driv
 
 static void cmd640_init_dev(ide_drive_t *drive)
 {
-	unsigned int i = drive->hwif->channel * 2 + drive->select.b.unit;
+	unsigned int i = drive->hwif->channel * 2 + (drive->dn & 1);
 
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 	/*
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -76,7 +76,7 @@ static unsigned int cs5535_udma_timings[
 static void cs5535_set_speed(ide_drive_t *drive, const u8 speed)
 {
 	u32 reg = 0, dummy;
-	int unit = drive->select.b.unit;
+	u8 unit = drive->dn & 1;
 
 	/* Set the PIO timings */
 	if (speed < XFER_SW_DMA_0) {
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -178,8 +178,7 @@ static void cy82c693_set_dma_mode(ide_dr
 
 #if CY82C693_DEBUG_INFO
 	printk(KERN_INFO "%s (ch=%d, dev=%d): set DMA mode to %d (single=%d)\n",
-		drive->name, HWIF(drive)->channel, drive->select.b.unit,
-		mode & 3, single);
+		drive->name, hwif->channel, drive->dn & 1, mode & 3, single);
 #endif /* CY82C693_DEBUG_INFO */
 
 	/*
@@ -224,7 +223,7 @@ static void cy82c693_set_pio_mode(ide_dr
 	compute_clocks(pio, &pclk);
 
 	/* now let's write  the clocks registers */
-	if (drive->select.b.unit == 0) {
+	if ((drive->dn & 1) == 0) {
 		/*
 		 * set master drive
 		 * address setup control register
@@ -266,7 +265,7 @@ static void cy82c693_set_pio_mode(ide_dr
 #if CY82C693_DEBUG_INFO
 	printk(KERN_INFO "%s (ch=%d, dev=%d): set PIO timing to "
 		"(addr=0x%X, ior=0x%X, iow=0x%X, 8bit=0x%X)\n",
-		drive->name, hwif->channel, drive->select.b.unit,
+		drive->name, hwif->channel, drive->dn & 1,
 		addrCtrl, pclk.time_16r, pclk.time_16w, pclk.time_8);
 #endif /* CY82C693_DEBUG_INFO */
 }
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -138,8 +138,7 @@ static void it821x_program_udma(ide_driv
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
 	int channel = hwif->channel;
-	int unit = drive->select.b.unit;
-	u8 conf;
+	u8 unit = drive->dn & 1, conf;
 
 	/* Program UDMA timing bits */
 	if(itdev->clock_mode == ATA_66)
@@ -168,13 +167,11 @@ static void it821x_clock_strategy(ide_dr
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
+	ide_drive_t *pair;
+	int clock, altclock, sel = 0;
+	u8 unit = drive->dn & 1, v;
 
-	u8 unit = drive->select.b.unit;
-	ide_drive_t *pair = &hwif->drives[1-unit];
-
-	int clock, altclock;
-	u8 v;
-	int sel = 0;
+	pair = &hwif->drives[1 - unit];
 
 	if(itdev->want[0][0] > itdev->want[1][0]) {
 		clock = itdev->want[0][1];
@@ -240,16 +237,17 @@ static void it821x_clock_strategy(ide_dr
 
 static void it821x_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif	= drive->hwif;
+	ide_hwif_t *hwif = drive->hwif;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	int unit = drive->select.b.unit;
-	ide_drive_t *pair = &hwif->drives[1 - unit];
-	u8 set_pio = pio;
+	ide_drive_t *pair;
+	u8 unit = drive->dn & 1, set_pio = pio;
 
 	/* Spec says 89 ref driver uses 88 */
 	static u16 pio_timings[]= { 0xAA88, 0xA382, 0xA181, 0x3332, 0x3121 };
 	static u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
 
+	pair = &hwif->drives[1 - unit];
+
 	/*
 	 * Compute the best PIO mode we can for a given device. We must
 	 * pick a speed that does not cause problems with the other device
@@ -286,9 +284,7 @@ static void it821x_tune_mwdma (ide_drive
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = (void *)ide_get_hwifdata(hwif);
-	int unit = drive->select.b.unit;
-	int channel = hwif->channel;
-	u8 conf;
+	u8 unit = drive->dn & 1, channel = hwif->channel, conf;
 
 	static u16 dma[]	= { 0x8866, 0x3222, 0x3121 };
 	static u8 mwdma_want[]	= { ATA_ANY, ATA_66, ATA_ANY };
@@ -325,9 +321,7 @@ static void it821x_tune_udma (ide_drive_
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	int unit = drive->select.b.unit;
-	int channel = hwif->channel;
-	u8 conf;
+	u8 unit = drive->dn & 1, channel = hwif->channel, conf;
 
 	static u16 udma[]	= { 0x4433, 0x4231, 0x3121, 0x2121, 0x1111, 0x2211, 0x1111 };
 	static u8 udma_want[]	= { ATA_ANY, ATA_50, ATA_ANY, ATA_66, ATA_66, ATA_50, ATA_66 };
@@ -369,7 +363,8 @@ static void it821x_dma_start(ide_drive_t
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	int unit = drive->select.b.unit;
+	u8 unit = drive->dn & 1;
+
 	if(itdev->mwdma[unit] != MWDMA_OFF)
 		it821x_program(drive, itdev->mwdma[unit]);
 	else if(itdev->udma[unit] != UDMA_OFF && itdev->timing10)
@@ -389,9 +384,10 @@ static void it821x_dma_start(ide_drive_t
 static int it821x_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	int unit = drive->select.b.unit;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
 	int ret = __ide_dma_end(drive);
+	u8 unit = drive->dn & 1;
+
 	if(itdev->mwdma[unit] != MWDMA_OFF)
 		it821x_program(drive, itdev->pio[unit]);
 	return ret;
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -160,8 +160,8 @@ static void ns87415_prepare_drive (ide_d
 		new |= bit;
 
 	/* Select PIO or DMA, DMA may only be selected for one drive/channel. */
-	bit   = 1 << (20 + drive->select.b.unit       + (hwif->channel << 1));
-	other = 1 << (20 + (1 - drive->select.b.unit) + (hwif->channel << 1));
+	bit   = 1 << (20 + (drive->dn & 1) + (hwif->channel << 1));
+	other = 1 << (20 + (1 - (drive->dn & 1)) + (hwif->channel << 1));
 	new = use_dma ? ((new & ~other) | bit) : (new & ~bit);
 
 	if (new != *old) {
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -179,7 +179,7 @@ static void opti621_set_pio_mode(ide_dri
 	misc = addr_timings[clk][addr_pio];
 
 	/* select Index-0/1 for Register-A/B */
-	write_reg(drive->select.b.unit, MISC_REG);
+	write_reg(drive->dn & 1, MISC_REG);
 	/* set read cycle timings */
 	write_reg(tim, READ_REG);
 	/* set write cycle timings */
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -126,7 +126,6 @@ static void sc1200_set_dma_mode(ide_driv
 {
 	ide_hwif_t		*hwif = HWIF(drive);
 	struct pci_dev		*dev = to_pci_dev(hwif->dev);
-	int			unit = drive->select.b.unit;
 	unsigned int		reg, timings;
 	unsigned short		pci_clock;
 	unsigned int		basereg = hwif->channel ? 0x50 : 0x40;
@@ -155,7 +154,7 @@ static void sc1200_set_dma_mode(ide_driv
 	else
 		timings = mwdma_timing[pci_clock][mode - XFER_MW_DMA_0];
 
-	if (unit == 0) {			/* are we configuring drive0? */
+	if ((drive->dn & 1) == 0) {
 		pci_read_config_dword(dev, basereg + 4, &reg);
 		timings |= reg & 0x80000000;	/* preserve PIO format bit */
 		pci_write_config_dword(dev, basereg + 4, timings);
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -291,7 +291,7 @@ static void scc_set_dma_mode(ide_drive_t
 static void scc_dma_host_set(ide_drive_t *drive, int on)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 unit = (drive->select.b.unit & 0x01);
+	u8 unit = drive->dn & 1;
 	u8 dma_stat = scc_ide_inb(hwif->dma_base + 4);
 
 	if (on)
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -153,7 +153,7 @@ static void svwks_set_dma_mode(ide_drive
 
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u8 unit			= (drive->select.b.unit & 0x01);
+	u8 unit			= drive->dn & 1;
 
 	u8 ultra_enable	 = 0, ultra_timing = 0, dma_timing = 0;
 
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -116,13 +116,14 @@ static inline unsigned long siimage_seld
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long base	= (unsigned long)hwif->hwif_data;
+	u8 unit			= drive->dn & 1;
 
 	base += 0xA0 + r;
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		base += hwif->channel << 6;
 	else
 		base += hwif->channel << 4;
-	base |= drive->select.b.unit << drive->select.b.unit;
+	base |= unit << unit;
 	return base;
 }
 
@@ -255,7 +256,7 @@ static void sil_set_pio_mode(ide_drive_t
 	u8 addr_mask		= hwif->channel ? (mmio ? 0xF4 : 0x84)
 						: (mmio ? 0xB4 : 0x80);
 	u8 mode			= 0;
-	u8 unit			= drive->select.b.unit;
+	u8 unit			= drive->dn & 1;
 
 	/* trim *taskfile* PIO to the slowest of the master/slave */
 	if (pair) {
@@ -301,9 +302,9 @@ static void sil_set_dma_mode(ide_drive_t
 
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u16 ultra = 0, multi	= 0;
-	u8 mode = 0, unit	= drive->select.b.unit;
 	unsigned long base	= (unsigned long)hwif->hwif_data;
+	u16 ultra = 0, multi	= 0;
+	u8 mode = 0, unit	= drive->dn & 1;
 	u8 mmio			= (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 scsc = 0, addr_mask	= hwif->channel ? (mmio ? 0xF4 : 0x84)
 						: (mmio ? 0xB4 : 0x80);
Index: b/drivers/ide/pci/triflex.c
===================================================================
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -38,13 +38,12 @@ static void triflex_set_mode(ide_drive_t
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 channel_offset = hwif->channel ? 0x74 : 0x70;
-	u16 timing = 0;
 	u32 triflex_timings = 0;
-	u8 unit = (drive->select.b.unit & 0x01);
-	
+	u16 timing = 0;
+	u8 channel_offset = hwif->channel ? 0x74 : 0x70, unit = drive->dn & 1;
+
 	pci_read_config_dword(dev, channel_offset, &triflex_timings);
-	
+
 	switch(speed) {
 		case XFER_MW_DMA_2:
 			timing = 0x0103; 
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -433,7 +433,7 @@ pmac_ide_selectproc(ide_drive_t *drive)
 	if (pmif == NULL)
 		return;
 
-	if (drive->select.b.unit & 0x01)
+	if (drive->dn & 1)
 		writel(pmif->timings[1], PMAC_IDE_REG(IDE_TIMING_CONFIG));
 	else
 		writel(pmif->timings[0], PMAC_IDE_REG(IDE_TIMING_CONFIG));
@@ -455,7 +455,7 @@ pmac_ide_kauai_selectproc(ide_drive_t *d
 	if (pmif == NULL)
 		return;
 
-	if (drive->select.b.unit & 0x01) {
+	if (drive->dn & 1) {
 		writel(pmif->timings[1], PMAC_IDE_REG(IDE_KAUAI_PIO_CONFIG));
 		writel(pmif->timings[3], PMAC_IDE_REG(IDE_KAUAI_ULTRA_CONFIG));
 	} else {
@@ -528,7 +528,7 @@ pmac_ide_set_pio_mode(ide_drive_t *drive
 		return;
 		
 	/* which drive is it ? */
-	timings = &pmif->timings[drive->select.b.unit & 0x01];
+	timings = &pmif->timings[drive->dn & 1];
 	t = *timings;
 
 	cycle_time = ide_pio_cycle_time(drive, pio);
@@ -805,9 +805,9 @@ static void pmac_ide_set_dma_mode(ide_dr
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
-	int unit = (drive->select.b.unit & 0x01);
 	int ret = 0;
 	u32 *timings, *timings2, tl[2];
+	u8 unit = drive->dn & 1;
 
 	timings = &pmif->timings[unit];
 	timings2 = &pmif->timings[unit+2];
@@ -1558,8 +1558,7 @@ pmac_ide_dma_setup(ide_drive_t *drive)
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct request *rq = HWGROUP(drive)->rq;
-	u8 unit = (drive->select.b.unit & 0x01);
-	u8 ata4;
+	u8 unit = drive->dn & 1, ata4;
 
 	if (pmif == NULL)
 		return 1;
