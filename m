Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbZFSNSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbZFSNSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbZFSNQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:16:59 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:20035
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755694AbZFSNQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:16:50 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i17ch62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KLHM7P-02-2UE-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/8] kvm/mmu: add support for another level to page walker
Date: Fri, 19 Jun 2009 15:16:27 +0200
Message-ID: <1245417389-5527-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jun 2009 13:16:38.0771 (UTC) FILETIME=[2DC0A430:01C9F0E0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page walker may be used with nested paging too when accessing mmio areas.
Make it support the additional page-level too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c         |    6 ++++++
 arch/x86/kvm/paging_tmpl.h |   16 ++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ef2396d..fc0e2fc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -117,6 +117,11 @@ module_param(oos_shadow, bool, 0644);
 #define PT64_DIR_BASE_ADDR_MASK \
 	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + PT64_LEVEL_BITS)) - 1))
 
+#define PT64_PDPE_BASE_ADDR_MASK \
+	(PT64_BASE_ADDR_MASK & ~(1ULL << (PAGE_SHIFT + (2 * PT64_LEVEL_BITS))))
+#define PT64_PDPE_OFFSET_MASK \
+	(PT64_BASE_ADDR_MASK & (1ULL << (PAGE_SHIFT + (2 * PT64_LEVEL_BITS))))
+
 #define PT32_BASE_ADDR_MASK PAGE_MASK
 #define PT32_DIR_BASE_ADDR_MASK \
 	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
@@ -130,6 +135,7 @@ module_param(oos_shadow, bool, 0644);
 #define PFERR_RSVD_MASK (1U << 3)
 #define PFERR_FETCH_MASK (1U << 4)
 
+#define PT_PDPE_LEVEL 3
 #define PT_DIRECTORY_LEVEL 2
 #define PT_PAGE_TABLE_LEVEL 1
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 8fbf4e7..54c77be 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -55,6 +55,7 @@
 
 #define gpte_to_gfn FNAME(gpte_to_gfn)
 #define gpte_to_gfn_pde FNAME(gpte_to_gfn_pde)
+#define gpte_to_gfn_pdpe FNAME(gpte_to_gfn_pdpe)
 
 /*
  * The guest_walker structure emulates the behavior of the hardware page
@@ -81,6 +82,11 @@ static gfn_t gpte_to_gfn_pde(pt_element_t gpte)
 	return (gpte & PT_DIR_BASE_ADDR_MASK) >> PAGE_SHIFT;
 }
 
+static gfn_t gpte_to_gfn_pdpe(pt_element_t gpte)
+{
+	return (gpte & PT64_PDPE_BASE_ADDR_MASK) >> PAGE_SHIFT;
+}
+
 static bool FNAME(cmpxchg_gpte)(struct kvm *kvm,
 			 gfn_t table_gfn, unsigned index,
 			 pt_element_t orig_pte, pt_element_t new_pte)
@@ -201,6 +207,15 @@ walk:
 			break;
 		}
 
+		if (walker->level == PT_PDPE_LEVEL &&
+		    (pte & PT_PAGE_SIZE_MASK) &&
+		    is_long_mode(vcpu)) {
+			walker->gfn  = gpte_to_gfn_pdpe(pte);
+			walker->gfn += (addr & PT64_PDPE_OFFSET_MASK)
+					>> PAGE_SHIFT;
+			break;
+		}
+
 		pt_access = pte_access;
 		--walker->level;
 	}
@@ -609,4 +624,5 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 #undef PT_MAX_FULL_LEVELS
 #undef gpte_to_gfn
 #undef gpte_to_gfn_pde
+#undef gpte_to_gfn_pdpe
 #undef CMPXCHG
-- 
1.6.3.1


