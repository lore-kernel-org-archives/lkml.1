Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab0BBR1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:27:30 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:52784 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab0BBR1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tAhVidzq2/o3I054WyqIQERJcupAiFKJ/kAX8uV/TX26x0sboQU7bY4VxYU6gRIBiR
         58Y8ZxJCdQ2SJ33UrM1xD2fv0zfu75KKprjSpd8+/yVHMdyqdAAXqFg7BJwEl3aqah1d
         iRC+Qwl/BFL1p3g5UJe+Y4HrSz6+KDcI+s17E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Feb 2010 18:27:08 +0100
Message-Id: <20100202172708.7599.51937.sendpatchset@localhost>
In-Reply-To: <20100202172701.7599.2028.sendpatchset@localhost>
References: <20100202172701.7599.2028.sendpatchset@localhost>
Subject: [PATCH 1/2] move host drivers for VLB IDE controllers to staging/out
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] move host drivers for VLB IDE controllers to staging/out

- they are for really old hardware that nobody has any longer
- they all require 'magic' parameters to work
- many controllers are also supported by pata_legacy driver

so move them to staging/out and schedule for removal in 2.6.36
unless somebody steps in to work on them.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig                   |   72 -----
 drivers/ide/Makefile                  |    7 
 drivers/ide/ali14xx.c                 |  249 ------------------
 drivers/ide/dtc2278.c                 |  154 -----------
 drivers/ide/ht6560b.c                 |  384 -----------------------------
 drivers/ide/ide-4drives.c             |   64 ----
 drivers/ide/qd65xx.c                  |  446 ----------------------------------
 drivers/ide/qd65xx.h                  |  144 ----------
 drivers/ide/umc8672.c                 |  183 -------------
 drivers/staging/Kconfig               |    2 
 drivers/staging/Makefile              |    1 
 drivers/staging/ide-vlb/Kconfig       |   69 +++++
 drivers/staging/ide-vlb/Makefile      |    7 
 drivers/staging/ide-vlb/TODO          |    5 
 drivers/staging/ide-vlb/ali14xx.c     |  249 ++++++++++++++++++
 drivers/staging/ide-vlb/dtc2278.c     |  154 +++++++++++
 drivers/staging/ide-vlb/ht6560b.c     |  384 +++++++++++++++++++++++++++++
 drivers/staging/ide-vlb/ide-4drives.c |   64 ++++
 drivers/staging/ide-vlb/qd65xx.c      |  446 ++++++++++++++++++++++++++++++++++
 drivers/staging/ide-vlb/qd65xx.h      |  144 ++++++++++
 drivers/staging/ide-vlb/umc8672.c     |  183 +++++++++++++
 21 files changed, 1708 insertions(+), 1703 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -826,78 +826,6 @@ config BLK_DEV_PALMCHIP_BK3710
 	  Say Y here if you want to support the onchip IDE controller on the
 	  TI DaVinci SoC
 
-# no isa -> no vlb
-if ISA && (ALPHA || X86 || MIPS)
-
-comment "Other IDE chipsets support"
-comment "Note: most of these also require special kernel boot parameters"
-
-config BLK_DEV_4DRIVES
-	tristate "Generic 4 drives/port support"
-	help
-	  Certain older chipsets, including the Tekram 690CD, use a single set
-	  of I/O ports at 0x1f0 to control up to four drives, instead of the
-	  customary two drives per port. Support for this can be enabled at
-	  runtime using the "ide-4drives.probe" kernel boot parameter if you
-	  say Y here.
-
-config BLK_DEV_ALI14XX
-	tristate "ALI M14xx support"
-	select IDE_TIMINGS
-	select IDE_LEGACY
-	help
-	  This driver is enabled at runtime using the "ali14xx.probe" kernel
-	  boot parameter.  It enables support for the secondary IDE interface
-	  of the ALI M1439/1443/1445/1487/1489 chipsets, and permits faster
-	  I/O speeds to be set as well.
-	  See the files <file:Documentation/ide/ide.txt> and
-	  <file:drivers/ide/legacy/ali14xx.c> for more info.
-
-config BLK_DEV_DTC2278
-	tristate "DTC-2278 support"
-	select IDE_XFER_MODE
-	select IDE_LEGACY
-	help
-	  This driver is enabled at runtime using the "dtc2278.probe" kernel
-	  boot parameter. It enables support for the secondary IDE interface
-	  of the DTC-2278 card, and permits faster I/O speeds to be set as
-	  well. See the <file:Documentation/ide/ide.txt> and
-	  <file:drivers/ide/legacy/dtc2278.c> files for more info.
-
-config BLK_DEV_HT6560B
-	tristate "Holtek HT6560B support"
-	select IDE_TIMINGS
-	select IDE_LEGACY
-	help
-	  This driver is enabled at runtime using the "ht6560b.probe" kernel
-	  boot parameter. It enables support for the secondary IDE interface
-	  of the Holtek card, and permits faster I/O speeds to be set as well.
-	  See the <file:Documentation/ide/ide.txt> and
-	  <file:drivers/ide/legacy/ht6560b.c> files for more info.
-
-config BLK_DEV_QD65XX
-	tristate "QDI QD65xx support"
-	select IDE_TIMINGS
-	select IDE_LEGACY
-	help
-	  This driver is enabled at runtime using the "qd65xx.probe" kernel
-	  boot parameter.  It permits faster I/O speeds to be set.  See the
-	  <file:Documentation/ide/ide.txt> and <file:drivers/ide/legacy/qd65xx.c>
-	  for more info.
-
-config BLK_DEV_UMC8672
-	tristate "UMC-8672 support"
-	select IDE_XFER_MODE
-	select IDE_LEGACY
-	help
-	  This driver is enabled at runtime using the "umc8672.probe" kernel
-	  boot parameter. It enables support for the secondary IDE interface
-	  of the UMC-8672, and permits faster I/O speeds to be set as well.
-	  See the files <file:Documentation/ide/ide.txt> and
-	  <file:drivers/ide/legacy/umc8672.c> for more info.
-
-endif
-
 config BLK_DEV_IDEDMA
 	def_bool BLK_DEV_IDEDMA_SFF || \
 		 BLK_DEV_IDEDMA_ICS || BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -19,13 +19,6 @@ ide-core-$(CONFIG_IDE_LEGACY)		+= ide-le
 
 obj-$(CONFIG_IDE)			+= ide-core.o
 
-obj-$(CONFIG_BLK_DEV_ALI14XX)		+= ali14xx.o
-obj-$(CONFIG_BLK_DEV_UMC8672)		+= umc8672.o
-obj-$(CONFIG_BLK_DEV_DTC2278)		+= dtc2278.o
-obj-$(CONFIG_BLK_DEV_HT6560B)		+= ht6560b.o
-obj-$(CONFIG_BLK_DEV_QD65XX)		+= qd65xx.o
-obj-$(CONFIG_BLK_DEV_4DRIVES)		+= ide-4drives.o
-
 obj-$(CONFIG_BLK_DEV_GAYLE)		+= gayle.o
 obj-$(CONFIG_BLK_DEV_FALCON_IDE)	+= falconide.o
 obj-$(CONFIG_BLK_DEV_MAC_IDE)		+= macide.o
