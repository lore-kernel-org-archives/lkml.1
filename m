Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbXCQVCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbXCQVCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 17:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXCQVCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 17:02:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:38570 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbXCQVBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 17:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GF5o677f0Pp7quiSrjgGY/+kvOoizFz9pz3zdpB88Svgyah9A5y4XLKJg7FZhJKHt/m+UWjv11+XQgIokDYYzHcuyYir/KFWn8xz1Cz8VAFJ+s5Tk+VSsDrWkuHu/3EB9MWvEqDVsZ39yjF/CWcLQy/w0/3Z88sIbUKrD0/5vBY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Sat, 17 Mar 2007 22:07:52 +0100
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703172207.52352.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 b/drivers/ide/Kconfig                       |   48 -
 b/drivers/ide/Makefile                      |    1 
 b/drivers/ide/arm/icside.c                  |   13 
 b/drivers/ide/ide-dma.c                     |    2 
 b/drivers/ide/ide.c                         |    4 
 b/drivers/ide/mips/au1xxx-ide.c             |    3 
 b/drivers/ide/pci/Makefile                  |    1 
 b/drivers/ide/pci/cmd64x.c                  |   45 -
 b/drivers/ide/pci/jmicron.c                 |   29 
 b/drivers/ide/pci/scc_pata.c                |  858 ++++++++++++++++++++++++++++
 b/drivers/ide/setup-pci.c                   |    5 
 b/include/asm-mips/mach-au1x00/au1xxx_ide.h |   34 -
 drivers/ide/ppc/scc_pata.c                  |  858 ----------------------------
 13 files changed, 915 insertions(+), 986 deletions(-)


Bartlomiej Zolnierkiewicz (2):
      ide: don't allow DMA to be enabled if CONFIG_IDEDMA_{ICS,PCI}_AUTO=n
      ide: remove CONFIG_IDEDMA_{ICS,PCI}_AUTO config options

Daniel Mack (1):
      ide: remove static prototypes from include/asm-mips/mach-au1x00/au1xxx_ide.h

Kou Ishizaki (1):
      scc_pata: dependency fix

Ralf Baechle (1):
      ide: au1xxx: fix use of mixed declarations and code

Sergei Shtylyov (1):
      cmd64x: fix recovery time calculation (take 3)

Tejun Heo (1):
      jmicron: make ide jmicron driver play nice with libata ones


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 3f76987..8f1fd01 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -434,24 +434,8 @@ config BLK_DEV_IDEDMA_FORCED
 
 	  Generally say N here.
 
-config IDEDMA_PCI_AUTO
-	bool "Use PCI DMA by default when available"
-	---help---
-	  Prior to kernel version 2.1.112, Linux used to automatically use
-	  DMA for IDE drives and chipsets which support it. Due to concerns
-	  about a couple of cases where buggy hardware may have caused damage,
-	  the default is now to NOT use DMA automatically. To revert to the
-	  previous behaviour, say Y to this question.
-
-	  If you suspect your hardware is at all flakey, say N here.
-	  Do NOT email the IDE kernel people regarding this issue!
-
-	  It is normally safe to answer Y to this question unless your
-	  motherboard uses a VIA VP2 chipset, in which case you should say N.
-
 config IDEDMA_ONLYDISK
 	bool "Enable DMA only for disks "
-	depends on IDEDMA_PCI_AUTO
 	help
 	  This is used if you know your ATAPI Devices are going to fail DMA
 	  Transfers.
@@ -769,6 +753,14 @@ config BLK_DEV_TC86C001
 	help
 	This driver adds support for Toshiba TC86C001 GOKU-S chip.
 
+config BLK_DEV_CELLEB
+	tristate "Toshiba's Cell Reference Set IDE support"
+	depends on PPC_CELLEB
+	help
+	  This driver provides support for the built-in IDE controller on
+	  Toshiba Cell Reference Board.
+	  If unsure, say Y.
+
 endif
 
 config BLK_DEV_IDE_PMAC
@@ -800,14 +792,6 @@ config BLK_DEV_IDEDMA_PMAC
 	  to transfer data to and from memory.  Saying Y is safe and improves
 	  performance.
 
-config BLK_DEV_IDE_CELLEB
-	bool "Toshiba's Cell Reference Set IDE support"
-	depends on PPC_CELLEB && IDE=y
-	help
-	  This driver provides support for the built-in IDE controller on
-	  Toshiba Cell Reference Board.
-	  If unsure, say Y.
-
 config BLK_DEV_IDE_SWARM
 	tristate "IDE for Sibyte evaluation boards"
 	depends on SIBYTE_SB1xxx_SOC
@@ -851,19 +835,6 @@ config BLK_DEV_IDEDMA_ICS
 	  Say Y here if you want to add DMA (Direct Memory Access) support to
 	  the ICS IDE driver.
 
-config IDEDMA_ICS_AUTO
-	bool "Use ICS DMA by default"
-	depends on BLK_DEV_IDEDMA_ICS
-	help
-	  Prior to kernel version 2.1.112, Linux used to automatically use
-	  DMA for IDE drives and chipsets which support it. Due to concerns
-	  about a couple of cases where buggy hardware may have caused damage,
-	  the default is now to NOT use DMA automatically. To revert to the
-	  previous behaviour, say Y to this question.
-
-	  If you suspect your hardware is at all flakey, say N here.
-	  Do NOT email the IDE kernel people regarding this issue!
-
 config BLK_DEV_IDE_RAPIDE
 	tristate "RapIDE interface support"
 	depends on ARM && ARCH_ACORN
@@ -1086,9 +1057,6 @@ config IDEDMA_IVB
 
 	  It is normally safe to answer Y; however, the default is N.
 
-config IDEDMA_AUTO
-	def_bool IDEDMA_PCI_AUTO || IDEDMA_ICS_AUTO
-
 endif
 
 config BLK_DEV_HD_ONLY
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 28feedf..d9f029e 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -37,7 +37,6 @@ ide-core-$(CONFIG_BLK_DEV_Q40IDE)	+= legacy/q40ide.o
 # built-in only drivers from ppc/
 ide-core-$(CONFIG_BLK_DEV_MPC8xx_IDE)	+= ppc/mpc8xx.o
 ide-core-$(CONFIG_BLK_DEV_IDE_PMAC)	+= ppc/pmac.o
-ide-core-$(CONFIG_BLK_DEV_IDE_CELLEB)	+= ppc/scc_pata.o
 
 # built-in only drivers from h8300/
 ide-core-$(CONFIG_H8300)		+= h8300/ide-h8300.o
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 40e5c66..e2953fc 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -196,11 +196,6 @@ static void icside_maskproc(ide_drive_t *drive, int mask)
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_ICS
-
-#ifndef CONFIG_IDEDMA_ICS_AUTO
-#warning CONFIG_IDEDMA_ICS_AUTO=n support is obsolete, and will be removed soon.
-#endif
-
 /*
  * SG-DMA support.
  *
@@ -474,12 +469,6 @@ static int icside_dma_lostirq(ide_drive_t *drive)
 
 static void icside_dma_init(ide_hwif_t *hwif)
 {
-	int autodma = 0;
-
-#ifdef CONFIG_IDEDMA_ICS_AUTO
-	autodma = 1;
-#endif
-
 	printk("    %s: SG-DMA", hwif->name);
 
 	hwif->atapi_dma		= 1;
@@ -489,7 +478,7 @@ static void icside_dma_init(ide_hwif_t *hwif)
 	hwif->dmatable_cpu	= NULL;
 	hwif->dmatable_dma	= 0;
 	hwif->speedproc		= icside_set_speed;
-	hwif->autodma		= autodma;
+	hwif->autodma		= 1;
 
 	hwif->ide_dma_check	= icside_dma_check;
 	hwif->dma_host_off	= icside_dma_host_off;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 08e7cd0..fd21308 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -767,7 +767,7 @@ int ide_set_dma(ide_drive_t *drive)
 	switch(rc) {
 	case -1: /* DMA needs to be disabled */
 		hwif->dma_off_quietly(drive);
-		return 0;
+		return -1;
 	case  0: /* DMA needs to be enabled */
 		return hwif->ide_dma_on(drive);
 	case  1: /* DMA setting cannot be changed */
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index dfbd744..695610f 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -177,11 +177,7 @@ DECLARE_MUTEX(ide_cfg_sem);
 static int ide_scan_direction; /* THIS was formerly 2.2.x pci=reverse */
 #endif
 
-#ifdef CONFIG_IDEDMA_AUTO
 int noautodma = 0;
-#else
-int noautodma = 1;
-#endif
 
 EXPORT_SYMBOL(noautodma);
 
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index b2dc028..d54d9fe 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -639,6 +639,7 @@ static int au_ide_probe(struct device *dev)
 	_auide_hwif *ahwif = &auide_hwif;
 	ide_hwif_t *hwif;
 	struct resource *res;
+	hw_regs_t *hw;
 	int ret = 0;
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
@@ -681,7 +682,7 @@ static int au_ide_probe(struct device *dev)
 	/* FIXME:  This might possibly break PCMCIA IDE devices */
 
 	hwif                            = &ide_hwifs[pdev->id];
-	hw_regs_t *hw 			= &hwif->hw;
+	hw 				= &hwif->hw;
 	hwif->irq = hw->irq             = ahwif->irq;
 	hwif->chipset                   = ide_au1xxx;
 
diff --git a/drivers/ide/pci/Makefile b/drivers/ide/pci/Makefile
index 6591ff4..95d1ea8 100644
--- a/drivers/ide/pci/Makefile
+++ b/drivers/ide/pci/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_BLK_DEV_AEC62XX)		+= aec62xx.o
 obj-$(CONFIG_BLK_DEV_ALI15X3)		+= alim15x3.o
 obj-$(CONFIG_BLK_DEV_AMD74XX)		+= amd74xx.o
 obj-$(CONFIG_BLK_DEV_ATIIXP)		+= atiixp.o
