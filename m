Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbZIPKXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbZIPKXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZIPKXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:23:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:46580 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbZIPKX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:23:29 -0400
Date: Wed, 16 Sep 2009 10:23:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com,
       venkatesh.pallipadi@intel.com, davej@redhat.com, yhlu.kernel@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, venkatesh.pallipadi@intel.com,
       yanmin_zhang@linux.intel.com, davej@redhat.com, yhlu.kernel@gmail.com,
       tglx@linutronix.de, len.brown@intel.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] x86: Add generic aperf/mperf code
Message-ID: <tip-5cbc19a983141729d716be17197028434127b376@git.kernel.org>
Git-Commit-ID: 5cbc19a983141729d716be17197028434127b376
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:23:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cbc19a983141729d716be17197028434127b376
Gitweb:     http://git.kernel.org/tip/5cbc19a983141729d716be17197028434127b376
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 2 Sep 2009 11:49:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:51:26 +0200

x86: Add generic aperf/mperf code

Move some of the aperf/mperf code out from the cpufreq driver
thingy so that other people can enjoy it too.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Yanmin <yanmin_zhang@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: cpufreq@vger.kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/processor.h           |   30 +++++++++++
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   79 +++------------------------
 2 files changed, 39 insertions(+), 70 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index e08ea04..4ae2ccf 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -27,6 +27,7 @@ struct mm_struct;
 #include <linux/cpumask.h>
 #include <linux/cache.h>
 #include <linux/threads.h>
+#include <linux/math64.h>
 #include <linux/init.h>
 
 /*
@@ -1020,4 +1021,33 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
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
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 509e6a7..4109679 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -70,11 +70,7 @@ struct acpi_cpufreq_data {
 
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
 
-struct acpi_msr_data {
-	u64 saved_aperf, saved_mperf;
-};
-
-static DEFINE_PER_CPU(struct acpi_msr_data, msr_data);
+static DEFINE_PER_CPU(struct aperfmperf, old_perf);
 
 DEFINE_TRACE(power_mark);
 
@@ -243,23 +239,12 @@ static u32 get_cur_val(const struct cpumask *mask)
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
@@ -278,63 +263,17 @@ static void read_measured_perf_ctrs(void *_cur)
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
