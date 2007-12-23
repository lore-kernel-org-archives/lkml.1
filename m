Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbXLWO6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbXLWO6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbXLWOwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:00 -0500
Received: from il.qumranet.com ([82.166.9.18]:35921 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbXLWOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 22/50] KVM: Allow dynamic allocation of the mmu shadow cache size
Date: Sun, 23 Dec 2007 16:51:07 +0200
Message-Id: <1198421495-31481-23-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

The user is now able to set how many mmu pages will be allocated to the guest.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    7 ++++++-
 drivers/kvm/kvm_main.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/mmu.c      |   40 ++++++++++++++++++++++++++++++++++++++--
 include/linux/kvm.h    |    3 +++
 4 files changed, 94 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 1965438..9f10c37 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -40,6 +40,8 @@
 #define KVM_MAX_VCPUS 4
 #define KVM_ALIAS_SLOTS 4
 #define KVM_MEMORY_SLOTS 8
+#define KVM_PERMILLE_MMU_PAGES 20
+#define KVM_MIN_ALLOC_MMU_PAGES 64
 #define KVM_NUM_MMU_PAGES 1024
 #define KVM_MIN_FREE_MMU_PAGES 5
 #define KVM_REFILL_PAGES 25
@@ -418,7 +420,9 @@ struct kvm {
 	 * Hash table of struct kvm_mmu_page.
 	 */
 	struct list_head active_mmu_pages;
-	int n_free_mmu_pages;
+	unsigned int n_free_mmu_pages;
+	unsigned int n_requested_mmu_pages;
+	unsigned int n_alloc_mmu_pages;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	unsigned long rmap_overflow;
@@ -547,6 +551,7 @@ void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte);
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
 void kvm_mmu_zap_all(struct kvm *kvm);
+void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
 
 hpa_t gpa_to_hpa(struct kvm_vcpu *vcpu, gpa_t gpa);
 #define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 3d1972e..d220e63 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -743,6 +743,24 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	if (mem->slot >= kvm->nmemslots)
 		kvm->nmemslots = mem->slot + 1;
 
+	if (!kvm->n_requested_mmu_pages) {
+		unsigned int n_pages;
+
+		if (npages) {
+			n_pages = npages * KVM_PERMILLE_MMU_PAGES / 1000;
+			kvm_mmu_change_mmu_pages(kvm, kvm->n_alloc_mmu_pages +
+						 n_pages);
+		} else {
+			unsigned int nr_mmu_pages;
+
+			n_pages = old.npages * KVM_PERMILLE_MMU_PAGES / 1000;
+			nr_mmu_pages = kvm->n_alloc_mmu_pages - n_pages;
+			nr_mmu_pages = max(nr_mmu_pages,
+				        (unsigned int) KVM_MIN_ALLOC_MMU_PAGES);
+			kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
+		}
+	}
+
 	*memslot = new;
 
 	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
@@ -760,6 +778,26 @@ out:
 	return r;
 }
 
+static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
+					  u32 kvm_nr_mmu_pages)
+{
+	if (kvm_nr_mmu_pages < KVM_MIN_ALLOC_MMU_PAGES)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+
+	kvm_mmu_change_mmu_pages(kvm, kvm_nr_mmu_pages);
+	kvm->n_requested_mmu_pages = kvm_nr_mmu_pages;
+
+	mutex_unlock(&kvm->lock);
+	return 0;
+}
+
+static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
+{
+	return kvm->n_alloc_mmu_pages;
+}
+
 /*
  * Get (and clear) the dirty memory log for a memory slot.
  */
@@ -3071,6 +3109,14 @@ static long kvm_vm_ioctl(struct file *filp,
 			goto out;
 		break;
 	}
+	case KVM_SET_NR_MMU_PAGES:
+		r = kvm_vm_ioctl_set_nr_mmu_pages(kvm, arg);
+		if (r)
+			goto out;
+		break;
+	case KVM_GET_NR_MMU_PAGES:
+		r = kvm_vm_ioctl_get_nr_mmu_pages(kvm);
+		break;
 	case KVM_GET_DIRTY_LOG: {
 		struct kvm_dirty_log log;
 
@@ -3278,6 +3324,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		switch (ext) {
 		case KVM_CAP_IRQCHIP:
 		case KVM_CAP_HLT:
+		case KVM_CAP_MMU_SHADOW_CACHE_CONTROL:
 			r = 1;
 			break;
 		default:
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 72757db..6cda1fe 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -747,6 +747,40 @@ static void kvm_mmu_zap_page(struct kvm *kvm,
 	kvm_mmu_reset_last_pte_updated(kvm);
 }
 
+/*
+ * Changing the number of mmu pages allocated to the vm
+ * Note: if kvm_nr_mmu_pages is too small, you will get dead lock
+ */
+void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
+{
+	/*
+	 * If we set the number of mmu pages to be smaller be than the
+	 * number of actived pages , we must to free some mmu pages before we
+	 * change the value
+	 */
+
+	if ((kvm->n_alloc_mmu_pages - kvm->n_free_mmu_pages) >
+	    kvm_nr_mmu_pages) {
+		int n_used_mmu_pages = kvm->n_alloc_mmu_pages
+				       - kvm->n_free_mmu_pages;
+
+		while (n_used_mmu_pages > kvm_nr_mmu_pages) {
+			struct kvm_mmu_page *page;
+
+			page = container_of(kvm->active_mmu_pages.prev,
+					    struct kvm_mmu_page, link);
+			kvm_mmu_zap_page(kvm, page);
+			n_used_mmu_pages--;
+		}
+		kvm->n_free_mmu_pages = 0;
+	}
+	else
+		kvm->n_free_mmu_pages += kvm_nr_mmu_pages
+					 - kvm->n_alloc_mmu_pages;
+
+	kvm->n_alloc_mmu_pages = kvm_nr_mmu_pages;
+}
+
 static int kvm_mmu_unprotect_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	unsigned index;
@@ -1297,8 +1331,10 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 
 	ASSERT(vcpu);
 
-	vcpu->kvm->n_free_mmu_pages = KVM_NUM_MMU_PAGES;
-
+	if (vcpu->kvm->n_requested_mmu_pages)
+		vcpu->kvm->n_free_mmu_pages = vcpu->kvm->n_requested_mmu_pages;
+	else
+		vcpu->kvm->n_free_mmu_pages = vcpu->kvm->n_alloc_mmu_pages;
 	/*
 	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
 	 * Therefore we need to allocate shadow page tables in the first
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 057a7f3..d2fd973 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -347,11 +347,14 @@ struct kvm_signal_mask {
  */
 #define KVM_CAP_IRQCHIP	  0
 #define KVM_CAP_HLT	  1
+#define KVM_CAP_MMU_SHADOW_CACHE_CONTROL 2
 
 /*
  * ioctls for VM fds
  */
 #define KVM_SET_MEMORY_REGION     _IOW(KVMIO, 0x40, struct kvm_memory_region)
+#define KVM_SET_NR_MMU_PAGES      _IO(KVMIO, 0x44)
+#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO, 0x45)
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
-- 
1.5.3.7

