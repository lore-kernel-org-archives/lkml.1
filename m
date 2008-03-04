Return-Path: <linux-kernel-owner+w=401wt.eu-S1764769AbYCDNIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764769AbYCDNIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764208AbYCDNIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:08:15 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:55583 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761190AbYCDNIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:08:12 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: akpm@linux-foundation.org
Cc: LKML <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: [PATCH] atmel_tc library
Date: Tue,  4 Mar 2008 14:07:40 +0100
Message-Id: <1204636061-6275-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

Create <linux/atmel_tc.h> based on <asm-arm/arch-at91/at91-tc.h> and the
at91sam9263 and at32ap7000 datasheets.  Most AT91 and AT32 SOCs have one
or two of these TC blocks, which include three 16-bit timers that can be
interconnected in various ways.

These TC blocks can be used for external interfacing (such as PWM and
measurement), or used as somewhat quirky sixteen-bit timers.

Changes relative to the original version:
  * Drop unneeded inclusion of <linux/mutex.h>
  * Support an arbitrary number of TC blocks
  * Return a struct with information about a TC block from
    atmel_tc_alloc() instead of using a combination of return values
    and "out" parameters.
  * ioremap() the I/O registers on allocation
  * Look up clocks and irqs for all channels
  * Add "name" parameter to atmel_tc_alloc() and use this when
    requesting the iomem resource.
  * Check if the platform provided the necessary resources at probe()
    time instead of when the TCB is allocated.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
---
This patch is meant to replace atmel_tc-library.patch

 drivers/misc/Kconfig       |    8 ++
 drivers/misc/Makefile      |    1 +
 drivers/misc/atmel_tclib.c |  161 ++++++++++++++++++++++++++++
 include/linux/atmel_tc.h   |  252 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 422 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/atmel_tclib.c
 create mode 100644 include/linux/atmel_tc.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 982e27b..b3ba681 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -22,6 +22,14 @@ config ATMEL_PWM
 	  purposes including software controlled power-efficent backlights
 	  on LCD displays, motor control, and waveform generation.
 
+config ATMEL_TCLIB
+	bool "Atmel AT32/AT91 Timer/Counter Library"
+	depends on (AVR32 || ARCH_AT91)
+	help
+	  Select this if you want a library to allocate the Timer/Counter
+	  blocks found on many Atmel processors.  This facilitates using
+	  these blocks by different drivers despite processor differences.
+
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
 	depends on X86 && PCI && INPUT && EXPERIMENTAL
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 3b12f5d..c975028 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_ACER_WMI)     += acer-wmi.o
 obj-$(CONFIG_ASUS_LAPTOP)     += asus-laptop.o
 obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
+obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
 obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
 obj-$(CONFIG_LKDTM)		+= lkdtm.o
 obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
