Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbYJEQqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbYJEQqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbYJEQlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:41:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:40222 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139AbYJEQlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:41:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=XR11C5Z2x/LjoUkRsiVv64JIVsPftAZFdOuw4PU73y1tef8aKH6OOUurOQUzkdw1Vf
         5CiWJLCfVlz3FOnhtVZWAKbQKq+NWNhM4Lssk1DaUNmqMN/atu7jaHP/roZjq06aOg/g
         jkvQfQyZY29fnqi//W0VeCQsZJb71j+qokapI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Sun, 5 Oct 2008 18:38:44 +0200
Message-Id: <200810051838.44451.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The final polishing touch for 2.6.27...

[ Swarm commit outstands in diffstat but is a straightforward change. ]


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 arch/mips/sibyte/swarm/Makefile   |    3 +-
 arch/mips/sibyte/swarm/platform.c |   81 +++++++++++++++
 drivers/ide/Kconfig               |    4 -
 drivers/ide/ide-cd.c              |    6 +-
 drivers/ide/ide-dma.c             |    2 +-
 drivers/ide/ide-probe.c           |    2 +-
 drivers/ide/mips/Makefile         |    1 -
 drivers/ide/mips/swarm.c          |  197 -------------------------------------
 include/linux/ide.h               |    4 +-
 9 files changed, 93 insertions(+), 207 deletions(-)
 create mode 100644 arch/mips/sibyte/swarm/platform.c
 delete mode 100644 drivers/ide/mips/swarm.c


Bartlomiej Zolnierkiewicz (1):
      ide: workaround for bogus gcc warning in ide_sysfs_register_port()

Bodo Eggert (1):
      ide-cd: Optiarc DVD RW AD-7200A does play audio

Borislav Petkov (1):
      ide-cd: temporary tray close fix

Ralf Baechle (1):
      IDE: Fix platform device registration in Swarm IDE driver (v2)

Sergei Shtylylov (1):
      ide-dma: fix ide_build_dmatable() for TRM290


diff --git a/arch/mips/sibyte/swarm/Makefile b/arch/mips/sibyte/swarm/Makefile
index f18ba92..7b45f19 100644
--- a/arch/mips/sibyte/swarm/Makefile
+++ b/arch/mips/sibyte/swarm/Makefile
@@ -1,3 +1,4 @@
-obj-y				:= setup.o rtc_xicor1241.o rtc_m41t81.o
+obj-y				:= platform.o setup.o rtc_xicor1241.o \
+				   rtc_m41t81.o
 
 obj-$(CONFIG_I2C_BOARDINFO)	+= swarm-i2c.o
