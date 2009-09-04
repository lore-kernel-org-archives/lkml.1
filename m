Return-Path: <linux-kernel-owner+w=401wt.eu-S934126AbZIDUOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126AbZIDUOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934082AbZIDUOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:44 -0400
Received: from kroah.org ([198.145.64.141]:36242 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934076AbZIDUOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:55 2009
Message-Id: <20090904200855.017632732@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [patch 32/48] KVM: MMU: protect kvm_mmu_change_mmu_pages with mmu_lock
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-protect-kvm_mmu_change_mmu_pages-with-mmu_lock.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit 7c8a83b75a38a807d37f5a4398eca2a42c8cf513)

kvm_handle_hva, called by MMU notifiers, manipulates mmu data only with
the protection of mmu_lock.

Update kvm_mmu_change_mmu_pages callers to take mmu_lock, thus protecting
against kvm_handle_hva.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c |    2 --
 arch/x86/kvm/x86.c |    6 ++++++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2059,7 +2059,6 @@ void kvm_mmu_slot_remove_write_access(st
 {
 	struct kvm_mmu_page *sp;
 
-	spin_lock(&kvm->mmu_lock);
 	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
 		int i;
 		u64 *pt;
@@ -2074,7 +2073,6 @@ void kvm_mmu_slot_remove_write_access(st
 				pt[i] &= ~PT_WRITABLE_MASK;
 	}
 	kvm_flush_remote_tlbs(kvm);
-	spin_unlock(&kvm->mmu_lock);
 }
 
 void kvm_mmu_zap_all(struct kvm *kvm)
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1454,10 +1454,12 @@ static int kvm_vm_ioctl_set_nr_mmu_pages
 		return -EINVAL;
 
 	down_write(&kvm->slots_lock);
+	spin_lock(&kvm->mmu_lock);
 
 	kvm_mmu_change_mmu_pages(kvm, kvm_nr_mmu_pages);
 	kvm->arch.n_requested_mmu_pages = kvm_nr_mmu_pages;
 
+	spin_unlock(&kvm->mmu_lock);
 	up_write(&kvm->slots_lock);
 	return 0;
 }
@@ -1624,7 +1626,9 @@ int kvm_vm_ioctl_get_dirty_log(struct kv
 
 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (is_dirty) {
+		spin_lock(&kvm->mmu_lock);
 		kvm_mmu_slot_remove_write_access(kvm, log->slot);
+		spin_unlock(&kvm->mmu_lock);
 		kvm_flush_remote_tlbs(kvm);
 		memslot = &kvm->memslots[log->slot];
 		n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
@@ -4059,12 +4063,14 @@ int kvm_arch_set_memory_region(struct kv
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


