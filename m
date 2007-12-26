Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXLZLVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXLZLVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXLZLHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:05 -0500
Received: from il.qumranet.com ([82.166.9.18]:50488 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbXLZLGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:11 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 49/55] KVM: Portability: Add vcpu and hardware management arch hooks
Date: Wed, 26 Dec 2007 13:05:54 +0200
Message-Id: <1198667160-22953-50-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Add the following hooks:

  void decache_vcpus_on_cpu(int cpu);
  int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu);
  void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
  void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu);
  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
  struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id);
  void kvm_arch_vcpu_destory(struct kvm_vcpu *vcpu);
  int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu);
  void kvm_arch_hardware_enable(void *garbage);
  void kvm_arch_hardware_disable(void *garbage);
  int kvm_arch_hardware_setup(void);
  void kvm_arch_hardware_unsetup(void);
  void kvm_arch_check_processor_compat(void *rtn);

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |   19 ++++++
 drivers/kvm/kvm_main.c |  113 ++++++-----------------------------
 drivers/kvm/x86.c      |  157 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/x86.h      |    3 +
 4 files changed, 197 insertions(+), 95 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 6498324..bca07c6 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -492,6 +492,8 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
 void vcpu_load(struct kvm_vcpu *vcpu);
 void vcpu_put(struct kvm_vcpu *vcpu);
 
+void decache_vcpus_on_cpu(int cpu);
+
 
 int kvm_init_x86(struct kvm_x86_ops *ops, unsigned int vcpu_size,
 		  struct module *module);
@@ -649,6 +651,23 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
 
 __init void kvm_arch_init(void);
 
+int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
+
+void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
+struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id);
+void kvm_arch_vcpu_destory(struct kvm_vcpu *vcpu);
+
+int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu);
+void kvm_arch_hardware_enable(void *garbage);
+void kvm_arch_hardware_disable(void *garbage);
+int kvm_arch_hardware_setup(void);
+void kvm_arch_hardware_unsetup(void);
+void kvm_arch_check_processor_compat(void *rtn);
+
+
 static inline void kvm_guest_enter(void)
 {
 	account_system_vtime(current);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 7808189..2610046 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -50,8 +50,8 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
-static DEFINE_SPINLOCK(kvm_lock);
-static LIST_HEAD(vm_list);
+DEFINE_SPINLOCK(kvm_lock);
+LIST_HEAD(vm_list);
 
 static cpumask_t cpus_hardware_enabled;
 
@@ -124,13 +124,8 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 
 	mutex_init(&vcpu->mutex);
 	vcpu->cpu = -1;
-	vcpu->mmu.root_hpa = INVALID_PAGE;
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
-	if (!irqchip_in_kernel(kvm) || id == 0)
-		vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
-	else
-		vcpu->mp_state = VCPU_MP_STATE_UNINITIALIZED;
 	init_waitqueue_head(&vcpu->wq);
 
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
@@ -140,29 +135,11 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	}
 	vcpu->run = page_address(page);
 
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page) {
-		r = -ENOMEM;
-		goto fail_free_run;
-	}
-	vcpu->pio_data = page_address(page);
-
-	r = kvm_mmu_create(vcpu);
+	r = kvm_arch_vcpu_init(vcpu);
 	if (r < 0)
-		goto fail_free_pio_data;
-
-	if (irqchip_in_kernel(kvm)) {
-		r = kvm_create_lapic(vcpu);
-		if (r < 0)
-			goto fail_mmu_destroy;
-	}
-
+		goto fail_free_run;
 	return 0;
 
-fail_mmu_destroy:
-	kvm_mmu_destroy(vcpu);
-fail_free_pio_data:
-	free_page((unsigned long)vcpu->pio_data);
 fail_free_run:
 	free_page((unsigned long)vcpu->run);
 fail:
@@ -172,9 +149,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_init);
 
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
-	kvm_free_lapic(vcpu);
-	kvm_mmu_destroy(vcpu);
-	free_page((unsigned long)vcpu->pio_data);
+	kvm_arch_vcpu_uninit(vcpu);
 	free_page((unsigned long)vcpu->run);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
@@ -240,7 +215,7 @@ static void kvm_free_vcpus(struct kvm *kvm)
 			kvm_unload_vcpu_mmu(kvm->vcpus[i]);
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (kvm->vcpus[i]) {
-			kvm_x86_ops->vcpu_free(kvm->vcpus[i]);
+			kvm_arch_vcpu_free(kvm->vcpus[i]);
 			kvm->vcpus[i] = NULL;
 		}
 	}
@@ -900,28 +875,17 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 	if (!valid_vcpu(n))
 		return -EINVAL;
 
