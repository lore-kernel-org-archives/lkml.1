Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZKPMUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZKPMUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZKPMUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbZKPMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:43 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 23/42] KVM: Activate Virtualization On Demand
Date: Mon, 16 Nov 2009 14:19:24 +0200
Message-Id: <1258373983-8693-24-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

X86 CPUs need to have some magic happening to enable the virtualization
extensions on them. This magic can result in unpleasant results for
users, like blocking other VMMs from working (vmx) or using invalid TLB
entries (svm).

Currently KVM activates virtualization when the respective kernel module
is loaded. This blocks us from autoloading KVM modules without breaking
other VMMs.

To circumvent this problem at least a bit, this patch introduces on
demand activation of virtualization. This means, that instead
virtualization is enabled on creation of the first virtual machine
and disabled on destruction of the last one.

So using this, KVM can be easily autoloaded, while keeping other
hypervisors usable.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c        |    8 ++-
 arch/powerpc/kvm/powerpc.c      |    3 +-
 arch/s390/kvm/kvm-s390.c        |    3 +-
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/svm.c              |   13 ++++--
 arch/x86/kvm/vmx.c              |   11 +++-
 arch/x86/kvm/x86.c              |    4 +-
 include/linux/kvm_host.h        |    2 +-
 virt/kvm/kvm_main.c             |   90 +++++++++++++++++++++++++++++++++-----
 9 files changed, 108 insertions(+), 28 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index f6471c8..5fdeec5 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -124,7 +124,7 @@ long ia64_pal_vp_create(u64 *vpd, u64 *host_iva, u64 *opt_handler)
 
 static  DEFINE_SPINLOCK(vp_lock);
 
-void kvm_arch_hardware_enable(void *garbage)
+int kvm_arch_hardware_enable(void *garbage)
 {
 	long  status;
 	long  tmp_base;
@@ -137,7 +137,7 @@ void kvm_arch_hardware_enable(void *garbage)
 	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
 	local_irq_restore(saved_psr);
 	if (slot < 0)
-		return;
+		return -EINVAL;
 
 	spin_lock(&vp_lock);
 	status = ia64_pal_vp_init_env(kvm_vsa_base ?
@@ -145,7 +145,7 @@ void kvm_arch_hardware_enable(void *garbage)
 			__pa(kvm_vm_buffer), KVM_VM_BUFFER_BASE, &tmp_base);
 	if (status != 0) {
 		printk(KERN_WARNING"kvm: Failed to Enable VT Support!!!!\n");
-		return ;
+		return -EINVAL;
 	}
 
 	if (!kvm_vsa_base) {
@@ -154,6 +154,8 @@ void kvm_arch_hardware_enable(void *garbage)
 	}
 	spin_unlock(&vp_lock);
 	ia64_ptr_entry(0x3, slot);
+
+	return 0;
 }
 
 void kvm_arch_hardware_disable(void *garbage)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 95af622..5902bbc 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -78,8 +78,9 @@ int kvmppc_emulate_mmio(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	return r;
 }
 
-void kvm_arch_hardware_enable(void *garbage)
+int kvm_arch_hardware_enable(void *garbage)
 {
+	return 0;
 }
 
 void kvm_arch_hardware_disable(void *garbage)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 00e2ce8..5445058 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -74,9 +74,10 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 static unsigned long long *facilities;
 
 /* Section: not file related */