diff --git a/arch/mips/sibyte/swarm/platform.c b/arch/mips/sibyte/swarm/platform.c
new file mode 100644
index 0000000..dd0e5b9
--- /dev/null
+++ b/arch/mips/sibyte/swarm/platform.c
@@ -0,0 +1,81 @@
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/ata_platform.h>
+
+#include <asm/sibyte/board.h>
+#include <asm/sibyte/sb1250_genbus.h>
+#include <asm/sibyte/sb1250_regs.h>
+
+#define DRV_NAME	"pata-swarm"
+
+#define SWARM_IDE_SHIFT	5
+#define SWARM_IDE_BASE	0x1f0
+#define SWARM_IDE_CTRL	0x3f6
+
+static struct resource swarm_pata_resource[] = {
+	{
+		.name	= "Swarm GenBus IDE",
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name	= "Swarm GenBus IDE",
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name	= "Swarm GenBus IDE",
+		.flags	= IORESOURCE_IRQ,
+		.start	= K_INT_GB_IDE,
+		.end	= K_INT_GB_IDE,
+	},
+};
+
+static struct pata_platform_info pata_platform_data = {
+	.ioport_shift	= SWARM_IDE_SHIFT,
+};
+
+static struct platform_device swarm_pata_device = {
+	.name		= "pata_platform",
+	.id		= -1,
+	.resource	= swarm_pata_resource,
+	.num_resources	= ARRAY_SIZE(swarm_pata_resource),
+	.dev  = {
+		.platform_data		= &pata_platform_data,
+		.coherent_dma_mask	= ~0,	/* grumble */
+	},
+};
+
+static int __init swarm_pata_init(void)
+{
+	u8 __iomem *base;
+	phys_t offset, size;
+	struct resource *r;
+
+	if (!SIBYTE_HAVE_IDE)
+		return -ENODEV;
+
+	base = ioremap(A_IO_EXT_BASE, 0x800);
+	offset = __raw_readq(base + R_IO_EXT_REG(R_IO_EXT_START_ADDR, IDE_CS));
+	size = __raw_readq(base + R_IO_EXT_REG(R_IO_EXT_MULT_SIZE, IDE_CS));
+	iounmap(base);
+
+	offset = G_IO_START_ADDR(offset) << S_IO_ADDRBASE;
+	size = (G_IO_MULT_SIZE(size) + 1) << S_IO_REGSIZE;
+	if (offset < A_PHYS_GENBUS || offset >= A_PHYS_GENBUS_END) {
+		pr_info(DRV_NAME ": PATA interface at GenBus disabled\n");
+
+		return -EBUSY;
+	}
+
+	pr_info(DRV_NAME ": PATA interface at GenBus slot %i\n", IDE_CS);
+
+	r = swarm_pata_resource;
+	r[0].start = offset + (SWARM_IDE_BASE << SWARM_IDE_SHIFT);
+	r[0].end   = offset + ((SWARM_IDE_BASE + 8) << SWARM_IDE_SHIFT) - 1;
+	r[1].start = offset + (SWARM_IDE_CTRL << SWARM_IDE_SHIFT);
+	r[1].end   = offset + ((SWARM_IDE_CTRL + 1) << SWARM_IDE_SHIFT) - 1;
+
+	return platform_device_register(&swarm_pata_device);
+}
+
+device_initcall(swarm_pata_init);
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 8e93a79..052879a 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -780,10 +780,6 @@ config BLK_DEV_IDEDMA_PMAC
 	  to transfer data to and from memory.  Saying Y is safe and improves
 	  performance.
 
-config BLK_DEV_IDE_SWARM
-	tristate "IDE for Sibyte evaluation boards"
-	depends on SIBYTE_SB1xxx_SOC
-
 config BLK_DEV_IDE_AU1XXX
        bool "IDE for AMD Alchemy Au1200"
        depends on SOC_AU1200
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 49a8c58..f16bb46 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1661,7 +1661,9 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 
 	mechtype = buf[8 + 6] >> 5;
