Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZKPMYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZKPMYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZKPMU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbZKPMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:43 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 30/42] KVM: Kill the confusing tsc_ref_khz and ref_freq variables
Date: Mon, 16 Nov 2009 14:19:31 +0200
Message-Id: <1258373983-8693-31-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zachary Amsden <zamsden@redhat.com>

They are globals, not clearly protected by any ordering or locking, and
vulnerable to various startup races.

Instead, for variable TSC machines, register the cpufreq notifier and get
the TSC frequency directly from the cpufreq machinery.  Not only is it
always right, it is also perfectly accurate, as no error prone measurement
is required.

On such machines, when a new CPU online is brought online, it isn't clear what
frequency it will start with, and it may not correspond to the reference, thus
in hardware_enable we clear the cpu_tsc_khz variable to zero and make sure
it is set before running on a VCPU.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6a31dfb..6f75856 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1326,6 +1326,8 @@ out:
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
+	if (unlikely(per_cpu(cpu_tsc_khz, cpu) == 0))
+		per_cpu(cpu_tsc_khz, cpu) = cpufreq_quick_get(cpu);
 	kvm_request_guest_time_update(vcpu);
 }
 
@@ -3063,9 +3065,6 @@ static void bounce_off(void *info)
 	/* nothing */
 }
 
-static unsigned int  ref_freq;
-static unsigned long tsc_khz_ref;
-
 static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 				     void *data)
 {
@@ -3074,14 +3073,11 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 	struct kvm_vcpu *vcpu;
 	int i, send_ipi = 0;
 
-	if (!ref_freq)
-		ref_freq = freq->old;
-
 	if (val == CPUFREQ_PRECHANGE && freq->old > freq->new)
 		return 0;
 	if (val == CPUFREQ_POSTCHANGE && freq->old < freq->new)
 		return 0;
-	per_cpu(cpu_tsc_khz, freq->cpu) = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
+	per_cpu(cpu_tsc_khz, freq->cpu) = freq->new;
 
 	spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
@@ -3122,12 +3118,14 @@ static void kvm_timer_init(void)
 {
 	int cpu;
 
-	for_each_possible_cpu(cpu)
-		per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
-		tsc_khz_ref = tsc_khz;
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
+		for_each_online_cpu(cpu)
+			per_cpu(cpu_tsc_khz, cpu) = cpufreq_get(cpu);
+	} else {
+		for_each_possible_cpu(cpu)
+			per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
 	}
 }
 
@@ -4700,6 +4698,14 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 
 int kvm_arch_hardware_enable(void *garbage)
 {
+	/*
+	 * Since this may be called from a hotplug notifcation,
+	 * we can't get the CPU frequency directly.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+		int cpu = raw_smp_processor_id();
+		per_cpu(cpu_tsc_khz, cpu) = 0;
+	}
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
-- 
1.6.5.2

