Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbZLOEHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbZLOEHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932506AbZLOEHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:07:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbZLOEHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:25 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 14/20] Move TSC cpu vars to a struct
Date: Mon, 14 Dec 2009 18:08:41 -1000
Message-Id: <1260850127-9766-15-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-14-git-send-email-zamsden@redhat.com>
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
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's enough of these floating around randomly to justify using a
structure for keeping them in one place.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |  110 ++++++++++++++++++++++++++++++----------------------
 1 files changed, 64 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8bd362b..7bc20ac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -738,19 +738,24 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
 }
 
 DEFINE_SPINLOCK(kvm_tsc_lock);
-static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
-static DEFINE_PER_CPU(unsigned long, cpu_tsc_multiplier);
-static DEFINE_PER_CPU(int, cpu_tsc_shift);
-static DEFINE_PER_CPU(s64, cpu_tsc_offset);
-static DEFINE_PER_CPU(u64, cpu_tsc_measure_base);
-static DEFINE_PER_CPU(atomic_t, cpu_tsc_synchronized);
-static DEFINE_PER_CPU(int, cpu_tsc_generation);
+struct cpu_tsc_vars
+{
+	unsigned long		tsc_khz;
+	unsigned long		tsc_multiplier;
+	unsigned int		tsc_shift;
+	int			tsc_generation;
+	s64			tsc_offset;
+	u64			tsc_measure_base;
+	atomic_t		tsc_synchronized;
+};
+static DEFINE_PER_CPU(struct cpu_tsc_vars, cpu_tsc_vars);
+
 static int tsc_base_cpu = -1;
 static unsigned long ref_tsc_khz;
 
 static inline int cpu_is_tsc_synchronized(int cpu)
 {
-	return (atomic_read(&per_cpu(cpu_tsc_synchronized, cpu)) != 0);
+	return (atomic_read(&per_cpu(cpu_tsc_vars, cpu).tsc_synchronized) != 0);
 }
 
 static inline unsigned long div_precise(unsigned long hi, unsigned long lo,
@@ -808,12 +813,12 @@ static inline unsigned long mult_precise(unsigned long val, unsigned long mult,
 	return bot;
 }
 
-static inline u64 compute_ref_tsc(int cpu)
+static inline u64 compute_ref_tsc(void)
 {
-	u64 tsc = native_read_tsc() - per_cpu(cpu_tsc_measure_base, cpu);
-	tsc = mult_precise(tsc, per_cpu(cpu_tsc_multiplier, cpu),
-				per_cpu(cpu_tsc_shift, cpu));
-	return tsc + per_cpu(cpu_tsc_offset, cpu);
+	struct cpu_tsc_vars *cv = &__get_cpu_var(cpu_tsc_vars);
+	u64 tsc = native_read_tsc() - cv->tsc_measure_base;
+	tsc = mult_precise(tsc, cv->tsc_multiplier, cv->tsc_shift);
+	return tsc + cv->tsc_offset;
 }
 
 /*
@@ -824,15 +829,17 @@ static inline u64 compute_ref_tsc(int cpu)
 u64 kvm_get_ref_tsc(void)
 {
 	int cpu, gen;
+	struct cpu_tsc_vars *cv;
 	u64 tsc;
 
 	cpu = get_cpu();
+	cv = &per_cpu(cpu_tsc_vars, cpu);
 again:
-	gen = per_cpu(cpu_tsc_generation, cpu);
+	gen = cv->tsc_generation;
 	smp_rmb();
-	tsc = compute_ref_tsc(cpu);
+	tsc = compute_ref_tsc();
 	smp_rmb();
-	if (unlikely(gen != per_cpu(cpu_tsc_generation, cpu)))
+	if (unlikely(gen != cv->tsc_generation))
 		goto again;
 	put_cpu();
 	return tsc;
@@ -889,7 +896,7 @@ static void sync_tsc_helper(int measure_cpu, s64 *delta, atomic_t *ready)
 				/* wait */;
 		}
 		native_cpuid(&junk, &junk, &junk, &junk);
