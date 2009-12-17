Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbZLQDPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbZLQDPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 22:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbZLQDPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 22:15:44 -0500
Received: from n73.bullet.mail.sp1.yahoo.com ([98.136.44.191]:32300 "HELO
	n73.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753130AbZLQDPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 22:15:42 -0500
X-Yahoo-Newman-Id: 531888.9780.bm@omp406.mail.mud.yahoo.com
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-YMail-OSG: GbNgn0EVM1nxAGBPt6Zt6.e_yqCCbujaoG5iWJExAxZ6hZYigwQrGEYzAu0jqDJ6MYFJo61c1S7M7xKPs0CwHgqnfd7B.NieektZKTzPqxpJM5sXDCaMySGHsYhL11R7Tqc7kLNafRXjexMF_zoEfwlbIDkoOXzroCG7YnY3p5aabMbe2f9inFBo2cG.0N1EddDs7_820R01FaAD4UGDryuhfQT8T.dV48Mq0XU1TfJkrxMTScDopMWeQ68P4FEIv5MTN5F80Ug0P9K5tGSsmMaFf9oR0VNUv6_Df8VR4NDDuVTUDA4_qoDVtn3yGhC5rzXLoVZMmcnU3YTAHraL2wfY0EdDfU_iiMREKWV5JSgN8s8WgOIKlyIvOdAYtaR0EV918zacmszoTYdPk5JrjtWIJRzPyl3E9t4dDzugTo1JeSntoG3251g11B1tmETCy1cgnVwWm5J1Gw--
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: Greg Ungerer <gerg@snapgear.com>
Subject: [PATCH] m68knommu: get rid of __do_IRQ and add support for using gpio irqs.
Date: Wed, 16 Dec 2009 19:15:39 -0800
User-Agent: KMail/1.9.9
Cc: uClinux development list <uclinux-dev@uclinux.org>,
       linux-m68k <linux-m68k@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912161915.39692.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Since we now have generic irq support for m68knommu and as __do_IRQ is
supposed to go away real soon now, I added config GENERIC_HARDIRQS_NO__DO_IRQ
to m68knommu/Kconfig.  Unfortunately, that produced an unbootable kernel --
looking at the code for generic_handle_irq in linux/irq.h, the NO__DO_IRQ
version unconditionally calls desc->handle_irq, which suggests that an irq's
handle_irq isnt getting initialized in the early boot and indeed, adding an
initialization of handle_irq in init_IRQ produced a working system.

I'm not entirely satisfied with that solution as it ignores why we are getting
an irq when no handler has been setup for it, but in any case, using
set_irq_chip_and_handler in init_IRQ to initialize all the handlers is the
right thing to do (or atleast, its what all the other arches do) (and I didnt
feel like digging out the BDM pod to figure out where the mystery irq is
coming from).

Then the real reason I was digging into the irq code is to add support for
using gpio irqs on the gpios of the parts that support that.  The following
patch is against 

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

only the intc-2 gpio irqs have been tested on real hardware.

------------------------------

Get rid of __do_IRQ; use set_irq_chip_and_handler to initialize irqs.  Add
support for using gpio irqs and setting the edge on external irqs generally.

Signed-off-by: Steven King <sfking@fdwdc.com>
--

 arch/m68k/include/asm/m520xsim.h             |    3 +
 arch/m68k/include/asm/m523xsim.h             |    3 +
 arch/m68k/include/asm/m5249sim.h             |    4 +-
 arch/m68k/include/asm/m527xsim.h             |    3 +
 arch/m68knommu/Kconfig                       |    4 ++
 arch/m68knommu/platform/5272/intc.c          |   39 +++++++++++---
 arch/m68knommu/platform/68328/ints.c         |    8 +--
 arch/m68knommu/platform/68360/ints.c         |    8 +--
 arch/m68knommu/platform/coldfire/intc-2.c    |   76 ++++++++++++++++++++++++--
 arch/m68knommu/platform/coldfire/intc-simr.c |   68 ++++++++++++++++++++++--
 arch/m68knommu/platform/coldfire/intc.c      |   59 +++++++++++++++++++--
 11 files changed, 239 insertions(+), 36 deletions(-)

diff --git a/arch/m68k/include/asm/m520xsim.h b/arch/m68k/include/asm/m520xsim.h
index ed2b69b..1b6fb8c 100644
--- a/arch/m68k/include/asm/m520xsim.h
+++ b/arch/m68k/include/asm/m520xsim.h
@@ -54,9 +54,12 @@
 #define MCFSIM_SDCS0        0x000a8110	/* SDRAM Chip Select 0 Configuration */
 #define MCFSIM_SDCS1        0x000a8114	/* SDRAM Chip Select 1 Configuration */
 
+#define MCFEPORT_EPPAR			0xFC088000
 #define MCFEPORT_EPDDR			0xFC088002
+#define MCFEPORT_EPIER			0xFC088003
 #define MCFEPORT_EPDR			0xFC088004
 #define MCFEPORT_EPPDR			0xFC088005
+#define MCFEPORT_EPFR			0xFC088006
 
 #define MCFGPIO_PODR_BUSCTL		0xFC0A4000
 #define MCFGPIO_PODR_BE			0xFC0A4001
diff --git a/arch/m68k/include/asm/m523xsim.h b/arch/m68k/include/asm/m523xsim.h
index a34894c..7660277 100644
--- a/arch/m68k/include/asm/m523xsim.h
+++ b/arch/m68k/include/asm/m523xsim.h
@@ -110,9 +110,12 @@
  * EPort
  */
 
+#define MCFEPORT_EPPAR		(MCF_IPSBAR + 0x130000)
 #define MCFEPORT_EPDDR		(MCF_IPSBAR + 0x130002)
+#define MCFEPORT_EPIER		(MCF_IPSBAR + 0x130003)
 #define MCFEPORT_EPDR		(MCF_IPSBAR + 0x130004)
 #define MCFEPORT_EPPDR		(MCF_IPSBAR + 0x130005)
+#define MCFEPORT_EPFR		(MCF_IPSBAR + 0x130006)
 
 /*
  * Generic GPIO support
diff --git a/arch/m68k/include/asm/m5249sim.h b/arch/m68k/include/asm/m5249sim.h
index 14bce87..840fb4a 100644
--- a/arch/m68k/include/asm/m5249sim.h
+++ b/arch/m68k/include/asm/m5249sim.h
@@ -126,8 +126,8 @@
  * Generic GPIO support
  */
 #define MCFGPIO_PIN_MAX		64
-#define MCFGPIO_IRQ_MAX		-1
-#define MCFGPIO_IRQ_VECBASE	-1
+#define MCFGPIO_IRQ_MAX		MCFINTC2_GPIOIRQ7
+#define MCFGPIO_IRQ_VECBASE	MCFINTC2_GPIOIRQ0
 
 /****************************************************************************/
 
diff --git a/arch/m68k/include/asm/m527xsim.h b/arch/m68k/include/asm/m527xsim.h
index 453356d..81d69a8 100644
--- a/arch/m68k/include/asm/m527xsim.h
+++ b/arch/m68k/include/asm/m527xsim.h
@@ -218,9 +218,12 @@
  * EPort
  */
 
+#define MCFEPORT_EPPAR		(MCF_IPSBAR + 0x130000)
 #define MCFEPORT_EPDDR		(MCF_IPSBAR + 0x130002)
+#define MCFEPORT_EPIER		(MCF_IPSBAR + 0x130003)
 #define MCFEPORT_EPDR		(MCF_IPSBAR + 0x130004)
 #define MCFEPORT_EPPDR		(MCF_IPSBAR + 0x130005)
+#define MCFEPORT_EPFR		(MCF_IPSBAR + 0x130006)
 
 
 /*
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 064f591..63be09e 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -59,6 +59,10 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	bool
+	default y
+
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
diff --git a/arch/m68knommu/platform/5272/intc.c b/arch/m68knommu/platform/5272/intc.c
index 7081e0a..2889f7d 100644
--- a/arch/m68knommu/platform/5272/intc.c
+++ b/arch/m68knommu/platform/5272/intc.c
@@ -103,8 +103,26 @@ static void intc_irq_ack(unsigned int irq)
 
 static int intc_irq_set_type(unsigned int irq, unsigned int type)
 {
-	/* We can set the edge type here for external interrupts */
-	return 0;
+	/* set the edge type for external interrupts */
+	u32 pitr;
+
+	if ((type != IRQF_TRIGGER_RISING) || (type != IRQF_TRIGGER_FALLING))
+		return -EINVAL;
+
+	switch (irq) {
+	case MCF_IRQ_EINT1 ... MCF_IRQ_EINT4:
+	case MCF_IRQ_EINT5 ... MCF_IRQ_EINT6:
+		pitr = __raw_readl(MCFSIM_PITR);
+		if (type & IRQF_TRIGGER_RISING)
+			pitr |= 1 << (96 - irq);
+		else
+			pitr &= ~(1 << (96 - irq));
+		__raw_writel(pitr, MCFSIM_PITR);
+
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static struct irq_chip intc_irq_chip = {
@@ -128,11 +146,16 @@ void __init init_IRQ(void)
 	writel(0x88888888, MCF_MBAR + MCFSIM_ICR4);
 
 	for (irq = 0; (irq < NR_IRQS); irq++) {
-		irq_desc[irq].status = IRQ_DISABLED;
-		irq_desc[irq].action = NULL;
-		irq_desc[irq].depth = 1;
-		irq_desc[irq].chip = &intc_irq_chip;
-		intc_irq_set_type(irq, 0);
+		switch (irq) {
+		case MCF_IRQ_EINT1 ... MCF_IRQ_EINT4:
+		case MCF_IRQ_EINT5 ... MCF_IRQ_EINT6:
+			set_irq_chip_and_handler(irq, &intc_irq_chip,
+					handle_edge_irq);
+			break;
+		default:
+			set_irq_chip_and_handler(irq, &intc_irq_chip,
+					handle_level_irq);
+			break;
+		}
 	}
 }
-
diff --git a/arch/m68knommu/platform/68328/ints.c b/arch/m68knommu/platform/68328/ints.c
index b91ee85..8a6a102 100644
--- a/arch/m68knommu/platform/68328/ints.c
+++ b/arch/m68knommu/platform/68328/ints.c
@@ -178,11 +178,7 @@ void __init init_IRQ(void)
 	/* turn off all interrupts */
 	IMR = ~0;
 
-	for (i = 0; (i < NR_IRQS); i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = NULL;
-		irq_desc[i].depth = 1;
-		irq_desc[i].chip = &intc_irq_chip;
-	}
+	for (i = 0; (i < NR_IRQS); i++)
+		set_irq_chip_and_handler(i, &intc_irq_chip, handle_level_irq);
 }
 
diff --git a/arch/m68knommu/platform/68360/ints.c b/arch/m68knommu/platform/68360/ints.c
index 1143f77..9b94c52 100644
--- a/arch/m68knommu/platform/68360/ints.c
+++ b/arch/m68knommu/platform/68360/ints.c
@@ -132,11 +132,7 @@ void init_IRQ(void)
 	/* turn off all CPM interrupts */
 	pquicc->intr_cimr = 0x00000000;
 
-	for (i = 0; (i < NR_IRQS); i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = NULL;
-		irq_desc[i].depth = 1;
-		irq_desc[i].chip = &intc_irq_chip;
-	}
+	for (i = 0; (i < NR_IRQS); i++)
+		set_irq_chip_and_handler(i, &intc_irq_chip, handle_level_irq);
 }
 
