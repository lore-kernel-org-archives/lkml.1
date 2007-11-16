Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbXKPIWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbXKPIWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 03:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbXKPIWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 03:22:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51161 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbXKPIWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 03:22:23 -0500
Date: Fri, 16 Nov 2007 09:21:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071116082146.GA14685@elte.hu>
References: <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <473CC6D4.2010909@rtr.ca> <20071116055531.GA16273@elte.hu> <20071116071522.GA1453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116071522.GA1453@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ok, i experimented around with the latency tracer, trying to capture the 
trace of a full suspend+resume cycle, and it needed the tracer fix below 
(GTOD clocksource suspend/resume would otherwise confuse the tracer and 
you'd get no trace output as a result).

once that tracer bug was fixed, the best method to generate a trace was 
to do this:

   echo 1 > /proc/sys/kernel/stackframe_tracing
   echo 1 > /proc/sys/kernel/syscall_tracing
   ./trace-cmd bash -c "echo mem > /sys/power/state" > trace.txt

	Ingo

---
 kernel/latency_trace.c |   53 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 17 deletions(-)

Index: linux/kernel/latency_trace.c
===================================================================
--- linux.orig/kernel/latency_trace.c
+++ linux/kernel/latency_trace.c
@@ -67,13 +67,6 @@ static unsigned long notrace cycles_to_u
 }
 #endif
 
-static notrace inline cycle_t now(void)
-{
-	if (trace_use_raw_cycles)
-		return get_cycles();
-	return get_monotonic_cycles();
-}
-
 #ifndef irqs_off
 # define irqs_off()			0
 #endif
@@ -237,6 +230,8 @@ struct cpu_trace {
 	unsigned long critical_sequence;
 	atomic_t underrun;
 	atomic_t overrun;
+	cycle_t cycles;
+	cycle_t last_cycles;
 	int early_warning;
 	int latency_type;
 	int cpu;
@@ -263,6 +258,30 @@ static struct cpu_trace cpu_traces[NR_CP
 #endif
  } };
 
+static notrace cycle_t now(struct cpu_trace *tr, int monotonic)
+{
+	cycles_t now, delta, last = tr->last_cycles;
+
+	if (trace_use_raw_cycles && !monotonic)
+		now = get_cycles();
+	else
+		now = get_monotonic_cycles();
+
+	/*
+	 * Protect against time warps:
+	 */
+	if (unlikely(now < last))
+		delta = 1;
+	else
+		delta = now - last;
+
+	tr->last_cycles = now;
+	tr->cycles += delta;
+
+	return tr->cycles;
+}
+
+
 #ifdef CONFIG_EVENT_TRACE
 
 int trace_enabled = 0;
@@ -615,7 +634,7 @@ ____trace(int cpu, enum trace_type type,
 again:
 	idx = tr->trace_idx;
 	idx_next = idx + 1;
-	timestamp = now();
+	timestamp = now(tr, 0);
 
 	if (unlikely((trace_freerunning || print_functions || atomic_read(&tr->underrun)) &&
 		     (idx_next >= MAX_TRACE) && !atomic_read(&tr->overrun))) {
@@ -1743,7 +1762,7 @@ check_critical_timing(int cpu, struct cp
 	 * as long as possible:
 	 */
 	T0 = tr->preempt_timestamp;
-	T1 = get_monotonic_cycles();
+	T1 = now(tr, 1);
 	delta = T1-T0;
 
 	local_save_flags(flags);
@@ -1757,7 +1776,7 @@ check_critical_timing(int cpu, struct cp
 	 * might change it (it can only get larger so the latency
 	 * is fair to be reported):
 	 */
-	T2 = get_monotonic_cycles();
+	T2 = now(tr, 1);
 
 	delta = T2-T0;
 
@@ -1807,7 +1826,7 @@ check_critical_timing(int cpu, struct cp
 	printk(" =>   ended at timestamp %lu: ", t1);
 	print_symbol("<%s>\n", tr->critical_end);
 	dump_stack();
-	t1 = cycles_to_usecs(get_monotonic_cycles());
+	t1 = cycles_to_usecs(now(tr, 1));
 	printk(" =>   dump-end timestamp %lu\n\n", t1);
 #endif
 
@@ -1817,7 +1836,7 @@ check_critical_timing(int cpu, struct cp
 
 out:
 	tr->critical_sequence = max_sequence;
-	tr->preempt_timestamp = get_monotonic_cycles();
+	tr->preempt_timestamp = now(tr, 1);
 	tr->early_warning = 0;
 	reset_trace_idx(cpu, tr);
 	_trace_cmdline(cpu, tr);
@@ -1866,7 +1885,7 @@ __start_critical_timing(unsigned long ei
 	atomic_inc(&tr->disabled);
 
 	tr->critical_sequence = max_sequence;
-	tr->preempt_timestamp = get_monotonic_cycles();
+	tr->preempt_timestamp = now(tr, 1);
 	tr->critical_start = eip;
 	reset_trace_idx(cpu, tr);
 	tr->latency_type = latency_type;
@@ -2150,7 +2169,7 @@ check_wakeup_timing(struct cpu_trace *tr
 		goto out;
 
 	T0 = tr->preempt_timestamp;
-	T1 = get_monotonic_cycles();
+	T1 = now(tr, 1);
 	/*
 	 * Any wraparound or time warp and we are out:
 	 */
@@ -2255,7 +2274,7 @@ void __trace_start_sched_wakeup(struct t
 //	if (!atomic_read(&tr->disabled)) {
 		atomic_inc(&tr->disabled);
 		tr->critical_sequence = max_sequence;
-		tr->preempt_timestamp = get_monotonic_cycles();
+		tr->preempt_timestamp = now(tr, 1);
 		tr->latency_type = WAKEUP_LATENCY;
 		tr->critical_start = CALLER_ADDR0;
 		_trace_cmdline(raw_smp_processor_id(), tr);
@@ -2366,7 +2385,7 @@ long user_trace_start(void)
 	reset_trace_idx(cpu, tr);
 
 	tr->critical_sequence = max_sequence;
-	tr->preempt_timestamp = get_monotonic_cycles();
+	tr->preempt_timestamp = now(tr, 1);
 	tr->critical_start = CALLER_ADDR0;
 	_trace_cmdline(cpu, tr);
 	mcount();
@@ -2425,7 +2444,7 @@ long user_trace_stop(void)
 		unsigned long long tmp0;
 
 		T0 = tr->preempt_timestamp;
-		T1 = get_monotonic_cycles();
+		T1 = now(tr, 1);
 		tmp0 = preempt_max_latency;
 		if (T1 < T0)
 			T0 = T1;
