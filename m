Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbXIQIl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbXIQIl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbXIQIcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:50 -0400
Received: from il.qumranet.com ([82.166.9.18]:45309 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbXIQIc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 025/104] KVM: Dynamically allocate vcpus
Date: Mon, 17 Sep 2007 10:31:07 +0200
Message-Id: <11900179471485-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This patch converts the vcpus array in "struct kvm" to a pointer
array, and changes the "vcpu_create" and "vcpu_setup" hooks into one
"vcpu_create" call which does the allocation and initialization of the
vcpu (calling back into the kvm_vcpu_init core helper).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |   12 ++--
 drivers/kvm/kvm_main.c |  198 +++++++++++++++++++++++++-----------------------
 drivers/kvm/kvm_svm.h  |    2 +-
 drivers/kvm/svm.c      |  177 +++++++++++++++++++++----------------------
 drivers/kvm/vmx.c      |   65 ++++++++++------
 5 files changed, 236 insertions(+), 218 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 954a140..e92c84b 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -300,10 +300,8 @@ void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 			     struct kvm_io_device *dev);
 
 struct kvm_vcpu {
-	int valid;
 	struct kvm *kvm;
 	int vcpu_id;
-	void *_priv;
 	struct mutex mutex;
 	int   cpu;
 	u64 host_tsc;
@@ -404,8 +402,7 @@ struct kvm {
 	struct list_head active_mmu_pages;
 	int n_free_mmu_pages;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
-	int nvcpus;
-	struct kvm_vcpu vcpus[KVM_MAX_VCPUS];
+	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	int memory_config_version;
 	int busy;
 	unsigned long rmap_overflow;
@@ -428,7 +425,8 @@ struct kvm_arch_ops {
 	int (*hardware_setup)(void);               /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
 
-	int (*vcpu_create)(struct kvm_vcpu *vcpu);
+	/* Create, but do not attach this VCPU */
+	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned id);
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
 
 	void (*vcpu_load)(struct kvm_vcpu *vcpu);
@@ -470,7 +468,6 @@ struct kvm_arch_ops {
 	void (*inject_gp)(struct kvm_vcpu *vcpu, unsigned err_code);
 
 	int (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
-	int (*vcpu_setup)(struct kvm_vcpu *vcpu);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
@@ -481,6 +478,9 @@ extern struct kvm_arch_ops *kvm_arch_ops;
 #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
 #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
 
+int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
+void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
+
 int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module);
 void kvm_exit_arch(void);
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index bf8b8f0..69d9ab4 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -266,8 +266,10 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	atomic_set(&completed, 0);
 	cpus_clear(cpus);
 	needed = 0;
-	for (i = 0; i < kvm->nvcpus; ++i) {
-		vcpu = &kvm->vcpus[i];
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		vcpu = kvm->vcpus[i];
+		if (!vcpu)
+			continue;
 		if (test_and_set_bit(KVM_TLB_FLUSH, &vcpu->requests))
 			continue;
 		cpu = vcpu->cpu;
@@ -291,10 +293,61 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	}
 }
 
+int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
+{
+	struct page *page;
+	int r;
+
+	mutex_init(&vcpu->mutex);
+	vcpu->cpu = -1;
+	vcpu->mmu.root_hpa = INVALID_PAGE;
+	vcpu->kvm = kvm;
+	vcpu->vcpu_id = id;
+
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page) {
+		r = -ENOMEM;
+		goto fail;
+	}
+	vcpu->run = page_address(page);
+
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page) {
+		r = -ENOMEM;
+		goto fail_free_run;
+	}
+	vcpu->pio_data = page_address(page);
+
+	vcpu->host_fx_image = (char*)ALIGN((hva_t)vcpu->fx_buf,
+					   FX_IMAGE_ALIGN);
+	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
+
+	r = kvm_mmu_create(vcpu);
+	if (r < 0)
+		goto fail_free_pio_data;
+
+	return 0;
+
+fail_free_pio_data:
+	free_page((unsigned long)vcpu->pio_data);
+fail_free_run:
+	free_page((unsigned long)vcpu->run);
+fail:
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_init);
+
+void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+	kvm_mmu_destroy(vcpu);
+	free_page((unsigned long)vcpu->pio_data);
+	free_page((unsigned long)vcpu->run);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
+
 static struct kvm *kvm_create_vm(void)
 {
 	struct kvm *kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
-	int i;
 
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
@@ -303,14 +356,6 @@ static struct kvm *kvm_create_vm(void)
 	spin_lock_init(&kvm->lock);
 	INIT_LIST_HEAD(&kvm->active_mmu_pages);
 	kvm_io_bus_init(&kvm->mmio_bus);
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		struct kvm_vcpu *vcpu = &kvm->vcpus[i];
-
-		mutex_init(&vcpu->mutex);
-		vcpu->cpu = -1;
-		vcpu->kvm = kvm;
-		vcpu->mmu.root_hpa = INVALID_PAGE;
-	}
 	spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	spin_unlock(&kvm_lock);