diff --git a/arch/m68knommu/platform/coldfire/intc-2.c b/arch/m68knommu/platform/coldfire/intc-2.c
index 5598c8b..2863285 100644
--- a/arch/m68knommu/platform/coldfire/intc-2.c
+++ b/arch/m68knommu/platform/coldfire/intc-2.c
@@ -39,6 +39,15 @@ static void intc_irq_mask(unsigned int irq)
 
 		val = __raw_readl(imraddr);
 		__raw_writel(val | imrbit, imraddr);
+
+		/* only on eport */
+		if (irq >= MCFGPIO_IRQ_VECBASE ||
+				irq < (MCFGPIO_IRQ_VECBASE + MCFGPIO_IRQ_MAX)) {
+
+			u8 epier = __raw_readb(MCFEPORT_EPIER);
+			epier &= ~(1 << (irq - MCFGPIO_IRQ_VECBASE));
+			__raw_writeb(epier, MCFEPORT_EPIER);
+		}
 	}
 }
 
@@ -64,13 +73,72 @@ static void intc_irq_unmask(unsigned int irq)
 
 		val = __raw_readl(imraddr);
 		__raw_writel(val & ~imrbit, imraddr);
+
+		/* only on eport */
+		if (irq >= MCFGPIO_IRQ_VECBASE ||
+				irq < (MCFGPIO_IRQ_VECBASE + MCFGPIO_IRQ_MAX)) {
+
+			u8 epier = __raw_readb(MCFEPORT_EPIER);
+			epier |= 1 << (irq - MCFGPIO_IRQ_VECBASE);
+			__raw_writeb(epier, MCFEPORT_EPIER);
+		}
+	}
+}
+
+static void intc_irq_ack(unsigned int irq)
+{
+	/* only on eport */
+	if (irq >= MCFGPIO_IRQ_VECBASE ||
+			irq < (MCFGPIO_IRQ_VECBASE + MCFGPIO_IRQ_MAX)) {
+		u8 epfr = __raw_readb(MCFEPORT_EPFR);
+		epfr |= 1 << (irq - MCFGPIO_IRQ_VECBASE);
+		__raw_writeb(epfr, MCFEPORT_EPFR);
 	}
 }
 
