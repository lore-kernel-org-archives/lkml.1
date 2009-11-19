Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZKSJop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZKSJop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 04:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZKSJoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 04:44:44 -0500
Received: from www.tglx.de ([62.245.132.106]:46980 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbZKSJom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 04:44:42 -0500
Date: Thu, 19 Nov 2009 10:44:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Scott Wood <scottwood@freescale.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@ozlabs.org
Subject: [patch] powerpc: Fixup last users of irq_chip->typename - V2
In-Reply-To: <alpine.LFD.2.00.0911182141060.24119@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911191035030.24119@localhost.localdomain>
References: <20091117224852.846805939@linutronix.de> <20091117224916.566205413@linutronix.de> <20091118175523.GA12857@b07421-ec1.am.freescale.net> <alpine.LFD.2.00.0911182141060.24119@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The typename member of struct irq_chip was kept for migration purposes
and is obsolete since more than 2 years. Fix up the leftovers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/kernel/irq.c                       |    6 +++---
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c  |    2 +-
 arch/powerpc/platforms/52xx/media5200.c         |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c       |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c       |    8 ++++----
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c    |    1 -
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c |    2 +-
 arch/powerpc/platforms/86xx/gef_pic.c           |    2 +-
 arch/powerpc/platforms/cell/axon_msi.c          |    2 +-
 arch/powerpc/platforms/cell/beat_interrupt.c    |    2 +-
 arch/powerpc/platforms/cell/interrupt.c         |    4 ++--
 arch/powerpc/platforms/cell/spider-pic.c        |    2 +-
 arch/powerpc/platforms/iseries/irq.c            |    2 +-
 arch/powerpc/platforms/powermac/pic.c           |    2 +-
 arch/powerpc/platforms/ps3/interrupt.c          |    2 +-
 arch/powerpc/platforms/pseries/xics.c           |    4 ++--
 arch/powerpc/sysdev/cpm1.c                      |    2 +-
 arch/powerpc/sysdev/cpm2_pic.c                  |    2 +-
 arch/powerpc/sysdev/fsl_msi.c                   |    2 +-
 arch/powerpc/sysdev/i8259.c                     |    2 +-
 arch/powerpc/sysdev/ipic.c                      |    4 ++--
 arch/powerpc/sysdev/mpc8xx_pic.c                |    2 +-
 arch/powerpc/sysdev/mpic.c                      |    6 +++---
 arch/powerpc/sysdev/mpic_pasemi_msi.c           |    2 +-
 arch/powerpc/sysdev/mpic_u3msi.c                |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c              |    2 +-
 arch/powerpc/sysdev/tsi108_pci.c                |    2 +-
 arch/powerpc/sysdev/uic.c                       |    2 +-
 arch/powerpc/sysdev/xilinx_intc.c               |    4 ++--
 29 files changed, 39 insertions(+), 40 deletions(-)

Index: linux-2.6-tip/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6-tip/arch/powerpc/kernel/irq.c
@@ -203,7 +203,7 @@ int show_interrupts(struct seq_file *p, 
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif /* CONFIG_SMP */
 		if (desc->chip)
-			seq_printf(p, " %s ", desc->chip->typename);
+			seq_printf(p, " %s ", desc->chip->name);
 		else
 			seq_puts(p, "  None      ");
 		seq_printf(p, "%s", (desc->status & IRQ_LEVEL) ? "Level " : "Edge  ");
@@ -1071,8 +1071,8 @@ static int virq_debug_show(struct seq_fi
 			seq_printf(m, "%5d  ", i);
 			seq_printf(m, "0x%05lx  ", virq_to_hw(i));
 
-			if (desc->chip && desc->chip->typename)
-				p = desc->chip->typename;
+			if (desc->chip && desc->chip->name)
+				p = desc->chip->name;
 			else
 				p = none;
 			seq_printf(m, "%-15s  ", p);
Index: linux-2.6-tip/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
+++ linux-2.6-tip/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
@@ -79,7 +79,7 @@ cpld_unmask_irq(unsigned int irq)
 }
 
 static struct irq_chip cpld_pic = {
-	.typename = " CPLD PIC ",
+	.name = " CPLD PIC ",
 	.mask = cpld_mask_irq,
 	.ack = cpld_mask_irq,
 	.unmask = cpld_unmask_irq,
Index: linux-2.6-tip/arch/powerpc/platforms/52xx/media5200.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/52xx/media5200.c
+++ linux-2.6-tip/arch/powerpc/platforms/52xx/media5200.c
@@ -74,7 +74,7 @@ static void media5200_irq_mask(unsigned 
 }
 
 static struct irq_chip media5200_irq_chip = {
-	.typename = "Media5200 FPGA",
+	.name = "Media5200 FPGA",
 	.unmask = media5200_irq_unmask,
 	.mask = media5200_irq_mask,
 	.mask_ack = media5200_irq_mask,
Index: linux-2.6-tip/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ linux-2.6-tip/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -149,7 +149,7 @@ static int mpc52xx_gpt_irq_set_type(unsi
 }
 
 static struct irq_chip mpc52xx_gpt_irq_chip = {
-	.typename = "MPC52xx GPT",
+	.name = "MPC52xx GPT",
 	.unmask = mpc52xx_gpt_irq_unmask,
 	.mask = mpc52xx_gpt_irq_mask,
 	.ack = mpc52xx_gpt_irq_ack,
Index: linux-2.6-tip/arch/powerpc/platforms/52xx/mpc52xx_pic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ linux-2.6-tip/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -220,7 +220,7 @@ static int mpc52xx_extirq_set_type(unsig
 }
 
 static struct irq_chip mpc52xx_extirq_irqchip = {
-	.typename = "MPC52xx External",
+	.name = "MPC52xx External",
 	.mask = mpc52xx_extirq_mask,
 	.unmask = mpc52xx_extirq_unmask,
 	.ack = mpc52xx_extirq_ack,
@@ -258,7 +258,7 @@ static void mpc52xx_main_unmask(unsigned
 }
 
 static struct irq_chip mpc52xx_main_irqchip = {
-	.typename = "MPC52xx Main",
+	.name = "MPC52xx Main",
 	.mask = mpc52xx_main_mask,
 	.mask_ack = mpc52xx_main_mask,
 	.unmask = mpc52xx_main_unmask,
@@ -291,7 +291,7 @@ static void mpc52xx_periph_unmask(unsign
 }
 
 static struct irq_chip mpc52xx_periph_irqchip = {
-	.typename = "MPC52xx Peripherals",
+	.name = "MPC52xx Peripherals",
 	.mask = mpc52xx_periph_mask,
 	.mask_ack = mpc52xx_periph_mask,
 	.unmask = mpc52xx_periph_unmask,
@@ -335,7 +335,7 @@ static void mpc52xx_sdma_ack(unsigned in
 }
 
 static struct irq_chip mpc52xx_sdma_irqchip = {
-	.typename = "MPC52xx SDMA",
+	.name = "MPC52xx SDMA",
 	.mask = mpc52xx_sdma_mask,
 	.unmask = mpc52xx_sdma_unmask,
 	.ack = mpc52xx_sdma_ack,
Index: linux-2.6-tip/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ linux-2.6-tip/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -69,7 +69,6 @@ static void pq2ads_pci_unmask_irq(unsign
 }
 
 static struct irq_chip pq2ads_pci_ic = {
-	.typename = "PQ2 ADS PCI",
 	.name = "PQ2 ADS PCI",
 	.end = pq2ads_pci_unmask_irq,
 	.mask = pq2ads_pci_mask_irq,
Index: linux-2.6-tip/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
+++ linux-2.6-tip/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
@@ -232,7 +232,7 @@ static int socrates_fpga_pic_set_type(un
 }
 
 static struct irq_chip socrates_fpga_pic_chip = {
-	.typename       = " FPGA-PIC ",
+	.name		= " FPGA-PIC ",
 	.ack		= socrates_fpga_pic_ack,
 	.mask           = socrates_fpga_pic_mask,
 	.mask_ack       = socrates_fpga_pic_mask_ack,
Index: linux-2.6-tip/arch/powerpc/platforms/86xx/gef_pic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/86xx/gef_pic.c
+++ linux-2.6-tip/arch/powerpc/platforms/86xx/gef_pic.c
@@ -149,7 +149,7 @@ static void gef_pic_unmask(unsigned int 
 }
 
 static struct irq_chip gef_pic_chip = {
-	.typename	= "gefp",
+	.name		= "gefp",
 	.mask		= gef_pic_mask,
 	.mask_ack	= gef_pic_mask_ack,
 	.unmask		= gef_pic_unmask,
Index: linux-2.6-tip/arch/powerpc/platforms/cell/axon_msi.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/cell/axon_msi.c
+++ linux-2.6-tip/arch/powerpc/platforms/cell/axon_msi.c
@@ -312,7 +312,7 @@ static struct irq_chip msic_irq_chip = {
 	.mask		= mask_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.shutdown	= unmask_msi_irq,
-	.typename	= "AXON-MSI",
+	.name		= "AXON-MSI",
 };
 
 static int msic_host_map(struct irq_host *h, unsigned int virq,
Index: linux-2.6-tip/arch/powerpc/platforms/cell/beat_interrupt.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/cell/beat_interrupt.c
+++ linux-2.6-tip/arch/powerpc/platforms/cell/beat_interrupt.c
@@ -110,7 +110,7 @@ static void beatic_end_irq(unsigned int 
 }
 
 static struct irq_chip beatic_pic = {
-	.typename = " CELL-BEAT ",
+	.name = " CELL-BEAT ",
 	.unmask = beatic_unmask_irq,
 	.mask = beatic_mask_irq,
 	.eoi = beatic_end_irq,
Index: linux-2.6-tip/arch/powerpc/platforms/cell/interrupt.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/cell/interrupt.c
+++ linux-2.6-tip/arch/powerpc/platforms/cell/interrupt.c
@@ -88,7 +88,7 @@ static void iic_eoi(unsigned int irq)
 }
 
 static struct irq_chip iic_chip = {
-	.typename = " CELL-IIC ",
+	.name = " CELL-IIC ",
 	.mask = iic_mask,
 	.unmask = iic_unmask,
 	.eoi = iic_eoi,
@@ -133,7 +133,7 @@ static void iic_ioexc_cascade(unsigned i
 
 
 static struct irq_chip iic_ioexc_chip = {
-	.typename = " CELL-IOEX",
+	.name = " CELL-IOEX",
 	.mask = iic_mask,
 	.unmask = iic_unmask,
 	.eoi = iic_ioexc_eoi,
Index: linux-2.6-tip/arch/powerpc/platforms/cell/spider-pic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/cell/spider-pic.c
+++ linux-2.6-tip/arch/powerpc/platforms/cell/spider-pic.c
@@ -168,7 +168,7 @@ static int spider_set_irq_type(unsigned 
 }
 
 static struct irq_chip spider_pic = {
-	.typename = " SPIDER   ",
+	.name = " SPIDER   ",
 	.unmask = spider_unmask_irq,
 	.mask = spider_mask_irq,
 	.ack = spider_ack_irq,
Index: linux-2.6-tip/arch/powerpc/platforms/iseries/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/iseries/irq.c
+++ linux-2.6-tip/arch/powerpc/platforms/iseries/irq.c
@@ -273,7 +273,7 @@ static void iseries_end_IRQ(unsigned int
 }
 
 static struct irq_chip iseries_pic = {
-	.typename	= "iSeries irq controller",
+	.name	= "iSeries irq controller",
 	.startup	= iseries_startup_IRQ,
 	.shutdown	= iseries_shutdown_IRQ,
 	.unmask		= iseries_enable_IRQ,
Index: linux-2.6-tip/arch/powerpc/platforms/powermac/pic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/powermac/pic.c
+++ linux-2.6-tip/arch/powerpc/platforms/powermac/pic.c
@@ -195,7 +195,7 @@ static int pmac_retrigger(unsigned int v
 }
 
 static struct irq_chip pmac_pic = {
-	.typename	= " PMAC-PIC ",
+	.name		= " PMAC-PIC ",
 	.startup	= pmac_startup_irq,
 	.mask		= pmac_mask_irq,
 	.ack		= pmac_ack_irq,
Index: linux-2.6-tip/arch/powerpc/platforms/ps3/interrupt.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/ps3/interrupt.c
+++ linux-2.6-tip/arch/powerpc/platforms/ps3/interrupt.c
@@ -152,7 +152,7 @@ static void ps3_chip_eoi(unsigned int vi
  */
 
 static struct irq_chip ps3_irq_chip = {
-	.typename = "ps3",
+	.name = "ps3",
 	.mask = ps3_chip_mask,
 	.unmask = ps3_chip_unmask,
 	.eoi = ps3_chip_eoi,
Index: linux-2.6-tip/arch/powerpc/platforms/pseries/xics.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6-tip/arch/powerpc/platforms/pseries/xics.c
@@ -388,7 +388,7 @@ static int xics_set_affinity(unsigned in
 }
 
 static struct irq_chip xics_pic_direct = {
-	.typename = " XICS     ",
+	.name = " XICS     ",
 	.startup = xics_startup,
 	.mask = xics_mask_irq,
 	.unmask = xics_unmask_irq,
@@ -397,7 +397,7 @@ static struct irq_chip xics_pic_direct =
 };
 
 static struct irq_chip xics_pic_lpar = {
-	.typename = " XICS     ",
+	.name = " XICS     ",
 	.startup = xics_startup,
 	.mask = xics_mask_irq,
 	.unmask = xics_unmask_irq,
Index: linux-2.6-tip/arch/powerpc/sysdev/cpm1.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/cpm1.c
+++ linux-2.6-tip/arch/powerpc/sysdev/cpm1.c
@@ -77,7 +77,7 @@ static void cpm_end_irq(unsigned int irq
 }
 
 static struct irq_chip cpm_pic = {
-	.typename = " CPM PIC ",
+	.name = " CPM PIC ",
 	.mask = cpm_mask_irq,
 	.unmask = cpm_unmask_irq,
 	.eoi = cpm_end_irq,
Index: linux-2.6-tip/arch/powerpc/sysdev/cpm2_pic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/cpm2_pic.c
+++ linux-2.6-tip/arch/powerpc/sysdev/cpm2_pic.c
@@ -182,7 +182,7 @@ static int cpm2_set_irq_type(unsigned in
 }
 
 static struct irq_chip cpm2_pic = {
-	.typename = " CPM2 SIU ",
+	.name = " CPM2 SIU ",
 	.mask = cpm2_mask_irq,
 	.unmask = cpm2_unmask_irq,
 	.ack = cpm2_ack,
Index: linux-2.6-tip/arch/powerpc/sysdev/fsl_msi.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/fsl_msi.c
+++ linux-2.6-tip/arch/powerpc/sysdev/fsl_msi.c
@@ -47,7 +47,7 @@ static struct irq_chip fsl_msi_chip = {
 	.mask		= mask_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.ack		= fsl_msi_end_irq,
-	.typename	= " FSL-MSI  ",
+	.name	= " FSL-MSI  ",
 };
 
 static int fsl_msi_host_map(struct irq_host *h, unsigned int virq,
Index: linux-2.6-tip/arch/powerpc/sysdev/i8259.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/i8259.c
+++ linux-2.6-tip/arch/powerpc/sysdev/i8259.c
@@ -135,7 +135,7 @@ static void i8259_unmask_irq(unsigned in
 }
 
 static struct irq_chip i8259_pic = {
-	.typename	= " i8259    ",
+	.name		= " i8259    ",
 	.mask		= i8259_mask_irq,
 	.disable	= i8259_mask_irq,
 	.unmask		= i8259_unmask_irq,
Index: linux-2.6-tip/arch/powerpc/sysdev/ipic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/ipic.c
+++ linux-2.6-tip/arch/powerpc/sysdev/ipic.c
@@ -660,7 +660,7 @@ static int ipic_set_irq_type(unsigned in
 
 /* level interrupts and edge interrupts have different ack operations */
 static struct irq_chip ipic_level_irq_chip = {
-	.typename	= " IPIC  ",
+	.name		= " IPIC  ",
 	.unmask		= ipic_unmask_irq,
 	.mask		= ipic_mask_irq,
 	.mask_ack	= ipic_mask_irq,
@@ -668,7 +668,7 @@ static struct irq_chip ipic_level_irq_ch
 };
 
 static struct irq_chip ipic_edge_irq_chip = {
-	.typename	= " IPIC  ",
+	.name		= " IPIC  ",
 	.unmask		= ipic_unmask_irq,
 	.mask		= ipic_mask_irq,
 	.mask_ack	= ipic_mask_irq_and_ack,
Index: linux-2.6-tip/arch/powerpc/sysdev/mpc8xx_pic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/mpc8xx_pic.c
+++ linux-2.6-tip/arch/powerpc/sysdev/mpc8xx_pic.c
@@ -94,7 +94,7 @@ static int mpc8xx_set_irq_type(unsigned 
 }
 
 static struct irq_chip mpc8xx_pic = {
-	.typename = " MPC8XX SIU ",
+	.name = " MPC8XX SIU ",
 	.unmask = mpc8xx_unmask_irq,
 	.mask = mpc8xx_mask_irq,
 	.ack = mpc8xx_ack,
Index: linux-2.6-tip/arch/powerpc/sysdev/mpic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/mpic.c
+++ linux-2.6-tip/arch/powerpc/sysdev/mpic.c
@@ -1062,19 +1062,19 @@ struct mpic * __init mpic_alloc(struct d
 	mpic->name = name;
 
 	mpic->hc_irq = mpic_irq_chip;
-	mpic->hc_irq.typename = name;
+	mpic->hc_irq.name = name;
 	if (flags & MPIC_PRIMARY)
 		mpic->hc_irq.set_affinity = mpic_set_affinity;
 #ifdef CONFIG_MPIC_U3_HT_IRQS
 	mpic->hc_ht_irq = mpic_irq_ht_chip;
-	mpic->hc_ht_irq.typename = name;
+	mpic->hc_ht_irq.name = name;
 	if (flags & MPIC_PRIMARY)
 		mpic->hc_ht_irq.set_affinity = mpic_set_affinity;
 #endif /* CONFIG_MPIC_U3_HT_IRQS */
 
 #ifdef CONFIG_SMP
 	mpic->hc_ipi = mpic_ipi_chip;
-	mpic->hc_ipi.typename = name;
+	mpic->hc_ipi.name = name;
 #endif /* CONFIG_SMP */
 
 	mpic->flags = flags;
Index: linux-2.6-tip/arch/powerpc/sysdev/mpic_pasemi_msi.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/mpic_pasemi_msi.c
+++ linux-2.6-tip/arch/powerpc/sysdev/mpic_pasemi_msi.c
@@ -60,7 +60,7 @@ static struct irq_chip mpic_pasemi_msi_c
 	.eoi		= mpic_end_irq,
 	.set_type	= mpic_set_irq_type,
 	.set_affinity	= mpic_set_affinity,
-	.typename	= "PASEMI-MSI ",
+	.name		= "PASEMI-MSI ",
 };
 
 static int pasemi_msi_check_device(struct pci_dev *pdev, int nvec, int type)
Index: linux-2.6-tip/arch/powerpc/sysdev/mpic_u3msi.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/mpic_u3msi.c
+++ linux-2.6-tip/arch/powerpc/sysdev/mpic_u3msi.c
@@ -42,7 +42,7 @@ static struct irq_chip mpic_u3msi_chip =
 	.eoi		= mpic_end_irq,
 	.set_type	= mpic_set_irq_type,
 	.set_affinity	= mpic_set_affinity,
-	.typename	= "MPIC-U3MSI",
+	.name		= "MPIC-U3MSI",
 };
 
 static u64 read_ht_magic_addr(struct pci_dev *pdev, unsigned int pos)
Index: linux-2.6-tip/arch/powerpc/sysdev/qe_lib/qe_ic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ linux-2.6-tip/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -237,7 +237,7 @@ static void qe_ic_mask_irq(unsigned int 
 }
 
 static struct irq_chip qe_ic_irq_chip = {
-	.typename = " QEIC  ",
+	.name = " QEIC  ",
 	.unmask = qe_ic_unmask_irq,
 	.mask = qe_ic_mask_irq,
 	.mask_ack = qe_ic_mask_irq,
Index: linux-2.6-tip/arch/powerpc/sysdev/tsi108_pci.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/tsi108_pci.c
+++ linux-2.6-tip/arch/powerpc/sysdev/tsi108_pci.c
@@ -376,7 +376,7 @@ static void tsi108_pci_irq_end(u_int irq
  */
 
 static struct irq_chip tsi108_pci_irq = {
-	.typename = "tsi108_PCI_int",
+	.name = "tsi108_PCI_int",
 	.mask = tsi108_pci_irq_disable,
 	.ack = tsi108_pci_irq_ack,
 	.end = tsi108_pci_irq_end,
Index: linux-2.6-tip/arch/powerpc/sysdev/uic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/uic.c
+++ linux-2.6-tip/arch/powerpc/sysdev/uic.c
@@ -177,7 +177,7 @@ static int uic_set_irq_type(unsigned int
 }
 
 static struct irq_chip uic_irq_chip = {
-	.typename	= " UIC  ",
+	.name		= " UIC  ",
 	.unmask		= uic_unmask_irq,
 	.mask		= uic_mask_irq,
  	.mask_ack	= uic_mask_ack_irq,
Index: linux-2.6-tip/arch/powerpc/sysdev/xilinx_intc.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/xilinx_intc.c
+++ linux-2.6-tip/arch/powerpc/sysdev/xilinx_intc.c
@@ -106,7 +106,7 @@ static void xilinx_intc_level_unmask(uns
 }
 
 static struct irq_chip xilinx_intc_level_irqchip = {
-	.typename = "Xilinx Level INTC",
+	.name = "Xilinx Level INTC",
 	.mask = xilinx_intc_mask,
 	.mask_ack = xilinx_intc_mask,
 	.unmask = xilinx_intc_level_unmask,
@@ -133,7 +133,7 @@ static void xilinx_intc_edge_ack(unsigne
 }
 
 static struct irq_chip xilinx_intc_edge_irqchip = {
-	.typename = "Xilinx Edge  INTC",
+	.name = "Xilinx Edge  INTC",
 	.mask = xilinx_intc_mask,
 	.unmask = xilinx_intc_edge_unmask,
 	.ack = xilinx_intc_edge_ack,
