Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZI2VlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZI2VlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZI2VlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:41:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbZI2Vk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:40:57 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4: kvm 2/4] Kill the confusing tsc_ref_khz and ref_freq variables.
Date: Tue, 29 Sep 2009 11:38:35 -1000
Message-Id: <1254260317-3490-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1254260317-3490-1-git-send-email-zamsden@redhat.com>
References: <4AC1C59F.6010703@redhat.com>
 <1254260317-3490-1-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/kvm/x86.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15d2ace..de4ce8f 100644
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
 
@@ -3061,9 +3063,6 @@ static void bounce_off(void *info)
 	/* nothing */
 }
 
-static unsigned int  ref_freq;
-static unsigned long tsc_khz_ref;
-
 static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 				     void *data)
 {
@@ -3072,14 +3071,11 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
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
@@ -3120,12 +3116,14 @@ static void kvm_timer_init(void)
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
 
@@ -4698,6 +4696,14 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 
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
1.6.4.4

