Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbZFEIRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbZFEIRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbZFEIGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37464 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502AbZFEIFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 32/62] Blackfin: add support for gptimer0 as a tick source
Date: Fri,  5 Jun 2009 04:04:41 -0400
Message-Id: <1244189111-19639-33-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

For systems where the core cycles are not a usable tick source (like SMP
or cycles gets updated), enable gptimer0 as an alternative.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig                     |   32 +++--
 arch/blackfin/include/asm/time.h          |    1 +
 arch/blackfin/kernel/time-ts.c            |  220 ++++++++++++++++++++++++-----
 arch/blackfin/kernel/time.c               |   10 +-
 arch/blackfin/mach-bf518/Kconfig          |    1 +
 arch/blackfin/mach-bf527/Kconfig          |    1 +
 arch/blackfin/mach-bf533/Kconfig          |    1 +
 arch/blackfin/mach-bf537/Kconfig          |    1 +
 arch/blackfin/mach-bf538/Kconfig          |    1 +
 arch/blackfin/mach-bf548/Kconfig          |    1 +
 arch/blackfin/mach-bf561/Kconfig          |    1 +
 arch/blackfin/mach-bf561/smp.c            |    2 +-
 arch/blackfin/mach-common/ints-priority.c |   23 +---
 arch/blackfin/mach-common/smp.c           |    5 +-
 14 files changed, 227 insertions(+), 73 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index cea2bfd..c04e7a4 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -241,12 +241,6 @@ config IRQ_PER_CPU
 	depends on SMP
 	default y
 
-config TICK_SOURCE_SYSTMR0
-	bool
-	select BFIN_GPTIMERS
-	depends on SMP
-	default y
-
 config BF_REV_MIN
 	int
 	default 0 if (BF51x || BF52x || (BF54x && !BF54xM))
@@ -607,7 +601,6 @@ source kernel/Kconfig.hz
 
 config GENERIC_TIME
 	bool "Generic time"
-	depends on !SMP
 	default y
 
 config GENERIC_CLOCKEVENTS
@@ -615,12 +608,26 @@ config GENERIC_CLOCKEVENTS
 	depends on GENERIC_TIME
 	default y
 
+choice
+	prompt "Kernel Tick Source"
+	depends on GENERIC_CLOCKEVENTS
+	default TICKSOURCE_CORETMR
+
+config TICKSOURCE_GPTMR0
+	bool "Gptimer0 (SCLK domain)"
+	select BFIN_GPTIMERS
+	depends on !IPIPE
+
+config TICKSOURCE_CORETMR
+	bool "Core timer (CCLK domain)"
+
+endchoice
+
 config CYCLES_CLOCKSOURCE
-	bool "Use 'CYCLES' as a clocksource (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Use 'CYCLES' as a clocksource"
 	depends on GENERIC_CLOCKEVENTS
 	depends on !BFIN_SCRATCH_REG_CYCLES
-	default n
+	depends on !SMP
 	help
 	  If you say Y here, you will enable support for using the 'cycles'
 	  registers as a clock source.  Doing so means you will be unable to
@@ -628,6 +635,11 @@ config CYCLES_CLOCKSOURCE
 	  still be able to read it (such as for performance monitoring), but
 	  writing the registers will most likely crash the kernel.
 
+config GPTMR0_CLOCKSOURCE
+	bool "Use GPTimer0 as a clocksource (higher rating)"
+	depends on GENERIC_CLOCKEVENTS
+	depends on !TICKSOURCE_GPTMR0
+
 source kernel/time/Kconfig
 
 comment "Misc"
diff --git a/arch/blackfin/include/asm/time.h b/arch/blackfin/include/asm/time.h
index ddc43ce..589e937 100644
--- a/arch/blackfin/include/asm/time.h
+++ b/arch/blackfin/include/asm/time.h
@@ -37,4 +37,5 @@ extern unsigned long long __bfin_cycles_off;
 extern unsigned int __bfin_cycles_mod;
 #endif
 
+extern void __init setup_core_timer(void);
 #endif
diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
index 2764612..d9a6fe4 100644
--- a/arch/blackfin/kernel/time-ts.c
+++ b/arch/blackfin/kernel/time-ts.c
@@ -20,8 +20,9 @@
 
 #include <asm/blackfin.h>
 #include <asm/time.h>
+#include <asm/gptimers.h>
 
