Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbXLKItf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbXLKItf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 03:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbXLKIt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 03:49:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39816 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbXLKIt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 03:49:27 -0500
Date: Tue, 11 Dec 2007 09:48:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071211084858.GD20172@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071210204212.GA5502@elte.hu> <20071210125923.37bd2f10.akpm@linux-foundation.org> <20071210224508.GB27178@elte.hu> <20071210230425.GA641@elte.hu> <20071211003433.5cf0230d@morte> <20071211005353.55bcbc1e@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211005353.55bcbc1e@inria.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> Stefano Brivio <stefano.brivio@polimi.it> wrote:
> 
> > Sorry for disappearing. Anyway, yes, those patches fixed it. Precision in
> > delays isn't that good when using my crappy unstable TSC (mdelay(2000)
> > causes delays between 2 and 2.9 seconds) but it's not depending on frequency
> > changes anymore. So I'd say it's fixed, but please tell me if you want me
> > to do any other test so as to be sure it is.
> 
> Ingo,
> 
> it seems you dropped http://lkml.org/lkml/2007/12/7/100 (cpu_clock() 
> based udelay), so how udelay can be affected by your proposed changes?

was this needed for you to get stable udelay()? (that cpu_clock() based 
udelay patch was buggy, i got the units wrong. udelay does wacky 
conversions between various units. So i dropped it for the time being.)

the last rollup you tested didnt show udelay problems, and it didnt 
include the sched_clock() based udelay patch.

so it would be nice if you could re-examine exactly what is needed. 
Please try latest -git and the concatenation of the 4 patches below. 
What would be the best info is to see which (if any!) patches are needed 
against latest -git to get a stable udelay() on your box.

	Ingo

--------------------------------------->
* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Subject		: jiffies counter leaps in 2.6.24-rc3
> Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
> References	: http://lkml.org/lkml/2007/11/24/53
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
> Handled-By	: Ingo Molnar <mingo@elte.hu>
> Patch		: http://lkml.org/lkml/2007/12/7/132

Linus, Andrew, i need some help deciding what to do about this 
regression. The fixes for this have been tested and resolve the 
regression, but they change printk and other code that runs by default 
and is thus rather invasive so late in the v2.6.24 cycle. This bug 
should only affect CONFIG_PRINTK_TIME=y kernels (a non-default debug 
option) - although some claimed effect was on udelay()/mdelay() too.

i've attached below the queue of 5 patches that fix this problem. They 
have been build and boot tested with more than 1000 random kernels in 
the past few days, so i certainly trust the core and x86 bits of this.

what do you think? Right now i've got them queued up for 2.6.25 in both 
the scheduler-devel and the x86-devel git trees - but can submit them 
for 2.6.24 if it's better if we did them there. I've got no strong 
opinion either way.

	Ingo

-------------------->
Subject: x86: scale cyc_2_nsec according to CPU frequency
From: "Guillaume Chazarain" <guichaz@yahoo.fr>

scale the sched_clock() cyc_2_nsec scaling factor according to
CPU frequency changes.

