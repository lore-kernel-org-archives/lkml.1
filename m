Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbXDDRzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbXDDRzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXDDRzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:55:08 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:36057 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbXDDRzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:55:06 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Juha Yrjola <juha.yrjola@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 7/90] ARM: OMAP: Optimize INTC register accesses and enable autoidling
Date: Wed,  4 Apr 2007 13:46:34 -0400
Message-Id: <11757088932135-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757088904153-git-send-email-tony@atomide.com>
References: omap-2007-04-04-133556 <11757088774110-git-send-email-tony@atomide.com> <11757088791107-git-send-email-tony@atomide.com> <11757088822930-git-send-email-tony@atomide.com> <11757088844012-git-send-email-tony@atomide.com> <1175708886798-git-send-email-tony@atomide.com> <11757088883638-git-send-email-tony@atomide.com> <11757088904153-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

Use virtual addresses directly instead of physical addresses to
avoid having to recalculate the virtual address with every
register access.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/irq.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index a39d306..f064f72 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -37,7 +37,7 @@ static struct omap_irq_bank {
 } __attribute__ ((aligned(4))) irq_banks[] = {
 	{
 		/* MPU INTC */
-		.base_reg	= OMAP24XX_IC_BASE,
+		.base_reg	= IO_ADDRESS(OMAP24XX_IC_BASE),
 		.nr_irqs	= 96,
 	}, {
 		/* XXX: DSP INTC */
@@ -47,7 +47,7 @@ static struct omap_irq_bank {
 /* XXX: FIQ and additional INTC support (only MPU at the moment) */
 static void omap_ack_irq(unsigned int irq)
 {
-	omap_writel(0x1, irq_banks[0].base_reg + INTC_CONTROL);
+	__raw_writel(0x1, irq_banks[0].base_reg + INTC_CONTROL);
 }
 
 static void omap_mask_irq(unsigned int irq)
@@ -60,7 +60,7 @@ static void omap_mask_irq(unsigned int irq)
 		irq %= 32;
 	}
 
-	omap_writel(1 << irq, irq_banks[0].base_reg + INTC_MIR_SET0 + offset);
+	__raw_writel(1 << irq, irq_banks[0].base_reg + INTC_MIR_SET0 + offset);
 }
 
 static void omap_unmask_irq(unsigned int irq)
@@ -73,7 +73,7 @@ static void omap_unmask_irq(unsigned int irq)
 		irq %= 32;
 	}
 
-	omap_writel(1 << irq, irq_banks[0].base_reg + INTC_MIR_CLEAR0 + offset);
+	__raw_writel(1 << irq, irq_banks[0].base_reg + INTC_MIR_CLEAR0 + offset);
 }
 
 static void omap_mask_ack_irq(unsigned int irq)
@@ -93,17 +93,20 @@ static void __init omap_irq_bank_init_one(struct omap_irq_bank *bank)
 {
 	unsigned long tmp;
 
-	tmp = omap_readl(bank->base_reg + INTC_REVISION) & 0xff;
+	tmp = __raw_readl(bank->base_reg + INTC_REVISION) & 0xff;
 	printk(KERN_INFO "IRQ: Found an INTC at 0x%08lx "
 			 "(revision %ld.%ld) with %d interrupts\n",
 			 bank->base_reg, tmp >> 4, tmp & 0xf, bank->nr_irqs);
 
-	tmp = omap_readl(bank->base_reg + INTC_SYSCONFIG);
+	tmp = __raw_readl(bank->base_reg + INTC_SYSCONFIG);
 	tmp |= 1 << 1;	/* soft reset */
-	omap_writel(tmp, bank->base_reg + INTC_SYSCONFIG);
+	__raw_writel(tmp, bank->base_reg + INTC_SYSCONFIG);
 
-	while (!(omap_readl(bank->base_reg + INTC_SYSSTATUS) & 0x1))
+	while (!(__raw_readl(bank->base_reg + INTC_SYSSTATUS) & 0x1))
 		/* Wait for reset to complete */;
+
+	/* Enable autoidle */
+	__raw_writel(1 << 0, bank->base_reg + INTC_SYSCONFIG);
 }
 
 void __init omap_init_irq(void)
-- 
1.4.4.2