@@ -367,30 +412,11 @@ static void free_pio_guest_pages(struct kvm_vcpu *vcpu)
 
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->valid)
-		return;
-
 	vcpu_load(vcpu);
 	kvm_mmu_unload(vcpu);
 	vcpu_put(vcpu);
 }
 
-static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
-{
-	if (!vcpu->valid)
-		return;
-
-	vcpu_load(vcpu);
-	kvm_mmu_destroy(vcpu);
-	vcpu_put(vcpu);
-	kvm_arch_ops->vcpu_free(vcpu);
-	free_page((unsigned long)vcpu->run);
-	vcpu->run = NULL;
-	free_page((unsigned long)vcpu->pio_data);
-	vcpu->pio_data = NULL;
-	free_pio_guest_pages(vcpu);
-}
-
 static void kvm_free_vcpus(struct kvm *kvm)
 {
 	unsigned int i;
@@ -399,9 +425,15 @@ static void kvm_free_vcpus(struct kvm *kvm)
 	 * Unpin any mmu pages first.
 	 */
 	for (i = 0; i < KVM_MAX_VCPUS; ++i)
-		kvm_unload_vcpu_mmu(&kvm->vcpus[i]);
-	for (i = 0; i < KVM_MAX_VCPUS; ++i)
-		kvm_free_vcpu(&kvm->vcpus[i]);
+		if (kvm->vcpus[i])
+			kvm_unload_vcpu_mmu(kvm->vcpus[i]);
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		if (kvm->vcpus[i]) {
+			kvm_arch_ops->vcpu_free(kvm->vcpus[i]);
+			kvm->vcpus[i] = NULL;
+		}
+	}
+
 }
 
 static int kvm_dev_release(struct inode *inode, struct file *filp)