-#ifdef CONFIG_CYCLES_CLOCKSOURCE
+#if defined(CONFIG_CYCLES_CLOCKSOURCE)
 
 /* Accelerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
@@ -63,10 +64,10 @@ static cycle_t read_cycles(struct clocksource *cs)
 	return __bfin_cycles_off + (get_cycles() << __bfin_cycles_mod);
 }
 
-static struct clocksource clocksource_bfin = {
-	.name		= "bfin_cycles",
+static struct clocksource bfin_cs_cycles = {
+	.name		= "bfin_cs_cycles",
 	.rating		= 350,
-	.read		= read_cycles,
+	.read		= bfin_read_cycles,
 	.mask		= CLOCKSOURCE_MASK(64),
 	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
@@ -74,53 +75,198 @@ static struct clocksource clocksource_bfin = {
 
 unsigned long long sched_clock(void)
 {
-	return cycles_2_ns(read_cycles(&clocksource_bfin));
+	return cycles_2_ns(read_cycles(&bfin_cs_cycles));
 }
 
-static int __init bfin_clocksource_init(void)
+static int __init bfin_cs_cycles_init(void)
 {
 	set_cyc2ns_scale(get_cclk() / 1000);
 
-	clocksource_bfin.mult = clocksource_hz2mult(get_cclk(), clocksource_bfin.shift);
+	bfin_cs_cycles.mult = \
+		clocksource_hz2mult(get_cclk(), bfin_cs_cycles.shift);
 
-	if (clocksource_register(&clocksource_bfin))
+	if (clocksource_register(&bfin_cs_cycles))
 		panic("failed to register clocksource");
 
 	return 0;
 }
+#else
+# define bfin_cs_cycles_init()
+#endif
+
+#ifdef CONFIG_GPTMR0_CLOCKSOURCE
+
+void __init setup_gptimer0(void)
+{
+	disable_gptimers(TIMER0bit);
+
+	set_gptimer_config(TIMER0_id, \
+		TIMER_OUT_DIS | TIMER_PERIOD_CNT | TIMER_MODE_PWM);
+	set_gptimer_period(TIMER0_id, -1);
+	set_gptimer_pwidth(TIMER0_id, -2);
+	SSYNC();
+	enable_gptimers(TIMER0bit);
+}
+
+static cycle_t bfin_read_gptimer0(void)
+{
+	return bfin_read_TIMER0_COUNTER();
+}
+
+static struct clocksource bfin_cs_gptimer0 = {
+	.name		= "bfin_cs_gptimer0",
+	.rating		= 400,
+	.read		= bfin_read_gptimer0,
+	.mask		= CLOCKSOURCE_MASK(32),
+	.shift		= 22,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static int __init bfin_cs_gptimer0_init(void)
+{
+	setup_gptimer0();
 
+	bfin_cs_gptimer0.mult = \
+		clocksource_hz2mult(get_sclk(), bfin_cs_gptimer0.shift);
+
+	if (clocksource_register(&bfin_cs_gptimer0))
+		panic("failed to register clocksource");
+
+	return 0;
+}
 #else
-# define bfin_clocksource_init()
+# define bfin_cs_gptimer0_init()
 #endif
 
+#ifdef CONFIG_CORE_TIMER_IRQ_L1
+__attribute__((l1_text))
+#endif
+irqreturn_t timer_interrupt(int irq, void *dev_id);
+
+static int bfin_timer_set_next_event(unsigned long, \
+		struct clock_event_device *);
+
+static void bfin_timer_set_mode(enum clock_event_mode, \
+		struct clock_event_device *);
+
+static struct clock_event_device clockevent_bfin = {
+#if defined(CONFIG_TICKSOURCE_GPTMR0)
+	.name		= "bfin_gptimer0",
+	.rating		= 300,
+	.irq		= IRQ_TIMER0,
+#else
+	.name		= "bfin_core_timer",
+	.rating		= 350,
+	.irq		= IRQ_CORETMR,
+#endif
+	.shift		= 32,
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_next_event = bfin_timer_set_next_event,
+	.set_mode	= bfin_timer_set_mode,
+};
+
+static struct irqaction bfin_timer_irq = {
+#if defined(CONFIG_TICKSOURCE_GPTMR0)
+	.name		= "Blackfin GPTimer0",
+#else
+	.name		= "Blackfin CoreTimer",
+#endif
+	.flags		= IRQF_DISABLED | IRQF_TIMER | \
+			  IRQF_IRQPOLL | IRQF_PERCPU,
+	.handler	= timer_interrupt,
+	.dev_id		= &clockevent_bfin,
+};
+
+#if defined(CONFIG_TICKSOURCE_GPTMR0)
 static int bfin_timer_set_next_event(unsigned long cycles,
                                      struct clock_event_device *evt)
 {
+	disable_gptimers(TIMER0bit);
+
+	/* it starts counting three SCLK cycles after the TIMENx bit is set */
+	set_gptimer_pwidth(TIMER0_id, cycles - 3);
+	enable_gptimers(TIMER0bit);
+	return 0;
+}
+
+static void bfin_timer_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC: {
+		set_gptimer_config(TIMER0_id, \
+			TIMER_OUT_DIS | TIMER_IRQ_ENA | \
+			TIMER_PERIOD_CNT | TIMER_MODE_PWM);
+		set_gptimer_period(TIMER0_id, get_sclk() / HZ);
+		set_gptimer_pwidth(TIMER0_id, get_sclk() / HZ - 1);
+		enable_gptimers(TIMER0bit);
+		break;
+	}
+	case CLOCK_EVT_MODE_ONESHOT:
+		disable_gptimers(TIMER0bit);
+		set_gptimer_config(TIMER0_id, \
+			TIMER_OUT_DIS | TIMER_IRQ_ENA | TIMER_MODE_PWM);
+		set_gptimer_period(TIMER0_id, 0);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		disable_gptimers(TIMER0bit);
+		break;
+	case CLOCK_EVT_MODE_RESUME:
+		break;
+	}
+}
+
+static void bfin_timer_ack(void)
+{
+	set_gptimer_status(TIMER_GROUP1, TIMER_STATUS_TIMIL0);
+}
+
+static void __init bfin_timer_init(void)
+{
+	disable_gptimers(TIMER0bit);
+}
+
+static unsigned long  __init bfin_clockevent_check(void)
+{
+	setup_irq(IRQ_TIMER0, &bfin_timer_irq);
+	return get_sclk();
+}
+
+#else /* CONFIG_TICKSOURCE_CORETMR */
+
+static int bfin_timer_set_next_event(unsigned long cycles,
+				struct clock_event_device *evt)
+{
+	bfin_write_TCNTL(TMPWR);
+	CSYNC();
 	bfin_write_TCOUNT(cycles);
 	CSYNC();
+	bfin_write_TCNTL(TMPWR | TMREN);
 	return 0;
 }
 
 static void bfin_timer_set_mode(enum clock_event_mode mode,
-                                struct clock_event_device *evt)
+				struct clock_event_device *evt)
 {
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC: {
 		unsigned long tcount = ((get_cclk() / (HZ * TIME_SCALE)) - 1);
 		bfin_write_TCNTL(TMPWR);
-		bfin_write_TSCALE(TIME_SCALE - 1);
 		CSYNC();
+		bfin_write_TSCALE(TIME_SCALE - 1);
 		bfin_write_TPERIOD(tcount);
 		bfin_write_TCOUNT(tcount);
-		bfin_write_TCNTL(TMPWR | TMREN | TAUTORLD);
 		CSYNC();
+		bfin_write_TCNTL(TMPWR | TMREN | TAUTORLD);
 		break;
 	}
 	case CLOCK_EVT_MODE_ONESHOT:
+		bfin_write_TCNTL(TMPWR);
+		CSYNC();
 		bfin_write_TSCALE(TIME_SCALE - 1);
+		bfin_write_TPERIOD(0);
 		bfin_write_TCOUNT(0);
-		bfin_write_TCNTL(TMPWR | TMREN);
-		CSYNC();
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
@@ -132,6 +278,10 @@ static void bfin_timer_set_mode(enum clock_event_mode mode,
 	}
 }
 
