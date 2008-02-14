Return-Path: <linux-kernel-owner+w=401wt.eu-S934833AbYBNA15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934833AbYBNA15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934554AbYBNAWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:22:52 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:47260 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933516AbYBNAWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:22:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wrkpBfTcJ6PpPgDFbhzr0DLf+hbn5ytMeqWwBLHmpXMSp6Y0fLjQ1sIOSIRsBJ5sOViTwWS+wM7N7RHog8ZCpasexAlLi782qVMmH17J5jlr2Q1FqXHH0fmxaFb6shaVo/xD7UCJuJ4cY9aTABFqVerLotS2xsTxpNEJcRGIiDg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2008 01:37:15 +0100
Message-Id: <20080214003715.12879.31660.sendpatchset@localhost.localdomain>
In-Reply-To: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
References: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/11] ppc/sandpoint: remove ppc_ide_md hooks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add IDE_HFLAG_FORCE_LEGACY_IRQS host flag for Motorola-Sandpoint platform
  to sl82c105 host driver.

* Disable ide_generic host driver in arch/ppc/configs/sandpoint_defconfig
  and enable sl82c105 one.

* Remove ppc_ide_md hooks from arch/ppc/platforms/sandpoint.c - no need for
  them (sl82c105 host driver takes care of all this setup).

* Then remove no longer needed <linux/ide.h> include.

* Also update arch/ppc/platforms/sandpoint.h.

Unfortunately (unlike lopec's case) sl82c105 host driver was not enabled
in defconfing so there is a funcionality change.

[ Not a big deal since sl82c105 is superior over ide_generic. ]

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/ppc/configs/sandpoint_defconfig |    2 
 arch/ppc/platforms/sandpoint.c       |   94 -----------------------------------
 arch/ppc/platforms/sandpoint.h       |    3 -
 drivers/ide/pci/sl82c105.c           |    2 
 4 files changed, 2 insertions(+), 99 deletions(-)

Index: b/arch/ppc/configs/sandpoint_defconfig
===================================================================
--- a/arch/ppc/configs/sandpoint_defconfig
+++ b/arch/ppc/configs/sandpoint_defconfig
@@ -189,7 +189,7 @@ CONFIG_IDE_TASKFILE_IO=y
 #
 # IDE chipset support/bugfixes
 #
-CONFIG_IDE_GENERIC=y
+CONFIG_BLK_DEV_SL82C105=y
 # CONFIG_BLK_DEV_IDEPCI is not set
 # CONFIG_BLK_DEV_IDEDMA is not set
 # CONFIG_IDEDMA_AUTO is not set
Index: b/arch/ppc/platforms/sandpoint.c
===================================================================
--- a/arch/ppc/platforms/sandpoint.c
+++ b/arch/ppc/platforms/sandpoint.c
@@ -71,7 +71,6 @@
 #include <linux/initrd.h>
 #include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/ide.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
@@ -559,93 +558,6 @@ sandpoint_show_cpuinfo(struct seq_file *
 	return 0;
 }
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-/*
- * IDE support.
- */
-static int		sandpoint_ide_ports_known = 0;
-static unsigned long	sandpoint_ide_regbase[MAX_HWIFS];
-static unsigned long	sandpoint_ide_ctl_regbase[MAX_HWIFS];
-static unsigned long	sandpoint_idedma_regbase;
-
-static void
-sandpoint_ide_probe(void)
-{
-	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_WINBOND,
-			PCI_DEVICE_ID_WINBOND_82C105, NULL);
-
-	if (pdev) {
-		sandpoint_ide_regbase[0]=pdev->resource[0].start;
-		sandpoint_ide_regbase[1]=pdev->resource[2].start;
-		sandpoint_ide_ctl_regbase[0]=pdev->resource[1].start;
-		sandpoint_ide_ctl_regbase[1]=pdev->resource[3].start;
-		sandpoint_idedma_regbase=pdev->resource[4].start;
-		pci_dev_put(pdev);
-	}
-
-	sandpoint_ide_ports_known = 1;
-}
-
-static int
-sandpoint_ide_default_irq(unsigned long base)
-{
-	if (sandpoint_ide_ports_known == 0)
-		sandpoint_ide_probe();
-
-	if (base == sandpoint_ide_regbase[0])
-		return SANDPOINT_IDE_INT0;
-	else if (base == sandpoint_ide_regbase[1])
-		return SANDPOINT_IDE_INT1;
-	else
-		return 0;
-}
-
-static unsigned long
-sandpoint_ide_default_io_base(int index)
-{
-	if (sandpoint_ide_ports_known == 0)
-		sandpoint_ide_probe();
-
-	return sandpoint_ide_regbase[index];
-}
-
-static void __init
-sandpoint_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port,
-		unsigned long ctrl_port, int *irq)
-{
-	unsigned long reg = data_port;
-	uint	alt_status_base;
-	int	i;
-
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hw->io_ports[i] = reg++;
-	}
-
-	if (data_port == sandpoint_ide_regbase[0]) {
-		alt_status_base = sandpoint_ide_ctl_regbase[0] + 2;
-		hw->irq = 14;
-	}
-	else if (data_port == sandpoint_ide_regbase[1]) {
-		alt_status_base = sandpoint_ide_ctl_regbase[1] + 2;
-		hw->irq = 15;
-	}
-	else {
-		alt_status_base = 0;
-		hw->irq = 0;
-	}
-
-	if (ctrl_port) {
-		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
-	} else {
-		hw->io_ports[IDE_CONTROL_OFFSET] = alt_status_base;
-	}
-
-	if (irq != NULL) {
-		*irq = hw->irq;
-	}
-}
-#endif
-
 /*
  * Set BAT 3 to map 0xf8000000 to end of physical memory space 1-to-1.
  */
@@ -736,10 +648,4 @@ platform_init(unsigned long r3, unsigned
 #ifdef CONFIG_SERIAL_TEXT_DEBUG
 	ppc_md.progress = gen550_progress;
 #endif
-
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-	ppc_ide_md.default_irq = sandpoint_ide_default_irq;
-	ppc_ide_md.default_io_base = sandpoint_ide_default_io_base;
-	ppc_ide_md.ide_init_hwif = sandpoint_ide_init_hwif_ports;
-#endif
 }
Index: b/arch/ppc/platforms/sandpoint.h
===================================================================
--- a/arch/ppc/platforms/sandpoint.h
+++ b/arch/ppc/platforms/sandpoint.h
@@ -28,9 +28,6 @@
  */
 #define SANDPOINT_IDE_INT0		23	/* EPIC 7 */
 #define SANDPOINT_IDE_INT1		24	/* EPIC 8 */
-#else
-#define SANDPOINT_IDE_INT0		14	/* 8259 Test */
-#define SANDPOINT_IDE_INT1		15	/* 8259 Test */
 #endif
 
 /*
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -329,7 +329,7 @@ static const struct ide_port_info sl82c1
 	.host_flags	= IDE_HFLAG_IO_32BIT |
 			  IDE_HFLAG_UNMASK_IRQS |
 /* FIXME: check for Compatibility mode in generic IDE PCI code */
-#ifdef CONFIG_LOPEC
+#if defined(CONFIG_LOPEC) || defined(CONFIG_SANDPOINT)
 			  IDE_HFLAG_FORCE_LEGACY_IRQS |
 #endif
 			  IDE_HFLAG_NO_AUTODMA |