-	if (mechtype == mechtype_caddy || mechtype == mechtype_popup)
+	if (mechtype == mechtype_caddy ||
+	    mechtype == mechtype_popup ||
+	    (drive->atapi_flags & IDE_AFLAG_NO_AUTOCLOSE))
 		cdi->mask |= CDC_CLOSE_TRAY;
 
 	if (cdi->sanyo_slot > 0) {
@@ -1859,6 +1861,8 @@ static const struct cd_list_entry ide_cd_quirks_list[] = {
 	{ "MATSHITADVD-ROM SR-8176", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
 	{ "MATSHITADVD-ROM SR-8174", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
 	{ "Optiarc DVD RW AD-5200A", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
+	{ "Optiarc DVD RW AD-7200A", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
+	{ "Optiarc DVD RW AD-7543A", NULL,   IDE_AFLAG_NO_AUTOCLOSE	     },
 	{ NULL, NULL, 0 }
 };
 
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index adc6827..3fa07c0 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -211,7 +211,7 @@ int ide_build_dmatable (ide_drive_t *drive, struct request *rq)
 				xcount = bcount & 0xffff;
 				if (is_trm290)
 					xcount = ((xcount >> 2) - 1) << 16;
-				if (xcount == 0x0000) {
+				else if (xcount == 0x0000) {
 	/* 
 	 * Most chipsets correctly interpret a length of 0x0000 as 64KB,
 	 * but at least one (e.g. CS5530) misinterprets it as zero (!).
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 994e410..a51a30e 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1492,7 +1492,7 @@ static struct device_attribute *ide_port_attrs[] = {
 
 static int ide_sysfs_register_port(ide_hwif_t *hwif)
 {
-	int i, rc;
+	int i, uninitialized_var(rc);
 
 	for (i = 0; ide_port_attrs[i]; i++) {
 		rc = device_create_file(hwif->portdev, ide_port_attrs[i]);
diff --git a/drivers/ide/mips/Makefile b/drivers/ide/mips/Makefile
index 677c7b2..5873fa0 100644
--- a/drivers/ide/mips/Makefile
+++ b/drivers/ide/mips/Makefile
@@ -1,4 +1,3 @@
-obj-$(CONFIG_BLK_DEV_IDE_SWARM)		+= swarm.o
 obj-$(CONFIG_BLK_DEV_IDE_AU1XXX)	+= au1xxx-ide.o
 
 EXTRA_CFLAGS    := -Idrivers/ide
diff --git a/drivers/ide/mips/swarm.c b/drivers/ide/mips/swarm.c
deleted file mode 100644
index 39c9ee9..0000000
--- a/drivers/ide/mips/swarm.c
+++ /dev/null
@@ -1,197 +0,0 @@
-/*
- * Copyright (C) 2001, 2002, 2003 Broadcom Corporation
- * Copyright (C) 2004 MontaVista Software Inc.
- *	Author:	Manish Lachwani, mlachwani@mvista.com
- * Copyright (C) 2004  MIPS Technologies, Inc.  All rights reserved.
- *	Author: Maciej W. Rozycki <macro@mips.com>
- * Copyright (c) 2006, 2008  Maciej W. Rozycki
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- */
-
-/*
- *  Derived loosely from ide-pmac.c, so:
- *  Copyright (C) 1998 Paul Mackerras.
- *  Copyright (C) 1995-1998 Mark Lord
- */
-
-/*
- * Boards with SiByte processors so far have supported IDE devices via
- * the Generic Bus, PCI bus, and built-in PCMCIA interface.  In all
- * cases, byte-swapping must be avoided for these devices (whereas
- * other PCI devices, for example, will require swapping).  Any
- * SiByte-targetted kernel including IDE support will include this
- * file.  Probing of a Generic Bus for an IDE device is controlled by
- * the definition of "SIBYTE_HAVE_IDE", which is provided by
- * <asm/sibyte/board.h> for Broadcom boards.
- */
-
-#include <linux/ide.h>
-#include <linux/ioport.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/platform_device.h>
-
-#include <asm/io.h>
-
-#include <asm/sibyte/board.h>
-#include <asm/sibyte/sb1250_genbus.h>
-#include <asm/sibyte/sb1250_regs.h>
-
-#define DRV_NAME "ide-swarm"
-
-static char swarm_ide_string[] = DRV_NAME;
-
-static struct resource swarm_ide_resource = {
-	.name	= "SWARM GenBus IDE",
-	.flags	= IORESOURCE_MEM,
-};
-
-static struct platform_device *swarm_ide_dev;
-
-static const struct ide_port_info swarm_port_info = {
-	.name			= DRV_NAME,
-	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
-};
-
-/*
- * swarm_ide_probe - if the board header indicates the existence of
- * Generic Bus IDE, allocate a HWIF for it.
- */
-static int __devinit swarm_ide_probe(struct device *dev)
-{
-	u8 __iomem *base;
-	struct ide_host *host;
-	phys_t offset, size;
-	int i, rc;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-
-	if (!SIBYTE_HAVE_IDE)
-		return -ENODEV;
-
-	base = ioremap(A_IO_EXT_BASE, 0x800);
-	offset = __raw_readq(base + R_IO_EXT_REG(R_IO_EXT_START_ADDR, IDE_CS));
-	size = __raw_readq(base + R_IO_EXT_REG(R_IO_EXT_MULT_SIZE, IDE_CS));
-	iounmap(base);
-
-	offset = G_IO_START_ADDR(offset) << S_IO_ADDRBASE;
-	size = (G_IO_MULT_SIZE(size) + 1) << S_IO_REGSIZE;
-	if (offset < A_PHYS_GENBUS || offset >= A_PHYS_GENBUS_END) {
-		printk(KERN_INFO DRV_NAME
-		       ": IDE interface at GenBus disabled\n");
-		return -EBUSY;
-	}
-
-	printk(KERN_INFO DRV_NAME ": IDE interface at GenBus slot %i\n",
-	       IDE_CS);
-
-	swarm_ide_resource.start = offset;
-	swarm_ide_resource.end = offset + size - 1;
-	if (request_resource(&iomem_resource, &swarm_ide_resource)) {
-		printk(KERN_ERR DRV_NAME
-		       ": can't request I/O memory resource\n");
-		return -EBUSY;
-	}
-
-	base = ioremap(offset, size);
-
-	memset(&hw, 0, sizeof(hw));
-	for (i = 0; i <= 7; i++)
-		hw.io_ports_array[i] =
-				(unsigned long)(base + ((0x1f0 + i) << 5));
-	hw.io_ports.ctl_addr =
-				(unsigned long)(base + (0x3f6 << 5));
-	hw.irq = K_INT_GB_IDE;
-	hw.chipset = ide_generic;
-
-	rc = ide_host_add(&swarm_port_info, hws, &host);
-	if (rc)
-		goto err;
-
-	dev_set_drvdata(dev, host);
-
-	return 0;
-err:
-	release_resource(&swarm_ide_resource);
-	iounmap(base);
-	return rc;
-}
-
-static struct device_driver swarm_ide_driver = {
-	.name	= swarm_ide_string,
-	.bus	= &platform_bus_type,
-	.probe	= swarm_ide_probe,
-};
-
-static void swarm_ide_platform_release(struct device *device)
-{
-	struct platform_device *pldev;
-
-	/* free device */
-	pldev = to_platform_device(device);
-	kfree(pldev);
-}
-
-static int __devinit swarm_ide_init_module(void)
-{
-	struct platform_device *pldev;
-	int err;
-
-	printk(KERN_INFO "SWARM IDE driver\n");
-
-	if (driver_register(&swarm_ide_driver)) {
-		printk(KERN_ERR "Driver registration failed\n");
-		err = -ENODEV;
-		goto out;
-	}
-
-        if (!(pldev = kzalloc(sizeof (*pldev), GFP_KERNEL))) {
-		err = -ENOMEM;
-		goto out_unregister_driver;
-	}
-
-	pldev->name		= swarm_ide_string;
-	pldev->id		= 0;
-	pldev->dev.release	= swarm_ide_platform_release;
-
-	if (platform_device_register(pldev)) {
-		err = -ENODEV;
-		goto out_free_pldev;
-	}
-
-        if (!pldev->dev.driver) {
-		/*
-		 * The driver was not bound to this device, there was
-                 * no hardware at this address. Unregister it, as the
-		 * release fuction will take care of freeing the
-		 * allocated structure
-		 */
-		platform_device_unregister (pldev);
-	}
-
-	swarm_ide_dev = pldev;
-
-	return 0;
-
-out_free_pldev:
-	kfree(pldev);
-
-out_unregister_driver:
-	driver_unregister(&swarm_ide_driver);
-out:
-	return err;
-}
-
-module_init(swarm_ide_init_module);
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 1524829..6514db8 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -366,7 +366,9 @@ enum {
 	/* Currently on a filemark */
 	IDE_AFLAG_FILEMARK		= (1 << 25),
 	/* 0 = no tape is loaded, so we don't rewind after ejecting */
-	IDE_AFLAG_MEDIUM_PRESENT	= (1 << 26)
+	IDE_AFLAG_MEDIUM_PRESENT	= (1 << 26),
+
+	IDE_AFLAG_NO_AUTOCLOSE		= (1 << 27),
 };
 
 struct ide_drive_s {