+static void bfin_timer_ack(void)
+{
+}
+
 static void __init bfin_timer_init(void)
 {
 	/* power up the timer, but don't enable it just yet */
@@ -145,38 +295,32 @@ static void __init bfin_timer_init(void)
 	bfin_write_TPERIOD(0);
 	bfin_write_TCOUNT(0);
 
-	/* now enable the timer */
 	CSYNC();
 }
 
+static unsigned long  __init bfin_clockevent_check(void)
+{
+	setup_irq(IRQ_CORETMR, &bfin_timer_irq);
+	return get_cclk() / TIME_SCALE;
+}
+
+void __init setup_core_timer(void)
+{
+	bfin_timer_init();
+	bfin_timer_set_mode(CLOCK_EVT_MODE_PERIODIC, NULL);
+}
+#endif /* CONFIG_TICKSOURCE_GPTMR0 */
+
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
-#ifdef CONFIG_CORE_TIMER_IRQ_L1
-__attribute__((l1_text))
-#endif
-irqreturn_t timer_interrupt(int irq, void *dev_id);
-
-static struct clock_event_device clockevent_bfin = {
-	.name		= "bfin_core_timer",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
-	.set_next_event = bfin_timer_set_next_event,
-	.set_mode	= bfin_timer_set_mode,
-};
-
-static struct irqaction bfin_timer_irq = {
-	.name		= "Blackfin Core Timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= timer_interrupt,
-	.dev_id		= &clockevent_bfin,
-};
-
 irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *evt = dev_id;
