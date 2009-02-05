Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbZBETer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbZBETer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759691AbZBETcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:24 -0500
Received: from gw.goop.org ([64.81.55.164]:40046 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758517AbZBETcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:20 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 09 of 36] x86: unify pmd_none
X-Mercurial-Node: 0799aebb0368c98733ecc424c9e76bc152430425
Message-Id: <0799aebb0368c98733ec.1233862251@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pmd_none.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h    |    7 +++++++
 arch/x86/include/asm/pgtable_32.h |    2 --
 arch/x86/include/asm/pgtable_64.h |    1 -
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -488,6 +488,13 @@
 	return pmd_val(pmd) & _PAGE_PRESENT;
 }
 
+static inline int pmd_none(pmd_t pmd)
+{
+	/* Only check low word on 32-bit platforms, since it might be
+	   out of sync with upper half. */
+	return !(unsigned long)native_pmd_val(pmd);
+}
+
 #if PAGETABLE_LEVELS > 2
 static inline int pud_present(pud_t pud)
 {
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -85,8 +85,6 @@
 /* The boot page tables (all created as a single array) */
 extern unsigned long pg0[];
 
-/* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
-#define pmd_none(x)	(!(unsigned long)pmd_val((x)))
 #define pmd_bad(x) ((pmd_val(x) & (PTE_FLAGS_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -206,7 +206,6 @@
 #define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
 #define pmd_offset(dir, address) ((pmd_t *)pud_page_vaddr(*(dir)) + \
 				  pmd_index(address))
-#define pmd_none(x)	(!pmd_val((x)))
 #define pfn_pmd(nr, prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val((prot))))
 #define pmd_pfn(x)  ((pmd_val((x)) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 


