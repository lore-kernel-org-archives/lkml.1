Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbXL3H2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbXL3H2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXL3HK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:59 -0500
Received: from il.qumranet.com ([82.166.9.18]:59486 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbXL3HKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 10/52] KVM: Portability: Move kvm_vcpu_ioctl_get_dirty_log to arch-specific  file
Date: Sun, 30 Dec 2007 09:09:56 +0200
Message-Id: <1198998638-22713-11-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Meanwhile keep the interface in common, and leave as more logic in common
as possible.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    5 +++++
 drivers/kvm/kvm_main.c |   19 ++++---------------
 drivers/kvm/x86.c      |   31 +++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index bdcc44e..c1aa84f 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -644,6 +644,11 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
 
 int kvm_dev_ioctl_check_extension(long ext);
 
+int kvm_get_dirty_log(struct kvm *kvm,
+			struct kvm_dirty_log *log, int *is_dirty);
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
+				struct kvm_dirty_log *log);
+
 int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 				   struct
 				   kvm_userspace_memory_region *mem,
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 1c4e950..e64dfa2 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -389,19 +389,14 @@ int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	return kvm_set_memory_region(kvm, mem, user_alloc);
 }
 
-/*
- * Get (and clear) the dirty memory log for a memory slot.
- */
-static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
-				      struct kvm_dirty_log *log)
+int kvm_get_dirty_log(struct kvm *kvm,
+			struct kvm_dirty_log *log, int *is_dirty)
 {
 	struct kvm_memory_slot *memslot;
 	int r, i;
 	int n;
 	unsigned long any = 0;
 
-	mutex_lock(&kvm->lock);
-
 	r = -EINVAL;
 	if (log->slot >= KVM_MEMORY_SLOTS)
 		goto out;
@@ -420,17 +415,11 @@ static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
 		goto out;
 
-	/* If nothing is dirty, don't bother messing with page tables. */
-	if (any) {
-		kvm_mmu_slot_remove_write_access(kvm, log->slot);
-		kvm_flush_remote_tlbs(kvm);
-		memset(memslot->dirty_bitmap, 0, n);
-	}
+	if (any)
+		*is_dirty = 1;
 
 	r = 0;
-
 out:
-	mutex_unlock(&kvm->lock);
 	return r;
 }
 
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 9618fcb..935e276 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -937,6 +937,37 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 	return r;
 }
 
+/*
+ * Get (and clear) the dirty memory log for a memory slot.
+ */
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
+				      struct kvm_dirty_log *log)
+{
+	int r;
+	int n;
+	struct kvm_memory_slot *memslot;
+	int is_dirty = 0;
+
+	mutex_lock(&kvm->lock);
+
+	r = kvm_get_dirty_log(kvm, log, &is_dirty);
+	if (r)
+		goto out;
+
+	/* If nothing is dirty, don't bother messing with page tables. */
+	if (is_dirty) {
+		kvm_mmu_slot_remove_write_access(kvm, log->slot);
+		kvm_flush_remote_tlbs(kvm);
+		memslot = &kvm->memslots[log->slot];
+		n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
+		memset(memslot->dirty_bitmap, 0, n);
+	}
+	r = 0;
+out:
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
-- 
1.5.3.7