+static int intc_irq_set_type(unsigned int irq, unsigned int flow_type)
+{
+	unsigned shift;
+	u16 eppar;
+
+	/* only on eport */
+	if (irq < MCFGPIO_IRQ_VECBASE ||
+			irq >= (MCFGPIO_IRQ_VECBASE + MCFGPIO_IRQ_MAX))
+		return -EINVAL;
+
+	/* we only support TRIGGER_LOW or either (or both) RISING and FALLING */
+	if ((flow_type & IRQF_TRIGGER_HIGH) ||
+			((flow_type & IRQF_TRIGGER_LOW) &&
+			 (flow_type & (IRQF_TRIGGER_RISING |
+				       IRQF_TRIGGER_FALLING))))
+		return -EINVAL;
+
+	shift = (irq - MCFGPIO_IRQ_VECBASE) * 2;
+
+	/* default to TRIGGER_LOW */
+	eppar = 0;
+	if (flow_type & IRQF_TRIGGER_RISING)
+		eppar |= (0x01 << shift);
+	if (flow_type & IRQF_TRIGGER_FALLING)
+		eppar |= (0x02 << shift);
+
+	if (eppar)
+		set_irq_handler(irq, handle_edge_irq);
+	else
+		set_irq_handler(irq, handle_level_irq);
+
+	eppar |= (__raw_readw(MCFEPORT_EPPAR) & ~(0x3 << shift));
+	__raw_writew(eppar, MCFEPORT_EPPAR);
+
+	return 0;
+}
+
 static struct irq_chip intc_irq_chip = {
 	.name		= "CF-INTC",
 	.mask		= intc_irq_mask,
 	.unmask		= intc_irq_unmask,
+	.ack		= intc_irq_ack,
+	.set_type	= intc_irq_set_type,
 };
 
 void __init init_IRQ(void)
