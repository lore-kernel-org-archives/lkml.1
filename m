Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZADNSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZADNSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZADNSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:18:11 -0500
Received: from relay3.sgi.com ([192.48.171.31]:38608 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751225AbZADNSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:18:08 -0500
Message-Id: <20090104131801.363451000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Sun, 04 Jan 2009 05:18:10 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: [PATCH 11/11] cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs
References: <20090104131759.865331000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=cpumask:use-work_on_cpu-in-acpi-cpufreq_c-p2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce stack usage, use new cpumask API

Replace the saving of current->cpus_allowed and set_cpus_allowed_ptr() with
a work_on_cpu function for read_measured_perf_ctrs().

Basically splits off the work function from get_measured_perf which is
run on the designated cpu.  Moves definition of struct perf_cur out of
function local namespace, and is used as the work function argument.
References in get_measured_perf use values in the perf_cur struct.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Jones <davej@redhat.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   83 +++++++++++++++--------------
 1 file changed, 43 insertions(+), 40 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -245,6 +245,30 @@ static u32 get_cur_val(const struct cpum
 	return cmd.val;
 }
 
+struct perf_cur {
+	union {
+		struct {
+			u32 lo;
+			u32 hi;
+		} split;
+		u64 whole;
+	} aperf_cur, mperf_cur;
+};
+
+
+static long read_measured_perf_ctrs(void *_cur)
+{
+	struct perf_cur *cur = _cur;
+
+	rdmsr(MSR_IA32_APERF, cur->aperf_cur.split.lo, cur->aperf_cur.split.hi);
+	rdmsr(MSR_IA32_MPERF, cur->mperf_cur.split.lo, cur->mperf_cur.split.hi);
+
+	wrmsr(MSR_IA32_APERF, 0, 0);
+	wrmsr(MSR_IA32_MPERF, 0, 0);
+
+	return 0;
+}
+
 /*
  * Return the measured active (C0) frequency on this CPU since last call
  * to this function.
@@ -261,31 +285,12 @@ static u32 get_cur_val(const struct cpum
 static unsigned int get_measured_perf(struct cpufreq_policy *policy,
 				      unsigned int cpu)
 {
-	union {
-		struct {
-			u32 lo;
-			u32 hi;
-		} split;
-		u64 whole;
-	} aperf_cur, mperf_cur;
-
-	cpumask_t saved_mask;
+	struct perf_cur cur;
 	unsigned int perf_percent;
 	unsigned int retval;
 
-	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	if (get_cpu() != cpu) {
-		/* We were not able to run on requested processor */
-		put_cpu();
+	if (!work_on_cpu(cpu, read_measured_perf_ctrs, &cur))
 		return 0;
-	}
-
-	rdmsr(MSR_IA32_APERF, aperf_cur.split.lo, aperf_cur.split.hi);
-	rdmsr(MSR_IA32_MPERF, mperf_cur.split.lo, mperf_cur.split.hi);
-
-	wrmsr(MSR_IA32_APERF, 0,0);
-	wrmsr(MSR_IA32_MPERF, 0,0);
 
 #ifdef __i386__
 	/*
@@ -293,37 +298,39 @@ static unsigned int get_measured_perf(st
 	 * Get an approximate value. Return failure in case we cannot get
 	 * an approximate value.
 	 */
-	if (unlikely(aperf_cur.split.hi || mperf_cur.split.hi)) {
+	if (unlikely(cur.aperf_cur.split.hi || cur.mperf_cur.split.hi)) {
 		int shift_count;
 		u32 h;
 
-		h = max_t(u32, aperf_cur.split.hi, mperf_cur.split.hi);
+		h = max_t(u32, cur.aperf_cur.split.hi, cur.mperf_cur.split.hi);
 		shift_count = fls(h);
 
-		aperf_cur.whole >>= shift_count;
-		mperf_cur.whole >>= shift_count;
+		cur.aperf_cur.whole >>= shift_count;
+		cur.mperf_cur.whole >>= shift_count;
 	}
 
-	if (((unsigned long)(-1) / 100) < aperf_cur.split.lo) {
+	if (((unsigned long)(-1) / 100) < cur.aperf_cur.split.lo) {
 		int shift_count = 7;
-		aperf_cur.split.lo >>= shift_count;
-		mperf_cur.split.lo >>= shift_count;
+		cur.aperf_cur.split.lo >>= shift_count;
+		cur.mperf_cur.split.lo >>= shift_count;
 	}
 
-	if (aperf_cur.split.lo && mperf_cur.split.lo)
-		perf_percent = (aperf_cur.split.lo * 100) / mperf_cur.split.lo;
+	if (cur.aperf_cur.split.lo && cur.mperf_cur.split.lo)
+		perf_percent = (cur.aperf_cur.split.lo * 100) /
+				cur.mperf_cur.split.lo;
 	else
 		perf_percent = 0;
 
 #else
-	if (unlikely(((unsigned long)(-1) / 100) < aperf_cur.whole)) {
+	if (unlikely(((unsigned long)(-1) / 100) < cur.aperf_cur.whole)) {
 		int shift_count = 7;
-		aperf_cur.whole >>= shift_count;
-		mperf_cur.whole >>= shift_count;
+		cur.aperf_cur.whole >>= shift_count;
+		cur.mperf_cur.whole >>= shift_count;
 	}
 
-	if (aperf_cur.whole && mperf_cur.whole)
-		perf_percent = (aperf_cur.whole * 100) / mperf_cur.whole;
+	if (cur.aperf_cur.whole && cur.mperf_cur.whole)
+		perf_percent = (cur.aperf_cur.whole * 100) /
+				cur.mperf_cur.whole;
 	else
 		perf_percent = 0;
 
@@ -331,10 +338,6 @@ static unsigned int get_measured_perf(st
 
 	retval = per_cpu(drv_data, policy->cpu)->max_freq * perf_percent / 100;
 
-	put_cpu();
-	set_cpus_allowed_ptr(current, &saved_mask);
-
-	dprintk("cpu %d: performance percent %d\n", cpu, perf_percent);
 	return retval;
 }
 
@@ -352,7 +355,7 @@ static unsigned int get_cur_freq_on_cpu(
 	}
 
 	cached_freq = data->freq_table[data->acpi_data->state].frequency;
-	freq = extract_freq(get_cur_val(&cpumask_of_cpu(cpu)), data);
+	freq = extract_freq(get_cur_val(cpumask_of(cpu)), data);
 	if (freq != cached_freq) {
 		/*
 		 * The dreaded BIOS frequency change behind our back.

