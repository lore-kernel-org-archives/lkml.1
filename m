Return-Path: <linux-kernel-owner+w=401wt.eu-S1758410AbXLWPAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbXLWPAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXLWOwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:08 -0500
Received: from il.qumranet.com ([82.166.9.18]:35909 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbXLWOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH 29/50] KVM: MMU: Clean up MMU functions to take struct kvm when appropriate
Date: Sun, 23 Dec 2007 16:51:14 +0200
Message-Id: <1198421495-31481-30-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

Some of the MMU functions take a struct kvm_vcpu even though they affect all
VCPUs.  This patch cleans up some of them to instead take a struct kvm.  This
makes things a bit more clear.

The main thing that was confusing me was whether certain functions need to be
called on all VCPUs.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |   18 +++++++++---------
 drivers/kvm/paging_tmpl.h |    4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index ece0aa4..a5ca945 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -606,7 +606,7 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *page,
 	BUG();
 }
 
-static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm_vcpu *vcpu,
+static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm,
 						gfn_t gfn)
 {
 	unsigned index;
@@ -616,7 +616,7 @@ static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm_vcpu *vcpu,
 
 	pgprintk("%s: looking for gfn %lx\n", __FUNCTION__, gfn);
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
-	bucket = &vcpu->kvm->mmu_page_hash[index];
+	bucket = &kvm->mmu_page_hash[index];
 	hlist_for_each_entry(page, node, bucket, hash_link)
 		if (page->gfn == gfn && !page->role.metaphysical) {
 			pgprintk("%s: found role %x\n",
@@ -782,7 +782,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 	kvm->n_alloc_mmu_pages = kvm_nr_mmu_pages;
 }
 
-static int kvm_mmu_unprotect_page(struct kvm_vcpu *vcpu, gfn_t gfn)
+static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 {
 	unsigned index;
 	struct hlist_head *bucket;
@@ -793,25 +793,25 @@ static int kvm_mmu_unprotect_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 	pgprintk("%s: looking for gfn %lx\n", __FUNCTION__, gfn);
 	r = 0;
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
-	bucket = &vcpu->kvm->mmu_page_hash[index];
+	bucket = &kvm->mmu_page_hash[index];
 	hlist_for_each_entry_safe(page, node, n, bucket, hash_link)
 		if (page->gfn == gfn && !page->role.metaphysical) {
 			pgprintk("%s: gfn %lx role %x\n", __FUNCTION__, gfn,
 				 page->role.word);
-			kvm_mmu_zap_page(vcpu->kvm, page);
+			kvm_mmu_zap_page(kvm, page);
 			r = 1;
 		}
 	return r;
 }
 
-static void mmu_unshadow(struct kvm_vcpu *vcpu, gfn_t gfn)
+static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_mmu_page *page;
 
-	while ((page = kvm_mmu_lookup_page(vcpu, gfn)) != NULL) {
+	while ((page = kvm_mmu_lookup_page(kvm, gfn)) != NULL) {
 		pgprintk("%s: zap %lx %x\n",
 			 __FUNCTION__, gfn, page->role.word);
-		kvm_mmu_zap_page(vcpu->kvm, page);
+		kvm_mmu_zap_page(kvm, page);
 	}
 }
 
@@ -1299,7 +1299,7 @@ int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, gva);
 
-	return kvm_mmu_unprotect_page(vcpu, gpa >> PAGE_SHIFT);
+	return kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
 }
 
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 447d2c3..4f6edf8 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -268,11 +268,11 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 
 		spte |= PT_WRITABLE_MASK;
 		if (user_fault) {
-			mmu_unshadow(vcpu, gfn);
+			mmu_unshadow(vcpu->kvm, gfn);
 			goto unshadowed;
 		}
 
-		shadow = kvm_mmu_lookup_page(vcpu, gfn);
+		shadow = kvm_mmu_lookup_page(vcpu->kvm, gfn);
 		if (shadow) {
 			pgprintk("%s: found shadow page for %lx, marking ro\n",
 				 __FUNCTION__, gfn);
-- 
1.5.3.7

