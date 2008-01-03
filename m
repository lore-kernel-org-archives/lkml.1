Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbYACPoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbYACPoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYACPmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:42:24 -0500
Received: from ns2.suse.de ([195.135.220.15]:44486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbYACPmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:42:21 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103442.621670000@suse.de>
In-Reply-To: <20080103442.621670000@suse.de>
To: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86] [6/16] Add a new arch_early_alloc() interface for x86-64
Message-Id: <20080103154220.0CCD814DDB@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:42:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows to allocate memory really early before bootmem is setup.

And a symbol that can be tested by the preprocessor.

pgtable.h is probably not the best include for it, but also not the worst.

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
+#define EARLY_ALLOC_START (32<<20)
+__init void *arch_early_alloc(unsigned long size)
+{
+	unsigned long p = find_e820_area(EARLY_ALLOC_START, -1UL, size);
+	if (p == -1ULL) {
+		/* Risk filling the DMA zone */
+		p = find_e820_area(EARLY_ALLOC_START, -1UL, size);
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
