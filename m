Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbZLOEMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbZLOEMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759286AbZLOEM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:12:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758545AbZLOEHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:06 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 06/20] Make TSC reference stable across frequency changes
Date: Mon, 14 Dec 2009 18:08:33 -1000
Message-Id: <1260850127-9766-7-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-6-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
 <1260850127-9766-5-git-send-email-zamsden@redhat.com>
 <1260850127-9766-6-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the full infrastructure for dealing with dynamic TSC frequency
changes.  The only way to properly deal with this is to disable
hardware virtualization during a CPU frequency event; this is
possible because the CPU frequency module will call before and
after a change.  In that case, we simply resynchronize the TSCs
afterwards to ensure a monotonic, global TSC source.

This is complicated a bit by the fact that the master TSC reference
may or may not be part of the same package which is undergoing the
frequency modification, thus we must deal with the case when there
is no master CPU frequency change by allowing single CPUs to
initiate their own synchronization.

During initial setup, cpufreq callbacks can set the cpu_tsc_khz
concurrently with the update, so we fix this by protecting under the
kvm_tsc_lock.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |  163 +++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 122 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c4d2e0..144a820 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -741,9 +741,15 @@ static DEFINE_PER_CPU(unsigned long, cpu_tsc_multiplier);
 static DEFINE_PER_CPU(int, cpu_tsc_shift);
 static DEFINE_PER_CPU(s64, cpu_tsc_offset);
 static DEFINE_PER_CPU(u64, cpu_tsc_measure_base);
+static DEFINE_PER_CPU(atomic_t, cpu_tsc_synchronized);
 static int tsc_base_cpu = -1;
 static unsigned long ref_tsc_khz;
 
+static inline int cpu_is_tsc_synchronized(int cpu)
+{
+	return (atomic_read(&per_cpu(cpu_tsc_synchronized, cpu)) != 0);
+}
+
 static inline unsigned long div_precise(unsigned long hi, unsigned long lo,
 	unsigned long divisor, unsigned long *rptr)
 {
@@ -923,6 +929,7 @@ static void kvm_sync_tsc(void *cpup)
 			accumulator -= delta[i+SYNC_TRIES];
 		accumulator = accumulator / (SYNC_TRIES*2-12);
 		per_cpu(cpu_tsc_offset, new_cpu) = accumulator;
+		atomic_set(&per_cpu(cpu_tsc_synchronized, new_cpu), 1);
 		pr_debug("%s: OUT, cpu = %d, cpu_tsc_offset = %lld, cpu_tsc_multiplier=%ld, cpu_tsc_shift=%d\n", __func__, raw_smp_processor_id(), per_cpu(cpu_tsc_offset, new_cpu), per_cpu(cpu_tsc_multiplier, new_cpu), per_cpu(cpu_tsc_shift, new_cpu));
 	}
 	local_irq_restore(flags);
@@ -931,6 +938,11 @@ static void kvm_sync_tsc(void *cpup)
 static void kvm_do_sync_tsc(int cpu)
 {
 	spin_lock(&kvm_tsc_lock);
+
+	/* tsc_base_cpu can change without tsc_lock, so recheck */
+	if (unlikely(cpu == tsc_base_cpu))
+		goto out_unlock;
+
 	if (raw_smp_processor_id() != tsc_base_cpu) {
 		smp_call_function_single(tsc_base_cpu, kvm_sync_tsc,
 					 (void *)&cpu, 0);
@@ -940,6 +952,8 @@ static void kvm_do_sync_tsc(int cpu)
 		smp_call_function_single(tsc_base_cpu, kvm_sync_tsc,
 					 (void *)&cpu, 1);
 	}
+
+out_unlock:
 	spin_unlock(&kvm_tsc_lock);
 }
 
@@ -1656,7 +1670,6 @@ out:
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
-	BUG_ON(per_cpu(cpu_tsc_khz, cpu) == 0);
 	kvm_request_guest_time_update(vcpu);
 }
 
@@ -3461,11 +3474,46 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, int in,
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_pio_string);
 
