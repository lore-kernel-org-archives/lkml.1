Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbXIQIjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbXIQIjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbXIQIcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:42 -0400
Received: from il.qumranet.com ([82.166.9.18]:45281 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "Yang, Sheng" <sheng.yang@intel.com>
Subject: [PATCH 040/104] KVM: VMX: Add cpu consistency check
Date: Mon, 17 Sep 2007 10:31:22 +0200
Message-Id: <11900179471974-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang, Sheng <sheng.yang@intel.com>

All the physical CPUs on the board should support the same VMX feature
set.  Add check_processor_compatibility to kvm_arch_ops for the consistency
check.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   10 +++++++++
 drivers/kvm/svm.c      |    6 +++++
 drivers/kvm/vmx.c      |   51 +++++++++++++++++++++++++++++++----------------
 4 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 7a34706..cfda3ab 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -420,6 +420,7 @@ struct kvm_arch_ops {
 	int (*disabled_by_bios)(void);             /* __init */
 	void (*hardware_enable)(void *dummy);      /* __init */
 	void (*hardware_disable)(void *dummy);
+	void (*check_processor_compatibility)(void *rtn);
 	int (*hardware_setup)(void);               /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5dee302..2be6b1c 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -3102,6 +3102,7 @@ int kvm_init_arch(struct kvm_arch_ops *ops, unsigned int vcpu_size,
 		  struct module *module)
 {
 	int r;
+	int cpu;
 
 	if (kvm_arch_ops) {
 		printk(KERN_ERR "kvm: already loaded the other module\n");
@@ -3123,6 +3124,14 @@ int kvm_init_arch(struct kvm_arch_ops *ops, unsigned int vcpu_size,
 	if (r < 0)
 		goto out;
 
+	for_each_online_cpu(cpu) {
+		smp_call_function_single(cpu,
+				kvm_arch_ops->check_processor_compatibility,
+				&r, 0, 1);
+		if (r < 0)
+			goto out_free_0;
+	}
+
 	on_each_cpu(hardware_enable, NULL, 0, 1);
 	r = register_cpu_notifier(&kvm_cpu_notifier);
 	if (r)
@@ -3169,6 +3178,7 @@ out_free_2:
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 out_free_1:
 	on_each_cpu(hardware_disable, NULL, 0, 1);
+out_free_0:
 	kvm_arch_ops->hardware_unsetup();
 out:
 	kvm_arch_ops = NULL;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 5277084..827bc27 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1798,11 +1798,17 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[3] = 0xc3;
 }
 
+static void svm_check_processor_compat(void *rtn)
+{
+	*(int *)rtn = 0;
+}
+
 static struct kvm_arch_ops svm_arch_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
 	.hardware_setup = svm_hardware_setup,
 	.hardware_unsetup = svm_hardware_unsetup,
+	.check_processor_compatibility = svm_check_processor_compat,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 2b30274..c4b8bfe 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -840,13 +840,13 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 
 	/* Ensure minimum (required) set of control bits are supported. */
 	if (ctl_min & ~ctl)
-		return -1;
+		return -EIO;
 
 	*result = ctl;
 	return 0;
 }
 
-static __init int setup_vmcs_config(void)
+static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 min, opt;
@@ -859,7 +859,7 @@ static __init int setup_vmcs_config(void)
 	opt = 0;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PINBASED_CTLS,
 				&_pin_based_exec_control) < 0)
-		return -1;
+		return -EIO;
 
 	min = CPU_BASED_HLT_EXITING |
 #ifdef CONFIG_X86_64
@@ -872,7 +872,7 @@ static __init int setup_vmcs_config(void)
 	opt = 0;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
 				&_cpu_based_exec_control) < 0)
-		return -1;
+		return -EIO;
 
 	min = 0;
 #ifdef CONFIG_X86_64
@@ -881,37 +881,37 @@ static __init int setup_vmcs_config(void)
 	opt = 0;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
-		return -1;
+		return -EIO;
 
 	min = opt = 0;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
-		return -1;
+		return -EIO;
 
 	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
 	if ((vmx_msr_high & 0x1fff) > PAGE_SIZE)
-		return -1;
+		return -EIO;
 
 #ifdef CONFIG_X86_64
 	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
 	if (vmx_msr_high & (1u<<16))
-		return -1;
+		return -EIO;
 #endif
 
 	/* Require Write-Back (WB) memory type for VMCS accesses. */
 	if (((vmx_msr_high >> 18) & 15) != 6)
-		return -1;
+		return -EIO;
 
-	vmcs_config.size = vmx_msr_high & 0x1fff;
-	vmcs_config.order = get_order(vmcs_config.size);
-	vmcs_config.revision_id = vmx_msr_low;
+	vmcs_conf->size = vmx_msr_high & 0x1fff;
+	vmcs_conf->order = get_order(vmcs_config.size);
+	vmcs_conf->revision_id = vmx_msr_low;
 
-	vmcs_config.pin_based_exec_ctrl = _pin_based_exec_control;
-	vmcs_config.cpu_based_exec_ctrl = _cpu_based_exec_control;
-	vmcs_config.vmexit_ctrl         = _vmexit_control;
-	vmcs_config.vmentry_ctrl        = _vmentry_control;
+	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
+	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
+	vmcs_conf->vmexit_ctrl         = _vmexit_control;
+	vmcs_conf->vmentry_ctrl        = _vmentry_control;
 
 	return 0;
 }
@@ -971,8 +971,8 @@ static __init int alloc_kvm_area(void)
 
 static __init int hardware_setup(void)
 {
-	if (setup_vmcs_config() < 0)
-		return -1;
+	if (setup_vmcs_config(&vmcs_config) < 0)
+		return -EIO;
 	return alloc_kvm_area();
 }
 
@@ -2414,11 +2414,26 @@ free_vcpu:
 	return ERR_PTR(err);
 }
 
+static void __init vmx_check_processor_compat(void *rtn)
+{
+	struct vmcs_config vmcs_conf;
+
+	*(int *)rtn = 0;
+	if (setup_vmcs_config(&vmcs_conf) < 0)
+		*(int *)rtn = -EIO;
+	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
+		printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
+				smp_processor_id());
+		*(int *)rtn = -EIO;
+	}
+}
+
 static struct kvm_arch_ops vmx_arch_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
 	.hardware_setup = hardware_setup,
 	.hardware_unsetup = hardware_unsetup,
+	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
 
-- 
1.5.3

