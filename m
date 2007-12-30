Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbXL3HL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbXL3HL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbXL3HKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:50 -0500
Received: from il.qumranet.com ([82.166.9.18]:59468 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbXL3HKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:42 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao@vtsmp-build32.los-vmm.org>
Subject: [PATCH 03/52] KVM: Portability: Add two hooks to handle kvm_create and destroy vm
Date: Sun, 30 Dec 2007 09:09:49 +0200
Message-Id: <1198998638-22713-4-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao@vtsmp-build32.los-vmm.org>

Add two arch hooks to handle kvm_create_vm and kvm destroy_vm. Now, just
put io_bus init and destory in common.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    4 ++++
 drivers/kvm/kvm_main.c |   42 ++++++------------------------------------
 drivers/kvm/x86.c      |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index c4ad66b..59e001c 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -674,6 +674,10 @@ int kvm_arch_hardware_setup(void);
 void kvm_arch_hardware_unsetup(void);
 void kvm_arch_check_processor_compat(void *rtn);
 
+void kvm_free_physmem(struct kvm *kvm);
+
+struct  kvm *kvm_arch_create_vm(void);
+void kvm_arch_destroy_vm(struct kvm *kvm);
 
 static inline void kvm_guest_enter(void)
 {
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index acd26cf..3aa34de 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -156,18 +156,18 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
 
 static struct kvm *kvm_create_vm(void)
 {
-	struct kvm *kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
+	struct kvm *kvm = kvm_arch_create_vm();
 
-	if (!kvm)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(kvm))
+		goto out;
 
 	kvm_io_bus_init(&kvm->pio_bus);
 	mutex_init(&kvm->lock);
-	INIT_LIST_HEAD(&kvm->active_mmu_pages);
 	kvm_io_bus_init(&kvm->mmio_bus);
 	spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	spin_unlock(&kvm_lock);
+out:
 	return kvm;
 }
 
@@ -188,7 +188,7 @@ static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
 	free->rmap = NULL;
 }
 
-static void kvm_free_physmem(struct kvm *kvm)
+void kvm_free_physmem(struct kvm *kvm)
 {
 	int i;
 
@@ -196,32 +196,6 @@ static void kvm_free_physmem(struct kvm *kvm)
 		kvm_free_physmem_slot(&kvm->memslots[i], NULL);
 }
 
-static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
-{
-	vcpu_load(vcpu);
-	kvm_mmu_unload(vcpu);
-	vcpu_put(vcpu);
-}
-
-static void kvm_free_vcpus(struct kvm *kvm)
-{
-	unsigned int i;
-
-	/*
-	 * Unpin any mmu pages first.
-	 */
-	for (i = 0; i < KVM_MAX_VCPUS; ++i)
-		if (kvm->vcpus[i])
-			kvm_unload_vcpu_mmu(kvm->vcpus[i]);
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		if (kvm->vcpus[i]) {
-			kvm_arch_vcpu_free(kvm->vcpus[i]);
-			kvm->vcpus[i] = NULL;
-		}
-	}
-
-}
-
 static void kvm_destroy_vm(struct kvm *kvm)
 {
 	spin_lock(&kvm_lock);
@@ -229,11 +203,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	spin_unlock(&kvm_lock);
 	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
-	kfree(kvm->vpic);
-	kfree(kvm->vioapic);
-	kvm_free_vcpus(kvm);
-	kvm_free_physmem(kvm);
-	kfree(kvm);
+	kvm_arch_destroy_vm(kvm);
 }
 
 static int kvm_vm_release(struct inode *inode, struct file *filp)
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index abb7bee..b7c72ac 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -2543,3 +2543,50 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 	kvm_mmu_destroy(vcpu);
 	free_page((unsigned long)vcpu->pio_data);
 }
+
+struct  kvm *kvm_arch_create_vm(void)
+{
+	struct kvm *kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
+
+	if (!kvm)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&kvm->active_mmu_pages);
+
+	return kvm;
+}
+
+static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
+{
+	vcpu_load(vcpu);
+	kvm_mmu_unload(vcpu);
+	vcpu_put(vcpu);
+}
+
+static void kvm_free_vcpus(struct kvm *kvm)
+{
+	unsigned int i;
+
+	/*
+	 * Unpin any mmu pages first.
+	 */
+	for (i = 0; i < KVM_MAX_VCPUS; ++i)
+		if (kvm->vcpus[i])
+			kvm_unload_vcpu_mmu(kvm->vcpus[i]);
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		if (kvm->vcpus[i]) {
+			kvm_arch_vcpu_free(kvm->vcpus[i]);
+			kvm->vcpus[i] = NULL;
+		}
+	}
+
+}
+
+void kvm_arch_destroy_vm(struct kvm *kvm)
+{
+	kfree(kvm->vpic);
+	kfree(kvm->vioapic);
+	kvm_free_vcpus(kvm);
+	kvm_free_physmem(kvm);
+	kfree(kvm);
+}
-- 
1.5.3.7

