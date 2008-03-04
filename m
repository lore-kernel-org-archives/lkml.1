Return-Path: <linux-kernel-owner+w=401wt.eu-S1764581AbYCDNHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764581AbYCDNHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758270AbYCDNHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:07:47 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63396 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758170AbYCDNHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:07:46 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: akpm@linux-foundation.org
Cc: LKML <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] atmel_tc clocksource/clockevent code
Date: Tue,  4 Mar 2008 14:07:41 +0100
Message-Id: <1204636061-6275-2-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204636061-6275-1-git-send-email-hskinnemoen@atmel.com>
References: <1204636061-6275-1-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

Clocksource and clockevent device based on the Atmel TC blocks.

The clockevent device handles both periodic and oneshot modes, so this
enables NO_HZ and high res timers on some platforms that previously
couldn't use those mechanisms.

This works on both AVR32 and AT91 chips, given relevant patches for
tclib support (always) and clockevents (or else this will only look
like a higher precision clocksource).  It's an updated and modularized
version of an AT91-only patch that has circulated for some time now.

Changes relative to the original patch:
  * Update to use new tclib API
  * Replace open-coded do-while loop using goto with a real do-while loop
  * Minor irq handler optimization: Load register base address from
    dev_id instead of a global variable.
  * Aggressively turn off clocks when the clockevent isn't being used
  * Include the clockevent code on AT91RM9200 as well. The rating is
    lower than the System Timer, so the clock will usually stay off.
  * Don't assume that the number of clocks is always equal to the
    number of irqs.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
This patch is meant to replace atmel_tc-clocksource-clockevent-code.patch

 drivers/clocksource/Makefile     |    1 +
 drivers/clocksource/tcb_clksrc.c |  305 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/Kconfig             |   25 +++
 3 files changed, 331 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clocksource/tcb_clksrc.c

diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index a522254..1525882 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -1,3 +1,4 @@
+obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+= tcb_clksrc.o
 obj-$(CONFIG_X86_CYCLONE_TIMER)	+= cyclone.o
 obj-$(CONFIG_X86_PM_TIMER)	+= acpi_pm.o
 obj-$(CONFIG_SCx200HR_TIMER)	+= scx200_hrt.o
diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
new file mode 100644
index 0000000..17facda
--- /dev/null
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -0,0 +1,305 @@
+#include <linux/init.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/atmel_tc.h>
+
+
+/*
+ * We're configured to use a specific TC block, one that's not hooked
+ * up to external hardware, to provide a time solution:
+ *
+ *   - Two channels combine to create a free-running 32 bit counter
+ *     with a base rate of 5+ MHz, packaged as a clocksource (with
+ *     resolution better than 200 nsec).
+ *
+ *   - The third channel may be used to provide a 16-bit clockevent
+ *     source, used in either periodic or oneshot mode.  This runs
+ *     at 32 KiHZ, and can handle delays of up to two seconds.
+ *
+ * A boot clocksource and clockevent source are also currently needed,
+ * unless the relevant platforms (ARM/AT91, AVR32/AT32) are changed so
+ * this code can be used when init_timers() is called, well before most
+ * devices are set up.  (Some low end AT91 parts, which can run uClinux,
+ * have only the timers in one TC block... they currently don't support
+ * the tclib code, because of that initialization issue.)
+ *
+ * REVISIT behavior during system suspend states... we should disable
+ * all clocks and save the power.  Easily done for clockevent devices,
+ * but clocksources won't necessarily get the needed notifications.
+ * For deeper system sleep states, this will be mandatory...
+ */
+
+static void __iomem *tcaddr;
+
+static cycle_t tc_get_cycles(void)
+{
+	unsigned long	flags;
+	u32		lower, upper;
+
+	raw_local_irq_save(flags);
+	do {
+		upper = __raw_readl(tcaddr + ATMEL_TC_REG(1, CV));
+		lower = __raw_readl(tcaddr + ATMEL_TC_REG(0, CV));
+	} while (upper != __raw_readl(tcaddr + ATMEL_TC_REG(1, CV)));
+
+	raw_local_irq_restore(flags);
+	return (upper << 16) | lower;
+}
+
+static struct clocksource clksrc = {
+	.name           = "tcb_clksrc",
+	.rating         = 200,
+	.read           = tc_get_cycles,
+	.mask           = CLOCKSOURCE_MASK(32),
+	.shift          = 18,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+
+struct tc_clkevt_device {
+	struct clock_event_device	clkevt;
+	struct clk			*clk;
+	void __iomem			*regs;
+};
+
+static struct tc_clkevt_device *to_tc_clkevt(struct clock_event_device *clkevt)
+{
+	return container_of(clkevt, struct tc_clkevt_device, clkevt);
+}
+
+/* For now, we always use the 32K clock ... this optimizes for NO_HZ,
+ * because using one of the divided clocks would usually mean the
+ * tick rate can never be less than several dozen Hz (vs 0.5 Hz).
+ *
+ * A divided clock could be good for high resolution timers, since
+ * 30.5 usec resolution can seem "low".
+ */
+static u32 timer_clock;
+
+static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
+{
+	struct tc_clkevt_device *tcd = to_tc_clkevt(d);
+	void __iomem		*regs = tcd->regs;
+
+	if (tcd->clkevt.mode == CLOCK_EVT_MODE_PERIODIC
+			|| tcd->clkevt.mode == CLOCK_EVT_MODE_ONESHOT) {
+		__raw_writel(0xff, regs + ATMEL_TC_REG(2, IDR));
+		__raw_writel(ATMEL_TC_CLKDIS, regs + ATMEL_TC_REG(2, CCR));
+		clk_disable(tcd->clk);
+	}
+
+	switch (m) {
+
+	/* By not making the gentime core emulate periodic mode on top
+	 * of oneshot, we get lower overhead and improved accuracy.
+	 */
+	case CLOCK_EVT_MODE_PERIODIC:
+		clk_enable(tcd->clk);
+
+		/* slow clock, count up to RC, then irq and restart */
+		__raw_writel(timer_clock
+				| ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO,
+				regs + ATMEL_TC_REG(2, CMR));
+		__raw_writel((32768 + HZ/2) / HZ, tcaddr + ATMEL_TC_REG(2, RC));
+
+		/* Enable clock and interrupts on RC compare */
+		__raw_writel(ATMEL_TC_CPCS, regs + ATMEL_TC_REG(2, IER));
+
+		/* go go gadget! */
+		__raw_writel(ATMEL_TC_CLKEN | ATMEL_TC_SWTRG,
+				regs + ATMEL_TC_REG(2, CCR));
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		clk_enable(tcd->clk);
+
+		/* slow clock, count up to RC, then irq and stop */
+		__raw_writel(timer_clock | ATMEL_TC_CPCSTOP
+				| ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO,
+				regs + ATMEL_TC_REG(2, CMR));
+		__raw_writel(ATMEL_TC_CPCS, regs + ATMEL_TC_REG(2, IER));
+
+		/* set_next_event() configures and starts the timer */
+		break;
+
+	default:
+		break;
+	}
+}
+
+static int tc_next_event(unsigned long delta, struct clock_event_device *d)
+{
+	__raw_writel(delta, tcaddr + ATMEL_TC_REG(2, RC));
+
+	/* go go gadget! */
+	__raw_writel(ATMEL_TC_CLKEN | ATMEL_TC_SWTRG,
+			tcaddr + ATMEL_TC_REG(2, CCR));
+	return 0;
+}
+
+static struct tc_clkevt_device clkevt = {
+	.clkevt	= {
+		.name		= "tc_clkevt",
+		.features	= CLOCK_EVT_FEAT_PERIODIC
+					| CLOCK_EVT_FEAT_ONESHOT,
+		.shift		= 32,
+		/* Should be lower than at91rm9200's system timer */
+		.rating		= 125,
+		.cpumask	= CPU_MASK_CPU0,
+		.set_next_event	= tc_next_event,
+		.set_mode	= tc_mode,
+	},
+};
+
+static irqreturn_t ch2_irq(int irq, void *handle)
+{
+	struct tc_clkevt_device	*dev = handle;
+	unsigned int		sr;
+
+	sr = __raw_readl(dev->regs + ATMEL_TC_REG(2, SR));
+	if (sr & ATMEL_TC_CPCS) {
+		dev->clkevt.event_handler(&dev->clkevt);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static struct irqaction tc_irqaction = {
+	.name		= "tc_clkevt",
+	.flags		= IRQF_TIMER | IRQF_DISABLED,
+	.handler	= ch2_irq,
+};
+
+static void __init setup_clkevents(struct atmel_tc *tc,
+		struct clk *t0_clk, int clk32k_divisor_idx)
+{
+	struct platform_device *pdev = tc->pdev;
+	struct clk *t2_clk = tc->clk[2];
+	int irq = tc->irq[2];
+
+	clkevt.regs = tc->regs;
+	clkevt.clk = t2_clk;
+	tc_irqaction.dev_id = &clkevt;
+
+	timer_clock = clk32k_divisor_idx;
+
+	clkevt.clkevt.mult = div_sc(32768, NSEC_PER_SEC, clkevt.clkevt.shift);
+	clkevt.clkevt.max_delta_ns
+		= clockevent_delta2ns(0xffff, &clkevt.clkevt);
+	clkevt.clkevt.min_delta_ns = clockevent_delta2ns(1, &clkevt.clkevt) + 1;
+
+	setup_irq(irq, &tc_irqaction);
+
+	clockevents_register_device(&clkevt.clkevt);
+}
+
+#else /* !CONFIG_GENERIC_CLOCKEVENTS */
+
+static void __init setup_clkevents(struct atmel_tc *tc,
+		struct clk *t0_clk, int clk32k_divisor_idx)
+{
+	/* NOTHING */
+}
+
+#endif
+
+static int __init tcb_clksrc_init(void)
+{
+	static char bootinfo[] __initdata
+		= KERN_DEBUG "%s: tc%d at %d.%03d MHz\n";
+
+	struct platform_device *pdev;
+	struct atmel_tc *tc;
+	struct clk *t0_clk, *t1_clk;
+	u32 rate, divided_rate = 0;
+	int best_divisor_idx = -1;
+	int clk32k_divisor_idx = -1;
+	int i;
+
+	tc = atmel_tc_alloc(CONFIG_ATMEL_TCB_CLKSRC_BLOCK, clksrc.name);
+	if (!tc) {
+		pr_debug("can't alloc TC for clocksource\n");
+		return -ENODEV;
+	}
+	tcaddr = tc->regs;
+	pdev = tc->pdev;
+
+	t0_clk = tc->clk[0];
+	clk_enable(t0_clk);
+
+	/* How fast will we be counting?  Pick something over 5 MHz.  */
+	rate = (u32) clk_get_rate(t0_clk);
+	for (i = 0; i < 5; i++) {
+		unsigned divisor = atmel_tc_divisors[i];
+		unsigned tmp;
+
+		/* remember 32 KiHz clock for later */
+		if (!divisor) {
+			clk32k_divisor_idx = i;
+			continue;
+		}
+
+		tmp = rate / divisor;
+		pr_debug("TC: %u / %-3u [%d] --> %u\n", rate, divisor, i, tmp);
+		if (best_divisor_idx > 0) {
+			if (tmp < 5 * 1000 * 1000)
+				continue;
+		}
+		divided_rate = tmp;
+		best_divisor_idx = i;
+	}
+
+	clksrc.mult = clocksource_hz2mult(divided_rate, clksrc.shift);
+
+	printk(bootinfo, clksrc.name, CONFIG_ATMEL_TCB_CLKSRC_BLOCK,
+			divided_rate / 1000000,
+			((divided_rate + 500000) % 1000000) / 1000);
+
+	/* tclib will give us three clocks no matter what the
+	 * underlying platform supports.
+	 */
+	clk_enable(tc->clk[1]);
+
+	/* channel 0:  waveform mode, input mclk/8, clock TIOA0 on overflow */
+	__raw_writel(best_divisor_idx			/* likely divide-by-8 */
+			| ATMEL_TC_WAVE
+			| ATMEL_TC_WAVESEL_UP		/* free-run */
+			| ATMEL_TC_ACPA_SET		/* TIOA0 rises at 0 */
+			| ATMEL_TC_ACPC_CLEAR,		/* (duty cycle 50%) */
+			tcaddr + ATMEL_TC_REG(0, CMR));
+	__raw_writel(0x0000, tcaddr + ATMEL_TC_REG(0, RA));
+	__raw_writel(0x8000, tcaddr + ATMEL_TC_REG(0, RC));
+	__raw_writel(0xff, tcaddr + ATMEL_TC_REG(0, IDR));	/* no irqs */
+	__raw_writel(ATMEL_TC_CLKEN, tcaddr + ATMEL_TC_REG(0, CCR));
+
+	/* channel 1:  waveform mode, input TIOA0 */
+	__raw_writel(ATMEL_TC_XC1			/* input: TIOA0 */
+			| ATMEL_TC_WAVE
+			| ATMEL_TC_WAVESEL_UP,		/* free-run */
+			tcaddr + ATMEL_TC_REG(1, CMR));
+	__raw_writel(0xff, tcaddr + ATMEL_TC_REG(1, IDR));	/* no irqs */
+	__raw_writel(ATMEL_TC_CLKEN, tcaddr + ATMEL_TC_REG(1, CCR));
+
+	/* chain channel 0 to channel 1, then reset all the timers */
+	__raw_writel(ATMEL_TC_TC1XC1S_TIOA0, tcaddr + ATMEL_TC_BMR);
+	__raw_writel(ATMEL_TC_SYNC, tcaddr + ATMEL_TC_BCR);
+
+	/* and away we go! */
+	clocksource_register(&clksrc);
+
+	/* channel 2:  periodic and oneshot timer support */
+	setup_clkevents(tc, t0_clk, clk32k_divisor_idx);
+
+	return 0;
+}
+arch_initcall(tcb_clksrc_init);
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b3ba681..4cf928e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -30,6 +30,31 @@ config ATMEL_TCLIB
 	  blocks found on many Atmel processors.  This facilitates using
 	  these blocks by different drivers despite processor differences.
 
+config ATMEL_TCB_CLKSRC
+	bool "TC Block Clocksource"
+	depends on ATMEL_TCLIB && GENERIC_TIME
+	default y
+	help
+	  Select this to get a high precision clocksource based on a
+	  TC block with a 5+ MHz base clock rate.  Two timer channels
+	  are combined to make a single 32-bit timer.
+
+	  When GENERIC_CLOCKEVENTS is defined, the third timer channel
+	  may be used as a clock event device supporting oneshot mode
+	  (delays of up to two seconds) based on the 32 KiHz clock.
+
+config ATMEL_TCB_CLKSRC_BLOCK
+	int
+	depends on ATMEL_TCB_CLKSRC
+	prompt "TC Block" if ARCH_AT91RM9200 || ARCH_AT91SAM9260 || CPU_AT32AP700X
+	default 0
+	range 0 1
+	help
+	  Some chips provide more than one TC block, so you have the
+	  choice of which one to use for the clock framework.  The other
+	  TC can be used for other purposes, such as PWM generation and
+	  interval timing.
+
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
 	depends on X86 && PCI && INPUT && EXPERIMENTAL
-- 
1.5.4.1

