Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZIXDbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZIXDbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 23:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZIXDbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 23:31:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbZIXDbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 23:31:25 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH: kvm 3/6] Fix hotadd of CPUs for KVM.
Date: Wed, 23 Sep 2009 17:29:02 -1000
Message-Id: <1253762945-5750-3-git-send-email-zamsden@redhat.com>
In-Reply-To: <1253762945-5750-2-git-send-email-zamsden@redhat.com>
References: <1253762945-5750-1-git-send-email-zamsden@redhat.com>
 <1253762945-5750-2-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both VMX and SVM require per-cpu memory allocation, which is done at module
init time, for only online cpus.  When bringing a new CPU online, we must
also allocate this structure.  The method chosen to implement this is to
make the CPU online notifier available via a call to the arch code.  This
allows memory allocation to be done smoothly, without any need to allocate
extra structures.

Note: CPU up notifiers may call KVM callback before calling cpufreq callbacks.
This would causes the CPU frequency not to be detected (and it is not always
clear on non-constant TSC platforms what the bringup TSC rate will be, so the
guess of using tsc_khz could be wrong).  So, we clear the rate to zero in such
a case and add logic to query it upon entry.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/svm.c              |   15 +++++++++++++--
 arch/x86/kvm/vmx.c              |   17 +++++++++++++++++
 arch/x86/kvm/x86.c              |   14 +++++++++++++-
 include/linux/kvm_host.h        |    6 ++++++
 virt/kvm/kvm_main.c             |    3 ++-
 6 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 299cc1b..b7dd14b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -459,6 +459,7 @@ struct descriptor_table {
 struct kvm_x86_ops {
 	int (*cpu_has_kvm_support)(void);          /* __init */
 	int (*disabled_by_bios)(void);             /* __init */
+	int (*cpu_hotadd)(int cpu);
 	int (*hardware_enable)(void *dummy);
 	void (*hardware_disable)(void *dummy);
 	void (*check_processor_compatibility)(void *rtn);
@@ -791,6 +792,7 @@ asmlinkage void kvm_handle_fault_on_reboot(void);
 	_ASM_PTR " 666b, 667b \n\t" \
 	".popsection"
 
+#define KVM_ARCH_WANT_HOTPLUG_NOTIFIER
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_age_hva(struct kvm *kvm, unsigned long hva);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9a4daca..8f99d0c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -330,13 +330,13 @@ static int svm_hardware_enable(void *garbage)
 		return -EBUSY;
 
 	if (!has_svm()) {
-		printk(KERN_ERR "svm_cpu_init: err EOPNOTSUPP on %d\n", me);
+		printk(KERN_ERR "svm_hardware_enable: err EOPNOTSUPP on %d\n", me);
 		return -EINVAL;
 	}
 	svm_data = per_cpu(svm_data, me);
 
 	if (!svm_data) {
-		printk(KERN_ERR "svm_cpu_init: svm_data is NULL on %d\n",
+		printk(KERN_ERR "svm_hardware_enable: svm_data is NULL on %d\n",
 		       me);
 		return -EINVAL;
 	}
@@ -394,6 +394,16 @@ err_1:
 
 }
 
+static __cpuinit int svm_cpu_hotadd(int cpu)
+{
+	struct svm_cpu_data *svm_data = per_cpu(svm_data, cpu);
+
+	if (svm_data)
+		return 0;
+
+	return svm_cpu_init(cpu);
+}
+
 static void set_msr_interception(u32 *msrpm, unsigned msr,
 				 int read, int write)
 {
@@ -2858,6 +2868,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.hardware_setup = svm_hardware_setup,
 	.hardware_unsetup = svm_hardware_unsetup,
 	.check_processor_compatibility = svm_check_processor_compat,
+	.cpu_hotadd = svm_cpu_hotadd,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3fe0d42..b8a8428 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1408,6 +1408,22 @@ static __exit void hardware_unsetup(void)
 	free_kvm_area();
 }
 
+static __cpuinit int vmx_cpu_hotadd(int cpu)
+{
+	struct vmcs *vmcs;
+
+	if (per_cpu(vmxarea, cpu))
+		return 0;
+
+	vmcs = alloc_vmcs_cpu(cpu);
+	if (!vmcs) 
+		return -ENOMEM;
+
+	per_cpu(vmxarea, cpu) = vmcs;
+
+	return 0;
+}
+
 static void fix_pmode_dataseg(int seg, struct kvm_save_segment *save)
 {
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
@@ -3925,6 +3941,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.hardware_setup = hardware_setup,
 	.hardware_unsetup = hardware_unsetup,
 	.check_processor_compatibility = vmx_check_processor_compat,
+	.cpu_hotadd = vmx_cpu_hotadd,
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
 	.cpu_has_accelerated_tpr = report_flexpriority,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 35082dd..05aea42 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1339,6 +1339,8 @@ out:
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
+	if (unlikely(per_cpu(cpu_tsc_khz, cpu) == 0))
+		kvm_get_cpu_khz(cpu);
 	kvm_request_guest_time_update(vcpu);
 }
 
@@ -4712,10 +4714,20 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 	return kvm_x86_ops->vcpu_reset(vcpu);
 }
 
+int kvm_arch_cpu_hotadd(int cpu)
+{
+	return kvm_x86_ops->cpu_hotadd(cpu);
+}
+
 int kvm_arch_hardware_enable(void *garbage)
 {
+	/*
+	 * Notifier callback chain may not have called cpufreq code
+	 * yet, thus we must reset TSC khz to zero and recompute it
+	 * before entering.
+	 */
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
-		kvm_get_cpu_khz(raw_smp_processor_id());
+		per_cpu(cpu_tsc_khz, raw_smp_processor_id()) = 0;
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0bf9ee9..2f075c4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -345,6 +345,12 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id);
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
 
+#ifdef KVM_ARCH_WANT_HOTPLUG_NOTIFIER
+int kvm_arch_cpu_hotadd(int cpu);
+#else
+#define kvm_arch_cpu_hotadd(x) (0)
+#endif
+
 int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu);
 int kvm_arch_hardware_enable(void *garbage);
 void kvm_arch_hardware_disable(void *garbage);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e27b7a9..1360db4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1734,7 +1734,8 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	case CPU_ONLINE:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
-		smp_call_function_single(cpu, hardware_enable, NULL, 1);
+		if (!kvm_arch_cpu_hotadd(cpu))
+			smp_call_function_single(cpu, hardware_enable, NULL, 1);
 		break;
 	}
 	return NOTIFY_OK;
-- 
1.6.4.4

