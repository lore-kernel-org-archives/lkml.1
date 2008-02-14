Return-Path: <linux-kernel-owner+w=401wt.eu-S934869AbYBNA0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934869AbYBNA0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934539AbYBNAWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:22:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:64981 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950AbYBNAWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:22:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tDwriZJcgVlbFTU+xb4xo0AFsHBghcefHhHNMlOlyA+up6vnruAIW8Rvt9rfOwGLmTK2sfRkcQbNCwlqlCi88vwTXwc+3AtVpJrHnN+sLtgw0J9mjXTvu2OFKbx/3YnKMpXoxBwEF6JbkXXmnWUCusJIntBXdB08EINrPqoM+O0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2008 01:36:56 +0100
Message-Id: <20080214003656.12879.21968.sendpatchset@localhost.localdomain>
In-Reply-To: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
References: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/11] ppc/mpc8xx: remove ppc_ide_md hooks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Initialize IDE ports in mpc8xx_ide_probe().

* Remove m8xx_ide_init() and ppc_ide_md hooks - no need for them
  (IDE mpc8xx host driver takes care of all this setup).

* Remove needless 'if (irq)' and 'if (data_port >= MAX_HWIFS)' checks
  from m8xx_ide_init_hwif_ports().

* Remove 'ctrl_port' and 'irq' arguments from m8xx_ide_init_hwif_ports().

* Rename m8xx_ide_init_hwif_ports() to m8xx_ide_init_ports().

* Add __init tag to m8xx_ide_init_ports().

This patch fixes hwif->irq always being overriden to 0 (== auto-probe, is
this even working on PPC?) because of ide_init_default_irq() call in ide.c.

There should be no other functional changes.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/ppc/syslib/m8xx_setup.c |    6 ---
 drivers/ide/ppc/mpc8xx.c     |   86 +++++++++++--------------------------------
 2 files changed, 22 insertions(+), 70 deletions(-)

Index: b/arch/ppc/syslib/m8xx_setup.c
===================================================================
--- a/arch/ppc/syslib/m8xx_setup.c
+++ b/arch/ppc/syslib/m8xx_setup.c
@@ -87,8 +87,6 @@ void m8xx_calibrate_decr(void);
 
 unsigned char __res[sizeof(bd_t)];
 
-extern void m8xx_ide_init(void);
-
 extern unsigned long find_available_memory(void);
 extern void m8xx_cpm_reset(void);
 extern void m8xx_wdt_handler_install(bd_t *bp);
@@ -474,8 +472,4 @@ platform_init(unsigned long r3, unsigned
 
 	ppc_md.find_end_of_memory	= m8xx_find_end_of_memory;
 	ppc_md.setup_io_mappings	= m8xx_map_io;
-
-#if defined(CONFIG_BLK_DEV_MPC8xx_IDE)
-	m8xx_ide_init();
-#endif
 }
Index: b/drivers/ide/ppc/mpc8xx.c
===================================================================
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -99,32 +99,6 @@ static int _slot_ = -1;			/* will be rea
 /* Make clock cycles and always round up */
 #define PCMCIA_MK_CLKS( t, T ) (( (t) * ((T)/1000000) + 999U ) / 1000U )
 
-
-
-/*
- * IDE stuff.
- */
-static int
-m8xx_ide_default_irq(unsigned long base)
-{
-#ifdef CONFIG_BLK_DEV_MPC8xx_IDE
-	if (base >= MAX_HWIFS)
-		return 0;
-
-	printk("[%d] m8xx_ide_default_irq %d\n",__LINE__,ioport_dsc[base].irq);
-	
-	return (ioport_dsc[base].irq);
-#else
-        return 9;
-#endif
-}
-
-static unsigned long
-m8xx_ide_default_io_base(int index)
-{
-        return index;
-}
-
 #define M8XX_PCMCIA_CD2(slot)      (0x10000000 >> (slot << 4))
 #define M8XX_PCMCIA_CD1(slot)      (0x08000000 >> (slot << 4))
 
@@ -149,12 +123,11 @@ static int pcmcia_schlvl = PCMCIA_SCHLVL
  */
 
 /*
- * m8xx_ide_init_hwif_ports for a direct IDE interface _using_
+ * m8xx_ide_init_ports() for a direct IDE interface _using_
+ * MPC8xx's internal PCMCIA interface
  */
 #if defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_DIRECT)
-static void
-m8xx_ide_init_hwif_ports(hw_regs_t *hw, unsigned long data_port, 
-		unsigned long ctrl_port, int *irq)
+static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 {
 	unsigned long *p = hw->io_ports;
 	int i;
@@ -173,8 +146,6 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, 
 	unsigned long base;
 
 	*p = 0;
-	if (irq)
-		*irq = 0;
 
 	pcmp = (pcmconf8xx_t *)(&(((immap_t *)IMAP_ADDR)->im_pcmcia));
 
@@ -248,9 +219,6 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, 
 		}
 	}
 
-	if (data_port >= MAX_HWIFS)
-		return;
-
 	if (_slot_ == -1) {
 		printk ("PCMCIA slot has not been defined! Using A as default\n");
 		_slot_ = 0;
@@ -292,11 +260,13 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, 
 	 	*p++ = base + ioport_dsc[data_port].reg_off[i];
 	}
 
