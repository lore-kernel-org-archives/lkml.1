Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0BMIDn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:03:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0BMICH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:07 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 39/39] KVM: rename is_writeble_pte() to is_writable_pte()
Date: Sat, 13 Feb 2010 10:01:59 +0200
Message-Id: <1266048119-14325-40-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

There are two spellings of "writable" in
arch/x86/kvm/mmu.c and paging_tmpl.h .

This patch renames is_writeble_pte() to is_writable_pte()
and makes grepping easy.

  New name is consistent with the definition of itself:
  return pte & PT_WRITABLE_MASK;

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c         |   18 +++++++++---------
 arch/x86/kvm/paging_tmpl.h |    2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 276bf74..ff2b2e8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -250,7 +250,7 @@ static int is_large_pte(u64 pte)
 	return pte & PT_PAGE_SIZE_MASK;
 }
 
-static int is_writeble_pte(unsigned long pte)
+static int is_writable_pte(unsigned long pte)
 {
 	return pte & PT_WRITABLE_MASK;
 }
@@ -632,7 +632,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	pfn = spte_to_pfn(*spte);
 	if (*spte & shadow_accessed_mask)
 		kvm_set_pfn_accessed(pfn);
-	if (is_writeble_pte(*spte))
+	if (is_writable_pte(*spte))
 		kvm_set_pfn_dirty(pfn);
 	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt], sp->role.level);
 	if (!*rmapp) {
@@ -708,7 +708,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 		BUG_ON(!spte);
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
-		if (is_writeble_pte(*spte)) {
+		if (is_writable_pte(*spte)) {
 			__set_spte(spte, *spte & ~PT_WRITABLE_MASK);
 			write_protected = 1;
 		}
@@ -732,7 +732,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 			BUG_ON(!(*spte & PT_PRESENT_MASK));
 			BUG_ON((*spte & (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK)) != (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK));
 			pgprintk("rmap_write_protect(large): spte %p %llx %lld\n", spte, *spte, gfn);
-			if (is_writeble_pte(*spte)) {
+			if (is_writable_pte(*spte)) {
 				rmap_remove(kvm, spte);
 				--kvm->stat.lpages;
 				__set_spte(spte, shadow_trap_nonpresent_pte);
@@ -787,7 +787,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 
 			new_spte &= ~PT_WRITABLE_MASK;
 			new_spte &= ~SPTE_HOST_WRITEABLE;
-			if (is_writeble_pte(*spte))
+			if (is_writable_pte(*spte))
 				kvm_set_pfn_dirty(spte_to_pfn(*spte));
 			__set_spte(spte, new_spte);
 			spte = rmap_next(kvm, rmapp, spte);
@@ -1847,7 +1847,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * is responsibility of mmu_get_page / kvm_sync_page.
 		 * Same reasoning can be applied to dirty page accounting.
 		 */
-		if (!can_unsync && is_writeble_pte(*sptep))
+		if (!can_unsync && is_writable_pte(*sptep))
 			goto set_pte;
 
 		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
@@ -1855,7 +1855,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				 __func__, gfn);
 			ret = 1;
 			pte_access &= ~ACC_WRITE_MASK;
-			if (is_writeble_pte(spte))
+			if (is_writable_pte(spte))
 				spte &= ~PT_WRITABLE_MASK;
 		}
 	}
@@ -1876,7 +1876,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 bool reset_host_protection)
 {
 	int was_rmapped = 0;
-	int was_writeble = is_writeble_pte(*sptep);
+	int was_writable = is_writable_pte(*sptep);
 	int rmap_count;
 
 	pgprintk("%s: spte %llx access %x write_fault %d"
@@ -1927,7 +1927,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
 			rmap_recycle(vcpu, sptep, gfn);
 	} else {
-		if (was_writeble)
+		if (was_writable)
 			kvm_release_pfn_dirty(pfn);
 		else
 			kvm_release_pfn_clean(pfn);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index ede2131..df15a53 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -162,7 +162,7 @@ walk:
 		if (rsvd_fault)
 			goto access_error;
 
-		if (write_fault && !is_writeble_pte(pte))
+		if (write_fault && !is_writable_pte(pte))
 			if (user_fault || is_write_protection(vcpu))
 				goto access_error;
 
-- 
1.6.5.3

