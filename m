Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab0BJRYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:24:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794Ab0BJRXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 33/40] KVM: x86: switch kvm_set_memory_alias to SRCU update
Date: Wed, 10 Feb 2010 19:23:02 +0200
Message-Id: <1265822589-11155-34-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Using a similar two-step procedure as for memslots.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    4 ++
 arch/x86/kvm/x86.c              |   60 +++++++++++++++++++++++++++++++++------
 include/linux/kvm_host.h        |    6 ++++
 virt/kvm/kvm_main.c             |    4 +-
 4 files changed, 63 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7cdcb3d..6c8c7c5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -368,8 +368,12 @@ struct kvm_mem_alias {
 	gfn_t base_gfn;
 	unsigned long npages;
 	gfn_t target_gfn;
+#define KVM_ALIAS_INVALID     1UL
+	unsigned long flags;
 };
 
+#define KVM_ARCH_HAS_UNALIAS_INSTANTIATION
+
 struct kvm_mem_aliases {
 	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
 	int naliases;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d7c040..59f4da4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -38,6 +38,7 @@
 #include <linux/intel-iommu.h>
 #include <linux/cpufreq.h>
 #include <linux/user-return-notifier.h>
+#include <linux/srcu.h>
 #include <trace/events/kvm.h>
 #undef TRACE_INCLUDE_FILE
 #define CREATE_TRACE_POINTS
@@ -2224,11 +2225,32 @@ static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
 	return kvm->arch.n_alloc_mmu_pages;
 }
 
+gfn_t unalias_gfn_instantiation(struct kvm *kvm, gfn_t gfn)
+{
+	int i;
+	struct kvm_mem_alias *alias;
+	struct kvm_mem_aliases *aliases;
+
+	aliases = rcu_dereference(kvm->arch.aliases);
+
+	for (i = 0; i < aliases->naliases; ++i) {
+		alias = &aliases->aliases[i];
+		if (alias->flags & KVM_ALIAS_INVALID)
+			continue;
+		if (gfn >= alias->base_gfn
+		    && gfn < alias->base_gfn + alias->npages)
+			return alias->target_gfn + gfn - alias->base_gfn;
+	}
+	return gfn;
+}
+
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
 	struct kvm_mem_alias *alias;
-	struct kvm_mem_aliases *aliases = kvm->arch.aliases;
+	struct kvm_mem_aliases *aliases;
+
+	aliases = rcu_dereference(kvm->arch.aliases);
 
 	for (i = 0; i < aliases->naliases; ++i) {
 		alias = &aliases->aliases[i];
@@ -2249,7 +2271,7 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 {
 	int r, n;
 	struct kvm_mem_alias *p;
-	struct kvm_mem_aliases *aliases;
+	struct kvm_mem_aliases *aliases, *old_aliases;
 
 	r = -EINVAL;
 	/* General sanity checks */
@@ -2266,28 +2288,48 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 	    < alias->target_phys_addr)
 		goto out;
 
+	r = -ENOMEM;
+	aliases = kzalloc(sizeof(struct kvm_mem_aliases), GFP_KERNEL);
+	if (!aliases)
+		goto out;
+
 	down_write(&kvm->slots_lock);
-	spin_lock(&kvm->mmu_lock);
 
-	aliases = kvm->arch.aliases;
+	/* invalidate any gfn reference in case of deletion/shrinking */
+	memcpy(aliases, kvm->arch.aliases, sizeof(struct kvm_mem_aliases));
+	aliases->aliases[alias->slot].flags |= KVM_ALIAS_INVALID;
+	old_aliases = kvm->arch.aliases;
+	rcu_assign_pointer(kvm->arch.aliases, aliases);
+	synchronize_srcu_expedited(&kvm->srcu);
+	kvm_mmu_zap_all(kvm);
+	kfree(old_aliases);
+
+	r = -ENOMEM;
+	aliases = kzalloc(sizeof(struct kvm_mem_aliases), GFP_KERNEL);
+	if (!aliases)
+		goto out_unlock;
+
+	memcpy(aliases, kvm->arch.aliases, sizeof(struct kvm_mem_aliases));
 
 	p = &aliases->aliases[alias->slot];
 	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
 	p->npages = alias->memory_size >> PAGE_SHIFT;
 	p->target_gfn = alias->target_phys_addr >> PAGE_SHIFT;
+	p->flags &= ~(KVM_ALIAS_INVALID);
 
 	for (n = KVM_ALIAS_SLOTS; n > 0; --n)
 		if (aliases->aliases[n - 1].npages)
 			break;
 	aliases->naliases = n;
 
-	spin_unlock(&kvm->mmu_lock);
-	kvm_mmu_zap_all(kvm);
+	old_aliases = kvm->arch.aliases;
+	rcu_assign_pointer(kvm->arch.aliases, aliases);
+	synchronize_srcu_expedited(&kvm->srcu);
+	kfree(old_aliases);
+	r = 0;
 
+out_unlock:
 	up_write(&kvm->slots_lock);
-
-	return 0;
-
 out:
 	return r;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 93bd307..20941c0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -266,6 +266,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 void kvm_disable_largepages(void);
 void kvm_arch_flush_shadow(struct kvm *kvm);
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
+gfn_t unalias_gfn_instantiation(struct kvm *kvm, gfn_t gfn);
+
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
 void kvm_release_page_clean(struct page *page);
@@ -539,6 +541,10 @@ static inline int mmu_notifier_retry(struct kvm_vcpu *vcpu, unsigned long mmu_se
 }
 #endif
 
+#ifndef KVM_ARCH_HAS_UNALIAS_INSTANTIATION
+#define unalias_gfn_instantiation unalias_gfn
+#endif
+
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
 
 #define KVM_MAX_IRQ_ROUTES 1024
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2bb24a8..c680f7b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -859,7 +859,7 @@ int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 	int i;
 	struct kvm_memslots *slots = rcu_dereference(kvm->memslots);
 
-	gfn = unalias_gfn(kvm, gfn);
+	gfn = unalias_gfn_instantiation(kvm, gfn);
 	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
 		struct kvm_memory_slot *memslot = &slots->memslots[i];
 
@@ -896,7 +896,7 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
 
-	gfn = unalias_gfn(kvm, gfn);
+	gfn = unalias_gfn_instantiation(kvm, gfn);
 	slot = gfn_to_memslot_unaliased(kvm, gfn);
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return bad_hva();
-- 
1.6.5.3

