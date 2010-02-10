Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0BJR1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:27:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/40] KVM: modify alias layout in x86s struct kvm_arch
Date: Wed, 10 Feb 2010 19:22:56 +0200
Message-Id: <1265822589-11155-28-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Have a pointer to an allocated region inside x86's kvm_arch.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    8 ++++++--
 arch/x86/kvm/x86.c              |   21 ++++++++++++++++-----
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fe4df46..7cdcb3d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -370,9 +370,13 @@ struct kvm_mem_alias {
 	gfn_t target_gfn;
 };
 
-struct kvm_arch{
-	int naliases;
+struct kvm_mem_aliases {
 	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
+	int naliases;
+};
+
+struct kvm_arch {
+	struct kvm_mem_aliases *aliases;
 
 	unsigned int n_free_mmu_pages;
 	unsigned int n_requested_mmu_pages;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f8e2712..6a3593f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2228,9 +2228,10 @@ gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
 	struct kvm_mem_alias *alias;
+	struct kvm_mem_aliases *aliases = kvm->arch.aliases;
 
-	for (i = 0; i < kvm->arch.naliases; ++i) {
-		alias = &kvm->arch.aliases[i];
+	for (i = 0; i < aliases->naliases; ++i) {
+		alias = &aliases->aliases[i];
 		if (gfn >= alias->base_gfn
 		    && gfn < alias->base_gfn + alias->npages)
 			return alias->target_gfn + gfn - alias->base_gfn;
@@ -2248,6 +2249,7 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 {
 	int r, n;
 	struct kvm_mem_alias *p;
+	struct kvm_mem_aliases *aliases;
 
 	r = -EINVAL;
 	/* General sanity checks */
@@ -2267,15 +2269,17 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 	down_write(&kvm->slots_lock);
 	spin_lock(&kvm->mmu_lock);
 
-	p = &kvm->arch.aliases[alias->slot];
+	aliases = kvm->arch.aliases;
+
+	p = &aliases->aliases[alias->slot];
 	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
 	p->npages = alias->memory_size >> PAGE_SHIFT;
 	p->target_gfn = alias->target_phys_addr >> PAGE_SHIFT;
 
 	for (n = KVM_ALIAS_SLOTS; n > 0; --n)
-		if (kvm->arch.aliases[n - 1].npages)
+		if (aliases->aliases[n - 1].npages)
 			break;
-	kvm->arch.naliases = n;
+	aliases->naliases = n;
 
 	spin_unlock(&kvm->mmu_lock);
 	kvm_mmu_zap_all(kvm);
@@ -5159,6 +5163,12 @@ struct  kvm *kvm_arch_create_vm(void)
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
 
+	kvm->arch.aliases = kzalloc(sizeof(struct kvm_mem_aliases), GFP_KERNEL);
+	if (!kvm->arch.aliases) {
+		kfree(kvm);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 
@@ -5215,6 +5225,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		put_page(kvm->arch.apic_access_page);
 	if (kvm->arch.ept_identity_pagetable)
 		put_page(kvm->arch.ept_identity_pagetable);
+	kfree(kvm->arch.aliases);
 	kfree(kvm);
 }
 
-- 
1.6.5.3

