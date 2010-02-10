Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0BJR2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:28:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 32/40] KVM: use SRCU for dirty log
Date: Wed, 10 Feb 2010 19:23:01 +0200
Message-Id: <1265822589-11155-33-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   49 +++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6a795be..2d7c040 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2416,27 +2416,60 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 				      struct kvm_dirty_log *log)
 {
-	int r;
-	int n;
+	int r, n, i;
 	struct kvm_memory_slot *memslot;
-	int is_dirty = 0;
+	unsigned long is_dirty = 0;
+	unsigned long *dirty_bitmap = NULL;
 
 	down_write(&kvm->slots_lock);
 
-	r = kvm_get_dirty_log(kvm, log, &is_dirty);
-	if (r)
+	r = -EINVAL;
+	if (log->slot >= KVM_MEMORY_SLOTS)
+		goto out;
+
+	memslot = &kvm->memslots->memslots[log->slot];
+	r = -ENOENT;
+	if (!memslot->dirty_bitmap)
+		goto out;
+
+	n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
+
+	r = -ENOMEM;
+	dirty_bitmap = vmalloc(n);
+	if (!dirty_bitmap)
 		goto out;
+	memset(dirty_bitmap, 0, n);
+
+	for (i = 0; !is_dirty && i < n/sizeof(long); i++)
+		is_dirty = memslot->dirty_bitmap[i];
 
 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (is_dirty) {
+		struct kvm_memslots *slots, *old_slots;
+
 		spin_lock(&kvm->mmu_lock);
 		kvm_mmu_slot_remove_write_access(kvm, log->slot);
 		spin_unlock(&kvm->mmu_lock);
-		memslot = &kvm->memslots->memslots[log->slot];
-		n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
-		memset(memslot->dirty_bitmap, 0, n);
+
+		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
+		if (!slots)
+			goto out_free;
+
+		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
+		slots->memslots[log->slot].dirty_bitmap = dirty_bitmap;
+
+		old_slots = kvm->memslots;
+		rcu_assign_pointer(kvm->memslots, slots);
+		synchronize_srcu_expedited(&kvm->srcu);
+		dirty_bitmap = old_slots->memslots[log->slot].dirty_bitmap;
+		kfree(old_slots);
 	}
+
 	r = 0;
+	if (copy_to_user(log->dirty_bitmap, dirty_bitmap, n))
+		r = -EFAULT;
+out_free:
+	vfree(dirty_bitmap);
 out:
 	up_write(&kvm->slots_lock);
 	return r;
-- 
1.6.5.3

