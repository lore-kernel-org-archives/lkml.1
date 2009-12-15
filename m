Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbZLOEJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbZLOEJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbZLOEIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:08:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbZLOEHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:33 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 17/20] Periodically measure TSC skew
Date: Mon, 14 Dec 2009 18:08:44 -1000
Message-Id: <1260850127-9766-18-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-17-git-send-email-zamsden@redhat.com>
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
 <1260850127-9766-13-git-send-email-zamsden@redhat.com>
 <1260850127-9766-14-git-send-email-zamsden@redhat.com>
 <1260850127-9766-15-git-send-email-zamsden@redhat.com>
 <1260850127-9766-16-git-send-email-zamsden@redhat.com>
 <1260850127-9766-17-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resync all CPUs to measure TSC skew periodically.  Use the measured skew
to adjust the resync time (not done yet - heuristic needed)

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 792c895..3a854ec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -750,9 +750,10 @@ struct cpu_tsc_vars
 	u64			last_ref;
 };
 static DEFINE_PER_CPU(struct cpu_tsc_vars, cpu_tsc_vars);
-
 static int tsc_base_cpu = -1;
 static unsigned long ref_tsc_khz;
+static u64 tsc_drift;
+static struct timer_list resync_timer;
 
 static inline int cpu_is_tsc_synchronized(int cpu)
 {
@@ -935,6 +936,7 @@ static void sync_tsc_helper(int measure_cpu, s64 *delta, atomic_t *ready)
  * Average and trim the samples of any outliers; we use > 2 x sigma
  */
 static u64 tsc_deviation;
+static u64 tsc_skew;
 static s64 average_samples(s64 *samples, unsigned num_samples)
 {
 	unsigned i, j;
@@ -993,10 +995,24 @@ static void kvm_sync_tsc(void *cpup)
 	s64 *delta1, *delta2;
 	static atomic_t ready ____cacheline_aligned = ATOMIC_INIT(1);
 	struct cpu_tsc_vars *cv = &per_cpu(cpu_tsc_vars, new_cpu);
+	static u64 old_base;
+	static s64 old_offset;
+	static unsigned long old_multiplier;
+	static unsigned int old_shift;
 
 	BUG_ON(tsc_base_cpu == -1);
 	local_irq_save(flags);
+
+	/*
+	 * First, the new CPU may be just coming up to sync or might have
+	 * changed frequency, which means the measurement base must be
+	 * adjusted.  If not, we can use it to compute a skew estimate.
+	 */
 	if (raw_smp_processor_id() == new_cpu) {
+		old_multiplier = cv->tsc_multiplier;
+		old_shift = cv->tsc_shift;
+		old_base = cv->tsc_measure_base;
+		old_offset = cv->tsc_offset;
 		cv->tsc_measure_base = native_read_tsc();
 		cv->tsc_offset = 0;
 		compute_best_multiplier(ref_tsc_khz, cv->tsc_khz,
@@ -1005,10 +1021,12 @@ static void kvm_sync_tsc(void *cpup)
 			 " tsc_base_cpu = %d\n", __func__, new_cpu, cv->tsc_khz,
 			 cv->tsc_measure_base, tsc_base_cpu);
 	}
+
 	delta1 = per_cpu(delta_array, tsc_base_cpu).delta;
 	delta2 = per_cpu(delta_array, new_cpu).delta;
 	sync_tsc_helper(tsc_base_cpu, delta1, &ready);
 	sync_tsc_helper(new_cpu, delta2, &ready);
+
 	if (raw_smp_processor_id() == new_cpu) {
 		s64 accumulator = 0;
 
@@ -1024,8 +1042,40 @@ static void kvm_sync_tsc(void *cpup)
 		accumulator += average_samples(&delta1[2], SYNC_TRIES-3);
 		accumulator -= average_samples(&delta2[2], SYNC_TRIES-3);
 		accumulator /= 2;
-
 		cv->tsc_offset = accumulator;
+
+		/*
+		 * Skew can be computed over a constant multiplier as follows:
+		 *
+		 * ref_new = (tsc_new - base_new) * mult + off_new
+		 * ref_old = (tsc_old - base_old) * mult + off_old
+		 *
+		 * skew = ref_new - (ref_old + delta_ref)
+		 *
+		 * skew = off_new - off_old + mult(tsc_new - tsc_old)
+		 *                - mult(base_new - base_old) - delta_ref
+		 *
+		 * The tsc_old / tsc_new values are not recoverable, but
+		 * observe that mult(tsc_new - tsc_old) == delta_ref, so
+		 *
+		 *    skew = delta(off) - mult(delta base)
+		 *
+		 * To avoid problems with signed computation, we multiply
+		 * unsigned numbers first before switching to signed arithmetic
+		 */
+		if (old_multiplier == cv->tsc_multiplier &&
+		    old_shift == cv->tsc_shift) {
+			u64 sbo = old_base, sbn = cv->tsc_measure_base;
+			s64 skew;
+			sbo = mult_precise(sbo, old_multiplier, old_shift);
+			sbn = mult_precise(sbn, old_multiplier, old_shift);
+			skew = cv->tsc_offset - old_offset + (sbo - sbn);
+			if (skew < 0)
+				skew = -skew;
+			if (skew > tsc_skew)
+				tsc_skew = skew;
+		}
+
 		smp_wmb();
 		++cv->tsc_generation;
 		atomic_set(&cv->tsc_synchronized, 1);
@@ -3611,6 +3661,8 @@ static long resync(void *unused)
 	struct cpu_tsc_vars *cv = &__get_cpu_var(cpu_tsc_vars);
 	u64 tsc = 0;
 	int cpu;
+	static unsigned long jif_old;
+	unsigned long jif_delta;
 
 	/*
 	 * First, make sure we are on the right CPU; between when the work got
@@ -3643,17 +3695,28 @@ static long resync(void *unused)
 	cv->tsc_generation++; // XXX needed? */
 	compute_best_multiplier(ref_tsc_khz, cv->tsc_khz, &cv->tsc_multiplier,
 				&cv->tsc_shift);
+	tsc_skew = 0;
 	atomic_set(&cv->tsc_synchronized, 1);
+	smp_wmb();
 
 	for_each_online_cpu(cpu)
 		kvm_do_sync_tsc(cpu);
 
+	for_each_online_cpu(cpu)
+		while (!cpu_is_tsc_synchronized(cpu))
+			cpu_relax();
+
+	smp_rmb();
+	jif_delta = jiffies - jif_old;
+	pr_debug("max TSC skew now estimated at %llu over %lu jiffies\n",
+		 tsc_skew, jif_delta);
+	jif_old = jiffies;
+	mod_timer(&resync_timer, jiffies + HZ * 50);
 	put_cpu();
 	return 0;
 }
 
 static DEFINE_MUTEX(resync_lock);
-
 static void resync_all(void)
 {
 	mutex_lock(&resync_lock);
@@ -3662,6 +3725,18 @@ static void resync_all(void)
 	mutex_unlock(&resync_lock);
 }
 
+static struct work_struct resync_work;
+static void resync_work_fn(struct work_struct *work)
+{
+	resync_all();
+}
+
+static void resync_callout(unsigned long unused)
+{
+	INIT_WORK(&resync_work, resync_work_fn);
+	schedule_work(&resync_work);
+}
+
 static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 				     void *data)
 {
@@ -3836,6 +3911,15 @@ static void kvm_timer_init(void)
 		for_each_possible_cpu(cpu)
 			per_cpu(cpu_tsc_vars, cpu).tsc_khz = tsc_khz;
 	}
+
+	/*
+	 * Now, pick a CPU to make the master and synchronize all other
+	 * CPUs to it's clock.  Periodically check for drift as well.
+	 * Our initial drift estimate is 1 ppm / sec.
+	 */
+	tsc_drift = ref_tsc_khz / 1000;
+	init_timer(&resync_timer);
+	resync_timer.function = resync_callout;
 	tsc_base_cpu = get_cpu();
 	put_cpu();
 	resync_all();
@@ -3898,6 +3982,9 @@ void kvm_arch_exit(void)
 			pci_write_config_byte(*nb, 0x87, disabled_c1_ramp);
 	}
 #endif
+	mutex_lock(&resync_lock);
+	del_timer(&resync_timer);
+	mutex_unlock(&resync_lock);
 }
 
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
-- 
1.6.5.2

