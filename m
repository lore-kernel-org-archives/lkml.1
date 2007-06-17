Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbXFQJyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbXFQJyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759461AbXFQJpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:10 -0400
Received: from il.qumranet.com ([82.166.9.18]:55176 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759177AbXFQJor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 33/58] KVM: MMU: Simplify fetch() a little bit
Date: Sun, 17 Jun 2007 12:44:14 +0300
Message-Id: <11820734802434-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 183d4ca..e094a8b 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -241,6 +241,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 {
 	hpa_t shadow_addr;
 	int level;
+	u64 *shadow_ent;
 	u64 *prev_shadow_ent = NULL;
 	pt_element_t *guest_ent = walker->ptep;
 
@@ -257,13 +258,13 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 
 	for (; ; level--) {
 		u32 index = SHADOW_PT_INDEX(addr, level);
-		u64 *shadow_ent = ((u64 *)__va(shadow_addr)) + index;
 		struct kvm_mmu_page *shadow_page;
 		u64 shadow_pte;
 		int metaphysical;
 		gfn_t table_gfn;
 		unsigned hugepage_access = 0;
 
+		shadow_ent = ((u64 *)__va(shadow_addr)) + index;
 		if (is_present_pte(*shadow_ent) || is_io_pte(*shadow_ent)) {
 			if (level == PT_PAGE_TABLE_LEVEL)
 				return shadow_ent;
@@ -272,22 +273,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			continue;
 		}
 
-		if (level == PT_PAGE_TABLE_LEVEL) {
-
-			if (walker->level == PT_DIRECTORY_LEVEL) {
-				if (prev_shadow_ent)
-					*prev_shadow_ent |= PT_SHADOW_PS_MARK;
-				FNAME(set_pde)(vcpu, *guest_ent, shadow_ent,
-					       walker->inherited_ar,
-					       walker->gfn);
-			} else {
-				ASSERT(walker->level == PT_PAGE_TABLE_LEVEL);
-				FNAME(set_pte)(vcpu, *guest_ent, shadow_ent,
-					       walker->inherited_ar,
-					       walker->gfn);
-			}
-			return shadow_ent;
-		}
+		if (level == PT_PAGE_TABLE_LEVEL)
+			break;
 
 		if (level - 1 == PT_PAGE_TABLE_LEVEL
 		    && walker->level == PT_DIRECTORY_LEVEL) {
@@ -310,6 +297,19 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		*shadow_ent = shadow_pte;
 		prev_shadow_ent = shadow_ent;
 	}
+
+	if (walker->level == PT_DIRECTORY_LEVEL) {
+		if (prev_shadow_ent)
+			*prev_shadow_ent |= PT_SHADOW_PS_MARK;
+		FNAME(set_pde)(vcpu, *guest_ent, shadow_ent,
+			       walker->inherited_ar, walker->gfn);
+	} else {
+		ASSERT(walker->level == PT_PAGE_TABLE_LEVEL);
+		FNAME(set_pte)(vcpu, *guest_ent, shadow_ent,
+			       walker->inherited_ar,
+			       walker->gfn);
+	}
+	return shadow_ent;
 }
 
 /*
-- 
1.5.0.6

