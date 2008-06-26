Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbYFZMlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbYFZMlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYFZM3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:39 -0400
Received: from il.qumranet.com ([212.179.150.194]:32363 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbYFZM2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/50] KVM: MMU: Optimize prefetch_page()
Date: Thu, 26 Jun 2008 15:28:10 +0300
Message-Id: <1214483312-9265-29-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reading each pte individually, read 256 bytes worth of ptes and
batch process them.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/paging_tmpl.h |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 934c7b6..4d91822 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -460,8 +460,9 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr)
 static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 				 struct kvm_mmu_page *sp)
 {
-	int i, offset = 0, r = 0;
-	pt_element_t pt;
+	int i, j, offset, r;
+	pt_element_t pt[256 / sizeof(pt_element_t)];
+	gpa_t pte_gpa;
 
 	if (sp->role.metaphysical
 	    || (PTTYPE == 32 && sp->role.level > PT_PAGE_TABLE_LEVEL)) {
@@ -469,19 +470,20 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 		return;
 	}
 
-	if (PTTYPE == 32)
+	pte_gpa = gfn_to_gpa(sp->gfn);
+	if (PTTYPE == 32) {
 		offset = sp->role.quadrant << PT64_LEVEL_BITS;
+		pte_gpa += offset * sizeof(pt_element_t);
+	}
 
-	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-		gpa_t pte_gpa = gfn_to_gpa(sp->gfn);
-		pte_gpa += (i+offset) * sizeof(pt_element_t);
-
-		r = kvm_read_guest_atomic(vcpu->kvm, pte_gpa, &pt,
-					  sizeof(pt_element_t));
-		if (r || is_present_pte(pt))
-			sp->spt[i] = shadow_trap_nonpresent_pte;
-		else
-			sp->spt[i] = shadow_notrap_nonpresent_pte;
+	for (i = 0; i < PT64_ENT_PER_PAGE; i += ARRAY_SIZE(pt)) {
+		r = kvm_read_guest_atomic(vcpu->kvm, pte_gpa, pt, sizeof pt);
+		pte_gpa += ARRAY_SIZE(pt) * sizeof(pt_element_t);
+		for (j = 0; j < ARRAY_SIZE(pt); ++j)
+			if (r || is_present_pte(pt[j]))
+				sp->spt[i+j] = shadow_trap_nonpresent_pte;
+			else
+				sp->spt[i+j] = shadow_notrap_nonpresent_pte;
 	}
 }
 
-- 
1.5.6

