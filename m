Return-Path: <linux-kernel-owner+w=401wt.eu-S932217Ab0AETyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab0AETyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932170Ab0AETxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:53:51 -0500
Received: from kroah.org ([198.145.64.141]:46043 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164Ab0AETxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:53:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 11:49:15 2010
Message-Id: <20100105194915.508413494@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 11:48:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [10/10] Revert: KVM: MMU: do not free active mmu pages in free_mmu_pages()
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
This reverts the commit d2127c8300fb1ec54af56faee17170e7a525326d, which was
the commit f00be0cae4e6ad0a8c7be381c6d9be3586800b3e upstream.

This was done based on comments saying it was causing problems.

Cc: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/kvm/mmu.c  |    8 ++++++++
 virt/kvm/kvm_main.c |    2 --
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1995,6 +1995,14 @@ EXPORT_SYMBOL_GPL(kvm_disable_tdp);
 
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
+	struct kvm_mmu_page *sp;
+
+	while (!list_empty(&vcpu->kvm->arch.active_mmu_pages)) {
+		sp = container_of(vcpu->kvm->arch.active_mmu_pages.next,
+				  struct kvm_mmu_page, link);
+		kvm_mmu_zap_page(vcpu->kvm, sp);
+		cond_resched();
+	}
 	free_page((unsigned long)vcpu->arch.mmu.pae_root);
 }
 
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -406,8 +406,6 @@ static void kvm_destroy_vm(struct kvm *k
 #endif
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
-#else
-	kvm_arch_flush_shadow(kvm);
 #endif
 	kvm_arch_destroy_vm(kvm);
 	mmdrop(mm);


