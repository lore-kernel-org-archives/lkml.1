Return-Path: <linux-kernel-owner+w=401wt.eu-S933607AbZHWL5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbZHWL5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933511AbZHWL5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:57:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933568AbZHWL4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:51 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 43/46] KVM: MMU: make page walker aware of mapping levels
Date: Sun, 23 Aug 2009 14:56:42 +0300
Message-Id: <1251028605-31977-44-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The page walker may be used with nested paging too when accessing mmio
areas.  Make it support the additional page-level too.

[ Marcelo: fix reserved bit check for 1gb pte ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c         |   17 +++++++++++++-
 arch/x86/kvm/paging_tmpl.h |   52 +++++++++++++++++++++++--------------------
 2 files changed, 44 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 110c224..09ab643 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -108,6 +108,9 @@ module_param(oos_shadow, bool, 0644);
 
 #define PT32_LEVEL_MASK(level) \
 		(((1ULL << PT32_LEVEL_BITS) - 1) << PT32_LEVEL_SHIFT(level))
+#define PT32_LVL_OFFSET_MASK(level) \
+	(PT32_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT32_LEVEL_BITS))) - 1))
 
 #define PT32_INDEX(address, level)\
 	(((address) >> PT32_LEVEL_SHIFT(level)) & ((1 << PT32_LEVEL_BITS) - 1))
@@ -116,10 +119,19 @@ module_param(oos_shadow, bool, 0644);
 #define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #define PT64_DIR_BASE_ADDR_MASK \
 	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + PT64_LEVEL_BITS)) - 1))
+#define PT64_LVL_ADDR_MASK(level) \
+	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
+#define PT64_LVL_OFFSET_MASK(level) \
+	(PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
 
 #define PT32_BASE_ADDR_MASK PAGE_MASK
 #define PT32_DIR_BASE_ADDR_MASK \
 	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
+#define PT32_LVL_ADDR_MASK(level) \
+	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
+					    * PT32_LEVEL_BITS))) - 1))
 
 #define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK \
 			| PT64_NX_MASK)
@@ -130,6 +142,7 @@ module_param(oos_shadow, bool, 0644);
 #define PFERR_RSVD_MASK (1U << 3)
 #define PFERR_FETCH_MASK (1U << 4)
 
+#define PT_PDPE_LEVEL 3
 #define PT_DIRECTORY_LEVEL 2
 #define PT_PAGE_TABLE_LEVEL 1
 
@@ -2273,7 +2286,9 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
 		context->rsvd_bits_mask[0][0] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51);
 		context->rsvd_bits_mask[1][3] = context->rsvd_bits_mask[0][3];
-		context->rsvd_bits_mask[1][2] = context->rsvd_bits_mask[0][2];
+		context->rsvd_bits_mask[1][2] = exb_bit_rsvd |
+			rsvd_bits(maxphyaddr, 51) |
+			rsvd_bits(13, 29);
 		context->rsvd_bits_mask[1][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51) |
 			rsvd_bits(13, 20);		/* large page */
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index b167f0d..578276e 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -27,7 +27,8 @@
 	#define guest_walker guest_walker64
 	#define FNAME(name) paging##64_##name
 	#define PT_BASE_ADDR_MASK PT64_BASE_ADDR_MASK
-	#define PT_DIR_BASE_ADDR_MASK PT64_DIR_BASE_ADDR_MASK
+	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
+	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
 	#define PT_LEVEL_MASK(level) PT64_LEVEL_MASK(level)
 	#define PT_LEVEL_BITS PT64_LEVEL_BITS
@@ -43,7 +44,8 @@
 	#define guest_walker guest_walker32
 	#define FNAME(name) paging##32_##name
 	#define PT_BASE_ADDR_MASK PT32_BASE_ADDR_MASK