+	smp_mb();
 	evt->event_handler(evt);
+	bfin_timer_ack();
 	return IRQ_HANDLED;
 }
 
@@ -184,9 +328,8 @@ static int __init bfin_clockevent_init(void)
 {
 	unsigned long timer_clk;
 
-	timer_clk = get_cclk() / TIME_SCALE;
+	timer_clk = bfin_clockevent_check();
 
-	setup_irq(IRQ_CORETMR, &bfin_timer_irq);
 	bfin_timer_init();
 
 	clockevent_bfin.mult = div_sc(timer_clk, NSEC_PER_SEC, clockevent_bfin.shift);
@@ -218,6 +361,7 @@ void __init time_init(void)
 	xtime.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec, -xtime.tv_nsec);
 
-	bfin_clocksource_init();
+	bfin_cs_cycles_init();
+	bfin_cs_gptimer0_init();
 	bfin_clockevent_init();
 }
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index 1bbacfb..daa02d4 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -31,7 +31,7 @@ static struct irqaction bfin_timer_irq = {
 #endif
 };
 
-#if defined(CONFIG_TICK_SOURCE_SYSTMR0) || defined(CONFIG_IPIPE)
+#if defined(CONFIG_TICKSOURCE_GPTMR0) || defined(CONFIG_IPIPE)
 void __init setup_system_timer0(void)
 {
 	/* Power down the core timer, just to play safe. */
@@ -74,7 +74,7 @@ void __init setup_core_timer(void)
 static void __init
 time_sched_init(irqreturn_t(*timer_routine) (int, void *))
 {
-#if defined(CONFIG_TICK_SOURCE_SYSTMR0) || defined(CONFIG_IPIPE)
+#if defined(CONFIG_TICKSOURCE_GPTMR0) || defined(CONFIG_IPIPE)
 	setup_system_timer0();
 	bfin_timer_irq.handler = timer_routine;
 	setup_irq(IRQ_TIMER0, &bfin_timer_irq);
@@ -94,7 +94,7 @@ static unsigned long gettimeoffset(void)
 	unsigned long offset;
 	unsigned long clocks_per_jiffy;
 
-#if defined(CONFIG_TICK_SOURCE_SYSTMR0) || defined(CONFIG_IPIPE)
+#if defined(CONFIG_TICKSOURCE_GPTMR0) || defined(CONFIG_IPIPE)
 	clocks_per_jiffy = bfin_read_TIMER0_PERIOD();
 	offset = bfin_read_TIMER0_COUNTER() / \
 		(((clocks_per_jiffy + 1) * HZ) / USEC_PER_SEC);
@@ -133,7 +133,7 @@ irqreturn_t timer_interrupt(int irq, void *dummy)
 	static long last_rtc_update;
 
 	write_seqlock(&xtime_lock);
-#if defined(CONFIG_TICK_SOURCE_SYSTMR0) && !defined(CONFIG_IPIPE)
+#if defined(CONFIG_TICKSOURCE_GPTMR0) && !defined(CONFIG_IPIPE)
 	/*
 	 * TIMIL0 is latched in __ipipe_grab_irq() when the I-Pipe is
 	 * enabled.
@@ -159,7 +159,7 @@ irqreturn_t timer_interrupt(int irq, void *dummy)
 				/* Do it again in 60s. */
 				last_rtc_update = xtime.tv_sec - 600;
 		}
-#if defined(CONFIG_TICK_SOURCE_SYSTMR0) && !defined(CONFIG_IPIPE)
+#if defined(CONFIG_TICKSOURCE_GPTMR0) && !defined(CONFIG_IPIPE)
 		set_gptimer_status(0, TIMER_STATUS_TIMIL0);
 	}
 #endif