@@ -2372,77 +2404,47 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 {
 	int r;
 	struct kvm_vcpu *vcpu;
-	struct page *page;
 
-	r = -EINVAL;
 	if (!valid_vcpu(n))
-		goto out;
-
-	vcpu = &kvm->vcpus[n];
-	vcpu->vcpu_id = n;
-
-	mutex_lock(&vcpu->mutex);
-
-	if (vcpu->valid) {
-		mutex_unlock(&vcpu->mutex);
-		return -EEXIST;
-	}
-
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	r = -ENOMEM;
-	if (!page)
-		goto out_unlock;
-	vcpu->run = page_address(page);
-
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	r = -ENOMEM;
-	if (!page)
-		goto out_free_run;
-	vcpu->pio_data = page_address(page);
-
-	vcpu->host_fx_image = (char*)ALIGN((hva_t)vcpu->fx_buf,
-					   FX_IMAGE_ALIGN);
-	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
-	vcpu->cr0 = 0x10;
-
-	r = kvm_arch_ops->vcpu_create(vcpu);
-	if (r < 0)
-		goto out_free_vcpus;
+		return -EINVAL;
 
-	r = kvm_mmu_create(vcpu);
-	if (r < 0)
-		goto out_free_vcpus;
+	vcpu = kvm_arch_ops->vcpu_create(kvm, n);
+	if (IS_ERR(vcpu))
+		return PTR_ERR(vcpu);
 
-	kvm_arch_ops->vcpu_load(vcpu);
+	vcpu_load(vcpu);
 	r = kvm_mmu_setup(vcpu);
-	if (r >= 0)
-		r = kvm_arch_ops->vcpu_setup(vcpu);
 	vcpu_put(vcpu);
-
 	if (r < 0)
-		goto out_free_vcpus;
+		goto free_vcpu;
 
+	spin_lock(&kvm->lock);
+	if (kvm->vcpus[n]) {
+		r = -EEXIST;
+		spin_unlock(&kvm->lock);
+		goto mmu_unload;
+	}
+	kvm->vcpus[n] = vcpu;
+	spin_unlock(&kvm->lock);
+
+	/* Now it's all set up, let userspace reach it */
 	r = create_vcpu_fd(vcpu);
 	if (r < 0)
-		goto out_free_vcpus;
-
-	spin_lock(&kvm_lock);
-	if (n >= kvm->nvcpus)
-		kvm->nvcpus = n + 1;
-	spin_unlock(&kvm_lock);
+		goto unlink;
+	return r;
 
-	vcpu->valid = 1;
+unlink:
+	spin_lock(&kvm->lock);
+	kvm->vcpus[n] = NULL;
+	spin_unlock(&kvm->lock);
 
-	return r;
+mmu_unload:
+	vcpu_load(vcpu);
+	kvm_mmu_unload(vcpu);
+	vcpu_put(vcpu);
 
-out_free_vcpus:
-	kvm_free_vcpu(vcpu);
-out_free_run:
-	free_page((unsigned long)vcpu->run);
-	vcpu->run = NULL;
-out_unlock:
-	mutex_unlock(&vcpu->mutex);
-out:
+free_vcpu:
+	kvm_arch_ops->vcpu_free(vcpu);
 	return r;
 }
 
@@ -2935,9 +2937,12 @@ static void decache_vcpus_on_cpu(int cpu)
 	int i;
 
 	spin_lock(&kvm_lock);
-	list_for_each_entry(vm, &vm_list, vm_list)
+	list_for_each_entry(vm, &vm_list, vm_list) {
+		spin_lock(&vm->lock);
 		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			vcpu = &vm->vcpus[i];
+			vcpu = vm->vcpus[i];
+			if (!vcpu)
+				continue;
 			/*
 			 * If the vcpu is locked, then it is running on some
 			 * other cpu and therefore it is not cached on the
@@ -2954,6 +2959,8 @@ static void decache_vcpus_on_cpu(int cpu)
 				mutex_unlock(&vcpu->mutex);
 			}
 		}
+		spin_unlock(&vm->lock);
+	}
 	spin_unlock(&kvm_lock);
 }
 
@@ -3078,8 +3085,9 @@ static u64 stat_get(void *_offset)
 	spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			vcpu = &kvm->vcpus[i];
-			total += *(u32 *)((void *)vcpu + offset);
+			vcpu = kvm->vcpus[i];
+			if (vcpu)
+				total += *(u32 *)((void *)vcpu + offset);
 		}
 	spin_unlock(&kvm_lock);
 	return total;
diff --git a/drivers/kvm/kvm_svm.h b/drivers/kvm/kvm_svm.h
index 82e5d77..a0e415d 100644
--- a/drivers/kvm/kvm_svm.h
+++ b/drivers/kvm/kvm_svm.h
@@ -23,7 +23,7 @@ static const u32 host_save_user_msrs[] = {
 struct kvm_vcpu;
 
 struct vcpu_svm {
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu vcpu;
 	struct vmcb *vmcb;
 	unsigned long vmcb_pa;
 	struct svm_cpu_data *svm_data;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 3248187..0feec85 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -51,7 +51,7 @@ MODULE_LICENSE("GPL");
 
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
-	return (struct vcpu_svm*)vcpu->_priv;
+	return container_of(vcpu, struct vcpu_svm, vcpu);
 }
 
 unsigned long iopm_base;
@@ -466,11 +466,6 @@ static void init_sys_seg(struct vmcb_seg *seg, uint32_t type)
 	seg->base = 0;
 }
 
-static int svm_vcpu_setup(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
 static void init_vmcb(struct vmcb *vmcb)
 {
 	struct vmcb_control_area *control = &vmcb->control;
@@ -576,19 +571,27 @@ static void init_vmcb(struct vmcb *vmcb)
 	/* rdx = ?? */
 }
 
