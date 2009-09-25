Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZIYAtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZIYAtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZIYAte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:49:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbZIYAtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:49:32 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH: kvm 2/5] Kill the confusing tsc_ref_khz and ref_freq variables.
Date: Thu, 24 Sep 2009 14:47:17 -1000
Message-Id: <1253839640-12695-3-git-send-email-zamsden@redhat.com>
In-Reply-To: <1253839640-12695-2-git-send-email-zamsden@redhat.com>
References: <20090924151049.GB14102@amt.cnet>
 <1253839640-12695-1-git-send-email-zamsden@redhat.com>
 <1253839640-12695-2-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are globals, not clearly protected by any ordering or locking, and
vulnerable to various startup races.

Instead, for variable TSC machines, register the cpufreq notifier and get
the TSC frequency directly from the cpufreq machinery.  Not only is it
always right, it is also perfectly accurate, as no error prone measurement
is required.  On such machines, also detect the frequency when bringing
a new CPU online; it isn't clear what frequency it will start with, and
it may not correspond to the reference.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15d2ace..c18e2fc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3061,9 +3061,6 @@ static void bounce_off(void *info)
 	/* nothing */
 }
 
-static unsigned int  ref_freq;
-static unsigned long tsc_khz_ref;
-
 static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 				     void *data)
 {
@@ -3071,15 +3068,15 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	int i, send_ipi = 0;
-
-	if (!ref_freq)
-		ref_freq = freq->old;
+	unsigned long old_khz;
 
 	if (val == CPUFREQ_PRECHANGE && freq->old > freq->new)
 		return 0;
 	if (val == CPUFREQ_POSTCHANGE && freq->old < freq->new)
 		return 0;
-	per_cpu(cpu_tsc_khz, freq->cpu) = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
+	old_khz = per_cpu(cpu_tsc_khz, freq->cpu);
+	per_cpu(cpu_tsc_khz, freq->cpu) = cpufreq_scale(old_khz, freq->old,
+							freq->new);
 
 	spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
@@ -3120,12 +3117,18 @@ static void kvm_timer_init(void)
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
+	}
+	for_each_possible_cpu(cpu) {
+		printk(KERN_DEBUG "kvm: cpu %d = %ld khz\n",
+			cpu, per_cpu(cpu_tsc_khz, cpu));
 	}
 }
 
@@ -4698,6 +4701,10 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 
 int kvm_arch_hardware_enable(void *garbage)
 {
+	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+		int cpu = raw_smp_processor_id();
+		per_cpu(cpu_tsc_khz, cpu) = cpufreq_quick_get(cpu);
+	}
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
-- 
1.6.4.4