-		tsc = compute_ref_tsc(cpu);
+		tsc = compute_ref_tsc();
 		rdtsc_barrier();
 		if (cpu == measure_cpu) {
 			while (!atomic_read(ready))
@@ -972,17 +979,18 @@ static void kvm_sync_tsc(void *cpup)
 	unsigned long flags;
 	s64 *delta1, *delta2;
 	static atomic_t ready ____cacheline_aligned = ATOMIC_INIT(1);
+	struct cpu_tsc_vars *cv = &per_cpu(cpu_tsc_vars, new_cpu);
 
 	BUG_ON(tsc_base_cpu == -1);
-	pr_debug("%s: IN, cpu = %d, freq = %ldkHz, tsc_base_cpu = %d\n", __func__, raw_smp_processor_id(), per_cpu(cpu_tsc_khz, raw_smp_processor_id()) , tsc_base_cpu);
 	local_irq_save(flags);
 	if (raw_smp_processor_id() == new_cpu) {
-		per_cpu(cpu_tsc_measure_base, new_cpu) = native_read_tsc();
-		per_cpu(cpu_tsc_offset, new_cpu) = 0;
-		compute_best_multiplier(ref_tsc_khz,
-			per_cpu(cpu_tsc_khz, new_cpu),
-			&per_cpu(cpu_tsc_multiplier, new_cpu),
-			&per_cpu(cpu_tsc_shift, new_cpu));
+		cv->tsc_measure_base = native_read_tsc();
+		cv->tsc_offset = 0;
+		compute_best_multiplier(ref_tsc_khz, cv->tsc_khz,
+			&cv->tsc_multiplier, &cv->tsc_shift);
+		pr_debug("%s: IN, cpu = %d, freq = %ldkHz, measure_base = %lld,"
+			 " tsc_base_cpu = %d\n", __func__, new_cpu, cv->tsc_khz,
+			 cv->tsc_measure_base, tsc_base_cpu);
 	}
 	delta1 = per_cpu(delta_array, tsc_base_cpu).delta;
 	delta2 = per_cpu(delta_array, new_cpu).delta;
@@ -1004,22 +1012,32 @@ static void kvm_sync_tsc(void *cpup)
 		accumulator -= average_samples(&delta2[2], SYNC_TRIES-3);
 		accumulator /= 2;
 
-		per_cpu(cpu_tsc_offset, new_cpu) = accumulator;
-		++per_cpu(cpu_tsc_generation, new_cpu);
-		atomic_set(&per_cpu(cpu_tsc_synchronized, new_cpu), 1);
-		pr_debug("%s: OUT, cpu = %d, cpu_tsc_offset = %lld, cpu_tsc_multiplier=%ld, cpu_tsc_shift=%d\n", __func__, raw_smp_processor_id(), per_cpu(cpu_tsc_offset, new_cpu), per_cpu(cpu_tsc_multiplier, new_cpu), per_cpu(cpu_tsc_shift, new_cpu));
+		cv->tsc_offset = accumulator;
+		smp_wmb();
+		++cv->tsc_generation;
+		atomic_set(&cv->tsc_synchronized, 1);
+		++kvm_stats.tsc_resync;
+		pr_debug("%s: OUT, cpu = %d, delta = %lld, cpu_tsc_offset = "
+			 "%lld, cpu_tsc_multiplier=%ld, cpu_tsc_shift=%d\n",
+			 __func__, new_cpu, accumulator, cv->tsc_offset,
+			 cv->tsc_multiplier, cv->tsc_shift);
 	}
 	local_irq_restore(flags);
 }
 
 static void kvm_do_sync_tsc(int cpu)
 {
+	BUG_ON(tsc_base_cpu == -1);
 	spin_lock(&kvm_tsc_lock);
 
 	/* tsc_base_cpu can change without tsc_lock, so recheck */
 	if (unlikely(cpu == tsc_base_cpu))
 		goto out_unlock;
 
+	/*
+	 * We're calling a co-routine; if we're one of the called CPUs, we
+	 * must call ourselves last.
+	 */
 	if (raw_smp_processor_id() != tsc_base_cpu) {
 		smp_call_function_single(tsc_base_cpu, kvm_sync_tsc,
 					 (void *)&cpu, 0);
@@ -1046,12 +1064,12 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	if ((!vcpu->time_page))
 		return;
 
-	this_tsc_khz = get_cpu_var(cpu_tsc_khz);
+	this_tsc_khz = get_cpu_var(cpu_tsc_vars).tsc_khz;
 	if (unlikely(vcpu->hv_clock_tsc_khz != this_tsc_khz)) {
 		kvm_set_time_scale(this_tsc_khz, &vcpu->hv_clock);
 		vcpu->hv_clock_tsc_khz = this_tsc_khz;
 	}
-	put_cpu_var(cpu_tsc_khz);
+	put_cpu_var(cpu_tsc_vars);
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
@@ -3572,18 +3590,16 @@ static void resync_user(struct work_struct *work)
 
 static void resync(void *info)
 {
-	int cpu;
+	struct cpu_tsc_vars *cv = &__get_cpu_var(cpu_tsc_vars);
 	u64 tsc;
 
 	/* Fixup our own values to stay in sync with the reference */
-	cpu = raw_smp_processor_id();
-	tsc = compute_ref_tsc(cpu);
-	per_cpu(cpu_tsc_measure_base, cpu) = native_read_tsc();
-	per_cpu(cpu_tsc_offset, cpu) = tsc;
-	compute_best_multiplier(ref_tsc_khz, per_cpu(cpu_tsc_khz, cpu),
-			&per_cpu(cpu_tsc_multiplier, cpu),
-			&per_cpu(cpu_tsc_shift, cpu));
-	atomic_set(&per_cpu(cpu_tsc_synchronized, cpu), 1);
+	tsc = compute_ref_tsc();
+	cv->tsc_measure_base = native_read_tsc();
+	cv->tsc_offset = tsc;
+	compute_best_multiplier(ref_tsc_khz, cv->tsc_khz, &cv->tsc_multiplier,
+				&cv->tsc_shift);
+	atomic_set(&cv->tsc_synchronized, 1);
 
 	/* Then, get everybody else on board */
 	if (!work_scheduled) {
@@ -3599,6 +3615,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	int i, send_ipi = 0;
+	struct cpu_tsc_vars *cv = &per_cpu(cpu_tsc_vars, freq->cpu);
 
 	/*
 	 * There is no way to precisely know the TSC value at which time the
@@ -3612,7 +3629,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 	 */
 	if (val == CPUFREQ_PRECHANGE) {
 		get_online_cpus();
-		atomic_set(&per_cpu(cpu_tsc_synchronized, freq->cpu), 0);
+		atomic_set(&cv->tsc_synchronized, 0);
 		spin_lock(&kvm_lock);
 		list_for_each_entry(kvm, &vm_list, vm_list) {
 			kvm_for_each_vcpu(i, vcpu, kvm) {
@@ -3642,7 +3659,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 		 * Just use the vm_tsc_lock for a mutex.
 		 */
 		spin_lock(&kvm_tsc_lock);
-		per_cpu(cpu_tsc_khz, freq->cpu) = freq->new;
+		cv->tsc_khz = freq->new;
 		spin_unlock(&kvm_tsc_lock);
 
 		return 0;
@@ -3691,12 +3708,13 @@ static int kvm_x86_cpu_hotplug(struct notifier_block *notifier,
 
 	case CPU_DYING:
 	case CPU_UP_CANCELED:
-		atomic_set(&per_cpu(cpu_tsc_synchronized, cpu), 0);
+		atomic_set(&per_cpu(cpu_tsc_vars, cpu).tsc_synchronized, 0);
 		break;
 
 	case CPU_ONLINE:
 		if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
-			per_cpu(cpu_tsc_khz, cpu) = cpufreq_quick_get(cpu);
+			per_cpu(cpu_tsc_vars, cpu).tsc_khz =
+				cpufreq_quick_get(cpu);
 		kvm_do_sync_tsc(cpu);
 		break;
 	}
@@ -3767,13 +3785,13 @@ static void kvm_timer_init(void)
 			if (!khz)
 				khz = tsc_khz;
 			spin_lock(&kvm_tsc_lock);
-			if (!per_cpu(cpu_tsc_khz, cpu))
-				per_cpu(cpu_tsc_khz, cpu) = khz;
+			if (!per_cpu(cpu_tsc_vars, cpu).tsc_khz)
+				per_cpu(cpu_tsc_vars, cpu).tsc_khz = khz;
 			spin_unlock(&kvm_tsc_lock);
 		}
 	} else {
 		for_each_possible_cpu(cpu)
-			per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
+			per_cpu(cpu_tsc_vars, cpu).tsc_khz = tsc_khz;
 	}
 	tsc_base_cpu = get_cpu();
 	resync(NULL);
-- 
1.6.5.2

