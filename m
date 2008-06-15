Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYFOTuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYFOTuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 15:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYFOTuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 15:50:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:55791 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYFOTuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 15:50:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=wHdl3rkLNBgcHFqileS0JlkZkArVxs6eSg0apqkrELgDgaW5yGpQRRngj9f1ERP+I9
         Hv1tbUU9TmJE0TlNNCy2FZva5D9+R/u28v4bqCev9ak4ffZqh7n6pj5cItHnaAwiYj2l
         gdJS0QKdYhuX+YkLrp7Kckj2IHScxWIGja/Sc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Sun, 15 Jun 2008 21:49:11 +0200
Message-Id: <200806152149.11267.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

- ide-generic post-2.6.25 regression bugfix
  (thanks to bugreport from Mikael Pettersson)

- ide-cs fixes (including post-2.6.25 regression bugfix)

- ide-pmac fixes (including post-2.6.25 regression bugfix)

- opti621 fixes (including 2.6.25 regression bugfix)

opti621 changes outstand in the diffstat and they are on the border
of being too much for -rc but since they were all tested on the real
hardware (thanks to Juergen Kosel) and they match behavior of Alan's
pata_opti621 they should be safe.

BTW 2.6.26 cycle was a bit rougher than usual when it comes to IDE
(due to nature of changes that went in and hitting few corner-cases
which slipped through audit + -mm/-next testing) but it should be all
good now and back to the norm in 2.6.27 cycle.


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/ide-generic.c    |    9 ++-
 drivers/ide/legacy/ide-cs.c  |   41 ++++----
 drivers/ide/pci/opti621.c    |  221 ++++++++----------------------------------
 drivers/ide/ppc/pmac.c       |   60 ++++++------
 drivers/macintosh/mediabay.c |    3 +-
 5 files changed, 101 insertions(+), 233 deletions(-)


Bartlomiej Zolnierkiewicz (12):
      opti621: disable read prefetch
      opti621: remove DMA support
      opti621: use PCI clock value provided by controller
      opti621: program devices timings separately in ->set_pio_mode
      opti621: use pre-calculated PIO timings
      opti621: add PIO 4 support
      ide-pmac: bugfix for media-bay support rework
      ide-pmac: add ->cable_detect method
      ide-pmac: remove bogus comment about pmac_ide_setup_device()
      ide-cs: fix probing and add warm-plug support
      ide-cs: fix releasing I/O resources
      ide-generic: don't probe all legacy ISA IDE ports by default


diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 9134488..2d92214 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -22,6 +22,10 @@
 
 #define DRV_NAME	"ide_generic"
 