-	vcpu = kvm_x86_ops->vcpu_create(kvm, n);
+	vcpu = kvm_arch_vcpu_create(kvm, n);
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
 
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 
-	/* We do fxsave: this must be aligned. */
-	BUG_ON((unsigned long)&vcpu->host_fx_image & 0xF);
-
-	vcpu_load(vcpu);
-	r = kvm_x86_ops->vcpu_reset(vcpu);
-	if (r == 0)
-		r = kvm_mmu_setup(vcpu);
-	vcpu_put(vcpu);
-	if (r < 0)
-		goto free_vcpu;
-
 	mutex_lock(&kvm->lock);
 	if (kvm->vcpus[n]) {
 		r = -EEXIST;
 		mutex_unlock(&kvm->lock);
-		goto mmu_unload;
+		goto vcpu_destroy;
 	}
 	kvm->vcpus[n] = vcpu;
 	mutex_unlock(&kvm->lock);
@@ -936,14 +900,8 @@ unlink:
 	mutex_lock(&kvm->lock);
 	kvm->vcpus[n] = NULL;
 	mutex_unlock(&kvm->lock);
-
-mmu_unload:
-	vcpu_load(vcpu);
-	kvm_mmu_unload(vcpu);
-	vcpu_put(vcpu);
-
-free_vcpu:
-	kvm_x86_ops->vcpu_free(vcpu);
+vcpu_destroy:
+	kvm_arch_vcpu_destory(vcpu);
 	return r;
 }
 
@@ -1281,41 +1239,6 @@ static struct miscdevice kvm_dev = {
 	&kvm_chardev_ops,
 };
 
-/*
- * Make sure that a cpu that is being hot-unplugged does not have any vcpus
- * cached on it.
- */
-static void decache_vcpus_on_cpu(int cpu)
-{
-	struct kvm *vm;
-	struct kvm_vcpu *vcpu;
-	int i;
-
-	spin_lock(&kvm_lock);
-	list_for_each_entry(vm, &vm_list, vm_list)
-		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			vcpu = vm->vcpus[i];
-			if (!vcpu)
-				continue;
-			/*
-			 * If the vcpu is locked, then it is running on some
-			 * other cpu and therefore it is not cached on the
-			 * cpu in question.
-			 *
-			 * If it's not locked, check the last cpu it executed
-			 * on.
-			 */
-			if (mutex_trylock(&vcpu->mutex)) {
-				if (vcpu->cpu == cpu) {
-					kvm_x86_ops->vcpu_decache(vcpu);
-					vcpu->cpu = -1;
-				}
-				mutex_unlock(&vcpu->mutex);
-			}
-		}
-	spin_unlock(&kvm_lock);
-}
-
 static void hardware_enable(void *junk)
 {
 	int cpu = raw_smp_processor_id();
@@ -1323,7 +1246,7 @@ static void hardware_enable(void *junk)
 	if (cpu_isset(cpu, cpus_hardware_enabled))
 		return;
 	cpu_set(cpu, cpus_hardware_enabled);
-	kvm_x86_ops->hardware_enable(NULL);
+	kvm_arch_hardware_enable(NULL);
 }
 
 static void hardware_disable(void *junk)
@@ -1334,7 +1257,7 @@ static void hardware_disable(void *junk)
 		return;
 	cpu_clear(cpu, cpus_hardware_enabled);
 	decache_vcpus_on_cpu(cpu);
-	kvm_x86_ops->hardware_disable(NULL);
+	kvm_arch_hardware_disable(NULL);
 }
 
 static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
@@ -1500,7 +1423,7 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	kvm_x86_ops->vcpu_load(vcpu, cpu);
+	kvm_arch_vcpu_load(vcpu, cpu);
 }
 
 static void kvm_sched_out(struct preempt_notifier *pn,
@@ -1508,7 +1431,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	kvm_x86_ops->vcpu_put(vcpu);
+	kvm_arch_vcpu_put(vcpu);
 }
 
 int kvm_init_x86(struct kvm_x86_ops *ops, unsigned int vcpu_size,
@@ -1533,13 +1456,13 @@ int kvm_init_x86(struct kvm_x86_ops *ops, unsigned int vcpu_size,
 
 	kvm_x86_ops = ops;
 
-	r = kvm_x86_ops->hardware_setup();
+	r = kvm_arch_hardware_setup();
 	if (r < 0)
 		goto out;
 
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu,
-				kvm_x86_ops->check_processor_compatibility,
+				kvm_arch_check_processor_compat,
 				&r, 0, 1);
 		if (r < 0)
 			goto out_free_0;
@@ -1594,7 +1517,7 @@ out_free_2:
 out_free_1:
 	on_each_cpu(hardware_disable, NULL, 0, 1);
 out_free_0:
-	kvm_x86_ops->hardware_unsetup();
+	kvm_arch_hardware_unsetup();
 out:
 	kvm_x86_ops = NULL;
 	return r;
@@ -1610,7 +1533,7 @@ void kvm_exit_x86(void)
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 	on_each_cpu(hardware_disable, NULL, 0, 1);
-	kvm_x86_ops->hardware_unsetup();
+	kvm_arch_hardware_unsetup();
 	kvm_x86_ops = NULL;
 }
 EXPORT_SYMBOL_GPL(kvm_exit_x86);
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 2edc53e..4902b35 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -564,6 +564,41 @@ out:
 	return r;
 }
 
