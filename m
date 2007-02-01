Return-Path: <linux-kernel-owner+w=401wt.eu-S1422797AbXBALOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422797AbXBALOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422807AbXBALNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:13:55 -0500
Received: from styx.suse.cz ([82.119.242.94]:53761 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751778AbXBALMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:12:35 -0500
Message-Id: <20070201103754.136630000@jet.suse.cz>
References: <20070201095952.589234000@jet.suse.cz>
User-Agent: quilt/0.44-16.5
Date: Thu, 01 Feb 2007 11:00:00 +0100
From: jbohac@suse.cz
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: [patch 8/9] Add time_update_mt_guess()
Content-Disposition: inline; filename=update_mt_guess
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

time_update_mt_guess() is the core of the TSC->MT approximation magic.

Called periodically from the LAPIC timer interrupt handler, it fine-tunes 
all the per-CPU offsets and ratios needed by guess_mt() to approximate the
MT using any processor's TSC.

We also need to update these from the cpufreq notifiers. Because a frequency
change makes the approximation unreliable (we don't know _exactly_ when it
happens) the approximation is disabled for a while after a frequency change and 
it's not re-enabled until the approximation stabilises again.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>


Index: linux-2.6.20-rc5/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/apic.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/apic.c
@@ -63,6 +63,9 @@ int using_apic_timer __read_mostly = 0;
 
 static void apic_pm_activate(void);
 
+extern void time_update_mt_guess(void);
+
+
 void enable_NMI_through_LVT0 (void * dummy)
 {
 	unsigned int v;
@@ -986,6 +989,8 @@ void smp_local_timer_interrupt(void)
 	 * Currently this isn't too much of an issue (performance wise),
 	 * we can take more than 100K local irqs per second on a 100 MHz P5.
 	 */
+
+	 time_update_mt_guess();
 }
 
 /*
Index: linux-2.6.20-rc5/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/time.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/time.c
@@ -221,6 +221,126 @@ static u32 read_master_timer_pm(void)
 }
 
 /*
+ * This function, called from the LAPIC interrupt,
+ * periodically updates all the per-CPU values needed by
+ * guess_mt()
+ */
+void time_update_mt_guess(void)
+{
+	u64 t, delta_t, delta_mt, mt;
+	s64 guess_mt_err, guess_mt_err_nsec, tsc_per_tick, tsc_slope_corr,
+	    current_slope, old_mt_err;
+	int cpu = smp_processor_id(), resync;
+	unsigned long flags;
+
+	if (vxtime.mode == VXTIME_TSC && cpu != 0)
+		return;
+
+	local_irq_save(flags);
+
+	/* if a frequency change is in progress, don't recalculate anything
+	   as this would destroy the fine-tuned slope. We don't rely on the TSC
+	   during this time, so we don't care about the accuracy at all */
+	if (vxtime.cpu[cpu].tsc_invalid == VXTIME_TSC_CPUFREQ) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	mt = get_master_timer64();
+	t = get_cycles_sync();
+
+	write_seqlock(&xtime_lock);
+
+	/* get the error of the estimated MT value */
+	delta_t = t - vxtime.cpu[cpu].tsc_last;
+	delta_mt = mt - vxtime.cpu[cpu].mt_last;
+	tsc_per_tick = ((mt_per_tick << 32) / delta_mt * delta_t) >> 32;
+
+	vxtime.cpu[cpu].mt_base = __guess_mt(t, cpu);
+
+	guess_mt_err = mt - vxtime.cpu[cpu].mt_base;
+	guess_mt_err_nsec = (guess_mt_err * (s64)vxtime.mt_q) >> 32;
+	old_mt_err =  ((s64)(vxtime.cpu[cpu].tsc_slope_avg - vxtime.cpu[cpu].tsc_slope)
+			* tsc_per_tick) >> TSC_SLOPE_SCALE;
+	current_slope = (delta_mt << TSC_SLOPE_SCALE) / delta_t;
+
+	/* calculate a long time average to attenuate oscilation */
+	vxtime.cpu[cpu].tsc_slope_avg = ((TSC_SLOPE_DECAY - 1) * vxtime.cpu[cpu].tsc_slope_avg +
+			current_slope) / TSC_SLOPE_DECAY;
+
+	tsc_slope_corr = ((s64)(guess_mt_err << TSC_SLOPE_SCALE)) / tsc_per_tick;
+	vxtime.cpu[cpu].tsc_slope = vxtime.cpu[cpu].tsc_slope_avg + tsc_slope_corr;
+
+	if ((s64)vxtime.cpu[cpu].tsc_slope < 0) {
+		vxtime.cpu[cpu].tsc_slope = 0;
+		vxtime.cpu[cpu].tsc_slope_avg = current_slope;
+	}
+
+	if (abs(guess_mt_err) > (mt_per_tick >> 2))
+		printk(KERN_DEBUG "Master Timer guess on cpu %d off by %lld.%.6ld seconds\n",
+			cpu, guess_mt_err_nsec / NSEC_PER_SEC,
+			(abs(guess_mt_err_nsec) % NSEC_PER_SEC) / 1000);
+
+	resync = 0;
+	/* if the guess is off by more than a second, something has gone very
+	   wrong; we'll break monotonicity and re-sync the guess with the MT */
+	if (abs(guess_mt_err_nsec) > NSEC_PER_SEC) {
+		resync = 1;
+		if (vxtime.mode != VXTIME_MT && guess_mt_err < 0)
+			printk(KERN_ERR "time not monotonic on cpu %d\n", cpu);
+	}
+	/* else if the guess is off by more than a jiffie, only synchronize the
+	   guess with the MT if the guess is behind (won't break monotonicity);
+	   if the guess is ahead, stop the timer by setting slope to zero */
+	else if (abs(guess_mt_err) > mt_per_tick) {
+		if (guess_mt_err > 0)
+			resync = 1;
+		else {
+			vxtime.cpu[cpu].tsc_slope = 0;
+			vxtime.cpu[cpu].tsc_slope_avg = current_slope;
+		}
+	}
+	/* good enough to switch back from temporary MT mode? */
+	else if (vxtime.cpu[cpu].tsc_invalid &&
+		    abs(guess_mt_err) < mt_per_tick / USEC_PER_TICK &&
+		    abs(old_mt_err) < mt_per_tick / USEC_PER_TICK &&
+		    mt > vxtime.cpu[cpu].last_mt_guess) {
+			vxtime.cpu[cpu].tsc_invalid = 0;
+			vxtime.cpu[cpu].mt_base = mt;
+			vxtime.cpu[cpu].tsc_slope = vxtime.cpu[cpu].tsc_slope_avg;
+	}
+
+	/* hard re-sync of the guess to the current value of the MT */
+	if (resync) {
+		vxtime.cpu[cpu].mt_base = mt;
+		vxtime.cpu[cpu].tsc_slope = vxtime.cpu[cpu].tsc_slope_avg = current_slope;
+
+		printk(KERN_INFO "Master Timer re-syncing on cpu %d (mt=%lld, slope=%lld)\n",
+			cpu, mt, vxtime.cpu[cpu].tsc_slope);
+	}
+
+	if (vxtime.cpu[cpu].tsc_slope == 0)
+		printk(KERN_INFO "timer on cpu %d frozen, waiting for time to catch up\n", cpu);
+
+	vxtime.cpu[cpu].tsc_last = t;
+	vxtime.cpu[cpu].mt_last = mt;
+
+	write_sequnlock(&xtime_lock);
+	local_irq_restore(flags);
+}
+
+inline u64 mt_to_nsec(u64 mt)
+{
+	u64 ret;
+	ret  = ((mt & 0xffffff) * vxtime.mt_q) >> 32;
+	mt >>= 24;
+	ret += ((mt & 0xffffff) * vxtime.mt_q) >> 8;
+	mt >>= 24;
+	ret += ( mt             * vxtime.mt_q) << 16;
+	return ret;
+}
+
+/*
  * do_gettimeoffset() returns microseconds since last timer interrupt was
  * triggered by hardware. A memory read of HPET is slower than a register read
  * of TSC, but much more reliable. It's also synchronized to the timer
@@ -666,50 +786,83 @@ static void cpufreq_delayed_get(void)
 }
 
 static unsigned int  ref_freq = 0;
-static unsigned long loops_per_jiffy_ref = 0;
 
 static unsigned long cpu_khz_ref = 0;
 
+struct cpufreq_notifier_data {
+	struct cpufreq_freqs *freq;
+	unsigned long val;
+};
+
+/* called on the CPU that changed frequency */
+static void time_cpufreq_notifier_on_cpu(void *data)
+{
+	unsigned long flags;
+	int cpu;
+	struct cpufreq_notifier_data *cnd = data;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	cpu = smp_processor_id();
+	switch (cnd->val) {
+
+		case CPUFREQ_PRECHANGE:
+		case CPUFREQ_SUSPENDCHANGE:
+			if (!vxtime.cpu[cpu].tsc_invalid)
+				vxtime.cpu[cpu].last_mt_guess = __guess_mt(get_cycles_sync(), cpu);
+			vxtime.cpu[cpu].tsc_invalid = VXTIME_TSC_CPUFREQ;
+			break;
+
+		case CPUFREQ_POSTCHANGE:
+		case CPUFREQ_RESUMECHANGE:
+			vxtime.cpu[cpu].tsc_slope = ((vxtime.cpu[cpu].tsc_slope >> 4) * cnd->freq->old / cnd->freq->new) << 4;
+			vxtime.cpu[cpu].tsc_slope_avg = ((vxtime.cpu[cpu].tsc_slope_avg >> 4) * cnd->freq->old / cnd->freq->new) << 4;
+
+			vxtime.cpu[cpu].mt_base = vxtime.cpu[cpu].mt_last = get_master_timer64();
+			vxtime.cpu[cpu].tsc_last = get_cycles_sync();
+
+			vxtime.cpu[cpu].tsc_invalid = VXTIME_TSC_INVALID;
+			break;
+	}
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+}
+
 static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 				 void *data)
 {
-        struct cpufreq_freqs *freq = data;
-	unsigned long *lpj, dummy;
+	struct cpufreq_notifier_data cnd = {
+		.freq = data,
+		.val = val,
+	};
 
-	if (cpu_has(&cpu_data[freq->cpu], X86_FEATURE_CONSTANT_TSC))
+	if (cpu_has(&cpu_data[cnd.freq->cpu], X86_FEATURE_CONSTANT_TSC))
 		return 0;
 
-	lpj = &dummy;
-	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
-#ifdef CONFIG_SMP
-		lpj = &cpu_data[freq->cpu].loops_per_jiffy;
-#else
-		lpj = &boot_cpu_data.loops_per_jiffy;
-#endif
-
 	if (!ref_freq) {
-		ref_freq = freq->old;
-		loops_per_jiffy_ref = *lpj;
+		ref_freq = cnd.freq->old;
 		cpu_khz_ref = cpu_khz;
 	}
-        if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
-            (val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
+
+	if ((val == CPUFREQ_PRECHANGE  && cnd.freq->old < cnd.freq->new) ||
+	    (val == CPUFREQ_POSTCHANGE && cnd.freq->old > cnd.freq->new) ||
 	    (val == CPUFREQ_RESUMECHANGE)) {
-                *lpj =
-		cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
 
-		cpu_khz = cpufreq_scale(cpu_khz_ref, ref_freq, freq->new);
-		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
-			vxtime.tsc_quot = (USEC_PER_MSEC << US_SCALE) / cpu_khz;
+		cpu_khz = cpufreq_scale(cpu_khz_ref, ref_freq, cnd.freq->new);
+
 	}
-	
-	set_cyc2ns_scale(cpu_khz_ref);
+
+	preempt_disable();
+	if (smp_processor_id() == cnd.freq->cpu)
+		time_cpufreq_notifier_on_cpu(&cnd);
+	else smp_call_function_single(cnd.freq->cpu, time_cpufreq_notifier_on_cpu, &cnd, 0, 1);
+	preempt_enable();
 
 	return 0;
 }
- 
+
 static struct notifier_block time_cpufreq_notifier_block = {
-         .notifier_call  = time_cpufreq_notifier
+	 .notifier_call  = time_cpufreq_notifier
 };
 
 static int __init cpufreq_tsc(void)

--
