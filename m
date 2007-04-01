Return-Path: <linux-kernel-owner+w=401wt.eu-S933256AbXDAOkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbXDAOkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933222AbXDAOjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:39:55 -0400
Received: from il.qumranet.com ([82.166.9.18]:47552 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933256AbXDAOfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 31/41] KVM: MMU: Fix hugepage pdes mapping same physical address with different access
Date: Sun,  1 Apr 2007 17:35:28 +0300
Message-Id: <11754381392527-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438139312-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com> <1175438139877-git-send-email-avi@qumranet.com> <11754381391119-git-send-email-avi@qumranet.com> <1175438139312-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The kvm mmu keeps a shadow page for hugepage pdes; if several such pdes map
the same physical address, they share the same shadow page.  This is a fairly
common case (kernel mappings on i386 nonpae Linux, for example).

However, if the two pdes map the same memory but with different permissions, kvm
will happily use the cached shadow page.  If the access through the more
permissive pde will occur after the access to the strict pde, an endless pagefault
loop will be generated and the guest will make no progress.

Fix by making the access permissions part of the cache lookup key.

The fix allows Xen pae to boot on kvm and run guest domains.

Thanks to Jeremy Fitzhardinge for reporting the bug and testing the fix.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    2 ++
 drivers/kvm/mmu.c         |    8 +++++---
 drivers/kvm/paging_tmpl.h |    7 ++++++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 7361c45..f5e343c 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -109,6 +109,7 @@ struct kvm_pte_chain {
  *   bits 4:7 - page table level for this shadow (1-4)
  *   bits 8:9 - page table quadrant for 2-level guests
  *   bit   16 - "metaphysical" - gfn is not a real page (huge page/real mode)
+ *   bits 17:18 - "access" - the user and writable bits of a huge page pde
  */
 union kvm_mmu_page_role {
 	unsigned word;
@@ -118,6 +119,7 @@ union kvm_mmu_page_role {
 		unsigned quadrant : 2;
 		unsigned pad_for_nice_hex_output : 6;
 		unsigned metaphysical : 1;
+		unsigned hugepage_access : 2;
 	};
 };
 
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index b181106..0216b77 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -568,6 +568,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gva_t gaddr,
 					     unsigned level,
 					     int metaphysical,
+					     unsigned hugepage_access,
 					     u64 *parent_pte)
 {
 	union kvm_mmu_page_role role;
@@ -581,6 +582,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	role.glevels = vcpu->mmu.root_level;
 	role.level = level;
 	role.metaphysical = metaphysical;
+	role.hugepage_access = hugepage_access;
 	if (vcpu->mmu.root_level <= PT32_ROOT_LEVEL) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
@@ -780,7 +782,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 				>> PAGE_SHIFT;
 			new_table = kvm_mmu_get_page(vcpu, pseudo_gfn,
 						     v, level - 1,
-						     1, &table[index]);
+						     1, 0, &table[index]);
 			if (!new_table) {
 				pgprintk("nonpaging_map: ENOMEM\n");
 				return -ENOMEM;
@@ -835,7 +837,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 
 		ASSERT(!VALID_PAGE(root));
 		page = kvm_mmu_get_page(vcpu, root_gfn, 0,
-					PT64_ROOT_LEVEL, 0, NULL);
+					PT64_ROOT_LEVEL, 0, 0, NULL);
 		root = page->page_hpa;
 		++page->root_count;
 		vcpu->mmu.root_hpa = root;
@@ -852,7 +854,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 			root_gfn = 0;
 		page = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
 					PT32_ROOT_LEVEL, !is_paging(vcpu),
-					NULL);
+					0, NULL);
 		root = page->page_hpa;
 		++page->root_count;
 		vcpu->mmu.pae_root[i] = root | PT_PRESENT_MASK;
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 17bd440..b94010d 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -247,6 +247,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		u64 shadow_pte;
 		int metaphysical;
 		gfn_t table_gfn;
+		unsigned hugepage_access = 0;
 
 		if (is_present_pte(*shadow_ent) || is_io_pte(*shadow_ent)) {
 			if (level == PT_PAGE_TABLE_LEVEL)
@@ -276,6 +277,9 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		if (level - 1 == PT_PAGE_TABLE_LEVEL
 		    && walker->level == PT_DIRECTORY_LEVEL) {
 			metaphysical = 1;
+			hugepage_access = *guest_ent;
+			hugepage_access &= PT_USER_MASK | PT_WRITABLE_MASK;
+			hugepage_access >>= PT_WRITABLE_SHIFT;
 			table_gfn = (*guest_ent & PT_BASE_ADDR_MASK)
 				>> PAGE_SHIFT;
 		} else {
@@ -283,7 +287,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			table_gfn = walker->table_gfn[level - 2];
 		}
 		shadow_page = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
-					       metaphysical, shadow_ent);
+					       metaphysical, hugepage_access,
+					       shadow_ent);
 		shadow_addr = shadow_page->page_hpa;
 		shadow_pte = shadow_addr | PT_PRESENT_MASK | PT_ACCESSED_MASK
 			| PT_WRITABLE_MASK | PT_USER_MASK;
-- 
1.5.0.5

