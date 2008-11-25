Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbYKYVs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbYKYVs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYKYVpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:45:08 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46168 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbYKYVpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:45:06 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 5/6] acpi_cpufreq: Use centralized APERF/MPERF function calls
To: "Darrick J. Wong" <djwong@us.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar.sarma@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2008 13:45:03 -0800
Message-ID: <20081125214503.22900.49148.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
References: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've centralized APERF/MPERF accessor functions and hooked up
the chargeback accounting code to it, convert the only other user of the
APERF/MPERF MSRs to use those functions as well.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   73 +++++-----------------------
 1 files changed, 14 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 8e48c5d..21958af 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -57,7 +57,6 @@ enum {
 };
 
 #define INTEL_MSR_RANGE		(0xffff)
-#define CPUID_6_ECX_APERFMPERF_CAPABILITY	(0x1)
 
 struct acpi_cpufreq_data {
 	struct acpi_processor_performance *acpi_data;
@@ -243,6 +242,9 @@ static u32 get_cur_val(const cpumask_t *mask)
 	return cmd.val;
 }
 
+DEFINE_PER_CPU(u64, cpufreq_old_aperf);
+DEFINE_PER_CPU(u64, cpufreq_old_mperf);
+
 /*
  * Return the measured active (C0) frequency on this CPU since last call
  * to this function.
@@ -259,16 +261,8 @@ static u32 get_cur_val(const cpumask_t *mask)
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
+	u64 aperf_cur, mperf_cur;
 	cpumask_t saved_mask;
-	unsigned int perf_percent;
 	unsigned int retval;
 
 	saved_mask = current->cpus_allowed;
@@ -279,60 +273,21 @@ static unsigned int get_measured_perf(struct cpufreq_policy *policy,
 		return 0;
 	}
 
-	rdmsr(MSR_IA32_APERF, aperf_cur.split.lo, aperf_cur.split.hi);
-	rdmsr(MSR_IA32_MPERF, mperf_cur.split.lo, mperf_cur.split.hi);
-
-	wrmsr(MSR_IA32_APERF, 0,0);
-	wrmsr(MSR_IA32_MPERF, 0,0);
-
-#ifdef __i386__
-	/*
-	 * We dont want to do 64 bit divide with 32 bit kernel
-	 * Get an approximate value. Return failure in case we cannot get
-	 * an approximate value.
-	 */
-	if (unlikely(aperf_cur.split.hi || mperf_cur.split.hi)) {
-		int shift_count;
-		u32 h;
-
-		h = max_t(u32, aperf_cur.split.hi, mperf_cur.split.hi);
-		shift_count = fls(h);
-
-		aperf_cur.whole >>= shift_count;
-		mperf_cur.whole >>= shift_count;
-	}
-
-	if (((unsigned long)(-1) / 100) < aperf_cur.split.lo) {
-		int shift_count = 7;
-		aperf_cur.split.lo >>= shift_count;
-		mperf_cur.split.lo >>= shift_count;
-	}
-
-	if (aperf_cur.split.lo && mperf_cur.split.lo)
-		perf_percent = (aperf_cur.split.lo * 100) / mperf_cur.split.lo;
-	else
-		perf_percent = 0;
-
-#else
-	if (unlikely(((unsigned long)(-1) / 100) < aperf_cur.whole)) {
-		int shift_count = 7;
-		aperf_cur.whole >>= shift_count;
-		mperf_cur.whole >>= shift_count;
-	}
-
-	if (aperf_cur.whole && mperf_cur.whole)
-		perf_percent = (aperf_cur.whole * 100) / mperf_cur.whole;
-	else
-		perf_percent = 0;
-
-#endif
+	/* Calculate difference in APERF and MPERF. */
+	get_intel_aperf_mperf_registers(&aperf_cur, &mperf_cur);
+	aperf_cur = delta_perf(aperf_cur, &(per_cpu(cpufreq_old_aperf,
+						    smp_processor_id())));
+	mperf_cur = delta_perf(mperf_cur, &(per_cpu(cpufreq_old_mperf,
+						    smp_processor_id())));
 
-	retval = per_cpu(drv_data, policy->cpu)->max_freq * perf_percent / 100;
+	/* Scale CPU frequency according to APERF/MPERF. */
+	retval = scale_with_perf(per_cpu(drv_data, policy->cpu)->max_freq,
+				 aperf_cur, mperf_cur);
 
 	put_cpu();
 	set_cpus_allowed_ptr(current, &saved_mask);
 
-	dprintk("cpu %d: performance percent %d\n", cpu, perf_percent);
+	dprintk("cpu %d: performance freq %d\n", cpu, retval);
 	return retval;
 }
 

