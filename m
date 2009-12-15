Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZLOEHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZLOEHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755719AbZLOEHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:07:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbZLOEH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:27 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 15/20] Fix longstanding races
Date: Mon, 14 Dec 2009 18:08:42 -1000
Message-Id: <1260850127-9766-16-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-15-git-send-email-zamsden@redhat.com>
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
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, we could get multiple CPU frequency updates in rapid succession.
If the base CPU changes, we must resynchronize all CPUs, but the work
scheduling was poorly serialized, which could result in some CPUs
missing the resynchronize action.

Second, the work function doesn't protect against CPU hotplug, and
further, it isn't actually possible; we would have to hold-off CPU
hotplug through the IPIs.

Third, we could potentially interrupt a call to get the reference
clock on the base CPU with a resync IPI, resulting in a skewed return
value in the original call.

The problem stems from the fact that any random CPU may come along and
change the tsc_khz variable of another; at the same time, we are doing
resynchronize through an IPI which requires us to abstain from using
higher level mutex primitives.  Combined with the fact that without
locking, we can't guarantee the tsc_base_cpu is stable, this makes most
locking schemes untenable.

So, I fix the flaw by creating these rules:
	1) per_cpu tsc_khz variable is updated only on the local CPU
	2) tsc_base_cpu is changed only in CPU take down

Now, we can avoid CPU takedown by simply entering a preemption disabled
state; CPU take down is done as a stop_machine action, and thus can't
run concurrently with any preemption disabled region.  So, we can now
guarantee tsc_base_cpu is stable with just get_cpu().

Further, since all tsc_khz updates are local, we can avoid tsc_khz
changes by blocking interrupts.  This isn't used for the general
kvm_get_ref_tsc(), which doesn't need to use such a heavy primitive,
but it is useful when resynchronizing to the master; the evict()
callout used to find how far advanced slave CPUs have advanced since
the master frequency change requires not to be interrupted with
another frequency change (this frequency change is likely as the
callouts to notifier chains for the CPU frequency change can happen
in the order {PRE|BASE},{PRE|NON-BASE}; the first callout will try
to schedule resync_all as work to be done).  Using the fact that the
tsc_khz update only happens from an interrupt also allows us to
simplify the generation update; no intermediate generations can ever
be observed, thus we can simplify the generation count again.

Damn, this is complicated crap.  The analagous task in real life would
be keeping a band of howler monkeys, each in their own tree, singing in
unison while the lead vocalist jumps from tree to tree, and meanwhile,
an unseen conductor keeps changing the tempo the piece is played at.
Thankfully, there are no key changes, however, occasionally new trees
sprout up at random and live ones fall over.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |  139 ++++++++++++++++++++++++++++++++--------------------
 1 files changed, 85 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7bc20ac..7e2ba3e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -747,6 +747,7 @@ struct cpu_tsc_vars
 	s64			tsc_offset;
 	u64			tsc_measure_base;
 	atomic_t		tsc_synchronized;
+	u64			last_ref;
 };
 static DEFINE_PER_CPU(struct cpu_tsc_vars, cpu_tsc_vars);
 
@@ -3570,42 +3571,83 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, int in,
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_pio_string);
 
-static void evict(void *info)
+/*
+ * evict(struct cpufreq_freqs *data)
+ *
+ * This function is meant to be called from an IPI and runs with
+ * interrupts disabled.  It records the last good value of the
+ * reference TSC before optionally updating the CPU frequency and
+ * marking the CPU unsynchronized.  Since it is entered from an
+ * interrupt handler, it can be used to bring CPUs out of hardware
+ * virtualization and have them wait until their clock has been
+ * resynchronized.
+ */
+static void evict(void *data)
 {
-	/* nothing */
+	struct cpu_tsc_vars *cv = &__get_cpu_var(cpu_tsc_vars);
+	WARN_ON(!irqs_disabled());
+	cv->last_ref = compute_ref_tsc();
+	if (data) {
+		struct cpufreq_freqs *freq = data;
+		cv->tsc_khz = freq->new;
+	}
+	atomic_set(&cv->tsc_synchronized, 0);
 }
 
