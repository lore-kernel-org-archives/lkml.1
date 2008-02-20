Return-Path: <linux-kernel-owner+w=401wt.eu-S1764346AbYBTAhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764346AbYBTAhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761697AbYBTAgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:36:35 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:37687 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758742AbYBTAgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:36:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TtRrghA43yCE8jOhuRMPTx6QTWZlcI1ThuRkC20gi/CsJJASyapAawn5M3eB3cPV38S5/uKTAeO+gxJBLeP4KgppTVyVgruNAPFdksNsbWJfdwnfVOC4XREM5Vr+gO0eQbRXtbd+cN6n+KD6FgQCWd/gRCAtWecN4Yq9C6vPBiU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] ide-mpc8xx: make m8xx_ide_init_ports() return an error value
Date: Wed, 20 Feb 2008 01:48:26 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Vitaly Bordug <vitb@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802200148.26395.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Make m8xx_ide_init_ports() return an error value.

* Update mpc8xx_ide_probe() to setup/probe only ports for which
  m8xx_ide_init_ports() succedded.

Cc: Vitaly Bordug <vitb@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/mpc8xx.c |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

Index: b/drivers/ide/ppc/mpc8xx.c
===================================================================
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -127,7 +127,7 @@ static int pcmcia_schlvl = PCMCIA_SCHLVL
  * MPC8xx's internal PCMCIA interface
  */
 #if defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_DIRECT)
-static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
+static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 {
 	unsigned long *p = hw->io_ports;
 	int i;
@@ -236,7 +236,7 @@ static void __init m8xx_ide_init_ports(h
 	if (pcmp->pcmc_pipr & (M8XX_PCMCIA_CD1(_slot_)|M8XX_PCMCIA_CD2(_slot_))) {
 		printk ("No card in slot %c: PIPR=%08x\n",
 			'A' + _slot_, (u32) pcmp->pcmc_pipr);
-		return;		/* No card in slot */
+		return -ENODEV;		/* No card in slot */
 	}
 
 	check_ide_device (pcmcia_base);
@@ -279,9 +279,6 @@ static void __init m8xx_ide_init_ports(h
 	}
 #endif	/* CONFIG_IDE_8xx_PCCARD */
 
-	ide_hwifs[data_port].pio_mask = ATA_PIO4;
-	ide_hwifs[data_port].set_pio_mode = m8xx_ide_set_pio_mode;
-
 	/* Enable Harddisk Interrupt,
 	 * and make it edge sensitive
 	 */
@@ -296,6 +293,8 @@ static void __init m8xx_ide_init_ports(h
 	/* Enable falling edge irq */
 	pcmp->pcmc_per = 0x100000 >> (16 * _slot_);
 #endif	/* CONFIG_IDE_8xx_PCCARD */
+
+	return 0;
 }
 #endif /* CONFIG_IDE_8xx_PCCARD || CONFIG_IDE_8xx_DIRECT */
 
@@ -304,7 +303,7 @@ static void __init m8xx_ide_init_ports(h
  * MPC8xx's internal PCMCIA interface
  */
 #if defined(CONFIG_IDE_EXT_DIRECT)
-static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
+static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 {
 	unsigned long *p = hw->io_ports;
 	int i;
@@ -357,15 +356,14 @@ static void __init m8xx_ide_init_ports(h
 	hw->irq = ioport_dsc[data_port].irq;
 	hw->ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
 
-	ide_hwifs[data_port].pio_mask = ATA_PIO4;
-	ide_hwifs[data_port].set_pio_mode = m8xx_ide_set_pio_mode;
-
 	/* Enable Harddisk Interrupt,
 	 * and make it edge sensitive
 	 */
 	/* (11-18) Set edge detect for irq, no wakeup from low power mode */
 	((immap_t *) IMAP_ADDR)->im_siu_conf.sc_siel |=
 			(0x80000000 >> ioport_dsc[data_port].irq);
+
+	return 0;
 }
 #endif	/* CONFIG_IDE_8xx_DIRECT */
 
@@ -794,14 +792,26 @@ static int __init mpc8xx_ide_probe(void)
 
 #ifdef IDE0_BASE_OFFSET
 	memset(&hw, 0, sizeof(hw));
-	m8xx_ide_init_ports(&hw, 0);
-	ide_init_port_hw(&ide_hwifs[0], &hw);
-	idx[0] = 0;
+	if (!m8xx_ide_init_ports(&hw, 0)) {
+		ide_hwif_t *hwif = &ide_hwifs[0];
+
+		ide_init_port_hw(hwif, &hw);
+		hwif->pio_mask = ATA_PIO4;
+		hwif->set_pio_mode = m8xx_ide_set_pio_mode;
+
+		idx[0] = 0;
+	}
 #ifdef IDE1_BASE_OFFSET
 	memset(&hw, 0, sizeof(hw));
-	m8xx_ide_init_ports(&hw, 1);
-	ide_init_port_hw(&ide_hwifs[1], &hw);
-	idx[1] = 1;
+	if (!m8xx_ide_init_ports(&hw, 1)) {
+		ide_hwif_t *mate = &ide_hwifs[1];
+
+		ide_init_port_hw(mate, &hw);
+		mate->pio_mask = ATA_PIO4;
+		mate->set_pio_mode = m8xx_ide_set_pio_mode;
+
+		idx[1] = 1;
+	}
 #endif
 #endif
 
