Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbZIXDcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbZIXDcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 23:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZIXDbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 23:31:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbZIXDb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 23:31:27 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH: kvm 4/6] Fix hotremove of CPUs for KVM.
Date: Wed, 23 Sep 2009 17:29:03 -1000
Message-Id: <1253762945-5750-4-git-send-email-zamsden@redhat.com>
In-Reply-To: <1253762945-5750-3-git-send-email-zamsden@redhat.com>
References: <1253762945-5750-1-git-send-email-zamsden@redhat.com>
 <1253762945-5750-2-git-send-email-zamsden@redhat.com>
 <1253762945-5750-3-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the process of bringing down CPUs, the SVM / VMX structures associated
with those CPUs are not freed.  This may cause leaks when unloading and
reloading the KVM module, as only the structures associated with online
CPUs are cleaned up.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/svm.c              |    1 +
 arch/x86/kvm/vmx.c              |    7 +++++++
 arch/x86/kvm/x86.c              |    5 +++++
 include/linux/kvm_host.h        |    2 ++
 virt/kvm/kvm_main.c             |    2 ++
 6 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b7dd14b..91e02d3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -460,6 +460,7 @@ struct kvm_x86_ops {
 	int (*cpu_has_kvm_support)(void);          /* __init */
 	int (*disabled_by_bios)(void);             /* __init */
 	int (*cpu_hotadd)(int cpu);
+	void (*cpu_hotremove)(int cpu);
 	int (*hardware_enable)(void *dummy);
 	void (*hardware_disable)(void *dummy);
 	void (*check_processor_compatibility)(void *rtn);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8f99d0c..7cf6c98 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2869,6 +2869,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.hardware_unsetup = svm_hardware_unsetup,
 	.check_processor_compatibility = svm_check_processor_compat,
 	.cpu_hotadd = svm_cpu_hotadd,
+	.cpu_hotremove = svm_cpu_uninit,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b8a8428..1e3e9fc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1424,6 +1424,12 @@ static __cpuinit int vmx_cpu_hotadd(int cpu)
 	return 0;
 }
 
+static __cpuinit void vmx_cpu_hotremove(int cpu)
+{
+	free_vmcs(per_cpu(vmxarea, cpu));
+	per_cpu(vmxarea, cpu) = NULL;
+}
+
 static void fix_pmode_dataseg(int seg, struct kvm_save_segment *save)
 {
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
@@ -3942,6 +3948,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.hardware_unsetup = hardware_unsetup,
 	.check_processor_compatibility = vmx_check_processor_compat,
 	.cpu_hotadd = vmx_cpu_hotadd,
+	.cpu_hotremove = vmx_cpu_hotremove,
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
 	.cpu_has_accelerated_tpr = report_flexpriority,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05aea42..38ba4a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4719,6 +4719,11 @@ int kvm_arch_cpu_hotadd(int cpu)
 	return kvm_x86_ops->cpu_hotadd(cpu);
 }
 
+void kvm_arch_cpu_hotremove(int cpu)
+{
+	kvm_x86_ops->cpu_hotremove(cpu);
+}
+
 int kvm_arch_hardware_enable(void *garbage)
 {
 	/*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2f075c4..2c844f0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -347,8 +347,10 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 #ifdef KVM_ARCH_WANT_HOTPLUG_NOTIFIER
 int kvm_arch_cpu_hotadd(int cpu);
+void kvm_arch_cpu_hotremove(int cpu);
 #else
 #define kvm_arch_cpu_hotadd(x) (0)
+#define kvm_arch_cpu_hotremove(x)
 #endif
 
 int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1360db4..bd21927 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1725,11 +1725,13 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
 		hardware_disable(NULL);
+		kvm_arch_cpu_hotremove(cpu);
 		break;
 	case CPU_UP_CANCELED:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
 		smp_call_function_single(cpu, hardware_disable, NULL, 1);
+		kvm_arch_cpu_hotremove(cpu);
 		break;
 	case CPU_ONLINE:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
-- 
1.6.4.4

