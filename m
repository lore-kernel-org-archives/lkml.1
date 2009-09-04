Return-Path: <linux-kernel-owner+w=401wt.eu-S934207AbZIDUSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207AbZIDUSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934065AbZIDUSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:18:33 -0400
Received: from kroah.org ([198.145.64.141]:36227 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934061AbZIDUOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:54 2009
Message-Id: <20090904200854.584125547@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
       Gleb Natapov <gleb@redhat.com>
Subject: [patch 29/48] KVM: MMU: do not free active mmu pages in free_mmu_pages()
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-do-not-free-active-mmu-pages-in-free_mmu_pages.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Gleb Natapov <gleb@redhat.com>

(cherry picked from commit f00be0cae4e6ad0a8c7be381c6d9be3586800b3e)

free_mmu_pages() should only undo what alloc_mmu_pages() does.
Free mmu pages from the generic VM destruction function, kvm_destroy_vm().

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c  |    8 --------
 virt/kvm/kvm_main.c |    2 ++
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1976,14 +1976,6 @@ EXPORT_SYMBOL_GPL(kvm_disable_tdp);
 
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_page *sp;
-
-	while (!list_empty(&vcpu->kvm->arch.active_mmu_pages)) {
-		sp = container_of(vcpu->kvm->arch.active_mmu_pages.next,
-				  struct kvm_mmu_page, link);
-		kvm_mmu_zap_page(vcpu->kvm, sp);
-		cond_resched();
-	}
 	free_page((unsigned long)vcpu->arch.mmu.pae_root);
 }
 
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -406,6 +406,8 @@ static void kvm_destroy_vm(struct kvm *k
 #endif
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
+#else
+	kvm_arch_flush_shadow(kvm);
 #endif
 	kvm_arch_destroy_vm(kvm);
 	mmdrop(mm);


