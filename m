Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYBKJgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYBKJgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYBKJek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:34:40 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:16588 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYBKJei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:34:38 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111034.764275766@suse.de>
In-Reply-To: <200802111034.764275766@suse.de>
To: ying.huang@intel.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [7/8] Implement true end_pfn_mapped for 32bit
Message-Id: <20080211093435.E6FC21B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:34:35 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:28:15.0099 (UTC) FILETIME=[6DA9BCB0:01C86C90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Even on 32bit 2MB pages can map more memory than is in the true
max_low_pfn if end_pfn is not highmem and not aligned to 2MB. 
Add a end_pfn_map similar to x86-64 that accounts for this 
fact. This is important for code that really needs to know about
all mapping aliases. Needed for followup patches (in this case EFI)

Cc: ying.huang@intel.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_32.c     |    5 +++++
 include/asm-x86/page.h    |    4 +++-
 include/asm-x86/page_64.h |    1 -
 3 files changed, 8 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -50,6 +50,8 @@
 
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
+unsigned long end_pfn_map;
+
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 unsigned long highstart_pfn, highend_pfn;
 
@@ -193,6 +195,7 @@ static void __init kernel_physical_mappi
 				set_pmd(pmd, pfn_pmd(pfn, prot));
 
 				pfn += PTRS_PER_PTE;
+				end_pfn_map = pfn;
 				continue;
 			}
 			pte = one_page_table_init(pmd);
@@ -207,6 +210,7 @@ static void __init kernel_physical_mappi
 
 				set_pte(pte, pfn_pte(pfn, prot));
 			}
+			end_pfn_map = pfn;
 		}
 	}
 }
Index: linux/include/asm-x86/page.h
===================================================================
--- linux.orig/include/asm-x86/page.h
+++ linux/include/asm-x86/page.h
@@ -36,7 +36,7 @@
 #define max_pfn_mapped		end_pfn_map
 #else
 #include <asm/page_32.h>
-#define max_pfn_mapped		max_low_pfn
+#define max_pfn_mapped		end_pfn_map
 #endif	/* CONFIG_X86_64 */
 
 #define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
@@ -51,6 +51,8 @@
 extern int page_is_ram(unsigned long pagenr);
 extern int devmem_is_allowed(unsigned long pagenr);
 
+extern unsigned long end_pfn_map;
+
 struct page;
 
 static void inline clear_user_page(void *page, unsigned long vaddr,
Index: linux/include/asm-x86/page_64.h
===================================================================
--- linux.orig/include/asm-x86/page_64.h
+++ linux/include/asm-x86/page_64.h
@@ -55,7 +55,6 @@ void clear_page(void *page);
 void copy_page(void *to, void *from);
 
 extern unsigned long end_pfn;
-extern unsigned long end_pfn_map;
 extern unsigned long phys_base;
 
 extern unsigned long __phys_addr(unsigned long);