diff --git a/arch/blackfin/mach-bf518/Kconfig b/arch/blackfin/mach-bf518/Kconfig
index f397ede..4c76fef 100644
--- a/arch/blackfin/mach-bf518/Kconfig
+++ b/arch/blackfin/mach-bf518/Kconfig
@@ -156,6 +156,7 @@ config IRQ_PORTH_INTB
 	default 11
 config IRQ_TIMER0
 	int "IRQ_TIMER0"
+	default 7 if TICKSOURCE_GPTMR0
 	default 8
 config IRQ_TIMER1
 	int "IRQ_TIMER1"
diff --git a/arch/blackfin/mach-bf527/Kconfig b/arch/blackfin/mach-bf527/Kconfig
index 8438ec6..848ac6f 100644
--- a/arch/blackfin/mach-bf527/Kconfig
+++ b/arch/blackfin/mach-bf527/Kconfig
@@ -170,6 +170,7 @@ config IRQ_PORTH_INTB
 	default 11
 config IRQ_TIMER0
 	int "IRQ_TIMER0"
+	default 7 if TICKSOURCE_GPTMR0
 	default 8
 config IRQ_TIMER1
 	int "IRQ_TIMER1"
diff --git a/arch/blackfin/mach-bf533/Kconfig b/arch/blackfin/mach-bf533/Kconfig
index 14427de..4c57244 100644
--- a/arch/blackfin/mach-bf533/Kconfig
+++ b/arch/blackfin/mach-bf533/Kconfig
@@ -59,6 +59,7 @@ config DMA7_UARTTX
 	default 10
 config TIMER0
 	int "TIMER0"
+	default 7 if TICKSOURCE_GPTMR0
 	default 8
 config TIMER1
 	int "TIMER1"
diff --git a/arch/blackfin/mach-bf537/Kconfig b/arch/blackfin/mach-bf537/Kconfig
index bbc08fd..d81224f 100644
--- a/arch/blackfin/mach-bf537/Kconfig
+++ b/arch/blackfin/mach-bf537/Kconfig
@@ -66,6 +66,7 @@ config IRQ_MAC_TX
 	default 11
 config IRQ_TIMER0
 	int "IRQ_TIMER0"
+	default 7 if TICKSOURCE_GPTMR0
 	default 8
 config IRQ_TIMER1
 	int "IRQ_TIMER1"
diff --git a/arch/blackfin/mach-bf538/Kconfig b/arch/blackfin/mach-bf538/Kconfig
index f068c35..2d280f5 100644
--- a/arch/blackfin/mach-bf538/Kconfig
+++ b/arch/blackfin/mach-bf538/Kconfig
@@ -57,6 +57,7 @@ config IRQ_UART0_TX
 	default 10
 config IRQ_TIMER0
 	int "IRQ_TIMER0"
+	default 7 if TICKSOURCE_GPTMR0
 	default 8
 config IRQ_TIMER1
 	int "IRQ_TIMER1"
diff --git a/arch/blackfin/mach-bf548/Kconfig b/arch/blackfin/mach-bf548/Kconfig
index 8d24eaa..a09623d 100644
--- a/arch/blackfin/mach-bf548/Kconfig
+++ b/arch/blackfin/mach-bf548/Kconfig
@@ -257,6 +257,7 @@ config IRQ_OTPSEC
 	default 11
 config IRQ_TIMER0
 	int "IRQ_TIMER0"
+	default 7 if TICKSOURCE_GPTMR0
 	default 8
 config IRQ_TIMER1
 	int "IRQ_TIMER1"
diff --git a/arch/blackfin/mach-bf561/Kconfig b/arch/blackfin/mach-bf561/Kconfig
index 6965dd5..cb97436 100644
--- a/arch/blackfin/mach-bf561/Kconfig
+++ b/arch/blackfin/mach-bf561/Kconfig
@@ -125,6 +125,7 @@ config IRQ_DMA2_11
 	default 9
 config IRQ_TIMER0
 	int "TIMER 0  Interrupt"
+	default 7 if TICKSOURCE_GPTMR0
 	default 8
 config IRQ_TIMER1
 	int "TIMER 1  Interrupt"
