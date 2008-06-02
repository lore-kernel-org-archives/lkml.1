Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbYFBUVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbYFBUVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYFBUV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:21:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:17242 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYFBUV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=WJP6nblvSEcyCC+XilCGrWYWih5Zk1QFFW7PMEq29NBeoWqswPMXD6iBFU4sjnWr2zyr1uCyhmnSoNUFmUBKjvU0C/i8HWdM7idA1F6X6fXXTqCRP7kYpApNVfkDpxUFToQkadP4qaFgG5mhAgtY7qQsEC2czV2e77fDqZFPyqc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Jun 2008 22:22:53 +0200
Message-Id: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/9] ide: fix host drivers missing hwif->chipset initialization
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide_find_port() now depends on ->chipset being set for occupied ide_hwifs[]
slots so all host drivers have to initialize hwif->chipset properly.

This patch fixes a regression on hosts with > 1 port or with a single port
but no devices attached to it for an affected host drivers.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/bast-ide.c     |    1 +
 drivers/ide/arm/ide_arm.c      |    1 +
 drivers/ide/ide-pnp.c          |    1 +
 drivers/ide/ide-probe.c        |    1 +
 drivers/ide/legacy/buddha.c    |    2 ++
 drivers/ide/legacy/falconide.c |    2 ++
 drivers/ide/legacy/gayle.c     |    2 ++
 drivers/ide/legacy/macide.c    |    2 ++
 drivers/ide/legacy/q40ide.c    |    2 ++
 drivers/ide/pci/cmd640.c       |    2 ++
 drivers/ide/ppc/mpc8xx.c       |    4 ++++
 11 files changed, 20 insertions(+)

Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -42,6 +42,7 @@ static int __init bastide_register(unsig
 
 	hw.io_ports.ctl_addr = aux + (6 * 0x20);
 	hw.irq = irq;
+	hw.chipset = ide_generic;
 
 	hwif = ide_find_port();
 	if (hwif == NULL)
Index: b/drivers/ide/arm/ide_arm.c
===================================================================
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -49,6 +49,7 @@ static int __init ide_arm_init(void)
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = IDE_ARM_IRQ;
+	hw.chipset = ide_generic;
 
 	hwif = ide_find_port();
 	if (hwif) {
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -55,6 +55,7 @@ static int idepnp_probe(struct pnp_dev *
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = pnp_irq(dev, 0);
+	hw.chipset = ide_generic;
 
 	hwif = ide_find_port();
 	if (hwif) {
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1670,6 +1670,7 @@ static void ide_legacy_init_one(u8 *idx,
 
 	ide_std_init_ports(hw, base, ctl);
 	hw->irq = irq;
+	hw->chipset = d->chipset;
 
 	hwif = ide_find_port_slot(d);
 	if (hwif) {
Index: b/drivers/ide/legacy/buddha.c
===================================================================
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -138,6 +138,8 @@ static void __init buddha_setup_ports(hw
 
 	hw->irq = IRQ_AMIGA_PORTS;
 	hw->ack_intr = ack_intr;
+
+	hw->chipset = ide_generic;
 }
 
     /*
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -81,6 +81,8 @@ static void __init falconide_setup_ports
 
 	hw->irq = IRQ_MFP_IDE;
 	hw->ack_intr = NULL;
+
+	hw->chipset = ide_generic;
 }
 
     /*
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -113,6 +113,8 @@ static void __init gayle_setup_ports(hw_
 
 	hw->irq = IRQ_AMIGA_PORTS;
 	hw->ack_intr = ack_intr;
+
+	hw->chipset = ide_generic;
 }
 
     /*
Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -78,6 +78,8 @@ static void __init macide_setup_ports(hw
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
+
+	hw->chipset = ide_generic;
 }
 
 static const char *mac_ide_name[] =
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -70,6 +70,8 @@ static void q40_ide_setup_ports(hw_regs_
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
+
+	hw->chipset = ide_generic;
 }
 
 static void q40ide_input_data(ide_drive_t *drive, struct request *rq,
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -749,9 +749,11 @@ static int __init cmd640x_init(void)
 
 	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
 	hw[0].irq = 14;
+	hw[0].chipset = ide_cmd640;
 
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
+	hw[1].chipset = ide_cmd640;
 
 	printk(KERN_INFO "cmd640: buggy cmd640%c interface on %s, config=0x%02x"
 			 "\n", 'a' + cmd640_chip_version - 1, bus_type, cfr);
Index: b/drivers/ide/ppc/mpc8xx.c
===================================================================
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -296,6 +296,8 @@ static int __init m8xx_ide_init_ports(hw
 	pcmp->pcmc_per = 0x100000 >> (16 * _slot_);
 #endif	/* CONFIG_IDE_8xx_PCCARD */
 
+	hw->chipset = ide_generic;
+
 	return 0;
 }
 #endif /* CONFIG_IDE_8xx_PCCARD || CONFIG_IDE_8xx_DIRECT */
@@ -370,6 +372,8 @@ static int __init m8xx_ide_init_ports(hw
 	((immap_t *) IMAP_ADDR)->im_siu_conf.sc_siel |=
 			(0x80000000 >> ioport_dsc[data_port].irq);
 
+	hw->chipset = ide_generic;
+
 	return 0;
 }
 #endif	/* CONFIG_IDE_8xx_DIRECT */
