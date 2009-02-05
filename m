Return-Path: <linux-kernel-owner+w=401wt.eu-S1762127AbZBETij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762127AbZBETij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbZBETcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:32 -0500
Received: from gw.goop.org ([64.81.55.164]:40055 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759459AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 25 of 36] x86: unify pte_offset_kernel
X-Mercurial-Node: e62b48cd3d4b959622147e6c59e15a350d961ef2
Message-Id: <e62b48cd3d4b95962214.1233862267@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pte_offset_kernel.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    5 +++++
 arch/x86/include/asm/pgtable_32.h |    3 ---
 arch/x86/include/asm/pgtable_64.h |    3 ---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -547,6 +547,11 @@
 	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 }
 
+static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
+{
+	return (pte_t *)pmd_page_vaddr(*pmd) + pte_index(address);
+}
+
 #if PAGETABLE_LEVELS > 2
 static inline int pud_present(pud_t pud)
 {
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -97,9 +97,6 @@
 
 static inline int pud_large(pud_t pud) { return 0; }
 
-#define pte_offset_kernel(dir, address)				\
-	((pte_t *)pmd_page_vaddr(*(dir)) +  pte_index((address)))
-
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address)					\
 	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE0) +		\
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -197,9 +197,6 @@
 
 /* PTE - Level 1 access. */
 
-#define pte_offset_kernel(dir, address) ((pte_t *) pmd_page_vaddr(*(dir)) + \
-					 pte_index((address)))
-
 /* x86-64 always has all page tables mapped. */
 #define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
 #define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))