-static int svm_create_vcpu(struct kvm_vcpu *vcpu)
+static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 {
 	struct vcpu_svm *svm;
 	struct page *page;
-	int r;
+	int err;
 
-	r = -ENOMEM;
 	svm = kzalloc(sizeof *svm, GFP_KERNEL);
-	if (!svm)
-		goto out1;
+	if (!svm) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = kvm_vcpu_init(&svm->vcpu, kvm, id);
+	if (err)
+		goto free_svm;
+
 	page = alloc_page(GFP_KERNEL);
-	if (!page)
-		goto out2;
+	if (!page) {
+		err = -ENOMEM;
+		goto uninit;
+	}
 
 	svm->vmcb = page_address(page);
 	clear_page(svm->vmcb);
@@ -597,33 +600,29 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	memset(svm->db_regs, 0, sizeof(svm->db_regs));
 	init_vmcb(svm->vmcb);
 
-	svm->vcpu   = vcpu;
-	vcpu->_priv = svm;
+	fx_init(&svm->vcpu);
+	svm->vcpu.fpu_active = 1;
+	svm->vcpu.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
+	if (svm->vcpu.vcpu_id == 0)
+		svm->vcpu.apic_base |= MSR_IA32_APICBASE_BSP;
 
-	fx_init(vcpu);
-	vcpu->fpu_active = 1;
-	vcpu->apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
-	if (vcpu->vcpu_id == 0)
-		vcpu->apic_base |= MSR_IA32_APICBASE_BSP;
+	return &svm->vcpu;
 
-	return 0;
-
-out2:
+uninit:
+	kvm_vcpu_uninit(&svm->vcpu);
+free_svm:
 	kfree(svm);
-out1:
-	return r;
+out:
+	return ERR_PTR(err);
 }
 
 static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (!svm)
-		return;
-	if (svm->vmcb)
-		__free_page(pfn_to_page(svm->vmcb_pa >> PAGE_SHIFT));
+	__free_page(pfn_to_page(svm->vmcb_pa >> PAGE_SHIFT));
+	kvm_vcpu_uninit(vcpu);
 	kfree(svm);
-	vcpu->_priv = NULL;
 }
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu)
@@ -1591,34 +1590,33 @@ again:
 #endif
 
 #ifdef CONFIG_X86_64
