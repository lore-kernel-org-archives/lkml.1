Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbZEXP7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbZEXP7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758468AbZEXPyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:54:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41835 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbZEXPud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:33 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 26/45] KVM: MMU: protect kvm_mmu_change_mmu_pages with mmu_lock
Date: Sun, 24 May 2009 18:50:11 +0300
Message-Id: <1243180230-2480-27-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

kvm_handle_hva, called by MMU notifiers, manipulates mmu data only with
the protection of mmu_lock.

Update kvm_mmu_change_mmu_pages callers to take mmu_lock, thus protecting
against kvm_handle_hva.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    2 --
 arch/x86/kvm/x86.c |    6 ++++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8fcdae9..80c76f4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2723,7 +2723,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 {
 	struct kvm_mmu_page *sp;
 
-	spin_lock(&kvm->mmu_lock);
 	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
 		int i;
 		u64 *pt;
@@ -2738,7 +2737,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 				pt[i] &= ~PT_WRITABLE_MASK;
 	}
 	kvm_flush_remote_tlbs(kvm);
-	spin_unlock(&kvm->mmu_lock);
 }
 
 void kvm_mmu_zap_all(struct kvm *kvm)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf97ea0..ecc35c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1621,10 +1621,12 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 		return -EINVAL;
 
 	down_write(&kvm->slots_lock);
+	spin_lock(&kvm->mmu_lock);
 
 	kvm_mmu_change_mmu_pages(kvm, kvm_nr_mmu_pages);
 	kvm->arch.n_requested_mmu_pages = kvm_nr_mmu_pages;
 
+	spin_unlock(&kvm->mmu_lock);
 	up_write(&kvm->slots_lock);
 	return 0;
 }
@@ -1800,7 +1802,9 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 
 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (is_dirty) {
+		spin_lock(&kvm->mmu_lock);
 		kvm_mmu_slot_remove_write_access(kvm, log->slot);
+		spin_unlock(&kvm->mmu_lock);
 		kvm_flush_remote_tlbs(kvm);
 		memslot = &kvm->memslots[log->slot];
 		n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
@@ -4544,12 +4548,14 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 		}
 	}
 
+	spin_lock(&kvm->mmu_lock);
 	if (!kvm->arch.n_requested_mmu_pages) {
 		unsigned int nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);
 		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
 	}
 
 	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
+	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 
 	return 0;
-- 
1.6.0.6