[ mingo@elte.hu: simplified it and fixed it for SMP. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tsc_32.c |   43 ++++++++++++++++++++++++++++++-----
 arch/x86/kernel/tsc_64.c |   57 ++++++++++++++++++++++++++++++++++++++---------
 include/asm-x86/timer.h  |   23 ++++++++++++++----
 3 files changed, 102 insertions(+), 21 deletions(-)

Index: linux/arch/x86/kernel/tsc_32.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc_32.c
+++ linux/arch/x86/kernel/tsc_32.c
@@ -5,6 +5,7 @@
 #include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
+#include <linux/percpu.h>
 
 #include <asm/delay.h>
 #include <asm/tsc.h>
@@ -80,13 +81,31 @@ EXPORT_SYMBOL_GPL(check_tsc_unstable);
  *
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
-unsigned long cyc2ns_scale __read_mostly;
 
-#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
+DEFINE_PER_CPU(unsigned long, cyc2ns);
 
-static inline void set_cyc2ns_scale(unsigned long cpu_khz)
+static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
+	unsigned long flags, prev_scale, *scale;
+	unsigned long long tsc_now, ns_now;
+
+	local_irq_save(flags);
+	sched_clock_idle_sleep_event();
+
+	scale = &per_cpu(cyc2ns, cpu);
+
+	rdtscll(tsc_now);
+	ns_now = __cycles_2_ns(tsc_now);
+
+	prev_scale = *scale;
+	if (cpu_khz)
+		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+
+	/*
+	 * Start smoothly with the new frequency:
+	 */
+	sched_clock_idle_wakeup_event(0);
+	local_irq_restore(flags);
 }
 
 /*
@@ -239,7 +258,9 @@ time_cpufreq_notifier(struct notifier_bl
 						ref_freq, freq->new);
 			if (!(freq->flags & CPUFREQ_CONST_LOOPS)) {
 				tsc_khz = cpu_khz;
-				set_cyc2ns_scale(cpu_khz);
+				preempt_disable();
+				set_cyc2ns_scale(cpu_khz, smp_processor_id());
+				preempt_enable();
 				/*
 				 * TSC based sched_clock turns
 				 * to junk w/ cpufreq
@@ -367,6 +388,8 @@ static inline void check_geode_tsc_relia
 
 void __init tsc_init(void)
 {
+	int cpu;
+
 	if (!cpu_has_tsc || tsc_disable)
 		goto out_no_tsc;
 
@@ -380,7 +403,15 @@ void __init tsc_init(void)
 				(unsigned long)cpu_khz / 1000,
 				(unsigned long)cpu_khz % 1000);
 
-	set_cyc2ns_scale(cpu_khz);
+	/*
+	 * Secondary CPUs do not run through tsc_init(), so set up
+	 * all the scale factors for all CPUs, assuming the same
+	 * speed as the bootup CPU. (cpufreq notifiers will fix this
+	 * up if their speed diverges)
+	 */
+	for_each_possible_cpu(cpu)
+		set_cyc2ns_scale(cpu_khz, cpu);
+
 	use_tsc_delay();
 
 	/* Check and install the TSC clocksource */
Index: linux/arch/x86/kernel/tsc_64.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc_64.c
+++ linux/arch/x86/kernel/tsc_64.c
@@ -10,6 +10,7 @@
 
 #include <asm/hpet.h>
 #include <asm/timex.h>
+#include <asm/timer.h>
 
 static int notsc __initdata = 0;
 
@@ -18,16 +19,48 @@ EXPORT_SYMBOL(cpu_khz);
 unsigned int tsc_khz;
 EXPORT_SYMBOL(tsc_khz);
 
-static unsigned int cyc2ns_scale __read_mostly;
+/* Accelerators for sched_clock()
+ * convert from cycles(64bits) => nanoseconds (64bits)
+ *  basic equation:
+ *		ns = cycles / (freq / ns_per_sec)
+ *		ns = cycles * (ns_per_sec / freq)
+ *		ns = cycles * (10^9 / (cpu_khz * 10^3))
+ *		ns = cycles * (10^6 / cpu_khz)
+ *
+ *	Then we use scaling math (suggested by george@mvista.com) to get:
+ *		ns = cycles * (10^6 * SC / cpu_khz) / SC
+ *		ns = cycles * cyc2ns_scale / SC
+ *
+ *	And since SC is a constant power of two, we can convert the div
+ *  into a shift.
+ *
+ *  We can use khz divisor instead of mhz to keep a better precision, since
+ *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
+ *  (mathieu.desnoyers@polymtl.ca)
+ *
+ *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
+ */
+DEFINE_PER_CPU(unsigned long, cyc2ns);
 
-static inline void set_cyc2ns_scale(unsigned long khz)
+static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	cyc2ns_scale = (NSEC_PER_MSEC << NS_SCALE) / khz;
-}
+	unsigned long flags, prev_scale, *scale;
+	unsigned long long tsc_now, ns_now;
 
-static unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	return (cyc * cyc2ns_scale) >> NS_SCALE;
+	local_irq_save(flags);
+	sched_clock_idle_sleep_event();
+
+	scale = &per_cpu(cyc2ns, cpu);
+
+	rdtscll(tsc_now);
+	ns_now = __cycles_2_ns(tsc_now);
+
+	prev_scale = *scale;
+	if (cpu_khz)
+		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+
+	sched_clock_idle_wakeup_event(0);
+	local_irq_restore(flags);
 }
 
 unsigned long long sched_clock(void)
@@ -100,7 +133,9 @@ static int time_cpufreq_notifier(struct 
 			mark_tsc_unstable("cpufreq changes");
 	}
 