@@ -83,11 +151,7 @@ void __init init_IRQ(void)
 	__raw_writel(0x1, MCF_IPSBAR + MCFICM_INTC0 + MCFINTC_IMRL);
 	__raw_writel(0x1, MCF_IPSBAR + MCFICM_INTC1 + MCFINTC_IMRL);
 
-	for (irq = 0; (irq < NR_IRQS); irq++) {
-		irq_desc[irq].status = IRQ_DISABLED;
-		irq_desc[irq].action = NULL;
-		irq_desc[irq].depth = 1;
-		irq_desc[irq].chip = &intc_irq_chip;
-	}
+	for (irq = 0; (irq < NR_IRQS); irq++)
+		set_irq_chip_and_handler(irq, &intc_irq_chip, handle_level_irq);
 }
 
diff --git a/arch/m68knommu/platform/coldfire/intc-simr.c b/arch/m68knommu/platform/coldfire/intc-simr.c
index 1b01e79..cc5473f 100644
--- a/arch/m68knommu/platform/coldfire/intc-simr.c
+++ b/arch/m68knommu/platform/coldfire/intc-simr.c
@@ -26,6 +26,15 @@ static void intc_irq_mask(unsigned int irq)
 		else if ((irq < MCFINT_VECBASE + 128) && MCFINTC1_SIMR)
 			__raw_writeb(irq - MCFINT_VECBASE - 64, MCFINTC1_SIMR);
 	}