Index: b/drivers/ide/ali14xx.c
===================================================================
--- a/drivers/ide/ali14xx.c
+++ /dev/null
@@ -1,249 +0,0 @@
-/*
- *  Copyright (C) 1996  Linus Torvalds & author (see below)
- */
-
-/*
- * ALI M14xx chipset EIDE controller
- *
- * Works for ALI M1439/1443/1445/1487/1489 chipsets.
- *
- * Adapted from code developed by derekn@vw.ece.cmu.edu.  -ml
- * Derek's notes follow:
- *
- * I think the code should be pretty understandable,
- * but I'll be happy to (try to) answer questions.
- *
- * The critical part is in the setupDrive function.  The initRegisters
- * function doesn't seem to be necessary, but the DOS driver does it, so
- * I threw it in.
- *
- * I've only tested this on my system, which only has one disk.  I posted
- * it to comp.sys.linux.hardware, so maybe some other people will try it
- * out.
- *
- * Derek Noonburg  (derekn@ece.cmu.edu)
- * 95-sep-26
- *
- * Update 96-jul-13:
- *
- * I've since upgraded to two disks and a CD-ROM, with no trouble, and
- * I've also heard from several others who have used it successfully.
- * This driver appears to work with both the 1443/1445 and the 1487/1489
- * chipsets.  I've added support for PIO mode 4 for the 1487.  This
- * seems to work just fine on the 1443 also, although I'm not sure it's
- * advertised as supporting mode 4.  (I've been running a WDC AC21200 in
- * mode 4 for a while now with no trouble.)  -Derek
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
-#include <linux/ide.h>
-#include <linux/init.h>
-
-#include <asm/io.h>
-
-#define DRV_NAME "ali14xx"
-
-/* port addresses for auto-detection */
-#define ALI_NUM_PORTS 4
-static const int ports[ALI_NUM_PORTS] __initdata =
-	{ 0x074, 0x0f4, 0x034, 0x0e4 };
-
-/* register initialization data */
-typedef struct { u8 reg, data; } RegInitializer;
-
-static const RegInitializer initData[] __initdata = {
-	{0x01, 0x0f}, {0x02, 0x00}, {0x03, 0x00}, {0x04, 0x00},
-	{0x05, 0x00}, {0x06, 0x00}, {0x07, 0x2b}, {0x0a, 0x0f},
-	{0x25, 0x00}, {0x26, 0x00}, {0x27, 0x00}, {0x28, 0x00},
-	{0x29, 0x00}, {0x2a, 0x00}, {0x2f, 0x00}, {0x2b, 0x00},
-	{0x2c, 0x00}, {0x2d, 0x00}, {0x2e, 0x00}, {0x30, 0x00},
-	{0x31, 0x00}, {0x32, 0x00}, {0x33, 0x00}, {0x34, 0xff},
-	{0x35, 0x03}, {0x00, 0x00}
-};
-
-/* timing parameter registers for each drive */
-static struct { u8 reg1, reg2, reg3, reg4; } regTab[4] = {
-	{0x03, 0x26, 0x04, 0x27},     /* drive 0 */
-	{0x05, 0x28, 0x06, 0x29},     /* drive 1 */
-	{0x2b, 0x30, 0x2c, 0x31},     /* drive 2 */
-	{0x2d, 0x32, 0x2e, 0x33},     /* drive 3 */
-};
-
-static int basePort;	/* base port address */
-static int regPort;	/* port for register number */
-static int dataPort;	/* port for register data */
-static u8 regOn;	/* output to base port to access registers */
-static u8 regOff;	/* output to base port to close registers */
-
-/*------------------------------------------------------------------------*/
-
-/*
- * Read a controller register.
- */
-static inline u8 inReg(u8 reg)
-{
-	outb_p(reg, regPort);
-	return inb(dataPort);
-}
-
-/*
- * Write a controller register.
- */
-static void outReg(u8 data, u8 reg)
-{
-	outb_p(reg, regPort);
-	outb_p(data, dataPort);
-}
-
-static DEFINE_SPINLOCK(ali14xx_lock);
-
-/*
- * Set PIO mode for the specified drive.
- * This function computes timing parameters
- * and sets controller registers accordingly.
- */
-static void ali14xx_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	int driveNum;
-	int time1, time2;
-	u8 param1, param2, param3, param4;
-	unsigned long flags;
-	int bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-	const struct ata_timing *t = ata_timing_find_mode(XFER_PIO_0 + pio);
-
-	/* calculate timing, according to PIO mode */
-	time1 = ide_pio_cycle_time(drive, pio);
-	time2 = t->active;
-	param3 = param1 = (time2 * bus_speed + 999) / 1000;
-	param4 = param2 = (time1 * bus_speed + 999) / 1000 - param1;
-	if (pio < 3) {
-		param3 += 8;
-		param4 += 8;
-	}
-	printk(KERN_DEBUG "%s: PIO mode%d, t1=%dns, t2=%dns, cycles = %d+%d, %d+%d\n",
-		drive->name, pio, time1, time2, param1, param2, param3, param4);
-
-	/* stuff timing parameters into controller registers */
-	driveNum = (drive->hwif->index << 1) + (drive->dn & 1);
-	spin_lock_irqsave(&ali14xx_lock, flags);
-	outb_p(regOn, basePort);
-	outReg(param1, regTab[driveNum].reg1);
-	outReg(param2, regTab[driveNum].reg2);
-	outReg(param3, regTab[driveNum].reg3);
-	outReg(param4, regTab[driveNum].reg4);
-	outb_p(regOff, basePort);
-	spin_unlock_irqrestore(&ali14xx_lock, flags);
-}
-
-/*
- * Auto-detect the IDE controller port.
- */
-static int __init findPort(void)
-{
-	int i;
-	u8 t;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	for (i = 0; i < ALI_NUM_PORTS; ++i) {
-		basePort = ports[i];
-		regOff = inb(basePort);
-		for (regOn = 0x30; regOn <= 0x33; ++regOn) {
-			outb_p(regOn, basePort);
-			if (inb(basePort) == regOn) {
-				regPort = basePort + 4;
-				dataPort = basePort + 8;
-				t = inReg(0) & 0xf0;
-				outb_p(regOff, basePort);
-				local_irq_restore(flags);
-				if (t != 0x50)
-					return 0;
-				return 1;  /* success */
-			}
-		}
-		outb_p(regOff, basePort);
-	}
-	local_irq_restore(flags);
-	return 0;
-}
-
-/*
- * Initialize controller registers with default values.
- */
-static int __init initRegisters(void)
-{
-	const RegInitializer *p;
-	u8 t;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	outb_p(regOn, basePort);
-	for (p = initData; p->reg != 0; ++p)
-		outReg(p->data, p->reg);
-	outb_p(0x01, regPort);
-	t = inb(regPort) & 0x01;
-	outb_p(regOff, basePort);
-	local_irq_restore(flags);
-	return t;
-}
-
-static const struct ide_port_ops ali14xx_port_ops = {
-	.set_pio_mode		= ali14xx_set_pio_mode,
-};
-
-static const struct ide_port_info ali14xx_port_info = {
-	.name			= DRV_NAME,
-	.chipset		= ide_ali14xx,
-	.port_ops		= &ali14xx_port_ops,
-	.host_flags		= IDE_HFLAG_NO_DMA,
-	.pio_mask		= ATA_PIO4,
-};
-
-static int __init ali14xx_probe(void)
-{
-	printk(KERN_DEBUG "ali14xx: base=0x%03x, regOn=0x%02x.\n",
-			  basePort, regOn);
-
-	/* initialize controller registers */
-	if (!initRegisters()) {
-		printk(KERN_ERR "ali14xx: Chip initialization failed.\n");
-		return 1;
-	}
-
-	return ide_legacy_device_add(&ali14xx_port_info, 0);
-}
-
-static int probe_ali14xx;
-
-module_param_named(probe, probe_ali14xx, bool, 0);
-MODULE_PARM_DESC(probe, "probe for ALI M14xx chipsets");
-
-static int __init ali14xx_init(void)
-{
-	if (probe_ali14xx == 0)
-		goto out;
-
-	/* auto-detect IDE controller port */
-	if (findPort()) {
-		if (ali14xx_probe())
-			return -ENODEV;
-		return 0;
-	}
-	printk(KERN_ERR "ali14xx: not found.\n");
-out:
-	return -ENODEV;
-}
-
-module_init(ali14xx_init);
-
-MODULE_AUTHOR("see local file");
-MODULE_DESCRIPTION("support of ALI 14XX IDE chipsets");
-MODULE_LICENSE("GPL");
Index: b/drivers/ide/dtc2278.c
===================================================================
--- a/drivers/ide/dtc2278.c
+++ /dev/null
@@ -1,154 +0,0 @@
-/*
- *  Copyright (C) 1996  Linus Torvalds & author (see below)
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
-#include <linux/ide.h>
-#include <linux/init.h>
-
-#include <asm/io.h>
-
-#define DRV_NAME "dtc2278"
-
-/*
- * Changing this #undef to #define may solve start up problems in some systems.
- */
-#undef ALWAYS_SET_DTC2278_PIO_MODE
-
-/*
- * From: andy@cercle.cts.com (Dyan Wile)
- *
- * Below is a patch for DTC-2278 - alike software-programmable controllers
- * The code enables the secondary IDE controller and the PIO4 (3?) timings on
- * the primary (EIDE). You may probably have to enable the 32-bit support to
- * get the full speed. You better get the disk interrupts disabled ( hdparm -u0
- * /dev/hd.. ) for the drives connected to the EIDE interface. (I get my
- * filesystem  corrupted with -u1, but under heavy disk load only :-)
- *
- * This card is now forced to use the "serialize" feature,
- * and irq-unmasking is disallowed.  If io_32bit is enabled,
- * it must be done for BOTH drives on each interface.
- *
- * This code was written for the DTC2278E, but might work with any of these:
- *
- * DTC2278S has only a single IDE interface.
- * DTC2278D has two IDE interfaces and is otherwise identical to the S version.
- * DTC2278E also has serial ports and a printer port
- * DTC2278EB: has onboard BIOS, and "works like a charm" -- Kent Bradford <kent@theory.caltech.edu>
- *
- * There may be a fourth controller type. The S and D versions use the
- * Winbond chip, and I think the E version does also.
- *
- */
-
-static void sub22 (char b, char c)
-{
-	int i;
-
-	for(i = 0; i < 3; ++i) {
-		inb(0x3f6);
-		outb_p(b,0xb0);
-		inb(0x3f6);
-		outb_p(c,0xb4);
-		inb(0x3f6);
-		if(inb(0xb4) == c) {
-			outb_p(7,0xb0);
-			inb(0x3f6);
-			return;	/* success */
-		}
-	}
-}
-
-static DEFINE_SPINLOCK(dtc2278_lock);
-
-static void dtc2278_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	unsigned long flags;
-
-	if (drive->pio_mode >= XFER_PIO_3) {
-		spin_lock_irqsave(&dtc2278_lock, flags);
-		/*
-		 * This enables PIO mode4 (3?) on the first interface
-		 */
-		sub22(1,0xc3);
-		sub22(0,0xa0);
-		spin_unlock_irqrestore(&dtc2278_lock, flags);
-	} else {
-		/* we don't know how to set it back again.. */
-		/* Actually we do - there is a data sheet available for the
-		   Winbond but does anyone actually care */
-	}
-}
-
-static const struct ide_port_ops dtc2278_port_ops = {
-	.set_pio_mode		= dtc2278_set_pio_mode,
-};
-
-static const struct ide_port_info dtc2278_port_info __initdata = {
-	.name			= DRV_NAME,
-	.chipset		= ide_dtc2278,
-	.port_ops		= &dtc2278_port_ops,
-	.host_flags		= IDE_HFLAG_SERIALIZE |
-				  IDE_HFLAG_NO_UNMASK_IRQS |
-				  IDE_HFLAG_IO_32BIT |
-				  /* disallow ->io_32bit changes */
-				  IDE_HFLAG_NO_IO_32BIT |
-				  IDE_HFLAG_NO_DMA |
-				  IDE_HFLAG_DTC2278,
-	.pio_mask		= ATA_PIO4,
-};
-
-static int __init dtc2278_probe(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	/*
-	 * This enables the second interface
-	 */
-	outb_p(4,0xb0);
-	inb(0x3f6);
-	outb_p(0x20,0xb4);
-	inb(0x3f6);
-#ifdef ALWAYS_SET_DTC2278_PIO_MODE
-	/*
-	 * This enables PIO mode4 (3?) on the first interface
-	 * and may solve start-up problems for some people.
-	 */
-	sub22(1,0xc3);
-	sub22(0,0xa0);
-#endif
-	local_irq_restore(flags);
-
-	return ide_legacy_device_add(&dtc2278_port_info, 0);
-}
-
-static int probe_dtc2278;
-
-module_param_named(probe, probe_dtc2278, bool, 0);
-MODULE_PARM_DESC(probe, "probe for DTC2278xx chipsets");
-
-static int __init dtc2278_init(void)
-{
-	if (probe_dtc2278 == 0)
-		return -ENODEV;
-
-	if (dtc2278_probe()) {
-		printk(KERN_ERR "dtc2278: ide interfaces already in use!\n");
-		return -EBUSY;
-	}
-	return 0;
-}
-
-module_init(dtc2278_init);
-
-MODULE_AUTHOR("See Local File");
-MODULE_DESCRIPTION("support of DTC-2278 VLB IDE chipsets");
-MODULE_LICENSE("GPL");
Index: b/drivers/ide/ht6560b.c
===================================================================
--- a/drivers/ide/ht6560b.c
+++ /dev/null
@@ -1,384 +0,0 @@
-/*
- *  Copyright (C) 1995-2000  Linus Torvalds & author (see below)
- */
-
-/*
- *  HT-6560B EIDE-controller support
- *  To activate controller support use kernel parameter "ide0=ht6560b".
- *  Use hdparm utility to enable PIO mode support.
- *
- *  Author:    Mikko Ala-Fossi            <maf@iki.fi>
- *             Jan Evert van Grootheest   <j.e.van.grootheest@caiway.nl>
- *
- *  Try:  http://www.maf.iki.fi/~maf/ht6560b/
- */
-
-#define DRV_NAME	"ht6560b"
-#define HT6560B_VERSION "v0.08"
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
-#include <linux/ide.h>
-#include <linux/init.h>
-
-#include <asm/io.h>
-
-/* #define DEBUG */  /* remove comments for DEBUG messages */
-
-/*
- * The special i/o-port that HT-6560B uses to configuration:
- *    bit0 (0x01): "1" selects secondary interface
- *    bit2 (0x04): "1" enables FIFO function
- *    bit5 (0x20): "1" enables prefetched data read function  (???)
- *
- * The special i/o-port that HT-6560A uses to configuration:
- *    bit0 (0x01): "1" selects secondary interface
- *    bit1 (0x02): "1" enables prefetched data read function
- *    bit2 (0x04): "0" enables multi-master system	      (?)
- *    bit3 (0x08): "1" 3 cycle time, "0" 2 cycle time	      (?)
- */
-#define HT_CONFIG_PORT	  0x3e6
-
-static inline u8 HT_CONFIG(ide_drive_t *drive)
-{
-	return ((unsigned long)ide_get_drivedata(drive) & 0xff00) >> 8;
-}
-
-/*
- * FIFO + PREFETCH (both a/b-model)
- */
-#define HT_CONFIG_DEFAULT 0x1c /* no prefetch */
-/* #define HT_CONFIG_DEFAULT 0x3c */ /* with prefetch */
-#define HT_SECONDARY_IF	  0x01
-#define HT_PREFETCH_MODE  0x20
-
-/*
- * ht6560b Timing values:
- *
- * I reviewed some assembler source listings of htide drivers and found
- * out how they setup those cycle time interfacing values, as they at Holtek
- * call them. IDESETUP.COM that is supplied with the drivers figures out
- * optimal values and fetches those values to drivers. I found out that
- * they use Select register to fetch timings to the ide board right after
- * interface switching. After that it was quite easy to add code to
- * ht6560b.c.
- *
- * IDESETUP.COM gave me values 0x24, 0x45, 0xaa, 0xff that worked fine
- * for hda and hdc. But hdb needed higher values to work, so I guess
- * that sometimes it is necessary to give higher value than IDESETUP
- * gives.   [see cmd640.c for an extreme example of this. -ml]
- *
- * Perhaps I should explain something about these timing values:
- * The higher nibble of value is the Recovery Time  (rt) and the lower nibble
- * of the value is the Active Time  (at). Minimum value 2 is the fastest and
- * the maximum value 15 is the slowest. Default values should be 15 for both.
- * So 0x24 means 2 for rt and 4 for at. Each of the drives should have
- * both values, and IDESETUP gives automatically rt=15 st=15 for CDROMs or
- * similar. If value is too small there will be all sorts of failures.
- *
- * Timing byte consists of
- *	High nibble:  Recovery Cycle Time  (rt)
- *	     The valid values range from 2 to 15. The default is 15.
- *
- *	Low nibble:   Active Cycle Time	   (at)
- *	     The valid values range from 2 to 15. The default is 15.
- *
- * You can obtain optimized timing values by running Holtek IDESETUP.COM
- * for DOS. DOS drivers get their timing values from command line, where
- * the first value is the Recovery Time and the second value is the
- * Active Time for each drive. Smaller value gives higher speed.
- * In case of failures you should probably fall back to a higher value.
- */
-static inline u8 HT_TIMING(ide_drive_t *drive)
-{
-	return (unsigned long)ide_get_drivedata(drive) & 0x00ff;
-}
-
-#define HT_TIMING_DEFAULT 0xff
-
-/*
- * This routine handles interface switching for the peculiar hardware design
- * on the F.G.I./Holtek HT-6560B VLB IDE interface.
- * The HT-6560B can only enable one IDE port at a time, and requires a
- * silly sequence (below) whenever we switch between primary and secondary.
- */
-
-/*
- * This routine is invoked from ide.c to prepare for access to a given drive.
- */
-static void ht6560b_dev_select(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	unsigned long flags;
-	static u8 current_select = 0;
-	static u8 current_timing = 0;
-	u8 select, timing;
-	
-	local_irq_save(flags);
-
-	select = HT_CONFIG(drive);
-	timing = HT_TIMING(drive);
-
-	/*
-	 * Need to enforce prefetch sometimes because otherwise
-	 * it'll hang (hard).
-	 */
-	if (drive->media != ide_disk ||
-	    (drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-		select |= HT_PREFETCH_MODE;
-
-	if (select != current_select || timing != current_timing) {
-		current_select = select;
-		current_timing = timing;
-		(void)inb(HT_CONFIG_PORT);
-		(void)inb(HT_CONFIG_PORT);
-		(void)inb(HT_CONFIG_PORT);
-		(void)inb(HT_CONFIG_PORT);
-		outb(select, HT_CONFIG_PORT);
-		/*
-		 * Set timing for this drive:
-		 */
-		outb(timing, hwif->io_ports.device_addr);
-		(void)inb(hwif->io_ports.status_addr);
-#ifdef DEBUG
-		printk("ht6560b: %s: select=%#x timing=%#x\n",
-			drive->name, select, timing);
-#endif
-	}
-	local_irq_restore(flags);
-
-	outb(drive->select | ATA_DEVICE_OBS, hwif->io_ports.device_addr);
-}
-
-/*
- * Autodetection and initialization of ht6560b
- */
-static int __init try_to_init_ht6560b(void)
-{
-	u8 orig_value;
-	int i;
-	
-	/* Autodetect ht6560b */
-	if ((orig_value = inb(HT_CONFIG_PORT)) == 0xff)
-		return 0;
-	
-	for (i=3;i>0;i--) {
-		outb(0x00, HT_CONFIG_PORT);
-		if (!( (~inb(HT_CONFIG_PORT)) & 0x3f )) {
-			outb(orig_value, HT_CONFIG_PORT);
-			return 0;
-		}
-	}
-	outb(0x00, HT_CONFIG_PORT);
-	if ((~inb(HT_CONFIG_PORT))& 0x3f) {
-		outb(orig_value, HT_CONFIG_PORT);
-		return 0;
-	}
-	/*
-	 * Ht6560b autodetected
-	 */
-	outb(HT_CONFIG_DEFAULT, HT_CONFIG_PORT);
-	outb(HT_TIMING_DEFAULT, 0x1f6);	/* Select register */
-	(void)inb(0x1f7);		/* Status register */
-
-	printk("ht6560b " HT6560B_VERSION
-	       ": chipset detected and initialized"
-#ifdef DEBUG
-	       " with debug enabled"
-#endif
-	       "\n"
-		);
-	return 1;
-}
-
-static u8 ht_pio2timings(ide_drive_t *drive, const u8 pio)
-{
-	int active_time, recovery_time;
-	int active_cycles, recovery_cycles;
-	int bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
-
-        if (pio) {
-		unsigned int cycle_time;
-		const struct ata_timing *t =
-			ata_timing_find_mode(XFER_PIO_0 + pio);
-
-		cycle_time = ide_pio_cycle_time(drive, pio);
-
-		/*
-		 *  Just like opti621.c we try to calculate the
-		 *  actual cycle time for recovery and activity
-		 *  according system bus speed.
-		 */
-		active_time = t->active;
-		recovery_time = cycle_time - active_time - t->setup;
-		/*
-		 *  Cycle times should be Vesa bus cycles
-		 */
-		active_cycles   = (active_time   * bus_speed + 999) / 1000;
-		recovery_cycles = (recovery_time * bus_speed + 999) / 1000;
-		/*
-		 *  Upper and lower limits
-		 */
-		if (active_cycles   < 2)  active_cycles   = 2;
-		if (recovery_cycles < 2)  recovery_cycles = 2;
-		if (active_cycles   > 15) active_cycles   = 15;
-		if (recovery_cycles > 15) recovery_cycles = 0;  /* 0==16 */
-		
-#ifdef DEBUG
-		printk("ht6560b: drive %s setting pio=%d recovery=%d (%dns) active=%d (%dns)\n", drive->name, pio, recovery_cycles, recovery_time, active_cycles, active_time);
-#endif
-		
-		return (u8)((recovery_cycles << 4) | active_cycles);
-	} else {
-		
-#ifdef DEBUG
-		printk("ht6560b: drive %s setting pio=0\n", drive->name);
-#endif
-		
-		return HT_TIMING_DEFAULT;    /* default setting */
-	}
-}
-
-static DEFINE_SPINLOCK(ht6560b_lock);
-
-/*
- *  Enable/Disable so called prefetch mode
- */
-static void ht_set_prefetch(ide_drive_t *drive, u8 state)
-{
-	unsigned long flags, config;
-	int t = HT_PREFETCH_MODE << 8;
-
-	spin_lock_irqsave(&ht6560b_lock, flags);
-
-	config = (unsigned long)ide_get_drivedata(drive);
-
-	/*
-	 *  Prefetch mode and unmask irq seems to conflict
-	 */
-	if (state) {
-		config |= t;   /* enable prefetch mode */
-		drive->dev_flags |= IDE_DFLAG_NO_UNMASK;
-		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
-	} else {
-		config &= ~t;  /* disable prefetch mode */
-		drive->dev_flags &= ~IDE_DFLAG_NO_UNMASK;
-	}
-
-	ide_set_drivedata(drive, (void *)config);
-
-	spin_unlock_irqrestore(&ht6560b_lock, flags);
-
-#ifdef DEBUG
-	printk("ht6560b: drive %s prefetch mode %sabled\n", drive->name, (state ? "en" : "dis"));
-#endif
-}
-
-static void ht6560b_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	unsigned long flags, config;
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-	u8 timing;
-	
-	switch (pio) {
-	case 8:         /* set prefetch off */
-	case 9:         /* set prefetch on */
-		ht_set_prefetch(drive, pio & 1);
-		return;
-	}
-
-	timing = ht_pio2timings(drive, pio);
-
-	spin_lock_irqsave(&ht6560b_lock, flags);
-	config = (unsigned long)ide_get_drivedata(drive);
-	config &= 0xff00;
-	config |= timing;
-	ide_set_drivedata(drive, (void *)config);
-	spin_unlock_irqrestore(&ht6560b_lock, flags);
-
-#ifdef DEBUG
-	printk("ht6560b: drive %s tuned to pio mode %#x timing=%#x\n", drive->name, pio, timing);
-#endif
-}
-
-static void __init ht6560b_init_dev(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	/* Setting default configurations for drives. */
-	int t = (HT_CONFIG_DEFAULT << 8) | HT_TIMING_DEFAULT;
-
-	if (hwif->channel)
-		t |= (HT_SECONDARY_IF << 8);
-
-	ide_set_drivedata(drive, (void *)t);
-}
-
-static int probe_ht6560b;
-
-module_param_named(probe, probe_ht6560b, bool, 0);
-MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
-
-static const struct ide_tp_ops ht6560b_tp_ops = {
-	.exec_command		= ide_exec_command,
-	.read_status		= ide_read_status,
-	.read_altstatus		= ide_read_altstatus,
-	.write_devctl		= ide_write_devctl,
-
-	.dev_select		= ht6560b_dev_select,
-	.tf_load		= ide_tf_load,
-	.tf_read		= ide_tf_read,
-
-	.input_data		= ide_input_data,
-	.output_data		= ide_output_data,
-};
-
-static const struct ide_port_ops ht6560b_port_ops = {
-	.init_dev		= ht6560b_init_dev,
-	.set_pio_mode		= ht6560b_set_pio_mode,
-};
-
-static const struct ide_port_info ht6560b_port_info __initdata = {
-	.name			= DRV_NAME,
-	.chipset		= ide_ht6560b,
-	.tp_ops 		= &ht6560b_tp_ops,
-	.port_ops		= &ht6560b_port_ops,
-	.host_flags		= IDE_HFLAG_SERIALIZE | /* is this needed? */
-				  IDE_HFLAG_NO_DMA |
-				  IDE_HFLAG_ABUSE_PREFETCH,
-	.pio_mask		= ATA_PIO4,
-};
-
-static int __init ht6560b_init(void)
-{
-	if (probe_ht6560b == 0)
-		return -ENODEV;
-
-	if (!request_region(HT_CONFIG_PORT, 1, DRV_NAME)) {
-		printk(KERN_NOTICE "%s: HT_CONFIG_PORT not found\n",
-			__func__);
-		return -ENODEV;
-	}
-
-	if (!try_to_init_ht6560b()) {
-		printk(KERN_NOTICE "%s: HBA not found\n", __func__);
-		goto release_region;
-	}
-
-	return ide_legacy_device_add(&ht6560b_port_info, 0);
-
-release_region:
-	release_region(HT_CONFIG_PORT, 1);
-	return -ENODEV;
-}
-
-module_init(ht6560b_init);
-
-MODULE_AUTHOR("See Local File");
-MODULE_DESCRIPTION("HT-6560B EIDE-controller support");
-MODULE_LICENSE("GPL");
Index: b/drivers/ide/ide-4drives.c
===================================================================
--- a/drivers/ide/ide-4drives.c
+++ /dev/null
@@ -1,64 +0,0 @@
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/ide.h>
-
-#define DRV_NAME "ide-4drives"
-
-static int probe_4drives;
-
-module_param_named(probe, probe_4drives, bool, 0);
-MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
-
-static void ide_4drives_init_dev(ide_drive_t *drive)
-{
-	if (drive->hwif->channel)
-		drive->select ^= 0x20;
-}
-
-static const struct ide_port_ops ide_4drives_port_ops = {
-	.init_dev		= ide_4drives_init_dev,
-};
-
-static const struct ide_port_info ide_4drives_port_info = {
-	.port_ops		= &ide_4drives_port_ops,
-	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_NO_DMA |
-				  IDE_HFLAG_4DRIVES,
-	.chipset		= ide_4drives,
-};
-
-static int __init ide_4drives_init(void)
-{
-	unsigned long base = 0x1f0, ctl = 0x3f6;
-	struct ide_hw hw, *hws[] = { &hw, &hw };
-
-	if (probe_4drives == 0)
-		return -ENODEV;
-
-	if (!request_region(base, 8, DRV_NAME)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
-				DRV_NAME, base, base + 7);
-		return -EBUSY;
-	}
-
-	if (!request_region(ctl, 1, DRV_NAME)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
-				DRV_NAME, ctl);
-		release_region(base, 8);
-		return -EBUSY;
-	}
-
-	memset(&hw, 0, sizeof(hw));
-
-	ide_std_init_ports(&hw, base, ctl);
-	hw.irq = 14;
-
-	return ide_host_add(&ide_4drives_port_info, hws, 2, NULL);
-}
-
-module_init(ide_4drives_init);
-
-MODULE_AUTHOR("Bartlomiej Zolnierkiewicz");
-MODULE_DESCRIPTION("generic IDE chipset with 4 drives/port support");
-MODULE_LICENSE("GPL");
Index: b/drivers/ide/qd65xx.c
===================================================================
--- a/drivers/ide/qd65xx.c
+++ /dev/null
@@ -1,446 +0,0 @@
-/*
- *  Copyright (C) 1996-2001  Linus Torvalds & author (see below)
- */
-
-/*
- *  Version 0.03	Cleaned auto-tune, added probe
- *  Version 0.04	Added second channel tuning
- *  Version 0.05	Enhanced tuning ; added qd6500 support
- *  Version 0.06	Added dos driver's list
- *  Version 0.07	Second channel bug fix 
- *
- * QDI QD6500/QD6580 EIDE controller fast support
- *
- * To activate controller support, use "ide0=qd65xx"
- */
-
-/*
- * Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
- * Samuel Thibault <samuel.thibault@ens-lyon.org>
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
-#include <linux/ide.h>
-#include <linux/init.h>
-#include <asm/system.h>
-#include <asm/io.h>
-
-#define DRV_NAME "qd65xx"
-
-#include "qd65xx.h"
-
-/*
- * I/O ports are 0x30-0x31 (and 0x32-0x33 for qd6580)
- *            or 0xb0-0xb1 (and 0xb2-0xb3 for qd6580)
- *	-- qd6500 is a single IDE interface
- *	-- qd6580 is a dual IDE interface
- *
- * More research on qd6580 being done by willmore@cig.mot.com (David)
- * More Information given by Petr Soucek (petr@ryston.cz)
- * http://www.ryston.cz/petr/vlb
- */
-
-/*
- * base: Timer1
- *
- *
- * base+0x01: Config (R/O)
- *
- * bit 0: ide baseport: 1 = 0x1f0 ; 0 = 0x170 (only useful for qd6500)
- * bit 1: qd65xx baseport: 1 = 0xb0 ; 0 = 0x30
- * bit 2: ID3: bus speed: 1 = <=33MHz ; 0 = >33MHz
- * bit 3: qd6500: 1 = disabled, 0 = enabled
- *        qd6580: 1
- * upper nibble:
- *        qd6500: 1100
- *        qd6580: either 1010 or 0101
- *
- *
- * base+0x02: Timer2 (qd6580 only)
- *
- *
- * base+0x03: Control (qd6580 only)
- *
- * bits 0-3 must always be set 1
- * bit 4 must be set 1, but is set 0 by dos driver while measuring vlb clock
- * bit 0 : 1 = Only primary port enabled : channel 0 for hda, channel 1 for hdb
- *         0 = Primary and Secondary ports enabled : channel 0 for hda & hdb
- *                                                   channel 1 for hdc & hdd
- * bit 1 : 1 = only disks on primary port
- *         0 = disks & ATAPI devices on primary port
- * bit 2-4 : always 0
- * bit 5 : status, but of what ?
- * bit 6 : always set 1 by dos driver
- * bit 7 : set 1 for non-ATAPI devices on primary port
- *	(maybe read-ahead and post-write buffer ?)
- */
-
-static int timings[4]={-1,-1,-1,-1}; /* stores current timing for each timer */
-
-/*
- * qd65xx_select:
- *
- * This routine is invoked to prepare for access to a given drive.
- */
-
-static void qd65xx_dev_select(ide_drive_t *drive)
-{
-	u8 index = ((	(QD_TIMREG(drive)) & 0x80 ) >> 7) |
-			(QD_TIMREG(drive) & 0x02);
-
-	if (timings[index] != QD_TIMING(drive))
-		outb(timings[index] = QD_TIMING(drive), QD_TIMREG(drive));
-
-	outb(drive->select | ATA_DEVICE_OBS, drive->hwif->io_ports.device_addr);
-}
-
-/*
- * qd6500_compute_timing
- *
- * computes the timing value where
- *	lower nibble represents active time,   in count of VLB clocks
- *	upper nibble represents recovery time, in count of VLB clocks
- */
-
-static u8 qd6500_compute_timing (ide_hwif_t *hwif, int active_time, int recovery_time)
-{
-	int clk = ide_vlb_clk ? ide_vlb_clk : 50;
-	u8 act_cyc, rec_cyc;
-
-	if (clk <= 33) {
-		act_cyc =  9 - IDE_IN(active_time   * clk / 1000 + 1, 2,  9);
-		rec_cyc = 15 - IDE_IN(recovery_time * clk / 1000 + 1, 0, 15);
-	} else {
-		act_cyc =  8 - IDE_IN(active_time   * clk / 1000 + 1, 1,  8);
-		rec_cyc = 18 - IDE_IN(recovery_time * clk / 1000 + 1, 3, 18);
-	}
-
-	return (rec_cyc << 4) | 0x08 | act_cyc;
-}
-
-/*
- * qd6580_compute_timing
- *
- * idem for qd6580
- */
-
-static u8 qd6580_compute_timing (int active_time, int recovery_time)
-{
-	int clk = ide_vlb_clk ? ide_vlb_clk : 50;
-	u8 act_cyc, rec_cyc;
-
-	act_cyc = 17 - IDE_IN(active_time   * clk / 1000 + 1, 2, 17);
-	rec_cyc = 15 - IDE_IN(recovery_time * clk / 1000 + 1, 2, 15);
-
-	return (rec_cyc << 4) | act_cyc;
-}
-
-/*
- * qd_find_disk_type
- *
- * tries to find timing from dos driver's table
- */
-
-static int qd_find_disk_type (ide_drive_t *drive,
-		int *active_time, int *recovery_time)
-{
-	struct qd65xx_timing_s *p;
-	char *m = (char *)&drive->id[ATA_ID_PROD];
-	char model[ATA_ID_PROD_LEN];
-
-	if (*m == 0)
-		return 0;
-
-	strncpy(model, m, ATA_ID_PROD_LEN);
-	ide_fixstring(model, ATA_ID_PROD_LEN, 1); /* byte-swap */
-
-	for (p = qd65xx_timing ; p->offset != -1 ; p++) {
-		if (!strncmp(p->model, model+p->offset, 4)) {
-			printk(KERN_DEBUG "%s: listed !\n", drive->name);
-			*active_time = p->active;
-			*recovery_time = p->recovery;
-			return 1;
-		}
-	}
-	return 0;
-}
-
-/*
- * qd_set_timing:
- *
- * records the timing
- */
-
-static void qd_set_timing (ide_drive_t *drive, u8 timing)
-{
-	unsigned long data = (unsigned long)ide_get_drivedata(drive);
-
-	data &= 0xff00;
-	data |= timing;
-	ide_set_drivedata(drive, (void *)data);
-
-	printk(KERN_DEBUG "%s: %#x\n", drive->name, timing);
-}
-
-static void qd6500_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	u16 *id = drive->id;
-	int active_time   = 175;
-	int recovery_time = 415; /* worst case values from the dos driver */
-
-	/* FIXME: use drive->pio_mode value */
-	if (!qd_find_disk_type(drive, &active_time, &recovery_time) &&
-	    (id[ATA_ID_OLD_PIO_MODES] & 0xff) && (id[ATA_ID_FIELD_VALID] & 2) &&
-	    id[ATA_ID_EIDE_PIO] >= 240) {
-		printk(KERN_INFO "%s: PIO mode%d\n", drive->name,
-			id[ATA_ID_OLD_PIO_MODES] & 0xff);
-		active_time = 110;
-		recovery_time = drive->id[ATA_ID_EIDE_PIO] - 120;
-	}
-
-	qd_set_timing(drive, qd6500_compute_timing(drive->hwif,
-				active_time, recovery_time));
-}
-
-static void qd6580_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-	const struct ata_timing *t = ata_timing_find_mode(XFER_PIO_0 + pio);
-	unsigned int cycle_time;
-	int active_time   = 175;
-	int recovery_time = 415; /* worst case values from the dos driver */
-	u8 base = (hwif->config_data & 0xff00) >> 8;
-
-	if (drive->id && !qd_find_disk_type(drive, &active_time, &recovery_time)) {
-		cycle_time = ide_pio_cycle_time(drive, pio);
-
-		switch (pio) {
-			case 0: break;
-			case 3:
-				if (cycle_time >= 110) {
-					active_time = 86;
-					recovery_time = cycle_time - 102;
-				} else
-					printk(KERN_WARNING "%s: Strange recovery time !\n",drive->name);
-				break;
-			case 4:
-				if (cycle_time >= 69) {
-					active_time = 70;
-					recovery_time = cycle_time - 61;
-				} else
-					printk(KERN_WARNING "%s: Strange recovery time !\n",drive->name);
-				break;
-			default:
-				if (cycle_time >= 180) {
-					active_time = 110;
-					recovery_time = cycle_time - 120;
-				} else {
-					active_time = t->active;
-					recovery_time = cycle_time - active_time;
-				}
-		}
-		printk(KERN_INFO "%s: PIO mode%d\n", drive->name,pio);
-	}
-
-	if (!hwif->channel && drive->media != ide_disk) {
-		outb(0x5f, QD_CONTROL_PORT);
-		printk(KERN_WARNING "%s: ATAPI: disabled read-ahead FIFO "
-			"and post-write buffer on %s.\n",
-			drive->name, hwif->name);
-	}
-
-	qd_set_timing(drive, qd6580_compute_timing(active_time, recovery_time));
-}
-
-/*
- * qd_testreg
- *
- * tests if the given port is a register
- */
-
-static int __init qd_testreg(int port)
-{
-	unsigned long flags;
-	u8 savereg, readreg;
-
-	local_irq_save(flags);
-	savereg = inb_p(port);
-	outb_p(QD_TESTVAL, port);	/* safe value */
-	readreg = inb_p(port);
-	outb(savereg, port);
-	local_irq_restore(flags);
-
-	if (savereg == QD_TESTVAL) {
-		printk(KERN_ERR "Outch ! the probe for qd65xx isn't reliable !\n");
-		printk(KERN_ERR "Please contact maintainers to tell about your hardware\n");
-		printk(KERN_ERR "Assuming qd65xx is not present.\n");
-		return 1;
-	}
-
-	return (readreg != QD_TESTVAL);
-}
-
-static void __init qd6500_init_dev(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 base = (hwif->config_data & 0xff00) >> 8;
-	u8 config = QD_CONFIG(hwif);
-
-	ide_set_drivedata(drive, (void *)QD6500_DEF_DATA);
-}
-
-static void __init qd6580_init_dev(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u16 t1, t2;
-	u8 base = (hwif->config_data & 0xff00) >> 8;
-	u8 config = QD_CONFIG(hwif);
-
-	if (hwif->host_flags & IDE_HFLAG_SINGLE) {
-		t1 = QD6580_DEF_DATA;
-		t2 = QD6580_DEF_DATA2;
-	} else
-		t2 = t1 = hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA;
-
-	ide_set_drivedata(drive, (void *)((drive->dn & 1) ? t2 : t1));
-}
-
-static const struct ide_tp_ops qd65xx_tp_ops = {
-	.exec_command		= ide_exec_command,
-	.read_status		= ide_read_status,
-	.read_altstatus		= ide_read_altstatus,
-	.write_devctl		= ide_write_devctl,
-
-	.dev_select		= qd65xx_dev_select,
-	.tf_load		= ide_tf_load,
-	.tf_read		= ide_tf_read,
-
-	.input_data		= ide_input_data,
-	.output_data		= ide_output_data,
-};
-
-static const struct ide_port_ops qd6500_port_ops = {
-	.init_dev		= qd6500_init_dev,
-	.set_pio_mode		= qd6500_set_pio_mode,
-};
-
-static const struct ide_port_ops qd6580_port_ops = {
-	.init_dev		= qd6580_init_dev,
-	.set_pio_mode		= qd6580_set_pio_mode,
-};
-
-static const struct ide_port_info qd65xx_port_info __initdata = {
-	.name			= DRV_NAME,
-	.tp_ops 		= &qd65xx_tp_ops,
-	.chipset		= ide_qd65xx,
-	.host_flags		= IDE_HFLAG_IO_32BIT |
-				  IDE_HFLAG_NO_DMA,
-	.pio_mask		= ATA_PIO4,
-};
-
-/*
- * qd_probe:
- *
- * looks at the specified baseport, and if qd found, registers & initialises it
- * return 1 if another qd may be probed
- */
-
-static int __init qd_probe(int base)
-{
-	int rc;
-	u8 config, unit, control;
-	struct ide_port_info d = qd65xx_port_info;
-
-	config = inb(QD_CONFIG_PORT);
-
-	if (! ((config & QD_CONFIG_BASEPORT) >> 1 == (base == 0xb0)) )
-		return -ENODEV;
-
-	unit = ! (config & QD_CONFIG_IDE_BASEPORT);
-
-	if (unit)
-		d.host_flags |= IDE_HFLAG_QD_2ND_PORT;
-
-	switch (config & 0xf0) {
-	case QD_CONFIG_QD6500:
-		if (qd_testreg(base))
-			 return -ENODEV;	/* bad register */
-
-		if (config & QD_CONFIG_DISABLED) {
-			printk(KERN_WARNING "qd6500 is disabled !\n");
-			return -ENODEV;
-		}
-
-		printk(KERN_NOTICE "qd6500 at %#x\n", base);
-		printk(KERN_DEBUG "qd6500: config=%#x, ID3=%u\n",
-			config, QD_ID3);
-
-		d.port_ops = &qd6500_port_ops;
-		d.host_flags |= IDE_HFLAG_SINGLE;
-		break;
-	case QD_CONFIG_QD6580_A:
-	case QD_CONFIG_QD6580_B:
-		if (qd_testreg(base) || qd_testreg(base + 0x02))
-			return -ENODEV;	/* bad registers */
-
-		control = inb(QD_CONTROL_PORT);
-
-		printk(KERN_NOTICE "qd6580 at %#x\n", base);
-		printk(KERN_DEBUG "qd6580: config=%#x, control=%#x, ID3=%u\n",
-			config, control, QD_ID3);
-
-		outb(QD_DEF_CONTR, QD_CONTROL_PORT);
-
-		d.port_ops = &qd6580_port_ops;
-		if (control & QD_CONTR_SEC_DISABLED)
-			d.host_flags |= IDE_HFLAG_SINGLE;
-
-		printk(KERN_INFO "qd6580: %s IDE board\n",
-			(control & QD_CONTR_SEC_DISABLED) ? "single" : "dual");
-		break;
-	default:
-		return -ENODEV;
-	}
-
-	rc = ide_legacy_device_add(&d, (base << 8) | config);
-
-	if (d.host_flags & IDE_HFLAG_SINGLE)
-		return (rc == 0) ? 1 : rc;
-
-	return rc;
-}
-
-static int probe_qd65xx;
-
-module_param_named(probe, probe_qd65xx, bool, 0);
-MODULE_PARM_DESC(probe, "probe for QD65xx chipsets");
-
-static int __init qd65xx_init(void)
-{
-	int rc1, rc2 = -ENODEV;
-
-	if (probe_qd65xx == 0)
-		return -ENODEV;
-
-	rc1 = qd_probe(0x30);
-	if (rc1)
-		rc2 = qd_probe(0xb0);
-
-	if (rc1 < 0 && rc2 < 0)
-		return -ENODEV;
-
-	return 0;
-}
-
-module_init(qd65xx_init);
-
-MODULE_AUTHOR("Samuel Thibault");
-MODULE_DESCRIPTION("support of qd65xx vlb ide chipset");
-MODULE_LICENSE("GPL");
Index: b/drivers/ide/qd65xx.h
===================================================================
--- a/drivers/ide/qd65xx.h
+++ /dev/null
@@ -1,144 +0,0 @@
-/*
- * Copyright (c) 2000	Linus Torvalds & authors
- */
-
-/*
- * Authors:	Petr Soucek <petr@ryston.cz>
- * 		Samuel Thibault <samuel.thibault@ens-lyon.org>
- */
-
-/* truncates a in [b,c] */
-#define IDE_IN(a,b,c)   ( ((a)<(b)) ? (b) : ( (a)>(c) ? (c) : (a)) )
-
-#define IDE_IMPLY(a,b)	((!(a)) || (b))
-
-#define QD_TIM1_PORT		(base)
-#define QD_CONFIG_PORT		(base+0x01)
-#define QD_TIM2_PORT		(base+0x02)
-#define QD_CONTROL_PORT		(base+0x03)
-
-#define QD_CONFIG_IDE_BASEPORT	0x01
-#define QD_CONFIG_BASEPORT	0x02
-#define QD_CONFIG_ID3		0x04
-#define QD_CONFIG_DISABLED	0x08
-#define QD_CONFIG_QD6500	0xc0
-#define QD_CONFIG_QD6580_A	0xa0
-#define QD_CONFIG_QD6580_B	0x50
-
-#define QD_CONTR_SEC_DISABLED	0x01
-
-#define QD_ID3			((config & QD_CONFIG_ID3)!=0)
-
-#define QD_CONFIG(hwif)		((hwif)->config_data & 0x00ff)
-
-static inline u8 QD_TIMING(ide_drive_t *drive)
-{
-	return (unsigned long)ide_get_drivedata(drive) & 0x00ff;
-}
-
-static inline u8 QD_TIMREG(ide_drive_t *drive)
-{
-	return ((unsigned long)ide_get_drivedata(drive) & 0xff00) >> 8;
-}
-
-#define QD6500_DEF_DATA		((QD_TIM1_PORT<<8) | (QD_ID3 ? 0x0c : 0x08))
-#define QD6580_DEF_DATA		((QD_TIM1_PORT<<8) | (QD_ID3 ? 0x0a : 0x00))
-#define QD6580_DEF_DATA2	((QD_TIM2_PORT<<8) | (QD_ID3 ? 0x0a : 0x00))
-#define QD_DEF_CONTR		(0x40 | ((control & 0x02) ? 0x9f : 0x1f))
-
-#define QD_TESTVAL		0x19	/* safe value */
-
-/* Drive specific timing taken from DOS driver v3.7 */
-
-static struct qd65xx_timing_s {
-	s8	offset;   /* ofset from the beginning of Model Number" */
-	char	model[4];    /* 4 chars from Model number, no conversion */
-	s16	active;   /* active time */
-	s16	recovery; /* recovery time */
-} qd65xx_timing [] = {
-	{ 30, "2040", 110, 225 },  /* Conner CP30204			*/
-	{ 30, "2045", 135, 225 },  /* Conner CP30254			*/
-	{ 30, "1040", 155, 325 },  /* Conner CP30104			*/
-	{ 30, "1047", 135, 265 },  /* Conner CP30174			*/
-	{ 30, "5344", 135, 225 },  /* Conner CP3544			*/
-	{ 30, "01 4", 175, 405 },  /* Conner CP-3104			*/
-	{ 27, "C030", 175, 375 },  /* Conner CP3000			*/
-	{  8, "PL42", 110, 295 },  /* Quantum LP240			*/
-	{  8, "PL21", 110, 315 },  /* Quantum LP120			*/
-	{  8, "PL25", 175, 385 },  /* Quantum LP52			*/
-	{  4, "PA24", 110, 285 },  /* WD Piranha SP4200			*/
-	{  6, "2200", 110, 260 },  /* WD Caviar AC2200			*/
-	{  6, "3204", 110, 235 },  /* WD Caviar AC2340			*/
-	{  6, "1202", 110, 265 },  /* WD Caviar AC2120			*/
-	{  0, "DS3-", 135, 315 },  /* Teac SD340			*/
-	{  8, "KM32", 175, 355 },  /* Toshiba MK234			*/
-	{  2, "53A1", 175, 355 },  /* Seagate ST351A			*/
-	{  2, "4108", 175, 295 },  /* Seagate ST1480A			*/
-	{  2, "1344", 175, 335 },  /* Seagate ST3144A			*/
-	{  6, "7 12", 110, 225 },  /* Maxtor 7213A			*/
-	{ 30, "02F4", 145, 295 },  /* Conner 3204F			*/
-	{  2, "1302", 175, 335 },  /* Seagate ST3120A			*/
-	{  2, "2334", 145, 265 },  /* Seagate ST3243A			*/
-	{  2, "2338", 145, 275 },  /* Seagate ST3283A			*/
-	{  2, "3309", 145, 275 },  /* Seagate ST3390A			*/
-	{  2, "5305", 145, 275 },  /* Seagate ST3550A			*/
-	{  2, "4100", 175, 295 },  /* Seagate ST1400A			*/
-	{  2, "4110", 175, 295 },  /* Seagate ST1401A			*/
-	{  2, "6300", 135, 265 },  /* Seagate ST3600A			*/
-	{  2, "5300", 135, 265 },  /* Seagate ST3500A			*/
-	{  6, "7 31", 135, 225 },  /* Maxtor 7131 AT			*/
-	{  6, "7 43", 115, 265 },  /* Maxtor 7345 AT			*/
-	{  6, "7 42", 110, 255 },  /* Maxtor 7245 AT			*/
-	{  6, "3 04", 135, 265 },  /* Maxtor 340 AT			*/
-	{  6, "61 0", 135, 285 },  /* WD AC160				*/
-	{  6, "1107", 135, 235 },  /* WD AC1170				*/
-	{  6, "2101", 110, 220 },  /* WD AC1210				*/
-	{  6, "4202", 135, 245 },  /* WD AC2420				*/
-	{  6, "41 0", 175, 355 },  /* WD Caviar 140			*/
-	{  6, "82 0", 175, 355 },  /* WD Caviar 280			*/
-	{  8, "PL01", 175, 375 },  /* Quantum LP105			*/
-	{  8, "PL25", 110, 295 },  /* Quantum LP525			*/
-	{ 10, "4S 2", 175, 385 },  /* Quantum ELS42			*/
-	{ 10, "8S 5", 175, 385 },  /* Quantum ELS85			*/
-	{ 10, "1S72", 175, 385 },  /* Quantum ELS127			*/
-	{ 10, "1S07", 175, 385 },  /* Quantum ELS170			*/
-	{  8, "ZE42", 135, 295 },  /* Quantum EZ240			*/
-	{  8, "ZE21", 175, 385 },  /* Quantum EZ127			*/
-	{  8, "ZE58", 175, 385 },  /* Quantum EZ85			*/
-	{  8, "ZE24", 175, 385 },  /* Quantum EZ42			*/
-	{ 27, "C036", 155, 325 },  /* Conner CP30064			*/
-	{ 27, "C038", 155, 325 },  /* Conner CP30084			*/
-	{  6, "2205", 110, 255 },  /* WDC AC2250			*/
-	{  2, " CHA", 140, 415 },  /* WDC AH series; WDC AH260, WDC	*/
-	{  2, " CLA", 140, 415 },  /* WDC AL series: WDC AL2120, 2170,	*/
-	{  4, "UC41", 140, 415 },  /* WDC CU140				*/
-	{  6, "1207", 130, 275 },  /* WDC AC2170			*/
-	{  6, "2107", 130, 275 },  /* WDC AC1270			*/
-	{  6, "5204", 130, 275 },  /* WDC AC2540			*/
-	{ 30, "3004", 110, 235 },  /* Conner CP30340			*/
-	{ 30, "0345", 135, 255 },  /* Conner CP30544			*/
-	{ 12, "12A3", 175, 320 },  /* MAXTOR LXT-213A			*/
-	{ 12, "43A0", 145, 240 },  /* MAXTOR LXT-340A			*/
-	{  6, "7 21", 180, 290 },  /* Maxtor 7120 AT			*/
-	{  6, "7 71", 135, 240 },  /* Maxtor 7170 AT			*/
-	{ 12, "45\0000", 110, 205 },   /* MAXTOR MXT-540		*/
-	{  8, "PL11", 180, 290 },  /* QUANTUM LP110A			*/
-	{  8, "OG21", 150, 275 },  /* QUANTUM GO120			*/
-	{ 12, "42A5", 175, 320 },  /* MAXTOR LXT-245A			*/
-	{  2, "2309", 175, 295 },  /* ST3290A				*/
-	{  2, "3358", 180, 310 },  /* ST3385A				*/
-	{  2, "6355", 180, 310 },  /* ST3655A				*/
-	{  2, "1900", 175, 270 },  /* ST9100A				*/
-	{  2, "1954", 175, 270 },  /* ST9145A				*/
-	{  2, "1909", 175, 270 },  /* ST9190AG				*/
-	{  2, "2953", 175, 270 },  /* ST9235A				*/
-	{  2, "1359", 175, 270 },  /* ST3195A				*/
-	{ 24, "3R11", 175, 290 },  /* ALPS ELECTRIC Co.,LTD, DR311C	*/
-	{  0, "2M26", 175, 215 },  /* M262XT-0Ah			*/
-	{  4, "2253", 175, 300 },  /* HP C2235A				*/
-	{  4, "-32A", 145, 245 },  /* H3133-A2				*/
-	{ 30, "0326", 150, 270 },  /* Samsung Electronics 120MB		*/
-	{ 30, "3044", 110, 195 },  /* Conner CFA340A			*/
-	{ 30, "43A0", 110, 195 },  /* Conner CFA340A			*/
-	{ -1, "    ", 175, 415 }   /* unknown disk name			*/
-};
Index: b/drivers/ide/umc8672.c
===================================================================
--- a/drivers/ide/umc8672.c
+++ /dev/null
@@ -1,183 +0,0 @@
-/*
- *  Copyright (C) 1995-1996  Linus Torvalds & author (see below)
- */
-
-/*
- *  Principal Author/Maintainer:  PODIEN@hml2.atlas.de (Wolfram Podien)
- *
- *  This file provides support for the advanced features
- *  of the UMC 8672 IDE interface.
- *
- *  Version 0.01	Initial version, hacked out of ide.c,
- *			and #include'd rather than compiled separately.
- *			This will get cleaned up in a subsequent release.
- *
- *  Version 0.02	now configs/compiles separate from ide.c  -ml
- *  Version 0.03	enhanced auto-tune, fix display bug
- *  Version 0.05	replace sti() with restore_flags()  -ml
- *			add detection of possible race condition  -ml
- */
-
-/*
- * VLB Controller Support from
- * Wolfram Podien
- * Rohoefe 3
- * D28832 Achim
- * Germany
- *
- * To enable UMC8672 support there must a lilo line like
- * append="ide0=umc8672"...
- * To set the speed according to the abilities of the hardware there must be a
- * line like
- * #define UMC_DRIVE0 11
- * in the beginning of the driver, which sets the speed of drive 0 to 11 (there
- * are some lines present). 0 - 11 are allowed speed values. These values are
- * the results from the DOS speed test program supplied from UMC. 11 is the
- * highest speed (about PIO mode 3)
- */
-#define REALLY_SLOW_IO		/* some systems can safely undef this */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
-#include <linux/ide.h>
-#include <linux/init.h>
-
-#include <asm/io.h>
-
-#define DRV_NAME "umc8672"
-
-/*
- * Default speeds.  These can be changed with "auto-tune" and/or hdparm.
- */
-#define UMC_DRIVE0      1              /* DOS measured drive speeds */
-#define UMC_DRIVE1      1              /* 0 to 11 allowed */
-#define UMC_DRIVE2      1              /* 11 = Fastest Speed */
-#define UMC_DRIVE3      1              /* In case of crash reduce speed */
-
-static u8 current_speeds[4] = {UMC_DRIVE0, UMC_DRIVE1, UMC_DRIVE2, UMC_DRIVE3};
-static const u8 pio_to_umc [5] = {0, 3, 7, 10, 11};	/* rough guesses */
-
-/*       0    1    2    3    4    5    6    7    8    9    10   11      */
-static const u8 speedtab [3][12] = {
-	{0x0f, 0x0b, 0x02, 0x02, 0x02, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x1},
-	{0x03, 0x02, 0x02, 0x02, 0x02, 0x02, 0x01, 0x01, 0x01, 0x01, 0x01, 0x1},
-	{0xff, 0xcb, 0xc0, 0x58, 0x36, 0x33, 0x23, 0x22, 0x21, 0x11, 0x10, 0x0}
-};
-
-static void out_umc(char port, char wert)
-{
-	outb_p(port, 0x108);
-	outb_p(wert, 0x109);
-}
-
-static inline u8 in_umc(char port)
-{
-	outb_p(port, 0x108);
-	return inb_p(0x109);
-}
-
-static void umc_set_speeds(u8 speeds[])
-{
-	int i, tmp;
-
-	outb_p(0x5A, 0x108); /* enable umc */
-
-	out_umc(0xd7, (speedtab[0][speeds[2]] | (speedtab[0][speeds[3]]<<4)));
-	out_umc(0xd6, (speedtab[0][speeds[0]] | (speedtab[0][speeds[1]]<<4)));
-	tmp = 0;
-	for (i = 3; i >= 0; i--)
-		tmp = (tmp << 2) | speedtab[1][speeds[i]];
-	out_umc(0xdc, tmp);
-	for (i = 0; i < 4; i++) {
-		out_umc(0xd0 + i, speedtab[2][speeds[i]]);
-		out_umc(0xd8 + i, speedtab[2][speeds[i]]);
-	}
-	outb_p(0xa5, 0x108); /* disable umc */
-
-	printk("umc8672: drive speeds [0 to 11]: %d %d %d %d\n",
-		speeds[0], speeds[1], speeds[2], speeds[3]);
-}
-
-static void umc_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	ide_hwif_t *mate = hwif->mate;
-	unsigned long uninitialized_var(flags);
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-
-	printk("%s: setting umc8672 to PIO mode%d (speed %d)\n",
-		drive->name, pio, pio_to_umc[pio]);
-	if (mate)
-		spin_lock_irqsave(&mate->lock, flags);
-	if (mate && mate->handler) {
-		printk(KERN_ERR "umc8672: other interface is busy: exiting tune_umc()\n");
-	} else {
-		current_speeds[drive->name[2] - 'a'] = pio_to_umc[pio];
-		umc_set_speeds(current_speeds);
-	}
-	if (mate)
-		spin_unlock_irqrestore(&mate->lock, flags);
-}
-
-static const struct ide_port_ops umc8672_port_ops = {
-	.set_pio_mode		= umc_set_pio_mode,
-};
-
-static const struct ide_port_info umc8672_port_info __initdata = {
-	.name			= DRV_NAME,
-	.chipset		= ide_umc8672,
-	.port_ops		= &umc8672_port_ops,
-	.host_flags		= IDE_HFLAG_NO_DMA,
-	.pio_mask		= ATA_PIO4,
-};
-
-static int __init umc8672_probe(void)
-{
-	unsigned long flags;
-
-	if (!request_region(0x108, 2, "umc8672")) {
-		printk(KERN_ERR "umc8672: ports 0x108-0x109 already in use.\n");
-		return 1;
-	}
-	local_irq_save(flags);
-	outb_p(0x5A, 0x108); /* enable umc */
-	if (in_umc (0xd5) != 0xa0) {
-		local_irq_restore(flags);
-		printk(KERN_ERR "umc8672: not found\n");
-		release_region(0x108, 2);
-		return 1;
-	}
-	outb_p(0xa5, 0x108); /* disable umc */
-
-	umc_set_speeds(current_speeds);
-	local_irq_restore(flags);
-
-	return ide_legacy_device_add(&umc8672_port_info, 0);
-}
-
-static int probe_umc8672;
-
-module_param_named(probe, probe_umc8672, bool, 0);
-MODULE_PARM_DESC(probe, "probe for UMC8672 chipset");
-
-static int __init umc8672_init(void)
-{
-	if (probe_umc8672 == 0)
-		goto out;
-
-	if (umc8672_probe() == 0)
-		return 0;
-out:
-	return -ENODEV;
-}
-
-module_init(umc8672_init);
-
-MODULE_AUTHOR("Wolfram Podien");
-MODULE_DESCRIPTION("Support for UMC 8672 IDE chipset");
-MODULE_LICENSE("GPL");
Index: b/drivers/staging/Kconfig
===================================================================
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -125,5 +125,7 @@ source "drivers/staging/sep/Kconfig"
 
 source "drivers/staging/iio/Kconfig"
 