-	set_cyc2ns_scale(tsc_khz_ref);
+	preempt_disable();
+	set_cyc2ns_scale(tsc_khz_ref, smp_processor_id());
+	preempt_enable();
 
 	return 0;
 }
@@ -151,7 +186,7 @@ static unsigned long __init tsc_read_ref
 void __init tsc_calibrate(void)
 {
 	unsigned long flags, tsc1, tsc2, tr1, tr2, pm1, pm2, hpet1, hpet2;
-	int hpet = is_hpet_enabled();
+	int hpet = is_hpet_enabled(), cpu;
 
 	local_irq_save(flags);
 
@@ -206,7 +241,9 @@ void __init tsc_calibrate(void)
 	}
 
 	tsc_khz = tsc2 / tsc1;
-	set_cyc2ns_scale(tsc_khz);
+
+	for_each_possible_cpu(cpu)
+		set_cyc2ns_scale(tsc_khz, cpu);
 }
 
 /*
Index: linux/include/asm-x86/timer.h
===================================================================
--- linux.orig/include/asm-x86/timer.h
+++ linux/include/asm-x86/timer.h
@@ -2,6 +2,7 @@
 #define _ASMi386_TIMER_H
 #include <linux/init.h>
 #include <linux/pm.h>
+#include <linux/percpu.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
 
@@ -16,7 +17,7 @@ extern int recalibrate_cpu_khz(void);
 #define calculate_cpu_khz() native_calculate_cpu_khz()
 #endif
 
-/* Accellerators for sched_clock()
+/* Accelerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
  *		ns = cycles / (freq / ns_per_sec)
@@ -31,20 +32,32 @@ extern int recalibrate_cpu_khz(void);
  *	And since SC is a constant power of two, we can convert the div
  *  into a shift.
  *
- *  We can use khz divisor instead of mhz to keep a better percision, since
+ *  We can use khz divisor instead of mhz to keep a better precision, since
  *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
  *  (mathieu.desnoyers@polymtl.ca)
  *
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
-extern unsigned long cyc2ns_scale __read_mostly;
+
+DECLARE_PER_CPU(unsigned long, cyc2ns);
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
-	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
+	return cyc * per_cpu(cyc2ns, smp_processor_id()) >> CYC2NS_SCALE_FACTOR;
 }
 
+static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+{
+	unsigned long long ns;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	ns = __cycles_2_ns(cyc);
+	local_irq_restore(flags);
+
+	return ns;
+}
 
 #endif
--------------->
Subject: x86: idle wakeup event in the HLT loop
From: Ingo Molnar <mingo@elte.hu>

do a proper idle-wakeup event on HLT as well - some CPUs stop the TSC
in HLT too, not just when going through the ACPI methods.

(the ACPI idle code already does this.)

[ update the 64-bit side too, as noticed by Jiri Slaby. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_32.c |   15 ++++++++++++---
 arch/x86/kernel/process_64.c |   13 ++++++++++---
 2 files changed, 22 insertions(+), 6 deletions(-)

Index: linux-x86.q/arch/x86/kernel/process_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/process_32.c
+++ linux-x86.q/arch/x86/kernel/process_32.c
@@ -113,10 +113,19 @@ void default_idle(void)
 		smp_mb();
 
 		local_irq_disable();
-		if (!need_resched())
+		if (!need_resched()) {
+			ktime_t t0, t1;
+			u64 t0n, t1n;
+
+			t0 = ktime_get();
+			t0n = ktime_to_ns(t0);
 			safe_halt();	/* enables interrupts racelessly */