-		"mov %c[rbx](%[vcpu]), %%rbx \n\t"
-		"mov %c[rcx](%[vcpu]), %%rcx \n\t"
-		"mov %c[rdx](%[vcpu]), %%rdx \n\t"
-		"mov %c[rsi](%[vcpu]), %%rsi \n\t"
-		"mov %c[rdi](%[vcpu]), %%rdi \n\t"
-		"mov %c[rbp](%[vcpu]), %%rbp \n\t"
-		"mov %c[r8](%[vcpu]),  %%r8  \n\t"
-		"mov %c[r9](%[vcpu]),  %%r9  \n\t"
-		"mov %c[r10](%[vcpu]), %%r10 \n\t"
-		"mov %c[r11](%[vcpu]), %%r11 \n\t"
-		"mov %c[r12](%[vcpu]), %%r12 \n\t"
-		"mov %c[r13](%[vcpu]), %%r13 \n\t"
-		"mov %c[r14](%[vcpu]), %%r14 \n\t"
-		"mov %c[r15](%[vcpu]), %%r15 \n\t"
+		"mov %c[rbx](%[svm]), %%rbx \n\t"
+		"mov %c[rcx](%[svm]), %%rcx \n\t"
+		"mov %c[rdx](%[svm]), %%rdx \n\t"
+		"mov %c[rsi](%[svm]), %%rsi \n\t"
+		"mov %c[rdi](%[svm]), %%rdi \n\t"
+		"mov %c[rbp](%[svm]), %%rbp \n\t"
+		"mov %c[r8](%[svm]),  %%r8  \n\t"
+		"mov %c[r9](%[svm]),  %%r9  \n\t"
+		"mov %c[r10](%[svm]), %%r10 \n\t"
+		"mov %c[r11](%[svm]), %%r11 \n\t"
+		"mov %c[r12](%[svm]), %%r12 \n\t"
+		"mov %c[r13](%[svm]), %%r13 \n\t"
+		"mov %c[r14](%[svm]), %%r14 \n\t"
+		"mov %c[r15](%[svm]), %%r15 \n\t"
 #else
-		"mov %c[rbx](%[vcpu]), %%ebx \n\t"
-		"mov %c[rcx](%[vcpu]), %%ecx \n\t"
-		"mov %c[rdx](%[vcpu]), %%edx \n\t"
-		"mov %c[rsi](%[vcpu]), %%esi \n\t"
-		"mov %c[rdi](%[vcpu]), %%edi \n\t"
-		"mov %c[rbp](%[vcpu]), %%ebp \n\t"
+		"mov %c[rbx](%[svm]), %%ebx \n\t"
+		"mov %c[rcx](%[svm]), %%ecx \n\t"
+		"mov %c[rdx](%[svm]), %%edx \n\t"
+		"mov %c[rsi](%[svm]), %%esi \n\t"
+		"mov %c[rdi](%[svm]), %%edi \n\t"
+		"mov %c[rbp](%[svm]), %%ebp \n\t"
 #endif
 
 #ifdef CONFIG_X86_64
 		/* Enter guest mode */
 		"push %%rax \n\t"
-		"mov %c[svm](%[vcpu]), %%rax \n\t"
-		"mov %c[vmcb](%%rax), %%rax \n\t"
+		"mov %c[vmcb](%[svm]), %%rax \n\t"
 		SVM_VMLOAD "\n\t"
 		SVM_VMRUN "\n\t"
 		SVM_VMSAVE "\n\t"
@@ -1626,8 +1624,7 @@ again:
 #else
 		/* Enter guest mode */
 		"push %%eax \n\t"
-		"mov %c[svm](%[vcpu]), %%eax \n\t"
-		"mov %c[vmcb](%%eax), %%eax \n\t"
+		"mov %c[vmcb](%[svm]), %%eax \n\t"
 		SVM_VMLOAD "\n\t"
 		SVM_VMRUN "\n\t"
 		SVM_VMSAVE "\n\t"
@@ -1636,55 +1633,54 @@ again:
 
 		/* Save guest registers, load host registers */
 #ifdef CONFIG_X86_64
