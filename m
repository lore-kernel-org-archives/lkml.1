Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbYAAPhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbYAAPhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYAAPgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:25 -0500
Received: from il.qumranet.com ([82.166.9.18]:33762 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbYAAPgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:23 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 02/54] KVM: Remove gpa_to_hpa()
Date: Tue,  1 Jan 2008 17:35:28 +0200
Message-Id: <1199201780-14001-3-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting last uses along the way.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    1 -
 drivers/kvm/mmu.c |   21 +++------------------
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 31315bc..1fd8158 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -375,7 +375,6 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 		  struct module *module);
 void kvm_exit(void);
 
-hpa_t gpa_to_hpa(struct kvm *kvm, gpa_t gpa);
 #define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
 #define HPA_ERR_MASK ((hpa_t)1 << HPA_MSB)
 static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 6aa0319..9b75b10 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -868,26 +868,13 @@ static void page_header_update_slot(struct kvm *kvm, void *pte, gfn_t gfn)
 	__set_bit(slot, &page_head->slot_bitmap);
 }
 
-hpa_t gpa_to_hpa(struct kvm *kvm, gpa_t gpa)
-{
-	struct page *page;
-	hpa_t hpa;
-
-	ASSERT((gpa & HPA_ERR_MASK) == 0);
-	page = gfn_to_page(kvm, gpa >> PAGE_SHIFT);
-	hpa = ((hpa_t)page_to_pfn(page) << PAGE_SHIFT) | (gpa & (PAGE_SIZE-1));
-	if (is_error_page(page))
-		return hpa | HPA_ERR_MASK;
-	return hpa;
-}
-
 struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, gva);
 
 	if (gpa == UNMAPPED_GVA)
 		return NULL;
-	return pfn_to_page(gpa_to_hpa(vcpu->kvm, gpa) >> PAGE_SHIFT);
+	return gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
 }
 
 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
@@ -1611,8 +1598,8 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 			audit_mappings_page(vcpu, ent, va, level - 1);
 		} else {
 			gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, va);
-			hpa_t hpa = gpa_to_hpa(vcpu, gpa);
-			struct page *page;
+			struct page *page = gpa_to_page(vcpu, gpa);
+			hpa_t hpa = page_to_phys(page);
 
 			if (is_shadow_present_pte(ent)
 			    && (ent & PT64_BASE_ADDR_MASK) != hpa)
@@ -1625,8 +1612,6 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 				 && !is_error_hpa(hpa))
 				printk(KERN_ERR "audit: (%s) notrap shadow,"
 				       " valid guest gva %lx\n", audit_msg, va);
-			page = pfn_to_page((gpa & PT64_BASE_ADDR_MASK)
-					   >> PAGE_SHIFT);
 			kvm_release_page_clean(page);
 
 		}
-- 
1.5.3.7

