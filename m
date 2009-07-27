Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZG0ObS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZG0ObS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZG0ObR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:31:17 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:44883 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751992AbZG0ObO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:31:14 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNG2ZI-03-X0I-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 4/7] kvm/mmu: make page walker aware of mapping levels
Date: Mon, 27 Jul 2009 16:30:45 +0200
Message-ID: <1248705048-22607-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
References: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Jul 2009 14:30:50.0817 (UTC) FILETIME=[D7137310:01CA0EC6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page walker may be used with nested paging too when accessing mmio
areas.  Make it support the additional page-level too.

[ Marcelo: fix reserved bit check for 1gb pte ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/mmu.c         |   17 +++++++++++++-
 arch/x86/kvm/paging_tmpl.h |   52 +++++++++++++++++++++++--------------------
 2 files changed, 44 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ffea432..9ba0acb 100644
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
 
@@ -2247,7 +2260,9 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
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
1.6.3.3


