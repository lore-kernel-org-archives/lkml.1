Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbZLOEMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbZLOEMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbZLOEHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:07:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537AbZLOEHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:00 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 04/20] Synchronize TSC when a new CPU comes up
Date: Mon, 14 Dec 2009 18:08:31 -1000
Message-Id: <1260850127-9766-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-4-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop is written to only work when one master and one slave
enter simultaneously, so properly protect it, and call it when
adding new CPUs.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   43 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95e43b9..a599c78 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -729,6 +729,7 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
 		 hv_clock->tsc_to_system_mul);
 }
 
+DEFINE_SPINLOCK(kvm_tsc_lock);
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_multiplier);
 static DEFINE_PER_CPU(int, cpu_tsc_shift);
@@ -921,6 +922,21 @@ static void kvm_sync_tsc(void *cpup)
 	local_irq_restore(flags);
 }
 
+static void kvm_do_sync_tsc(int cpu)
+{
+	spin_lock(&kvm_tsc_lock);
+	if (raw_smp_processor_id() != tsc_base_cpu) {
+		smp_call_function_single(tsc_base_cpu, kvm_sync_tsc,
+					 (void *)&cpu, 0);
+		smp_call_function_single(cpu, kvm_sync_tsc, (void *)&cpu, 1);
+	} else {
+		smp_call_function_single(cpu, kvm_sync_tsc, (void *)&cpu, 0);
+		smp_call_function_single(tsc_base_cpu, kvm_sync_tsc,
+					 (void *)&cpu, 1);
+	}
+	spin_unlock(&kvm_tsc_lock);
+}
+
 static void kvm_write_guest_time(struct kvm_vcpu *v)
 {
 	struct timespec ts;
@@ -1634,12 +1650,7 @@ out:
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
-	if (unlikely(per_cpu(cpu_tsc_khz, cpu) == 0)) {
-		unsigned long khz = cpufreq_quick_get(cpu);
-		if (!khz)
-			khz = tsc_khz;
-		per_cpu(cpu_tsc_khz, cpu) = khz;
-	}
+	BUG_ON(per_cpu(cpu_tsc_khz, cpu) == 0);
 	kvm_request_guest_time_update(vcpu);
 }
 
@@ -3505,6 +3516,18 @@ static int kvm_x86_cpu_hotplug(struct notifier_block *notifier,
 
 	val &= ~CPU_TASKS_FROZEN;
 	switch (val) {
+	case CPU_DOWN_PREPARE:
+		if (cpu == tsc_base_cpu) {
+			int new_cpu;
+			spin_lock(&kvm_tsc_lock);
+			for_each_online_cpu(new_cpu)
+				if (new_cpu != tsc_base_cpu)
+					break;
+			tsc_base_cpu = new_cpu;
+			spin_unlock(&kvm_tsc_lock);
+		}
+		break;
+
 	case CPU_DYING:
 	case CPU_UP_CANCELED:
 		if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
@@ -3514,6 +3537,7 @@ static int kvm_x86_cpu_hotplug(struct notifier_block *notifier,
 	case CPU_ONLINE:
 		if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 			per_cpu(cpu_tsc_khz, cpu) = cpufreq_quick_get(cpu);
+		kvm_do_sync_tsc(cpu);
 		break;
 	}
 	return NOTIFY_OK;
@@ -3548,11 +3572,8 @@ static void kvm_timer_init(void)
 	per_cpu(cpu_tsc_shift, tsc_base_cpu) = 0;
 	per_cpu(cpu_tsc_offset, tsc_base_cpu) = 0;
 	for_each_online_cpu(cpu)
-		if (cpu != tsc_base_cpu) {
-			smp_call_function_single(cpu, kvm_sync_tsc,
-						 (void *)&cpu, 0);
-			kvm_sync_tsc((void *)&cpu);
-		}
+		if (cpu != tsc_base_cpu)
+			kvm_do_sync_tsc(cpu);
 	put_cpu();
 }
 
-- 
1.6.5.2

