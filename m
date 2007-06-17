Return-Path: <linux-kernel-owner+w=401wt.eu-S1761487AbXFQJzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761487AbXFQJzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759294AbXFQJpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:15 -0400
Received: from il.qumranet.com ([82.166.9.18]:55193 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759352AbXFQJos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:48 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 42/58] KVM: MMU: Simpify accessed/dirty/present/nx bit handling
Date: Sun, 17 Jun 2007 12:44:23 +0300
Message-Id: <11820734812037-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Always set the accessed and dirty bit (since having them cleared causes
a read-modify-write cycle), always set the present bit, and copy the
nx bit from the guest.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |    5 -----
 drivers/kvm/paging_tmpl.h |    7 ++-----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index f24b540..b47391f 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -91,11 +91,6 @@ static int dbg = 1;
 #define PT32_DIR_PSE36_MASK (((1ULL << PT32_DIR_PSE36_SIZE) - 1) << PT32_DIR_PSE36_SHIFT)
 
 
-#define PT32_PTE_COPY_MASK \
-	(PT_PRESENT_MASK | PT_ACCESSED_MASK | PT_DIRTY_MASK | PT_GLOBAL_MASK)
-
-#define PT64_PTE_COPY_MASK (PT64_NX_MASK | PT32_PTE_COPY_MASK)
-
 #define PT_FIRST_AVAIL_BITS_SHIFT 9
 #define PT64_SECOND_AVAIL_BITS_SHIFT 52
 
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 59b4cb2..b17a4b7 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -31,7 +31,6 @@
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
 	#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 	#define PT_LEVEL_MASK(level) PT64_LEVEL_MASK(level)
-	#define PT_PTE_COPY_MASK PT64_PTE_COPY_MASK
 	#ifdef CONFIG_X86_64
 	#define PT_MAX_FULL_LEVELS 4
 	#else
@@ -46,7 +45,6 @@
 	#define PT_INDEX(addr, level) PT32_INDEX(addr, level)
 	#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 	#define PT_LEVEL_MASK(level) PT32_LEVEL_MASK(level)
-	#define PT_PTE_COPY_MASK PT32_PTE_COPY_MASK
 	#define PT_MAX_FULL_LEVELS 2
 #else
 	#error Invalid PTTYPE value
@@ -219,7 +217,8 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 		FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
 	}
 
-	spte |= *gpte & PT_PTE_COPY_MASK;
+	spte |= PT_PRESENT_MASK | PT_ACCESSED_MASK | PT_DIRTY_MASK;
+	spte |= *gpte & PT64_NX_MASK;
 	spte |= access_bits << PT_SHADOW_BITS_OFFSET;
 	if (!dirty)
 		access_bits &= ~PT_WRITABLE_MASK;
@@ -495,7 +494,5 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr)
 #undef PT_INDEX
 #undef SHADOW_PT_INDEX
 #undef PT_LEVEL_MASK
-#undef PT_PTE_COPY_MASK
-#undef PT_NON_PTE_COPY_MASK
 #undef PT_DIR_BASE_ADDR_MASK
 #undef PT_MAX_FULL_LEVELS
-- 
1.5.0.6