-		"mov %%rbx, %c[rbx](%[vcpu]) \n\t"
-		"mov %%rcx, %c[rcx](%[vcpu]) \n\t"
-		"mov %%rdx, %c[rdx](%[vcpu]) \n\t"
-		"mov %%rsi, %c[rsi](%[vcpu]) \n\t"
-		"mov %%rdi, %c[rdi](%[vcpu]) \n\t"
-		"mov %%rbp, %c[rbp](%[vcpu]) \n\t"
-		"mov %%r8,  %c[r8](%[vcpu]) \n\t"
-		"mov %%r9,  %c[r9](%[vcpu]) \n\t"
-		"mov %%r10, %c[r10](%[vcpu]) \n\t"
-		"mov %%r11, %c[r11](%[vcpu]) \n\t"
-		"mov %%r12, %c[r12](%[vcpu]) \n\t"
-		"mov %%r13, %c[r13](%[vcpu]) \n\t"
-		"mov %%r14, %c[r14](%[vcpu]) \n\t"
-		"mov %%r15, %c[r15](%[vcpu]) \n\t"
+		"mov %%rbx, %c[rbx](%[svm]) \n\t"
+		"mov %%rcx, %c[rcx](%[svm]) \n\t"
+		"mov %%rdx, %c[rdx](%[svm]) \n\t"
+		"mov %%rsi, %c[rsi](%[svm]) \n\t"
+		"mov %%rdi, %c[rdi](%[svm]) \n\t"
+		"mov %%rbp, %c[rbp](%[svm]) \n\t"
+		"mov %%r8,  %c[r8](%[svm]) \n\t"
+		"mov %%r9,  %c[r9](%[svm]) \n\t"
+		"mov %%r10, %c[r10](%[svm]) \n\t"
+		"mov %%r11, %c[r11](%[svm]) \n\t"
+		"mov %%r12, %c[r12](%[svm]) \n\t"
+		"mov %%r13, %c[r13](%[svm]) \n\t"
+		"mov %%r14, %c[r14](%[svm]) \n\t"
+		"mov %%r15, %c[r15](%[svm]) \n\t"
 
 		"pop  %%r15; pop  %%r14; pop  %%r13; pop  %%r12;"
 		"pop  %%r11; pop  %%r10; pop  %%r9;  pop  %%r8;"
 		"pop  %%rbp; pop  %%rdi; pop  %%rsi;"
 		"pop  %%rdx; pop  %%rcx; pop  %%rbx; \n\t"
 #else
-		"mov %%ebx, %c[rbx](%[vcpu]) \n\t"
-		"mov %%ecx, %c[rcx](%[vcpu]) \n\t"
-		"mov %%edx, %c[rdx](%[vcpu]) \n\t"
-		"mov %%esi, %c[rsi](%[vcpu]) \n\t"
-		"mov %%edi, %c[rdi](%[vcpu]) \n\t"
-		"mov %%ebp, %c[rbp](%[vcpu]) \n\t"
+		"mov %%ebx, %c[rbx](%[svm]) \n\t"
+		"mov %%ecx, %c[rcx](%[svm]) \n\t"
+		"mov %%edx, %c[rdx](%[svm]) \n\t"
+		"mov %%esi, %c[rsi](%[svm]) \n\t"
+		"mov %%edi, %c[rdi](%[svm]) \n\t"
+		"mov %%ebp, %c[rbp](%[svm]) \n\t"
 
 		"pop  %%ebp; pop  %%edi; pop  %%esi;"
 		"pop  %%edx; pop  %%ecx; pop  %%ebx; \n\t"
 #endif
 		:
-		: [vcpu]"a"(vcpu),
-		  [svm]"i"(offsetof(struct kvm_vcpu, _priv)),
+		: [svm]"a"(svm),
 		  [vmcb]"i"(offsetof(struct vcpu_svm, vmcb_pa)),
-		  [rbx]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RBX])),
-		  [rcx]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RCX])),
-		  [rdx]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RDX])),
-		  [rsi]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RSI])),
-		  [rdi]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RDI])),
-		  [rbp]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RBP]))
+		  [rbx]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_RBX])),
+		  [rcx]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_RCX])),
+		  [rdx]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_RDX])),
+		  [rsi]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_RSI])),
+		  [rdi]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_RDI])),
+		  [rbp]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_RBP]))
 #ifdef CONFIG_X86_64
-		  ,[r8 ]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R8 ])),
-		  [r9 ]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R9 ])),
-		  [r10]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R10])),
-		  [r11]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R11])),
-		  [r12]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R12])),
-		  [r13]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R13])),
-		  [r14]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R14])),
-		  [r15]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R15]))
+		  ,[r8 ]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R8])),
+		  [r9 ]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R9 ])),
+		  [r10]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R10])),
+		  [r11]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R11])),
+		  [r12]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R12])),
+		  [r13]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R13])),
+		  [r14]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R14])),
+		  [r15]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R15]))
 #endif
 		: "cc", "memory" );
 
