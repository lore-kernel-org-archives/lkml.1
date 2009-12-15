Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbZLOELB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbZLOELB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759258AbZLOEKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:10:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759173AbZLOEHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:20 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 12/20] Higher accuracy TSC offset computation
Date: Mon, 14 Dec 2009 18:08:39 -1000
Message-Id: <1260850127-9766-13-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-12-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
 <1260850127-9766-5-git-send-email-zamsden@redhat.com>
 <1260850127-9766-6-git-send-email-zamsden@redhat.com>
 <1260850127-9766-7-git-send-email-zamsden@redhat.com>
 <1260850127-9766-8-git-send-email-zamsden@redhat.com>
 <1260850127-9766-9-git-send-email-zamsden@redhat.com>
 <1260850127-9766-10-git-send-email-zamsden@redhat.com>
 <1260850127-9766-11-git-send-email-zamsden@redhat.com>
 <1260850127-9766-12-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use per-cpu delta counters and statistically eliminate outliers which
might happen due to platform anomalies such as NMI.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |  100 +++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 71 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c4266f..c66dede 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -840,6 +840,11 @@ again:
 EXPORT_SYMBOL_GPL(kvm_get_ref_tsc);
 
 #define SYNC_TRIES 64
+struct cpu_delta_array {
+	s64 delta[SYNC_TRIES];
+};
+static DEFINE_PER_CPU(struct cpu_delta_array, delta_array);
+
 
 /*
  * sync_tsc_helper is a dual-entry coroutine meant to be run by only
@@ -849,25 +854,16 @@ EXPORT_SYMBOL_GPL(kvm_get_ref_tsc);
  *
  * To discount cache latency effects, this routine will be called
  * twice, one with the measure / recording CPUs reversed.  In addition,
- * the first 4 and last 2 results will be discarded to allow branch
- * predicition to become established (and to discount effects from
- * a potentially early predicted loop exit).
+ * the first and last results will be discarded to allow branch predicition
+ * to become established (and to discount effects from a potentially early
+ * predicted loop exit).
  *
- * Because of this, we must be extra careful to guard the entrance
- * and exit against the CPU switch.  I chose to use atomic instructions
- * only at the end of the measure loop and use the same routine for
- * both CPUs, with symmetric comparisons, and a statically placed
- * recording array, hopefully maximizing the branch predicition and
- * cache locality.  The results appear quite good; on known to be
- * synchronized CPUs, I typically get < 10 TSC delta measured, with
- * maximum observed error on the order of 100 cycles.
- *
- * This doesn't account for NUMA cache effects, and could potentially
- * be improved there by moving the delta[] array to the stack of the
- * measuring CPU.  In fact, this modification might be worth trying
- * for non-NUMA systems as well, but this appears to be fine for now.
+ * We allocate the delta array as a per-cpu variable to get local cache
+ * allocation, and also take steps to statistically ignore outliers which
+ * might be caused by SMIs.  It may seem like overkill, but it is very
+ * accurate, which is what we're aiming for.
  */
-static void sync_tsc_helper(int measure_cpu, u64 *delta, atomic_t *ready)
+static void sync_tsc_helper(int measure_cpu, s64 *delta, atomic_t *ready)
 {
 	int tries;
 	static u64 tsc_other;
@@ -915,12 +911,59 @@ static void sync_tsc_helper(int measure_cpu, u64 *delta, atomic_t *ready)
 	mb();
 }
 
+/*
+ * Average and trim the samples of any outliers; we use > 2 x sigma
+ */
+static s64 average_samples(s64 *samples, unsigned num_samples)
+{
+	unsigned i, j;
+	s64 mean;
+	u64 stddev;
+	s64 average;
+
+	/* First get the mean */
+	mean = 0;
+	for (i = 0; i < num_samples; i++)
+		mean += samples[i];
+	mean = mean / num_samples;
+
+	/* Now the deviation */
+	stddev = 0;
+	for (i = 0; i < num_samples; i++) {
+		s64 dev = samples[i] - mean;
+		stddev += dev * dev;
+	}
+	stddev = stddev / (num_samples - 1);
+	stddev = int_sqrt(stddev);
+
+	/* Throw out anything outside 2x stddev */
+	stddev <<= 1;
+	average = 0, j = 0;
+	for (i = 0; i < num_samples; i++) {
+		s64 dev = samples[i] - mean;
+		if (dev < 0)
+			dev = -dev;
+		if (dev <= stddev) {
+			average += samples[i];
+			j++;
+		}
+	}
+	if (j > 0)
+		average = average / j;
+	else
+		printk(KERN_ERR "kvm: TSC samples failed to converge!\n");
+	pr_debug("%s: mean = %lld, stddev = %llu, average = %lld\n",
+		 __func__, mean, stddev, average);
+
+	return average;
+}
+
 static void kvm_sync_tsc(void *cpup)
 {
 	int new_cpu = *(int *)cpup;
 	unsigned long flags;
-	static s64 delta[SYNC_TRIES*2];
-	static atomic_t ready = ATOMIC_INIT(1);
+	s64 *delta1, *delta2;
+	static atomic_t ready ____cacheline_aligned = ATOMIC_INIT(1);
 
 	BUG_ON(tsc_base_cpu == -1);
 	pr_debug("%s: IN, cpu = %d, freq = %ldkHz, tsc_base_cpu = %d\n", __func__, raw_smp_processor_id(), per_cpu(cpu_tsc_khz, raw_smp_processor_id()) , tsc_base_cpu);
@@ -933,27 +976,26 @@ static void kvm_sync_tsc(void *cpup)
 			&per_cpu(cpu_tsc_multiplier, new_cpu),
 			&per_cpu(cpu_tsc_shift, new_cpu));
 	}
-	sync_tsc_helper(tsc_base_cpu, delta, &ready);
-	sync_tsc_helper(new_cpu, &delta[SYNC_TRIES], &ready);
+	delta1 = per_cpu(delta_array, tsc_base_cpu).delta;
+	delta2 = per_cpu(delta_array, new_cpu).delta;
+	sync_tsc_helper(tsc_base_cpu, delta1, &ready);
+	sync_tsc_helper(new_cpu, delta2, &ready);
 	if (raw_smp_processor_id() == new_cpu) {
-		int i;
 		s64 accumulator = 0;
 
 		/*
-		 * accumulate [SYNC_TRIES+4,-2) of tsc{base} - tsc{new}
-		 * subtract   [SYNC_TRIES+4,-2) of tsc{new} - tsc{base}
+		 * accumulate [2,SYNC_TRIES-1) of tsc{base} - tsc{new}
+		 * subtract   [SYNC_TRIES+2,-1) of tsc{new} - tsc{base}
 		 *
 		 * this allows instruction cycle and cache differences to
 		 * cancel each other out and drops warm up/cool down variation
 		 *
 		 * Note the arithmatic must be signed because of the divide
 		 */
+		accumulator += average_samples(&delta1[2], SYNC_TRIES-3);
+		accumulator -= average_samples(&delta2[2], SYNC_TRIES-3);
+		accumulator /= 2;
 
-		for (i = 4; i < SYNC_TRIES - 2; i++)
-			accumulator += delta[i];
-		for (i = 4; i < SYNC_TRIES - 2; i++)
-			accumulator -= delta[i+SYNC_TRIES];
-		accumulator = accumulator / (SYNC_TRIES*2-12);
 		per_cpu(cpu_tsc_offset, new_cpu) = accumulator;
 		++per_cpu(cpu_tsc_generation, new_cpu);
 		atomic_set(&per_cpu(cpu_tsc_synchronized, new_cpu), 1);
-- 
1.6.5.2

