Return-Path: <linux-kernel-owner+w=401wt.eu-S965564AbXA3O4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965564AbXA3O4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965573AbXA3O4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:56:20 -0500
Received: from il.qumranet.com ([62.219.232.206]:51200 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965564AbXA3O4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:56:18 -0500
Subject: [PATCH 4/5] KVM: cpu hotplug support
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:56:16 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF5B96.1070007@qumranet.com>
In-Reply-To: <45BF5B96.1070007@qumranet.com>
Message-Id: <20070130145616.EFD52A0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On hotplug, we execute the hardware extension enable sequence.
On unplug, we decache any vcpus that last ran on the exiting cpu, and
execute the hardware extension disable sequence.

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -34,6 +34,7 @@
 #include <linux/highmem.h>
 #include <linux/file.h>
 #include <asm/desc.h>
+#include <linux/cpu.h>
 
 #include "x86_emulate.h"
 #include "segment_descriptor.h"
@@ -2038,6 +2039,64 @@ static struct notifier_block kvm_reboot_
 	.priority = 0,
 };
 
+/*
+ * Make sure that a cpu that is being hot-unplugged does not have any vcpus
+ * cached on it.
+ */
+static void decache_vcpus_on_cpu(int cpu)
+{
+	struct kvm *vm;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	spin_lock(&kvm_lock);
+	list_for_each_entry(vm, &vm_list, vm_list)
+		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+			vcpu = &vm->vcpus[i];
+			/*
+			 * If the vcpu is locked, then it is running on some
+			 * other cpu and therefore it is not cached on the
+			 * cpu in question.
+			 *
+			 * If it's not locked, check the last cpu it executed
+			 * on.
+			 */
+			if (mutex_trylock(&vcpu->mutex)) {
+				if (vcpu->cpu == cpu) {
+					kvm_arch_ops->vcpu_decache(vcpu);
+					vcpu->cpu = -1;
+				}
+				mutex_unlock(&vcpu->mutex);
+			}
+		}
+	spin_unlock(&kvm_lock);
+}
+
+static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
+			   void *v)
+{
+	int cpu = (long)v;
+
+	switch (val) {
+	case CPU_DEAD:
+	case CPU_UP_CANCELED:
+		decache_vcpus_on_cpu(cpu);
+		smp_call_function_single(cpu, kvm_arch_ops->hardware_disable,
+					 NULL, 0, 1);
+		break;
+	case CPU_UP_PREPARE:
+		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
+					 NULL, 0, 1);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kvm_cpu_notifier = {
+	.notifier_call = kvm_cpu_hotplug,
+	.priority = 20, /* must be > scheduler priority */
+};
+
 static __init void kvm_init_debug(void)
 {
 	struct kvm_stats_debugfs_item *p;
@@ -2084,6 +2143,9 @@ int kvm_init_arch(struct kvm_arch_ops *o
 	    return r;
 
 	on_each_cpu(kvm_arch_ops->hardware_enable, 0, 0, 1);
+	r = register_cpu_notifier(&kvm_cpu_notifier);
+	if (r)
+		goto out_free_1;
 	register_reboot_notifier(&kvm_reboot_notifier);
 
 	kvm_chardev_ops.owner = module;
@@ -2098,6 +2160,8 @@ int kvm_init_arch(struct kvm_arch_ops *o
 
 out_free:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
+	unregister_cpu_notifier(&kvm_cpu_notifier);
+out_free_1:
 	on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
 	return r;
Index: linux-2.6/drivers/kvm/kvm.h
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm.h
+++ linux-2.6/drivers/kvm/kvm.h
@@ -341,6 +341,7 @@ struct kvm_arch_ops {
 
 	struct kvm_vcpu *(*vcpu_load)(struct kvm_vcpu *vcpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
+	void (*vcpu_decache)(struct kvm_vcpu *vcpu);
 
 	int (*set_guest_debug)(struct kvm_vcpu *vcpu,
 			       struct kvm_debug_guest *dbg);
Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c
+++ linux-2.6/drivers/kvm/svm.c
@@ -609,6 +609,10 @@ static void svm_vcpu_put(struct kvm_vcpu
 	put_cpu();
 }
 
+static void svm_vcpu_decache(struct kvm_vcpu *vcpu)
+{
+}
+
 static void svm_cache_regs(struct kvm_vcpu *vcpu)
 {
 	vcpu->regs[VCPU_REGS_RAX] = vcpu->svm->vmcb->save.rax;
@@ -1677,6 +1681,7 @@ static struct kvm_arch_ops svm_arch_ops 
 
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
+	.vcpu_decache = svm_vcpu_decache,
 
 	.set_guest_debug = svm_guest_debug,
 	.get_msr = svm_get_msr,
Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c
+++ linux-2.6/drivers/kvm/vmx.c
@@ -250,6 +250,11 @@ static void vmx_vcpu_put(struct kvm_vcpu
 	put_cpu();
 }
 
+static void vmx_vcpu_decache(struct kvm_vcpu *vcpu)
+{
+	vcpu_clear(vcpu);
+}
+
 static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 {
 	return vmcs_readl(GUEST_RFLAGS);
@@ -509,7 +514,7 @@ static __init int vmx_disabled_by_bios(v
 	return (msr & 5) == 1; /* locked but not enabled */
 }
 
-static __init void hardware_enable(void *garbage)
+static void hardware_enable(void *garbage)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
@@ -2021,6 +2026,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
+	.vcpu_decache = vmx_vcpu_decache,
 
 	.set_guest_debug = set_guest_debug,
 	.get_msr = vmx_get_msr,