-static struct execute_work resync_work;
-static int work_scheduled;
-
-static void resync_user(struct work_struct *work)
+static long resync(void *unused)
 {
+	struct cpu_tsc_vars *cv = &__get_cpu_var(cpu_tsc_vars);
+	u64 tsc = 0;
 	int cpu;
 
-	work_scheduled = 0;
-	for_each_online_cpu(cpu)
-		if (cpu != tsc_base_cpu)
-			kvm_do_sync_tsc(cpu);
-}
+	/*
+	 * First, make sure we are on the right CPU; between when the work got
+	 * scheduled and when this runs, the tsc_base could have changed.  We
+	 * lock out changes to tsc_base_cpu with cpu_get().  The cpu takedown
+	 * code can't run until all non-preempt sections are finished, so being
+	 * in a non-preempt section protects the base from changing.  Tricky.
+	 */
+	cpu = get_cpu();
+	if (cpu != tsc_base_cpu)
+		return -1;
 
-static void resync(void *info)
-{
-	struct cpu_tsc_vars *cv = &__get_cpu_var(cpu_tsc_vars);
-	u64 tsc;
+	/*
+	 * When the base CPU frequency changes independenetly of other
+	 * cores, the reference TSC can fall behind.  Rather than
+	 * introduce a complicated and fragile locking scheme for this
+	 * rare case, simply evict all CPUs from VM execution and take
+	 * the highest global reference clock.  This also allows us to
+	 * recover from skew events which slightly advance other clocks
+	 * relative to the base.
+	 */
+	on_each_cpu(evict, NULL, 1);
+	for_each_online_cpu(cpu)
+		if (per_cpu(cpu_tsc_vars, cpu).last_ref > tsc)
+			tsc = per_cpu(cpu_tsc_vars, cpu).last_ref;
 
 	/* Fixup our own values to stay in sync with the reference */
-	tsc = compute_ref_tsc();
 	cv->tsc_measure_base = native_read_tsc();
 	cv->tsc_offset = tsc;
+	cv->tsc_generation++; // XXX needed? */
 	compute_best_multiplier(ref_tsc_khz, cv->tsc_khz, &cv->tsc_multiplier,
 				&cv->tsc_shift);
 	atomic_set(&cv->tsc_synchronized, 1);
 
-	/* Then, get everybody else on board */
-	if (!work_scheduled) {
-		work_scheduled = 1;
-		execute_in_process_context(resync_user, &resync_work);
-	}
+	for_each_online_cpu(cpu)
+		kvm_do_sync_tsc(cpu);
+
+	put_cpu();
+	return 0;
+}
+
+static DEFINE_MUTEX(resync_lock);
+
+static void resync_all(void)
+{
+	mutex_lock(&resync_lock);
+	while (work_on_cpu(tsc_base_cpu, resync, NULL) != 0);
+		/* do nothing */
+	mutex_unlock(&resync_lock);
 }
 
 static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
