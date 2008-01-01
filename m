Return-Path: <linux-kernel-owner+w=401wt.eu-S1759222AbYAAPwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbYAAPwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbYAAPhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:08 -0500
Received: from il.qumranet.com ([82.166.9.18]:33796 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbYAAPgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:31 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 47/54] KVM: MMU: Pass pte dirty flag to set_pte() instead of calculating it on-site
Date: Tue,  1 Jan 2008 17:36:13 +0200
Message-Id: <1199201780-14001-48-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to remove its dependency on pt_element_t.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 179ce9e..ca8d515 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -235,14 +235,12 @@ err:
 	return 0;
 }
 
-static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
-			   u64 *shadow_pte, unsigned pt_access,
-			   unsigned pte_access,
-			   int user_fault, int write_fault,
+static void FNAME(set_pte)(struct kvm_vcpu *vcpu, u64 *shadow_pte,
+			   unsigned pt_access, unsigned pte_access,
+			   int user_fault, int write_fault, int dirty,
 			   int *ptwrite, struct guest_walker *walker,
 			   gfn_t gfn)
 {
-	int dirty = gpte & PT_DIRTY_MASK;
 	u64 spte;
 	int was_rmapped = is_rmap_pte(*shadow_pte);
 	struct page *page;
@@ -338,8 +336,8 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 		return;
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
 	pte_access = page->role.access & FNAME(gpte_access)(vcpu, gpte);
-	FNAME(set_pte)(vcpu, gpte, spte, page->role.access, pte_access,
-		       0, 0, NULL, NULL, gpte_to_gfn(gpte));
+	FNAME(set_pte)(vcpu, spte, page->role.access, pte_access, 0, 0,
+		       gpte & PT_DIRTY_MASK, NULL, NULL, gpte_to_gfn(gpte));
 }
 
 /*
@@ -402,9 +400,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		*shadow_ent = shadow_pte;
 	}
 
-	FNAME(set_pte)(vcpu, walker->pte, shadow_ent,
-		       access, walker->pte_access & access,
-		       user_fault, write_fault,
+	FNAME(set_pte)(vcpu, shadow_ent, access, walker->pte_access & access,
+		       user_fault, write_fault, walker->pte & PT_DIRTY_MASK,
 		       ptwrite, walker, walker->gfn);
 
 	return shadow_ent;
-- 
1.5.3.7

