Return-Path: <linux-kernel-owner+w=401wt.eu-S1765473AbYBWBeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765473AbYBWBeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYBWBdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:33:41 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:30997 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750927AbYBWBdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:33:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fURClI+4gadfyZHi7bYJW/TpMW/fdqLPX6bJm3sZRGiPNSZBEGIOyd81/RxQAagtVylC6o++MjLCBFQMes8QFBk6yL5he43BCUFN7fEhpgDNag32zJWH88IK3sAP0dQBWXE8ftKHMFCLhwldl5HWBokLG3gEomIm4bw7Hsa7bKY=  ;
X-YMail-OSG: B6IebUIVM1mmEPJ7gLnfts4xh2DL95Gux34i8RfI.xrvsIl3sWE9VThItsvxo5_zt1QvpHQ2dlbZlbB7imISchTtwcTjP.s962QX8O04YUs1PVabmw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.25-rc2-git 2/2] atmel_tc clocksource/clockevent code
Date: Fri, 22 Feb 2008 17:28:37 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221728.37910.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clocksource and clockevent device based on the Atmel TC blocks.

The clockevent device handles both periodic and oneshot modes, so this
enables NO_HZ and high res timers on some platforms that previously
couldn't use those mechanisms.

This works on both AVR32 and AT91 chips, given relevant patches for
tclib support (always) and clockevents (or else this will only look
like a higher precision clocksource).  It's an updated and modularized
version of an AT91-only patch that has circulated for some time now.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
As with the preceding patch, this depends on platform updates that
won't merge before 2.6.26 ... in this case, updates to switch over
to clocksources (at91sam9 chips, but not at91rm9200) and clockevents
(avr32 and at91sam9), on top of platform_device setup.

 drivers/clocksource/Makefile     |    1 
 drivers/clocksource/tcb_clksrc.c |  303 +++++++++++++++++++++++++++++++++++++++
 drivers/misc/Kconfig             |   25 +++
 3 files changed, 329 insertions(+)

--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -1,3 +1,4 @@
+obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+= tcb_clksrc.o
 obj-$(CONFIG_X86_CYCLONE_TIMER)	+= cyclone.o
 obj-$(CONFIG_X86_PM_TIMER)	+= acpi_pm.o
 obj-$(CONFIG_SCx200HR_TIMER)	+= scx200_hrt.o