+obj-$(CONFIG_BLK_DEV_CELLEB)		+= scc_pata.o
 obj-$(CONFIG_BLK_DEV_CMD64X)		+= cmd64x.o
 obj-$(CONFIG_BLK_DEV_CS5520)		+= cs5520.o
 obj-$(CONFIG_BLK_DEV_CS5530)		+= cs5530.o
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index b0d4825..561197f 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -1,6 +1,6 @@
 /* $Id: cmd64x.c,v 1.21 2000/01/30 23:23:16
  *
- * linux/drivers/ide/pci/cmd64x.c		Version 1.41	Feb 3, 2007
+ * linux/drivers/ide/pci/cmd64x.c		Version 1.42	Feb 8, 2007
  *
  * cmd64x.c: Enable interrupts at initialization time on Ultra/PCI machines.
  *           Note, this driver is not used at all on other systems because
@@ -189,6 +189,11 @@ static int cmd64x_get_info (char *buffer, char **addr, off_t offset, int count)
 
 #endif	/* defined(DISPLAY_CMD64X_TIMINGS) && defined(CONFIG_PROC_FS) */
 
+static u8 quantize_timing(int timing, int quant)
+{
+	return (timing + quant - 1) / quant;
+}
+
 /*
  * This routine writes the prepared setup/active/recovery counts
  * for a drive into the cmd646 chipset registers to active them.
@@ -268,47 +273,37 @@ static void program_drive_counts (ide_drive_t *drive, int setup_count, int activ
  */
 static u8 cmd64x_tune_pio (ide_drive_t *drive, u8 mode_wanted)
 {
-	int setup_time, active_time, recovery_time;
-	int clock_time, pio_mode, cycle_time;
-	u8 recovery_count2, cycle_count;
-	int setup_count, active_count, recovery_count;
-	int bus_speed = system_bus_clock();
-	ide_pio_data_t  d;
+	int setup_time, active_time, cycle_time;
+	u8  cycle_count, setup_count, active_count, recovery_count;
+	u8  pio_mode;
+	int clock_time = 1000 / system_bus_clock();
+	ide_pio_data_t pio;
 
-	pio_mode = ide_get_best_pio_mode(drive, mode_wanted, 5, &d);
-	cycle_time = d.cycle_time;
+	pio_mode = ide_get_best_pio_mode(drive, mode_wanted, 5, &pio);
+	cycle_time = pio.cycle_time;
 
-	/*
-	 * I copied all this complicated stuff from cmd640.c and made a few
-	 * minor changes.  For now I am just going to pray that it is correct.
-	 */
 	setup_time  = ide_pio_timings[pio_mode].setup_time;
 	active_time = ide_pio_timings[pio_mode].active_time;
-	recovery_time = cycle_time - (setup_time + active_time);
-	clock_time = 1000 / bus_speed;
-	cycle_count = (cycle_time + clock_time - 1) / clock_time;
-
-	setup_count = (setup_time + clock_time - 1) / clock_time;
 
-	active_count = (active_time + clock_time - 1) / clock_time;
+	setup_count  = quantize_timing( setup_time, clock_time);
+	cycle_count  = quantize_timing( cycle_time, clock_time);
+	active_count = quantize_timing(active_time, clock_time);
 
-	recovery_count = (recovery_time + clock_time - 1) / clock_time;
-	recovery_count2 = cycle_count - (setup_count + active_count);
-	if (recovery_count2 > recovery_count)
-		recovery_count = recovery_count2;
+	recovery_count = cycle_count - active_count;
+	/* program_drive_counts() takes care of zero recovery cycles */
 	if (recovery_count > 16) {
 		active_count += recovery_count - 16;
 		recovery_count = 16;
 	}
 	if (active_count > 16)
-		active_count = 16; /* maximum allowed by cmd646 */
+		active_count = 16; /* maximum allowed by cmd64x */
 
 	program_drive_counts (drive, setup_count, active_count, recovery_count);
 
 	cmdprintk("%s: PIO mode wanted %d, selected %d (%dns)%s, "
 		"clocks=%d/%d/%d\n",
 		drive->name, mode_wanted, pio_mode, cycle_time,
-		d.overridden ? " (overriding vendor mode)" : "",
+		pio.overridden ? " (overriding vendor mode)" : "",
 		setup_count, active_count, recovery_count);
 
 	return pio_mode;
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index 53f2550..be4fc96 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -240,12 +240,31 @@ static int __devinit jmicron_init_one(struct pci_dev *dev, const struct pci_devi
 	return 0;
 }
 
+/* If libata is configured, jmicron PCI quirk will configure it such
+ * that the SATA ports are in AHCI function while the PATA ports are
+ * in a separate IDE function.  In such cases, match device class and
+ * attach only to IDE.  If libata isn't configured, keep the old
+ * behavior for backward compatibility.
+ */
+#if defined(CONFIG_ATA) || defined(CONFIG_ATA_MODULE)
+#define JMB_CLASS	PCI_CLASS_STORAGE_IDE << 8
+#define JMB_CLASS_MASK	0xffff00
+#else
+#define JMB_CLASS	0
+#define JMB_CLASS_MASK	0
+#endif
+
 static struct pci_device_id jmicron_pci_tbl[] = {
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361,
+	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 0},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363,
+	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 1},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365,
+	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 2},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366,
+	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 3},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368,
+	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 4},
 	{ 0, },
 };
 
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
new file mode 100644
index 0000000..f84bf79
--- /dev/null
+++ b/drivers/ide/pci/scc_pata.c
@@ -0,0 +1,858 @@
+/*
+ * Support for IDE interfaces on Celleb platform
+ *
+ * (C) Copyright 2006 TOSHIBA CORPORATION
+ *
+ * This code is based on drivers/ide/pci/siimage.c:
+ * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
+ * Copyright (C) 2003		Red Hat <alan@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/hdreg.h>
+#include <linux/ide.h>
+#include <linux/init.h>
+
+#define PCI_DEVICE_ID_TOSHIBA_SCC_ATA            0x01b4
+
+#define SCC_PATA_NAME           "scc IDE"
+
+#define TDVHSEL_MASTER          0x00000001
+#define TDVHSEL_SLAVE           0x00000004
+
+#define MODE_JCUSFEN            0x00000080
+
+#define CCKCTRL_ATARESET        0x00040000
+#define CCKCTRL_BUFCNT          0x00020000
+#define CCKCTRL_CRST            0x00010000
+#define CCKCTRL_OCLKEN          0x00000100
+#define CCKCTRL_ATACLKOEN       0x00000002
+#define CCKCTRL_LCLKEN          0x00000001
+
+#define QCHCD_IOS_SS		0x00000001
+
+#define QCHSD_STPDIAG		0x00020000
+
+#define INTMASK_MSK             0xD1000012
+#define INTSTS_SERROR		0x80000000
+#define INTSTS_PRERR		0x40000000
+#define INTSTS_RERR		0x10000000
+#define INTSTS_ICERR		0x01000000
+#define INTSTS_BMSINT		0x00000010
+#define INTSTS_BMHE		0x00000008
+#define INTSTS_IOIRQS           0x00000004
+#define INTSTS_INTRQ            0x00000002
+#define INTSTS_ACTEINT          0x00000001
+
+#define ECMODE_VALUE 0x01
+
+static struct scc_ports {
+	unsigned long ctl, dma;
+	unsigned char hwif_id;  /* for removing hwif from system */
+} scc_ports[MAX_HWIFS];
+
+/* PIO transfer mode  table */
+/* JCHST */
+static unsigned long JCHSTtbl[2][7] = {
+	{0x0E, 0x05, 0x02, 0x03, 0x02, 0x00, 0x00},   /* 100MHz */
+	{0x13, 0x07, 0x04, 0x04, 0x03, 0x00, 0x00}    /* 133MHz */
+};
+
+/* JCHHT */
+static unsigned long JCHHTtbl[2][7] = {
+	{0x0E, 0x02, 0x02, 0x02, 0x02, 0x00, 0x00},   /* 100MHz */
+	{0x13, 0x03, 0x03, 0x03, 0x03, 0x00, 0x00}    /* 133MHz */
+};
+
+/* JCHCT */
+static unsigned long JCHCTtbl[2][7] = {
+	{0x1D, 0x1D, 0x1C, 0x0B, 0x06, 0x00, 0x00},   /* 100MHz */
+	{0x27, 0x26, 0x26, 0x0E, 0x09, 0x00, 0x00}    /* 133MHz */
+};
+
+
+/* DMA transfer mode  table */
+/* JCHDCTM/JCHDCTS */
+static unsigned long JCHDCTxtbl[2][7] = {
+	{0x0A, 0x06, 0x04, 0x03, 0x01, 0x00, 0x00},   /* 100MHz */
+	{0x0E, 0x09, 0x06, 0x04, 0x02, 0x01, 0x00}    /* 133MHz */
+};
+
+/* JCSTWTM/JCSTWTS  */
+static unsigned long JCSTWTxtbl[2][7] = {
+	{0x06, 0x04, 0x03, 0x02, 0x02, 0x02, 0x00},   /* 100MHz */
+	{0x09, 0x06, 0x04, 0x02, 0x02, 0x02, 0x02}    /* 133MHz */
+};
+
+/* JCTSS */
+static unsigned long JCTSStbl[2][7] = {
+	{0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x00},   /* 100MHz */
+	{0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05}    /* 133MHz */
+};
+
+/* JCENVT */
+static unsigned long JCENVTtbl[2][7] = {
+	{0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00},   /* 100MHz */
+	{0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02}    /* 133MHz */
+};
+
+/* JCACTSELS/JCACTSELM */
+static unsigned long JCACTSELtbl[2][7] = {
+	{0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00},   /* 100MHz */
+	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01}    /* 133MHz */
+};
+
+
+static u8 scc_ide_inb(unsigned long port)
+{
+	u32 data = in_be32((void*)port);
+	return (u8)data;
+}
+
+static u16 scc_ide_inw(unsigned long port)
+{
+	u32 data = in_be32((void*)port);
+	return (u16)data;
+}
+
+static void scc_ide_insw(unsigned long port, void *addr, u32 count)
+{
+	u16 *ptr = (u16 *)addr;
+	while (count--) {
+		*ptr++ = le16_to_cpu(in_be32((void*)port));
+	}
+}
+
+static void scc_ide_insl(unsigned long port, void *addr, u32 count)
+{
+	u16 *ptr = (u16 *)addr;
+	while (count--) {
+		*ptr++ = le16_to_cpu(in_be32((void*)port));
+		*ptr++ = le16_to_cpu(in_be32((void*)port));
+	}
+}
+
+static void scc_ide_outb(u8 addr, unsigned long port)
+{
+	out_be32((void*)port, addr);
+}
+
+static void scc_ide_outw(u16 addr, unsigned long port)
+{
+	out_be32((void*)port, addr);
+}
+
+static void
+scc_ide_outbsync(ide_drive_t * drive, u8 addr, unsigned long port)
+{
+	ide_hwif_t *hwif = HWIF(drive);
+
+	out_be32((void*)port, addr);
+	__asm__ __volatile__("eieio":::"memory");
+	in_be32((void*)(hwif->dma_base + 0x01c));
+	__asm__ __volatile__("eieio":::"memory");
+}
+
+static void
+scc_ide_outsw(unsigned long port, void *addr, u32 count)
+{
+	u16 *ptr = (u16 *)addr;
+	while (count--) {
+		out_be32((void*)port, cpu_to_le16(*ptr++));
+	}
+}
+
+static void
+scc_ide_outsl(unsigned long port, void *addr, u32 count)
+{
+	u16 *ptr = (u16 *)addr;
+	while (count--) {
+		out_be32((void*)port, cpu_to_le16(*ptr++));
+		out_be32((void*)port, cpu_to_le16(*ptr++));
+	}
+}
+
+/**
+ *	scc_ratemask	-	Compute available modes
+ *	@drive: IDE drive
+ *
+ *	Compute the available speeds for the devices on the interface.
+ *	Enforce UDMA33 as a limit if there is no 80pin cable present.
+ */
+
+static u8 scc_ratemask(ide_drive_t *drive)
+{
+	u8 mode = 4;
+
+	if (!eighty_ninty_three(drive))
+		mode = min(mode, (u8)1);
+	return mode;
+}
+
+/**
+ *	scc_tuneproc	-	tune a drive PIO mode
+ *	@drive: drive to tune
+ *	@mode_wanted: the target operating mode
+ *
+ *	Load the timing settings for this device mode into the
+ *	controller.
+ */
+
+static void scc_tuneproc(ide_drive_t *drive, byte mode_wanted)
+{
+	ide_hwif_t *hwif = HWIF(drive);
+	struct scc_ports *ports = ide_get_hwifdata(hwif);
+	unsigned long ctl_base = ports->ctl;
+	unsigned long cckctrl_port = ctl_base + 0xff0;
+	unsigned long piosht_port = ctl_base + 0x000;
+	unsigned long pioct_port = ctl_base + 0x004;
+	unsigned long reg;
+	unsigned char speed = XFER_PIO_0;
+	int offset;
+
+	mode_wanted = ide_get_best_pio_mode(drive, mode_wanted, 4, NULL);
+	switch (mode_wanted) {
+	case 4:
+		speed = XFER_PIO_4;
+		break;
+	case 3:
+		speed = XFER_PIO_3;
+		break;
+	case 2:
+		speed = XFER_PIO_2;
+		break;
+	case 1:
+		speed = XFER_PIO_1;
+		break;
+	case 0:
+	default:
+		speed = XFER_PIO_0;
+		break;
+	}
+
+	reg = in_be32((void __iomem *)cckctrl_port);
+	if (reg & CCKCTRL_ATACLKOEN) {
+		offset = 1; /* 133MHz */
+	} else {
+		offset = 0; /* 100MHz */
+	}
+	reg = JCHSTtbl[offset][mode_wanted] << 16 | JCHHTtbl[offset][mode_wanted];
+	out_be32((void __iomem *)piosht_port, reg);
+	reg = JCHCTtbl[offset][mode_wanted];
+	out_be32((void __iomem *)pioct_port, reg);
+
+	ide_config_drive_speed(drive, speed);
+}
+
+/**
+ *	scc_tune_chipset	-	tune a drive DMA mode
+ *	@drive: Drive to set up
+ *	@xferspeed: speed we want to achieve
+ *
+ *	Load the timing settings for this device mode into the
+ *	controller.
+ */
+
+static int scc_tune_chipset(ide_drive_t *drive, byte xferspeed)
+{
+	ide_hwif_t *hwif = HWIF(drive);
+	u8 speed = ide_rate_filter(scc_ratemask(drive), xferspeed);
+	struct scc_ports *ports = ide_get_hwifdata(hwif);
+	unsigned long ctl_base = ports->ctl;
+	unsigned long cckctrl_port = ctl_base + 0xff0;
+	unsigned long mdmact_port = ctl_base + 0x008;
+	unsigned long mcrcst_port = ctl_base + 0x00c;
+	unsigned long sdmact_port = ctl_base + 0x010;
+	unsigned long scrcst_port = ctl_base + 0x014;
+	unsigned long udenvt_port = ctl_base + 0x018;
+	unsigned long tdvhsel_port   = ctl_base + 0x020;
+	int is_slave = (&hwif->drives[1] == drive);
+	int offset, idx;
+	unsigned long reg;
+	unsigned long jcactsel;
+
+	reg = in_be32((void __iomem *)cckctrl_port);
+	if (reg & CCKCTRL_ATACLKOEN) {
+		offset = 1; /* 133MHz */
+	} else {
+		offset = 0; /* 100MHz */
+	}
+
+	switch (speed) {
+	case XFER_UDMA_6:
+		idx = 6;
+		break;
+	case XFER_UDMA_5:
+		idx = 5;
+		break;
+	case XFER_UDMA_4:
+		idx = 4;
+		break;
+	case XFER_UDMA_3:
+		idx = 3;
+		break;
+	case XFER_UDMA_2:
+		idx = 2;
+		break;
+	case XFER_UDMA_1:
+		idx = 1;
+		break;
+	case XFER_UDMA_0:
+		idx = 0;
+		break;
+	default:
+		return 1;
+	}
+
+	jcactsel = JCACTSELtbl[offset][idx];
+	if (is_slave) {
+		out_be32((void __iomem *)sdmact_port, JCHDCTxtbl[offset][idx]);
+		out_be32((void __iomem *)scrcst_port, JCSTWTxtbl[offset][idx]);
+		jcactsel = jcactsel << 2;
+		out_be32((void __iomem *)tdvhsel_port, (in_be32((void __iomem *)tdvhsel_port) & ~TDVHSEL_SLAVE) | jcactsel);
+	} else {
+		out_be32((void __iomem *)mdmact_port, JCHDCTxtbl[offset][idx]);
+		out_be32((void __iomem *)mcrcst_port, JCSTWTxtbl[offset][idx]);
+		out_be32((void __iomem *)tdvhsel_port, (in_be32((void __iomem *)tdvhsel_port) & ~TDVHSEL_MASTER) | jcactsel);
+	}
+	reg = JCTSStbl[offset][idx] << 16 | JCENVTtbl[offset][idx];
+	out_be32((void __iomem *)udenvt_port, reg);
+
+	return ide_config_drive_speed(drive, speed);
+}
+
+/**
+ *	scc_config_chipset_for_dma	-	configure for DMA
+ *	@drive: drive to configure
+ *
+ *	Called by scc_config_drive_for_dma().
+ */
+
+static int scc_config_chipset_for_dma(ide_drive_t *drive)
+{
+	u8 speed = ide_dma_speed(drive, scc_ratemask(drive));
+
+	if (!speed)
+		return 0;
+
+	if (scc_tune_chipset(drive, speed))
+		return 0;
+
+	return ide_dma_enable(drive);
+}
+
+/**
+ *	scc_configure_drive_for_dma	-	set up for DMA transfers
+ *	@drive: drive we are going to set up
+ *
+ *	Set up the drive for DMA, tune the controller and drive as
+ *	required.
+ *      If the drive isn't suitable for DMA or we hit other problems
+ *      then we will drop down to PIO and set up PIO appropriately.
+ *      (return 1)
+ */
+
+static int scc_config_drive_for_dma(ide_drive_t *drive)
+{
+	if (ide_use_dma(drive) && scc_config_chipset_for_dma(drive))
+		return 0;
+
+	if (ide_use_fast_pio(drive))
+		scc_tuneproc(drive, 4);
+
+	return -1;
+}
+
+/**
+ *	scc_ide_dma_setup	-	begin a DMA phase
+ *	@drive: target device
+ *
+ *	Build an IDE DMA PRD (IDE speak for scatter gather table)
+ *	and then set up the DMA transfer registers.
+ *
+ *	Returns 0 on success. If a PIO fallback is required then 1
+ *	is returned.
+ */
+
+static int scc_dma_setup(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = HWGROUP(drive)->rq;
+	unsigned int reading;
+	u8 dma_stat;
+
+	if (rq_data_dir(rq))
+		reading = 0;
+	else
+		reading = 1 << 3;
+
+	/* fall back to pio! */
+	if (!ide_build_dmatable(drive, rq)) {
+		ide_map_sg(drive, rq);
+		return 1;
+	}
+
+	/* PRD table */
+	out_be32((void __iomem *)hwif->dma_prdtable, hwif->dmatable_dma);
+
+	/* specify r/w */
+	out_be32((void __iomem *)hwif->dma_command, reading);
+
+	/* read dma_status for INTR & ERROR flags */
+	dma_stat = in_be32((void __iomem *)hwif->dma_status);
+
+	/* clear INTR & ERROR flags */
+	out_be32((void __iomem *)hwif->dma_status, dma_stat|6);
+	drive->waiting_for_dma = 1;
+	return 0;
+}
+
+
+/**
+ *	scc_ide_dma_end	-	Stop DMA
+ *	@drive: IDE drive
+ *
+ *	Check and clear INT Status register.
+ *      Then call __ide_dma_end().
+ */
+
+static int scc_ide_dma_end(ide_drive_t * drive)
+{
+	ide_hwif_t *hwif = HWIF(drive);
+	unsigned long intsts_port = hwif->dma_base + 0x014;
+	u32 reg;
+
+	while (1) {
+		reg = in_be32((void __iomem *)intsts_port);
+
+		if (reg & INTSTS_SERROR) {
+			printk(KERN_WARNING "%s: SERROR\n", SCC_PATA_NAME);
+			out_be32((void __iomem *)intsts_port, INTSTS_SERROR|INTSTS_BMSINT);
+
+			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
+			continue;
+		}
+
+		if (reg & INTSTS_PRERR) {
+			u32 maea0, maec0;
+			unsigned long ctl_base = hwif->config_data;
+
+			maea0 = in_be32((void __iomem *)(ctl_base + 0xF50));
+			maec0 = in_be32((void __iomem *)(ctl_base + 0xF54));
+
+			printk(KERN_WARNING "%s: PRERR [addr:%x cmd:%x]\n", SCC_PATA_NAME, maea0, maec0);
+
+			out_be32((void __iomem *)intsts_port, INTSTS_PRERR|INTSTS_BMSINT);
+
+			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
+			continue;
+		}
+
+		if (reg & INTSTS_RERR) {
+			printk(KERN_WARNING "%s: Response Error\n", SCC_PATA_NAME);
+			out_be32((void __iomem *)intsts_port, INTSTS_RERR|INTSTS_BMSINT);
+
+			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
+			continue;
+		}
+
+		if (reg & INTSTS_ICERR) {
+			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
+
+			printk(KERN_WARNING "%s: Illegal Configuration\n", SCC_PATA_NAME);
+			out_be32((void __iomem *)intsts_port, INTSTS_ICERR|INTSTS_BMSINT);
+			continue;
+		}
+
+		if (reg & INTSTS_BMSINT) {
+			printk(KERN_WARNING "%s: Internal Bus Error\n", SCC_PATA_NAME);
+			out_be32((void __iomem *)intsts_port, INTSTS_BMSINT);
+
+			ide_do_reset(drive);
+			continue;
+		}
+
+		if (reg & INTSTS_BMHE) {
+			out_be32((void __iomem *)intsts_port, INTSTS_BMHE);
+			continue;
+		}
+
+		if (reg & INTSTS_ACTEINT) {
+			out_be32((void __iomem *)intsts_port, INTSTS_ACTEINT);
+			continue;
+		}
+
+		if (reg & INTSTS_IOIRQS) {
+			out_be32((void __iomem *)intsts_port, INTSTS_IOIRQS);
+			continue;
+		}
+		break;
+	}
+
+	return __ide_dma_end(drive);
+}
+
+/* returns 1 if dma irq issued, 0 otherwise */
+static int scc_dma_test_irq(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+	u8 dma_stat		= hwif->INB(hwif->dma_status);
+
+	/* return 1 if INTR asserted */
+	if ((dma_stat & 4) == 4)
+		return 1;
+
+	/* Workaround for PTERADD: emulate DMA_INTR when
+	 * - IDE_STATUS[ERR] = 1
+	 * - INT_STATUS[INTRQ] = 1
+	 * - DMA_STATUS[IORACTA] = 1
+	 */
+	if (in_be32((void __iomem *)IDE_ALTSTATUS_REG) & ERR_STAT &&
+	    in_be32((void __iomem *)(hwif->dma_base + 0x014)) & INTSTS_INTRQ &&
+		dma_stat & 1)
+		return 1;
+
+	if (!drive->waiting_for_dma)
+		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
+			drive->name, __FUNCTION__);
+	return 0;
+}
+
+/**
+ *	setup_mmio_scc	-	map CTRL/BMID region
+ *	@dev: PCI device we are configuring
+ *	@name: device name
+ *
+ */
+
+static int setup_mmio_scc (struct pci_dev *dev, const char *name)
+{
+	unsigned long ctl_base = pci_resource_start(dev, 0);
+	unsigned long dma_base = pci_resource_start(dev, 1);
+	unsigned long ctl_size = pci_resource_len(dev, 0);
+	unsigned long dma_size = pci_resource_len(dev, 1);
+	void *ctl_addr;
+	void *dma_addr;
+	int i;
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		if (scc_ports[i].ctl == 0)
+			break;
+	}
+	if (i >= MAX_HWIFS)
+		return -ENOMEM;
+
+	if (!request_mem_region(ctl_base, ctl_size, name)) {
+		printk(KERN_WARNING "%s: IDE controller MMIO ports not available.\n", SCC_PATA_NAME);
+		goto fail_0;
+	}
+
+	if (!request_mem_region(dma_base, dma_size, name)) {
+		printk(KERN_WARNING "%s: IDE controller MMIO ports not available.\n", SCC_PATA_NAME);
+		goto fail_1;
+	}
+
+	if ((ctl_addr = ioremap(ctl_base, ctl_size)) == NULL)
+		goto fail_2;
+
+	if ((dma_addr = ioremap(dma_base, dma_size)) == NULL)
+		goto fail_3;
+
+	pci_set_master(dev);
+	scc_ports[i].ctl = (unsigned long)ctl_addr;
+	scc_ports[i].dma = (unsigned long)dma_addr;
+	pci_set_drvdata(dev, (void *) &scc_ports[i]);
+
+	return 1;
+
+ fail_3:
+	iounmap(ctl_addr);
+ fail_2:
+	release_mem_region(dma_base, dma_size);
+ fail_1:
+	release_mem_region(ctl_base, ctl_size);
+ fail_0:
+	return -ENOMEM;
+}
+
+/**
+ *	init_setup_scc	-	set up an SCC PATA Controller
+ *	@dev: PCI device
+ *	@d: IDE PCI device
+ *
+ *	Perform the initial set up for this device.
+ */
+
+static int __devinit init_setup_scc(struct pci_dev *dev, ide_pci_device_t *d)
+{
+	unsigned long ctl_base;
+	unsigned long dma_base;
+	unsigned long cckctrl_port;
+	unsigned long intmask_port;
+	unsigned long mode_port;
+	unsigned long ecmode_port;
+	unsigned long dma_status_port;
+	u32 reg = 0;
+	struct scc_ports *ports;
+	int rc;
+
+	rc = setup_mmio_scc(dev, d->name);
+	if (rc < 0) {
+		return rc;
+	}
+
+	ports = pci_get_drvdata(dev);
+	ctl_base = ports->ctl;
+	dma_base = ports->dma;
+	cckctrl_port = ctl_base + 0xff0;
+	intmask_port = dma_base + 0x010;
+	mode_port = ctl_base + 0x024;
+	ecmode_port = ctl_base + 0xf00;
+	dma_status_port = dma_base + 0x004;
+
+	/* controller initialization */
+	reg = 0;
+	out_be32((void*)cckctrl_port, reg);
+	reg |= CCKCTRL_ATACLKOEN;
+	out_be32((void*)cckctrl_port, reg);
+	reg |= CCKCTRL_LCLKEN | CCKCTRL_OCLKEN;
+	out_be32((void*)cckctrl_port, reg);
+	reg |= CCKCTRL_CRST;
+	out_be32((void*)cckctrl_port, reg);
+
+	for (;;) {
+		reg = in_be32((void*)cckctrl_port);
+		if (reg & CCKCTRL_CRST)
+			break;
+		udelay(5000);
+	}
+
+	reg |= CCKCTRL_ATARESET;
+	out_be32((void*)cckctrl_port, reg);
+
+	out_be32((void*)ecmode_port, ECMODE_VALUE);
+	out_be32((void*)mode_port, MODE_JCUSFEN);
+	out_be32((void*)intmask_port, INTMASK_MSK);
+
+	return ide_setup_pci_device(dev, d);
+}
+
+/**
+ *	init_mmio_iops_scc	-	set up the iops for MMIO
+ *	@hwif: interface to set up
+ *
+ */
+
+static void __devinit init_mmio_iops_scc(ide_hwif_t *hwif)
+{
+	struct pci_dev *dev = hwif->pci_dev;
+	struct scc_ports *ports = pci_get_drvdata(dev);
+	unsigned long dma_base = ports->dma;
+
+	ide_set_hwifdata(hwif, ports);
+
+	hwif->INB = scc_ide_inb;
+	hwif->INW = scc_ide_inw;
+	hwif->INSW = scc_ide_insw;
+	hwif->INSL = scc_ide_insl;
+	hwif->OUTB = scc_ide_outb;
+	hwif->OUTBSYNC = scc_ide_outbsync;
+	hwif->OUTW = scc_ide_outw;
+	hwif->OUTSW = scc_ide_outsw;
+	hwif->OUTSL = scc_ide_outsl;
+
+	hwif->io_ports[IDE_DATA_OFFSET] = dma_base + 0x20;
+	hwif->io_ports[IDE_ERROR_OFFSET] = dma_base + 0x24;
+	hwif->io_ports[IDE_NSECTOR_OFFSET] = dma_base + 0x28;
+	hwif->io_ports[IDE_SECTOR_OFFSET] = dma_base + 0x2c;
+	hwif->io_ports[IDE_LCYL_OFFSET] = dma_base + 0x30;
+	hwif->io_ports[IDE_HCYL_OFFSET] = dma_base + 0x34;
+	hwif->io_ports[IDE_SELECT_OFFSET] = dma_base + 0x38;
+	hwif->io_ports[IDE_STATUS_OFFSET] = dma_base + 0x3c;
+	hwif->io_ports[IDE_CONTROL_OFFSET] = dma_base + 0x40;
+
+	hwif->irq = hwif->pci_dev->irq;
+	hwif->dma_base = dma_base;
+	hwif->config_data = ports->ctl;
+	hwif->mmio = 1;
+}
+
+/**
+ *	init_iops_scc	-	set up iops
+ *	@hwif: interface to set up
+ *
+ *	Do the basic setup for the SCC hardware interface
+ *	and then do the MMIO setup.
+ */
+
+static void __devinit init_iops_scc(ide_hwif_t *hwif)
+{
+	struct pci_dev *dev =  hwif->pci_dev;
+	hwif->hwif_data = NULL;
+	if (pci_get_drvdata(dev) == NULL)
+		return;
+	init_mmio_iops_scc(hwif);
+}
+
+/**
+ *	init_hwif_scc	-	set up hwif
+ *	@hwif: interface to set up
+ *
+ *	We do the basic set up of the interface structure. The SCC
+ *	requires several custom handlers so we override the default
+ *	ide DMA handlers appropriately.
+ */
+
+static void __devinit init_hwif_scc(ide_hwif_t *hwif)
+{
+	struct scc_ports *ports = ide_get_hwifdata(hwif);
+
+	ports->hwif_id = hwif->index;
+
+	hwif->dma_command = hwif->dma_base;
+	hwif->dma_status = hwif->dma_base + 0x04;
+	hwif->dma_prdtable = hwif->dma_base + 0x08;
+
+	/* PTERADD */
+	out_be32((void __iomem *)(hwif->dma_base + 0x018), hwif->dmatable_dma);
+
+	hwif->dma_setup = scc_dma_setup;
+	hwif->ide_dma_end = scc_ide_dma_end;
+	hwif->speedproc = scc_tune_chipset;
+	hwif->tuneproc = scc_tuneproc;
+	hwif->ide_dma_check = scc_config_drive_for_dma;
+	hwif->ide_dma_test_irq = scc_dma_test_irq;
+
+	hwif->drives[0].autotune = IDE_TUNE_AUTO;
+	hwif->drives[1].autotune = IDE_TUNE_AUTO;
+
+	if (in_be32((void __iomem *)(hwif->config_data + 0xff0)) & CCKCTRL_ATACLKOEN) {
+		hwif->ultra_mask = 0x7f; /* 133MHz */
+	} else {
+		hwif->ultra_mask = 0x3f; /* 100MHz */
+	}
+	hwif->mwdma_mask = 0x00;
+	hwif->swdma_mask = 0x00;
+	hwif->atapi_dma = 1;
+
+	/* we support 80c cable only. */
+	hwif->udma_four = 1;
+
+	hwif->autodma = 0;
+	if (!noautodma)
+		hwif->autodma = 1;
+	hwif->drives[0].autodma = hwif->autodma;
+	hwif->drives[1].autodma = hwif->autodma;
+}
+
+#define DECLARE_SCC_DEV(name_str)			\
+  {							\
+      .name		= name_str,			\
+      .init_setup	= init_setup_scc,		\
+      .init_iops	= init_iops_scc,		\
+      .init_hwif	= init_hwif_scc,		\
+      .channels	= 1,					\
+      .autodma	= AUTODMA,				\
+      .bootable	= ON_BOARD,				\
+  }
+
+static ide_pci_device_t scc_chipsets[] __devinitdata = {
+	/* 0 */ DECLARE_SCC_DEV("sccIDE"),
+};
+
+/**
+ *	scc_init_one	-	pci layer discovery entry
+ *	@dev: PCI device
+ *	@id: ident table entry
+ *
+ *	Called by the PCI code when it finds an SCC PATA controller.
+ *	We then use the IDE PCI generic helper to do most of the work.
+ */
+
+static int __devinit scc_init_one(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	ide_pci_device_t *d = &scc_chipsets[id->driver_data];
+	return d->init_setup(dev, d);
+}
+
+/**
+ *	scc_remove	-	pci layer remove entry
+ *	@dev: PCI device
+ *
+ *	Called by the PCI code when it removes an SCC PATA controller.
+ */
+
+static void __devexit scc_remove(struct pci_dev *dev)
+{
+	struct scc_ports *ports = pci_get_drvdata(dev);
+	ide_hwif_t *hwif = &ide_hwifs[ports->hwif_id];
+	unsigned long ctl_base = pci_resource_start(dev, 0);
+	unsigned long dma_base = pci_resource_start(dev, 1);
+	unsigned long ctl_size = pci_resource_len(dev, 0);
+	unsigned long dma_size = pci_resource_len(dev, 1);
+
+	if (hwif->dmatable_cpu) {
+		pci_free_consistent(hwif->pci_dev,
+				    PRD_ENTRIES * PRD_BYTES,
+				    hwif->dmatable_cpu,
+				    hwif->dmatable_dma);
+		hwif->dmatable_cpu = NULL;
+	}
+
+	ide_unregister(hwif->index);
+
+	hwif->chipset = ide_unknown;
+	iounmap((void*)ports->dma);
+	iounmap((void*)ports->ctl);
+	release_mem_region(dma_base, dma_size);
+	release_mem_region(ctl_base, ctl_size);
+	memset(ports, 0, sizeof(*ports));
+}
+
+static struct pci_device_id scc_pci_tbl[] = {
+	{ PCI_VENDOR_ID_TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_SCC_ATA,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, scc_pci_tbl);
+
+static struct pci_driver driver = {
+	.name = "SCC IDE",
+	.id_table = scc_pci_tbl,
+	.probe = scc_init_one,
+	.remove = scc_remove,
+};
+
+static int scc_ide_init(void)
+{
+	return ide_pci_register_driver(&driver);
+}
+
+module_init(scc_ide_init);
+/* -- No exit code?
+static void scc_ide_exit(void)
+{
+	ide_pci_unregister_driver(&driver);
+}
+module_exit(scc_ide_exit);
+ */
+
+
+MODULE_DESCRIPTION("PCI driver module for Toshiba SCC IDE");
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/ppc/scc_pata.c b/drivers/ide/ppc/scc_pata.c
deleted file mode 100644
index f84bf79..0000000
--- a/drivers/ide/ppc/scc_pata.c
+++ /dev/null
@@ -1,858 +0,0 @@
-/*
- * Support for IDE interfaces on Celleb platform
- *
- * (C) Copyright 2006 TOSHIBA CORPORATION
- *
- * This code is based on drivers/ide/pci/siimage.c:
- * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
- * Copyright (C) 2003		Red Hat <alan@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- */
-
-#include <linux/types.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/delay.h>
-#include <linux/hdreg.h>
-#include <linux/ide.h>
-#include <linux/init.h>
-
-#define PCI_DEVICE_ID_TOSHIBA_SCC_ATA            0x01b4
-
-#define SCC_PATA_NAME           "scc IDE"
-
-#define TDVHSEL_MASTER          0x00000001
-#define TDVHSEL_SLAVE           0x00000004
-
-#define MODE_JCUSFEN            0x00000080
-
-#define CCKCTRL_ATARESET        0x00040000
-#define CCKCTRL_BUFCNT          0x00020000
-#define CCKCTRL_CRST            0x00010000
-#define CCKCTRL_OCLKEN          0x00000100
-#define CCKCTRL_ATACLKOEN       0x00000002
-#define CCKCTRL_LCLKEN          0x00000001
-
-#define QCHCD_IOS_SS		0x00000001
-
-#define QCHSD_STPDIAG		0x00020000
-
-#define INTMASK_MSK             0xD1000012
-#define INTSTS_SERROR		0x80000000
-#define INTSTS_PRERR		0x40000000
-#define INTSTS_RERR		0x10000000
-#define INTSTS_ICERR		0x01000000
-#define INTSTS_BMSINT		0x00000010
-#define INTSTS_BMHE		0x00000008
-#define INTSTS_IOIRQS           0x00000004
-#define INTSTS_INTRQ            0x00000002
-#define INTSTS_ACTEINT          0x00000001
-
-#define ECMODE_VALUE 0x01
-
-static struct scc_ports {
-	unsigned long ctl, dma;
-	unsigned char hwif_id;  /* for removing hwif from system */
-} scc_ports[MAX_HWIFS];
-
-/* PIO transfer mode  table */
-/* JCHST */
-static unsigned long JCHSTtbl[2][7] = {
-	{0x0E, 0x05, 0x02, 0x03, 0x02, 0x00, 0x00},   /* 100MHz */
-	{0x13, 0x07, 0x04, 0x04, 0x03, 0x00, 0x00}    /* 133MHz */
-};
-
-/* JCHHT */
-static unsigned long JCHHTtbl[2][7] = {
-	{0x0E, 0x02, 0x02, 0x02, 0x02, 0x00, 0x00},   /* 100MHz */
-	{0x13, 0x03, 0x03, 0x03, 0x03, 0x00, 0x00}    /* 133MHz */
-};
-
-/* JCHCT */
-static unsigned long JCHCTtbl[2][7] = {
-	{0x1D, 0x1D, 0x1C, 0x0B, 0x06, 0x00, 0x00},   /* 100MHz */
-	{0x27, 0x26, 0x26, 0x0E, 0x09, 0x00, 0x00}    /* 133MHz */
-};
-
-
-/* DMA transfer mode  table */
-/* JCHDCTM/JCHDCTS */
-static unsigned long JCHDCTxtbl[2][7] = {
-	{0x0A, 0x06, 0x04, 0x03, 0x01, 0x00, 0x00},   /* 100MHz */
-	{0x0E, 0x09, 0x06, 0x04, 0x02, 0x01, 0x00}    /* 133MHz */
-};
-
-/* JCSTWTM/JCSTWTS  */
-static unsigned long JCSTWTxtbl[2][7] = {
-	{0x06, 0x04, 0x03, 0x02, 0x02, 0x02, 0x00},   /* 100MHz */
-	{0x09, 0x06, 0x04, 0x02, 0x02, 0x02, 0x02}    /* 133MHz */
-};
-
-/* JCTSS */
-static unsigned long JCTSStbl[2][7] = {
-	{0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x00},   /* 100MHz */
-	{0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05}    /* 133MHz */
-};
-
-/* JCENVT */
-static unsigned long JCENVTtbl[2][7] = {
-	{0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00},   /* 100MHz */
-	{0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02}    /* 133MHz */
-};
-
-/* JCACTSELS/JCACTSELM */
-static unsigned long JCACTSELtbl[2][7] = {
-	{0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00},   /* 100MHz */
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01}    /* 133MHz */
-};
-
-
-static u8 scc_ide_inb(unsigned long port)
-{
-	u32 data = in_be32((void*)port);
-	return (u8)data;
-}
-
-static u16 scc_ide_inw(unsigned long port)
-{
-	u32 data = in_be32((void*)port);
-	return (u16)data;
-}
-
-static void scc_ide_insw(unsigned long port, void *addr, u32 count)
-{
-	u16 *ptr = (u16 *)addr;
-	while (count--) {
-		*ptr++ = le16_to_cpu(in_be32((void*)port));
-	}
-}
-
-static void scc_ide_insl(unsigned long port, void *addr, u32 count)
-{
-	u16 *ptr = (u16 *)addr;
-	while (count--) {
-		*ptr++ = le16_to_cpu(in_be32((void*)port));
-		*ptr++ = le16_to_cpu(in_be32((void*)port));
-	}
-}
-
-static void scc_ide_outb(u8 addr, unsigned long port)
-{
-	out_be32((void*)port, addr);
-}
-
-static void scc_ide_outw(u16 addr, unsigned long port)
-{
-	out_be32((void*)port, addr);
-}
-
-static void
-scc_ide_outbsync(ide_drive_t * drive, u8 addr, unsigned long port)
-{
-	ide_hwif_t *hwif = HWIF(drive);
-
-	out_be32((void*)port, addr);
-	__asm__ __volatile__("eieio":::"memory");
-	in_be32((void*)(hwif->dma_base + 0x01c));
-	__asm__ __volatile__("eieio":::"memory");
-}
-
-static void
-scc_ide_outsw(unsigned long port, void *addr, u32 count)
-{
-	u16 *ptr = (u16 *)addr;
-	while (count--) {
-		out_be32((void*)port, cpu_to_le16(*ptr++));
-	}
-}
-
-static void
-scc_ide_outsl(unsigned long port, void *addr, u32 count)
-{
-	u16 *ptr = (u16 *)addr;
-	while (count--) {
-		out_be32((void*)port, cpu_to_le16(*ptr++));
-		out_be32((void*)port, cpu_to_le16(*ptr++));
-	}
-}
-
-/**
- *	scc_ratemask	-	Compute available modes
- *	@drive: IDE drive
- *
- *	Compute the available speeds for the devices on the interface.
- *	Enforce UDMA33 as a limit if there is no 80pin cable present.
- */
-
-static u8 scc_ratemask(ide_drive_t *drive)
-{
-	u8 mode = 4;
-
-	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
-	return mode;
-}
-
-/**
- *	scc_tuneproc	-	tune a drive PIO mode
- *	@drive: drive to tune
- *	@mode_wanted: the target operating mode
- *
- *	Load the timing settings for this device mode into the
- *	controller.
- */
-
-static void scc_tuneproc(ide_drive_t *drive, byte mode_wanted)
-{
-	ide_hwif_t *hwif = HWIF(drive);
-	struct scc_ports *ports = ide_get_hwifdata(hwif);
-	unsigned long ctl_base = ports->ctl;
-	unsigned long cckctrl_port = ctl_base + 0xff0;
-	unsigned long piosht_port = ctl_base + 0x000;
-	unsigned long pioct_port = ctl_base + 0x004;
-	unsigned long reg;
-	unsigned char speed = XFER_PIO_0;
-	int offset;
-
-	mode_wanted = ide_get_best_pio_mode(drive, mode_wanted, 4, NULL);
-	switch (mode_wanted) {
-	case 4:
-		speed = XFER_PIO_4;
-		break;
-	case 3:
-		speed = XFER_PIO_3;
-		break;
-	case 2:
-		speed = XFER_PIO_2;
-		break;
-	case 1:
-		speed = XFER_PIO_1;
-		break;
-	case 0:
-	default:
-		speed = XFER_PIO_0;
-		break;
-	}
-
-	reg = in_be32((void __iomem *)cckctrl_port);
-	if (reg & CCKCTRL_ATACLKOEN) {
-		offset = 1; /* 133MHz */
-	} else {
-		offset = 0; /* 100MHz */
-	}
-	reg = JCHSTtbl[offset][mode_wanted] << 16 | JCHHTtbl[offset][mode_wanted];
-	out_be32((void __iomem *)piosht_port, reg);
-	reg = JCHCTtbl[offset][mode_wanted];
-	out_be32((void __iomem *)pioct_port, reg);
-
-	ide_config_drive_speed(drive, speed);
-}
-
-/**
- *	scc_tune_chipset	-	tune a drive DMA mode
- *	@drive: Drive to set up
- *	@xferspeed: speed we want to achieve
- *
- *	Load the timing settings for this device mode into the
- *	controller.
- */
-
-static int scc_tune_chipset(ide_drive_t *drive, byte xferspeed)
-{
-	ide_hwif_t *hwif = HWIF(drive);
-	u8 speed = ide_rate_filter(scc_ratemask(drive), xferspeed);
-	struct scc_ports *ports = ide_get_hwifdata(hwif);
-	unsigned long ctl_base = ports->ctl;
-	unsigned long cckctrl_port = ctl_base + 0xff0;
-	unsigned long mdmact_port = ctl_base + 0x008;
-	unsigned long mcrcst_port = ctl_base + 0x00c;
-	unsigned long sdmact_port = ctl_base + 0x010;
-	unsigned long scrcst_port = ctl_base + 0x014;
-	unsigned long udenvt_port = ctl_base + 0x018;
-	unsigned long tdvhsel_port   = ctl_base + 0x020;
-	int is_slave = (&hwif->drives[1] == drive);
-	int offset, idx;
-	unsigned long reg;
-	unsigned long jcactsel;
-
-	reg = in_be32((void __iomem *)cckctrl_port);
-	if (reg & CCKCTRL_ATACLKOEN) {
-		offset = 1; /* 133MHz */
-	} else {
-		offset = 0; /* 100MHz */
-	}
-
-	switch (speed) {
-	case XFER_UDMA_6:
-		idx = 6;
-		break;
-	case XFER_UDMA_5:
-		idx = 5;
-		break;
-	case XFER_UDMA_4:
-		idx = 4;
-		break;
-	case XFER_UDMA_3:
-		idx = 3;
-		break;
-	case XFER_UDMA_2:
-		idx = 2;
-		break;
-	case XFER_UDMA_1:
-		idx = 1;
-		break;
-	case XFER_UDMA_0:
-		idx = 0;
-		break;
-	default:
-		return 1;
-	}
-
-	jcactsel = JCACTSELtbl[offset][idx];
-	if (is_slave) {
-		out_be32((void __iomem *)sdmact_port, JCHDCTxtbl[offset][idx]);
-		out_be32((void __iomem *)scrcst_port, JCSTWTxtbl[offset][idx]);
-		jcactsel = jcactsel << 2;
-		out_be32((void __iomem *)tdvhsel_port, (in_be32((void __iomem *)tdvhsel_port) & ~TDVHSEL_SLAVE) | jcactsel);
-	} else {
-		out_be32((void __iomem *)mdmact_port, JCHDCTxtbl[offset][idx]);
-		out_be32((void __iomem *)mcrcst_port, JCSTWTxtbl[offset][idx]);
-		out_be32((void __iomem *)tdvhsel_port, (in_be32((void __iomem *)tdvhsel_port) & ~TDVHSEL_MASTER) | jcactsel);
-	}
-	reg = JCTSStbl[offset][idx] << 16 | JCENVTtbl[offset][idx];
-	out_be32((void __iomem *)udenvt_port, reg);
-
-	return ide_config_drive_speed(drive, speed);
-}
-
-/**
- *	scc_config_chipset_for_dma	-	configure for DMA
- *	@drive: drive to configure
- *
- *	Called by scc_config_drive_for_dma().
- */
-
-static int scc_config_chipset_for_dma(ide_drive_t *drive)
-{
-	u8 speed = ide_dma_speed(drive, scc_ratemask(drive));
-
-	if (!speed)
-		return 0;
-
-	if (scc_tune_chipset(drive, speed))
-		return 0;
-
-	return ide_dma_enable(drive);
-}
-
-/**
- *	scc_configure_drive_for_dma	-	set up for DMA transfers
- *	@drive: drive we are going to set up
- *
- *	Set up the drive for DMA, tune the controller and drive as
- *	required.
- *      If the drive isn't suitable for DMA or we hit other problems
- *      then we will drop down to PIO and set up PIO appropriately.
- *      (return 1)
- */
-
-static int scc_config_drive_for_dma(ide_drive_t *drive)
-{
-	if (ide_use_dma(drive) && scc_config_chipset_for_dma(drive))
-		return 0;
-
-	if (ide_use_fast_pio(drive))
-		scc_tuneproc(drive, 4);
-
-	return -1;
-}
-
-/**
- *	scc_ide_dma_setup	-	begin a DMA phase
- *	@drive: target device
- *
- *	Build an IDE DMA PRD (IDE speak for scatter gather table)
- *	and then set up the DMA transfer registers.
- *
- *	Returns 0 on success. If a PIO fallback is required then 1
- *	is returned.
- */
-
-static int scc_dma_setup(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = HWGROUP(drive)->rq;
-	unsigned int reading;
-	u8 dma_stat;
-
-	if (rq_data_dir(rq))
-		reading = 0;
-	else
-		reading = 1 << 3;
-
-	/* fall back to pio! */
-	if (!ide_build_dmatable(drive, rq)) {
-		ide_map_sg(drive, rq);
-		return 1;
-	}
-
-	/* PRD table */
-	out_be32((void __iomem *)hwif->dma_prdtable, hwif->dmatable_dma);
-
-	/* specify r/w */
-	out_be32((void __iomem *)hwif->dma_command, reading);
-
-	/* read dma_status for INTR & ERROR flags */
-	dma_stat = in_be32((void __iomem *)hwif->dma_status);
-
-	/* clear INTR & ERROR flags */
-	out_be32((void __iomem *)hwif->dma_status, dma_stat|6);
-	drive->waiting_for_dma = 1;
-	return 0;
-}
-
-
-/**
- *	scc_ide_dma_end	-	Stop DMA
- *	@drive: IDE drive
- *
- *	Check and clear INT Status register.
- *      Then call __ide_dma_end().
- */
-
-static int scc_ide_dma_end(ide_drive_t * drive)
-{
-	ide_hwif_t *hwif = HWIF(drive);
-	unsigned long intsts_port = hwif->dma_base + 0x014;
-	u32 reg;
-
-	while (1) {
-		reg = in_be32((void __iomem *)intsts_port);
-
-		if (reg & INTSTS_SERROR) {
-			printk(KERN_WARNING "%s: SERROR\n", SCC_PATA_NAME);
-			out_be32((void __iomem *)intsts_port, INTSTS_SERROR|INTSTS_BMSINT);
-
-			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
-			continue;
-		}
-
-		if (reg & INTSTS_PRERR) {
-			u32 maea0, maec0;
-			unsigned long ctl_base = hwif->config_data;
-
-			maea0 = in_be32((void __iomem *)(ctl_base + 0xF50));
-			maec0 = in_be32((void __iomem *)(ctl_base + 0xF54));
-
-			printk(KERN_WARNING "%s: PRERR [addr:%x cmd:%x]\n", SCC_PATA_NAME, maea0, maec0);
-
-			out_be32((void __iomem *)intsts_port, INTSTS_PRERR|INTSTS_BMSINT);
-
-			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
-			continue;
-		}
-
-		if (reg & INTSTS_RERR) {
-			printk(KERN_WARNING "%s: Response Error\n", SCC_PATA_NAME);
-			out_be32((void __iomem *)intsts_port, INTSTS_RERR|INTSTS_BMSINT);
-
-			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
-			continue;
-		}
-
-		if (reg & INTSTS_ICERR) {
-			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
-
-			printk(KERN_WARNING "%s: Illegal Configuration\n", SCC_PATA_NAME);
-			out_be32((void __iomem *)intsts_port, INTSTS_ICERR|INTSTS_BMSINT);
-			continue;
-		}
-
-		if (reg & INTSTS_BMSINT) {
-			printk(KERN_WARNING "%s: Internal Bus Error\n", SCC_PATA_NAME);
-			out_be32((void __iomem *)intsts_port, INTSTS_BMSINT);
-
-			ide_do_reset(drive);
-			continue;
-		}
-
-		if (reg & INTSTS_BMHE) {
-			out_be32((void __iomem *)intsts_port, INTSTS_BMHE);
-			continue;
-		}
-
-		if (reg & INTSTS_ACTEINT) {
-			out_be32((void __iomem *)intsts_port, INTSTS_ACTEINT);
-			continue;
-		}
-
-		if (reg & INTSTS_IOIRQS) {
-			out_be32((void __iomem *)intsts_port, INTSTS_IOIRQS);
-			continue;
-		}
-		break;
-	}
-
-	return __ide_dma_end(drive);
-}
-
-/* returns 1 if dma irq issued, 0 otherwise */
-static int scc_dma_test_irq(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->INB(hwif->dma_status);
-
-	/* return 1 if INTR asserted */
-	if ((dma_stat & 4) == 4)
-		return 1;
-
-	/* Workaround for PTERADD: emulate DMA_INTR when
-	 * - IDE_STATUS[ERR] = 1
-	 * - INT_STATUS[INTRQ] = 1
-	 * - DMA_STATUS[IORACTA] = 1
-	 */
-	if (in_be32((void __iomem *)IDE_ALTSTATUS_REG) & ERR_STAT &&
-	    in_be32((void __iomem *)(hwif->dma_base + 0x014)) & INTSTS_INTRQ &&
-		dma_stat & 1)
-		return 1;
-
-	if (!drive->waiting_for_dma)
-		printk(KERN_WARNING "%s: (%s) called while not waiting\n",
-			drive->name, __FUNCTION__);
-	return 0;
-}
-
-/**
- *	setup_mmio_scc	-	map CTRL/BMID region
- *	@dev: PCI device we are configuring
- *	@name: device name
- *
- */
-
-static int setup_mmio_scc (struct pci_dev *dev, const char *name)
-{
-	unsigned long ctl_base = pci_resource_start(dev, 0);
-	unsigned long dma_base = pci_resource_start(dev, 1);
-	unsigned long ctl_size = pci_resource_len(dev, 0);
-	unsigned long dma_size = pci_resource_len(dev, 1);
-	void *ctl_addr;
-	void *dma_addr;
-	int i;
-
-	for (i = 0; i < MAX_HWIFS; i++) {
-		if (scc_ports[i].ctl == 0)
-			break;
-	}
-	if (i >= MAX_HWIFS)
-		return -ENOMEM;
-
-	if (!request_mem_region(ctl_base, ctl_size, name)) {
-		printk(KERN_WARNING "%s: IDE controller MMIO ports not available.\n", SCC_PATA_NAME);
-		goto fail_0;
-	}
-
-	if (!request_mem_region(dma_base, dma_size, name)) {
-		printk(KERN_WARNING "%s: IDE controller MMIO ports not available.\n", SCC_PATA_NAME);
-		goto fail_1;
-	}
-
-	if ((ctl_addr = ioremap(ctl_base, ctl_size)) == NULL)
-		goto fail_2;
-
-	if ((dma_addr = ioremap(dma_base, dma_size)) == NULL)
-		goto fail_3;
-
-	pci_set_master(dev);
-	scc_ports[i].ctl = (unsigned long)ctl_addr;
-	scc_ports[i].dma = (unsigned long)dma_addr;
-	pci_set_drvdata(dev, (void *) &scc_ports[i]);
-
-	return 1;
-
- fail_3:
-	iounmap(ctl_addr);
- fail_2:
-	release_mem_region(dma_base, dma_size);
- fail_1:
-	release_mem_region(ctl_base, ctl_size);
- fail_0:
-	return -ENOMEM;
-}
-
-/**
- *	init_setup_scc	-	set up an SCC PATA Controller
- *	@dev: PCI device
- *	@d: IDE PCI device
- *
- *	Perform the initial set up for this device.
- */
-
-static int __devinit init_setup_scc(struct pci_dev *dev, ide_pci_device_t *d)
-{
-	unsigned long ctl_base;
-	unsigned long dma_base;
-	unsigned long cckctrl_port;
-	unsigned long intmask_port;
-	unsigned long mode_port;
-	unsigned long ecmode_port;
-	unsigned long dma_status_port;
-	u32 reg = 0;
-	struct scc_ports *ports;
-	int rc;
-
-	rc = setup_mmio_scc(dev, d->name);
-	if (rc < 0) {
-		return rc;
-	}
-
-	ports = pci_get_drvdata(dev);
-	ctl_base = ports->ctl;
-	dma_base = ports->dma;
-	cckctrl_port = ctl_base + 0xff0;
-	intmask_port = dma_base + 0x010;
-	mode_port = ctl_base + 0x024;
-	ecmode_port = ctl_base + 0xf00;
-	dma_status_port = dma_base + 0x004;
-
-	/* controller initialization */
-	reg = 0;
-	out_be32((void*)cckctrl_port, reg);
-	reg |= CCKCTRL_ATACLKOEN;
-	out_be32((void*)cckctrl_port, reg);
-	reg |= CCKCTRL_LCLKEN | CCKCTRL_OCLKEN;
-	out_be32((void*)cckctrl_port, reg);
-	reg |= CCKCTRL_CRST;
-	out_be32((void*)cckctrl_port, reg);
-
-	for (;;) {
-		reg = in_be32((void*)cckctrl_port);
-		if (reg & CCKCTRL_CRST)
-			break;
-		udelay(5000);
-	}
-
-	reg |= CCKCTRL_ATARESET;
-	out_be32((void*)cckctrl_port, reg);
-
-	out_be32((void*)ecmode_port, ECMODE_VALUE);
-	out_be32((void*)mode_port, MODE_JCUSFEN);
-	out_be32((void*)intmask_port, INTMASK_MSK);
-
-	return ide_setup_pci_device(dev, d);
-}
-
-/**
- *	init_mmio_iops_scc	-	set up the iops for MMIO
- *	@hwif: interface to set up
- *
- */
-
-static void __devinit init_mmio_iops_scc(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = hwif->pci_dev;
-	struct scc_ports *ports = pci_get_drvdata(dev);
-	unsigned long dma_base = ports->dma;
-
-	ide_set_hwifdata(hwif, ports);
-
-	hwif->INB = scc_ide_inb;
-	hwif->INW = scc_ide_inw;
-	hwif->INSW = scc_ide_insw;
-	hwif->INSL = scc_ide_insl;
-	hwif->OUTB = scc_ide_outb;
-	hwif->OUTBSYNC = scc_ide_outbsync;
-	hwif->OUTW = scc_ide_outw;
-	hwif->OUTSW = scc_ide_outsw;
-	hwif->OUTSL = scc_ide_outsl;
-
-	hwif->io_ports[IDE_DATA_OFFSET] = dma_base + 0x20;
-	hwif->io_ports[IDE_ERROR_OFFSET] = dma_base + 0x24;
-	hwif->io_ports[IDE_NSECTOR_OFFSET] = dma_base + 0x28;
-	hwif->io_ports[IDE_SECTOR_OFFSET] = dma_base + 0x2c;
-	hwif->io_ports[IDE_LCYL_OFFSET] = dma_base + 0x30;
-	hwif->io_ports[IDE_HCYL_OFFSET] = dma_base + 0x34;
-	hwif->io_ports[IDE_SELECT_OFFSET] = dma_base + 0x38;
-	hwif->io_ports[IDE_STATUS_OFFSET] = dma_base + 0x3c;
-	hwif->io_ports[IDE_CONTROL_OFFSET] = dma_base + 0x40;
-
-	hwif->irq = hwif->pci_dev->irq;
-	hwif->dma_base = dma_base;
-	hwif->config_data = ports->ctl;
-	hwif->mmio = 1;
-}
-
-/**
- *	init_iops_scc	-	set up iops
- *	@hwif: interface to set up
- *
- *	Do the basic setup for the SCC hardware interface
- *	and then do the MMIO setup.
- */
-
-static void __devinit init_iops_scc(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev =  hwif->pci_dev;
-	hwif->hwif_data = NULL;
-	if (pci_get_drvdata(dev) == NULL)
-		return;
-	init_mmio_iops_scc(hwif);
-}
-
-/**
- *	init_hwif_scc	-	set up hwif
- *	@hwif: interface to set up
- *
- *	We do the basic set up of the interface structure. The SCC
- *	requires several custom handlers so we override the default
- *	ide DMA handlers appropriately.
- */
-
-static void __devinit init_hwif_scc(ide_hwif_t *hwif)
-{
-	struct scc_ports *ports = ide_get_hwifdata(hwif);
-
-	ports->hwif_id = hwif->index;
-
-	hwif->dma_command = hwif->dma_base;
-	hwif->dma_status = hwif->dma_base + 0x04;
-	hwif->dma_prdtable = hwif->dma_base + 0x08;
-
-	/* PTERADD */
-	out_be32((void __iomem *)(hwif->dma_base + 0x018), hwif->dmatable_dma);
-
-	hwif->dma_setup = scc_dma_setup;
-	hwif->ide_dma_end = scc_ide_dma_end;
-	hwif->speedproc = scc_tune_chipset;
-	hwif->tuneproc = scc_tuneproc;
-	hwif->ide_dma_check = scc_config_drive_for_dma;
-	hwif->ide_dma_test_irq = scc_dma_test_irq;
-
-	hwif->drives[0].autotune = IDE_TUNE_AUTO;
-	hwif->drives[1].autotune = IDE_TUNE_AUTO;
-
-	if (in_be32((void __iomem *)(hwif->config_data + 0xff0)) & CCKCTRL_ATACLKOEN) {
-		hwif->ultra_mask = 0x7f; /* 133MHz */
-	} else {
-		hwif->ultra_mask = 0x3f; /* 100MHz */
-	}
-	hwif->mwdma_mask = 0x00;
-	hwif->swdma_mask = 0x00;
-	hwif->atapi_dma = 1;
-
-	/* we support 80c cable only. */
-	hwif->udma_four = 1;
-
-	hwif->autodma = 0;
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
-}
-
-#define DECLARE_SCC_DEV(name_str)			\
-  {							\
-      .name		= name_str,			\
-      .init_setup	= init_setup_scc,		\
-      .init_iops	= init_iops_scc,		\
-      .init_hwif	= init_hwif_scc,		\
-      .channels	= 1,					\
-      .autodma	= AUTODMA,				\
-      .bootable	= ON_BOARD,				\
-  }
-
-static ide_pci_device_t scc_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_SCC_DEV("sccIDE"),
-};
-
-/**
- *	scc_init_one	-	pci layer discovery entry
- *	@dev: PCI device
- *	@id: ident table entry
- *
- *	Called by the PCI code when it finds an SCC PATA controller.
- *	We then use the IDE PCI generic helper to do most of the work.
- */
-
-static int __devinit scc_init_one(struct pci_dev *dev, const struct pci_device_id *id)
-{
-	ide_pci_device_t *d = &scc_chipsets[id->driver_data];
-	return d->init_setup(dev, d);
-}
-
-/**
- *	scc_remove	-	pci layer remove entry
- *	@dev: PCI device
- *
- *	Called by the PCI code when it removes an SCC PATA controller.
- */
-
-static void __devexit scc_remove(struct pci_dev *dev)
-{
-	struct scc_ports *ports = pci_get_drvdata(dev);
-	ide_hwif_t *hwif = &ide_hwifs[ports->hwif_id];
-	unsigned long ctl_base = pci_resource_start(dev, 0);
-	unsigned long dma_base = pci_resource_start(dev, 1);
-	unsigned long ctl_size = pci_resource_len(dev, 0);
-	unsigned long dma_size = pci_resource_len(dev, 1);
-
-	if (hwif->dmatable_cpu) {
-		pci_free_consistent(hwif->pci_dev,
-				    PRD_ENTRIES * PRD_BYTES,
-				    hwif->dmatable_cpu,
-				    hwif->dmatable_dma);
-		hwif->dmatable_cpu = NULL;
-	}
-
-	ide_unregister(hwif->index);
-
-	hwif->chipset = ide_unknown;
-	iounmap((void*)ports->dma);
-	iounmap((void*)ports->ctl);
-	release_mem_region(dma_base, dma_size);
-	release_mem_region(ctl_base, ctl_size);
-	memset(ports, 0, sizeof(*ports));
-}
-
-static struct pci_device_id scc_pci_tbl[] = {
-	{ PCI_VENDOR_ID_TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_SCC_ATA,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ 0, },
-};
-MODULE_DEVICE_TABLE(pci, scc_pci_tbl);
-
-static struct pci_driver driver = {
-	.name = "SCC IDE",
-	.id_table = scc_pci_tbl,
-	.probe = scc_init_one,
-	.remove = scc_remove,
-};
-
-static int scc_ide_init(void)
-{
-	return ide_pci_register_driver(&driver);
-}
-
-module_init(scc_ide_init);
-/* -- No exit code?
-static void scc_ide_exit(void)
-{
-	ide_pci_unregister_driver(&driver);
-}
-module_exit(scc_ide_exit);
- */
-
-
-MODULE_DESCRIPTION("PCI driver module for Toshiba SCC IDE");
-MODULE_LICENSE("GPL");
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index a52c80f..118fb32 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -505,11 +505,6 @@ static void ide_hwif_setup_dma(struct pci_dev *dev, ide_pci_device_t *d, ide_hwi
 		}
 	}
 }
