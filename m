Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbZBTRRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbZBTRRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZBTRRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:17:20 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:55640 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZBTRRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:17:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=L4DQwg9irKHNeTtBY4Z0EMURexog8PAAwt3dRiDg8H1DNyWU+gE5jgl2NhvSpq1+vR
         1/8QrKk8GqDinUBZb41o69Tc4wM4bsCfKHC6pP4ILj+67UmICLjA8oxJ6Ldwjj6hDpMf
         22hJF2lNqX1PPlVRIv7pfkV2R+r5B66c04PVg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] ide: merge ide_arm and ide_generic host drivers
Date: Fri, 20 Feb 2009 18:18:17 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090219; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       Alexander Schulz <alex@shark-linux.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902201818.17754.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: merge ide_arm and ide_generic host drivers

There is no need for a separate ide_arm host driver nowadays
so merge it into ide_generic one.

While at it:
- return -EBUSY from ide_generic_init() if I/O resources are busy
- scale down ide_generic_check_pci_legacy_iobases() for CONFIG_PCI=n

Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alexander Schulz <alex@shark-linux.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig       |    8 +-----
 drivers/ide/Makefile      |    2 -
 drivers/ide/ide-generic.c |   18 +++++++++++----
 drivers/ide/ide_arm.c     |   53 ----------------------------------------------
 4 files changed, 15 insertions(+), 66 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -222,7 +222,8 @@ comment "IDE chipset support/bugfixes"
 
 config IDE_GENERIC
 	tristate "generic/default IDE chipset support"
-	depends on ALPHA || X86 || IA64 || M32R || MIPS
+	depends on ALPHA || X86 || IA64 || M32R || MIPS || ARCH_RPC || ARCH_SHARK
+	default ARM && (ARCH_RPC || ARCH_SHARK)
 	help
 	  This is the generic IDE driver.  This driver attaches to the
 	  fixed legacy ports (e.g. on PCs 0x1f0/0x170, 0x1e8/0x168 and
@@ -726,11 +727,6 @@ config BLK_DEV_IDE_TX4939
 	depends on SOC_TX4939
 	select BLK_DEV_IDEDMA_SFF
 
-config IDE_ARM
-	tristate "ARM IDE support"
-	depends on ARM && (ARCH_RPC || ARCH_SHARK)
-	default y
-
 config BLK_DEV_IDE_ICSIDE
 	tristate "ICS IDE interface support"
 	depends on ARM && ARCH_ACORN
Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -21,8 +21,6 @@ ide-core-$(CONFIG_IDE_LEGACY)		+= ide-le
 
 obj-$(CONFIG_IDE)			+= ide-core.o
 
-obj-$(CONFIG_IDE_ARM)			+= ide_arm.o
-
 obj-$(CONFIG_BLK_DEV_ALI14XX)		+= ali14xx.o
 obj-$(CONFIG_BLK_DEV_UMC8672)		+= umc8672.o
 obj-$(CONFIG_BLK_DEV_DTC2278)		+= dtc2278.o
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -13,7 +13,10 @@
 #include <linux/ide.h>
 #include <linux/pci_ids.h>
 
-/* FIXME: convert m32r to use ide_platform host driver */
+/* FIXME: convert arm and m32r to use ide_platform host driver */
+#ifdef CONFIG_ARM
+#include <asm/irq.h>
+#endif
 #ifdef CONFIG_M32R
 #include <asm/m32r.h>
 #endif
@@ -28,8 +31,11 @@ static const struct ide_port_info ide_ge
 	.host_flags		= IDE_HFLAG_NO_DMA,
 };
 
-#if defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_MAPPI2) \
-	|| defined(CONFIG_PLAT_OPSPUT)
+#ifdef CONFIG_ARM
+static const u16 legacy_bases[] = { 0x1f0 };
+static const int legacy_irqs[]  = { IRQ_HARDDISK };
+#elif defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_MAPPI2) || \
+      defined(CONFIG_PLAT_OPSPUT)
 static const u16 legacy_bases[] = { 0x1f0 };
 static const int legacy_irqs[]  = { PLD_IRQ_CFIREQ };
 #elif defined(CONFIG_PLAT_MAPPI3)
@@ -45,11 +51,11 @@ static const int legacy_irqs[]  = { 14, 
 
 static void ide_generic_check_pci_legacy_iobases(int *primary, int *secondary)
 {
+#ifdef CONFIG_PCI
 	struct pci_dev *p = NULL;
 	u16 val;
 
 	for_each_pci_dev(p) {
-
 		if (pci_resource_start(p, 0) == 0x1f0)
 			*primary = 1;
 		if (pci_resource_start(p, 2) == 0x170)
@@ -64,7 +70,6 @@ static void ide_generic_check_pci_legacy
 		/* Intel MPIIX - PIO ATA on non PCI side of bridge */
 		if (p->vendor == PCI_VENDOR_ID_INTEL &&
 		    p->device == PCI_DEVICE_ID_INTEL_82371MX) {
-
 			pci_read_config_word(p, 0x6C, &val);
 			if (val & 0x8000) {
 				/* ATA port enabled */
@@ -75,6 +80,7 @@ static void ide_generic_check_pci_legacy
 			}
 		}
 	}
+#endif
 }
 
 static int __init ide_generic_init(void)
@@ -106,6 +112,7 @@ static int __init ide_generic_init(void)
 				printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX "
 						"not free.\n",
 						DRV_NAME, io_addr, io_addr + 7);
+				rc = -EBUSY;
 				continue;
 			}
 
@@ -114,6 +121,7 @@ static int __init ide_generic_init(void)
 						"not free.\n",
 						DRV_NAME, io_addr + 0x206);
 				release_region(io_addr, 8);
+				rc = -EBUSY;
 				continue;
 			}
 
Index: b/drivers/ide/ide_arm.c
===================================================================
--- a/drivers/ide/ide_arm.c
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- * ARM default IDE host driver
- *
- * Copyright (C) 2004 Bartlomiej Zolnierkiewicz
- * Based on code by: Russell King, Ian Molton and Alexander Schulz.
- *
- * May be copied or modified under the terms of the GNU General Public License.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/ide.h>
-
-#include <asm/irq.h>
-
-#define DRV_NAME "ide_arm"
-
-#define IDE_ARM_IO	0x1f0
-#define IDE_ARM_IRQ	IRQ_HARDDISK
-
-static const struct ide_port_info ide_arm_port_info = {
-	.host_flags		= IDE_HFLAG_NO_DMA,
-};
-
-static int __init ide_arm_init(void)
-{
-	unsigned long base = IDE_ARM_IO, ctl = IDE_ARM_IO + 0x206;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
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
-	ide_std_init_ports(&hw, base, ctl);
-	hw.irq = IDE_ARM_IRQ;
-	hw.chipset = ide_generic;
-
-	return ide_host_add(&ide_arm_port_info, hws, NULL);
-}
-
-module_init(ide_arm_init);
-
-MODULE_LICENSE("GPL");
