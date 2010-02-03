Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab0BCJuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:50:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49241 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0BCJuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:50:00 -0500
Date: Wed, 3 Feb 2010 10:49:59 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Amit Kucheria <amit.kucheria@canonical.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux@arm.linux.org.uk, Dinh.Nguyen@freescale.com,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       bryan.wu@canonical.com, valentin.longchamp@epfl.ch
Subject: Re: [PATCHv2 04/11] mxc: changes to common plat-mxc code to add
	support for i.MX5
Message-ID: <20100203094959.GN6130@pengutronix.de>
References: <cover.1265173246.git.amit.kucheria@verdurent.com> <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com> <9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com> <cover.1265173480.git.amit.kucheria@canonical.com> <ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com> <ec63e5978fd5ac5d308ede5916e648ba925818eb.1265173480.git.amit.kucheria@canonical.com> <f17812d71002022243s7b68dab0ycc19238535384d4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d71002022243s7b68dab0ycc19238535384d4f@mail.gmail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Industrial Linux Solutions Handelsregister:
	Amtsgericht Hildesheim, HRA 2686 Peiner Strasse 6-8, 31137
	Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 10:46:08 up 113 days, 22:35, 55 users,  load average: 1.88, 2.15,
	1.82
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 10:43:33PM -0800, Eric Miao wrote:
> 
> Mmm.... this should be something that we really need to get rid of, it just
> makes a single kernel for both TZIC and AVIC together impossible, if that's
> so designed by HW, I'm thinking about keeping this into plat-mxc/ is a good
> way to go ...
> 
> Sascha, you have any better idea? Provided the other file debug-macro.S in
> the same directory already seems to break the support for multiple arches?
> 

I have the following patch which I'm not sure I like better. It can
support both irq controller types and does not add overhead if only one
of them is compiled in. It might need some refactoring to fit into Amits
patch stack.

Sascha


commit c30ed01dcd257bba813b27a423bc54d5f32fc878
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Tue Nov 17 16:23:24 2009 +0100

    MXC tzic support
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
index ebe4b8c..377f792 100644
--- a/arch/arm/plat-mxc/Kconfig
+++ b/arch/arm/plat-mxc/Kconfig
@@ -84,4 +84,7 @@ config ARCH_MXC_IOMUX_V3
 config ARCH_MXC_AVIC
 	bool
 
+config ARCH_MXC_TZIC
+	bool
+
 endif
diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
index 325d9da..37ce6ec 100644
--- a/arch/arm/plat-mxc/Makefile
+++ b/arch/arm/plat-mxc/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_ARCH_MX1) += iomux-mx1-mx2.o dma-mx1-mx2.o
 obj-$(CONFIG_ARCH_MX2) += iomux-mx1-mx2.o dma-mx1-mx2.o
 obj-$(CONFIG_ARCH_MXC_IOMUX_V3) += iomux-v3.o
 obj-$(CONFIG_MXC_PWM)  += pwm.o
+obj-$(CONFIG_ARCH_MXC_TZIC) += tzic.o
 obj-$(CONFIG_ARCH_MXC_AVIC) += irq.o
diff --git a/arch/arm/plat-mxc/cpu.c b/arch/arm/plat-mxc/cpu.c
index b073b7d..d46325e 100644
--- a/arch/arm/plat-mxc/cpu.c
+++ b/arch/arm/plat-mxc/cpu.c
@@ -11,4 +11,5 @@ void mxc_set_cpu_type(unsigned int type)
 }
 
 void __iomem *mxc_irq_base;
+int mxc_irq_controller_type;
 
diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
index 286cb9b..d395763 100644
--- a/arch/arm/plat-mxc/include/mach/common.h
+++ b/arch/arm/plat-mxc/include/mach/common.h
@@ -44,5 +44,5 @@ extern void mxc_arch_reset_init(void __iomem *);
 extern void mxc91231_power_off(void);
 extern void mxc91231_arch_reset(int, const char *);
 extern void mxc91231_prepare_idle(void);
-
+extern void tzic_init_irq(void __iomem *);
 #endif
diff --git a/arch/arm/plat-mxc/include/mach/entry-macro.S b/arch/arm/plat-mxc/include/mach/entry-macro.S
index 55375df..049f740 100644
--- a/arch/arm/plat-mxc/include/mach/entry-macro.S
+++ b/arch/arm/plat-mxc/include/mach/entry-macro.S
@@ -13,6 +13,9 @@
 
 #define AVIC_NIMASK	0x04
 
