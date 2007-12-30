Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbXL3HXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbXL3HXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbXL3HL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:28 -0500
Received: from il.qumranet.com ([82.166.9.18]:59486 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705AbXL3HKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:51 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 44/52] KVM: MMU: Code cleanup
Date: Sun, 30 Dec 2007 09:10:30 +0200
Message-Id: <1198998638-22713-45-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 92b9313..6e01301 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -187,6 +187,7 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 	int dirty = gpte & PT_DIRTY_MASK;
 	u64 spte;
 	int was_rmapped = is_rmap_pte(*shadow_pte);
+	struct page *page;
 
 	pgprintk("%s: spte %llx gpte %llx access %llx write_fault %d"
 		 " user_fault %d gfn %lx\n",
@@ -205,6 +206,12 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 
 	paddr = gpa_to_hpa(vcpu->kvm, gaddr & PT64_BASE_ADDR_MASK);
 
+	/*
+	 * the reason paddr get mask even that it isnt pte is beacuse the
+	 * HPA_ERR_MASK bit might be used to signal error
+	 */
+	page = pfn_to_page((paddr & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
+
 	spte |= PT_PRESENT_MASK;
 	if (access_bits & PT_USER_MASK)
 		spte |= PT_USER_MASK;
@@ -212,8 +219,7 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 	if (is_error_hpa(paddr)) {
 		set_shadow_pte(shadow_pte,
 			       shadow_trap_nonpresent_pte | PT_SHADOW_IO_MARK);
-		kvm_release_page_clean(pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
-				       >> PAGE_SHIFT));
+		kvm_release_page_clean(page);
 		return;
 	}
 
@@ -254,17 +260,11 @@ unshadowed:
 	if (!was_rmapped) {
 		rmap_add(vcpu, shadow_pte, (gaddr & PT64_BASE_ADDR_MASK)
 			 >> PAGE_SHIFT);
-		if (!is_rmap_pte(*shadow_pte)) {
-			struct page *page;
-
-			page = pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
-					   >> PAGE_SHIFT);
+		if (!is_rmap_pte(*shadow_pte))
 			kvm_release_page_clean(page);
-		}
 	}
 	else
-		kvm_release_page_clean(pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
-				       >> PAGE_SHIFT));
+		kvm_release_page_clean(page);
 	if (!ptwrite || !*ptwrite)
 		vcpu->last_pte_updated = shadow_pte;
 }
-- 
1.5.3.7