+source "drivers/staging/ide-vlb/Kconfig"
+
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
Index: b/drivers/staging/Makefile
===================================================================
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -44,3 +44,4 @@ obj-$(CONFIG_VME_BUS)		+= vme/
 obj-$(CONFIG_RAR_REGISTER)	+= rar/
 obj-$(CONFIG_DX_SEP)		+= sep/
 obj-$(CONFIG_IIO)		+= iio/
+obj-$(CONFIG_IDE)		+= ide-vlb/
Index: b/drivers/staging/ide-vlb/Kconfig
===================================================================
--- /dev/null
+++ b/drivers/staging/ide-vlb/Kconfig
@@ -0,0 +1,69 @@
+
+# no isa -> no vlb
+if ISA && (ALPHA || X86 || MIPS) && IDE
+
+config IDE_VLB_4DRIVES
+	tristate "Generic 4 drives/port ISA/VLB IDE support"
+	help
+	  Certain older chipsets, including the Tekram 690CD, use a single set
+	  of I/O ports at 0x1f0 to control up to four drives, instead of the
+	  customary two drives per port. Support for this can be enabled at
+	  runtime using the "ide-4drives.probe" kernel boot parameter if you
+	  say Y here.
+
+config IDE_VLB_ALI14XX
+	tristate "ALI M14xx VLB IDE support"
+	select IDE_TIMINGS
+	select IDE_LEGACY
+	help
+	  This driver is enabled at runtime using the "ali14xx.probe" kernel
+	  boot parameter.  It enables support for the secondary IDE interface
+	  of the ALI M1439/1443/1445/1487/1489 chipsets, and permits faster
+	  I/O speeds to be set as well.
+	  See the files <file:Documentation/ide/ide.txt> and
+	  <file:drivers/ide/legacy/ali14xx.c> for more info.
+
+config IDE_VLB_DTC2278
+	tristate "DTC-2278 VLB IDE support"
+	select IDE_XFER_MODE
+	select IDE_LEGACY
+	help
+	  This driver is enabled at runtime using the "dtc2278.probe" kernel
+	  boot parameter. It enables support for the secondary IDE interface
+	  of the DTC-2278 card, and permits faster I/O speeds to be set as
+	  well. See the <file:Documentation/ide/ide.txt> and
+	  <file:drivers/ide/legacy/dtc2278.c> files for more info.
+
+config IDE_VLB_HT6560B
+	tristate "Holtek HT6560B VLB IDE support"
+	select IDE_TIMINGS
+	select IDE_LEGACY
+	help
+	  This driver is enabled at runtime using the "ht6560b.probe" kernel
+	  boot parameter. It enables support for the secondary IDE interface
+	  of the Holtek card, and permits faster I/O speeds to be set as well.
+	  See the <file:Documentation/ide/ide.txt> and
+	  <file:drivers/ide/legacy/ht6560b.c> files for more info.
+
+config IDE_VLB_QD65XX
+	tristate "QDI QD65xx VLB IDE support"
+	select IDE_TIMINGS
+	select IDE_LEGACY
+	help
+	  This driver is enabled at runtime using the "qd65xx.probe" kernel
+	  boot parameter.  It permits faster I/O speeds to be set.  See the
+	  <file:Documentation/ide/ide.txt> and <file:drivers/ide/legacy/qd65xx.c>
+	  for more info.
+
+config IDE_VLB_UMC8672
+	tristate "UMC-8672 VLB IDE support"
+	select IDE_XFER_MODE
+	select IDE_LEGACY
+	help
+	  This driver is enabled at runtime using the "umc8672.probe" kernel
+	  boot parameter. It enables support for the secondary IDE interface
+	  of the UMC-8672, and permits faster I/O speeds to be set as well.
+	  See the files <file:Documentation/ide/ide.txt> and
+	  <file:drivers/ide/legacy/umc8672.c> for more info.
+
+endif
Index: b/drivers/staging/ide-vlb/Makefile
===================================================================
--- /dev/null
+++ b/drivers/staging/ide-vlb/Makefile
@@ -0,0 +1,7 @@
+
+obj-$(CONFIG_IDE_VLB_ALI14XX)		+= ali14xx.o
+obj-$(CONFIG_IDE_VLB_UMC8672)		+= umc8672.o
+obj-$(CONFIG_IDE_VLB_DTC2278)		+= dtc2278.o
+obj-$(CONFIG_IDE_VLB_HT6560B)		+= ht6560b.o
+obj-$(CONFIG_IDE_VLB_QD65XX)		+= qd65xx.o
+obj-$(CONFIG_IDE_VLB_4DRIVES)		+= ide-4drives.o
Index: b/drivers/staging/ide-vlb/TODO
===================================================================
--- /dev/null
+++ b/drivers/staging/ide-vlb/TODO
@@ -0,0 +1,5 @@
+TODO:
+	- add missing hardware support to drivers/ata/pata_legacy driver
+	  and then maintain it to ensure that it continues to work.  Having
+	  the hardware for this is pretty much a requirement.  If this does
+	  not happen, the code will be removed in the 2.6.36 kernel release.
Index: b/drivers/staging/ide-vlb/ali14xx.c
===================================================================
--- /dev/null
+++ b/drivers/staging/ide-vlb/ali14xx.c
@@ -0,0 +1,249 @@
+/*
+ *  Copyright (C) 1996  Linus Torvalds & author (see below)
+ */
+
+/*
+ * ALI M14xx chipset EIDE controller
+ *
+ * Works for ALI M1439/1443/1445/1487/1489 chipsets.
+ *
+ * Adapted from code developed by derekn@vw.ece.cmu.edu.  -ml
+ * Derek's notes follow:
+ *
+ * I think the code should be pretty understandable,
+ * but I'll be happy to (try to) answer questions.
+ *
+ * The critical part is in the setupDrive function.  The initRegisters
+ * function doesn't seem to be necessary, but the DOS driver does it, so
+ * I threw it in.
+ *
+ * I've only tested this on my system, which only has one disk.  I posted
+ * it to comp.sys.linux.hardware, so maybe some other people will try it
+ * out.
+ *
+ * Derek Noonburg  (derekn@ece.cmu.edu)
+ * 95-sep-26
+ *
+ * Update 96-jul-13:
+ *
+ * I've since upgraded to two disks and a CD-ROM, with no trouble, and
+ * I've also heard from several others who have used it successfully.
+ * This driver appears to work with both the 1443/1445 and the 1487/1489
+ * chipsets.  I've added support for PIO mode 4 for the 1487.  This
+ * seems to work just fine on the 1443 also, although I'm not sure it's
+ * advertised as supporting mode 4.  (I've been running a WDC AC21200 in
+ * mode 4 for a while now with no trouble.)  -Derek
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/mm.h>
+#include <linux/ioport.h>
+#include <linux/blkdev.h>
+#include <linux/ide.h>
+#include <linux/init.h>
+
+#include <asm/io.h>
+
+#define DRV_NAME "ali14xx"
+
+/* port addresses for auto-detection */
+#define ALI_NUM_PORTS 4
+static const int ports[ALI_NUM_PORTS] __initdata =
+	{ 0x074, 0x0f4, 0x034, 0x0e4 };
+
+/* register initialization data */
+typedef struct { u8 reg, data; } RegInitializer;
+
+static const RegInitializer initData[] __initdata = {
+	{0x01, 0x0f}, {0x02, 0x00}, {0x03, 0x00}, {0x04, 0x00},
+	{0x05, 0x00}, {0x06, 0x00}, {0x07, 0x2b}, {0x0a, 0x0f},
+	{0x25, 0x00}, {0x26, 0x00}, {0x27, 0x00}, {0x28, 0x00},
+	{0x29, 0x00}, {0x2a, 0x00}, {0x2f, 0x00}, {0x2b, 0x00},
+	{0x2c, 0x00}, {0x2d, 0x00}, {0x2e, 0x00}, {0x30, 0x00},
+	{0x31, 0x00}, {0x32, 0x00}, {0x33, 0x00}, {0x34, 0xff},
+	{0x35, 0x03}, {0x00, 0x00}
+};
+
+/* timing parameter registers for each drive */
+static struct { u8 reg1, reg2, reg3, reg4; } regTab[4] = {
+	{0x03, 0x26, 0x04, 0x27},     /* drive 0 */
+	{0x05, 0x28, 0x06, 0x29},     /* drive 1 */
+	{0x2b, 0x30, 0x2c, 0x31},     /* drive 2 */
+	{0x2d, 0x32, 0x2e, 0x33},     /* drive 3 */
+};
+
+static int basePort;	/* base port address */
+static int regPort;	/* port for register number */
+static int dataPort;	/* port for register data */
+static u8 regOn;	/* output to base port to access registers */
+static u8 regOff;	/* output to base port to close registers */
+
+/*------------------------------------------------------------------------*/
+
+/*
+ * Read a controller register.
+ */
+static inline u8 inReg(u8 reg)
+{
+	outb_p(reg, regPort);
+	return inb(dataPort);
+}
+
+/*
+ * Write a controller register.
+ */
+static void outReg(u8 data, u8 reg)
+{
+	outb_p(reg, regPort);
+	outb_p(data, dataPort);
+}
+
+static DEFINE_SPINLOCK(ali14xx_lock);
+
+/*
+ * Set PIO mode for the specified drive.
+ * This function computes timing parameters
+ * and sets controller registers accordingly.
+ */
+static void ali14xx_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
+{
+	int driveNum;
+	int time1, time2;
+	u8 param1, param2, param3, param4;
+	unsigned long flags;
+	int bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
+	const struct ata_timing *t = ata_timing_find_mode(XFER_PIO_0 + pio);
+
+	/* calculate timing, according to PIO mode */
+	time1 = ide_pio_cycle_time(drive, pio);
+	time2 = t->active;
+	param3 = param1 = (time2 * bus_speed + 999) / 1000;
+	param4 = param2 = (time1 * bus_speed + 999) / 1000 - param1;
+	if (pio < 3) {
+		param3 += 8;
+		param4 += 8;
+	}
+	printk(KERN_DEBUG "%s: PIO mode%d, t1=%dns, t2=%dns, cycles = %d+%d, %d+%d\n",
+		drive->name, pio, time1, time2, param1, param2, param3, param4);
+
+	/* stuff timing parameters into controller registers */
+	driveNum = (drive->hwif->index << 1) + (drive->dn & 1);
+	spin_lock_irqsave(&ali14xx_lock, flags);
+	outb_p(regOn, basePort);
+	outReg(param1, regTab[driveNum].reg1);
+	outReg(param2, regTab[driveNum].reg2);
+	outReg(param3, regTab[driveNum].reg3);
+	outReg(param4, regTab[driveNum].reg4);
+	outb_p(regOff, basePort);
+	spin_unlock_irqrestore(&ali14xx_lock, flags);
+}
+
+/*
+ * Auto-detect the IDE controller port.
+ */
+static int __init findPort(void)
+{
+	int i;
+	u8 t;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	for (i = 0; i < ALI_NUM_PORTS; ++i) {
+		basePort = ports[i];
+		regOff = inb(basePort);
+		for (regOn = 0x30; regOn <= 0x33; ++regOn) {
+			outb_p(regOn, basePort);
+			if (inb(basePort) == regOn) {
+				regPort = basePort + 4;
+				dataPort = basePort + 8;
+				t = inReg(0) & 0xf0;
+				outb_p(regOff, basePort);
+				local_irq_restore(flags);
+				if (t != 0x50)
+					return 0;
+				return 1;  /* success */
+			}
+		}
+		outb_p(regOff, basePort);
+	}
+	local_irq_restore(flags);
+	return 0;
+}
+
+/*
+ * Initialize controller registers with default values.
+ */
+static int __init initRegisters(void)
+{
+	const RegInitializer *p;
+	u8 t;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	outb_p(regOn, basePort);
+	for (p = initData; p->reg != 0; ++p)
+		outReg(p->data, p->reg);
+	outb_p(0x01, regPort);
+	t = inb(regPort) & 0x01;
+	outb_p(regOff, basePort);
+	local_irq_restore(flags);
+	return t;
+}
+
+static const struct ide_port_ops ali14xx_port_ops = {
+	.set_pio_mode		= ali14xx_set_pio_mode,
+};
+
+static const struct ide_port_info ali14xx_port_info = {
+	.name			= DRV_NAME,
+	.chipset		= ide_ali14xx,
+	.port_ops		= &ali14xx_port_ops,
+	.host_flags		= IDE_HFLAG_NO_DMA,
+	.pio_mask		= ATA_PIO4,
+};
+
+static int __init ali14xx_probe(void)
+{
+	printk(KERN_DEBUG "ali14xx: base=0x%03x, regOn=0x%02x.\n",
+			  basePort, regOn);
+
+	/* initialize controller registers */
+	if (!initRegisters()) {
+		printk(KERN_ERR "ali14xx: Chip initialization failed.\n");
+		return 1;
+	}
+
+	return ide_legacy_device_add(&ali14xx_port_info, 0);
+}
+
+static int probe_ali14xx;
+
+module_param_named(probe, probe_ali14xx, bool, 0);
+MODULE_PARM_DESC(probe, "probe for ALI M14xx chipsets");
+
+static int __init ali14xx_init(void)
+{
+	if (probe_ali14xx == 0)
+		goto out;
+
+	/* auto-detect IDE controller port */
+	if (findPort()) {
+		if (ali14xx_probe())
+			return -ENODEV;
+		return 0;
+	}
+	printk(KERN_ERR "ali14xx: not found.\n");
+out:
+	return -ENODEV;
+}
+
+module_init(ali14xx_init);
+
+MODULE_AUTHOR("see local file");
+MODULE_DESCRIPTION("support of ALI 14XX IDE chipsets");
+MODULE_LICENSE("GPL");
Index: b/drivers/staging/ide-vlb/dtc2278.c
===================================================================
--- /dev/null
+++ b/drivers/staging/ide-vlb/dtc2278.c
@@ -0,0 +1,154 @@
+/*
+ *  Copyright (C) 1996  Linus Torvalds & author (see below)
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/mm.h>
+#include <linux/ioport.h>
+#include <linux/blkdev.h>
+#include <linux/ide.h>
+#include <linux/init.h>
+
+#include <asm/io.h>
+
+#define DRV_NAME "dtc2278"
+
+/*
+ * Changing this #undef to #define may solve start up problems in some systems.
+ */
+#undef ALWAYS_SET_DTC2278_PIO_MODE
+
+/*
+ * From: andy@cercle.cts.com (Dyan Wile)
+ *
+ * Below is a patch for DTC-2278 - alike software-programmable controllers
+ * The code enables the secondary IDE controller and the PIO4 (3?) timings on
+ * the primary (EIDE). You may probably have to enable the 32-bit support to
+ * get the full speed. You better get the disk interrupts disabled ( hdparm -u0
+ * /dev/hd.. ) for the drives connected to the EIDE interface. (I get my
+ * filesystem  corrupted with -u1, but under heavy disk load only :-)
+ *
+ * This card is now forced to use the "serialize" feature,
+ * and irq-unmasking is disallowed.  If io_32bit is enabled,
+ * it must be done for BOTH drives on each interface.
+ *
+ * This code was written for the DTC2278E, but might work with any of these:
+ *
+ * DTC2278S has only a single IDE interface.
+ * DTC2278D has two IDE interfaces and is otherwise identical to the S version.
+ * DTC2278E also has serial ports and a printer port
+ * DTC2278EB: has onboard BIOS, and "works like a charm" -- Kent Bradford <kent@theory.caltech.edu>
+ *
+ * There may be a fourth controller type. The S and D versions use the
+ * Winbond chip, and I think the E version does also.
+ *
+ */
+
+static void sub22 (char b, char c)
+{
+	int i;
+
+	for(i = 0; i < 3; ++i) {
+		inb(0x3f6);
+		outb_p(b,0xb0);
+		inb(0x3f6);
+		outb_p(c,0xb4);
+		inb(0x3f6);
+		if(inb(0xb4) == c) {
+			outb_p(7,0xb0);
+			inb(0x3f6);
+			return;	/* success */
+		}
+	}
+}
+
+static DEFINE_SPINLOCK(dtc2278_lock);
+
+static void dtc2278_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
+{
+	unsigned long flags;
+
+	if (drive->pio_mode >= XFER_PIO_3) {
+		spin_lock_irqsave(&dtc2278_lock, flags);
+		/*
+		 * This enables PIO mode4 (3?) on the first interface
+		 */
+		sub22(1,0xc3);
+		sub22(0,0xa0);
+		spin_unlock_irqrestore(&dtc2278_lock, flags);
+	} else {
+		/* we don't know how to set it back again.. */
+		/* Actually we do - there is a data sheet available for the
+		   Winbond but does anyone actually care */
+	}
+}
+
+static const struct ide_port_ops dtc2278_port_ops = {
+	.set_pio_mode		= dtc2278_set_pio_mode,
+};
+
+static const struct ide_port_info dtc2278_port_info __initdata = {
+	.name			= DRV_NAME,
+	.chipset		= ide_dtc2278,
+	.port_ops		= &dtc2278_port_ops,
+	.host_flags		= IDE_HFLAG_SERIALIZE |
+				  IDE_HFLAG_NO_UNMASK_IRQS |
+				  IDE_HFLAG_IO_32BIT |
+				  /* disallow ->io_32bit changes */
+				  IDE_HFLAG_NO_IO_32BIT |
+				  IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_DTC2278,
+	.pio_mask		= ATA_PIO4,
+};
+
+static int __init dtc2278_probe(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	/*
+	 * This enables the second interface
+	 */
+	outb_p(4,0xb0);
+	inb(0x3f6);
+	outb_p(0x20,0xb4);
+	inb(0x3f6);
+#ifdef ALWAYS_SET_DTC2278_PIO_MODE
+	/*
+	 * This enables PIO mode4 (3?) on the first interface
+	 * and may solve start-up problems for some people.
+	 */
+	sub22(1,0xc3);
+	sub22(0,0xa0);
+#endif
+	local_irq_restore(flags);
+
+	return ide_legacy_device_add(&dtc2278_port_info, 0);
+}
+
+static int probe_dtc2278;
+
+module_param_named(probe, probe_dtc2278, bool, 0);
+MODULE_PARM_DESC(probe, "probe for DTC2278xx chipsets");
+
+static int __init dtc2278_init(void)
+{
+	if (probe_dtc2278 == 0)
+		return -ENODEV;
+
+	if (dtc2278_probe()) {
+		printk(KERN_ERR "dtc2278: ide interfaces already in use!\n");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+module_init(dtc2278_init);
+
+MODULE_AUTHOR("See Local File");
+MODULE_DESCRIPTION("support of DTC-2278 VLB IDE chipsets");
+MODULE_LICENSE("GPL");
Index: b/drivers/staging/ide-vlb/ht6560b.c
===================================================================
--- /dev/null
+++ b/drivers/staging/ide-vlb/ht6560b.c
@@ -0,0 +1,384 @@
+/*
+ *  Copyright (C) 1995-2000  Linus Torvalds & author (see below)
+ */
+
+/*
+ *  HT-6560B EIDE-controller support
+ *  To activate controller support use kernel parameter "ide0=ht6560b".
+ *  Use hdparm utility to enable PIO mode support.
+ *
+ *  Author:    Mikko Ala-Fossi            <maf@iki.fi>
+ *             Jan Evert van Grootheest   <j.e.van.grootheest@caiway.nl>
+ *
+ *  Try:  http://www.maf.iki.fi/~maf/ht6560b/
+ */
+
+#define DRV_NAME	"ht6560b"
+#define HT6560B_VERSION "v0.08"
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/mm.h>
+#include <linux/ioport.h>
+#include <linux/blkdev.h>
+#include <linux/ide.h>
+#include <linux/init.h>
+
+#include <asm/io.h>
+
+/* #define DEBUG */  /* remove comments for DEBUG messages */
+
+/*
+ * The special i/o-port that HT-6560B uses to configuration:
+ *    bit0 (0x01): "1" selects secondary interface
+ *    bit2 (0x04): "1" enables FIFO function
+ *    bit5 (0x20): "1" enables prefetched data read function  (???)
+ *
+ * The special i/o-port that HT-6560A uses to configuration:
+ *    bit0 (0x01): "1" selects secondary interface
+ *    bit1 (0x02): "1" enables prefetched data read function
+ *    bit2 (0x04): "0" enables multi-master system	      (?)
+ *    bit3 (0x08): "1" 3 cycle time, "0" 2 cycle time	      (?)
+ */
+#define HT_CONFIG_PORT	  0x3e6
+
+static inline u8 HT_CONFIG(ide_drive_t *drive)
+{
+	return ((unsigned long)ide_get_drivedata(drive) & 0xff00) >> 8;
+}
+
+/*
+ * FIFO + PREFETCH (both a/b-model)
+ */
+#define HT_CONFIG_DEFAULT 0x1c /* no prefetch */
+/* #define HT_CONFIG_DEFAULT 0x3c */ /* with prefetch */
+#define HT_SECONDARY_IF	  0x01
+#define HT_PREFETCH_MODE  0x20
+
+/*
+ * ht6560b Timing values:
+ *
+ * I reviewed some assembler source listings of htide drivers and found
+ * out how they setup those cycle time interfacing values, as they at Holtek
+ * call them. IDESETUP.COM that is supplied with the drivers figures out
+ * optimal values and fetches those values to drivers. I found out that
+ * they use Select register to fetch timings to the ide board right after
+ * interface switching. After that it was quite easy to add code to
+ * ht6560b.c.
+ *
+ * IDESETUP.COM gave me values 0x24, 0x45, 0xaa, 0xff that worked fine
+ * for hda and hdc. But hdb needed higher values to work, so I guess
+ * that sometimes it is necessary to give higher value than IDESETUP
+ * gives.   [see cmd640.c for an extreme example of this. -ml]
+ *
+ * Perhaps I should explain something about these timing values:
+ * The higher nibble of value is the Recovery Time  (rt) and the lower nibble
+ * of the value is the Active Time  (at). Minimum value 2 is the fastest and
+ * the maximum value 15 is the slowest. Default values should be 15 for both.
+ * So 0x24 means 2 for rt and 4 for at. Each of the drives should have
+ * both values, and IDESETUP gives automatically rt=15 st=15 for CDROMs or
+ * similar. If value is too small there will be all sorts of failures.
+ *
+ * Timing byte consists of
+ *	High nibble:  Recovery Cycle Time  (rt)
+ *	     The valid values range from 2 to 15. The default is 15.
+ *
+ *	Low nibble:   Active Cycle Time	   (at)
+ *	     The valid values range from 2 to 15. The default is 15.
+ *
+ * You can obtain optimized timing values by running Holtek IDESETUP.COM
+ * for DOS. DOS drivers get their timing values from command line, where
+ * the first value is the Recovery Time and the second value is the
+ * Active Time for each drive. Smaller value gives higher speed.
+ * In case of failures you should probably fall back to a higher value.
+ */
+static inline u8 HT_TIMING(ide_drive_t *drive)
+{
+	return (unsigned long)ide_get_drivedata(drive) & 0x00ff;
+}
+
+#define HT_TIMING_DEFAULT 0xff
+
+/*
+ * This routine handles interface switching for the peculiar hardware design
+ * on the F.G.I./Holtek HT-6560B VLB IDE interface.
+ * The HT-6560B can only enable one IDE port at a time, and requires a
+ * silly sequence (below) whenever we switch between primary and secondary.
+ */
+
+/*
+ * This routine is invoked from ide.c to prepare for access to a given drive.
+ */
+static void ht6560b_dev_select(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	unsigned long flags;
+	static u8 current_select = 0;
+	static u8 current_timing = 0;
+	u8 select, timing;
+
+	local_irq_save(flags);
+
+	select = HT_CONFIG(drive);
+	timing = HT_TIMING(drive);
+
+	/*
+	 * Need to enforce prefetch sometimes because otherwise
+	 * it'll hang (hard).
+	 */
+	if (drive->media != ide_disk ||
+	    (drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+		select |= HT_PREFETCH_MODE;
+
+	if (select != current_select || timing != current_timing) {
+		current_select = select;
+		current_timing = timing;
+		(void)inb(HT_CONFIG_PORT);
+		(void)inb(HT_CONFIG_PORT);
+		(void)inb(HT_CONFIG_PORT);
+		(void)inb(HT_CONFIG_PORT);
+		outb(select, HT_CONFIG_PORT);
+		/*
+		 * Set timing for this drive:
+		 */
+		outb(timing, hwif->io_ports.device_addr);
+		(void)inb(hwif->io_ports.status_addr);
+#ifdef DEBUG
+		printk("ht6560b: %s: select=%#x timing=%#x\n",
+			drive->name, select, timing);
+#endif
+	}
+	local_irq_restore(flags);
+
+	outb(drive->select | ATA_DEVICE_OBS, hwif->io_ports.device_addr);
+}
+
+/*
+ * Autodetection and initialization of ht6560b
+ */
+static int __init try_to_init_ht6560b(void)
+{
+	u8 orig_value;
+	int i;
+
+	/* Autodetect ht6560b */
+	if ((orig_value = inb(HT_CONFIG_PORT)) == 0xff)
+		return 0;
+
+	for (i=3;i>0;i--) {
+		outb(0x00, HT_CONFIG_PORT);
+		if (!( (~inb(HT_CONFIG_PORT)) & 0x3f )) {
+			outb(orig_value, HT_CONFIG_PORT);
+			return 0;
+		}
+	}
+	outb(0x00, HT_CONFIG_PORT);
+	if ((~inb(HT_CONFIG_PORT))& 0x3f) {
+		outb(orig_value, HT_CONFIG_PORT);
+		return 0;
+	}
+	/*
+	 * Ht6560b autodetected
+	 */
+	outb(HT_CONFIG_DEFAULT, HT_CONFIG_PORT);
+	outb(HT_TIMING_DEFAULT, 0x1f6);	/* Select register */
+	(void)inb(0x1f7);		/* Status register */
+
+	printk("ht6560b " HT6560B_VERSION
+	       ": chipset detected and initialized"
+#ifdef DEBUG
+	       " with debug enabled"
+#endif
+	       "\n"
+		);
+	return 1;
+}
+
+static u8 ht_pio2timings(ide_drive_t *drive, const u8 pio)
+{
+	int active_time, recovery_time;
+	int active_cycles, recovery_cycles;
+	int bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
+
+        if (pio) {
+		unsigned int cycle_time;
+		const struct ata_timing *t =
+			ata_timing_find_mode(XFER_PIO_0 + pio);
+
+		cycle_time = ide_pio_cycle_time(drive, pio);
+
+		/*
+		 *  Just like opti621.c we try to calculate the
+		 *  actual cycle time for recovery and activity
+		 *  according system bus speed.
+		 */
+		active_time = t->active;
+		recovery_time = cycle_time - active_time - t->setup;
+		/*
+		 *  Cycle times should be Vesa bus cycles
+		 */
+		active_cycles   = (active_time   * bus_speed + 999) / 1000;
+		recovery_cycles = (recovery_time * bus_speed + 999) / 1000;
+		/*
+		 *  Upper and lower limits
+		 */
+		if (active_cycles   < 2)  active_cycles   = 2;
+		if (recovery_cycles < 2)  recovery_cycles = 2;
+		if (active_cycles   > 15) active_cycles   = 15;
+		if (recovery_cycles > 15) recovery_cycles = 0;  /* 0==16 */
+
+#ifdef DEBUG
+		printk("ht6560b: drive %s setting pio=%d recovery=%d (%dns) active=%d (%dns)\n", drive->name, pio, recovery_cycles, recovery_time, active_cycles, active_time);
+#endif
+
+		return (u8)((recovery_cycles << 4) | active_cycles);
+	} else {
+
+#ifdef DEBUG
+		printk("ht6560b: drive %s setting pio=0\n", drive->name);
+#endif
+
+		return HT_TIMING_DEFAULT;    /* default setting */
+	}
+}
+
+static DEFINE_SPINLOCK(ht6560b_lock);
+
+/*
+ *  Enable/Disable so called prefetch mode
+ */
+static void ht_set_prefetch(ide_drive_t *drive, u8 state)
+{
+	unsigned long flags, config;
+	int t = HT_PREFETCH_MODE << 8;
+
+	spin_lock_irqsave(&ht6560b_lock, flags);
+
+	config = (unsigned long)ide_get_drivedata(drive);
+
+	/*
+	 *  Prefetch mode and unmask irq seems to conflict
+	 */
+	if (state) {
+		config |= t;   /* enable prefetch mode */
+		drive->dev_flags |= IDE_DFLAG_NO_UNMASK;
+		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
+	} else {
+		config &= ~t;  /* disable prefetch mode */
+		drive->dev_flags &= ~IDE_DFLAG_NO_UNMASK;
+	}
+
+	ide_set_drivedata(drive, (void *)config);
+
+	spin_unlock_irqrestore(&ht6560b_lock, flags);
+
+#ifdef DEBUG
+	printk("ht6560b: drive %s prefetch mode %sabled\n", drive->name, (state ? "en" : "dis"));
+#endif
+}
+
+static void ht6560b_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
+{
+	unsigned long flags, config;
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
+	u8 timing;
+
+	switch (pio) {
+	case 8:         /* set prefetch off */
+	case 9:         /* set prefetch on */
+		ht_set_prefetch(drive, pio & 1);
+		return;
+	}
+
+	timing = ht_pio2timings(drive, pio);
+
+	spin_lock_irqsave(&ht6560b_lock, flags);
+	config = (unsigned long)ide_get_drivedata(drive);
+	config &= 0xff00;
+	config |= timing;
+	ide_set_drivedata(drive, (void *)config);
+	spin_unlock_irqrestore(&ht6560b_lock, flags);
+
+#ifdef DEBUG
+	printk("ht6560b: drive %s tuned to pio mode %#x timing=%#x\n", drive->name, pio, timing);
+#endif
+}
+
+static void __init ht6560b_init_dev(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	/* Setting default configurations for drives. */
+	int t = (HT_CONFIG_DEFAULT << 8) | HT_TIMING_DEFAULT;
+
+	if (hwif->channel)
+		t |= (HT_SECONDARY_IF << 8);
+
+	ide_set_drivedata(drive, (void *)t);
+}
+
+static int probe_ht6560b;
+
+module_param_named(probe, probe_ht6560b, bool, 0);
+MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
+
+static const struct ide_tp_ops ht6560b_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
+
+	.dev_select		= ht6560b_dev_select,
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
+
+static const struct ide_port_ops ht6560b_port_ops = {
+	.init_dev		= ht6560b_init_dev,
+	.set_pio_mode		= ht6560b_set_pio_mode,
+};
+
+static const struct ide_port_info ht6560b_port_info __initdata = {
+	.name			= DRV_NAME,
+	.chipset		= ide_ht6560b,
+	.tp_ops 		= &ht6560b_tp_ops,
+	.port_ops		= &ht6560b_port_ops,
+	.host_flags		= IDE_HFLAG_SERIALIZE | /* is this needed? */
+				  IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_ABUSE_PREFETCH,
+	.pio_mask		= ATA_PIO4,
+};
+
+static int __init ht6560b_init(void)
+{
+	if (probe_ht6560b == 0)
+		return -ENODEV;
+
+	if (!request_region(HT_CONFIG_PORT, 1, DRV_NAME)) {
+		printk(KERN_NOTICE "%s: HT_CONFIG_PORT not found\n",
+			__func__);
+		return -ENODEV;
+	}
+
+	if (!try_to_init_ht6560b()) {
+		printk(KERN_NOTICE "%s: HBA not found\n", __func__);
+		goto release_region;
+	}
+
+	return ide_legacy_device_add(&ht6560b_port_info, 0);
+
+release_region:
+	release_region(HT_CONFIG_PORT, 1);
+	return -ENODEV;
+}
+
+module_init(ht6560b_init);
+
+MODULE_AUTHOR("See Local File");
+MODULE_DESCRIPTION("HT-6560B EIDE-controller support");
+MODULE_LICENSE("GPL");
Index: b/drivers/staging/ide-vlb/ide-4drives.c
===================================================================
--- /dev/null
+++ b/drivers/staging/ide-vlb/ide-4drives.c
@@ -0,0 +1,64 @@
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/ide.h>
+
+#define DRV_NAME "ide-4drives"
+
+static int probe_4drives;
+
+module_param_named(probe, probe_4drives, bool, 0);
+MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
+
+static void ide_4drives_init_dev(ide_drive_t *drive)
+{
+	if (drive->hwif->channel)
+		drive->select ^= 0x20;
+}
+
+static const struct ide_port_ops ide_4drives_port_ops = {
+	.init_dev		= ide_4drives_init_dev,
+};
+
+static const struct ide_port_info ide_4drives_port_info = {
+	.port_ops		= &ide_4drives_port_ops,
+	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_4DRIVES,
+	.chipset		= ide_4drives,
+};
+
+static int __init ide_4drives_init(void)
+{
+	unsigned long base = 0x1f0, ctl = 0x3f6;
+	struct ide_hw hw, *hws[] = { &hw, &hw };
+
+	if (probe_4drives == 0)
+		return -ENODEV;
+
+	if (!request_region(base, 8, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
+				DRV_NAME, base, base + 7);
+		return -EBUSY;
+	}
+
+	if (!request_region(ctl, 1, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
+				DRV_NAME, ctl);
+		release_region(base, 8);
+		return -EBUSY;
+	}
+
+	memset(&hw, 0, sizeof(hw));
+
+	ide_std_init_ports(&hw, base, ctl);
+	hw.irq = 14;
+
+	return ide_host_add(&ide_4drives_port_info, hws, 2, NULL);
+}
+
+module_init(ide_4drives_init);
+
+MODULE_AUTHOR("Bartlomiej Zolnierkiewicz");
+MODULE_DESCRIPTION("generic IDE chipset with 4 drives/port support");
+MODULE_LICENSE("GPL");
Index: b/drivers/staging/ide-vlb/qd65xx.c
===================================================================
--- /dev/null
+++ b/drivers/staging/ide-vlb/qd65xx.c
@@ -0,0 +1,446 @@
+/*
+ *  Copyright (C) 1996-2001  Linus Torvalds & author (see below)
+ */
+
+/*
+ *  Version 0.03	Cleaned auto-tune, added probe
+ *  Version 0.04	Added second channel tuning
+ *  Version 0.05	Enhanced tuning ; added qd6500 support
+ *  Version 0.06	Added dos driver's list
+ *  Version 0.07	Second channel bug fix
+ *
+ * QDI QD6500/QD6580 EIDE controller fast support
+ *
+ * To activate controller support, use "ide0=qd65xx"
+ */
+
+/*
+ * Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
+ * Samuel Thibault <samuel.thibault@ens-lyon.org>
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/mm.h>
+#include <linux/ioport.h>
+#include <linux/blkdev.h>
+#include <linux/ide.h>
+#include <linux/init.h>
+#include <asm/system.h>
+#include <asm/io.h>
+
+#define DRV_NAME "qd65xx"
+
+#include "qd65xx.h"
+
+/*
+ * I/O ports are 0x30-0x31 (and 0x32-0x33 for qd6580)
+ *            or 0xb0-0xb1 (and 0xb2-0xb3 for qd6580)
+ *	-- qd6500 is a single IDE interface
+ *	-- qd6580 is a dual IDE interface
+ *
+ * More research on qd6580 being done by willmore@cig.mot.com (David)
+ * More Information given by Petr Soucek (petr@ryston.cz)
+ * http://www.ryston.cz/petr/vlb
+ */
+
+/*
+ * base: Timer1
+ *
+ *
+ * base+0x01: Config (R/O)
+ *
+ * bit 0: ide baseport: 1 = 0x1f0 ; 0 = 0x170 (only useful for qd6500)
+ * bit 1: qd65xx baseport: 1 = 0xb0 ; 0 = 0x30
+ * bit 2: ID3: bus speed: 1 = <=33MHz ; 0 = >33MHz
+ * bit 3: qd6500: 1 = disabled, 0 = enabled
+ *        qd6580: 1
+ * upper nibble:
+ *        qd6500: 1100
+ *        qd6580: either 1010 or 0101
+ *
+ *
+ * base+0x02: Timer2 (qd6580 only)
+ *
+ *
+ * base+0x03: Control (qd6580 only)
+ *
+ * bits 0-3 must always be set 1
+ * bit 4 must be set 1, but is set 0 by dos driver while measuring vlb clock
+ * bit 0 : 1 = Only primary port enabled : channel 0 for hda, channel 1 for hdb
+ *         0 = Primary and Secondary ports enabled : channel 0 for hda & hdb
+ *                                                   channel 1 for hdc & hdd
+ * bit 1 : 1 = only disks on primary port
+ *         0 = disks & ATAPI devices on primary port
+ * bit 2-4 : always 0
+ * bit 5 : status, but of what ?
+ * bit 6 : always set 1 by dos driver
+ * bit 7 : set 1 for non-ATAPI devices on primary port
+ *	(maybe read-ahead and post-write buffer ?)
+ */
+
+static int timings[4]={-1,-1,-1,-1}; /* stores current timing for each timer */
+
+/*
+ * qd65xx_select:
+ *
+ * This routine is invoked to prepare for access to a given drive.
+ */
+
+static void qd65xx_dev_select(ide_drive_t *drive)
+{
+	u8 index = ((	(QD_TIMREG(drive)) & 0x80 ) >> 7) |
+			(QD_TIMREG(drive) & 0x02);
+
+	if (timings[index] != QD_TIMING(drive))
+		outb(timings[index] = QD_TIMING(drive), QD_TIMREG(drive));
+
+	outb(drive->select | ATA_DEVICE_OBS, drive->hwif->io_ports.device_addr);
+}
+
+/*
+ * qd6500_compute_timing
+ *
+ * computes the timing value where
+ *	lower nibble represents active time,   in count of VLB clocks
+ *	upper nibble represents recovery time, in count of VLB clocks
+ */
+
+static u8 qd6500_compute_timing (ide_hwif_t *hwif, int active_time, int recovery_time)
+{
+	int clk = ide_vlb_clk ? ide_vlb_clk : 50;
+	u8 act_cyc, rec_cyc;
+
+	if (clk <= 33) {
+		act_cyc =  9 - IDE_IN(active_time   * clk / 1000 + 1, 2,  9);
+		rec_cyc = 15 - IDE_IN(recovery_time * clk / 1000 + 1, 0, 15);
+	} else {
+		act_cyc =  8 - IDE_IN(active_time   * clk / 1000 + 1, 1,  8);
+		rec_cyc = 18 - IDE_IN(recovery_time * clk / 1000 + 1, 3, 18);
+	}
+
+	return (rec_cyc << 4) | 0x08 | act_cyc;
+}
+
+/*
+ * qd6580_compute_timing
+ *
+ * idem for qd6580
+ */
+
+static u8 qd6580_compute_timing (int active_time, int recovery_time)
+{
+	int clk = ide_vlb_clk ? ide_vlb_clk : 50;
+	u8 act_cyc, rec_cyc;
+
+	act_cyc = 17 - IDE_IN(active_time   * clk / 1000 + 1, 2, 17);
+	rec_cyc = 15 - IDE_IN(recovery_time * clk / 1000 + 1, 2, 15);
+
+	return (rec_cyc << 4) | act_cyc;
+}
+
+/*
+ * qd_find_disk_type
+ *
+ * tries to find timing from dos driver's table
+ */
+
+static int qd_find_disk_type (ide_drive_t *drive,
+		int *active_time, int *recovery_time)
+{
+	struct qd65xx_timing_s *p;
+	char *m = (char *)&drive->id[ATA_ID_PROD];
+	char model[ATA_ID_PROD_LEN];
+
+	if (*m == 0)
+		return 0;
+
+	strncpy(model, m, ATA_ID_PROD_LEN);
+	ide_fixstring(model, ATA_ID_PROD_LEN, 1); /* byte-swap */
+
+	for (p = qd65xx_timing ; p->offset != -1 ; p++) {
+		if (!strncmp(p->model, model+p->offset, 4)) {
+			printk(KERN_DEBUG "%s: listed !\n", drive->name);
+			*active_time = p->active;
+			*recovery_time = p->recovery;
+			return 1;
+		}
+	}
+	return 0;
+}
+
+/*
+ * qd_set_timing:
+ *
+ * records the timing
+ */
+
+static void qd_set_timing (ide_drive_t *drive, u8 timing)
+{
+	unsigned long data = (unsigned long)ide_get_drivedata(drive);
+
+	data &= 0xff00;
+	data |= timing;
+	ide_set_drivedata(drive, (void *)data);
+
+	printk(KERN_DEBUG "%s: %#x\n", drive->name, timing);
+}
+
+static void qd6500_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
+{
+	u16 *id = drive->id;
+	int active_time   = 175;
+	int recovery_time = 415; /* worst case values from the dos driver */
+
+	/* FIXME: use drive->pio_mode value */
+	if (!qd_find_disk_type(drive, &active_time, &recovery_time) &&
+	    (id[ATA_ID_OLD_PIO_MODES] & 0xff) && (id[ATA_ID_FIELD_VALID] & 2) &&
+	    id[ATA_ID_EIDE_PIO] >= 240) {
+		printk(KERN_INFO "%s: PIO mode%d\n", drive->name,
+			id[ATA_ID_OLD_PIO_MODES] & 0xff);
+		active_time = 110;
+		recovery_time = drive->id[ATA_ID_EIDE_PIO] - 120;
+	}
+
+	qd_set_timing(drive, qd6500_compute_timing(drive->hwif,
+				active_time, recovery_time));
+}
+
+static void qd6580_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
+{
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
+	const struct ata_timing *t = ata_timing_find_mode(XFER_PIO_0 + pio);
+	unsigned int cycle_time;
+	int active_time   = 175;
+	int recovery_time = 415; /* worst case values from the dos driver */
+	u8 base = (hwif->config_data & 0xff00) >> 8;
+
+	if (drive->id && !qd_find_disk_type(drive, &active_time, &recovery_time)) {
+		cycle_time = ide_pio_cycle_time(drive, pio);
+
+		switch (pio) {
+			case 0: break;
+			case 3:
+				if (cycle_time >= 110) {
+					active_time = 86;
+					recovery_time = cycle_time - 102;
+				} else
+					printk(KERN_WARNING "%s: Strange recovery time !\n",drive->name);
+				break;
+			case 4:
+				if (cycle_time >= 69) {
+					active_time = 70;
+					recovery_time = cycle_time - 61;
+				} else
+					printk(KERN_WARNING "%s: Strange recovery time !\n",drive->name);
+				break;
+			default:
+				if (cycle_time >= 180) {
+					active_time = 110;
+					recovery_time = cycle_time - 120;
+				} else {
+					active_time = t->active;
+					recovery_time = cycle_time - active_time;
+				}
+		}
+		printk(KERN_INFO "%s: PIO mode%d\n", drive->name,pio);
+	}
+
+	if (!hwif->channel && drive->media != ide_disk) {
+		outb(0x5f, QD_CONTROL_PORT);
+		printk(KERN_WARNING "%s: ATAPI: disabled read-ahead FIFO "
+			"and post-write buffer on %s.\n",
+			drive->name, hwif->name);
+	}
+
+	qd_set_timing(drive, qd6580_compute_timing(active_time, recovery_time));
+}
+
+/*
+ * qd_testreg
+ *
+ * tests if the given port is a register
+ */
+
+static int __init qd_testreg(int port)
+{
+	unsigned long flags;
+	u8 savereg, readreg;
+
+	local_irq_save(flags);
+	savereg = inb_p(port);
+	outb_p(QD_TESTVAL, port);	/* safe value */
+	readreg = inb_p(port);
+	outb(savereg, port);
+	local_irq_restore(flags);
+
+	if (savereg == QD_TESTVAL) {
+		printk(KERN_ERR "Outch ! the probe for qd65xx isn't reliable !\n");
+		printk(KERN_ERR "Please contact maintainers to tell about your hardware\n");
+		printk(KERN_ERR "Assuming qd65xx is not present.\n");
+		return 1;
+	}
+
+	return (readreg != QD_TESTVAL);
+}
+
+static void __init qd6500_init_dev(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 base = (hwif->config_data & 0xff00) >> 8;
+	u8 config = QD_CONFIG(hwif);
+
+	ide_set_drivedata(drive, (void *)QD6500_DEF_DATA);
+}
+
+static void __init qd6580_init_dev(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u16 t1, t2;
+	u8 base = (hwif->config_data & 0xff00) >> 8;
+	u8 config = QD_CONFIG(hwif);
+
+	if (hwif->host_flags & IDE_HFLAG_SINGLE) {
+		t1 = QD6580_DEF_DATA;
+		t2 = QD6580_DEF_DATA2;
+	} else
+		t2 = t1 = hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA;
+
+	ide_set_drivedata(drive, (void *)((drive->dn & 1) ? t2 : t1));
+}
+
+static const struct ide_tp_ops qd65xx_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.write_devctl		= ide_write_devctl,
+
+	.dev_select		= qd65xx_dev_select,
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
+
+static const struct ide_port_ops qd6500_port_ops = {
+	.init_dev		= qd6500_init_dev,
+	.set_pio_mode		= qd6500_set_pio_mode,
+};
+
+static const struct ide_port_ops qd6580_port_ops = {
+	.init_dev		= qd6580_init_dev,
+	.set_pio_mode		= qd6580_set_pio_mode,
+};
+
+static const struct ide_port_info qd65xx_port_info __initdata = {
+	.name			= DRV_NAME,
+	.tp_ops 		= &qd65xx_tp_ops,
+	.chipset		= ide_qd65xx,
+	.host_flags		= IDE_HFLAG_IO_32BIT |
+				  IDE_HFLAG_NO_DMA,
+	.pio_mask		= ATA_PIO4,
+};
+
+/*
+ * qd_probe:
+ *
+ * looks at the specified baseport, and if qd found, registers & initialises it
+ * return 1 if another qd may be probed
+ */
+
+static int __init qd_probe(int base)
+{
+	int rc;
+	u8 config, unit, control;
+	struct ide_port_info d = qd65xx_port_info;
+
+	config = inb(QD_CONFIG_PORT);
+
+	if (! ((config & QD_CONFIG_BASEPORT) >> 1 == (base == 0xb0)) )
+		return -ENODEV;
+
+	unit = ! (config & QD_CONFIG_IDE_BASEPORT);
+
+	if (unit)
+		d.host_flags |= IDE_HFLAG_QD_2ND_PORT;
+
+	switch (config & 0xf0) {
+	case QD_CONFIG_QD6500:
+		if (qd_testreg(base))
+			 return -ENODEV;	/* bad register */
+
+		if (config & QD_CONFIG_DISABLED) {
+			printk(KERN_WARNING "qd6500 is disabled !\n");
+			return -ENODEV;
+		}
+
+		printk(KERN_NOTICE "qd6500 at %#x\n", base);
+		printk(KERN_DEBUG "qd6500: config=%#x, ID3=%u\n",
+			config, QD_ID3);
+
+		d.port_ops = &qd6500_port_ops;
+		d.host_flags |= IDE_HFLAG_SINGLE;
+		break;
+	case QD_CONFIG_QD6580_A:
+	case QD_CONFIG_QD6580_B:
+		if (qd_testreg(base) || qd_testreg(base + 0x02))
+			return -ENODEV;	/* bad registers */
+
+		control = inb(QD_CONTROL_PORT);
+
+		printk(KERN_NOTICE "qd6580 at %#x\n", base);
+		printk(KERN_DEBUG "qd6580: config=%#x, control=%#x, ID3=%u\n",
+			config, control, QD_ID3);
+
+		outb(QD_DEF_CONTR, QD_CONTROL_PORT);
+
+		d.port_ops = &qd6580_port_ops;
+		if (control & QD_CONTR_SEC_DISABLED)
+			d.host_flags |= IDE_HFLAG_SINGLE;
+
+		printk(KERN_INFO "qd6580: %s IDE board\n",
+			(control & QD_CONTR_SEC_DISABLED) ? "single" : "dual");
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	rc = ide_legacy_device_add(&d, (base << 8) | config);
+
+	if (d.host_flags & IDE_HFLAG_SINGLE)
+		return (rc == 0) ? 1 : rc;
+
+	return rc;
+}
+
+static int probe_qd65xx;
+
+module_param_named(probe, probe_qd65xx, bool, 0);
+MODULE_PARM_DESC(probe, "probe for QD65xx chipsets");
+
+static int __init qd65xx_init(void)
+{
+	int rc1, rc2 = -ENODEV;
+
+	if (probe_qd65xx == 0)
+		return -ENODEV;
+
+	rc1 = qd_probe(0x30);
+	if (rc1)
+		rc2 = qd_probe(0xb0);
+
+	if (rc1 < 0 && rc2 < 0)
+		return -ENODEV;
+
+	return 0;
+}
+
+module_init(qd65xx_init);
+
+MODULE_AUTHOR("Samuel Thibault");
+MODULE_DESCRIPTION("support of qd65xx vlb ide chipset");
+MODULE_LICENSE("GPL");
Index: b/drivers/staging/ide-vlb/qd65xx.h
===================================================================
--- /dev/null
+++ b/drivers/staging/ide-vlb/qd65xx.h
@@ -0,0 +1,144 @@
+/*
+ * Copyright (c) 2000	Linus Torvalds & authors
+ */
+
+/*
+ * Authors:	Petr Soucek <petr@ryston.cz>
+ * 		Samuel Thibault <samuel.thibault@ens-lyon.org>
+ */
+
+/* truncates a in [b,c] */
+#define IDE_IN(a,b,c)   ( ((a)<(b)) ? (b) : ( (a)>(c) ? (c) : (a)) )
+
+#define IDE_IMPLY(a,b)	((!(a)) || (b))
+
+#define QD_TIM1_PORT		(base)
+#define QD_CONFIG_PORT		(base+0x01)
+#define QD_TIM2_PORT		(base+0x02)
+#define QD_CONTROL_PORT		(base+0x03)
+
+#define QD_CONFIG_IDE_BASEPORT	0x01
+#define QD_CONFIG_BASEPORT	0x02
+#define QD_CONFIG_ID3		0x04
+#define QD_CONFIG_DISABLED	0x08
+#define QD_CONFIG_QD6500	0xc0
+#define QD_CONFIG_QD6580_A	0xa0
+#define QD_CONFIG_QD6580_B	0x50
+
+#define QD_CONTR_SEC_DISABLED	0x01
+
+#define QD_ID3			((config & QD_CONFIG_ID3)!=0)
+
+#define QD_CONFIG(hwif)		((hwif)->config_data & 0x00ff)
+
+static inline u8 QD_TIMING(ide_drive_t *drive)
+{
+	return (unsigned long)ide_get_drivedata(drive) & 0x00ff;
+}
+
+static inline u8 QD_TIMREG(ide_drive_t *drive)
+{
+	return ((unsigned long)ide_get_drivedata(drive) & 0xff00) >> 8;
+}
+
+#define QD6500_DEF_DATA		((QD_TIM1_PORT<<8) | (QD_ID3 ? 0x0c : 0x08))
+#define QD6580_DEF_DATA		((QD_TIM1_PORT<<8) | (QD_ID3 ? 0x0a : 0x00))
+#define QD6580_DEF_DATA2	((QD_TIM2_PORT<<8) | (QD_ID3 ? 0x0a : 0x00))
+#define QD_DEF_CONTR		(0x40 | ((control & 0x02) ? 0x9f : 0x1f))
+
+#define QD_TESTVAL		0x19	/* safe value */
+
+/* Drive specific timing taken from DOS driver v3.7 */
+
+static struct qd65xx_timing_s {
+	s8	offset;   /* ofset from the beginning of Model Number" */
+	char	model[4];    /* 4 chars from Model number, no conversion */
+	s16	active;   /* active time */
+	s16	recovery; /* recovery time */
+} qd65xx_timing [] = {
+	{ 30, "2040", 110, 225 },  /* Conner CP30204			*/
+	{ 30, "2045", 135, 225 },  /* Conner CP30254			*/
+	{ 30, "1040", 155, 325 },  /* Conner CP30104			*/
+	{ 30, "1047", 135, 265 },  /* Conner CP30174			*/
+	{ 30, "5344", 135, 225 },  /* Conner CP3544			*/
+	{ 30, "01 4", 175, 405 },  /* Conner CP-3104			*/
+	{ 27, "C030", 175, 375 },  /* Conner CP3000			*/
+	{  8, "PL42", 110, 295 },  /* Quantum LP240			*/
+	{  8, "PL21", 110, 315 },  /* Quantum LP120			*/
+	{  8, "PL25", 175, 385 },  /* Quantum LP52			*/
+	{  4, "PA24", 110, 285 },  /* WD Piranha SP4200			*/
+	{  6, "2200", 110, 260 },  /* WD Caviar AC2200			*/
+	{  6, "3204", 110, 235 },  /* WD Caviar AC2340			*/
+	{  6, "1202", 110, 265 },  /* WD Caviar AC2120			*/
+	{  0, "DS3-", 135, 315 },  /* Teac SD340			*/
+	{  8, "KM32", 175, 355 },  /* Toshiba MK234			*/
+	{  2, "53A1", 175, 355 },  /* Seagate ST351A			*/
+	{  2, "4108", 175, 295 },  /* Seagate ST1480A			*/
+	{  2, "1344", 175, 335 },  /* Seagate ST3144A			*/
+	{  6, "7 12", 110, 225 },  /* Maxtor 7213A			*/
+	{ 30, "02F4", 145, 295 },  /* Conner 3204F			*/
+	{  2, "1302", 175, 335 },  /* Seagate ST3120A			*/
+	{  2, "2334", 145, 265 },  /* Seagate ST3243A			*/
+	{  2, "2338", 145, 275 },  /* Seagate ST3283A			*/
+	{  2, "3309", 145, 275 },  /* Seagate ST3390A			*/
+	{  2, "5305", 145, 275 },  /* Seagate ST3550A			*/
+	{  2, "4100", 175, 295 },  /* Seagate ST1400A			*/
+	{  2, "4110", 175, 295 },  /* Seagate ST1401A			*/
+	{  2, "6300", 135, 265 },  /* Seagate ST3600A			*/
+	{  2, "5300", 135, 265 },  /* Seagate ST3500A			*/
+	{  6, "7 31", 135, 225 },  /* Maxtor 7131 AT			*/
+	{  6, "7 43", 115, 265 },  /* Maxtor 7345 AT			*/
+	{  6, "7 42", 110, 255 },  /* Maxtor 7245 AT			*/
+	{  6, "3 04", 135, 265 },  /* Maxtor 340 AT			*/
+	{  6, "61 0", 135, 285 },  /* WD AC160				*/
+	{  6, "1107", 135, 235 },  /* WD AC1170				*/
+	{  6, "2101", 110, 220 },  /* WD AC1210				*/
+	{  6, "4202", 135, 245 },  /* WD AC2420				*/
+	{  6, "41 0", 175, 355 },  /* WD Caviar 140			*/
+	{  6, "82 0", 175, 355 },  /* WD Caviar 280			*/
+	{  8, "PL01", 175, 375 },  /* Quantum LP105			*/
+	{  8, "PL25", 110, 295 },  /* Quantum LP525			*/
+	{ 10, "4S 2", 175, 385 },  /* Quantum ELS42			*/
+	{ 10, "8S 5", 175, 385 },  /* Quantum ELS85			*/
+	{ 10, "1S72", 175, 385 },  /* Quantum ELS127			*/
+	{ 10, "1S07", 175, 385 },  /* Quantum ELS170			*/
+	{  8, "ZE42", 135, 295 },  /* Quantum EZ240			*/
+	{  8, "ZE21", 175, 385 },  /* Quantum EZ127			*/
+	{  8, "ZE58", 175, 385 },  /* Quantum EZ85			*/
+	{  8, "ZE24", 175, 385 },  /* Quantum EZ42			*/
+	{ 27, "C036", 155, 325 },  /* Conner CP30064			*/
+	{ 27, "C038", 155, 325 },  /* Conner CP30084			*/
+	{  6, "2205", 110, 255 },  /* WDC AC2250			*/
+	{  2, " CHA", 140, 415 },  /* WDC AH series; WDC AH260, WDC	*/
+	{  2, " CLA", 140, 415 },  /* WDC AL series: WDC AL2120, 2170,	*/
+	{  4, "UC41", 140, 415 },  /* WDC CU140				*/
+	{  6, "1207", 130, 275 },  /* WDC AC2170			*/
+	{  6, "2107", 130, 275 },  /* WDC AC1270			*/
+	{  6, "5204", 130, 275 },  /* WDC AC2540			*/
+	{ 30, "3004", 110, 235 },  /* Conner CP30340			*/
+	{ 30, "0345", 135, 255 },  /* Conner CP30544			*/
+	{ 12, "12A3", 175, 320 },  /* MAXTOR LXT-213A			*/
+	{ 12, "43A0", 145, 240 },  /* MAXTOR LXT-340A			*/
+	{  6, "7 21", 180, 290 },  /* Maxtor 7120 AT			*/
+	{  6, "7 71", 135, 240 },  /* Maxtor 7170 AT			*/
+	{ 12, "45\0000", 110, 205 },   /* MAXTOR MXT-540		*/
+	{  8, "PL11", 180, 290 },  /* QUANTUM LP110A			*/
+	{  8, "OG21", 150, 275 },  /* QUANTUM GO120			*/
+	{ 12, "42A5", 175, 320 },  /* MAXTOR LXT-245A			*/
+	{  2, "2309", 175, 295 },  /* ST3290A				*/
+	{  2, "3358", 180, 310 },  /* ST3385A				*/
+	{  2, "6355", 180, 310 },  /* ST3655A				*/
+	{  2, "1900", 175, 270 },  /* ST9100A				*/
+	{  2, "1954", 175, 270 },  /* ST9145A				*/
+	{  2, "1909", 175, 270 },  /* ST9190AG				*/
+	{  2, "2953", 175, 270 },  /* ST9235A				*/
+	{  2, "1359", 175, 270 },  /* ST3195A				*/
+	{ 24, "3R11", 175, 290 },  /* ALPS ELECTRIC Co.,LTD, DR311C	*/
+	{  0, "2M26", 175, 215 },  /* M262XT-0Ah			*/
+	{  4, "2253", 175, 300 },  /* HP C2235A				*/
+	{  4, "-32A", 145, 245 },  /* H3133-A2				*/
+	{ 30, "0326", 150, 270 },  /* Samsung Electronics 120MB		*/
+	{ 30, "3044", 110, 195 },  /* Conner CFA340A			*/
+	{ 30, "43A0", 110, 195 },  /* Conner CFA340A			*/
+	{ -1, "    ", 175, 415 }   /* unknown disk name			*/
+};
Index: b/drivers/staging/ide-vlb/umc8672.c
===================================================================
--- /dev/null
+++ b/drivers/staging/ide-vlb/umc8672.c
@@ -0,0 +1,183 @@
+/*
+ *  Copyright (C) 1995-1996  Linus Torvalds & author (see below)
+ */
+
+/*
+ *  Principal Author/Maintainer:  PODIEN@hml2.atlas.de (Wolfram Podien)
+ *
+ *  This file provides support for the advanced features
+ *  of the UMC 8672 IDE interface.
+ *
+ *  Version 0.01	Initial version, hacked out of ide.c,
+ *			and #include'd rather than compiled separately.
+ *			This will get cleaned up in a subsequent release.
+ *
+ *  Version 0.02	now configs/compiles separate from ide.c  -ml
+ *  Version 0.03	enhanced auto-tune, fix display bug
+ *  Version 0.05	replace sti() with restore_flags()  -ml
+ *			add detection of possible race condition  -ml
+ */
+
+/*
+ * VLB Controller Support from
+ * Wolfram Podien
+ * Rohoefe 3
+ * D28832 Achim
+ * Germany
+ *
+ * To enable UMC8672 support there must a lilo line like
+ * append="ide0=umc8672"...
+ * To set the speed according to the abilities of the hardware there must be a
+ * line like
+ * #define UMC_DRIVE0 11
+ * in the beginning of the driver, which sets the speed of drive 0 to 11 (there
+ * are some lines present). 0 - 11 are allowed speed values. These values are
+ * the results from the DOS speed test program supplied from UMC. 11 is the
+ * highest speed (about PIO mode 3)
+ */
+#define REALLY_SLOW_IO		/* some systems can safely undef this */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/mm.h>
+#include <linux/ioport.h>
+#include <linux/blkdev.h>
+#include <linux/ide.h>
+#include <linux/init.h>
+
+#include <asm/io.h>
+
+#define DRV_NAME "umc8672"
+
+/*
+ * Default speeds.  These can be changed with "auto-tune" and/or hdparm.
+ */
+#define UMC_DRIVE0      1              /* DOS measured drive speeds */
+#define UMC_DRIVE1      1              /* 0 to 11 allowed */
+#define UMC_DRIVE2      1              /* 11 = Fastest Speed */
+#define UMC_DRIVE3      1              /* In case of crash reduce speed */
+
+static u8 current_speeds[4] = {UMC_DRIVE0, UMC_DRIVE1, UMC_DRIVE2, UMC_DRIVE3};
+static const u8 pio_to_umc [5] = {0, 3, 7, 10, 11};	/* rough guesses */
+
+/*       0    1    2    3    4    5    6    7    8    9    10   11      */
+static const u8 speedtab [3][12] = {
+	{0x0f, 0x0b, 0x02, 0x02, 0x02, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x1},
+	{0x03, 0x02, 0x02, 0x02, 0x02, 0x02, 0x01, 0x01, 0x01, 0x01, 0x01, 0x1},
+	{0xff, 0xcb, 0xc0, 0x58, 0x36, 0x33, 0x23, 0x22, 0x21, 0x11, 0x10, 0x0}
+};
+
+static void out_umc(char port, char wert)
+{
+	outb_p(port, 0x108);
+	outb_p(wert, 0x109);
+}
+
+static inline u8 in_umc(char port)
+{
+	outb_p(port, 0x108);
+	return inb_p(0x109);
+}
+
+static void umc_set_speeds(u8 speeds[])
+{
+	int i, tmp;
+
+	outb_p(0x5A, 0x108); /* enable umc */
+
+	out_umc(0xd7, (speedtab[0][speeds[2]] | (speedtab[0][speeds[3]]<<4)));
+	out_umc(0xd6, (speedtab[0][speeds[0]] | (speedtab[0][speeds[1]]<<4)));
+	tmp = 0;
+	for (i = 3; i >= 0; i--)
+		tmp = (tmp << 2) | speedtab[1][speeds[i]];
+	out_umc(0xdc, tmp);
+	for (i = 0; i < 4; i++) {
+		out_umc(0xd0 + i, speedtab[2][speeds[i]]);
+		out_umc(0xd8 + i, speedtab[2][speeds[i]]);
+	}
+	outb_p(0xa5, 0x108); /* disable umc */
+
+	printk("umc8672: drive speeds [0 to 11]: %d %d %d %d\n",
+		speeds[0], speeds[1], speeds[2], speeds[3]);
+}
+
+static void umc_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
+{
+	ide_hwif_t *mate = hwif->mate;
+	unsigned long uninitialized_var(flags);
+	const u8 pio = drive->pio_mode - XFER_PIO_0;
+
+	printk("%s: setting umc8672 to PIO mode%d (speed %d)\n",
+		drive->name, pio, pio_to_umc[pio]);
+	if (mate)
+		spin_lock_irqsave(&mate->lock, flags);
+	if (mate && mate->handler) {
+		printk(KERN_ERR "umc8672: other interface is busy: exiting tune_umc()\n");
+	} else {
+		current_speeds[drive->name[2] - 'a'] = pio_to_umc[pio];
+		umc_set_speeds(current_speeds);
+	}
+	if (mate)
+		spin_unlock_irqrestore(&mate->lock, flags);
+}
+
+static const struct ide_port_ops umc8672_port_ops = {
+	.set_pio_mode		= umc_set_pio_mode,
+};
+
+static const struct ide_port_info umc8672_port_info __initdata = {
+	.name			= DRV_NAME,
+	.chipset		= ide_umc8672,
+	.port_ops		= &umc8672_port_ops,
+	.host_flags		= IDE_HFLAG_NO_DMA,
+	.pio_mask		= ATA_PIO4,
+};
+
+static int __init umc8672_probe(void)
+{
+	unsigned long flags;
+
+	if (!request_region(0x108, 2, "umc8672")) {
+		printk(KERN_ERR "umc8672: ports 0x108-0x109 already in use.\n");
+		return 1;
+	}
+	local_irq_save(flags);
+	outb_p(0x5A, 0x108); /* enable umc */
+	if (in_umc (0xd5) != 0xa0) {
+		local_irq_restore(flags);
+		printk(KERN_ERR "umc8672: not found\n");
+		release_region(0x108, 2);
+		return 1;
+	}
+	outb_p(0xa5, 0x108); /* disable umc */
+
+	umc_set_speeds(current_speeds);
+	local_irq_restore(flags);
+
+	return ide_legacy_device_add(&umc8672_port_info, 0);
+}
+
+static int probe_umc8672;
+
+module_param_named(probe, probe_umc8672, bool, 0);
+MODULE_PARM_DESC(probe, "probe for UMC8672 chipset");
+
+static int __init umc8672_init(void)
+{
+	if (probe_umc8672 == 0)
+		goto out;
+
+	if (umc8672_probe() == 0)
+		return 0;
+out:
+	return -ENODEV;
+}
+
+module_init(umc8672_init);
+
+MODULE_AUTHOR("Wolfram Podien");
+MODULE_DESCRIPTION("Support for UMC 8672 IDE chipset");
+MODULE_LICENSE("GPL");
