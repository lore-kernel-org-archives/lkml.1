Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbXEVXtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbXEVXtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXEVXtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:49:04 -0400
Received: from deeprooted.net ([216.254.16.51]:47988 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756132AbXEVXtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:49:01 -0400
Message-Id: <20070522234650.794625187@mvista.com>
User-Agent: quilt/0.45-1
Date: Tue, 22 May 2007 16:46:50 -0700
From: Kevin Hilman <khilman@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -rt] Resolve -rt OMAP conflicts
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all the OMAP clocksource/clockevent stuff from the
-rt patch since it is now all in the OMAP tree.

It also removes the few raw_spinlock additions to OMAP specific files
which will be revisited/resumitted if necessary.  I currently believe
that all of these raw spinlocks are no longer necessary.

Signed-off-by: Kevin Hilman <khilman@mvista.com>

--- linux/arch/arm/Kconfig
+++ linux.orig/arch/arm/Kconfig
@@ -363,7 +363,6 @@
 config ARCH_OMAP
 	bool "TI OMAP"
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	help
 	  Support for TI's OMAP platform (OMAP1 and OMAP2).
 
reverted:
--- linux/arch/arm/mach-omap1/pm.c
+++ linux.orig/arch/arm/mach-omap1/pm.c
@@ -120,7 +120,7 @@
 
 	local_irq_disable();
 	local_fiq_disable();
