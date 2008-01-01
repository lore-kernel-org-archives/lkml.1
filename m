Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbYAAPxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbYAAPxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbYAAPhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:10 -0500
Received: from il.qumranet.com ([82.166.9.18]:33788 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbYAAPga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:30 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 45/54] KVM: MMU: Fix inherited permissions for emulated guest pte updates
Date: Tue,  1 Jan 2008 17:36:11 +0200
Message-Id: <1199201780-14001-46-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we emulate a guest pte write, we fail to apply the correct inherited
permissions from the parent ptes.  Now that we store inherited permissions
in the shadow page, we can use that to update the pte permissions correctly.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    4 ++--
 drivers/kvm/mmu.c         |    4 ++--
 drivers/kvm/paging_tmpl.h |    4 +++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 0d3555b..ceefb44 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -55,7 +55,7 @@ struct kvm_pte_chain {
  *   bits 4:7 - page table level for this shadow (1-4)
  *   bits 8:9 - page table quadrant for 2-level guests
  *   bit   16 - "metaphysical" - gfn is not a real page (huge page/real mode)
- *   bits 17:19 - "access" - the user, writable, and nx bits of a huge page pde
+ *   bits 17:19 - common access permissions for all ptes in this shadow page
  */
 union kvm_mmu_page_role {
 	unsigned word;
@@ -65,7 +65,7 @@ union kvm_mmu_page_role {
 		unsigned quadrant : 2;
 		unsigned pad_for_nice_hex_output : 6;
 		unsigned metaphysical : 1;
-		unsigned hugepage_access : 3;
+		unsigned access : 3;
 	};
 };
 
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index f8a2137..cace1e4 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -680,7 +680,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gva_t gaddr,
 					     unsigned level,
 					     int metaphysical,
-					     unsigned hugepage_access,
+					     unsigned access,
 					     u64 *parent_pte)
 {
 	union kvm_mmu_page_role role;
@@ -694,7 +694,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	role.glevels = vcpu->mmu.root_level;
 	role.level = level;
 	role.metaphysical = metaphysical;
-	role.hugepage_access = hugepage_access;
+	role.access = access;
 	if (vcpu->mmu.root_level <= PT32_ROOT_LEVEL) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 1fc4f9b..211fef8 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -327,6 +327,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 			      int offset_in_pte)
 {
 	pt_element_t gpte;
+	unsigned pte_access;
 
 	gpte = *(const pt_element_t *)pte;
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
@@ -337,7 +338,8 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	if (bytes < sizeof(pt_element_t))
 		return;
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
-	FNAME(set_pte)(vcpu, gpte, spte, ACC_ALL, ACC_ALL,
+	pte_access = page->role.access & FNAME(gpte_access)(vcpu, gpte);
+	FNAME(set_pte)(vcpu, gpte, spte, page->role.access, pte_access,
 		       0, 0, NULL, NULL, gpte_to_gfn(gpte));
 }
 
-- 
1.5.3.7