-	if (irq) {
+	hw->irq = ioport_dsc[data_port].irq;
+	hw->ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
+
 #ifdef CONFIG_IDE_8xx_PCCARD
+	{
 		unsigned int reg;
 
-		*irq = ioport_dsc[data_port].irq;
 		if (_slot_)
 			pgcrx = &((immap_t *) IMAP_ADDR)->im_pcmcia.pcmc_pgcrb;
 		else
@@ -306,14 +276,11 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, 
 		reg |= mk_int_int_mask (pcmcia_schlvl) << 24;
 		reg |= mk_int_int_mask (pcmcia_schlvl) << 16;
 		*pgcrx = reg;
-#else	/* direct connected IDE drive, i.e. external IRQ, not the PCMCIA irq */
-		*irq = ioport_dsc[data_port].irq;
-#endif	/* CONFIG_IDE_8xx_PCCARD */
 	}
+#endif	/* CONFIG_IDE_8xx_PCCARD */
 
 	ide_hwifs[data_port].pio_mask = ATA_PIO4;
 	ide_hwifs[data_port].set_pio_mode = m8xx_ide_set_pio_mode;
-	ide_hwifs[data_port].ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
 
 	/* Enable Harddisk Interrupt,
 	 * and make it edge sensitive
@@ -329,16 +296,15 @@ m8xx_ide_init_hwif_ports(hw_regs_t *hw, 
 	/* Enable falling edge irq */
 	pcmp->pcmc_per = 0x100000 >> (16 * _slot_);
 #endif	/* CONFIG_IDE_8xx_PCCARD */
-}	/* m8xx_ide_init_hwif_ports() using 8xx internal PCMCIA interface */
+}
 #endif /* CONFIG_IDE_8xx_PCCARD || CONFIG_IDE_8xx_DIRECT */
 
 /*
- * m8xx_ide_init_hwif_ports for a direct IDE interface _not_ using
+ * m8xx_ide_init_ports() for a direct IDE interface _not_ using
  * MPC8xx's internal PCMCIA interface
  */
 #if defined(CONFIG_IDE_EXT_DIRECT)
-void m8xx_ide_init_hwif_ports (hw_regs_t *hw,
-	unsigned long data_port, unsigned long ctrl_port, int *irq)
+static void __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 {
 	unsigned long *p = hw->io_ports;
 	int i;
@@ -349,8 +315,6 @@ void m8xx_ide_init_hwif_ports (hw_regs_t
 	unsigned long base;
 
 	*p = 0;
-	if (irq)
-		*irq = 0;
 
 	if (!ide_base) {
 
@@ -372,9 +336,6 @@ void m8xx_ide_init_hwif_ports (hw_regs_t
 #endif
 	}
 
-	if (data_port >= MAX_HWIFS)
-		return;
-
 	base = ide_base + ioport_dsc[data_port].base_off;
 #ifdef DEBUG
 	printk ("base: %08x + %08x = %08x\n",
@@ -392,14 +353,12 @@ void m8xx_ide_init_hwif_ports (hw_regs_t
 	 	*p++ = base + ioport_dsc[data_port].reg_off[i];
 	}
 
-	if (irq) {
-		/* direct connected IDE drive, i.e. external IRQ */
-		*irq = ioport_dsc[data_port].irq;
-	}
+	/* direct connected IDE drive, i.e. external IRQ */
+	hw->irq = ioport_dsc[data_port].irq;
+	hw->ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
 
 	ide_hwifs[data_port].pio_mask = ATA_PIO4;
 	ide_hwifs[data_port].set_pio_mode = m8xx_ide_set_pio_mode;
-	ide_hwifs[data_port].ack_intr = (ide_ack_intr_t *)ide_interrupt_ack;
 
 	/* Enable Harddisk Interrupt,
 	 * and make it edge sensitive
@@ -407,8 +366,7 @@ void m8xx_ide_init_hwif_ports (hw_regs_t
 	/* (11-18) Set edge detect for irq, no wakeup from low power mode */
 	((immap_t *) IMAP_ADDR)->im_siu_conf.sc_siel |=
 			(0x80000000 >> ioport_dsc[data_port].irq);
-}	/* m8xx_ide_init_hwif_ports() for CONFIG_IDE_8xx_DIRECT */ 
-
+}
 #endif	/* CONFIG_IDE_8xx_DIRECT */
 
 
@@ -829,20 +787,20 @@ static int identify  (volatile u8 *p)
 	return (0);	/* don't know */
 }
 
-void m8xx_ide_init(void)
-{
-	ppc_ide_md.default_irq          = m8xx_ide_default_irq;
-	ppc_ide_md.default_io_base      = m8xx_ide_default_io_base;
-	ppc_ide_md.ide_init_hwif        = m8xx_ide_init_hwif_ports;
-}
-
 static int __init mpc8xx_ide_probe(void)
 {
+	hw_regs_t hw;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 #ifdef IDE0_BASE_OFFSET
+	memset(&hw, 0, sizeof(hw));
+	m8xx_ide_init_ports(&hw, 0);
+	ide_init_port_hw(&ide_hwifs[0], &hw);
 	idx[0] = 0;
 #ifdef IDE1_BASE_OFFSET
+	memset(&hw, 0, sizeof(hw));
+	m8xx_ide_init_ports(&hw, 1);
+	ide_init_port_hw(&ide_hwifs[1], &hw);
 	idx[1] = 1;
 #endif
 #endif