+	if (need_resched()) {
-	if (need_resched() || need_resched_delayed()) {
 		local_fiq_enable();
 		local_irq_enable();
 		return;
reverted:
--- linux/arch/arm/mach-omap1/time.c
+++ linux.orig/arch/arm/mach-omap1/time.c
@@ -39,10 +39,6 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/clocksource.h>
-#include <linux/clockchips.h>
 
 #include <asm/system.h>
 #include <asm/hardware.h>
@@ -52,7 +48,13 @@
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
 
+struct sys_timer omap_timer;
 
+/*
+ * ---------------------------------------------------------------------------
+ * MPU timer
+ * ---------------------------------------------------------------------------
+ */
 #define OMAP_MPU_TIMER_BASE		OMAP_MPU_TIMER1_BASE
 #define OMAP_MPU_TIMER_OFFSET		0x100
 
@@ -86,6 +88,21 @@
 	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
 }
 
+/*
+ * MPU_TICKS_PER_SEC must be an even number, otherwise machinecycles_to_usecs
+ * will break. On P2, the timer count rate is 6.5 MHz after programming PTV
+ * with 0. This divides the 13MHz input by 2, and is undocumented.
+ */
+#if defined(CONFIG_MACH_OMAP_PERSEUS2) || defined(CONFIG_MACH_OMAP_FSAMPLE)
+/* REVISIT: This ifdef construct should be replaced by a query to clock
+ * framework to see if timer base frequency is 12.0, 13.0 or 19.2 MHz.
+ */
+#define MPU_TICKS_PER_SEC		(13000000 / 2)
+#else
+#define MPU_TICKS_PER_SEC		(12000000 / 2)
+#endif
+
+#define MPU_TIMER_TICK_PERIOD		((MPU_TICKS_PER_SEC / HZ) - 1)
 
 typedef struct {
 	u32 cntl;			/* CNTL_TIMER, R/W */
@@ -103,164 +120,98 @@
 	return timer->read_tim;
 }
 
+static inline void omap_mpu_timer_start(int nr, unsigned long load_val)
-static inline void omap_mpu_set_autoreset(int nr)
-{
-	volatile omap_mpu_timer_regs_t* timer = omap_mpu_timer_base(nr);
-
-	timer->cntl = timer->cntl | MPU_TIMER_AR;
-}
-
-static inline void omap_mpu_remove_autoreset(int nr)
-{
-	volatile omap_mpu_timer_regs_t* timer = omap_mpu_timer_base(nr);
-
-	timer->cntl = timer->cntl & ~MPU_TIMER_AR;
-}
-
-static inline void omap_mpu_timer_start(int nr, unsigned long load_val,
-					int autoreset)
 {
 	volatile omap_mpu_timer_regs_t* timer = omap_mpu_timer_base(nr);
-	unsigned int timerflags = (MPU_TIMER_CLOCK_ENABLE | MPU_TIMER_ST);
-
-	if (autoreset) timerflags |= MPU_TIMER_AR;
 
 	timer->cntl = MPU_TIMER_CLOCK_ENABLE;
 	udelay(1);
 	timer->load_tim = load_val;
         udelay(1);
+	timer->cntl = (MPU_TIMER_CLOCK_ENABLE | MPU_TIMER_AR | MPU_TIMER_ST);
-	timer->cntl = timerflags;
-}
-
-/*
- * ---------------------------------------------------------------------------
- * MPU timer 1 ... count down to zero, interrupt, reload
- * ---------------------------------------------------------------------------
- */
-static int omap_mpu_set_next_event(unsigned long cycles,
-				    struct clock_event_device *evt)
-{
-	omap_mpu_timer_start(0, cycles, 0);
-	return 0;
 }
 
+unsigned long omap_mpu_timer_ticks_to_usecs(unsigned long nr_ticks)
-static void omap_mpu_set_mode(enum clock_event_mode mode,
-			      struct clock_event_device *evt)
-{
-	switch (mode) {
-	case CLOCK_EVT_MODE_PERIODIC:
-		omap_mpu_set_autoreset(0);
-		break;
-	case CLOCK_EVT_MODE_ONESHOT:
-		omap_mpu_remove_autoreset(0);
-		break;
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-		break;
-	}
-}
-
-static struct clock_event_device clockevent_mpu_timer1 = {
-	.name		= "mpu_timer1",
-	.features       = CLOCK_EVT_FEAT_PERIODIC, CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
-	.set_next_event	= omap_mpu_set_next_event,
-	.set_mode	= omap_mpu_set_mode,
-};
-
-static irqreturn_t omap_mpu_timer1_interrupt(int irq, void *dev_id)
 {
+	unsigned long long nsec;
-	struct clock_event_device *evt = &clockevent_mpu_timer1;
-
-	evt->event_handler(evt);
 
+	nsec = cycles_2_ns((unsigned long long)nr_ticks);
+	return (unsigned long)nsec / 1000;
-	return IRQ_HANDLED;
 }
 
+/*
+ * Last processed system timer interrupt
+ */
+static unsigned long omap_mpu_timer_last = 0;
-static struct irqaction omap_mpu_timer1_irq = {
-	.name		= "mpu_timer1",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
-	.handler	= omap_mpu_timer1_interrupt,
-};
 
+/*
+ * Returns elapsed usecs since last system timer interrupt
+ */
+static unsigned long omap_mpu_timer_gettimeoffset(void)
-static __init void omap_init_mpu_timer(unsigned long rate)
 {
+	unsigned long now = 0 - omap_mpu_timer_read(0);
+	unsigned long elapsed = now - omap_mpu_timer_last;
-	set_cyc2ns_scale(rate / 1000);
-
-	setup_irq(INT_TIMER1, &omap_mpu_timer1_irq);
-	omap_mpu_timer_start(0, (rate / HZ) - 1, 1);
-
-	clockevent_mpu_timer1.mult = div_sc(rate, NSEC_PER_SEC,
-					    clockevent_mpu_timer1.shift);
-	clockevent_mpu_timer1.max_delta_ns =
-		clockevent_delta2ns(-1, &clockevent_mpu_timer1);
-	clockevent_mpu_timer1.min_delta_ns =
-		clockevent_delta2ns(1, &clockevent_mpu_timer1);
 
+	return omap_mpu_timer_ticks_to_usecs(elapsed);
-	clockevent_mpu_timer1.cpumask = cpumask_of_cpu(0);
-	clockevents_register_device(&clockevent_mpu_timer1);
 }
 
-
 /*
+ * Elapsed time between interrupts is calculated using timer0.
+ * Latency during the interrupt is calculated using timer1.
+ * Both timer0 and timer1 are counting at 6MHz (P2 6.5MHz).
- * ---------------------------------------------------------------------------
- * MPU timer 2 ... free running 32-bit clock source and scheduler clock
- * ---------------------------------------------------------------------------
  */
+static irqreturn_t omap_mpu_timer_interrupt(int irq, void *dev_id)
+{
+	unsigned long now, latency;
 
+	write_seqlock(&xtime_lock);
+	now = 0 - omap_mpu_timer_read(0);
+	latency = MPU_TICKS_PER_SEC / HZ - omap_mpu_timer_read(1);
+	omap_mpu_timer_last = now - latency;
+	timer_tick();
+	write_sequnlock(&xtime_lock);
-static unsigned long omap_mpu_timer2_overflows;
 
-static irqreturn_t omap_mpu_timer2_interrupt(int irq, void *dev_id)
-{
-	omap_mpu_timer2_overflows++;
 	return IRQ_HANDLED;
 }
 
+static struct irqaction omap_mpu_timer_irq = {
+	.name		= "mpu timer",
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.handler	= omap_mpu_timer_interrupt,
-static struct irqaction omap_mpu_timer2_irq = {
-	.name		= "mpu_timer2",
-	.flags		= IRQF_DISABLED,
-	.handler	= omap_mpu_timer2_interrupt,
 };
 
+static unsigned long omap_mpu_timer1_overflows;
+static irqreturn_t omap_mpu_timer1_interrupt(int irq, void *dev_id)
-static cycle_t mpu_read(void)
 {
+	omap_mpu_timer1_overflows++;
+	return IRQ_HANDLED;
-	return ~omap_mpu_timer_read(1);
 }
 
+static struct irqaction omap_mpu_timer1_irq = {
+	.name		= "mpu timer1 overflow",
+	.flags		= IRQF_DISABLED,
+	.handler	= omap_mpu_timer1_interrupt,
-static struct clocksource clocksource_mpu = {
-	.name		= "mpu_timer2",
-	.rating		= 300,
-	.read		= mpu_read,
-	.mask		= CLOCKSOURCE_MASK(32),
-	.shift		= 24,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
+static __init void omap_init_mpu_timer(void)
-static void __init omap_init_clocksource(unsigned long rate)
 {
+	set_cyc2ns_scale(MPU_TICKS_PER_SEC / 1000);
+	omap_timer.offset = omap_mpu_timer_gettimeoffset;
+	setup_irq(INT_TIMER1, &omap_mpu_timer1_irq);
+	setup_irq(INT_TIMER2, &omap_mpu_timer_irq);
+	omap_mpu_timer_start(0, 0xffffffff);
+	omap_mpu_timer_start(1, MPU_TIMER_TICK_PERIOD);
-	static char err[] __initdata = KERN_ERR
-			"%s: can't register clocksource!\n";
-
-	clocksource_mpu.mult
-		= clocksource_khz2mult(rate/1000, clocksource_mpu.shift);
-
-	setup_irq(INT_TIMER2, &omap_mpu_timer2_irq);
-	omap_mpu_timer_start(1, ~0, 1);
-
-	if (clocksource_register(&clocksource_mpu))
-		printk(err, clocksource_mpu.name);
 }
 
-
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
 unsigned long long sched_clock(void)
 {
+	unsigned long ticks = 0 - omap_mpu_timer_read(0);
-	unsigned long ticks = 0 - omap_mpu_timer_read(1);
 	unsigned long long ticks64;
 
+	ticks64 = omap_mpu_timer1_overflows;
-	ticks64 = omap_mpu_timer2_overflows;
 	ticks64 <<= 32;
 	ticks64 |= ticks;
 
@@ -274,21 +225,10 @@
  */
 static void __init omap_timer_init(void)
 {
+	omap_init_mpu_timer();
-	struct clk	*ck_ref = clk_get(NULL, "ck_ref");
-	unsigned long	rate;
-
-	BUG_ON(IS_ERR(ck_ref));
-
-	rate = clk_get_rate(ck_ref);
-	clk_put(ck_ref);
-
-	/* PTV = 0 */
-	rate /= 2;
-
-	omap_init_mpu_timer(rate);
-	omap_init_clocksource(rate);
 }
 
 struct sys_timer omap_timer = {
 	.init		= omap_timer_init,
+	.offset		= NULL,		/* Initialized later */
 };
reverted:
--- linux/arch/arm/mach-omap2/pm.c
+++ linux.orig/arch/arm/mach-omap2/pm.c
@@ -53,7 +53,7 @@
 {
 	local_irq_disable();
 	local_fiq_disable();
+	if (need_resched()) {
-	if (need_resched() || need_resched_delayed()) {
 		local_fiq_enable();
 		local_irq_enable();
 		return;
reverted:
--- linux/arch/arm/plat-omap/Kconfig
+++ linux.orig/arch/arm/plat-omap/Kconfig
@@ -11,7 +11,6 @@
 
 config ARCH_OMAP1
 	bool "TI OMAP1"
-	select GENERIC_CLOCKEVENTS
 
 config ARCH_OMAP2
 	bool "TI OMAP2"
reverted:
--- linux/arch/arm/plat-omap/clock.c
+++ linux.orig/arch/arm/plat-omap/clock.c
@@ -29,7 +29,7 @@
 
 static LIST_HEAD(clocks);
 static DEFINE_MUTEX(clocks_mutex);
+static DEFINE_SPINLOCK(clockfw_lock);
-static DEFINE_RAW_SPINLOCK(clockfw_lock);
 
 static struct clk_functions *arch_clock;
 
reverted:
--- linux/arch/arm/plat-omap/common.c
+++ linux.orig/arch/arm/plat-omap/common.c
@@ -156,53 +156,3 @@
 	return add_preferred_console("ttyS", line, opt);
 }
 console_initcall(omap_add_serial_console);
-
-
-/*
- * 32KHz clocksource ... always available, on pretty most chips except
- * OMAP 730 and 1510.  Other timers could be used as clocksources, with
- * higher resolution in free-running counter modes (e.g. 12 MHz xtal),
- * but systems won't necessarily want to spend resources that way.
- */
-
-#if defined(CONFIG_ARCH_OMAP16XX)
-#define TIMER_32K_SYNCHRONIZED		0xfffbc410
-#elif defined(CONFIG_ARCH_OMAP24XX)
-#define TIMER_32K_SYNCHRONIZED		0x48004010
-#endif
-
-#ifdef	TIMER_32K_SYNCHRONIZED
-
-#include <linux/clocksource.h>
-
-static cycle_t omap_32k_read(void)
-{
-	return omap_readl(TIMER_32K_SYNCHRONIZED);
-}
-
-static struct clocksource clocksource_32k = {
-	.name		= "32k_counter",
-	.rating		= 250,
-	.read		= omap_32k_read,
-	.mask		= CLOCKSOURCE_MASK(32),
-	.shift		= 10,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-};
-
-static int __init omap_init_clocksource_32k(void)
-{
-	static char err[] __initdata = KERN_ERR
-			"%s: can't register clocksource!\n";
-
-	if (cpu_is_omap16xx() || cpu_is_omap24xx()) {
-		clocksource_32k.mult = clocksource_hz2mult(32768,
-					    clocksource_32k.shift);
-
-		if (clocksource_register(&clocksource_32k))
-			printk(err, clocksource_32k.name);
-	}
-	return 0;
-}
-arch_initcall(omap_init_clocksource_32k);
-
-#endif	/* TIMER_32K_SYNCHRONIZED */
reverted:
--- linux/arch/arm/plat-omap/dma.c
+++ linux.orig/arch/arm/plat-omap/dma.c
@@ -982,7 +982,7 @@
 /*----------------------------------------------------------------------------*/
 
 static struct lcd_dma_info {
+	spinlock_t lock;
-	raw_spinlock_t lock;
 	int reserved;
 	void (* callback)(u16 status, void *data);
 	void *cb_data;
reverted:
--- linux/arch/arm/plat-omap/gpio.c
+++ linux.orig/arch/arm/plat-omap/gpio.c
@@ -120,7 +120,7 @@
 	u32 reserved_map;
 	u32 suspend_wakeup;
 	u32 saved_wakeup;
+	spinlock_t lock;
-	raw_spinlock_t lock;
 };
 
 #define METHOD_MPUIO		0
reverted:
--- linux/arch/arm/plat-omap/mux.c
+++ linux.orig/arch/arm/plat-omap/mux.c
@@ -56,7 +56,7 @@
  */
 int __init_or_module omap_cfg_reg(const unsigned long index)
 {
+	static DEFINE_SPINLOCK(mux_spin_lock);
-	static DEFINE_RAW_SPINLOCK(mux_spin_lock);
 
 	unsigned long flags;
 	struct pin_config *cfg;
reverted:
--- linux/arch/arm/plat-omap/timer32k.c
+++ linux.orig/arch/arm/plat-omap/timer32k.c
@@ -42,8 +42,6 @@
 #include <linux/spinlock.h>
 #include <linux/err.h>
 #include <linux/clk.h>
-#include <linux/clocksource.h>
-#include <linux/clockchips.h>
 
 #include <asm/system.h>
 #include <asm/hardware.h>
@@ -82,13 +80,13 @@
 #define OMAP1_32K_TIMER_TVR		0x00
 #define OMAP1_32K_TIMER_TCR		0x04
 
+#define OMAP_32K_TICKS_PER_HZ		(32768 / HZ)
-#define OMAP_32K_TICKS_PER_SEC		(32768)
 
 /*
  * TRM says 1 / HZ = ( TVR + 1) / 32768, so TRV = (32768 / HZ) - 1
  * so with HZ = 128, TVR = 255.
  */
+#define OMAP_32K_TIMER_TICK_PERIOD	((32768 / HZ) - 1)
-#define OMAP_32K_TIMER_TICK_PERIOD	((OMAP_32K_TICKS_PER_SEC / HZ) - 1)
 
 #define JIFFIES_TO_HW_TICKS(nr_jiffies, clock_rate)			\
 				(((nr_jiffies) * (clock_rate)) / HZ)
@@ -144,28 +142,6 @@
 
 #endif
 
-static void omap_32k_timer_set_mode(enum clock_event_mode mode,
-				    struct clock_event_device *evt)
-{
-	switch (mode) {
-	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_PERIODIC:
-		omap_32k_timer_start(OMAP_32K_TIMER_TICK_PERIOD);
-		break;
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-		omap_32k_timer_stop();
-		break;
-	}
-}
-
-static struct clock_event_device clockevent_32k_timer = {
-	.name		= "32k-timer",
-	.features       = CLOCK_EVT_FEAT_PERIODIC,
-	.shift		= 32,
-	.set_mode	= omap_32k_timer_set_mode,
-};
-
 /*
  * The 32KHz synchronized timer is an additional timer on 16xx.
  * It is always running.
@@ -195,6 +171,15 @@
 static unsigned long omap_32k_last_tick = 0;
 
 /*
+ * Returns elapsed usecs since last 32k timer interrupt
+ */
+static unsigned long omap_32k_timer_gettimeoffset(void)
+{
+	unsigned long now = omap_32k_sync_timer_read();
+	return omap_32k_ticks_to_usecs(now - omap_32k_last_tick);
+}
+
+/*
  * Returns current time from boot in nsecs. It's OK for this to wrap
  * around for now, as it's just a relative time stamp.
  */
@@ -203,16 +188,95 @@
 	return omap_32k_ticks_to_nsecs(omap_32k_sync_timer_read());
 }
 
+/*
+ * Timer interrupt for 32KHz timer. When dynamic tick is enabled, this
+ * function is also called from other interrupts to remove latency
+ * issues with dynamic tick. In the dynamic tick case, we need to lock
+ * with irqsave.
+ */
+static inline irqreturn_t _omap_32k_timer_interrupt(int irq, void *dev_id)
+{
+	unsigned long now;
+
+	omap_32k_timer_ack_irq();
+	now = omap_32k_sync_timer_read();
+
+	while ((signed long)(now - omap_32k_last_tick)
+						>= OMAP_32K_TICKS_PER_HZ) {
+		omap_32k_last_tick += OMAP_32K_TICKS_PER_HZ;
+		timer_tick();
+	}
+
+	/* Restart timer so we don't drift off due to modulo or dynamic tick.
+	 * By default we program the next timer to be continuous to avoid
+	 * latencies during high system load. During dynamic tick operation the
+	 * continuous timer can be overridden from pm_idle to be longer.
+	 */
+	omap_32k_timer_start(omap_32k_last_tick + OMAP_32K_TICKS_PER_HZ - now);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t omap_32k_timer_handler(int irq, void *dev_id)
+{
+	return _omap_32k_timer_interrupt(irq, dev_id);
+}
+
 static irqreturn_t omap_32k_timer_interrupt(int irq, void *dev_id)
 {
+	unsigned long flags;
-	struct clock_event_device *evt = &clockevent_32k_timer;
-	omap_32k_timer_ack_irq();
 
+	write_seqlock_irqsave(&xtime_lock, flags);
+	_omap_32k_timer_interrupt(irq, dev_id);
+	write_sequnlock_irqrestore(&xtime_lock, flags);
-	evt->event_handler(evt);
 
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_NO_IDLE_HZ
+/*
+ * Programs the next timer interrupt needed. Called when dynamic tick is
+ * enabled, and to reprogram the ticks to skip from pm_idle. Note that
+ * we can keep the timer continuous, and don't need to set it to run in
+ * one-shot mode. This is because the timer will get reprogrammed again
+ * after next interrupt.
+ */
+void omap_32k_timer_reprogram(unsigned long next_tick)
+{
+	unsigned long ticks = JIFFIES_TO_HW_TICKS(next_tick, 32768) + 1;
+	unsigned long now = omap_32k_sync_timer_read();
+	unsigned long idled = now - omap_32k_last_tick;
+
+	if (idled + 1 < ticks)
+		ticks -= idled;
+	else
+		ticks = 1;
+	omap_32k_timer_start(ticks);
+}
+
+static struct irqaction omap_32k_timer_irq;
+extern struct timer_update_handler timer_update;
+
+static int omap_32k_timer_enable_dyn_tick(void)
+{
+	/* No need to reprogram timer, just use the next interrupt */
+	return 0;
+}
+
+static int omap_32k_timer_disable_dyn_tick(void)
+{
+	omap_32k_timer_start(OMAP_32K_TIMER_TICK_PERIOD);
+	return 0;
+}
+
+static struct dyn_tick_timer omap_dyn_tick_timer = {
+	.enable		= omap_32k_timer_enable_dyn_tick,
+	.disable	= omap_32k_timer_disable_dyn_tick,
+	.reprogram	= omap_32k_timer_reprogram,
+	.handler	= omap_32k_timer_handler,
+};
+#endif	/* CONFIG_NO_IDLE_HZ */
+
 static struct irqaction omap_32k_timer_irq = {
 	.name		= "32KHz timer",
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
@@ -221,8 +285,13 @@
 
 static __init void omap_init_32k_timer(void)
 {
+#ifdef CONFIG_NO_IDLE_HZ
+	omap_timer.dyn_tick = &omap_dyn_tick_timer;
+#endif
+
 	if (cpu_class_is_omap1())
 		setup_irq(INT_OS_TIMER, &omap_32k_timer_irq);
+	omap_timer.offset  = omap_32k_timer_gettimeoffset;
 	omap_32k_last_tick = omap_32k_sync_timer_read();
 
 #ifdef CONFIG_ARCH_OMAP2
@@ -239,16 +308,7 @@
 	}
 #endif
 
+	omap_32k_timer_start(OMAP_32K_TIMER_TICK_PERIOD);
-	clockevent_32k_timer.mult = div_sc(OMAP_32K_TICKS_PER_SEC,
-					   NSEC_PER_SEC,
-					   clockevent_32k_timer.shift);
-	clockevent_32k_timer.max_delta_ns =
-		clockevent_delta2ns(0xfffffffe, &clockevent_32k_timer);
-	clockevent_32k_timer.min_delta_ns =
-		clockevent_delta2ns(1, &clockevent_32k_timer);
-
-	clockevent_32k_timer.cpumask = cpumask_of_cpu(0);
-	clockevents_register_device(&clockevent_32k_timer);
 }
 
 /*
@@ -266,4 +326,5 @@
 
 struct sys_timer omap_timer = {
 	.init		= omap_timer_init,
+	.offset		= NULL,		/* Initialized later */
 };
--
