Return-Path: <linux-kernel-owner+w=401wt.eu-S1030902AbXAZQzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030902AbXAZQzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030900AbXAZQzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:55:03 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:25679 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030902AbXAZQyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:54:35 -0500
Date: Fri, 26 Jan 2007 17:54:32 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [S390] ETR support.
Message-ID: <20070126165432.GW11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

[S390] ETR support.

This patch adds support for clock synchronization to an external time
reference (ETR). The external time reference sends an oscillator
signal and a synchronization signal every 2^20 microseconds to keep
the TOD clocks of all connected servers in sync. For availability
two ETR units can be connected to a machine. If the clock deviates
for more than the sync-check tolerance all cpus get a machine check
that indicates that the clock is out of sync. For the lovely details
how to get the clock back in sync see the code below.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/s390_ext.c    |    8 
 arch/s390/kernel/smp.c         |    3 
 arch/s390/kernel/time.c        | 1179 ++++++++++++++++++++++++++++++++++++++---
 arch/s390/kernel/vtime.c       |    8 
 arch/s390/lib/delay.c          |   48 +
 drivers/s390/block/dasd.c      |   13 
 drivers/s390/block/dasd_eckd.c |   44 -
 drivers/s390/cio/cio.c         |   17 
 drivers/s390/s390mach.c        |   17 
 drivers/s390/s390mach.h        |    3 
 include/asm-s390/etr.h         |  219 +++++++
 include/asm-s390/hardirq.h     |    2 
 include/asm-s390/timex.h       |   36 +
 13 files changed, 1488 insertions(+), 109 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/s390_ext.c linux-2.6-patched/arch/s390/kernel/s390_ext.c