-void kvm_arch_hardware_enable(void *garbage)
+int kvm_arch_hardware_enable(void *garbage)
 {
 	/* every s390 is virtualization enabled ;-) */
+	return 0;
 }
 
 void kvm_arch_hardware_disable(void *garbage)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a46e2dd..295c7c4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -459,7 +459,7 @@ struct descriptor_table {
 struct kvm_x86_ops {
 	int (*cpu_has_kvm_support)(void);          /* __init */
 	int (*disabled_by_bios)(void);             /* __init */
-	void (*hardware_enable)(void *dummy);      /* __init */
+	int (*hardware_enable)(void *dummy);
 	void (*hardware_disable)(void *dummy);
 	void (*check_processor_compatibility)(void *rtn);
 	int (*hardware_setup)(void);               /* __init */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f54c4f9..59fe4d5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -316,7 +316,7 @@ static void svm_hardware_disable(void *garbage)
 	cpu_svm_disable();
 }
 
-static void svm_hardware_enable(void *garbage)
+static int svm_hardware_enable(void *garbage)
 {
 
 	struct svm_cpu_data *svm_data;
@@ -325,16 +325,20 @@ static void svm_hardware_enable(void *garbage)
 	struct desc_struct *gdt;
 	int me = raw_smp_processor_id();
 
+	rdmsrl(MSR_EFER, efer);
+	if (efer & EFER_SVME)
+		return -EBUSY;
+
 	if (!has_svm()) {
 		printk(KERN_ERR "svm_cpu_init: err EOPNOTSUPP on %d\n", me);
-		return;
+		return -EINVAL;
 	}
 	svm_data = per_cpu(svm_data, me);
 
 	if (!svm_data) {
 		printk(KERN_ERR "svm_cpu_init: svm_data is NULL on %d\n",
 		       me);
-		return;
+		return -EINVAL;
 	}
 
 	svm_data->asid_generation = 1;
@@ -345,11 +349,12 @@ static void svm_hardware_enable(void *garbage)
 	gdt = (struct desc_struct *)gdt_descr.base;
 	svm_data->tss_desc = (struct kvm_ldttss_desc *)(gdt + GDT_ENTRY_TSS);
 
-	rdmsrl(MSR_EFER, efer);
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
 	wrmsrl(MSR_VM_HSAVE_PA,
 	       page_to_pfn(svm_data->save_area) << PAGE_SHIFT);
+
+	return 0;
 }
 
 static void svm_cpu_uninit(int cpu)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 73cb5dd..a187570 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1138,12 +1138,15 @@ static __init int vmx_disabled_by_bios(void)
 	/* locked but not enabled */
 }
 
-static void hardware_enable(void *garbage)
+static int hardware_enable(void *garbage)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
 	u64 old;
 
+	if (read_cr4() & X86_CR4_VMXE)
+		return -EBUSY;
+
 	INIT_LIST_HEAD(&per_cpu(vcpus_on_cpu, cpu));
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
 	if ((old & (FEATURE_CONTROL_LOCKED |
@@ -1158,6 +1161,10 @@ static void hardware_enable(void *garbage)
 	asm volatile (ASM_VMX_VMXON_RAX
 		      : : "a"(&phys_addr), "m"(phys_addr)
 		      : "memory", "cc");
+
+	ept_sync_global();
+
+	return 0;
 }
 
 static void vmclear_local_vcpus(void)
@@ -4040,8 +4047,6 @@ static int __init vmx_init(void)
 	if (bypass_guest_pf)
 		kvm_mmu_set_nonpresent_ptes(~0xffeull, 0ull);
 
-	ept_sync_global();
-
 	return 0;
 
 out3:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 829e306..3d83de8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4691,9 +4691,9 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 	return kvm_x86_ops->vcpu_reset(vcpu);
 }
 
-void kvm_arch_hardware_enable(void *garbage)
+int kvm_arch_hardware_enable(void *garbage)
 {
-	kvm_x86_ops->hardware_enable(garbage);
+	return kvm_x86_ops->hardware_enable(garbage);
 }
 
 void kvm_arch_hardware_disable(void *garbage)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c0a1cc3..b985a29 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -345,7 +345,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu);
-void kvm_arch_hardware_enable(void *garbage);
+int kvm_arch_hardware_enable(void *garbage);
 void kvm_arch_hardware_disable(void *garbage);
 int kvm_arch_hardware_setup(void);
 void kvm_arch_hardware_unsetup(void);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 38e4d2c..70c8cbe 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -69,6 +69,8 @@ DEFINE_SPINLOCK(kvm_lock);
 LIST_HEAD(vm_list);
 
 static cpumask_var_t cpus_hardware_enabled;
+static int kvm_usage_count = 0;
+static atomic_t hardware_enable_failed;
 
 struct kmem_cache *kvm_vcpu_cache;
 EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
@@ -79,6 +81,8 @@ struct dentry *kvm_debugfs_dir;
 
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
+static int hardware_enable_all(void);
+static void hardware_disable_all(void);
 
 static bool kvm_rebooting;
 
@@ -339,6 +343,7 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
 
 static struct kvm *kvm_create_vm(void)
 {
+	int r = 0;
 	struct kvm *kvm = kvm_arch_create_vm();
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 	struct page *page;
@@ -346,6 +351,11 @@ static struct kvm *kvm_create_vm(void)
 
 	if (IS_ERR(kvm))
 		goto out;
+
+	r = hardware_enable_all();
+	if (r)
+		goto out_err_nodisable;
+
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
 	INIT_HLIST_HEAD(&kvm->mask_notifier_list);
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
@@ -354,8 +364,8 @@ static struct kvm *kvm_create_vm(void)
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page) {
-		kfree(kvm);
-		return ERR_PTR(-ENOMEM);
+		r = -ENOMEM;
+		goto out_err;
 	}
 	kvm->coalesced_mmio_ring =
 			(struct kvm_coalesced_mmio_ring *)page_address(page);