@@ -1865,7 +1861,6 @@ static struct kvm_arch_ops svm_arch_ops = {
 
 	.run = svm_vcpu_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
-	.vcpu_setup = svm_vcpu_setup,
 	.patch_hypercall = svm_patch_hypercall,
 };
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 96837d6..df57878 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -39,7 +39,7 @@ struct vmcs {
 };
 
 struct vcpu_vmx {
-	struct kvm_vcpu      *vcpu;
+	struct kvm_vcpu       vcpu;
 	int                   launched;
 	struct kvm_msr_entry *guest_msrs;
 	struct kvm_msr_entry *host_msrs;
@@ -60,7 +60,7 @@ struct vcpu_vmx {
 
 static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
 {
-	return (struct vcpu_vmx*)vcpu->_priv;
+	return container_of(vcpu, struct vcpu_vmx, vcpu);
 }
 
 static int init_rmode_tss(struct kvm *kvm);
@@ -2302,46 +2302,62 @@ static void vmx_free_vmcs(struct kvm_vcpu *vcpu)
 
 static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
 	vmx_free_vmcs(vcpu);
+	kfree(vmx->host_msrs);
+	kfree(vmx->guest_msrs);
+	kvm_vcpu_uninit(vcpu);
+	kfree(vmx);
 }
 
-static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
+static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 {
-	struct vcpu_vmx *vmx;
+	int err;
+	struct vcpu_vmx *vmx = kzalloc(sizeof(*vmx), GFP_KERNEL);
 
-	vmx = kzalloc(sizeof(*vmx), GFP_KERNEL);
 	if (!vmx)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
+
+	err = kvm_vcpu_init(&vmx->vcpu, kvm, id);
+	if (err)
+		goto free_vcpu;
 
 	vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!vmx->guest_msrs)
-		goto out_free;
+	if (!vmx->guest_msrs) {
+		err = -ENOMEM;
+		goto uninit_vcpu;
+	}
 
 	vmx->host_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!vmx->host_msrs)
-		goto out_free;
+		goto free_guest_msrs;
 
 	vmx->vmcs = alloc_vmcs();
 	if (!vmx->vmcs)
-		goto out_free;
+		goto free_msrs;
 
 	vmcs_clear(vmx->vmcs);
 
-	vmx->vcpu   = vcpu;
-	vcpu->_priv = vmx;
-
-	return 0;
-
-out_free:
-	if (vmx->host_msrs)
-		kfree(vmx->host_msrs);
-
-	if (vmx->guest_msrs)
-		kfree(vmx->guest_msrs);
-
+	vmx_vcpu_load(&vmx->vcpu);
+	err = vmx_vcpu_setup(&vmx->vcpu);
+	vmx_vcpu_put(&vmx->vcpu);
+	if (err)
+		goto free_vmcs;
+
+	return &vmx->vcpu;
+
+free_vmcs:
+	free_vmcs(vmx->vmcs);
+free_msrs:
+	kfree(vmx->host_msrs);
+free_guest_msrs:
+	kfree(vmx->guest_msrs);
+uninit_vcpu:
+	kvm_vcpu_uninit(&vmx->vcpu);
+free_vcpu:
 	kfree(vmx);
-
-	return -ENOMEM;
+	return ERR_PTR(err);
 }
 
 static struct kvm_arch_ops vmx_arch_ops = {
@@ -2389,7 +2405,6 @@ static struct kvm_arch_ops vmx_arch_ops = {
 
 	.run = vmx_vcpu_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
-	.vcpu_setup = vmx_vcpu_setup,
 	.patch_hypercall = vmx_patch_hypercall,
 };
 
-- 
1.5.3

