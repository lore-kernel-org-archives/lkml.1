Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbYCLCxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbYCLCxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYCLCxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:53:31 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:44811 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYCLCxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:53:30 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20080312353.598285931@firstfloor.org>
To: andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/7] Implement true end_pfn_mapped for 32bit
Date: Wed, 12 Mar 2008 03:53:27 +0100 (CET)
X-OriginalArrivalTime: 12 Mar 2008 02:46:55.0582 (UTC) FILETIME=[558B87E0:01C883EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Old patch; repost, but needed for further patches in the series]

Even on 32bit 2MB pages can map more memory than is in the true
max_low_pfn if end_pfn is not highmem and not aligned to 2MB. 
Add a end_pfn_map similar to x86-64 that accounts for this 
fact. This is important for code that really needs to know about
all mapping aliases.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_32.c     |    4 ++++
 include/asm-x86/page.h    |    4 +++-
 include/asm-x86/page_64.h |    1 -
 3 files changed, 7 insertions(+), 2 deletions(-)

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