-
-#ifndef CONFIG_IDEDMA_PCI_AUTO
-#warning CONFIG_IDEDMA_PCI_AUTO=n support is obsolete, and will be removed soon.
-#endif
-
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI*/
 
 /**
diff --git a/include/asm-mips/mach-au1x00/au1xxx_ide.h b/include/asm-mips/mach-au1x00/au1xxx_ide.h
index e9fa252..8fcae21 100644
--- a/include/asm-mips/mach-au1x00/au1xxx_ide.h
+++ b/include/asm-mips/mach-au1x00/au1xxx_ide.h
@@ -141,40 +141,6 @@ static int auide_ddma_init( _auide_hwif *auide );
 static void auide_setup_ports(hw_regs_t *hw, _auide_hwif *ahwif);
 int __init auide_probe(void);
 
-#ifdef CONFIG_PM
-        int au1200ide_pm_callback( au1xxx_power_dev_t *dev,
-                                   au1xxx_request_t request, void *data);
-        static int au1xxxide_pm_standby( au1xxx_power_dev_t *dev );
-        static int au1xxxide_pm_sleep( au1xxx_power_dev_t *dev );
-        static int au1xxxide_pm_resume( au1xxx_power_dev_t *dev );
-        static int au1xxxide_pm_getstatus( au1xxx_power_dev_t *dev );
-        static int au1xxxide_pm_access( au1xxx_power_dev_t *dev );
-        static int au1xxxide_pm_idle( au1xxx_power_dev_t *dev );
-        static int au1xxxide_pm_cleanup( au1xxx_power_dev_t *dev );
-#endif
-
-
-/*
- * Multi-Word DMA + DbDMA functions
- */
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
-        static int auide_build_sglist(ide_drive_t *drive,  struct request *rq);
-        static int auide_build_dmatable(ide_drive_t *drive);
-        static int auide_dma_end(ide_drive_t *drive);
-        ide_startstop_t auide_dma_intr (ide_drive_t *drive);
-        static void auide_dma_exec_cmd(ide_drive_t *drive, u8 command);
-        static int auide_dma_setup(ide_drive_t *drive);
-        static int auide_dma_check(ide_drive_t *drive);
-        static int auide_dma_test_irq(ide_drive_t *drive);
-        static int auide_dma_host_off(ide_drive_t *drive);
-        static int auide_dma_host_on(ide_drive_t *drive);
-        static int auide_dma_lostirq(ide_drive_t *drive);
-        static int auide_dma_on(ide_drive_t *drive);
-        static void auide_ddma_tx_callback(int irq, void *param);
-        static void auide_ddma_rx_callback(int irq, void *param);
-        static int auide_dma_off_quietly(ide_drive_t *drive);
-#endif /* end CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA */
-
 /*******************************************************************************
 * PIO Mode timing calculation :                                                *
 *                                                                              *
