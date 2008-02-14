Return-Path: <linux-kernel-owner+w=401wt.eu-S964804AbYBNA1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804AbYBNA1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934553AbYBNAWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:22:48 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:47260 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933338AbYBNAWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:22:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PlML1bbUu/V0NNTRL73py/jR2RGRRC+tjERlEKTHAqVLaE+wORW7hNhnCU+YADW5kpALDwMxlYR5s5dpmc+M7S23iBPVLp8GYR9NFLFx1DJRw8xtjML5erGnzvG5R2ufPEuDyIiRehsV2ctAPPkjsA51HJMe8Qhe6d/eePBTbqA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2008 01:37:08 +0100
Message-Id: <20080214003708.12879.9696.sendpatchset@localhost.localdomain>
In-Reply-To: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
References: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/11] ppc/lopec: remove ppc_ide_md hooks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add IDE_HFLAG_FORCE_LEGACY_IRQS host flag for Motorola-LoPEC platform
  to sl82c105 host driver.

* Remove ppc_ide_md hooks from arch/ppc/platforms/lopec.c - no need for
  them (sl82c105 host driver takes care of all this setup).

* Then remove no longer needed <linux/ide.h> include.

Looking at arch/ppc/configs/lopec_defconfig:

...
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_SHARE_IRQ is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_SL82C105=y
...

there should be no functional changes unless somebody preferred to disable
sl82c105 host driver and use only ide_generic one (but why would anybody
want to do such thing :-).

PS It seems that lopec_defconfig hasn't been updated for ages but if somebody
is going to do it please look into disabling IDE_GENERIC and BLK_DEV_GENERIC
config options.  Thanks.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/ppc/platforms/lopec.c |   85 ---------------------------------------------
 drivers/ide/pci/sl82c105.c |    4 ++
 2 files changed, 4 insertions(+), 85 deletions(-)

Index: b/arch/ppc/platforms/lopec.c
===================================================================
--- a/arch/ppc/platforms/lopec.c
+++ b/arch/ppc/platforms/lopec.c
@@ -15,7 +15,6 @@
 #include <linux/pci_ids.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
-#include <linux/ide.h>
 #include <linux/seq_file.h>
 #include <linux/initrd.h>
 #include <linux/console.h>
@@ -168,85 +167,6 @@ lopec_power_off(void)
 	lopec_halt();
 }
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-int lopec_ide_ports_known = 0;
-static unsigned long lopec_ide_regbase[MAX_HWIFS];
-static unsigned long lopec_ide_ctl_regbase[MAX_HWIFS];
-static unsigned long lopec_idedma_regbase;
-
-static void
-lopec_ide_probe(void)
-{
-	struct pci_dev *dev = pci_get_device(PCI_VENDOR_ID_WINBOND,
-					      PCI_DEVICE_ID_WINBOND_82C105,
-					      NULL);
-	lopec_ide_ports_known = 1;
-
-	if (dev) {
-		lopec_ide_regbase[0] = dev->resource[0].start;
-		lopec_ide_regbase[1] = dev->resource[2].start;
-		lopec_ide_ctl_regbase[0] = dev->resource[1].start;
-		lopec_ide_ctl_regbase[1] = dev->resource[3].start;
-		lopec_idedma_regbase = dev->resource[4].start;
-		pci_dev_put(dev);
-	}
-}
-
-static int
-lopec_ide_default_irq(unsigned long base)
-{
-	if (lopec_ide_ports_known == 0)
-		lopec_ide_probe();
-
-	if (base == lopec_ide_regbase[0])
-		return 14;
-	else if (base == lopec_ide_regbase[1])
-		return 15;
-	else
-		return 0;
-}
-
-static unsigned long
-lopec_ide_default_io_base(int index)
-{
-	if (lopec_ide_ports_known == 0)
-		lopec_ide_probe();
-	return lopec_ide_regbase[index];
-}
-
-static void __init
-lopec_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data,
-			  unsigned long ctl, int *irq)
-{
-	unsigned long reg = data;
-	uint alt_status_base;
-	int i;
-
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
-		hw->io_ports[i] = reg++;
-
-	if (data == lopec_ide_regbase[0]) {
-		alt_status_base = lopec_ide_ctl_regbase[0] + 2;
-		hw->irq = 14;
-	} else if (data == lopec_ide_regbase[1]) {
-		alt_status_base = lopec_ide_ctl_regbase[1] + 2;
-		hw->irq = 15;
-	} else {
-		alt_status_base = 0;
-		hw->irq = 0;
-	}
-
-	if (ctl)
-		hw->io_ports[IDE_CONTROL_OFFSET] = ctl;
-	else
-		hw->io_ports[IDE_CONTROL_OFFSET] = alt_status_base;
-
-	if (irq != NULL)
-		*irq = hw->irq;
-
-}
-#endif /* BLK_DEV_IDE */
-
 static void __init
 lopec_init_IRQ(void)
 {
@@ -384,11 +304,6 @@ platform_init(unsigned long r3, unsigned
 	ppc_md.nvram_read_val = todc_direct_read_val;
 	ppc_md.nvram_write_val = todc_direct_write_val;
 
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_IDE_MODULE)
-	ppc_ide_md.default_irq = lopec_ide_default_irq;
-	ppc_ide_md.default_io_base = lopec_ide_default_io_base;
-	ppc_ide_md.ide_init_hwif = lopec_ide_init_hwif_ports;
-#endif
 #ifdef CONFIG_SERIAL_TEXT_DEBUG
 	ppc_md.progress = gen550_progress;
 #endif
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -328,6 +328,10 @@ static const struct ide_port_info sl82c1
 	.enablebits	= {{0x40,0x01,0x01}, {0x40,0x10,0x10}},
 	.host_flags	= IDE_HFLAG_IO_32BIT |
 			  IDE_HFLAG_UNMASK_IRQS |
+/* FIXME: check for Compatibility mode in generic IDE PCI code */
+#ifdef CONFIG_LOPEC
+			  IDE_HFLAG_FORCE_LEGACY_IRQS |
+#endif
 			  IDE_HFLAG_NO_AUTODMA |
 			  IDE_HFLAG_BOOTABLE,
 	.pio_mask	= ATA_PIO5,