-static void bounce_off(void *info)
+static void evict(void *info)
 {
 	/* nothing */
 }
 
+static struct execute_work resync_work;
+static int work_scheduled;
+
+static void resync_user(struct work_struct *work)
+{
+	int cpu;
+
+	work_scheduled = 0;
+	for_each_online_cpu(cpu)
+		if (cpu != tsc_base_cpu)
+			kvm_do_sync_tsc(cpu);
+}
+
+static void resync(void *info)
+{
+	int cpu;
+	u64 tsc;
+
+	/* Fixup our own values to stay in sync with the reference */
+	cpu = raw_smp_processor_id();
+	tsc = compute_ref_tsc(cpu);
+	per_cpu(cpu_tsc_measure_base, cpu) = native_read_tsc();
+	per_cpu(cpu_tsc_offset, cpu) = tsc;
+	compute_best_multiplier(ref_tsc_khz, per_cpu(cpu_tsc_khz, cpu),
+			&per_cpu(cpu_tsc_multiplier, cpu),
+			&per_cpu(cpu_tsc_shift, cpu));
+	atomic_set(&per_cpu(cpu_tsc_synchronized, cpu), 1);
+
+	/* Then, get everybody else on board */
+	if (!work_scheduled) {
+		work_scheduled = 1;
+		execute_in_process_context(resync_user, &resync_work);
+	}
+}
+
 static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 				     void *data)
 {
@@ -3474,39 +3522,68 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 	struct kvm_vcpu *vcpu;
 	int i, send_ipi = 0;
 
-	if (val == CPUFREQ_PRECHANGE && freq->old > freq->new)
-		return 0;
-	if (val == CPUFREQ_POSTCHANGE && freq->old < freq->new)
-		return 0;
-	per_cpu(cpu_tsc_khz, freq->cpu) = freq->new;
-
-	spin_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			if (vcpu->cpu != freq->cpu)
-				continue;
-			if (!kvm_request_guest_time_update(vcpu))
-				continue;
-			if (vcpu->cpu != smp_processor_id())
-				send_ipi++;
+	/*
+	 * There is no way to precisely know the TSC value at which time the
+	 * CPU frequency actually changed, and these callbacks may happen at
+	 * different times, thus there will be drift in the reference TSC
+	 * clock across all CPUs.  To avoid this problem, we forcibly evict
+	 * any CPUs which may be running in hardware virtualization.
+	 *
+	 * We do this by setting cpu_tsc_synchronized to zero and polling for
+	 * this value to change when entering hardware virtualization.
+	 */
+	if (val == CPUFREQ_PRECHANGE) {
+		get_online_cpus();
+		atomic_set(&per_cpu(cpu_tsc_synchronized, freq->cpu), 0);
+		spin_lock(&kvm_lock);
+		list_for_each_entry(kvm, &vm_list, vm_list) {
+			kvm_for_each_vcpu(i, vcpu, kvm) {
+				if (vcpu->cpu != freq->cpu)
+					continue;
+				if (vcpu->cpu != smp_processor_id())
+					send_ipi++;
+				kvm_request_guest_time_update(vcpu);
+			}
+		}
+		spin_unlock(&kvm_lock);
+		if (send_ipi) {
+			/*
+			 * In case we update the frequency for another cpu
+			 * (which might be in guest context) send an interrupt
+			 * to kick the cpu out of guest context.  Next time
+			 * guest context is entered kvmclock will be updated,
+			 * so the guest will not see stale values.
+			 */
+			smp_call_function_single(freq->cpu, evict, NULL, 1);
 		}
-	}
-	spin_unlock(&kvm_lock);
 
-	if (freq->old < freq->new && send_ipi) {
 		/*
-		 * We upscale the frequency.  Must make the guest
-		 * doesn't see old kvmclock values while running with
-		 * the new frequency, otherwise we risk the guest sees
-		 * time go backwards.
-		 *
-		 * In case we update the frequency for another cpu
-		 * (which might be in guest context) send an interrupt
-		 * to kick the cpu out of guest context.  Next time
-		 * guest context is entered kvmclock will be updated,
-		 * so the guest will not see stale values.
+		 * The update of the frequency can't happen while a VM
+		 * is running, nor can it happen during init when we can
+		 * race against the init code setting the first known freq.
+		 * Just use the vm_tsc_lock for a mutex.
 		 */
-		smp_call_function_single(freq->cpu, bounce_off, NULL, 1);
+		spin_lock(&kvm_tsc_lock);
+		per_cpu(cpu_tsc_khz, freq->cpu) = freq->new;
+		spin_unlock(&kvm_tsc_lock);
+
+		return 0;
+	}
+
+	/*
+	 * After the change, we must resynchronize affected CPUs.
+	 * If the master reference changes, that means all CPUs.
+	 * Note that some CPUs may be resynchronized twice, once
+	 * by the master, and once by themselves, depending on the
+	 * order in which this notifier is called; this is harmless.
+	 */
+	if (val == CPUFREQ_POSTCHANGE) {
+		if (freq->cpu == tsc_base_cpu)
+			smp_call_function_single(freq->cpu, resync, NULL, 1);
+		else if (cpu_is_tsc_synchronized(tsc_base_cpu))
+			/* Can't do this if base is not yet updated */
+			kvm_do_sync_tsc(freq->cpu);
+		put_online_cpus();
 	}
 	return 0;
 }