--- /dev/null
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -0,0 +1,303 @@
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
+retry:
+	upper = __raw_readl(tcaddr + ATMEL_TC_REG(1, CV));
+	lower = __raw_readl(tcaddr + ATMEL_TC_REG(0, CV));
+	if (upper != __raw_readl(tcaddr + ATMEL_TC_REG(1, CV)))
+		goto retry;
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
+#define USE_TC_CLKEVT
+#endif
+
+#ifdef CONFIG_ARCH_AT91RM9200
+/* The AT91rm9200 system timer is a oneshot-capable 32k timer that's
+ * always running ... configuring a TC channel to work the same way
+ * would just waste some power.
+ */
+#undef USE_TC_CLKEVT
+#endif
+
+#ifdef USE_TC_CLKEVT
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
+	__raw_writel(0xff, tcaddr + ATMEL_TC_REG(2, IDR));
+	__raw_writel(ATMEL_TC_CLKDIS, tcaddr + ATMEL_TC_REG(2, CCR));
+
+	switch (m) {
+
+	/* By not making the gentime core emulate periodic mode on top
+	 * of oneshot, we get lower overhead and improved accuracy.
+	 */
+	case CLOCK_EVT_MODE_PERIODIC:
+		/* slow clock, count up to RC, then irq and restart */
+		__raw_writel(timer_clock
+				| ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO,
+				tcaddr + ATMEL_TC_REG(2, CMR));
+		__raw_writel((32768 + HZ/2) / HZ, tcaddr + ATMEL_TC_REG(2, RC));
+
+		/* Enable clock and interrupts on RC compare */
+		__raw_writel(ATMEL_TC_CPCS, tcaddr + ATMEL_TC_REG(2, IER));
+
+		/* go go gadget! */
+		__raw_writel(ATMEL_TC_CLKEN | ATMEL_TC_SWTRG,
+				tcaddr + ATMEL_TC_REG(2, CCR));
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* slow clock, count up to RC, then irq and stop */
+		__raw_writel(timer_clock | ATMEL_TC_CPCSTOP
+				| ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO,
+				tcaddr + ATMEL_TC_REG(2, CMR));
+		__raw_writel(ATMEL_TC_CPCS, tcaddr + ATMEL_TC_REG(2, IER));
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
+static struct clock_event_device clkevt = {
+	.name		= "tc_clkevt",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.shift		= 32,
+	.rating		= 125,
+	.cpumask	= CPU_MASK_CPU0,
+	.set_next_event	= tc_next_event,
+	.set_mode	= tc_mode,
+};
+
+static irqreturn_t ch2_irq(int irq, void *handle)
+{
+	unsigned int	sr = __raw_readl(tcaddr + ATMEL_TC_REG(2, SR));
+
+	if (sr & ATMEL_TC_CPCS) {
+		clkevt.event_handler(&clkevt);
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
+static void __init setup_clkevents(struct platform_device *pdev,
+		struct clk *t0_clk, int clk32k_divisor_idx)
+{
+	struct clk	*t2_clk = clk_get(&pdev->dev, "t2_clk");
+	int		irq;
+
+	/* SOCs have either one IRQ and one clock for the whole
+	 * TC block; or one each per channel.  We use channel 2.
+	 */
+	if (IS_ERR(t2_clk)) {
+		t2_clk = t0_clk;
+		irq = platform_get_irq(pdev, 0);
+	} else {
+		irq = platform_get_irq(pdev, 2);
+		clk_enable(t2_clk);
+	}
+
+	timer_clock = clk32k_divisor_idx;
+
+	clkevt.mult = div_sc(32768, NSEC_PER_SEC, clkevt.shift);
+	clkevt.max_delta_ns = clockevent_delta2ns(0xffff, &clkevt);
+	clkevt.min_delta_ns = clockevent_delta2ns(1, &clkevt) + 1;
+
+	setup_irq(irq, &tc_irqaction);
+
+	clockevents_register_device(&clkevt);
+}
+
+#else /* !USE_TC_CLKEVT */
+
+static void __init setup_clkevents(struct platform_device *pdev,
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
+	struct clk *t0_clk, *t1_clk;
+	u32 rate, divided_rate = 0;
+	int best_divisor_idx = -1;
+	int clk32k_divisor_idx = -1;
+	int i;
+	struct resource *iomem;
+
+	pdev = atmel_tc_alloc(CONFIG_ATMEL_TCB_CLKSRC_BLOCK, &iomem);
+	if (pdev == NULL) {
+		pr_debug("can't alloc TC for clocksource\n");
+		return -ENODEV;
+	}
+	rename_region(iomem, clksrc.name);
+	tcaddr = ioremap(iomem->start, 256);
+
+	t0_clk = clk_get(&pdev->dev, "t0_clk");
+	if (IS_ERR(t0_clk)) {
+		atmel_tc_free(pdev);
+		return PTR_ERR(t0_clk);
+	}
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
+	/* Some platforms (like at91rm9200, at91sam9260, etc) have one clock
+	 * (and IRQ) per timer.  Others (at91sam9263, ap700x, etc) don't.
+	 */
+	t1_clk = clk_get(&pdev->dev, "t1_clk");
+	if (IS_ERR(t1_clk))
+		t1_clk = t0_clk;
+	else
+		clk_enable(t1_clk);
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
+	setup_clkevents(pdev, t0_clk, clk32k_divisor_idx);
+
+	return 0;
+}
+arch_initcall(tcb_clksrc_init);
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