--- linux-2.6/arch/s390/kernel/s390_ext.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/s390_ext.c	2007-01-26 17:29:31.000000000 +0100
@@ -125,14 +125,12 @@ void do_extint(struct pt_regs *regs, uns
 		 * Make sure that the i/o interrupt did not "overtake"
 		 * the last HZ timer interrupt.
 		 */
-		account_ticks();
+		account_ticks(S390_lowcore.int_clock);
 	kstat_cpu(smp_processor_id()).irqs[EXTERNAL_INTERRUPT]++;
         index = ext_hash(code);
 	for (p = ext_int_hash[index]; p; p = p->next) {
-		if (likely(p->code == code)) {
-			if (likely(p->handler))
-				p->handler(code);
-		}
+		if (likely(p->code == code))
+			p->handler(code);
 	}
 	irq_exit();
 	set_irq_regs(old_regs);
diff -urpN linux-2.6/arch/s390/kernel/smp.c linux-2.6-patched/arch/s390/kernel/smp.c
--- linux-2.6/arch/s390/kernel/smp.c	2007-01-26 17:29:31.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/smp.c	2007-01-26 17:29:31.000000000 +0100
@@ -457,9 +457,10 @@ int __devinit start_secondary(void *cpuv
         /* Setup the cpu */
         cpu_init();
 	preempt_disable();
-        /* init per CPU timer */
+	/* Enable TOD clock interrupts on the secondary cpu. */
         init_cpu_timer();
 #ifdef CONFIG_VIRT_TIMER
+	/* Enable cpu timer interrupts on the secondary cpu. */
         init_cpu_vtimer();
 #endif
 	/* Enable pfault pseudo page faults on this cpu. */
diff -urpN linux-2.6/arch/s390/kernel/time.c linux-2.6-patched/arch/s390/kernel/time.c
--- linux-2.6/arch/s390/kernel/time.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/time.c	2007-01-26 17:29:31.000000000 +0100
@@ -37,11 +37,15 @@
 #include <asm/irq.h>
 #include <asm/irq_regs.h>
 #include <asm/timer.h>
+#include <asm/etr.h>
 
 /* change this if you have some constant time drift */
 #define USECS_PER_JIFFY     ((unsigned long) 1000000/HZ)
 #define CLK_TICKS_PER_JIFFY ((unsigned long) USECS_PER_JIFFY << 12)
 
+/* The value of the TOD clock for 1.1.1970. */
+#define TOD_UNIX_EPOCH 0x7d91048bca000000ULL
+
 /*
  * Create a small time difference between the timer interrupts
  * on the different cpus to avoid lock contention.
@@ -51,6 +55,7 @@
 #define TICK_SIZE tick
 
 static ext_int_info_t ext_int_info_cc;
+static ext_int_info_t ext_int_etr_cc;
 static u64 init_timer_cc;
 static u64 jiffies_timer_cc;
 static u64 xtime_cc;
@@ -89,29 +94,21 @@ void tod_to_timeval(__u64 todval, struct
 #define s390_do_profile()	do { ; } while(0)
 #endif /* CONFIG_PROFILING */
 
-
 /*
- * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * Advance the per cpu tick counter up to the time given with the
+ * "time" argument. The per cpu update consists of accounting
+ * the virtual cpu time, calling update_process_times and calling
+ * the profiling hook. If xtime is before time it is advanced as well.
  */
-void account_ticks(void)
+void account_ticks(u64 time)
 {
-	__u64 tmp;
 	__u32 ticks;
+	__u64 tmp;
 
 	/* Calculate how many ticks have passed. */
-	if (S390_lowcore.int_clock < S390_lowcore.jiffy_timer) {
-		/*
-		 * We have to program the clock comparator even if
-		 * no tick has passed. That happens if e.g. an i/o
-		 * interrupt wakes up an idle processor that has
-		 * switched off its hz timer.
-		 */
-		tmp = S390_lowcore.jiffy_timer + CPU_DEVIATION;
-		asm volatile ("SCKC %0" : : "m" (tmp));
+	if (time < S390_lowcore.jiffy_timer)
 		return;
-	}
-	tmp = S390_lowcore.int_clock - S390_lowcore.jiffy_timer;
+	tmp = time - S390_lowcore.jiffy_timer;
 	if (tmp >= 2*CLK_TICKS_PER_JIFFY) {  /* more than two ticks ? */
 		ticks = __div(tmp, CLK_TICKS_PER_JIFFY) + 1;
 		S390_lowcore.jiffy_timer +=
@@ -124,10 +121,6 @@ void account_ticks(void)
 		S390_lowcore.jiffy_timer += CLK_TICKS_PER_JIFFY;
 	}
 
-	/* set clock comparator for next tick */
-	tmp = S390_lowcore.jiffy_timer + CPU_DEVIATION;
-        asm volatile ("SCKC %0" : : "m" (tmp));
-
 #ifdef CONFIG_SMP
 	/*
 	 * Do not rely on the boot cpu to do the calls to do_timer.
@@ -210,7 +203,7 @@ static inline void stop_hz_timer(void)
 		if (timer >= jiffies_timer_cc)
 			todval = timer;
 	}
-	asm volatile ("SCKC %0" : : "m" (todval));
+	set_clock_comparator(todval);
 }
 
 /*
@@ -223,7 +216,8 @@ static inline void start_hz_timer(void)
 
 	if (!cpu_isset(smp_processor_id(), nohz_cpu_mask))
 		return;
-	account_ticks();
+	account_ticks(get_clock());
+	set_clock_comparator(S390_lowcore.jiffy_timer + CPU_DEVIATION);
 	cpu_clear(smp_processor_id(), nohz_cpu_mask);
 }
 
@@ -254,21 +248,56 @@ static void __init nohz_init(void)
 #endif
 
 /*
- * Start the clock comparator on the current CPU.
+ * Set up per cpu jiffy timer and set the clock comparator.
+ */
+static void setup_jiffy_timer(void)
+{
+	/* Set up clock comparator to next jiffy. */
+	S390_lowcore.jiffy_timer =
+		jiffies_timer_cc + (jiffies_64 + 1) * CLK_TICKS_PER_JIFFY;
+	set_clock_comparator(S390_lowcore.jiffy_timer + CPU_DEVIATION);
+}
+
+/*
+ * Set up lowcore and control register of the current cpu to
+ * enable TOD clock and clock comparator interrupts.
  */
 void init_cpu_timer(void)
 {
-	unsigned long cr0;
-	__u64 timer;
+	setup_jiffy_timer();
 
-	timer = jiffies_timer_cc + jiffies_64 * CLK_TICKS_PER_JIFFY;
-	S390_lowcore.jiffy_timer = timer + CLK_TICKS_PER_JIFFY;
-	timer += CLK_TICKS_PER_JIFFY + CPU_DEVIATION;
-	asm volatile ("SCKC %0" : : "m" (timer));
-        /* allow clock comparator timer interrupt */
-	__ctl_store(cr0, 0, 0);
-        cr0 |= 0x800;
-	__ctl_load(cr0, 0, 0);
+	/* Enable clock comparator timer interrupt. */
+	__ctl_set_bit(0,11);
+
+	/* Always allow ETR external interrupts, even without an ETR. */
+	__ctl_set_bit(0, 4);
+}
+
+static void clock_comparator_interrupt(__u16 code)
+{
+	/* set clock comparator for next tick */
+	set_clock_comparator(S390_lowcore.jiffy_timer + CPU_DEVIATION);
+}
+
+static void etr_reset(void);
+static void etr_init(void);
+static void etr_ext_handler(__u16);
+
+/*
+ * Get the TOD clock running.
+ */
+static u64 __init reset_tod_clock(void)
+{
+	u64 time;
+
+	etr_reset();
+	if (store_clock(&time) == 0)
+		return time;
+	/* TOD clock not running. Set the clock to Unix Epoch. */
+	if (set_clock(TOD_UNIX_EPOCH) != 0 || store_clock(&time) != 0)
+		panic("TOD clock not operational.");
+
+	return TOD_UNIX_EPOCH;
 }
 
 static cycle_t read_tod_clock(void)
@@ -293,48 +322,31 @@ static struct clocksource clocksource_to
  */
 void __init time_init(void)
 {
-	__u64 set_time_cc;
-	int cc;
-
-        /* kick the TOD clock */
-	asm volatile(
-		"	stck	0(%2)\n"
-		"	ipm	%0\n"
-		"	srl	%0,28"
-		: "=d" (cc), "=m" (init_timer_cc)
-		: "a" (&init_timer_cc) : "cc");
-        switch (cc) {
-        case 0: /* clock in set state: all is fine */
-                break;
-        case 1: /* clock in non-set state: FIXME */
-                printk("time_init: TOD clock in non-set state\n");
-                break;
-        case 2: /* clock in error state: FIXME */
-                printk("time_init: TOD clock in error state\n");
-                break;
-        case 3: /* clock in stopped or not-operational state: FIXME */
-                printk("time_init: TOD clock stopped/non-operational\n");
-                break;
-        }
+	init_timer_cc = reset_tod_clock();
+	xtime_cc = init_timer_cc + CLK_TICKS_PER_JIFFY;
 	jiffies_timer_cc = init_timer_cc - jiffies_64 * CLK_TICKS_PER_JIFFY;
 
 	/* set xtime */
-	xtime_cc = init_timer_cc + CLK_TICKS_PER_JIFFY;
-	set_time_cc = init_timer_cc - 0x8126d60e46000000LL +
-		(0x3c26700LL*1000000*4096);
-        tod_to_timeval(set_time_cc, &xtime);
+	tod_to_timeval(init_timer_cc - TOD_UNIX_EPOCH, &xtime);
         set_normalized_timespec(&wall_to_monotonic,
                                 -xtime.tv_sec, -xtime.tv_nsec);
 
 	/* request the clock comparator external interrupt */
-	if (register_early_external_interrupt(0x1004, NULL,
+	if (register_early_external_interrupt(0x1004,
+					      clock_comparator_interrupt,
 					      &ext_int_info_cc) != 0)
                 panic("Couldn't request external interrupt 0x1004");
 
 	if (clocksource_register(&clocksource_tod) != 0)
 		panic("Could not register TOD clock source");
 
-        init_cpu_timer();
+	/* request the etr external interrupt */
+	if (register_early_external_interrupt(0x1406, etr_ext_handler,
+					      &ext_int_etr_cc) != 0)
+		panic("Couldn't request external interrupt 0x1406");
+
+	/* Enable TOD clock interrupts on the boot cpu. */
+	init_cpu_timer();
 
 #ifdef CONFIG_NO_IDLE_HZ
 	nohz_init();
@@ -343,5 +355,1048 @@ void __init time_init(void)
 #ifdef CONFIG_VIRT_TIMER
 	vtime_init();
 #endif
+	etr_init();
+}
+
+/*
+ * External Time Reference (ETR) code.
+ */
+static int etr_port0_online;
+static int etr_port1_online;
+
+static int __init early_parse_etr(char *p)
+{
+	if (strncmp(p, "off", 3) == 0)
+		etr_port0_online = etr_port1_online = 0;
+	else if (strncmp(p, "port0", 5) == 0)
+		etr_port0_online = 1;
+	else if (strncmp(p, "port1", 5) == 0)
+		etr_port1_online = 1;
+	else if (strncmp(p, "on", 2) == 0)
+		etr_port0_online = etr_port1_online = 1;
+	return 0;
+}
+early_param("etr", early_parse_etr);
+
+enum etr_event {
+	ETR_EVENT_PORT0_CHANGE,
+	ETR_EVENT_PORT1_CHANGE,
+	ETR_EVENT_PORT_ALERT,
+	ETR_EVENT_SYNC_CHECK,
+	ETR_EVENT_SWITCH_LOCAL,
+	ETR_EVENT_UPDATE,
+};
+
+enum etr_flags {
+	ETR_FLAG_ENOSYS,
+	ETR_FLAG_EACCES,
+	ETR_FLAG_STEAI,
+};
+
+/*
+ * Valid bit combinations of the eacr register are (x = don't care):
+ * e0 e1 dp p0 p1 ea es sl
+ *  0  0  x  0	0  0  0  0  initial, disabled state
+ *  0  0  x  0	1  1  0  0  port 1 online
+ *  0  0  x  1	0  1  0  0  port 0 online
+ *  0  0  x  1	1  1  0  0  both ports online
+ *  0  1  x  0	1  1  0  0  port 1 online and usable, ETR or PPS mode
+ *  0  1  x  0	1  1  0  1  port 1 online, usable and ETR mode
+ *  0  1  x  0	1  1  1  0  port 1 online, usable, PPS mode, in-sync
+ *  0  1  x  0	1  1  1  1  port 1 online, usable, ETR mode, in-sync
+ *  0  1  x  1	1  1  0  0  both ports online, port 1 usable
+ *  0  1  x  1	1  1  1  0  both ports online, port 1 usable, PPS mode, in-sync
+ *  0  1  x  1	1  1  1  1  both ports online, port 1 usable, ETR mode, in-sync
+ *  1  0  x  1	0  1  0  0  port 0 online and usable, ETR or PPS mode
+ *  1  0  x  1	0  1  0  1  port 0 online, usable and ETR mode
+ *  1  0  x  1	0  1  1  0  port 0 online, usable, PPS mode, in-sync
+ *  1  0  x  1	0  1  1  1  port 0 online, usable, ETR mode, in-sync
+ *  1  0  x  1	1  1  0  0  both ports online, port 0 usable
+ *  1  0  x  1	1  1  1  0  both ports online, port 0 usable, PPS mode, in-sync
+ *  1  0  x  1	1  1  1  1  both ports online, port 0 usable, ETR mode, in-sync
+ *  1  1  x  1	1  1  1  0  both ports online & usable, ETR, in-sync
+ *  1  1  x  1	1  1  1  1  both ports online & usable, ETR, in-sync
+ */
+static struct etr_eacr etr_eacr;
+static u64 etr_tolec;			/* time of last eacr update */
+static unsigned long etr_flags;
+static struct etr_aib etr_port0;
+static int etr_port0_uptodate;
+static struct etr_aib etr_port1;
+static int etr_port1_uptodate;
+static unsigned long etr_events;
+static struct timer_list etr_timer;
+static struct tasklet_struct etr_tasklet;
+static DEFINE_PER_CPU(atomic_t, etr_sync_word);
+
+static void etr_timeout(unsigned long dummy);
+static void etr_tasklet_fn(unsigned long dummy);
+
+/*
+ * The etr get_clock function. It will write the current clock value
+ * to the clock pointer and return 0 if the clock is in sync with the
+ * external time source. If the clock mode is local it will return
+ * -ENOSYS and -EAGAIN if the clock is not in sync with the external
+ * reference. This function is what ETR is all about..
+ */
+int get_sync_clock(unsigned long long *clock)
+{
+	atomic_t *sw_ptr;
+	unsigned int sw0, sw1;
+
+	sw_ptr = &get_cpu_var(etr_sync_word);
+	sw0 = atomic_read(sw_ptr);
+	*clock = get_clock();
+	sw1 = atomic_read(sw_ptr);
+	put_cpu_var(etr_sync_sync);
+	if (sw0 == sw1 && (sw0 & 0x80000000U))
+		/* Success: time is in sync. */
+		return 0;
+	if (test_bit(ETR_FLAG_ENOSYS, &etr_flags))
+		return -ENOSYS;
+	if (test_bit(ETR_FLAG_EACCES, &etr_flags))
+		return -EACCES;
+	return -EAGAIN;
+}
+EXPORT_SYMBOL(get_sync_clock);
+
+/*
+ * Make get_sync_clock return -EAGAIN.
+ */
+static void etr_disable_sync_clock(void *dummy)
+{
+	atomic_t *sw_ptr = &__get_cpu_var(etr_sync_word);
+	/*
+	 * Clear the in-sync bit 2^31. All get_sync_clock calls will
+	 * fail until the sync bit is turned back on. In addition
+	 * increase the "sequence" counter to avoid the race of an
+	 * etr event and the complete recovery against get_sync_clock.
+	 */
+	atomic_clear_mask(0x80000000, sw_ptr);
+	atomic_inc(sw_ptr);
+}
+
+/*
+ * Make get_sync_clock return 0 again.
+ * Needs to be called from a context disabled for preemption.
+ */
+static void etr_enable_sync_clock(void)
+{
+	atomic_t *sw_ptr = &__get_cpu_var(etr_sync_word);
+	atomic_set_mask(0x80000000, sw_ptr);
+}
+
+/*
+ * Reset ETR attachment.
+ */
+static void etr_reset(void)
+{
+	etr_eacr =  (struct etr_eacr) {
+		.e0 = 0, .e1 = 0, ._pad0 = 4, .dp = 0,
+		.p0 = 0, .p1 = 0, ._pad1 = 0, .ea = 0,
+		.es = 0, .sl = 0 };
+	if (etr_setr(&etr_eacr) == 0)
+		etr_tolec = get_clock();
+	else {
+		set_bit(ETR_FLAG_ENOSYS, &etr_flags);
+		if (etr_port0_online || etr_port1_online) {
+			printk(KERN_WARNING "Running on non ETR capable "
+			       "machine, only local mode available.\n");
+			etr_port0_online = etr_port1_online = 0;
+		}
+	}
+}
+
+static void etr_init(void)
+{
+	struct etr_aib aib;
+
+	if (test_bit(ETR_FLAG_ENOSYS, &etr_flags))
+		return;
+	/* Check if this machine has the steai instruction. */
+	if (etr_steai(&aib, ETR_STEAI_STEPPING_PORT) == 0)
+		set_bit(ETR_FLAG_STEAI, &etr_flags);
+	setup_timer(&etr_timer, etr_timeout, 0UL);
+	tasklet_init(&etr_tasklet, etr_tasklet_fn, 0);
+	if (!etr_port0_online && !etr_port1_online)
+		set_bit(ETR_FLAG_EACCES, &etr_flags);
+	if (etr_port0_online) {
+		set_bit(ETR_EVENT_PORT0_CHANGE, &etr_events);
+		tasklet_hi_schedule(&etr_tasklet);
+	}
+	if (etr_port1_online) {
+		set_bit(ETR_EVENT_PORT1_CHANGE, &etr_events);
+		tasklet_hi_schedule(&etr_tasklet);
+	}
+}
+
+/*
+ * Two sorts of ETR machine checks. The architecture reads:
+ * "When a machine-check niterruption occurs and if a switch-to-local or
+ *  ETR-sync-check interrupt request is pending but disabled, this pending
+ *  disabled interruption request is indicated and is cleared".
+ * Which means that we can get etr_switch_to_local events from the machine
+ * check handler although the interruption condition is disabled. Lovely..
+ */
+
+/*
+ * Switch to local machine check. This is called when the last usable
+ * ETR port goes inactive. After switch to local the clock is not in sync.
+ */
+void etr_switch_to_local(void)
+{
+	if (!etr_eacr.sl)
+		return;
+	etr_disable_sync_clock(NULL);
+	set_bit(ETR_EVENT_SWITCH_LOCAL, &etr_events);
+	tasklet_hi_schedule(&etr_tasklet);
+}
+
+/*
+ * ETR sync check machine check. This is called when the ETR OTE and the
+ * local clock OTE are farther apart than the ETR sync check tolerance.
+ * After a ETR sync check the clock is not in sync. The machine check
+ * is broadcasted to all cpus at the same time.
+ */
+void etr_sync_check(void)
+{
+	if (!etr_eacr.es)
+		return;
+	etr_disable_sync_clock(NULL);
+	set_bit(ETR_EVENT_SYNC_CHECK, &etr_events);
+	tasklet_hi_schedule(&etr_tasklet);
+}
+
+/*
+ * ETR external interrupt. There are two causes:
+ * 1) port state change, check the usability of the port
+ * 2) port alert, one of the ETR-data-validity bits (v1-v2 bits of the
+ *    sldr-status word) or ETR-data word 1 (edf1) or ETR-data word 3 (edf3)
+ *    or ETR-data word 4 (edf4) has changed.
+ */
+static void etr_ext_handler(__u16 code)
+{
+	struct etr_interruption_parameter *intparm =
+		(struct etr_interruption_parameter *) &S390_lowcore.ext_params;
+
+	if (intparm->pc0)
+		/* ETR port 0 state change. */
+		set_bit(ETR_EVENT_PORT0_CHANGE, &etr_events);
+	if (intparm->pc1)
+		/* ETR port 1 state change. */
+		set_bit(ETR_EVENT_PORT1_CHANGE, &etr_events);
+	if (intparm->eai)
+		/*
+		 * ETR port alert on either port 0, 1 or both.
+		 * Both ports are not up-to-date now.
+		 */
+		set_bit(ETR_EVENT_PORT_ALERT, &etr_events);
+	tasklet_hi_schedule(&etr_tasklet);
+}
+
+static void etr_timeout(unsigned long dummy)
+{
+	set_bit(ETR_EVENT_UPDATE, &etr_events);
+	tasklet_hi_schedule(&etr_tasklet);
+}
+
+/*
+ * Check if the etr mode is pss.
+ */
+static inline int etr_mode_is_pps(struct etr_eacr eacr)
+{
+	return eacr.es && !eacr.sl;
+}
+
+/*
+ * Check if the etr mode is etr.
+ */
+static inline int etr_mode_is_etr(struct etr_eacr eacr)
+{
+	return eacr.es && eacr.sl;
+}
+
+/*
+ * Check if the port can be used for TOD synchronization.
+ * For PPS mode the port has to receive OTEs. For ETR mode
+ * the port has to receive OTEs, the ETR stepping bit has to
+ * be zero and the validity bits for data frame 1, 2, and 3
+ * have to be 1.
+ */
+static int etr_port_valid(struct etr_aib *aib, int port)
+{
+	unsigned int psc;
+
+	/* Check that this port is receiving OTEs. */
+	if (aib->tsp == 0)
+		return 0;
+
+	psc = port ? aib->esw.psc1 : aib->esw.psc0;
+	if (psc == etr_lpsc_pps_mode)
+		return 1;
+	if (psc == etr_lpsc_operational_step)
+		return !aib->esw.y && aib->slsw.v1 &&
+			aib->slsw.v2 && aib->slsw.v3;
+	return 0;
+}
+
+/*
+ * Check if two ports are on the same network.
+ */
+static int etr_compare_network(struct etr_aib *aib1, struct etr_aib *aib2)
+{
+	// FIXME: any other fields we have to compare?
+	return aib1->edf1.net_id == aib2->edf1.net_id;
+}
+
+/*
+ * Wrapper for etr_stei that converts physical port states
+ * to logical port states to be consistent with the output
+ * of stetr (see etr_psc vs. etr_lpsc).
+ */
+static void etr_steai_cv(struct etr_aib *aib, unsigned int func)
+{
+	BUG_ON(etr_steai(aib, func) != 0);
+	/* Convert port state to logical port state. */
+	if (aib->esw.psc0 == 1)
+		aib->esw.psc0 = 2;
+	else if (aib->esw.psc0 == 0 && aib->esw.p == 0)
+		aib->esw.psc0 = 1;
+	if (aib->esw.psc1 == 1)
+		aib->esw.psc1 = 2;
+	else if (aib->esw.psc1 == 0 && aib->esw.p == 1)
+		aib->esw.psc1 = 1;
+}
+
+/*
+ * Check if the aib a2 is still connected to the same attachment as
+ * aib a1, the etv values differ by one and a2 is valid.
+ */
+static int etr_aib_follows(struct etr_aib *a1, struct etr_aib *a2, int p)
+{
+	int state_a1, state_a2;
+
+	/* Paranoia check: e0/e1 should better be the same. */
+	if (a1->esw.eacr.e0 != a2->esw.eacr.e0 ||
+	    a1->esw.eacr.e1 != a2->esw.eacr.e1)
+		return 0;
+
+	/* Still connected to the same etr ? */
+	state_a1 = p ? a1->esw.psc1 : a1->esw.psc0;
+	state_a2 = p ? a2->esw.psc1 : a2->esw.psc0;
+	if (state_a1 == etr_lpsc_operational_step) {
+		if (state_a2 != etr_lpsc_operational_step ||
+		    a1->edf1.net_id != a2->edf1.net_id ||
+		    a1->edf1.etr_id != a2->edf1.etr_id ||
+		    a1->edf1.etr_pn != a2->edf1.etr_pn)
+			return 0;
+	} else if (state_a2 != etr_lpsc_pps_mode)
+		return 0;
+
+	/* The ETV value of a2 needs to be ETV of a1 + 1. */
+	if (a1->edf2.etv + 1 != a2->edf2.etv)
+		return 0;
+
+	if (!etr_port_valid(a2, p))
+		return 0;
+
+	return 1;
+}
+
+/*
+ * The time is "clock". xtime is what we think the time is.
+ * Adjust the value by a multiple of jiffies and add the delta to ntp.
+ * "delay" is an approximation how long the synchronization took. If
+ * the time correction is positive, then "delay" is subtracted from
+ * the time difference and only the remaining part is passed to ntp.
+ */
+static void etr_adjust_time(unsigned long long clock, unsigned long long delay)
+{
+	unsigned long long delta, ticks;
+	struct timex adjust;
+
+	/*
+	 * We don't have to take the xtime lock because the cpu
+	 * executing etr_adjust_time is running disabled in
+	 * tasklet context and all other cpus are looping in
+	 * etr_sync_cpu_start.
+	 */
+	if (clock > xtime_cc) {
+		/* It is later than we thought. */
+		delta = ticks = clock - xtime_cc;
+		delta = ticks = (delta < delay) ? 0 : delta - delay;
+		delta -= do_div(ticks, CLK_TICKS_PER_JIFFY);
+		init_timer_cc = init_timer_cc + delta;
+		jiffies_timer_cc = jiffies_timer_cc + delta;
+		xtime_cc = xtime_cc + delta;
+		adjust.offset = ticks * (1000000 / HZ);
+	} else {
+		/* It is earlier than we thought. */
+		delta = ticks = xtime_cc - clock;
+		delta -= do_div(ticks, CLK_TICKS_PER_JIFFY);
+		init_timer_cc = init_timer_cc - delta;
+		jiffies_timer_cc = jiffies_timer_cc - delta;
+		xtime_cc = xtime_cc - delta;
+		adjust.offset = -ticks * (1000000 / HZ);
+	}
+	if (adjust.offset != 0) {
+		printk(KERN_NOTICE "etr: time adjusted by %li micro-seconds\n",
+		       adjust.offset);
+		adjust.modes = ADJ_OFFSET_SINGLESHOT;
+		do_adjtimex(&adjust);
+	}
+}
+
+static void etr_sync_cpu_start(void *dummy)
+{
+	int *in_sync = dummy;
+
+	etr_enable_sync_clock();
+	/*
+	 * This looks like a busy wait loop but it isn't. etr_sync_cpus
+	 * is called on all other cpus while the TOD clocks is stopped.
+	 * __udelay will stop the cpu on an enabled wait psw until the
+	 * TOD is running again.
+	 */
+	while (*in_sync == 0)
+		__udelay(1);
+	if (*in_sync != 1)
+		/* Didn't work. Clear per-cpu in sync bit again. */
+		etr_disable_sync_clock(NULL);
+	/*
+	 * This round of TOD syncing is done. Set the clock comparator
+	 * to the next tick and let the processor continue.
+	 */
+	setup_jiffy_timer();
+}
+
+static void etr_sync_cpu_end(void *dummy)
+{
+}
+
+/*
+ * Sync the TOD clock using the port refered to by aibp. This port
+ * has to be enabled and the other port has to be disabled. The
+ * last eacr update has to be more than 1.6 seconds in the past.
+ */
+static int etr_sync_clock(struct etr_aib *aib, int port)
+{
+	struct etr_aib *sync_port;
+	unsigned long long clock, delay;
+	int in_sync, follows;
+	int rc;
+
+	/* Check if the current aib is adjacent to the sync port aib. */
+	sync_port = (port == 0) ? &etr_port0 : &etr_port1;
+	follows = etr_aib_follows(sync_port, aib, port);
+	memcpy(sync_port, aib, sizeof(*aib));
+	if (!follows)
+		return -EAGAIN;
+
+	/*
+	 * Catch all other cpus and make them wait until we have
+	 * successfully synced the clock. smp_call_function will
+	 * return after all other cpus are in etr_sync_cpu_start.
+	 */
+	in_sync = 0;
+	preempt_disable();
+	smp_call_function(etr_sync_cpu_start,&in_sync,0,0);
+	local_irq_disable();
+	etr_enable_sync_clock();
+
+	/* Set clock to next OTE. */
+	__ctl_set_bit(14, 21);
+	__ctl_set_bit(0, 29);
+	clock = ((unsigned long long) (aib->edf2.etv + 1)) << 32;
+	if (set_clock(clock) == 0) {
+		__udelay(1);	/* Wait for the clock to start. */
+		__ctl_clear_bit(0, 29);
+		__ctl_clear_bit(14, 21);
+		etr_stetr(aib);
+		/* Adjust Linux timing variables. */
+		delay = (unsigned long long)
+			(aib->edf2.etv - sync_port->edf2.etv) << 32;
+		etr_adjust_time(clock, delay);
+		setup_jiffy_timer();
+		/* Verify that the clock is properly set. */
+		if (!etr_aib_follows(sync_port, aib, port)) {
+			/* Didn't work. */
+			etr_disable_sync_clock(NULL);
+			in_sync = -EAGAIN;
+			rc = -EAGAIN;
+		} else {
+			in_sync = 1;
+			rc = 0;
+		}
+	} else {
+		/* Could not set the clock ?!? */
+		__ctl_clear_bit(0, 29);
+		__ctl_clear_bit(14, 21);
+		etr_disable_sync_clock(NULL);
+		in_sync = -EAGAIN;
+		rc = -EAGAIN;
+	}
+	local_irq_enable();
+	smp_call_function(etr_sync_cpu_end,NULL,0,0);
+	preempt_enable();
+	return rc;
+}
+
+/*
+ * Handle the immediate effects of the different events.
+ * The port change event is used for online/offline changes.
+ */
+static struct etr_eacr etr_handle_events(struct etr_eacr eacr)
+{
+	if (test_and_clear_bit(ETR_EVENT_SYNC_CHECK, &etr_events))
+		eacr.es = 0;
+	if (test_and_clear_bit(ETR_EVENT_SWITCH_LOCAL, &etr_events))
+		eacr.es = eacr.sl = 0;
+	if (test_and_clear_bit(ETR_EVENT_PORT_ALERT, &etr_events))
+		etr_port0_uptodate = etr_port1_uptodate = 0;
+
+	if (test_and_clear_bit(ETR_EVENT_PORT0_CHANGE, &etr_events)) {
+		if (eacr.e0)
+			/*
+			 * Port change of an enabled port. We have to
+			 * assume that this can have caused an stepping
+			 * port switch.
+			 */
+			etr_tolec = get_clock();
+		eacr.p0 = etr_port0_online;
+		if (!eacr.p0)
+			eacr.e0 = 0;
+		etr_port0_uptodate = 0;
+	}
+	if (test_and_clear_bit(ETR_EVENT_PORT1_CHANGE, &etr_events)) {
+		if (eacr.e1)
+			/*
+			 * Port change of an enabled port. We have to
+			 * assume that this can have caused an stepping
+			 * port switch.
+			 */
+			etr_tolec = get_clock();
+		eacr.p1 = etr_port1_online;
+		if (!eacr.p1)
+			eacr.e1 = 0;
+		etr_port1_uptodate = 0;
+	}
+	clear_bit(ETR_EVENT_UPDATE, &etr_events);
+	return eacr;
+}
+
+/*
+ * Set up a timer that expires after the etr_tolec + 1.6 seconds if
+ * one of the ports needs an update.
+ */
+static void etr_set_tolec_timeout(unsigned long long now)
+{
+	unsigned long micros;
+
+	if ((!etr_eacr.p0 || etr_port0_uptodate) &&
+	    (!etr_eacr.p1 || etr_port1_uptodate))
+		return;
+	micros = (now > etr_tolec) ? ((now - etr_tolec) >> 12) : 0;
+	micros = (micros > 1600000) ? 0 : 1600000 - micros;
+	mod_timer(&etr_timer, jiffies + (micros * HZ) / 1000000 + 1);
+}
+
+/*
+ * Set up a time that expires after 1/2 second.
+ */
+static void etr_set_sync_timeout(void)
+{
+	mod_timer(&etr_timer, jiffies + HZ/2);
+}
+
+/*
+ * Update the aib information for one or both ports.
+ */
+static struct etr_eacr etr_handle_update(struct etr_aib *aib,
+					 struct etr_eacr eacr)
+{
+	/* With both ports disabled the aib information is useless. */
+	if (!eacr.e0 && !eacr.e1)
+		return eacr;
+
+	/* Update port0 or port1 with aib stored in etr_tasklet_fn. */
+	if (aib->esw.q == 0) {
+		/* Information for port 0 stored. */
+		if (eacr.p0 && !etr_port0_uptodate) {
+			etr_port0 = *aib;
+			if (etr_port0_online)
+				etr_port0_uptodate = 1;
+		}
+	} else {
+		/* Information for port 1 stored. */
+		if (eacr.p1 && !etr_port1_uptodate) {
+			etr_port1 = *aib;
+			if (etr_port0_online)
+				etr_port1_uptodate = 1;
+		}
+	}
+
+	/*
+	 * Do not try to get the alternate port aib if the clock
+	 * is not in sync yet.
+	 */
+	if (!eacr.es)
+		return eacr;
+
+	/*
+	 * If steai is available we can get the information about
+	 * the other port immediately. If only stetr is available the
+	 * data-port bit toggle has to be used.
+	 */
+	if (test_bit(ETR_FLAG_STEAI, &etr_flags)) {
+		if (eacr.p0 && !etr_port0_uptodate) {
+			etr_steai_cv(&etr_port0, ETR_STEAI_PORT_0);
+			etr_port0_uptodate = 1;
+		}
+		if (eacr.p1 && !etr_port1_uptodate) {
+			etr_steai_cv(&etr_port1, ETR_STEAI_PORT_1);
+			etr_port1_uptodate = 1;
+		}
+	} else {
+		/*
+		 * One port was updated above, if the other
+		 * port is not uptodate toggle dp bit.
+		 */
+		if ((eacr.p0 && !etr_port0_uptodate) ||
+		    (eacr.p1 && !etr_port1_uptodate))
+			eacr.dp ^= 1;
+		else
+			eacr.dp = 0;
+	}
+	return eacr;
+}
+
+/*
+ * Write new etr control register if it differs from the current one.
+ * Return 1 if etr_tolec has been updated as well.
+ */
+static void etr_update_eacr(struct etr_eacr eacr)
+{
+	int dp_changed;
+
+	if (memcmp(&etr_eacr, &eacr, sizeof(eacr)) == 0)
+		/* No change, return. */
+		return;
+	/*
+	 * The disable of an active port of the change of the data port
+	 * bit can/will cause a change in the data port.
+	 */
+	dp_changed = etr_eacr.e0 > eacr.e0 || etr_eacr.e1 > eacr.e1 ||
+		(etr_eacr.dp ^ eacr.dp) != 0;
+	etr_eacr = eacr;
+	etr_setr(&etr_eacr);
+	if (dp_changed)
+		etr_tolec = get_clock();
+}
+
+/*
+ * ETR tasklet. In this function you'll find the main logic. In
+ * particular this is the only function that calls etr_update_eacr(),
+ * it "controls" the etr control register.
+ */
+static void etr_tasklet_fn(unsigned long dummy)
+{
+	unsigned long long now;
+	struct etr_eacr eacr;
+	struct etr_aib aib;
+	int sync_port;
+
+	/* Create working copy of etr_eacr. */
+	eacr = etr_eacr;
+
+	/* Check for the different events and their immediate effects. */
+	eacr = etr_handle_events(eacr);
+
+	/* Check if ETR is supposed to be active. */
+	eacr.ea = eacr.p0 || eacr.p1;
+	if (!eacr.ea) {
+		/* Both ports offline. Reset everything. */
+		eacr.dp = eacr.es = eacr.sl = 0;
+		on_each_cpu(etr_disable_sync_clock, NULL, 0, 1);
+		del_timer_sync(&etr_timer);
+		etr_update_eacr(eacr);
+		set_bit(ETR_FLAG_EACCES, &etr_flags);
+		return;
+	}
+
+	/* Store aib to get the current ETR status word. */
+	BUG_ON(etr_stetr(&aib) != 0);
+	etr_port0.esw = etr_port1.esw = aib.esw;	/* Copy status word. */
+	now = get_clock();
+
+	/*
+	 * Update the port information if the last stepping port change
+	 * or data port change is older than 1.6 seconds.
+	 */
+	if (now >= etr_tolec + (1600000 << 12))
+		eacr = etr_handle_update(&aib, eacr);
+
+	/*
+	 * Select ports to enable. The prefered synchronization mode is PPS.
+	 * If a port can be enabled depends on a number of things:
+	 * 1) The port needs to be online and uptodate. A port is not
+	 *    disabled just because it is not uptodate, but it is only
+	 *    enabled if it is uptodate.
+	 * 2) The port needs to have the same mode (pps / etr).
+	 * 3) The port needs to be usable -> etr_port_valid() == 1
+	 * 4) To enable the second port the clock needs to be in sync.
+	 * 5) If both ports are useable and are ETR ports, the network id
+	 *    has to be the same.
+	 * The eacr.sl bit is used to indicate etr mode vs. pps mode.
+	 */
+	if (eacr.p0 && aib.esw.psc0 == etr_lpsc_pps_mode) {
+		eacr.sl = 0;
+		eacr.e0 = 1;
+		if (!etr_mode_is_pps(etr_eacr))
+			eacr.es = 0;
+		if (!eacr.es || !eacr.p1 || aib.esw.psc1 != etr_lpsc_pps_mode)
+			eacr.e1 = 0;
+		// FIXME: uptodate checks ?
+		else if (etr_port0_uptodate && etr_port1_uptodate)
+			eacr.e1 = 1;
+		sync_port = (etr_port0_uptodate &&
+			     etr_port_valid(&etr_port0, 0)) ? 0 : -1;
+		clear_bit(ETR_FLAG_EACCES, &etr_flags);
+	} else if (eacr.p1 && aib.esw.psc1 == etr_lpsc_pps_mode) {
+		eacr.sl = 0;
+		eacr.e0 = 0;
+		eacr.e1 = 1;
+		if (!etr_mode_is_pps(etr_eacr))
+			eacr.es = 0;
+		sync_port = (etr_port1_uptodate &&
+			     etr_port_valid(&etr_port1, 1)) ? 1 : -1;
+		clear_bit(ETR_FLAG_EACCES, &etr_flags);
+	} else if (eacr.p0 && aib.esw.psc0 == etr_lpsc_operational_step) {
+		eacr.sl = 1;
+		eacr.e0 = 1;
+		if (!etr_mode_is_etr(etr_eacr))
+			eacr.es = 0;
+		if (!eacr.es || !eacr.p1 ||
+		    aib.esw.psc1 != etr_lpsc_operational_alt)
+			eacr.e1 = 0;
+		else if (etr_port0_uptodate && etr_port1_uptodate &&
+			 etr_compare_network(&etr_port0, &etr_port1))
+			eacr.e1 = 1;
+		sync_port = (etr_port0_uptodate &&
+			     etr_port_valid(&etr_port0, 0)) ? 0 : -1;
+		clear_bit(ETR_FLAG_EACCES, &etr_flags);
+	} else if (eacr.p1 && aib.esw.psc1 == etr_lpsc_operational_step) {
+		eacr.sl = 1;
+		eacr.e0 = 0;
+		eacr.e1 = 1;
+		if (!etr_mode_is_etr(etr_eacr))
+			eacr.es = 0;
+		sync_port = (etr_port1_uptodate &&
+			     etr_port_valid(&etr_port1, 1)) ? 1 : -1;
+		clear_bit(ETR_FLAG_EACCES, &etr_flags);
+	} else {
+		/* Both ports not usable. */
+		eacr.es = eacr.sl = 0;
+		sync_port = -1;
+		set_bit(ETR_FLAG_EACCES, &etr_flags);
+	}
+
+	/*
+	 * If the clock is in sync just update the eacr and return.
+	 * If there is no valid sync port wait for a port update.
+	 */
+	if (eacr.es || sync_port < 0) {
+		etr_update_eacr(eacr);
+		etr_set_tolec_timeout(now);
+		return;
+	}
+
+	/*
+	 * Prepare control register for clock syncing
+	 * (reset data port bit, set sync check control.
+	 */
+	eacr.dp = 0;
+	eacr.es = 1;
+
+	/*
+	 * Update eacr and try to synchronize the clock. If the update
+	 * of eacr caused a stepping port switch (or if we have to
+	 * assume that a stepping port switch has occured) or the
+	 * clock syncing failed, reset the sync check control bit
+	 * and set up a timer to try again after 0.5 seconds
+	 */
+	etr_update_eacr(eacr);
+	if (now < etr_tolec + (1600000 << 12) ||
+	    etr_sync_clock(&aib, sync_port) != 0) {
+		/* Sync failed. Try again in 1/2 second. */
+		eacr.es = 0;
+		etr_update_eacr(eacr);
+		etr_set_sync_timeout();
+	} else
+		etr_set_tolec_timeout(now);
+}
+
+/*
+ * Sysfs interface functions
+ */
+static struct sysdev_class etr_sysclass = {
+	set_kset_name("etr")
+};
+
+static struct sys_device etr_port0_dev = {
+	.id	= 0,
+	.cls	= &etr_sysclass,
+};
+
+static struct sys_device etr_port1_dev = {
+	.id	= 1,
+	.cls	= &etr_sysclass,
+};
+
+/*
+ * ETR class attributes
+ */
+static ssize_t etr_stepping_port_show(struct sysdev_class *class, char *buf)
+{
+	return sprintf(buf, "%i\n", etr_port0.esw.p);
+}
+
+static SYSDEV_CLASS_ATTR(stepping_port, 0400, etr_stepping_port_show, NULL);
+
+static ssize_t etr_stepping_mode_show(struct sysdev_class *class, char *buf)
+{
+	char *mode_str;
+
+	if (etr_mode_is_pps(etr_eacr))
+		mode_str = "pps";
+	else if (etr_mode_is_etr(etr_eacr))
+		mode_str = "etr";
+	else
+		mode_str = "local";
+	return sprintf(buf, "%s\n", mode_str);
+}
+
+static SYSDEV_CLASS_ATTR(stepping_mode, 0400, etr_stepping_mode_show, NULL);
+
+/*
+ * ETR port attributes
+ */
+static inline struct etr_aib *etr_aib_from_dev(struct sys_device *dev)
+{
+	if (dev == &etr_port0_dev)
+		return etr_port0_online ? &etr_port0 : NULL;
+	else
+		return etr_port1_online ? &etr_port1 : NULL;
+}
+
+static ssize_t etr_online_show(struct sys_device *dev, char *buf)
+{
+	unsigned int online;
+
+	online = (dev == &etr_port0_dev) ? etr_port0_online : etr_port1_online;
+	return sprintf(buf, "%i\n", online);
+}
+
+static ssize_t etr_online_store(struct sys_device *dev,
+			      const char *buf, size_t count)
+{
+	unsigned int value;
+
+	value = simple_strtoul(buf, NULL, 0);
+	if (value != 0 && value != 1)
+		return -EINVAL;
+	if (test_bit(ETR_FLAG_ENOSYS, &etr_flags))
+		return -ENOSYS;
+	if (dev == &etr_port0_dev) {
+		if (etr_port0_online == value)
+			return count;	/* Nothing to do. */
+		etr_port0_online = value;
+		set_bit(ETR_EVENT_PORT0_CHANGE, &etr_events);
+		tasklet_hi_schedule(&etr_tasklet);
+	} else {
+		if (etr_port1_online == value)
+			return count;	/* Nothing to do. */
+		etr_port1_online = value;
+		set_bit(ETR_EVENT_PORT1_CHANGE, &etr_events);
+		tasklet_hi_schedule(&etr_tasklet);
+	}
+	return count;
+}
+
+static SYSDEV_ATTR(online, 0600, etr_online_show, etr_online_store);
+
+static ssize_t etr_stepping_control_show(struct sys_device *dev, char *buf)
+{
+	return sprintf(buf, "%i\n", (dev == &etr_port0_dev) ?
+		       etr_eacr.e0 : etr_eacr.e1);
+}
+
+static SYSDEV_ATTR(stepping_control, 0400, etr_stepping_control_show, NULL);
+
+static ssize_t etr_mode_code_show(struct sys_device *dev, char *buf)
+{
+	if (!etr_port0_online && !etr_port1_online)
+		/* Status word is not uptodate if both ports are offline. */
+		return -ENODATA;
+	return sprintf(buf, "%i\n", (dev == &etr_port0_dev) ?
+		       etr_port0.esw.psc0 : etr_port0.esw.psc1);
+}
+
+static SYSDEV_ATTR(state_code, 0400, etr_mode_code_show, NULL);
+
+static ssize_t etr_untuned_show(struct sys_device *dev, char *buf)
+{
+	struct etr_aib *aib = etr_aib_from_dev(dev);
+
+	if (!aib || !aib->slsw.v1)
+		return -ENODATA;
+	return sprintf(buf, "%i\n", aib->edf1.u);
+}
+
+static SYSDEV_ATTR(untuned, 0400, etr_untuned_show, NULL);
+
+static ssize_t etr_network_id_show(struct sys_device *dev, char *buf)
+{
+	struct etr_aib *aib = etr_aib_from_dev(dev);
+
+	if (!aib || !aib->slsw.v1)
+		return -ENODATA;
+	return sprintf(buf, "%i\n", aib->edf1.net_id);
+}
+
+static SYSDEV_ATTR(network, 0400, etr_network_id_show, NULL);
+
+static ssize_t etr_id_show(struct sys_device *dev, char *buf)
+{
+	struct etr_aib *aib = etr_aib_from_dev(dev);
+
+	if (!aib || !aib->slsw.v1)
+		return -ENODATA;
+	return sprintf(buf, "%i\n", aib->edf1.etr_id);
+}
+
+static SYSDEV_ATTR(id, 0400, etr_id_show, NULL);
+
+static ssize_t etr_port_number_show(struct sys_device *dev, char *buf)
+{
+	struct etr_aib *aib = etr_aib_from_dev(dev);
+
+	if (!aib || !aib->slsw.v1)
+		return -ENODATA;
+	return sprintf(buf, "%i\n", aib->edf1.etr_pn);
+}
+
+static SYSDEV_ATTR(port, 0400, etr_port_number_show, NULL);
+
+static ssize_t etr_coupled_show(struct sys_device *dev, char *buf)
+{
+	struct etr_aib *aib = etr_aib_from_dev(dev);
+
+	if (!aib || !aib->slsw.v3)
+		return -ENODATA;
+	return sprintf(buf, "%i\n", aib->edf3.c);
+}
+
+static SYSDEV_ATTR(coupled, 0400, etr_coupled_show, NULL);
+
+static ssize_t etr_local_time_show(struct sys_device *dev, char *buf)
+{
+	struct etr_aib *aib = etr_aib_from_dev(dev);
+
+	if (!aib || !aib->slsw.v3)
+		return -ENODATA;
+	return sprintf(buf, "%i\n", aib->edf3.blto);
+}
+
+static SYSDEV_ATTR(local_time, 0400, etr_local_time_show, NULL);
+
+static ssize_t etr_utc_offset_show(struct sys_device *dev, char *buf)
+{
+	struct etr_aib *aib = etr_aib_from_dev(dev);
+
+	if (!aib || !aib->slsw.v3)
+		return -ENODATA;
+	return sprintf(buf, "%i\n", aib->edf3.buo);
+}
+
+static SYSDEV_ATTR(utc_offset, 0400, etr_utc_offset_show, NULL);
+
+static struct sysdev_attribute *etr_port_attributes[] = {
+	&attr_online,
+	&attr_stepping_control,
+	&attr_state_code,
+	&attr_untuned,
+	&attr_network,
+	&attr_id,
+	&attr_port,
+	&attr_coupled,
+	&attr_local_time,
+	&attr_utc_offset,
+	NULL
+};
+
+static int __init etr_register_port(struct sys_device *dev)
+{
+	struct sysdev_attribute **attr;
+	int rc;
+
+	rc = sysdev_register(dev);
+	if (rc)
+		goto out;
+	for (attr = etr_port_attributes; *attr; attr++) {
+		rc = sysdev_create_file(dev, *attr);
+		if (rc)
+			goto out_unreg;
+	}
+	return 0;
+out_unreg:
+	for (; attr >= etr_port_attributes; attr--)
+		sysdev_remove_file(dev, *attr);
+	sysdev_unregister(dev);
+out:
+	return rc;
+}
+
+static void __init etr_unregister_port(struct sys_device *dev)
+{
+	struct sysdev_attribute **attr;
+
+	for (attr = etr_port_attributes; *attr; attr++)
+		sysdev_remove_file(dev, *attr);
+	sysdev_unregister(dev);
+}
+
+static int __init etr_init_sysfs(void)
+{
+	int rc;
+
+	rc = sysdev_class_register(&etr_sysclass);
+	if (rc)
+		goto out;
+	rc = sysdev_class_create_file(&etr_sysclass, &attr_stepping_port);
+	if (rc)
+		goto out_unreg_class;
+	rc = sysdev_class_create_file(&etr_sysclass, &attr_stepping_mode);
+	if (rc)
+		goto out_remove_stepping_port;
+	rc = etr_register_port(&etr_port0_dev);
+	if (rc)
+		goto out_remove_stepping_mode;
+	rc = etr_register_port(&etr_port1_dev);
+	if (rc)
+		goto out_remove_port0;
+	return 0;
+
+out_remove_port0:
+	etr_unregister_port(&etr_port0_dev);
+out_remove_stepping_mode:
+	sysdev_class_remove_file(&etr_sysclass, &attr_stepping_mode);
+out_remove_stepping_port:
+	sysdev_class_remove_file(&etr_sysclass, &attr_stepping_port);
+out_unreg_class:
+	sysdev_class_unregister(&etr_sysclass);
+out:
+	return rc;
 }
 
+device_initcall(etr_init_sysfs);
diff -urpN linux-2.6/arch/s390/kernel/vtime.c linux-2.6-patched/arch/s390/kernel/vtime.c
--- linux-2.6/arch/s390/kernel/vtime.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/vtime.c	2007-01-26 17:29:31.000000000 +0100
@@ -524,16 +524,15 @@ EXPORT_SYMBOL(del_virt_timer);
 void init_cpu_vtimer(void)
 {
 	struct vtimer_queue *vt_list;
-	unsigned long cr0;
 
 	/* kick the virtual timer */
 	S390_lowcore.exit_timer = VTIMER_MAX_SLICE;
 	S390_lowcore.last_update_timer = VTIMER_MAX_SLICE;
 	asm volatile ("SPT %0" : : "m" (S390_lowcore.last_update_timer));
 	asm volatile ("STCK %0" : "=m" (S390_lowcore.last_update_clock));
-	__ctl_store(cr0, 0, 0);
-	cr0 |= 0x400;
-	__ctl_load(cr0, 0, 0);
+
+	/* enable cpu timer interrupts */
+	__ctl_set_bit(0,10);
 
 	vt_list = &per_cpu(virt_cpu_timer, smp_processor_id());
 	INIT_LIST_HEAD(&vt_list->list);
@@ -572,6 +571,7 @@ void __init vtime_init(void)
 	if (register_idle_notifier(&vtimer_idle_nb))
 		panic("Couldn't register idle notifier");
 
+	/* Enable cpu timer interrupts on the boot cpu. */
 	init_cpu_vtimer();
 }
 
diff -urpN linux-2.6/arch/s390/lib/delay.c linux-2.6-patched/arch/s390/lib/delay.c
--- linux-2.6/arch/s390/lib/delay.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/lib/delay.c	2007-01-26 17:29:31.000000000 +0100
@@ -1,5 +1,5 @@
 /*
- *  arch/s390/kernel/delay.c
+ *  arch/s390/lib/delay.c
  *    Precise Delay Loops for S390
  *
  *  S390 version
@@ -13,10 +13,8 @@
 
 #include <linux/sched.h>
 #include <linux/delay.h>
-
-#ifdef CONFIG_SMP
-#include <asm/smp.h>
-#endif
+#include <linux/timex.h>
+#include <linux/irqflags.h>
 
 void __delay(unsigned long loops)
 {
@@ -31,17 +29,39 @@ void __delay(unsigned long loops)
 }
 
 /*
- * Waits for 'usecs' microseconds using the tod clock, giving up the time slice
- * of the virtual PU inbetween to avoid congestion.
+ * Waits for 'usecs' microseconds using the TOD clock comparator.
  */
 void __udelay(unsigned long usecs)
 {
-	uint64_t start_cc;
+	u64 end, time, jiffy_timer = 0;
+	unsigned long flags, cr0, mask, dummy;
+
+	local_irq_save(flags);
+	if (raw_irqs_disabled_flags(flags)) {
+		jiffy_timer = S390_lowcore.jiffy_timer;
+		S390_lowcore.jiffy_timer = -1ULL - (4096 << 12);
+		__ctl_store(cr0, 0, 0);
+		dummy = (cr0 & 0xffff00e0) | 0x00000800;
+		__ctl_load(dummy , 0, 0);
+		mask = psw_kernel_bits | PSW_MASK_WAIT | PSW_MASK_EXT;
+	} else
+		mask = psw_kernel_bits | PSW_MASK_WAIT |
+			PSW_MASK_EXT | PSW_MASK_IO;
+
+	end = get_clock() + ((u64) usecs << 12);
+	do {
+		time = end < S390_lowcore.jiffy_timer ?
+			end : S390_lowcore.jiffy_timer;
+		set_clock_comparator(time);
+		trace_hardirqs_on();
+		__load_psw_mask(mask);
+		local_irq_disable();
+	} while (get_clock() < end);
 
-        if (usecs == 0)
-                return;
-	start_cc = get_clock();
-        do {
-		cpu_relax();
-	} while (((get_clock() - start_cc)/4096) < usecs);
+	if (raw_irqs_disabled_flags(flags)) {
+		__ctl_load(cr0, 0, 0);
+		S390_lowcore.jiffy_timer = jiffy_timer;
+	}
+	set_clock_comparator(S390_lowcore.jiffy_timer);
+	local_irq_restore(flags);
 }
diff -urpN linux-2.6/drivers/s390/block/dasd.c linux-2.6-patched/drivers/s390/block/dasd.c
--- linux-2.6/drivers/s390/block/dasd.c	2007-01-26 17:28:04.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd.c	2007-01-26 17:29:31.000000000 +0100
@@ -1232,6 +1232,19 @@ __dasd_process_blk_queue(struct dasd_dev
 		if (IS_ERR(cqr)) {
 			if (PTR_ERR(cqr) == -ENOMEM)
 				break;	/* terminate request queue loop */
+			if (PTR_ERR(cqr) == -EAGAIN) {
+				/*
+				 * The current request cannot be build right
+				 * now, we have to try later. If this request
+				 * is the head-of-queue we stop the device
+				 * for 1/2 second.
+				 */
+				if (!list_empty(&device->ccw_queue))
+					break;
+				device->stopped |= DASD_STOPPED_PENDING;
+				dasd_set_timer(device, HZ/2);
+				break;
+			}
 			DBF_DEV_EVENT(DBF_ERR, device,
 				      "CCW creation failed (rc=%ld) "
 				      "on request %p",
diff -urpN linux-2.6/drivers/s390/block/dasd_eckd.c linux-2.6-patched/drivers/s390/block/dasd_eckd.c
--- linux-2.6/drivers/s390/block/dasd_eckd.c	2007-01-26 17:28:04.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd_eckd.c	2007-01-26 17:29:31.000000000 +0100
@@ -204,37 +204,39 @@ recs_per_track(struct dasd_eckd_characte
 	return 0;
 }
 
-static inline void
+static inline int
 check_XRC (struct ccw1         *de_ccw,
            struct DE_eckd_data *data,
            struct dasd_device  *device)
 {
         struct dasd_eckd_private *private;
+	int rc;
 
         private = (struct dasd_eckd_private *) device->private;
+	if (!private->rdc_data.facilities.XRC_supported)
+		return 0;
 
         /* switch on System Time Stamp - needed for XRC Support */
-        if (private->rdc_data.facilities.XRC_supported) {
-
-                data->ga_extended |= 0x08; /* switch on 'Time Stamp Valid'   */
-                data->ga_extended |= 0x02; /* switch on 'Extended Parameter' */
-
-                data->ep_sys_time = get_clock ();
-
-                de_ccw->count = sizeof (struct DE_eckd_data);
-		de_ccw->flags |= CCW_FLAG_SLI;
-        }
+	data->ga_extended |= 0x08; /* switch on 'Time Stamp Valid'   */
+	data->ga_extended |= 0x02; /* switch on 'Extended Parameter' */
 
-        return;
+	rc = get_sync_clock(&data->ep_sys_time);
+	/* Ignore return code if sync clock is switched off. */
+	if (rc == -ENOSYS || rc == -EACCES)
+		rc = 0;
 
-} /* end check_XRC */
+	de_ccw->count = sizeof (struct DE_eckd_data);
+	de_ccw->flags |= CCW_FLAG_SLI;
+	return rc;
+}
 
-static inline void
+static inline int
 define_extent(struct ccw1 * ccw, struct DE_eckd_data * data, int trk,
 	      int totrk, int cmd, struct dasd_device * device)
 {
 	struct dasd_eckd_private *private;
 	struct ch_t geo, beg, end;
+	int rc = 0;
 
 	private = (struct dasd_eckd_private *) device->private;
 
@@ -263,12 +265,12 @@ define_extent(struct ccw1 * ccw, struct 
 	case DASD_ECKD_CCW_WRITE_KD_MT:
 		data->mask.perm = 0x02;
 		data->attributes.operation = private->attrib.operation;
-                check_XRC (ccw, data, device);
+		rc = check_XRC (ccw, data, device);
 		break;
 	case DASD_ECKD_CCW_WRITE_CKD:
 	case DASD_ECKD_CCW_WRITE_CKD_MT:
 		data->attributes.operation = DASD_BYPASS_CACHE;
-                check_XRC (ccw, data, device);
+		rc = check_XRC (ccw, data, device);
 		break;
 	case DASD_ECKD_CCW_ERASE:
 	case DASD_ECKD_CCW_WRITE_HOME_ADDRESS:
@@ -276,7 +278,7 @@ define_extent(struct ccw1 * ccw, struct 
 		data->mask.perm = 0x3;
 		data->mask.auth = 0x1;
 		data->attributes.operation = DASD_BYPASS_CACHE;
-                check_XRC (ccw, data, device);
+		rc = check_XRC (ccw, data, device);
 		break;
 	default:
 		DEV_MESSAGE(KERN_ERR, device, "unknown opcode 0x%x", cmd);
@@ -312,6 +314,7 @@ define_extent(struct ccw1 * ccw, struct 
 	data->beg_ext.head = beg.head;
 	data->end_ext.cyl = end.cyl;
 	data->end_ext.head = end.head;
+	return rc;
 }
 
 static inline void
@@ -1200,7 +1203,12 @@ dasd_eckd_build_cp(struct dasd_device * 
 		return cqr;
 	ccw = cqr->cpaddr;
 	/* First ccw is define extent. */
-	define_extent(ccw++, cqr->data, first_trk, last_trk, cmd, device);
+	if (define_extent(ccw++, cqr->data, first_trk,
+			  last_trk, cmd, device) == -EAGAIN) {
+		/* Clock not in sync and XRC is enabled. Try again later. */
+		dasd_sfree_request(cqr, device);
+		return ERR_PTR(-EAGAIN);
+	}
 	/* Build locate_record+read/write/ccws. */
 	idaws = (unsigned long *) (cqr->data + sizeof(struct DE_eckd_data));
 	LO_data = (struct LO_eckd_data *) (idaws + cidaw);
diff -urpN linux-2.6/drivers/s390/cio/cio.c linux-2.6-patched/drivers/s390/cio/cio.c
--- linux-2.6/drivers/s390/cio/cio.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/cio.c	2007-01-26 17:29:31.000000000 +0100
@@ -646,7 +646,7 @@ do_IRQ (struct pt_regs *regs)
 		 * Make sure that the i/o interrupt did not "overtake"
 		 * the last HZ timer interrupt.
 		 */
-		account_ticks();
+		account_ticks(S390_lowcore.int_clock);
 	/*
 	 * Get interrupt information from lowcore
 	 */
@@ -850,6 +850,19 @@ __disable_subchannel_easy(struct subchan
 	return -EBUSY; /* uhm... */
 }
 
+/* we can't use the normal udelay here, since it enables external interrupts */
+
+static void udelay_reset(unsigned long usecs)
+{
+	uint64_t start_cc, end_cc;
+
+	asm volatile ("STCK %0" : "=m" (start_cc));
+	do {
+		cpu_relax();
+		asm volatile ("STCK %0" : "=m" (end_cc));
+	} while (((end_cc - start_cc)/4096) < usecs);
+}
+
 static inline int
 __clear_subchannel_easy(struct subchannel_id schid)
 {
@@ -865,7 +878,7 @@ __clear_subchannel_easy(struct subchanne
 			if (schid_equal(&ti.schid, &schid))
 				return 0;
 		}
-		udelay(100);
+		udelay_reset(100);
 	}
 	return -EBUSY;
 }
diff -urpN linux-2.6/drivers/s390/s390mach.c linux-2.6-patched/drivers/s390/s390mach.c
--- linux-2.6/drivers/s390/s390mach.c	2007-01-26 17:27:48.000000000 +0100
+++ linux-2.6-patched/drivers/s390/s390mach.c	2007-01-26 17:29:31.000000000 +0100
@@ -15,7 +15,7 @@
 #include <linux/time.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
-
+#include <asm/etr.h>
 #include <asm/lowcore.h>
 #include <asm/cio.h>
 #include "cio/cio.h"
@@ -466,6 +466,19 @@ s390_do_machine_check(struct pt_regs *re
 			s390_handle_damage("unable to revalidate registers.");
 	}
 
+	if (mci->cd) {
+		/* Timing facility damage */
+		s390_handle_damage("TOD clock damaged");
+	}
+
+	if (mci->ed && mci->ec) {
+		/* External damage */
+		if (S390_lowcore.external_damage_code & (1U << ED_ETR_SYNC))
+			etr_sync_check();
+		if (S390_lowcore.external_damage_code & (1U << ED_ETR_SWITCH))
+			etr_switch_to_local();
+	}
+
 	if (mci->se)
 		/* Storage error uncorrected */
 		s390_handle_damage("received storage error uncorrected "
@@ -504,7 +517,7 @@ static int
 machine_check_init(void)
 {
 	init_MUTEX_LOCKED(&m_sem);
-	ctl_clear_bit(14, 25);	/* disable external damage MCH */
+	ctl_set_bit(14, 25);	/* enable external damage MCH */
 	ctl_set_bit(14, 27);    /* enable system recovery MCH */
 #ifdef CONFIG_MACHCHK_WARNING
 	ctl_set_bit(14, 24);	/* enable warning MCH */
diff -urpN linux-2.6/drivers/s390/s390mach.h linux-2.6-patched/drivers/s390/s390mach.h
--- linux-2.6/drivers/s390/s390mach.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/s390mach.h	2007-01-26 17:29:31.000000000 +0100
@@ -102,4 +102,7 @@ static inline int stcrw(struct crw *pcrw
 	return ccode;
 }
 
+#define ED_ETR_SYNC	12	/* External damage ETR sync check */
+#define ED_ETR_SWITCH	13	/* External damage ETR switch to local */
+
 #endif /* __s390mach */
diff -urpN linux-2.6/include/asm-s390/etr.h linux-2.6-patched/include/asm-s390/etr.h
--- linux-2.6/include/asm-s390/etr.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/etr.h	2007-01-26 17:29:31.000000000 +0100
@@ -0,0 +1,219 @@
+/*
+ *  include/asm-s390/etr.h
+ *
+ *  Copyright IBM Corp. 2006
+ *  Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com)
+ */
+#ifndef __S390_ETR_H
+#define __S390_ETR_H
+
+/* ETR attachment control register */
+struct etr_eacr {
+	unsigned int e0		: 1;	/* port 0 stepping control */
+	unsigned int e1		: 1;	/* port 1 stepping control */
+	unsigned int _pad0	: 5;	/* must be 00100 */
+	unsigned int dp		: 1;	/* data port control */
+	unsigned int p0		: 1;	/* port 0 change recognition control */
+	unsigned int p1		: 1;	/* port 1 change recognition control */
+	unsigned int _pad1	: 3;	/* must be 000 */
+	unsigned int ea		: 1;	/* ETR alert control */
+	unsigned int es		: 1;	/* ETR sync check control */
+	unsigned int sl		: 1;	/* switch to local control */
+} __attribute__ ((packed));
+
+/* Port state returned by steai */
+enum etr_psc {
+	etr_psc_operational = 0,
+	etr_psc_semi_operational = 1,
+	etr_psc_protocol_error =  4,
+	etr_psc_no_symbols = 8,
+	etr_psc_no_signal = 12,
+	etr_psc_pps_mode = 13
+};
+
+/* Logical port state returned by stetr */
+enum etr_lpsc {
+	etr_lpsc_operational_step = 0,
+	etr_lpsc_operational_alt = 1,
+	etr_lpsc_semi_operational = 2,
+	etr_lpsc_protocol_error =  4,
+	etr_lpsc_no_symbol_sync = 8,
+	etr_lpsc_no_signal = 12,
+	etr_lpsc_pps_mode = 13
+};
+
+/* ETR status words */
+struct etr_esw {
+	struct etr_eacr eacr;		/* attachment control register */
+	unsigned int y		: 1;	/* stepping mode */
+	unsigned int _pad0	: 5;	/* must be 00000 */
+	unsigned int p		: 1;	/* stepping port number */
+	unsigned int q		: 1;	/* data port number */
+	unsigned int psc0	: 4;	/* port 0 state code */
+	unsigned int psc1	: 4;	/* port 1 state code */
+} __attribute__ ((packed));
+
+/* Second level data register status word */
+struct etr_slsw {
+	unsigned int vv1	: 1;	/* copy of validity bit data frame 1 */
+	unsigned int vv2	: 1;	/* copy of validity bit data frame 2 */
+	unsigned int vv3	: 1;	/* copy of validity bit data frame 3 */
+	unsigned int vv4	: 1;	/* copy of validity bit data frame 4 */
+	unsigned int _pad0	: 19;	/* must by all zeroes */
+	unsigned int n		: 1;	/* EAF port number */
+	unsigned int v1		: 1;	/* validity bit ETR data frame 1 */
+	unsigned int v2		: 1;	/* validity bit ETR data frame 2 */
+	unsigned int v3		: 1;	/* validity bit ETR data frame 3 */
+	unsigned int v4		: 1;	/* validity bit ETR data frame 4 */
+	unsigned int _pad1	: 4;	/* must be 0000 */
+} __attribute__ ((packed));
+
+/* ETR data frames */
+struct etr_edf1 {
+	unsigned int u		: 1;	/* untuned bit */
+	unsigned int _pad0	: 1;	/* must be 0 */
+	unsigned int r		: 1;	/* service request bit */
+	unsigned int _pad1	: 4;	/* must be 0000 */
+	unsigned int a		: 1;	/* time adjustment bit */
+	unsigned int net_id	: 8;	/* ETR network id */
+	unsigned int etr_id	: 8;	/* id of ETR which sends data frames */
+	unsigned int etr_pn	: 8;	/* port number of ETR output port */
+} __attribute__ ((packed));
+
+struct etr_edf2 {
+	unsigned int etv	: 32;	/* Upper 32 bits of TOD. */
+} __attribute__ ((packed));
+
+struct etr_edf3 {
+	unsigned int rc		: 8;	/* failure reason code */
+	unsigned int _pad0	: 3;	/* must be 000 */
+	unsigned int c		: 1;	/* ETR coupled bit */
+	unsigned int tc		: 4;	/* ETR type code */
+	unsigned int blto	: 8;	/* biased local time offset */
+					/* (blto - 128) * 15 = minutes */
+	unsigned int buo	: 8;	/* biased utc offset */
+					/* (buo - 128) = leap seconds */
+} __attribute__ ((packed));
+
+struct etr_edf4 {
+	unsigned int ed		: 8;	/* ETS device dependent data */
+	unsigned int _pad0	: 1;	/* must be 0 */
+	unsigned int buc	: 5;	/* biased ut1 correction */
+					/* (buc - 16) * 0.1 seconds */
+	unsigned int em		: 6;	/* ETS error magnitude */
+	unsigned int dc		: 6;	/* ETS drift code */
+	unsigned int sc		: 6;	/* ETS steering code */
+} __attribute__ ((packed));
+
+/*
+ * ETR attachment information block, two formats
+ * format 1 has 4 reserved words with a size of 64 bytes
+ * format 2 has 16 reserved words with a size of 96 bytes
+ */
+struct etr_aib {
+	struct etr_esw esw;
+	struct etr_slsw slsw;
+	unsigned long long tsp;
+	struct etr_edf1 edf1;
+	struct etr_edf2 edf2;
+	struct etr_edf3 edf3;
+	struct etr_edf4 edf4;
+	unsigned int reserved[16];
+} __attribute__ ((packed,aligned(8)));
+
+/* ETR interruption parameter */
+struct etr_interruption_parameter {
+	unsigned int _pad0	: 8;
+	unsigned int pc0	: 1;	/* port 0 state change */
+	unsigned int pc1	: 1;	/* port 1 state change */
+	unsigned int _pad1	: 3;
+	unsigned int eai	: 1;	/* ETR alert indication */
+	unsigned int _pad2	: 18;
+} __attribute__ ((packed));
+
+/* Query TOD offset result */
+struct etr_ptff_qto {
+	unsigned long long physical_clock;
+	unsigned long long tod_offset;
+	unsigned long long logical_tod_offset;
+	unsigned long long tod_epoch_difference;
+} __attribute__ ((packed));
+
+/* Inline assembly helper functions */
+static inline int etr_setr(struct etr_eacr *ctrl)
+{
+	int rc = -ENOSYS;
+
+	asm volatile(
+		"	.insn	s,0xb2160000,0(%2)\n"
+		"0:	la	%0,0\n"
+		"1:\n"
+		EX_TABLE(0b,1b)
+		: "+d" (rc) : "m" (*ctrl), "a" (ctrl));
+	return rc;
+}
+
+/* Stores a format 1 aib with 64 bytes */
+static inline int etr_stetr(struct etr_aib *aib)
+{
+	int rc = -ENOSYS;
+
+	asm volatile(
+		"	.insn	s,0xb2170000,0(%2)\n"
+		"0:	la	%0,0\n"
+		"1:\n"
+		EX_TABLE(0b,1b)
+		: "+d" (rc) : "m" (*aib), "a" (aib));
+	return rc;
+}
+
+/* Stores a format 2 aib with 96 bytes for specified port */
+static inline int etr_steai(struct etr_aib *aib, unsigned int func)
+{
+	register unsigned int reg0 asm("0") = func;
+	int rc = -ENOSYS;
+
+	asm volatile(
+		"	.insn	s,0xb2b30000,0(%2)\n"
+		"0:	la	%0,0\n"
+		"1:\n"
+		EX_TABLE(0b,1b)
+		: "+d" (rc) : "m" (*aib), "a" (aib), "d" (reg0));
+	return rc;
+}
+
+/* Function codes for the steai instruction. */
+#define ETR_STEAI_STEPPING_PORT		0x10
+#define ETR_STEAI_ALTERNATE_PORT	0x11
+#define ETR_STEAI_PORT_0		0x12
+#define ETR_STEAI_PORT_1		0x13
+
+static inline int etr_ptff(void *ptff_block, unsigned int func)
+{
+	register unsigned int reg0 asm("0") = func;
+	register unsigned long reg1 asm("1") = (unsigned long) ptff_block;
+	int rc = -ENOSYS;
+
+	asm volatile(
+		"	.word	0x0104\n"
+		"	ipm	%0\n"
+		"	srl	%0,28\n"
+		: "=d" (rc), "=m" (ptff_block)
+		: "d" (reg0), "d" (reg1), "m" (ptff_block) : "cc");
+	return rc;
+}
+
+/* Function codes for the ptff instruction. */
+#define ETR_PTFF_QAF	0x00	/* query available functions */
+#define ETR_PTFF_QTO	0x01	/* query tod offset */
+#define ETR_PTFF_QSI	0x02	/* query steering information */
+#define ETR_PTFF_ATO	0x40	/* adjust tod offset */
+#define ETR_PTFF_STO	0x41	/* set tod offset */
+#define ETR_PTFF_SFS	0x42	/* set fine steering rate */
+#define ETR_PTFF_SGS	0x43	/* set gross steering rate */
+
+/* Functions needed by the machine check handler */
+extern void etr_switch_to_local(void);
+extern void etr_sync_check(void);
+
+#endif /* __S390_ETR_H */
diff -urpN linux-2.6/include/asm-s390/hardirq.h linux-2.6-patched/include/asm-s390/hardirq.h
--- linux-2.6/include/asm-s390/hardirq.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/hardirq.h	2007-01-26 17:29:31.000000000 +0100
@@ -32,6 +32,6 @@ typedef struct {
 
 #define HARDIRQ_BITS	8
 
-extern void account_ticks(void);
+extern void account_ticks(u64 time);
 
 #endif /* __ASM_HARDIRQ_H */
diff -urpN linux-2.6/include/asm-s390/timex.h linux-2.6-patched/include/asm-s390/timex.h
--- linux-2.6/include/asm-s390/timex.h	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/timex.h	2007-01-26 17:29:31.000000000 +0100
@@ -11,6 +11,41 @@
 #ifndef _ASM_S390_TIMEX_H
 #define _ASM_S390_TIMEX_H
 
+/* Inline functions for clock register access. */
+static inline int set_clock(__u64 time)
+{
+	int cc;
+
+	asm volatile(
+		"   sck   0(%2)\n"
+		"   ipm   %0\n"
+		"   srl   %0,28\n"
+		: "=d" (cc) : "m" (time), "a" (&time) : "cc");
+	return cc;
+}
+
+static inline int store_clock(__u64 *time)
+{
+	int cc;
+
+	asm volatile(
+		"   stck  0(%2)\n"
+		"   ipm   %0\n"
+		"   srl   %0,28\n"
+		: "=d" (cc), "=m" (*time) : "a" (time) : "cc");
+	return cc;
+}
+
+static inline void set_clock_comparator(__u64 time)
+{
+	asm volatile("sckc 0(%1)" : : "m" (time), "a" (&time));
+}
+
+static inline void store_clock_comparator(__u64 *time)
+{
+	asm volatile("stckc 0(%1)" : "=m" (*time) : "a" (time));
+}
+
 #define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
 
 typedef unsigned long long cycles_t;
@@ -32,6 +67,7 @@ static inline cycles_t get_cycles(void)
 	return (cycles_t) get_clock() >> 2;
 }
 
+int get_sync_clock(unsigned long long *clock);
 void init_cpu_timer(void);
 
 #endif