@@ -3536,8 +3613,7 @@ static int kvm_x86_cpu_hotplug(struct notifier_block *notifier,
 
 	case CPU_DYING:
 	case CPU_UP_CANCELED:
-		if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
-			per_cpu(cpu_tsc_khz, cpu) = 0;
+		atomic_set(&per_cpu(cpu_tsc_synchronized, cpu), 0);
 		break;
 
 	case CPU_ONLINE:
@@ -3590,6 +3666,12 @@ static void kvm_timer_init(void)
 		}
 	}
 #endif
+
+	/*
+	 * Register notifiers for both CPU add / remove and CPU frequency
+	 * change.  Must be careful to avoid subtle races, as frequency
+	 * can change at any time.
+	 */
 	register_cpu_notifier(&kvm_x86_cpu_notifier);
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
@@ -3598,7 +3680,10 @@ static void kvm_timer_init(void)
 			unsigned long khz = cpufreq_get(cpu);
 			if (!khz)
 				khz = tsc_khz;
-			per_cpu(cpu_tsc_khz, cpu) = khz;
+			spin_lock(&kvm_tsc_lock);
+			if (!per_cpu(cpu_tsc_khz, cpu))
+				per_cpu(cpu_tsc_khz, cpu) = khz;
+			spin_unlock(&kvm_tsc_lock);
 		}
 	} else {
 		for_each_possible_cpu(cpu)
@@ -3606,12 +3691,7 @@ static void kvm_timer_init(void)
 	}
 	tsc_base_cpu = get_cpu();
 	ref_tsc_khz = per_cpu(cpu_tsc_khz, tsc_base_cpu);
-	per_cpu(cpu_tsc_multiplier, tsc_base_cpu) = 1;
-	per_cpu(cpu_tsc_shift, tsc_base_cpu) = 0;
-	per_cpu(cpu_tsc_offset, tsc_base_cpu) = 0;
-	for_each_online_cpu(cpu)
-		if (cpu != tsc_base_cpu)
-			kvm_do_sync_tsc(cpu);
+	resync(NULL);
 	put_cpu();
 }
 
@@ -4097,7 +4177,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	clear_bit(KVM_REQ_KICK, &vcpu->requests);
 	smp_mb__after_clear_bit();
 
-	if (vcpu->requests || need_resched() || signal_pending(current)) {
+	if (vcpu->requests || need_resched() || signal_pending(current) ||
+	    !cpu_is_tsc_synchronized(smp_processor_id())) {
 		set_bit(KVM_REQ_KICK, &vcpu->requests);
 		local_irq_enable();
 		preempt_enable();
-- 
1.6.5.2