+#define TZIC_HIPND0 0xd80
+
+
 	@ this macro disables fast irq (not implemented)
 	.macro	disable_fiq
 	.endm
@@ -28,10 +31,35 @@
 	.macro  arch_ret_to_user, tmp1, tmp2
 	.endm
 
-	@ this macro checks which interrupt occured
-	@ and returns its number in irqnr
-	@ and returns if an interrupt occured in irqstat
-	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
+	.macro	tzic_get_irqnr_and_base, irqnr, irqstat, base, tmp
+
+	@ Load offset & priority of the highest priority
+	@ interrupt pending.
+	ldr     \irqnr, =0
+	ldr     \irqstat, =TZIC_HIPND0
+1000:
+	ldr     \tmp,   [\base, \irqstat]
+	cmp     \tmp, #0
+	bne     1001f
+	addeq   \irqnr, \irqnr, #32
+	addeq   \irqstat, \irqstat, #4
+	cmp     \irqnr, #128
+	blo     1000b
+	b       2001f
+1001:	ldr     \irqstat, =1
+1002:	tst     \tmp, \irqstat
+	bne     2002f
+	movs    \irqstat, \irqstat, lsl #1
+	addne   \irqnr, \irqnr, #1
+	bne     1002b
+2001:
+	ldr  \irqnr, =0
+2002:
+	movs \irqnr, \irqnr
+	.endm
+
+	.macro	avic_get_irqnr_and_base, irqnr, irqstat, base, tmp
+
 	@ Load offset & priority of the highest priority
 	@ interrupt pending from AVIC_NIVECSR
 	ldr	\irqstat, [\base, #0x40]
@@ -47,6 +75,28 @@
 #endif
 	.endm
 
+	.macro get_irqnr_and_base, irqnr, irqstat, base, tmp
+#if defined CONFIG_ARCH_MXC_TZIC && defined CONFIG_ARCH_MXC_AVIC
+	ldr	\tmp, =mxc_irq_controller_type
+	ldr	\tmp, [\tmp]
+	cmp	\tmp, #MXC_IRQ_TYPE_AVIC
+	beq	3001f
+
+	tzic_get_irqnr_and_base \irqnr, \irqstat, \base, \tmp
+	b	3002f
+3001:
+	avic_get_irqnr_and_base \irqnr, \irqstat, \base, \tmp
+3002:
+
+#elif defined CONFIG_ARCH_MXC_TZIC
+	tzic_get_irqnr_and_base \irqnr, \irqstat, \base, \tmp
+#elif defined CONFIG_ARCH_MXC_AVIC
+	avic_get_irqnr_and_base \irqnr, \irqstat, \base, \tmp
+#else
+#error no tzic and no avic?
+#endif
+	.endm
+
 	@ irq priority table (not used)
 	.macro	irq_prio_table
 	.endm
diff --git a/arch/arm/plat-mxc/include/mach/mxc.h b/arch/arm/plat-mxc/include/mach/mxc.h
index b64a269..6cf0f98 100644
--- a/arch/arm/plat-mxc/include/mach/mxc.h
+++ b/arch/arm/plat-mxc/include/mach/mxc.h
@@ -129,8 +129,12 @@ extern unsigned int __mxc_cpu_type;
 #define cpu_is_mx3()	(cpu_is_mx31() || cpu_is_mx35() || cpu_is_mxc91231())
 #define cpu_is_mx2()	(cpu_is_mx21() || cpu_is_mx27())
 
+#define	MXC_IRQ_TYPE_AVIC	1
+#define	MXC_IRQ_TYPE_TZIC	2
+
 #ifndef __ASSEMBLY__
 extern void __iomem *mxc_irq_base;
+extern int mxc_irq_controller_type;
 #endif
 
 #endif /*  __ASM_ARCH_MXC_H__ */
diff --git a/arch/arm/plat-mxc/irq.c b/arch/arm/plat-mxc/irq.c
index 4855a65..3e7ac84 100644
--- a/arch/arm/plat-mxc/irq.c
+++ b/arch/arm/plat-mxc/irq.c
@@ -116,6 +116,7 @@ void __init mxc_init_irq(void __iomem *irqbase)
 	int i;
 
 	mxc_irq_base = irqbase;
+	mxc_irq_controller_type = MXC_IRQ_TYPE_AVIC;
 
 	/* put the AVIC into the reset value with
 	 * all interrupts disabled
diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
new file mode 100644
index 0000000..2d14af4
--- /dev/null
+++ b/arch/arm/plat-mxc/tzic.c
@@ -0,0 +1,104 @@
+/*
+ *  Copyright 2004-2008 Freescale Semiconductor, Inc. All Rights Reserved.
+ */
+
+/*
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <asm/irq.h>
+#include <asm/mach/irq.h>
+#include <mach/common.h>
+#include <mach/hardware.h>
+
+extern void __iomem *mxc_irq_base;
+extern int mxc_irq_controller_type;
+
+#define TZIC_INTCNTL            0x0000	/* control register */
+#define TZIC_INTTYPE            0x0004	/* Controller type register */
+#define TZIC_IMPID              0x0008	/* Distributor Implementer Identification Register */
+#define TZIC_PRIOMASK           0x000c	/* Priority Mask Reg */
+#define TZIC_SYNCCTRL           0x0010	/* Synchronizer Control register */
+#define TZIC_DSMINT             0x0014	/* DSM interrupt Holdoffregister */
+#define TZIC_INTSEC0            0x0080	/* interrupt security register 0 */
+#define TZIC_ENSET0             0x0100	/* Enable Set Register 0 */
+#define TZIC_ENCLEAR0           0x0180	/* Enable Clear Register 0 */
+#define TZIC_SRCSET0            0x0200	/* Source Set Register 0 */
+#define TZIC_SRCCLAR0           0x0280	/* Source Clear Register 0 */
+#define TZIC_PRIORITY0          0x0400	/* Priority Register 0 */
+#define TZIC_PND0               0x0d00	/* Pending Register 0 */
+#define TZIC_HIPND0             0x0d80	/* High Priority Pending Register */
+#define TZIC_WAKEUP0            0x0e00	/* Wakeup Config Register */
+#define TZIC_SWINT              0x0f00	/* Software Interrupt Rigger Register */
+#define TZIC_ID0                0x0fd0	/* Indentification Register 0 */
+
+static void mxc_mask_irq(unsigned int irq)
+{
+	int index, off;
+
+	index = irq >> 5;
+	off = irq & 0x1F;
+	__raw_writel(1 << off, mxc_irq_base + TZIC_ENCLEAR0 + (index << 2));
+}
+
+static void mxc_unmask_irq(unsigned int irq)
+{
+	int index, off;
+
+	index = irq >> 5;
+	off = irq & 0x1F;
+	__raw_writel(1 << off, mxc_irq_base + TZIC_ENSET0 + (index << 2));
+}
+
+static struct irq_chip mxc_tzic_chip = {
+	.name = "MXC_TZIC",
+	.ack = mxc_mask_irq,
+	.mask = mxc_mask_irq,
+	.unmask = mxc_unmask_irq,
+};
+
+void __init tzic_init_irq(void __iomem *base)
+{
+	int i;
+
+	mxc_irq_base = base;
+	mxc_irq_controller_type = MXC_IRQ_TYPE_TZIC;
+
+	/* put the TZIC into the reset value with
+	 * all interrupts disabled
+	 */
+	__raw_readl(mxc_irq_base + TZIC_INTCNTL);
+
+	__raw_writel(0x80010001, mxc_irq_base + TZIC_INTCNTL);
+	__raw_readl(mxc_irq_base + TZIC_INTCNTL);
+	__raw_writel(0x1f, mxc_irq_base + TZIC_PRIOMASK);
+	__raw_readl(mxc_irq_base + TZIC_PRIOMASK);
+	__raw_writel(0x02, mxc_irq_base + TZIC_SYNCCTRL);
+	__raw_readl(mxc_irq_base + TZIC_SYNCCTRL);
+
+	for (i = 0; i < 4; i++)
+		__raw_writel(0xffffffff, mxc_irq_base + TZIC_INTSEC0 + i * 4);
+
+	/* disable all interrupts */
+	for (i = 0; i < 4; i++)
+		__raw_writel(0xffffffff, mxc_irq_base + TZIC_ENCLEAR0 + i * 4);
+
+	for (i = 0; i < 128; i++) {
+		set_irq_chip(i, &mxc_tzic_chip);
+		set_irq_handler(i, handle_level_irq);
+		set_irq_flags(i, IRQF_VALID);
+	}
+
+	printk(KERN_INFO "MXC IRQ initialized\n");
+}
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