+
+	/* only on eport */
+	if (irq >= MCFGPIO_IRQ_VECBASE ||
+			irq < (MCFGPIO_IRQ_VECBASE + MCFGPIO_IRQ_MAX)) {
+
+		u8 epier = __raw_readb(MCFEPORT_EPIER);
+		epier &= ~(1 << (irq - MCFGPIO_IRQ_VECBASE));
+		__raw_writeb(epier, MCFEPORT_EPIER);
+	}
 }
 
 static void intc_irq_unmask(unsigned int irq)
@@ -36,10 +45,63 @@ static void intc_irq_unmask(unsigned int irq)
 		else if ((irq < MCFINT_VECBASE + 128) && MCFINTC1_CIMR)
 			__raw_writeb(irq - MCFINT_VECBASE - 64, MCFINTC1_CIMR);
 	}
+
+	/* only on eport */
+	if (irq >= MCFGPIO_IRQ_VECBASE ||
+			irq < (MCFGPIO_IRQ_VECBASE + MCFGPIO_IRQ_MAX)) {
+
+		u8 epier = __raw_readb(MCFEPORT_EPIER);
+		epier |= 1 << (irq - MCFGPIO_IRQ_VECBASE);
+		__raw_writeb(epier, MCFEPORT_EPIER);
+	}
+}
+
+static void intc_irq_ack(unsigned int irq)
+{
+	/* only on eport */
+	if (irq >= MCFGPIO_IRQ_VECBASE ||
+			irq < (MCFGPIO_IRQ_VECBASE + MCFGPIO_IRQ_MAX)) {
+		u8 epfr = __raw_readb(MCFEPORT_EPFR);
+		epfr |= 1 << (irq - MCFGPIO_IRQ_VECBASE);
+		__raw_writeb(epfr, MCFEPORT_EPFR);
+	}
 }
 
 static int intc_irq_set_type(unsigned int irq, unsigned int type)
 {
+	unsigned shift;
+	u16 eppar;
+
+	/* only on eport */
+	if (irq < MCFGPIO_IRQ_VECBASE ||
+			irq >= (MCFGPIO_IRQ_VECBASE + MCFGPIO_IRQ_MAX))
+		return -EINVAL;
+
+	/* we only support TRIGGER_LOW or either (or both) RISING and FALLING */
+	if ((type & IRQF_TRIGGER_HIGH) ||
+			((type & IRQF_TRIGGER_LOW) &&
+			 (type & (IRQF_TRIGGER_RISING |
+				       IRQF_TRIGGER_FALLING))))
+		return -EINVAL;
+
+	shift = (irq - MCFGPIO_IRQ_VECBASE) * 2;
+
+	/* default to TRIGGER_LOW */
+	eppar = 0;
+	if (type & IRQF_TRIGGER_RISING)
+		eppar |= (0x01 << shift);
+	if (type & IRQF_TRIGGER_FALLING)
+		eppar |= (0x02 << shift);
+
+	if (eppar)
+		set_irq_handler(irq, handle_edge_irq);
+	else
+		set_irq_handler(irq, handle_level_irq);
+
+	eppar |= (__raw_readw(MCFEPORT_EPPAR) & ~(0x3 << shift));
+	__raw_writew(eppar, MCFEPORT_EPPAR);
+
+
 	if (irq >= MCFINT_VECBASE) {
 		if (irq < MCFINT_VECBASE + 64)
 			__raw_writeb(5, MCFINTC0_ICR0 + irq - MCFINT_VECBASE);
@@ -53,6 +115,7 @@ static struct irq_chip intc_irq_chip = {
 	.name		= "CF-INTC",
 	.mask		= intc_irq_mask,
 	.unmask		= intc_irq_unmask,
+	.ack		= intc_irq_ack,
 	.set_type	= intc_irq_set_type,
 };
 
@@ -68,10 +131,7 @@ void __init init_IRQ(void)
 		__raw_writeb(0xff, MCFINTC1_SIMR);
 
 	for (irq = 0; (irq < NR_IRQS); irq++) {
-		irq_desc[irq].status = IRQ_DISABLED;
-		irq_desc[irq].action = NULL;
-		irq_desc[irq].depth = 1;
-		irq_desc[irq].chip = &intc_irq_chip;
+		set_irq_chip_and_handler(irq, &intc_irq_chip, handle_level_irq);
 		intc_irq_set_type(irq, 0);
 	}
 }
diff --git a/arch/m68knommu/platform/coldfire/intc.c b/arch/m68knommu/platform/coldfire/intc.c
index a4560c8..ad392a5 100644
--- a/arch/m68knommu/platform/coldfire/intc.c
+++ b/arch/m68knommu/platform/coldfire/intc.c
@@ -115,16 +115,69 @@ static void intc_irq_mask(unsigned int irq)
 {
 	if (mcf_irq2imr[irq])
 		mcf_setimr(mcf_irq2imr[irq]);
+
+#if defined MCFINTC2_GPIOIRQ0
+	if (irq >= MCFINTC2_GPIOIRQ0 && irq <= MCFINTC2_GPIOIRQ7) {
+		u32 gpiointenable = __raw_readl(MCFSIM2_GPIOINTENABLE);
+
+		gpiointenable &= ~(0x101 << (irq - MCFINTC2_GPIOIRQ0));
+		__raw_writel(gpiointenable, MCFSIM2_GPIOINTENABLE);
+	}
+#endif
 }
 
 static void intc_irq_unmask(unsigned int irq)
 {
 	if (mcf_irq2imr[irq])
 		mcf_clrimr(mcf_irq2imr[irq]);
+
+#if defined MCFINTC2_GPIOIRQ0
+	if (irq >= MCFINTC2_GPIOIRQ0 && irq <= MCFINTC2_GPIOIRQ7) {
+		struct irq_desc *desc = irq_to_desc(irq);
+		u32 gpiointenable = __raw_readl(MCFSIM2_GPIOINTENABLE);
+
+		if (desc->status & IRQF_TRIGGER_RISING)
+			gpiointenable |= 0x0001 << (irq - MCFINTC2_GPIOIRQ0);
+		if (desc->status & IRQF_TRIGGER_FALLING)
+			gpiointenable |= 0x0100 << (irq - MCFINTC2_GPIOIRQ0);
+		__raw_writel(gpiointenable, MCFSIM2_GPIOINTENABLE);
+	}
+#endif
+}
+
+static void intc_irq_ack(unsigned int irq)
+{
+#if defined MCFINTC2_GPIOIRQ0
+	if (irq >= MCFINTC2_GPIOIRQ0 && irq <= MCFINTC2_GPIOIRQ7) {
+		u32 gpiointclear = __raw_readl(MCFSIM2_GPIOINTCLEAR);
+
+		gpiointclear |= 0x0101 << (irq - MCFINTC2_GPIOIRQ0);
+		__raw_writel(gpiointclear, MCFSIM2_GPIOINTCLEAR);
+	}
+#endif
 }
 
 static int intc_irq_set_type(unsigned int irq, unsigned int type)
 {
+#if defined MCFINTC2_GPIOIRQ0
+	u32 gpiointenable;
+
+	if (type & ~(IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))
+		return -EINVAL;
+
+	if ((irq < MCFINTC2_GPIOIRQ0) || (irq > MCFINTC2_GPIOIRQ7))
+		return -EINVAL;
+
+	/* enable rising or falling or both */
+	gpiointenable = __raw_readl(MCFSIM2_GPIOINTENABLE);
+	gpiointenable &= ~(0x101 << (irq - MCFINTC2_GPIOIRQ0));
+	if (type & IRQF_TRIGGER_RISING)
+		gpiointenable |= 0x0001 << (irq - MCFINTC2_GPIOIRQ0);
+	if (type & IRQF_TRIGGER_FALLING)
+		gpiointenable |= 0x0100 << (irq - MCFINTC2_GPIOIRQ0);
+	__raw_writel(gpiointenable, MCFSIM2_GPIOINTENABLE);
+#endif
+
 	return 0;
 }
 
@@ -132,6 +185,7 @@ static struct irq_chip intc_irq_chip = {
 	.name		= "CF-INTC",
 	.mask		= intc_irq_mask,
 	.unmask		= intc_irq_unmask,
+	.ack		= intc_irq_ack,
 	.set_type	= intc_irq_set_type,
 };
 
@@ -143,10 +197,7 @@ void __init init_IRQ(void)
 	mcf_maskimr(0xffffffff);
 
 	for (irq = 0; (irq < NR_IRQS); irq++) {
-		irq_desc[irq].status = IRQ_DISABLED;
-		irq_desc[irq].action = NULL;
-		irq_desc[irq].depth = 1;
-		irq_desc[irq].chip = &intc_irq_chip;
+		set_irq_chip_and_handler(irq, &intc_irq_chip, handle_level_irq);
 		intc_irq_set_type(irq, 0);
 	}
 }

