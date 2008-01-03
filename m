Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbYACRqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbYACRqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYACRqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:46:14 -0500
Received: from ns1.suse.de ([195.135.220.2]:60662 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbYACRqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:46:13 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103646.181089000@suse.de>
In-Reply-To: <20080103646.181089000@suse.de>
To: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/3] Add a new arch_early_alloc() interface for x86-64 v2
Message-Id: <20080103174612.4E77114DDD@wotan.suse.de>
Date: Thu,  3 Jan 2008 18:46:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows to allocate memory really early before bootmem is setup.
And a symbol that can be tested by the preprocessor.

pgtable.h is probably not the best include for it, but also not the worst.

This starts to allocate at 128MB and falls back to lower memory only
if that fails. Rationale is that this will handle 64MB kdump kernels
loaded at 16MB.

v1->v2: [includes typo fix from Eric Dumazet] 
v1->v2: [Move default start to 128MB instead of 32MB]

Cc: peterz@infradead.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/e820_64.c    |   14 ++++++++++++++
 include/asm-x86/pgtable_64.h |    3 +++
 2 files changed, 17 insertions(+)

Index: linux/arch/x86/kernel/e820_64.c
===================================================================
--- linux.orig/arch/x86/kernel/e820_64.c
+++ linux/arch/x86/kernel/e820_64.c
@@ -819,3 +819,17 @@ int __init arch_get_ram_range(int slot, 
 		max_pfn << PAGE_SHIFT) - *addr;
 	return i + 1;
 }
+
+#define EARLY_ALLOC_START (128<<20)
+__init void *arch_early_alloc(unsigned long size)
+{
+	unsigned long p = find_e820_area(EARLY_ALLOC_START, -1UL, size);
+	if (p == -1ULL) {
+		/* Risk filling the DMA zone */
+		p = find_e820_area(0, -1UL, size);
+		if (p == -1ULL)
+			panic("arch_early_alloc %lu failed", size);
+	}
+	reserve_early(p, p + size);
+	return __va(p);
+}
Index: linux/include/asm-x86/pgtable_64.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_64.h
+++ linux/include/asm-x86/pgtable_64.h
@@ -436,6 +436,9 @@ pte_t *lookup_address(unsigned long addr
 #define	kc_offset_to_vaddr(o) \
    (((o) & (1UL << (__VIRTUAL_MASK_SHIFT-1))) ? ((o) | (~__VIRTUAL_MASK)) : (o))
 
+#define ARCH_HAS_EARLY_ALLOC
+extern void *arch_early_alloc(unsigned long size);
+
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
