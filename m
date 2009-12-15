Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbZLOENB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbZLOENB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759299AbZLOEMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:12:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbZLOEG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:06:56 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 02/20] Add a hotplug notifier to KVM x86 backend
Date: Mon, 14 Dec 2009 18:08:29 -1000
Message-Id: <1260850127-9766-3-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-2-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a hotplug notifier here gives us direct control for getting the
clock rate, which might be different on power-up.  This eliminates a check
from the hot path of entering hardware virtualization, and is a cleaner
way to do things.  The notifier must be last, so the cpufreq code has a
chance to run first and figure out the CPU speed.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   38 ++++++++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1cc51ca..faa467d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3308,10 +3308,37 @@ static struct notifier_block kvmclock_cpufreq_notifier_block = {
         .notifier_call  = kvmclock_cpufreq_notifier
 };
 
+static int kvm_x86_cpu_hotplug(struct notifier_block *notifier,
+			       unsigned long val, void *v)
+{
+	int cpu = (long)v;
+
+	val &= ~CPU_TASKS_FROZEN;
+	switch (val) {
+	case CPU_DYING:
+	case CPU_UP_CANCELED:
+		if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+			per_cpu(cpu_tsc_khz, cpu) = 0;
+		break;
+
+	case CPU_ONLINE:
+		if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+			per_cpu(cpu_tsc_khz, cpu) = cpufreq_quick_get(cpu);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kvm_x86_cpu_notifier = {
+	.notifier_call = kvm_x86_cpu_hotplug,
+	.priority = -INT_MAX, /* we want to be called last */
+};
+
 static void kvm_timer_init(void)
 {
 	int cpu;
 
+	register_cpu_notifier(&kvm_x86_cpu_notifier);
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
@@ -3374,6 +3401,7 @@ void kvm_arch_exit(void)
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
 					    CPUFREQ_TRANSITION_NOTIFIER);
+	unregister_cpu_notifier(&kvm_x86_cpu_notifier);
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();
 }
@@ -4904,17 +4932,7 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 
 int kvm_arch_hardware_enable(void *garbage)
 {
-	/*
-	 * Since this may be called from a hotplug notifcation,
-	 * we can't get the CPU frequency directly.
-	 */
-	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
-		int cpu = raw_smp_processor_id();
-		per_cpu(cpu_tsc_khz, cpu) = 0;
-	}
-
 	kvm_shared_msr_cpu_online();
-
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
-- 
1.6.5.2