diff --git a/arch/blackfin/mach-bf561/smp.c b/arch/blackfin/mach-bf561/smp.c
index 4ea13d2..8c10701 100644
--- a/arch/blackfin/mach-bf561/smp.c
+++ b/arch/blackfin/mach-bf561/smp.c
@@ -133,7 +133,7 @@ void __init platform_request_ipi(irq_handler_t handler)
 	int ret;
 
 	ret = request_irq(IRQ_SUPPLE_0, handler, IRQF_DISABLED,
-			  "SMP interrupt", handler);
+			  "Supplemental Interrupt0", handler);
 	if (ret)
 		panic("Cannot request supplemental interrupt 0 for IPI service");
 }
diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index 389c5e8..6e80861 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -1052,7 +1052,7 @@ int __init init_arch_irq(void)
 			set_irq_chained_handler(irq, bfin_demux_error_irq);
 			break;
 #endif
-#if defined(CONFIG_TICK_SOURCE_SYSTMR0) || defined(CONFIG_IPIPE)
+#if defined(CONFIG_TICKSOURCE_GPTMR0)
 		case IRQ_TIMER0:
 			set_irq_handler(irq, handle_percpu_irq);
 			break;
@@ -1232,13 +1232,9 @@ asmlinkage int __ipipe_grab_irq(int vec, struct pt_regs *regs)
 
 	if (likely(vec == EVT_IVTMR_P)) {
 		irq = IRQ_CORETMR;
-		goto core_tick;
-	}
-
-	SSYNC();
 
+	} else {
 #if defined(CONFIG_BF54x) || defined(CONFIG_BF52x) || defined(CONFIG_BF561)
-	{
 		unsigned long sic_status[3];
 
 		sic_status[0] = bfin_read_SIC_ISR0() & bfin_read_SIC_IMASK0();
@@ -1254,9 +1250,7 @@ asmlinkage int __ipipe_grab_irq(int vec, struct pt_regs *regs)
 			if (sic_status[(ivg->irqno - IVG7) / 32] & ivg->isrflag)
 				break;
 		}
-	}
 #else
-	{
 		unsigned long sic_status;
 
 		sic_status = bfin_read_SIC_IMASK() & bfin_read_SIC_ISR();
@@ -1268,15 +1262,13 @@ asmlinkage int __ipipe_grab_irq(int vec, struct pt_regs *regs)
 			} else if (sic_status & ivg->isrflag)
 				break;
 		}
-	}
 #endif
 
-	irq = ivg->irqno;
+		irq = ivg->irqno;
+	}
 
 	if (irq == IRQ_SYSTMR) {
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
-core_tick:
-#else
+#ifndef CONFIG_GENERIC_CLOCKEVENTS
 		bfin_write_TIMER_STATUS(1); /* Latch TIMIL0 */
 #endif
 		/* This is basically what we need from the register frame. */
@@ -1288,9 +1280,6 @@ core_tick:
 			__raw_get_cpu_var(__ipipe_tick_regs).ipend |= 0x10;
 	}
 
-#ifndef CONFIG_GENERIC_CLOCKEVENTS
-core_tick:
-#endif
 	if (this_domain == ipipe_root_domain) {
 		s = __test_and_set_bit(IPIPE_SYNCDEFER_FLAG, &p->status);
 		barrier();
@@ -1308,7 +1297,7 @@ core_tick:
 		}
 	}
 
-       return 0;
+	return 0;
 }
 
 #endif /* CONFIG_IPIPE */
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 187c79e..b669595 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -43,6 +43,7 @@
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/cpu.h>
+#include <asm/time.h>
 #include <linux/err.h>
 
 /*
@@ -356,7 +357,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 
 static void __cpuinit setup_secondary(unsigned int cpu)
 {
-#if !(defined(CONFIG_TICK_SOURCE_SYSTMR0) || defined(CONFIG_IPIPE))
+#if !defined(CONFIG_TICKSOURCE_GPTMR0)
 	struct irq_desc *timer_desc;
 #endif
 	unsigned long ilat;
@@ -377,7 +378,7 @@ static void __cpuinit setup_secondary(unsigned int cpu)
 	    IMASK_IVG14 | IMASK_IVG13 | IMASK_IVG12 | IMASK_IVG11 |
 	    IMASK_IVG10 | IMASK_IVG9 | IMASK_IVG8 | IMASK_IVG7 | IMASK_IVGHW;
 
-#if defined(CONFIG_TICK_SOURCE_SYSTMR0) || defined(CONFIG_IPIPE)
+#if defined(CONFIG_TICKSOURCE_GPTMR0)
 	/* Power down the core timer, just to play safe. */
 	bfin_write_TCNTL(0);
 
-- 
1.6.3.1

