Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbXL3HXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbXL3HXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbXL3HL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:29 -0500
Received: from il.qumranet.com ([82.166.9.18]:59488 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743AbXL3HKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:51 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 46/52] KVM: MMU: Move pse36 handling to the guest walker
Date: Sun, 30 Dec 2007 09:10:32 +0200
Message-Id: <1198998638-22713-47-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |    7 +++++++
 drivers/kvm/paging_tmpl.h |    5 ++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 346aa65..a9fed59 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -218,6 +218,13 @@ static int is_rmap_pte(u64 pte)
 		&& pte != shadow_notrap_nonpresent_pte;
 }
 
+static gfn_t pse36_gfn_delta(u32 gpte)
+{
+	int shift = 32 - PT32_DIR_PSE36_SHIFT - PAGE_SHIFT;
+
+	return (gpte & PT32_DIR_PSE36_MASK) << shift;
+}
+
 static void set_shadow_pte(u64 *sptep, u64 spte)
 {
 #ifdef CONFIG_X86_64
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 6f79ae8..dceb4b9 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -149,6 +149,8 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 		    && (PTTYPE == 64 || is_pse(vcpu))) {
 			walker->gfn = gpte_to_gfn_pde(pte);
 			walker->gfn += PT_INDEX(addr, PT_PAGE_TABLE_LEVEL);
+			if (PTTYPE == 32 && is_cpuid_PSE36())
+				walker->gfn += pse36_gfn_delta(pte);
 			break;
 		}
 
@@ -320,9 +322,6 @@ static void FNAME(set_pde)(struct kvm_vcpu *vcpu, pt_element_t gpde,
 
 	access_bits &= gpde;
 	gaddr = (gpa_t)gfn << PAGE_SHIFT;
-	if (PTTYPE == 32 && is_cpuid_PSE36())
-		gaddr |= (gpde & PT32_DIR_PSE36_MASK) <<
-			(32 - PT32_DIR_PSE36_SHIFT);
 	FNAME(set_pte_common)(vcpu, shadow_pte, gaddr,
 			      gpde, access_bits, user_fault, write_fault,
 			      ptwrite, walker, gfn);
-- 
1.5.3.7