diff --git a/drivers/misc/atmel_tclib.c b/drivers/misc/atmel_tclib.c
new file mode 100644
index 0000000..05dc8a3
--- /dev/null
+++ b/drivers/misc/atmel_tclib.c
@@ -0,0 +1,161 @@
+#include <linux/atmel_tc.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+
+/* Number of bytes to reserve for the iomem resource */
+#define ATMEL_TC_IOMEM_SIZE	256
+
+
+/*
+ * This is a thin library to solve the problem of how to portably allocate
+ * one of the TC blocks.  For simplicity, it doesn't currently expect to
+ * share individual timers between different drivers.
+ */
+
+#if defined(CONFIG_AVR32)
+/* AVR32 has these divide PBB */
+const u8 atmel_tc_divisors[5] = { 0, 4, 8, 16, 32, };
+EXPORT_SYMBOL(atmel_tc_divisors);
+
+#elif defined(CONFIG_ARCH_AT91)
+/* AT91 has these divide MCK */
+const u8 atmel_tc_divisors[5] = { 2, 8, 32, 128, 0, };
+EXPORT_SYMBOL(atmel_tc_divisors);
+
+#endif
+
+static DEFINE_SPINLOCK(tc_list_lock);
+static LIST_HEAD(tc_list);
+
+/**
+ * atmel_tc_alloc - allocate a specified TC block
+ * @block: which block to allocate
+ * @name: name to be associated with the iomem resource
+ *
+ * Caller allocates a block.  If it is available, a pointer to a
+ * pre-initialized struct atmel_tc is returned. The caller can access
+ * the registers directly through the "regs" field.
+ */
+struct atmel_tc *atmel_tc_alloc(unsigned block, const char *name)
+{
+	struct atmel_tc		*tc;
+	struct platform_device	*pdev = NULL;
+	struct resource		*r;
+
+	spin_lock(&tc_list_lock);
+	list_for_each_entry(tc, &tc_list, node) {
+		if (tc->pdev->id == block) {
+			pdev = tc->pdev;
+			break;
+		}
+	}
+
+	if (!pdev || tc->iomem)
+		goto fail;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	r = request_mem_region(r->start, ATMEL_TC_IOMEM_SIZE, name);
+	if (!r)
+		goto fail;
+
+	tc->regs = ioremap(r->start, ATMEL_TC_IOMEM_SIZE);
+	if (!tc->regs)
+		goto fail_ioremap;
+
+	tc->iomem = r;
+
+out:
+	spin_unlock(&tc_list_lock);
+	return tc;
+
+fail_ioremap:
+	release_resource(r);
+fail:
+	tc = NULL;
+	goto out;
+}
+EXPORT_SYMBOL_GPL(atmel_tc_alloc);
+
+/**
+ * atmel_tc_free - release a specified TC block
+ * @tc: Timer/counter block that was returned by atmel_tc_alloc()
+ *
+ * This reverses the effect of atmel_tc_alloc(), unmapping the I/O
+ * registers, invalidating the resource returned by that routine and
+ * making the TC available to other drivers.
+ */
+void atmel_tc_free(struct atmel_tc *tc)
+{
+	spin_lock(&tc_list_lock);
+	if (tc->regs) {
+		iounmap(tc->regs);
+		release_resource(tc->iomem);
+		tc->regs = NULL;
+		tc->iomem = NULL;
+	}
+	spin_unlock(&tc_list_lock);
+}
+EXPORT_SYMBOL_GPL(atmel_tc_free);
+
+static int __init tc_probe(struct platform_device *pdev)
+{
+	struct atmel_tc *tc;
+	struct clk	*clk;
+	int		irq;
+
+	if (!platform_get_resource(pdev, IORESOURCE_MEM, 0))
+		return -EINVAL;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return -EINVAL;
+
+	tc = kzalloc(sizeof(struct atmel_tc), GFP_KERNEL);
+	if (!tc)
+		return -ENOMEM;
+
+	tc->pdev = pdev;
+
+	clk = clk_get(&pdev->dev, "t0_clk");
+	if (IS_ERR(clk)) {
+		kfree(tc);
+		return -EINVAL;
+	}
+
+	tc->clk[0] = clk;
+	tc->clk[1] = clk_get(&pdev->dev, "t1_clk");
+	if (IS_ERR(tc->clk[1]))
+		tc->clk[1] = clk;
+	tc->clk[2] = clk_get(&pdev->dev, "t2_clk");
+	if (IS_ERR(tc->clk[2]))
+		tc->clk[2] = clk;
+
+	tc->irq[0] = irq;
+	tc->irq[1] = platform_get_irq(pdev, 1);
+	if (tc->irq[1] < 0)
+		tc->irq[1] = irq;
+	tc->irq[2] = platform_get_irq(pdev, 2);
+	if (tc->irq[2] < 0)
+		tc->irq[2] = irq;
+
+	spin_lock(&tc_list_lock);
+	list_add_tail(&tc->node, &tc_list);
+	spin_unlock(&tc_list_lock);
+
+	return 0;
+}
+
+static struct platform_driver tc_driver = {
+	.driver.name	= "atmel_tcb",
+};
+
+static int __init tc_init(void)
+{
+	return platform_driver_probe(&tc_driver, tc_probe);
+}
+arch_initcall(tc_init);
diff --git a/include/linux/atmel_tc.h b/include/linux/atmel_tc.h
new file mode 100644
index 0000000..53ba65e
--- /dev/null
+++ b/include/linux/atmel_tc.h
@@ -0,0 +1,252 @@
+/*
+ * Timer/Counter Unit (TC) registers.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef ATMEL_TC_H
+#define ATMEL_TC_H
+
+#include <linux/compiler.h>
+#include <linux/list.h>
+
+/*
+ * Many 32-bit Atmel SOCs include one or more TC blocks, each of which holds
+ * three general-purpose 16-bit timers.  These timers share one register bank.
+ * Depending on the SOC, each timer may have its own clock and IRQ, or those
+ * may be shared by the whole TC block.
+ *
+ * These TC blocks may have up to nine external pins:  TCLK0..2 signals for
+ * clocks or clock gates, and per-timer TIOA and TIOB signals used for PWM
+ * or triggering.  Those pins need to be set up for use with the TC block,
+ * else they will be used as GPIOs or for a different controller.
+ *
+ * Although we expect each TC block to have a platform_device node, those
+ * nodes are not what drivers bind to.  Instead, they ask for a specific
+ * TC block, by number ... which is a common approach on systems with many
+ * timers.  Then they use clk_get() and platform_get_irq() to get clock and
+ * IRQ resources.
+ */
+
+struct clk;
+
+/**
+ * struct atmel_tc - information about a Timer/Counter Block
+ * @pdev: physical device
+ * @iomem: resource associated with the I/O register
+ * @regs: mapping through which the I/O registers can be accessed
+ * @irq: irq for each of the three channels
+ * @clk: internal clock source for each of the three channels
+ * @node: list node, for tclib internal use
+ *
+ * On some platforms, each TC channel has its own clocks and IRQs,
+ * while on others, all TC channels share the same clock and IRQ.
+ * Drivers should clk_enable() all the clocks they need even though
+ * all the entries in @clk may point to the same physical clock.
+ * Likewise, drivers should request irqs independently for each
+ * channel, but they must use IRQF_SHARED in case some of the entries
+ * in @irq are actually the same IRQ.
+ */
+struct atmel_tc {
+	struct platform_device	*pdev;
+	struct resource		*iomem;
+	void __iomem		*regs;
+	int			irq[3];
+	struct clk		*clk[3];
+	struct list_head	node;
+};
+
+extern struct atmel_tc *atmel_tc_alloc(unsigned block, const char *name);
+extern void atmel_tc_free(struct atmel_tc *tc);
+
+/* platform-specific ATMEL_TC_TIMER_CLOCKx divisors (0 means 32KiHz) */
+extern const u8 atmel_tc_divisors[5];
+
+
+/*
+ * Two registers have block-wide controls.  These are: configuring the three
+ * "external" clocks (or event sources) used by the timer channels; and
+ * synchronizing the timers by resetting them all at once.
+ *
+ * "External" can mean "external to chip" using the TCLK0, TCLK1, or TCLK2
+ * signals.  Or, it can mean "external to timer", using the TIOA output from
+ * one of the other two timers that's being run in waveform mode.
+ */
+
+#define ATMEL_TC_BCR	0xc0		/* TC Block Control Register */
+#define     ATMEL_TC_SYNC	(1 << 0)	/* synchronize timers */
+
+#define ATMEL_TC_BMR	0xc4		/* TC Block Mode Register */
+#define     ATMEL_TC_TC0XC0S	(3 << 0)	/* external clock 0 source */
+#define        ATMEL_TC_TC0XC0S_TCLK0	(0 << 0)
+#define        ATMEL_TC_TC0XC0S_NONE	(1 << 0)
+#define        ATMEL_TC_TC0XC0S_TIOA1	(2 << 0)
+#define        ATMEL_TC_TC0XC0S_TIOA2	(3 << 0)
+#define     ATMEL_TC_TC1XC1S	(3 << 2)	/* external clock 1 source */
+#define        ATMEL_TC_TC1XC1S_TCLK1	(0 << 2)
+#define        ATMEL_TC_TC1XC1S_NONE	(1 << 2)
+#define        ATMEL_TC_TC1XC1S_TIOA0	(2 << 2)
+#define        ATMEL_TC_TC1XC1S_TIOA2	(3 << 2)
+#define     ATMEL_TC_TC2XC2S	(3 << 4)	/* external clock 2 source */
+#define        ATMEL_TC_TC2XC2S_TCLK2	(0 << 4)
+#define        ATMEL_TC_TC2XC2S_NONE	(1 << 4)
+#define        ATMEL_TC_TC2XC2S_TIOA0	(2 << 4)
+#define        ATMEL_TC_TC2XC2S_TIOA1	(3 << 4)
+
+
+/*
+ * Each TC block has three "channels", each with one counter and controls.
+ *
+ * Note that the semantics of ATMEL_TC_TIMER_CLOCKx (input clock selection
+ * when it's not "external") is silicon-specific.  AT91 platforms use one
+ * set of definitions; AVR32 platforms use a different set.  Don't hard-wire
+ * such knowledge into your code, use the global "atmel_tc_divisors" ...
+ * where index N is the divisor for clock N+1, else zero to indicate it uses
+ * the 32 KiHz clock.
+ *
+ * The timers can be chained in various ways, and operated in "waveform"
+ * generation mode (including PWM) or "capture" mode (to time events).  In
+ * both modes, behavior can be configured in many ways.
+ *
+ * Each timer has two I/O pins, TIOA and TIOB.  Waveform mode uses TIOA as a
+ * PWM output, and TIOB as either another PWM or as a trigger.  Capture mode
+ * uses them only as inputs.
+ */
+#define ATMEL_TC_CHAN(idx)	((idx)*0x40)
+#define ATMEL_TC_REG(idx, reg)	(ATMEL_TC_CHAN(idx) + ATMEL_TC_ ## reg)
+
+#define ATMEL_TC_CCR	0x00		/* Channel Control Register */
+#define     ATMEL_TC_CLKEN	(1 << 0)	/* clock enable */
+#define     ATMEL_TC_CLKDIS	(1 << 1)	/* clock disable */
+#define     ATMEL_TC_SWTRG	(1 << 2)	/* software trigger */
+
+#define ATMEL_TC_CMR	0x04		/* Channel Mode Register */
+
+/* Both modes share some CMR bits */
+#define     ATMEL_TC_TCCLKS	(7 << 0)	/* clock source */
+#define        ATMEL_TC_TIMER_CLOCK1	(0 << 0)
+#define        ATMEL_TC_TIMER_CLOCK2	(1 << 0)
+#define        ATMEL_TC_TIMER_CLOCK3	(2 << 0)
+#define        ATMEL_TC_TIMER_CLOCK4	(3 << 0)
+#define        ATMEL_TC_TIMER_CLOCK5	(4 << 0)
+#define        ATMEL_TC_XC0		(5 << 0)
+#define        ATMEL_TC_XC1		(6 << 0)
+#define        ATMEL_TC_XC2		(7 << 0)
+#define     ATMEL_TC_CLKI	(1 << 3)	/* clock invert */
+#define     ATMEL_TC_BURST	(3 << 4)	/* clock gating */
+#define        ATMEL_TC_GATE_NONE	(0 << 4)
+#define        ATMEL_TC_GATE_XC0	(1 << 4)
+#define        ATMEL_TC_GATE_XC1	(2 << 4)
+#define        ATMEL_TC_GATE_XC2	(3 << 4)
+#define     ATMEL_TC_WAVE	(1 << 15)	/* true = Waveform mode */
+
+/* CAPTURE mode CMR bits */
+#define     ATMEL_TC_LDBSTOP	(1 << 6)	/* counter stops on RB load */
+#define     ATMEL_TC_LDBDIS	(1 << 7)	/* counter disable on RB load */
+#define     ATMEL_TC_ETRGEDG	(3 << 8)	/* external trigger edge */
+#define        ATMEL_TC_ETRGEDG_NONE	(0 << 8)
+#define        ATMEL_TC_ETRGEDG_RISING	(1 << 8)
+#define        ATMEL_TC_ETRGEDG_FALLING	(2 << 8)
+#define        ATMEL_TC_ETRGEDG_BOTH	(3 << 8)
+#define     ATMEL_TC_ABETRG	(1 << 10)	/* external trigger is TIOA? */
+#define     ATMEL_TC_CPCTRG	(1 << 14)	/* RC compare trigger enable */
+#define     ATMEL_TC_LDRA	(3 << 16)	/* RA loading edge (of TIOA) */
+#define        ATMEL_TC_LDRA_NONE	(0 << 16)
+#define        ATMEL_TC_LDRA_RISING	(1 << 16)
+#define        ATMEL_TC_LDRA_FALLING	(2 << 16)
+#define        ATMEL_TC_LDRA_BOTH	(3 << 16)
+#define     ATMEL_TC_LDRB	(3 << 18)	/* RB loading edge (of TIOA) */
+#define        ATMEL_TC_LDRB_NONE	(0 << 18)
+#define        ATMEL_TC_LDRB_RISING	(1 << 18)
+#define        ATMEL_TC_LDRB_FALLING	(2 << 18)
+#define        ATMEL_TC_LDRB_BOTH	(3 << 18)
+
+/* WAVEFORM mode CMR bits */
+#define     ATMEL_TC_CPCSTOP	(1 <<  6)	/* RC compare stops counter */
+#define     ATMEL_TC_CPCDIS	(1 <<  7)	/* RC compare disables counter */
+#define     ATMEL_TC_EEVTEDG	(3 <<  8)	/* external event edge */
+#define        ATMEL_TC_EEVTEDG_NONE	(0 << 8)
+#define        ATMEL_TC_EEVTEDG_RISING	(1 << 8)
+#define        ATMEL_TC_EEVTEDG_FALLING	(2 << 8)
+#define        ATMEL_TC_EEVTEDG_BOTH	(3 << 8)
+#define     ATMEL_TC_EEVT	(3 << 10)	/* external event source */
+#define        ATMEL_TC_EEVT_TIOB	(0 << 10)
+#define        ATMEL_TC_EEVT_XC0	(1 << 10)
+#define        ATMEL_TC_EEVT_XC1	(2 << 10)
+#define        ATMEL_TC_EEVT_XC2	(3 << 10)
+#define     ATMEL_TC_ENETRG	(1 << 12)	/* external event is trigger */
+#define     ATMEL_TC_WAVESEL	(3 << 13)	/* waveform type */
+#define        ATMEL_TC_WAVESEL_UP	(0 << 13)
+#define        ATMEL_TC_WAVESEL_UPDOWN	(1 << 13)
+#define        ATMEL_TC_WAVESEL_UP_AUTO	(2 << 13)
+#define        ATMEL_TC_WAVESEL_UPDOWN_AUTO (3 << 13)
+#define     ATMEL_TC_ACPA	(3 << 16)	/* RA compare changes TIOA */
+#define        ATMEL_TC_ACPA_NONE	(0 << 16)
+#define        ATMEL_TC_ACPA_SET	(1 << 16)
+#define        ATMEL_TC_ACPA_CLEAR	(2 << 16)
+#define        ATMEL_TC_ACPA_TOGGLE	(3 << 16)
+#define     ATMEL_TC_ACPC	(3 << 18)	/* RC compare changes TIOA */
+#define        ATMEL_TC_ACPC_NONE	(0 << 18)
+#define        ATMEL_TC_ACPC_SET	(1 << 18)
+#define        ATMEL_TC_ACPC_CLEAR	(2 << 18)
+#define        ATMEL_TC_ACPC_TOGGLE	(3 << 18)
+#define     ATMEL_TC_AEEVT	(3 << 20)	/* external event changes TIOA */
+#define        ATMEL_TC_AEEVT_NONE	(0 << 20)
+#define        ATMEL_TC_AEEVT_SET	(1 << 20)
+#define        ATMEL_TC_AEEVT_CLEAR	(2 << 20)
+#define        ATMEL_TC_AEEVT_TOGGLE	(3 << 20)
+#define     ATMEL_TC_ASWTRG	(3 << 22)	/* software trigger changes TIOA */
+#define        ATMEL_TC_ASWTRG_NONE	(0 << 22)
+#define        ATMEL_TC_ASWTRG_SET	(1 << 22)
+#define        ATMEL_TC_ASWTRG_CLEAR	(2 << 22)
+#define        ATMEL_TC_ASWTRG_TOGGLE	(3 << 22)
+#define     ATMEL_TC_BCPB	(3 << 24)	/* RB compare changes TIOB */
+#define        ATMEL_TC_BCPB_NONE	(0 << 24)
+#define        ATMEL_TC_BCPB_SET	(1 << 24)
+#define        ATMEL_TC_BCPB_CLEAR	(2 << 24)
+#define        ATMEL_TC_BCPB_TOGGLE	(3 << 24)
+#define     ATMEL_TC_BCPC	(3 << 26)	/* RC compare changes TIOB */
+#define        ATMEL_TC_BCPC_NONE	(0 << 26)
+#define        ATMEL_TC_BCPC_SET	(1 << 26)
+#define        ATMEL_TC_BCPC_CLEAR	(2 << 26)
+#define        ATMEL_TC_BCPC_TOGGLE	(3 << 26)
+#define     ATMEL_TC_BEEVT	(3 << 28)	/* external event changes TIOB */
+#define        ATMEL_TC_BEEVT_NONE	(0 << 28)
+#define        ATMEL_TC_BEEVT_SET	(1 << 28)
+#define        ATMEL_TC_BEEVT_CLEAR	(2 << 28)
+#define        ATMEL_TC_BEEVT_TOGGLE	(3 << 28)
+#define     ATMEL_TC_BSWTRG	(3 << 30)	/* software trigger changes TIOB */
+#define        ATMEL_TC_BSWTRG_NONE	(0 << 30)
+#define        ATMEL_TC_BSWTRG_SET	(1 << 30)
+#define        ATMEL_TC_BSWTRG_CLEAR	(2 << 30)
+#define        ATMEL_TC_BSWTRG_TOGGLE	(3 << 30)
+
+#define ATMEL_TC_CV	0x10		/* counter Value */
+#define ATMEL_TC_RA	0x14		/* register A */
+#define ATMEL_TC_RB	0x18		/* register B */
+#define ATMEL_TC_RC	0x1c		/* register C */
+
+#define ATMEL_TC_SR	0x20		/* status (read-only) */
+/* Status-only flags */
+#define     ATMEL_TC_CLKSTA	(1 << 16)	/* clock enabled */
+#define     ATMEL_TC_MTIOA	(1 << 17)	/* TIOA mirror */
+#define     ATMEL_TC_MTIOB	(1 << 18)	/* TIOB mirror */
+
+#define ATMEL_TC_IER	0x24		/* interrupt enable (write-only) */
+#define ATMEL_TC_IDR	0x28		/* interrupt disable (write-only) */
+#define ATMEL_TC_IMR	0x2c		/* interrupt mask (read-only) */
+
+/* Status and IRQ flags */
+#define     ATMEL_TC_COVFS	(1 <<  0)	/* counter overflow */
+#define     ATMEL_TC_LOVRS	(1 <<  1)	/* load overrun */
+#define     ATMEL_TC_CPAS	(1 <<  2)	/* RA compare */
+#define     ATMEL_TC_CPBS	(1 <<  3)	/* RB compare */
+#define     ATMEL_TC_CPCS	(1 <<  4)	/* RC compare */
+#define     ATMEL_TC_LDRAS	(1 <<  5)	/* RA loading */
+#define     ATMEL_TC_LDRBS	(1 <<  6)	/* RB loading */
+#define     ATMEL_TC_ETRGS	(1 <<  7)	/* external trigger */
+
+#endif
-- 
1.5.4.1

