Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbXEYHK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbXEYHK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbXEYHKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:10:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39112 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbXEYHKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:10:16 -0400
Date: Fri, 25 May 2007 09:10:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch] sched_clock(): cleanups
Message-ID: <20070525071005.GA6431@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] sched_clock(): cleanups
From: Ingo Molnar <mingo@elte.hu>

clean up sched-clock.c - mostly comment style fixes.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/sched-clock.c |   79 ++++++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 28 deletions(-)

Index: linux-cfs-2.6.22-rc2-mm1.q/arch/i386/kernel/sched-clock.c
===================================================================
--- linux-cfs-2.6.22-rc2-mm1.q.orig/arch/i386/kernel/sched-clock.c
+++ linux-cfs-2.6.22-rc2-mm1.q/arch/i386/kernel/sched-clock.c
@@ -60,18 +60,20 @@ DEFINE_PER_CPU(struct sc_data, sc_data) 
  */
 unsigned long long native_sched_clock(void)
 {
-	unsigned long long r;
 	struct sc_data *sc = &get_cpu_var(sc_data);
+	unsigned long long r;
+	unsigned long flags;
 
 	if (sc->unstable) {
-		unsigned long flags;
 		r = (jiffies_64 - sc->sync_base) * (1000000000 / HZ);
 		r += sc->ns_base;
 		local_irq_save(flags);
-		/* last_val is used to avoid non monotonity on a
-		   stable->unstable transition. Make sure the time
-		   never goes to before the last value returned by
-		   the TSC clock */
+		/*
+		 * last_val is used to avoid non monotonity on a
+		 * stable->unstable transition. Make sure the time
+		 * never goes to before the last value returned by
+		 * the TSC clock
+		 */
 		if (r <= sc->last_val)
 			r = sc->last_val + 1;
 		sc->last_val = r;
@@ -87,8 +89,10 @@ unsigned long long native_sched_clock(vo
 	return r;
 }
 
-/* We need to define a real function for sched_clock, to override the
-   weak default version */
+/*
+ * We need to define a real function for sched_clock, to override the
+ * weak default version
+ */
 #ifdef CONFIG_PARAVIRT
 unsigned long long sched_clock(void)
 {
@@ -101,9 +105,11 @@ unsigned long long sched_clock(void)
 
 static int no_sc_for_printk;
 
-/* printk clock: when it is known the sc results are very non monotonic
-   fall back to jiffies for printk. Other sched_clock users are supposed
-   to handle this. */
+/*
+ * printk clock: when it is known the sc results are very non monotonic
+ * fall back to jiffies for printk. Other sched_clock users are supposed
+ * to handle this.
+ */
 unsigned long long printk_clock(void)
 {
 	if (unlikely(no_sc_for_printk))
@@ -119,15 +125,19 @@ static void resync_sc_freq(struct sc_dat
 		sc->unstable = 1;
 		return;
 	}
-	/* Handle nesting, but when we're zero multiple calls in a row
-	   are ok too and not a bug */
+	/*
+	 * Handle nesting, but when we're zero multiple calls in a row
+	 * are ok too and not a bug
+	 */
 	if (sc->unstable > 0)
 		sc->unstable--;
 	if (sc->unstable)
 		return;
-	/* RED-PEN protect with seqlock? I hope that's not needed
-	   because sched_clock callers should be able to tolerate small
-	   errors. */
+	/*
+	 * RED-PEN protect with seqlock? I hope that's not needed
+	 * because sched_clock callers should be able to tolerate small
+	 * errors.
+	 */
 	sc->ns_base = ktime_to_ns(ktime_get());
 	rdtscll(sc->sync_base);
 	sc->cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR) / newfreq;
@@ -137,6 +147,7 @@ static void call_r_s_f(void *arg)
 {
 	struct cpufreq_freqs *freq = arg;
 	unsigned f = freq->new;
+
 	if (!f)
 		f = cpufreq_get(freq->cpu);
 	if (!f)
@@ -146,7 +157,9 @@ static void call_r_s_f(void *arg)
 
 static void call_r_s_f_here(void *arg)
 {
-	struct cpufreq_freqs f = { .cpu = get_cpu(), .new = 0 };
+	struct cpufreq_freqs f = { .new = 0 };
+
+	f.cpu = get_cpu();
 	call_r_s_f(&f);
 	put_cpu();
 }
@@ -155,9 +168,11 @@ static int sc_freq_event(struct notifier
 			 void *data)
 {
 	struct cpufreq_freqs *freq = data;
-	int cpu = get_cpu();
-	struct sc_data *sc = &per_cpu(sc_data, cpu);
+	struct sc_data *sc;
+	int cpu;
 
+	cpu = get_cpu();
+	sc = &per_cpu(sc_data, cpu);
 	if (cpu_has(&cpu_data[cpu], X86_FEATURE_CONSTANT_TSC))
 		goto out;
 	if (freq->old == freq->new)
@@ -167,16 +182,20 @@ static int sc_freq_event(struct notifier
 	case CPUFREQ_SUSPENDCHANGE:
 		/* Mark TSC unstable during suspend/resume */
 	case CPUFREQ_PRECHANGE:
-		/* Mark TSC as unstable until cpu frequency change is done
-		   because we don't know when exactly it will change.
-		   unstable in used as a counter to guard against races
-		   between the cpu frequency notifiers and normal resyncs */
+		/*
+		 * Mark TSC as unstable until cpu frequency change is done
+		 * because we don't know when exactly it will change.
+		 * unstable in used as a counter to guard against races
+		 * between the cpu frequency notifiers and normal resyncs
+		 */
 		sc->unstable++;
 		/* FALL THROUGH */
 	case CPUFREQ_RESUMECHANGE:
 	case CPUFREQ_POSTCHANGE:
-		/* Frequency change or resume is done -- update everything and
-		   mark TSC as stable again. */
+		/*
+		 * Frequency change or resume is done -- update everything
+		 * and mark TSC as stable again.
+		 */
 		if (cpu == freq->cpu)
 			resync_sc_freq(sc, freq->new);
 		else
@@ -186,6 +205,7 @@ static int sc_freq_event(struct notifier
 	}
 out:
 	put_cpu();
+
 	return NOTIFY_DONE;
 }
 
@@ -197,6 +217,7 @@ static int __cpuinit
 sc_cpu_event(struct notifier_block *self, unsigned long event, void *hcpu)
 {
 	long cpu = (long)hcpu;
+
 	if (event == CPU_ONLINE) {
 		struct cpufreq_freqs f = { .cpu = cpu, .new = 0 };
 		smp_call_function_single(cpu, call_r_s_f, &f, 0, 1);
@@ -209,13 +230,15 @@ static __init int init_sched_clock(void)
 	if (unsynchronized_tsc())
 		no_sc_for_printk = 1;
 
-	/* On a race between the various events the initialization might be
-	   done multiple times, but code is tolerant to this */
+	/*
+	 * On a race between the various events the initialization might be
+	 * done multiple times, but code is tolerant to this
+	 */
 	cpufreq_register_notifier(&sc_freq_notifier,
 				CPUFREQ_TRANSITION_NOTIFIER);
 	hotcpu_notifier(sc_cpu_event, 0);
 	on_each_cpu(call_r_s_f_here, NULL, 0, 0);
+
 	return 0;
 }
 core_initcall(init_sched_clock);
-