+/*
+ * Make sure that a cpu that is being hot-unplugged does not have any vcpus
+ * cached on it.
+ */
+void decache_vcpus_on_cpu(int cpu)
+{
+	struct kvm *vm;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	spin_lock(&kvm_lock);
+	list_for_each_entry(vm, &vm_list, vm_list)
+		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+			vcpu = vm->vcpus[i];
+			if (!vcpu)
+				continue;
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
+					kvm_x86_ops->vcpu_decache(vcpu);
+					vcpu->cpu = -1;
+				}
+				mutex_unlock(&vcpu->mutex);
+			}
+		}
+	spin_unlock(&kvm_lock);
+}
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
@@ -2319,3 +2354,125 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	fx_restore(&vcpu->host_fx_image);
 }
 EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
+
+void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops->vcpu_free(vcpu);
+}
+
+struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
+						unsigned int id)
+{
+	int r;
+	struct kvm_vcpu *vcpu = kvm_x86_ops->vcpu_create(kvm, id);
+
+	if (IS_ERR(vcpu)) {
+		r = -ENOMEM;
+		goto fail;
+	}
+
+	/* We do fxsave: this must be aligned. */
+	BUG_ON((unsigned long)&vcpu->host_fx_image & 0xF);
+
+	vcpu_load(vcpu);
+	r = kvm_arch_vcpu_reset(vcpu);
+	if (r == 0)
+		r = kvm_mmu_setup(vcpu);
+	vcpu_put(vcpu);
+	if (r < 0)
+		goto free_vcpu;
+
+	return vcpu;
+free_vcpu:
+	kvm_x86_ops->vcpu_free(vcpu);
+fail:
+	return ERR_PTR(r);
+}
+
+void kvm_arch_vcpu_destory(struct kvm_vcpu *vcpu)
+{
+	vcpu_load(vcpu);
+	kvm_mmu_unload(vcpu);
+	vcpu_put(vcpu);
+
+	kvm_x86_ops->vcpu_free(vcpu);
+}
+
+int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
+{
+	return kvm_x86_ops->vcpu_reset(vcpu);
+}
+
+void kvm_arch_hardware_enable(void *garbage)
+{
+	kvm_x86_ops->hardware_enable(garbage);
+}
+
+void kvm_arch_hardware_disable(void *garbage)
+{
+	kvm_x86_ops->hardware_disable(garbage);
+}
+
+int kvm_arch_hardware_setup(void)
+{
+	return kvm_x86_ops->hardware_setup();
+}
+
+void kvm_arch_hardware_unsetup(void)
+{
+	kvm_x86_ops->hardware_unsetup();
+}
+
+void kvm_arch_check_processor_compat(void *rtn)
+{
+	kvm_x86_ops->check_processor_compatibility(rtn);
+}
+
+int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	struct page *page;
+	struct kvm *kvm;
+	int r;
+
+	BUG_ON(vcpu->kvm == NULL);
+	kvm = vcpu->kvm;
+
+	vcpu->mmu.root_hpa = INVALID_PAGE;
+	if (!irqchip_in_kernel(kvm) || vcpu->vcpu_id == 0)
+		vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
+	else
+		vcpu->mp_state = VCPU_MP_STATE_UNINITIALIZED;
+
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page) {
+		r = -ENOMEM;
+		goto fail;
+	}
+	vcpu->pio_data = page_address(page);
+
+	r = kvm_mmu_create(vcpu);
+	if (r < 0)
+		goto fail_free_pio_data;
+
+	if (irqchip_in_kernel(kvm)) {
+		r = kvm_create_lapic(vcpu);
+		if (r < 0)
+			goto fail_mmu_destroy;
+	}
+
+	return 0;
+
+fail_mmu_destroy:
+	kvm_mmu_destroy(vcpu);
+fail_free_pio_data:
+	free_page((unsigned long)vcpu->pio_data);
+fail:
+	return r;
+}
+
+void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+	kvm_free_lapic(vcpu);
+	kvm_mmu_destroy(vcpu);
+	free_page((unsigned long)vcpu->pio_data);
+}
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index ec32c26..4df0641 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -19,6 +19,9 @@
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
 
+extern spinlock_t kvm_lock;
+extern struct list_head vm_list;
+
 struct kvm_vcpu {
 	KVM_VCPU_COMM;
 	u64 host_tsc;
-- 
1.5.3.7