-		else
-			local_irq_enable();
+			local_irq_disable();
+			t1 = ktime_get();
+			t1n = ktime_to_ns(t1);
+			sched_clock_idle_wakeup_event(t1n - t0n);
+		}
+		local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
 	} else {
 		/* loop is done by the caller */
Index: linux-x86.q/arch/x86/kernel/process_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/process_64.c
+++ linux-x86.q/arch/x86/kernel/process_64.c
@@ -116,9 +116,16 @@ static void default_idle(void)
 	smp_mb();
 	local_irq_disable();
 	if (!need_resched()) {
-		/* Enables interrupts one instruction before HLT.
-		   x86 special cases this so there is no race. */
-		safe_halt();
+		ktime_t t0, t1;
+		u64 t0n, t1n;
+
+		t0 = ktime_get();
+		t0n = ktime_to_ns(t0);
+		safe_halt();	/* enables interrupts racelessly */
+		local_irq_disable();
+		t1 = ktime_get();
+		t1n = ktime_to_ns(t1);
+		sched_clock_idle_wakeup_event(t1n - t0n);
 	} else
 		local_irq_enable();
 	current_thread_info()->status |= TS_POLLING;
--------------->
Subject: printk: make printk more robust by not allowing recursion
From: Ingo Molnar <mingo@elte.hu>

make printk more robust by allowing recursion only if there's a crash
going on. Also add recursion detection.

I've tested it with an artificially injected printk recursion - instead
of a lockup or spontaneous reboot or other crash, the output was a well
controlled:

[   41.057335] SysRq : <2>BUG: recent printk recursion!
[   41.057335] loglevel0-8 reBoot Crashdump show-all-locks(D) tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks

also do all this printk-debug logic with irqs disabled.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/printk.c |   48 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 10 deletions(-)

Index: linux/kernel/printk.c
===================================================================
--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -628,30 +628,57 @@ asmlinkage int printk(const char *fmt, .
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int printk_cpu = UINT_MAX;
 
+const char printk_recursion_bug_msg [] =
+			KERN_CRIT "BUG: recent printk recursion!\n";
+static int printk_recursion_bug;
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
+	static int log_level_unknown = 1;
+	static char printk_buf[1024];
+
 	unsigned long flags;
-	int printed_len;
+	int printed_len = 0;
+	int this_cpu;
 	char *p;
-	static char printk_buf[1024];
-	static int log_level_unknown = 1;
 
 	boot_delay_msec();
 
 	preempt_disable();
-	if (unlikely(oops_in_progress) && printk_cpu == smp_processor_id())
-		/* If a crash is occurring during printk() on this CPU,
-		 * make sure we can't deadlock */
-		zap_locks();
-
 	/* This stops the holder of console_sem just where we want him */
 	raw_local_irq_save(flags);
+	this_cpu = smp_processor_id();
+
+	/*
+	 * Ouch, printk recursed into itself!
+	 */
+	if (unlikely(printk_cpu == this_cpu)) {
+		/*
+		 * If a crash is occurring during printk() on this CPU,
+		 * then try to get the crash message out but make sure
+		 * we can't deadlock. Otherwise just return to avoid the
+		 * recursion and return - but flag the recursion so that
+		 * it can be printed at the next appropriate moment:
+		 */
+		if (!oops_in_progress) {
+			printk_recursion_bug = 1;
+			goto out_restore_irqs;
+		}
+		zap_locks();
+	}
+
 	lockdep_off();
 	spin_lock(&logbuf_lock);
-	printk_cpu = smp_processor_id();
+	printk_cpu = this_cpu;
 
+	if (printk_recursion_bug) {
+		printk_recursion_bug = 0;
+		strcpy(printk_buf, printk_recursion_bug_msg);
+		printed_len = sizeof(printk_recursion_bug_msg);
+	}
 	/* Emit the output into the temporary buffer */
-	printed_len = vscnprintf(printk_buf, sizeof(printk_buf), fmt, args);
+	printed_len += vscnprintf(printk_buf + printed_len,
+				  sizeof(printk_buf), fmt, args);
 
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
@@ -744,6 +771,7 @@ asmlinkage int vprintk(const char *fmt, 
 		printk_cpu = UINT_MAX;
 		spin_unlock(&logbuf_lock);
 		lockdep_on();
+out_restore_irqs:
 		raw_local_irq_restore(flags);
 	}
 
--------------->
Subject: sched: fix CONFIG_PRINT_TIME's reliance on sched_clock()
From: Ingo Molnar <mingo@elte.hu>

Stefano Brivio reported weird printk timestamp behavior during
CPU frequency changes:

  http://bugzilla.kernel.org/show_bug.cgi?id=9475

fix CONFIG_PRINT_TIME's reliance on sched_clock() and use cpu_clock()
instead.

Reported-and-bisected-by: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/printk.c
===================================================================
--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -707,7 +707,7 @@ asmlinkage int vprintk(const char *fmt, 
 					loglev_char = default_message_loglevel
 						+ '0';
 				}
-				t = printk_clock();
+				t = cpu_clock(printk_cpu);
 				nanosec_rem = do_div(t, 1000000000);
 				tlen = sprintf(tbuf,
 						"<%c>[%5lu.%06lu] ",