-	#define PT_DIR_BASE_ADDR_MASK PT32_DIR_BASE_ADDR_MASK
+	#define PT_LVL_ADDR_MASK(lvl) PT32_LVL_ADDR_MASK(lvl)
+	#define PT_LVL_OFFSET_MASK(lvl) PT32_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT32_INDEX(addr, level)
 	#define PT_LEVEL_MASK(level) PT32_LEVEL_MASK(level)
 	#define PT_LEVEL_BITS PT32_LEVEL_BITS
@@ -53,8 +55,8 @@
 	#error Invalid PTTYPE value
 #endif
 
-#define gpte_to_gfn FNAME(gpte_to_gfn)
-#define gpte_to_gfn_pde FNAME(gpte_to_gfn_pde)
+#define gpte_to_gfn_lvl FNAME(gpte_to_gfn_lvl)
+#define gpte_to_gfn(pte) gpte_to_gfn_lvl((pte), PT_PAGE_TABLE_LEVEL)
 
 /*
  * The guest_walker structure emulates the behavior of the hardware page
@@ -71,14 +73,9 @@ struct guest_walker {
 	u32 error_code;
 };
 
-static gfn_t gpte_to_gfn(pt_element_t gpte)
+static gfn_t gpte_to_gfn_lvl(pt_element_t gpte, int lvl)
 {
-	return (gpte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
-}
-
-static gfn_t gpte_to_gfn_pde(pt_element_t gpte)
-{
-	return (gpte & PT_DIR_BASE_ADDR_MASK) >> PAGE_SHIFT;
+	return (gpte & PT_LVL_ADDR_MASK(lvl)) >> PAGE_SHIFT;
 }
 
 static bool FNAME(cmpxchg_gpte)(struct kvm *kvm,
@@ -189,18 +186,24 @@ walk:
 
 		walker->ptes[walker->level - 1] = pte;
 
-		if (walker->level == PT_PAGE_TABLE_LEVEL) {
-			walker->gfn = gpte_to_gfn(pte);
-			break;
-		}
-
-		if (walker->level == PT_DIRECTORY_LEVEL
-		    && (pte & PT_PAGE_SIZE_MASK)
-		    && (PTTYPE == 64 || is_pse(vcpu))) {
-			walker->gfn = gpte_to_gfn_pde(pte);
-			walker->gfn += PT_INDEX(addr, PT_PAGE_TABLE_LEVEL);
-			if (PTTYPE == 32 && is_cpuid_PSE36())
+		if ((walker->level == PT_PAGE_TABLE_LEVEL) ||
+		    ((walker->level == PT_DIRECTORY_LEVEL) &&
+				(pte & PT_PAGE_SIZE_MASK)  &&
+				(PTTYPE == 64 || is_pse(vcpu))) ||
+		    ((walker->level == PT_PDPE_LEVEL) &&
+				(pte & PT_PAGE_SIZE_MASK)  &&
+				is_long_mode(vcpu))) {
+			int lvl = walker->level;
+
+			walker->gfn = gpte_to_gfn_lvl(pte, lvl);
+			walker->gfn += (addr & PT_LVL_OFFSET_MASK(lvl))
+					>> PAGE_SHIFT;
+
+			if (PTTYPE == 32 &&
+			    walker->level == PT_DIRECTORY_LEVEL &&
+			    is_cpuid_PSE36())
 				walker->gfn += pse36_gfn_delta(pte);
+
 			break;
 		}
 
@@ -609,9 +612,10 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 #undef PT_BASE_ADDR_MASK
 #undef PT_INDEX
 #undef PT_LEVEL_MASK
-#undef PT_DIR_BASE_ADDR_MASK
+#undef PT_LVL_ADDR_MASK
+#undef PT_LVL_OFFSET_MASK
 #undef PT_LEVEL_BITS
 #undef PT_MAX_FULL_LEVELS
 #undef gpte_to_gfn
-#undef gpte_to_gfn_pde
+#undef gpte_to_gfn_lvl
 #undef CMPXCHG
-- 
1.6.4.1

