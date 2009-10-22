Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZJVMl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZJVMl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbZJVMl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:41:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40368 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbZJVMlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:20 -0400
Message-Id: <20091022124111.756583994@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:07:53 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 10/17] x86: Add generic aperf/mperf code
Content-Disposition: inline; filename=sched-lb-9-new.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    
Move some of the aperf/mperf code out from the cpufreq driver
thingy so that other people can enjoy it too.
    

Index: linux-2.6.31.4-rt14-lb1/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.31.4-rt14-lb1.orig/arch/x86/include/asm/processor.h	2009-10-21 10:47:17.000000000 -0400
+++ linux-2.6.31.4-rt14-lb1/arch/x86/include/asm/processor.h	2009-10-21 10:48:41.000000000 -0400
@@ -27,6 +27,7 @@
 #include <linux/cpumask.h>
 #include <linux/cache.h>
 #include <linux/threads.h>
+#include <linux/math64.h>
 #include <linux/init.h>
 
 /*
@@ -1010,4 +1011,33 @@
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
+struct aperfmperf {
+	u64 aperf, mperf;
+};
+
+static inline void get_aperfmperf(struct aperfmperf *am)
+{
+	WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_APERFMPERF));
+
+	rdmsrl(MSR_IA32_APERF, am->aperf);
+	rdmsrl(MSR_IA32_MPERF, am->mperf);
+}
+
+#define APERFMPERF_SHIFT 10
+
+static inline
+unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
+				    struct aperfmperf *new)
+{
+	u64 aperf = new->aperf - old->aperf;
+	u64 mperf = new->mperf - old->mperf;
+	unsigned long ratio = aperf;
+
+	mperf >>= APERFMPERF_SHIFT;
+	if (mperf)
+		ratio = div64_u64(aperf, mperf);
+
+	return ratio;
+}
+
 #endif /* _ASM_X86_PROCESSOR_H */
Index: linux-2.6.31.4-rt14-lb1/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
===================================================================
--- linux-2.6.31.4-rt14-lb1.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	2009-10-21 10:47:17.000000000 -0400
+++ linux-2.6.31.4-rt14-lb1/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	2009-10-21 10:48:41.000000000 -0400
@@ -70,11 +70,7 @@
 
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
 
-struct acpi_msr_data {
-	u64 saved_aperf, saved_mperf;
-};
-
-static DEFINE_PER_CPU(struct acpi_msr_data, msr_data);
+static DEFINE_PER_CPU(struct aperfmperf, old_perf);
 
 DEFINE_TRACE(power_mark);
 
@@ -243,23 +239,12 @@
 	return cmd.val;
 }
 
-struct perf_pair {
-	union {
-		struct {
-			u32 lo;
-			u32 hi;
-		} split;
-		u64 whole;
-	} aperf, mperf;
-};
-
 /* Called via smp_call_function_single(), on the target CPU */
 static void read_measured_perf_ctrs(void *_cur)
 {
-	struct perf_pair *cur = _cur;
+	struct aperfmperf *am = _cur;
 
-	rdmsr(MSR_IA32_APERF, cur->aperf.split.lo, cur->aperf.split.hi);
-	rdmsr(MSR_IA32_MPERF, cur->mperf.split.lo, cur->mperf.split.hi);
+	get_aperfmperf(am);
 }
 
 /*
@@ -278,63 +263,17 @@
 static unsigned int get_measured_perf(struct cpufreq_policy *policy,
 				      unsigned int cpu)
 {
-	struct perf_pair readin, cur;
-	unsigned int perf_percent;
+	struct aperfmperf perf;
+	unsigned long ratio;
 	unsigned int retval;
 
-	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &readin, 1))
+	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
 		return 0;
 
-	cur.aperf.whole = readin.aperf.whole -
-				per_cpu(msr_data, cpu).saved_aperf;
-	cur.mperf.whole = readin.mperf.whole -
-				per_cpu(msr_data, cpu).saved_mperf;
-	per_cpu(msr_data, cpu).saved_aperf = readin.aperf.whole;
-	per_cpu(msr_data, cpu).saved_mperf = readin.mperf.whole;
-
-#ifdef __i386__
-	/*
-	 * We dont want to do 64 bit divide with 32 bit kernel
-	 * Get an approximate value. Return failure in case we cannot get
-	 * an approximate value.
-	 */
-	if (unlikely(cur.aperf.split.hi || cur.mperf.split.hi)) {
-		int shift_count;
-		u32 h;
-
-		h = max_t(u32, cur.aperf.split.hi, cur.mperf.split.hi);
-		shift_count = fls(h);
-
-		cur.aperf.whole >>= shift_count;
-		cur.mperf.whole >>= shift_count;
-	}
-
-	if (((unsigned long)(-1) / 100) < cur.aperf.split.lo) {
-		int shift_count = 7;
-		cur.aperf.split.lo >>= shift_count;
-		cur.mperf.split.lo >>= shift_count;
-	}
-
-	if (cur.aperf.split.lo && cur.mperf.split.lo)
-		perf_percent = (cur.aperf.split.lo * 100) / cur.mperf.split.lo;
-	else
-		perf_percent = 0;
-
-#else
-	if (unlikely(((unsigned long)(-1) / 100) < cur.aperf.whole)) {
-		int shift_count = 7;
-		cur.aperf.whole >>= shift_count;
-		cur.mperf.whole >>= shift_count;
-	}
-
-	if (cur.aperf.whole && cur.mperf.whole)
-		perf_percent = (cur.aperf.whole * 100) / cur.mperf.whole;
-	else
-		perf_percent = 0;
-
-#endif
+	ratio = calc_aperfmperf_ratio(&per_cpu(old_perf, cpu), &perf);
+	per_cpu(old_perf, cpu) = perf;
 
-	retval = (policy->cpuinfo.max_freq * perf_percent) / 100;
+	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
 
 	return retval;
 }

--