@@ -363,15 +373,13 @@ static struct kvm *kvm_create_vm(void)
 
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	{
-		int err;
 		kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
-		err = mmu_notifier_register(&kvm->mmu_notifier, current->mm);
-		if (err) {
+		r = mmu_notifier_register(&kvm->mmu_notifier, current->mm);
+		if (r) {
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 			put_page(page);
 #endif
-			kfree(kvm);
-			return ERR_PTR(err);
+			goto out_err;
 		}
 	}
 #endif
@@ -395,6 +403,12 @@ static struct kvm *kvm_create_vm(void)
 #endif
 out:
 	return kvm;
+
+out_err:
+	hardware_disable_all();
+out_err_nodisable:
+	kfree(kvm);
+	return ERR_PTR(r);
 }
 
 /*
@@ -453,6 +467,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_arch_flush_shadow(kvm);
 #endif
 	kvm_arch_destroy_vm(kvm);
+	hardware_disable_all();
 	mmdrop(mm);
 }
 
@@ -1644,11 +1659,21 @@ static struct miscdevice kvm_dev = {
 static void hardware_enable(void *junk)
 {
 	int cpu = raw_smp_processor_id();
+	int r;
 
 	if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
 		return;
+
 	cpumask_set_cpu(cpu, cpus_hardware_enabled);
-	kvm_arch_hardware_enable(NULL);
+
+	r = kvm_arch_hardware_enable(NULL);
+
+	if (r) {
+		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
+		atomic_inc(&hardware_enable_failed);
+		printk(KERN_INFO "kvm: enabling virtualization on "
+				 "CPU%d failed\n", cpu);
+	}
 }
 
 static void hardware_disable(void *junk)
@@ -1661,11 +1686,52 @@ static void hardware_disable(void *junk)
 	kvm_arch_hardware_disable(NULL);
 }
 
+static void hardware_disable_all_nolock(void)
+{
+	BUG_ON(!kvm_usage_count);
+
+	kvm_usage_count--;
+	if (!kvm_usage_count)
+		on_each_cpu(hardware_disable, NULL, 1);
+}
+
+static void hardware_disable_all(void)
+{
+	spin_lock(&kvm_lock);
+	hardware_disable_all_nolock();
+	spin_unlock(&kvm_lock);
+}
+
+static int hardware_enable_all(void)
+{
+	int r = 0;
+
+	spin_lock(&kvm_lock);
+
+	kvm_usage_count++;
+	if (kvm_usage_count == 1) {
+		atomic_set(&hardware_enable_failed, 0);
+		on_each_cpu(hardware_enable, NULL, 1);
+
+		if (atomic_read(&hardware_enable_failed)) {
+			hardware_disable_all_nolock();
+			r = -EBUSY;
+		}
+	}
+
+	spin_unlock(&kvm_lock);
+
+	return r;
+}
+
 static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 			   void *v)
 {
 	int cpu = (long)v;
 
+	if (!kvm_usage_count)
+		return NOTIFY_OK;
+
 	val &= ~CPU_TASKS_FROZEN;
 	switch (val) {
 	case CPU_DYING:
@@ -1868,13 +1934,15 @@ static void kvm_exit_debug(void)
 
 static int kvm_suspend(struct sys_device *dev, pm_message_t state)
 {
-	hardware_disable(NULL);
+	if (kvm_usage_count)
+		hardware_disable(NULL);
 	return 0;
 }
 
 static int kvm_resume(struct sys_device *dev)
 {
-	hardware_enable(NULL);
+	if (kvm_usage_count)
+		hardware_enable(NULL);
 	return 0;
 }
 
@@ -1949,7 +2017,6 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 			goto out_free_1;
 	}
 
-	on_each_cpu(hardware_enable, NULL, 1);
 	r = register_cpu_notifier(&kvm_cpu_notifier);
 	if (r)
 		goto out_free_2;
@@ -1999,7 +2066,6 @@ out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 out_free_2:
-	on_each_cpu(hardware_disable, NULL, 1);
 out_free_1:
 	kvm_arch_hardware_unsetup();
 out_free_0a:
-- 
1.6.5.2