+static int probe_mask = 0x03;
+module_param(probe_mask, int, 0);
+MODULE_PARM_DESC(probe_mask, "probe mask for legacy ISA IDE ports");
+
 static ssize_t store_add(struct class *cls, const char *buf, size_t n)
 {
 	ide_hwif_t *hwif;
@@ -89,6 +93,9 @@ static int __init ide_generic_init(void)
 	u8 idx[MAX_HWIFS];
 	int i;
 
+	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
+			 "parameter for probing all legacy ISA IDE ports\n");
+
 	for (i = 0; i < MAX_HWIFS; i++) {
 		ide_hwif_t *hwif;
 		unsigned long io_addr = ide_default_io_base(i);
@@ -96,7 +103,7 @@ static int __init ide_generic_init(void)
 
 		idx[i] = 0xff;
 
-		if (io_addr) {
+		if ((probe_mask & (1 << i)) && io_addr) {
 			if (!request_region(io_addr, 8, DRV_NAME)) {
 				printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX "
 						"not free.\n",
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index aa2ea3d..f633b6b 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -135,13 +135,17 @@ static void ide_detach(struct pcmcia_device *link)
 {
     ide_info_t *info = link->priv;
     ide_hwif_t *hwif = info->hwif;
+    unsigned long data_addr, ctl_addr;
 
     DEBUG(0, "ide_detach(0x%p)\n", link);
 
+    data_addr = hwif->io_ports.data_addr;
+    ctl_addr  = hwif->io_ports.ctl_addr;
+
     ide_release(link);
 
-    release_region(hwif->io_ports.ctl_addr, 1);
-    release_region(hwif->io_ports.data_addr, 8);
+    release_region(ctl_addr, 1);
+    release_region(data_addr, 8);
 
     kfree(info);
 } /* ide_detach */
@@ -194,6 +198,16 @@ static ide_hwif_t *idecs_register(unsigned long io, unsigned long ctl,
     if (hwif->present)
 	return hwif;
 
+    /* retry registration in case device is still spinning up */
+    for (i = 0; i < 10; i++) {
+	msleep(100);
+	ide_port_scan(hwif);
+	if (hwif->present)
+	    return hwif;
+    }
+
+    return hwif;
+
 out_release:
     release_region(ctl, 1);
     release_region(io, 8);
@@ -222,7 +236,7 @@ static int ide_config(struct pcmcia_device *link)
 	cistpl_cftable_entry_t dflt;
     } *stk = NULL;
     cistpl_cftable_entry_t *cfg;
-    int i, pass, last_ret = 0, last_fn = 0, is_kme = 0;
+    int pass, last_ret = 0, last_fn = 0, is_kme = 0;
     unsigned long io_base, ctl_base;
     ide_hwif_t *hwif;
 
@@ -319,30 +333,15 @@ static int ide_config(struct pcmcia_device *link)
     if (is_kme)
 	outb(0x81, ctl_base+1);
 
-    /* retry registration in case device is still spinning up */
-    for (i = 0; i < 10; i++) {
-	hwif = idecs_register(io_base, ctl_base, link->irq.AssignedIRQ, link);
-	if (hwif)
-	    break;
-	if (link->io.NumPorts1 == 0x20) {
+     hwif = idecs_register(io_base, ctl_base, link->irq.AssignedIRQ, link);
+     if (hwif == NULL && link->io.NumPorts1 == 0x20) {
 	    outb(0x02, ctl_base + 0x10);
 	    hwif = idecs_register(io_base + 0x10, ctl_base + 0x10,
 				  link->irq.AssignedIRQ, link);
-	    if (hwif) {
-		io_base += 0x10;
-		ctl_base += 0x10;
-		break;
-	    }
-	}
-	msleep(100);
     }
 
-    if (hwif == NULL) {
-	printk(KERN_NOTICE "ide-cs: ide_register() at 0x%3lx & 0x%3lx"
-	       ", irq %u failed\n", io_base, ctl_base,
-	       link->irq.AssignedIRQ);
+    if (hwif == NULL)
 	goto failed;
-    }
 
     info->ndev = 1;
     sprintf(info->node.dev_name, "hd%c", 'a' + hwif->index * 2);
diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index 6e99080..725c805 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -81,8 +81,6 @@
  * 0.5 doesn't work.
  */
 
-#define OPTI621_DEBUG		/* define for debug messages */
-
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -92,28 +90,6 @@
 
 #include <asm/io.h>
 
-//#define OPTI621_MAX_PIO 3
-/* In fact, I do not have any PIO 4 drive
- * (address: 25 ns, data: 70 ns, recovery: 35 ns),
- * but OPTi 82C621 is programmable and it can do (minimal values):
- * on 40MHz PCI bus (pulse 25 ns):
- *  address: 25 ns, data: 25 ns, recovery: 50 ns;
- * on 20MHz PCI bus (pulse 50 ns):
- *  address: 50 ns, data: 50 ns, recovery: 100 ns.
- */
-
-/* #define READ_PREFETCH 0 */
-/* Uncomment for disable read prefetch.
- * There is some readprefetch capatibility in hdparm,
- * but when I type hdparm -P 1 /dev/hda, I got errors
- * and till reset drive is inaccessible.
- * This (hw) read prefetch is safe on my drive.
- */
-
-#ifndef READ_PREFETCH
-#define READ_PREFETCH 0x40 /* read prefetch is enabled */
-#endif /* else read prefetch is disabled */
-
 #define READ_REG 0	/* index of Read cycle timing register */
 #define WRITE_REG 1	/* index of Write cycle timing register */
 #define CNTRL_REG 3	/* index of Control register */
@@ -122,51 +98,8 @@
 
 static int reg_base;
 
-#define PIO_NOT_EXIST 254
-#define PIO_DONT_KNOW 255
-
 static DEFINE_SPINLOCK(opti621_lock);
 
-/* there are stored pio numbers from other calls of opti621_set_pio_mode */
-static void compute_pios(ide_drive_t *drive, const u8 pio)
-/* Store values into drive->drive_data
- *	second_contr - 0 for primary controller, 1 for secondary
- *	slave_drive - 0 -> pio is for master, 1 -> pio is for slave
- *	pio - PIO mode for selected drive (for other we don't know)
- */
-{
-	int d;
-	ide_hwif_t *hwif = HWIF(drive);
-
-	drive->drive_data = pio;
-
-	for (d = 0; d < 2; ++d) {
-		drive = &hwif->drives[d];
-		if (drive->present) {
-			if (drive->drive_data == PIO_DONT_KNOW)
-				drive->drive_data = ide_get_best_pio_mode(drive, 255, 3);
-#ifdef OPTI621_DEBUG
-			printk("%s: Selected PIO mode %d\n",
-				drive->name, drive->drive_data);
-#endif
-		} else {
-			drive->drive_data = PIO_NOT_EXIST;
-		}
-	}
-}
-
-static int cmpt_clk(int time, int bus_speed)
-/* Returns (rounded up) time in clocks for time in ns,
- * with bus_speed in MHz.
- * Example: bus_speed = 40 MHz, time = 80 ns
- * 1000/40 = 25 ns (clk value),
- * 80/25 = 3.2, rounded up to 4 (I hope ;-)).
- * Use idebus=xx to select right frequency.
- */
-{
-	return ((time*bus_speed+999)/1000);
-}
-
 /* Write value to register reg, base of register
  * is at reg_base (0x1f0 primary, 0x170 secondary,
  * if not changed by PCI configuration).
@@ -199,83 +132,29 @@ static u8 read_reg(int reg)
 	return ret;
 }
 
-typedef struct pio_clocks_s {
-	int	address_time;	/* Address setup (clocks) */
-	int	data_time;	/* Active/data pulse (clocks) */
-	int	recovery_time;	/* Recovery time (clocks) */
-} pio_clocks_t;
-
-static void compute_clocks(int pio, pio_clocks_t *clks)
-{
-	if (pio != PIO_NOT_EXIST) {
-		int adr_setup, data_pls;
-		int bus_speed = ide_pci_clk ? ide_pci_clk : system_bus_clock();
-
-		adr_setup = ide_pio_timings[pio].setup_time;
-		data_pls = ide_pio_timings[pio].active_time;
-		clks->address_time = cmpt_clk(adr_setup, bus_speed);
-		clks->data_time = cmpt_clk(data_pls, bus_speed);
-		clks->recovery_time = cmpt_clk(ide_pio_timings[pio].cycle_time
-			- adr_setup-data_pls, bus_speed);
-		if (clks->address_time < 1)
-			clks->address_time = 1;
-		if (clks->address_time > 4)
-			clks->address_time = 4;
-		if (clks->data_time < 1)
-			clks->data_time = 1;
-		if (clks->data_time > 16)
-			clks->data_time = 16;
-		if (clks->recovery_time < 2)
-			clks->recovery_time = 2;
-		if (clks->recovery_time > 17)
-			clks->recovery_time = 17;
-	} else {
-		clks->address_time = 1;
-		clks->data_time = 1;
-		clks->recovery_time = 2;
-		/* minimal values */
-	}
-}
-
 static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	/* primary and secondary drives share some registers,
-	 * so we have to program both drives
-	 */
+	ide_hwif_t *hwif = drive->hwif;
+	ide_drive_t *pair = ide_get_paired_drive(drive);
 	unsigned long flags;
-	u8 pio1 = 0, pio2 = 0;
-	pio_clocks_t first, second;
-	int ax, drdy;
-	u8 cycle1, cycle2, misc;
-	ide_hwif_t *hwif = HWIF(drive);
-
-	/* sets drive->drive_data for both drives */
-	compute_pios(drive, pio);
-	pio1 = hwif->drives[0].drive_data;
-	pio2 = hwif->drives[1].drive_data;
-
-	compute_clocks(pio1, &first);
-	compute_clocks(pio2, &second);
-
-	/* ax = max(a1,a2) */
-	ax = (first.address_time < second.address_time) ? second.address_time : first.address_time;
-
-	drdy = 2; /* DRDY is default 2 (by OPTi Databook) */
-
-	cycle1 = ((first.data_time-1)<<4)  | (first.recovery_time-2);
-	cycle2 = ((second.data_time-1)<<4) | (second.recovery_time-2);
-	misc = READ_PREFETCH | ((ax-1)<<4) | ((drdy-2)<<1);
-
-#ifdef OPTI621_DEBUG
-	printk("%s: master: address: %d, data: %d, "
-		"recovery: %d, drdy: %d [clk]\n",
-		hwif->name, ax, first.data_time,
-		first.recovery_time, drdy);
-	printk("%s: slave:  address: %d, data: %d, "
-		"recovery: %d, drdy: %d [clk]\n",
-		hwif->name, ax, second.data_time,
-		second.recovery_time, drdy);
-#endif
+	u8 tim, misc, addr_pio = pio, clk;
+
+	/* DRDY is default 2 (by OPTi Databook) */
+	static const u8 addr_timings[2][5] = {
+		{ 0x20, 0x10, 0x00, 0x00, 0x00 },	/* 33 MHz */
+		{ 0x10, 0x10, 0x00, 0x00, 0x00 },	/* 25 MHz */
+	};
+	static const u8 data_rec_timings[2][5] = {
+		{ 0x5b, 0x45, 0x32, 0x21, 0x20 },	/* 33 MHz */
+		{ 0x48, 0x34, 0x21, 0x10, 0x10 }	/* 25 MHz */
+	};
+
+	drive->drive_data = XFER_PIO_0 + pio;
+
+	if (pair->present) {
+		if (pair->drive_data && pair->drive_data < drive->drive_data)
+			addr_pio = pair->drive_data - XFER_PIO_0;
+	}
 
 	spin_lock_irqsave(&opti621_lock, flags);
 
@@ -289,24 +168,21 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	(void)inb(reg_base + CNTRL_REG);
 	/* if reads 0xc0, no interface exist? */
 	read_reg(CNTRL_REG);
-	/* read version, probably 0 */
-	read_reg(STRAP_REG);
 
-	/* program primary drive */
-	/* select Index-0 for Register-A */
-	write_reg(0, MISC_REG);
-	/* set read cycle timings */
-	write_reg(cycle1, READ_REG);
-	/* set write cycle timings */
-	write_reg(cycle1, WRITE_REG);
+	/* check CLK speed */
+	clk = read_reg(STRAP_REG) & 1;
+
+	printk(KERN_INFO "%s: CLK = %d MHz\n", hwif->name, clk ? 25 : 33);
 
-	/* program secondary drive */
-	/* select Index-1 for Register-B */
-	write_reg(1, MISC_REG);
+	tim  = data_rec_timings[clk][pio];
+	misc = addr_timings[clk][addr_pio];
+
+	/* select Index-0/1 for Register-A/B */
+	write_reg(drive->select.b.unit, MISC_REG);
 	/* set read cycle timings */
-	write_reg(cycle2, READ_REG);
+	write_reg(tim, READ_REG);
 	/* set write cycle timings */
-	write_reg(cycle2, WRITE_REG);
+	write_reg(tim, WRITE_REG);
 
 	/* use Register-A for drive 0 */
 	/* use Register-B for drive 1 */
@@ -319,45 +195,26 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	spin_unlock_irqrestore(&opti621_lock, flags);
 }
 
-static void __devinit opti621_port_init_devs(ide_hwif_t *hwif)
-{
-	hwif->drives[0].drive_data = PIO_DONT_KNOW;
-	hwif->drives[1].drive_data = PIO_DONT_KNOW;
-}
-
 static const struct ide_port_ops opti621_port_ops = {
-	.port_init_devs		= opti621_port_init_devs,
 	.set_pio_mode		= opti621_set_pio_mode,
 };
 
-static const struct ide_port_info opti621_chipsets[] __devinitdata = {
-	{	/* 0 */
-		.name		= "OPTI621",
-		.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
-		.port_ops	= &opti621_port_ops,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-		.pio_mask	= ATA_PIO3,
-		.swdma_mask	= ATA_SWDMA2,
-		.mwdma_mask	= ATA_MWDMA2,
-	}, {	/* 1 */
-		.name		= "OPTI621X",
-		.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
-		.port_ops	= &opti621_port_ops,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
-		.pio_mask	= ATA_PIO3,
-		.swdma_mask	= ATA_SWDMA2,
-		.mwdma_mask	= ATA_MWDMA2,
-	}
+static const struct ide_port_info opti621_chipset __devinitdata = {
+	.name		= "OPTI621/X",
+	.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
+	.port_ops	= &opti621_port_ops,
+	.host_flags	= IDE_HFLAG_NO_DMA,
+	.pio_mask	= ATA_PIO4,
 };
 
 static int __devinit opti621_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &opti621_chipsets[id->driver_data]);
+	return ide_setup_pci_device(dev, &opti621_chipset);
 }
 
 static const struct pci_device_id opti621_pci_tbl[] = {
 	{ PCI_VDEVICE(OPTI, PCI_DEVICE_ID_OPTI_82C621), 0 },
-	{ PCI_VDEVICE(OPTI, PCI_DEVICE_ID_OPTI_82C825), 1 },
+	{ PCI_VDEVICE(OPTI, PCI_DEVICE_ID_OPTI_82C825), 0 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, opti621_pci_tbl);
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 48aa019..ba2d587 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -59,7 +59,6 @@ typedef struct pmac_ide_hwif {
 	int				irq;
 	int				kind;
 	int				aapl_bus_id;
-	unsigned			cable_80 : 1;
 	unsigned			mediabay : 1;
 	unsigned			broken_dma : 1;
 	unsigned			broken_dma_warn : 1;
@@ -918,10 +917,40 @@ pmac_ide_do_resume(ide_hwif_t *hwif)
 	return 0;
 }
 
+static u8 pmac_ide_cable_detect(ide_hwif_t *hwif)
+{
+	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)ide_get_hwifdata(hwif);
+	struct device_node *np = pmif->node;
+	const char *cable = of_get_property(np, "cable-type", NULL);
+
+	/* Get cable type from device-tree. */
+	if (cable && !strncmp(cable, "80-", 3))
+		return ATA_CBL_PATA80;
+
+	/*
+	 * G5's seem to have incorrect cable type in device-tree.
+	 * Let's assume they have a 80 conductor cable, this seem
+	 * to be always the case unless the user mucked around.
+	 */
+	if (of_device_is_compatible(np, "K2-UATA") ||
+	    of_device_is_compatible(np, "shasta-ata"))
+		return ATA_CBL_PATA80;
+
+	return ATA_CBL_PATA40;
+}
+
 static const struct ide_port_ops pmac_ide_ata6_port_ops = {
 	.set_pio_mode		= pmac_ide_set_pio_mode,
 	.set_dma_mode		= pmac_ide_set_dma_mode,
 	.selectproc		= pmac_ide_kauai_selectproc,
+	.cable_detect		= pmac_ide_cable_detect,
+};
+
+static const struct ide_port_ops pmac_ide_ata4_port_ops = {
+	.set_pio_mode		= pmac_ide_set_pio_mode,
+	.set_dma_mode		= pmac_ide_set_dma_mode,
+	.selectproc		= pmac_ide_selectproc,
+	.cable_detect		= pmac_ide_cable_detect,
 };
 
 static const struct ide_port_ops pmac_ide_port_ops = {
@@ -949,10 +978,7 @@ static const struct ide_port_info pmac_port_info = {
 
 /*
  * Setup, register & probe an IDE channel driven by this driver, this is
- * called by one of the 2 probe functions (macio or PCI). Note that a channel
- * that ends up beeing free of any device is not kept around by this driver
- * (it is kept in 2.4). This introduce an interface numbering change on some
- * rare machines unfortunately, but it's better this way.
+ * called by one of the 2 probe functions (macio or PCI).
  */
 static int __devinit
 pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
@@ -962,7 +988,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	struct ide_port_info d = pmac_port_info;
 
-	pmif->cable_80 = 0;
 	pmif->broken_dma = pmif->broken_dma_warn = 0;
 	if (of_device_is_compatible(np, "shasta-ata")) {
 		pmif->kind = controller_sh_ata6;
@@ -979,6 +1004,7 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 	} else if (of_device_is_compatible(np, "keylargo-ata")) {
 		if (strcmp(np->name, "ata-4") == 0) {
 			pmif->kind = controller_kl_ata4;
+			d.port_ops = &pmac_ide_ata4_port_ops;
 			d.udma_mask = ATA_UDMA4;
 		} else
 			pmif->kind = controller_kl_ata3;
@@ -992,22 +1018,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 	bidp = of_get_property(np, "AAPL,bus-id", NULL);
 	pmif->aapl_bus_id =  bidp ? *bidp : 0;
 
-	/* Get cable type from device-tree */
-	if (pmif->kind == controller_kl_ata4 || pmif->kind == controller_un_ata6
-	    || pmif->kind == controller_k2_ata6
-	    || pmif->kind == controller_sh_ata6) {
-		const char* cable = of_get_property(np, "cable-type", NULL);
-		if (cable && !strncmp(cable, "80-", 3))
-			pmif->cable_80 = 1;
-	}
-	/* G5's seem to have incorrect cable type in device-tree. Let's assume
-	 * they have a 80 conductor cable, this seem to be always the case unless
-	 * the user mucked around
-	 */
-	if (of_device_is_compatible(np, "K2-UATA") ||
-	    of_device_is_compatible(np, "shasta-ata"))
-		pmif->cable_80 = 1;
-
 	/* On Kauai-type controllers, we make sure the FCR is correct */
 	if (pmif->kauai_fcr)
 		writel(KAUAI_FCR_UATA_MAGIC |
@@ -1053,7 +1063,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 
 	hwif->hwif_data = pmif;
 	ide_init_port_hw(hwif, hw);
-	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 
 	printk(KERN_INFO "ide%d: Found Apple %s controller, bus ID %d%s, irq %d\n",
 	       hwif->index, model_name[pmif->kind], pmif->aapl_bus_id,
@@ -1070,11 +1079,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 		}
 	}
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
-	if (pmif->cable_80 == 0)
-		d.udma_mask &= ATA_UDMA2;
-#endif
-
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, &d);
diff --git a/drivers/macintosh/mediabay.c b/drivers/macintosh/mediabay.c
index 82add26..c34bdf8 100644
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -556,7 +556,8 @@ static void media_bay_step(int i)
 				printk("mediabay %d, registering IDE...\n", i);
 				pmu_suspend();
 				ide_port_scan(bay->cd_port);
-				bay->cd_index = bay->cd_port->index;
+				if (bay->cd_port->present)
+					bay->cd_index = bay->cd_port->index;
 				pmu_resume();
 			}
 			if (bay->cd_index == -1) {