@@ -3614,8 +3656,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 	struct cpufreq_freqs *freq = data;
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
-	int i, send_ipi = 0;
-	struct cpu_tsc_vars *cv = &per_cpu(cpu_tsc_vars, freq->cpu);
+	int i;
 
 	/*
 	 * There is no way to precisely know the TSC value at which time the
@@ -3625,43 +3666,34 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 	 * any CPUs which may be running in hardware virtualization.
 	 *
 	 * We do this by setting cpu_tsc_synchronized to zero and polling for
-	 * this value to change when entering hardware virtualization.
+	 * this value to change when entering hardware virtualization; this
+	 * will happen in the call to evict(), which also stores the new freq
 	 */
 	if (val == CPUFREQ_PRECHANGE) {
-		get_online_cpus();
-		atomic_set(&cv->tsc_synchronized, 0);
 		spin_lock(&kvm_lock);
 		list_for_each_entry(kvm, &vm_list, vm_list) {
 			kvm_for_each_vcpu(i, vcpu, kvm) {
 				if (vcpu->cpu != freq->cpu)
 					continue;
-				if (vcpu->cpu != smp_processor_id())
-					send_ipi++;
 				kvm_request_guest_time_update(vcpu);
 			}
 		}
 		spin_unlock(&kvm_lock);
-		if (send_ipi) {
-			/*
-			 * In case we update the frequency for another cpu
-			 * (which might be in guest context) send an interrupt
-			 * to kick the cpu out of guest context.  Next time
-			 * guest context is entered kvmclock will be updated,
-			 * so the guest will not see stale values.
-			 */
-			smp_call_function_single(freq->cpu, evict, NULL, 1);
-		}
 
 		/*
-		 * The update of the frequency can't happen while a VM
-		 * is running, nor can it happen during init when we can
-		 * race against the init code setting the first known freq.
-		 * Just use the vm_tsc_lock for a mutex.
+		 * In case we update the frequency for another cpu (which might
+		 * be in guest context) we must send an interrupt to kick the
+		 * cpu out of guest context.  Next time guest context is
+		 * entered kvmclock will be updated, so the guest will not see
+		 * stale values.
+		 *
+		 * The update of the frequency can't happen while a VM is
+		 * running, nor can it happen while we might be possibly
+		 * running a resync.  To avoid locking problems which arise
+		 * otherwise, always update the tsc_khz value on the affected
+		 * processor; this is done by passing the freq data to evict
 		 */
-		spin_lock(&kvm_tsc_lock);
-		cv->tsc_khz = freq->new;
-		spin_unlock(&kvm_tsc_lock);
-
+		smp_call_function_single(freq->cpu, evict, data, 1);
 		return 0;
 	}
 
@@ -3673,8 +3705,9 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 	 * order in which this notifier is called; this is harmless.
 	 */
 	if (val == CPUFREQ_POSTCHANGE) {
+		get_online_cpus();
 		if (freq->cpu == tsc_base_cpu)
-			smp_call_function_single(freq->cpu, resync, NULL, 1);
+			resync_all();
 		else if (cpu_is_tsc_synchronized(tsc_base_cpu))
 			/* Can't do this if base is not yet updated */
 			kvm_do_sync_tsc(freq->cpu);
@@ -3694,19 +3727,17 @@ static int kvm_x86_cpu_hotplug(struct notifier_block *notifier,
 
 	val &= ~CPU_TASKS_FROZEN;
 	switch (val) {
-	case CPU_DOWN_PREPARE:
+	case CPU_DYING:
 		if (cpu == tsc_base_cpu) {
 			int new_cpu;
-			spin_lock(&kvm_tsc_lock);
 			for_each_online_cpu(new_cpu)
 				if (new_cpu != tsc_base_cpu)
 					break;
 			tsc_base_cpu = new_cpu;
-			spin_unlock(&kvm_tsc_lock);
 		}
 		break;
 
-	case CPU_DYING:
+	case CPU_DOWN_PREPARE:
 	case CPU_UP_CANCELED:
 		atomic_set(&per_cpu(cpu_tsc_vars, cpu).tsc_synchronized, 0);
 		break;
@@ -3784,18 +3815,18 @@ static void kvm_timer_init(void)
 			unsigned long khz = cpufreq_get(cpu);
 			if (!khz)
 				khz = tsc_khz;
-			spin_lock(&kvm_tsc_lock);
+			local_irq_disable();
 			if (!per_cpu(cpu_tsc_vars, cpu).tsc_khz)
 				per_cpu(cpu_tsc_vars, cpu).tsc_khz = khz;
-			spin_unlock(&kvm_tsc_lock);
+			local_irq_enable();
 		}
 	} else {
 		for_each_possible_cpu(cpu)
 			per_cpu(cpu_tsc_vars, cpu).tsc_khz = tsc_khz;
 	}
 	tsc_base_cpu = get_cpu();
-	resync(NULL);
 	put_cpu();
+	resync_all();
 }
 
 int kvm_arch_init(void *opaque)
-- 
1.6.5.2

