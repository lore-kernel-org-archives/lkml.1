Return-Path: <linux-kernel-owner+w=401wt.eu-S1946633AbXBIQjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946633AbXBIQjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946646AbXBIQjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51678 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946633AbXBIQil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:38:41 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] kvm: NULL noise removal
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYlk-0006me-Lp@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:38:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/kvm/kvm_main.c |   28 ++++++++++++++--------------
 drivers/kvm/svm.c      |    8 ++++----
 drivers/kvm/vmx.c      |    2 +-
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a553540..099f0af 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -62,7 +62,7 @@ static struct kvm_stats_debugfs_item {
 	{ "halt_exits", &kvm_stat.halt_exits },
 	{ "request_irq", &kvm_stat.request_irq_exits },
 	{ "irq_exits", &kvm_stat.irq_exits },
-	{ 0, 0 }
+	{ NULL, NULL }
 };
 
 static struct dentry *debugfs_dir;
@@ -205,7 +205,7 @@ static struct kvm_vcpu *vcpu_load(struct kvm *kvm, int vcpu_slot)
 	mutex_lock(&vcpu->mutex);
 	if (unlikely(!vcpu->vmcs)) {
 		mutex_unlock(&vcpu->mutex);
-		return 0;
+		return NULL;
 	}
 	return kvm_arch_ops->vcpu_load(vcpu);
 }
@@ -257,9 +257,9 @@ static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
 	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
 		vfree(free->dirty_bitmap);
 
-	free->phys_mem = 0;
+	free->phys_mem = NULL;
 	free->npages = 0;
-	free->dirty_bitmap = 0;
+	free->dirty_bitmap = NULL;
 }
 
 static void kvm_free_physmem(struct kvm *kvm)
@@ -267,7 +267,7 @@ static void kvm_free_physmem(struct kvm *kvm)
 	int i;
 
 	for (i = 0; i < kvm->nmemslots; ++i)
-		kvm_free_physmem_slot(&kvm->memslots[i], 0);
+		kvm_free_physmem_slot(&kvm->memslots[i], NULL);
 }
 
 static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
@@ -640,11 +640,11 @@ raced:
 
 	/* Deallocate if slot is being removed */
 	if (!npages)
-		new.phys_mem = 0;
+		new.phys_mem = NULL;
 
 	/* Free page dirty bitmap if unneeded */
 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
-		new.dirty_bitmap = 0;
+		new.dirty_bitmap = NULL;
 
 	r = -ENOMEM;
 
@@ -799,14 +799,14 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 		    && gfn < memslot->base_gfn + memslot->npages)
 			return memslot;
 	}
-	return 0;
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(gfn_to_memslot);
 
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
-	struct kvm_memory_slot *memslot = 0;
+	struct kvm_memory_slot *memslot = NULL;
 	unsigned long rel_gfn;
 
 	for (i = 0; i < kvm->nmemslots; ++i) {
@@ -2015,7 +2015,7 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		 * in vmx root mode.
 		 */
 		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
-		on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
+		on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
 	}
 	return NOTIFY_OK;
 }
@@ -2029,7 +2029,7 @@ static __init void kvm_init_debug(void)
 {
 	struct kvm_stats_debugfs_item *p;
 
-	debugfs_dir = debugfs_create_dir("kvm", 0);
+	debugfs_dir = debugfs_create_dir("kvm", NULL);
 	for (p = debugfs_entries; p->name; ++p)
 		p->dentry = debugfs_create_u32(p->name, 0444, debugfs_dir,
 					       p->data);
@@ -2070,7 +2070,7 @@ int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 	if (r < 0)
 	    return r;
 
-	on_each_cpu(kvm_arch_ops->hardware_enable, 0, 0, 1);
+	on_each_cpu(kvm_arch_ops->hardware_enable, NULL, 0, 1);
 	register_reboot_notifier(&kvm_reboot_notifier);
 
 	kvm_chardev_ops.owner = module;
@@ -2085,7 +2085,7 @@ int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 
 out_free:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
-	on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
+	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
 	return r;
 }
@@ -2095,7 +2095,7 @@ void kvm_exit_arch(void)
 	misc_deregister(&kvm_dev);
 
 	unregister_reboot_notifier(&kvm_reboot_notifier);
-	on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
+	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
 	kvm_arch_ops = NULL;
 }
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index c79df79..85f61dd 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -274,7 +274,7 @@ static void svm_hardware_disable(void *garbage)
 		wrmsrl(MSR_VM_HSAVE_PA, 0);
 		rdmsrl(MSR_EFER, efer);
 		wrmsrl(MSR_EFER, efer & ~MSR_EFER_SVME_MASK);
-		per_cpu(svm_data, raw_smp_processor_id()) = 0;
+		per_cpu(svm_data, raw_smp_processor_id()) = NULL;
 		__free_page(svm_data->save_area);
 		kfree(svm_data);
 	}
@@ -642,7 +642,7 @@ static struct vmcb_seg *svm_seg(struct kvm_vcpu *vcpu, int seg)
 	case VCPU_SREG_LDTR: return &save->ldtr;
 	}
 	BUG();
-	return 0;
+	return NULL;
 }
 
 static u64 svm_get_segment_base(struct kvm_vcpu *vcpu, int seg)
@@ -934,7 +934,7 @@ static int io_get_override(struct kvm_vcpu *vcpu,
 		return 0;
 
 	*addr_override = 0;
-	*seg = 0;
+	*seg = NULL;
 	for (i = 0; i < ins_length; i++)
 		switch (inst[i]) {
 		case 0xf0:
@@ -1087,7 +1087,7 @@ static int cpuid_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int emulate_on_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	if (emulate_instruction(vcpu, 0, 0, 0) != EMULATE_DONE)
+	if (emulate_instruction(vcpu, NULL, 0, 0) != EMULATE_DONE)
 		printk(KERN_ERR "%s: failed\n", __FUNCTION__);
 	return 1;
 }
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 54c35c0..27e05a7 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -98,7 +98,7 @@ static struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr)
 	for (i = 0; i < vcpu->nmsrs; ++i)
 		if (vcpu->guest_msrs[i].index == msr)
 			return &vcpu->guest_msrs[i];
-	return 0;
+	return NULL;
 }
 
 static void vmcs_clear(struct vmcs *vmcs)
-- 
1.5.0-rc2.GIT


