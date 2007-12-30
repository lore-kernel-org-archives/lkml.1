Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbXL3HZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbXL3HZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbXL3HLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:35 -0500
Received: from il.qumranet.com ([82.166.9.18]:59493 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600AbXL3HKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:50 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 40/52] KVM: MMU: Implement guest page fault bypass for nonpae
Date: Sun, 30 Dec 2007 09:10:26 +0200
Message-Id: <1198998638-22713-41-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I spent an hour worrying why I see so many guest page faults on FC6 i386.
Turns out bypass wasn't implemented for nonpae.  Implement it so it doesn't
happen again.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index bf15d12..92b9313 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -486,19 +486,22 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr)
 static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 				 struct kvm_mmu_page *sp)
 {
-	int i;
+	int i, offset = 0;
 	pt_element_t *gpt;
 	struct page *page;
 
-	if (sp->role.metaphysical || PTTYPE == 32) {
+	if (sp->role.metaphysical
+	    || (PTTYPE == 32 && sp->role.level > PT_PAGE_TABLE_LEVEL)) {
 		nonpaging_prefetch_page(vcpu, sp);
 		return;
 	}
 
+	if (PTTYPE == 32)
+		offset = sp->role.quadrant << PT64_LEVEL_BITS;
 	page = gfn_to_page(vcpu->kvm, sp->gfn);
 	gpt = kmap_atomic(page, KM_USER0);
 	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
-		if (is_present_pte(gpt[i]))
+		if (is_present_pte(gpt[offset + i]))
 			sp->spt[i] = shadow_trap_nonpresent_pte;
 		else
 			sp->spt[i] = shadow_notrap_nonpresent_pte;
-- 
1.5.3.7

