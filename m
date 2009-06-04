Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZFDBsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZFDBsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 21:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbZFDBrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 21:47:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40360 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbZFDBro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 21:47:44 -0400
Date: Wed, 3 Jun 2009 21:46:46 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jdike@addtoit.com, rusty@rustcorp.com.au, hch@infradead.org,
       Amerigo Wang <amwang@redhat.com>, mingo@elte.hu,
       akpm@linux-foundation.org
Message-Id: <20090604014858.6332.68218.sendpatchset@localhost.localdomain>
In-Reply-To: <20090604014813.6332.18486.sendpatchset@localhost.localdomain>
References: <20090604014813.6332.18486.sendpatchset@localhost.localdomain>
Subject: [Patch 5/5] module: merge module_alloc() finally
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As Christoph Hellwig suggested, module_alloc() actually can be
unified for i386 and x86_64 (of course, also UML).

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: 'Ingo Molnar' <mingo@elte.hu>

---
Index: linux-2.6/arch/x86/include/asm/pgtable_32_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable_32_types.h
+++ linux-2.6/arch/x86/include/asm/pgtable_32_types.h
@@ -46,6 +46,10 @@ extern bool __vmalloc_start_set; /* set 
 # define VMALLOC_END	(FIXADDR_START - 2 * PAGE_SIZE)
 #endif
 
+#define MODULES_VADDR	VMALLOC_START
+#define MODULES_END	VMALLOC_END
+#define MODULES_LEN	(MODULES_VADDR - MODULES_END)
+
 #define MAXMEM	(VMALLOC_END - PAGE_OFFSET - __VMALLOC_RESERVE)
 
 #endif /* _ASM_X86_PGTABLE_32_DEFS_H */
Index: linux-2.6/arch/um/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/um/include/asm/pgtable.h
+++ linux-2.6/arch/um/include/asm/pgtable.h
@@ -53,16 +53,21 @@ extern unsigned long end_iomem;
 #else
 # define VMALLOC_END	(FIXADDR_START-2*PAGE_SIZE)
 #endif
+#define MODULES_VADDR	VMALLOC_START
+#define MODULES_END	VMALLOC_END
+#define MODULES_LEN	(MODULES_VADDR - MODULES_END)
 
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
 #define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
-
+#define __PAGE_KERNEL_EXEC                                              \
+        (_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
 #define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
 #define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED)
 #define PAGE_COPY	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
 #define PAGE_READONLY	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
 #define PAGE_KERNEL	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
+#define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC)
 
 /*
  * The i386 can't do page protection for execute, and considers that the same
Index: linux-2.6/arch/x86/kernel/module.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/module.c
+++ linux-2.6/arch/x86/kernel/module.c
@@ -35,14 +35,6 @@
 #define DEBUGP(fmt...)
 #endif
 
-#if defined(CONFIG_UML) || defined(CONFIG_X86_32)
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc_exec(size);
-}
-#else /*X86_64*/
 void *module_alloc(unsigned long size)
 {
 	struct vm_struct *area;
@@ -57,9 +49,9 @@ void *module_alloc(unsigned long size)
 	if (!area)
 		return NULL;
 
-	return __vmalloc_area(area, GFP_KERNEL, PAGE_KERNEL_EXEC);
+	return __vmalloc_area(area, GFP_KERNEL | __GFP_HIGHMEM,
+					PAGE_KERNEL_EXEC);
 }
-#endif
 
 static void trim_init_extable(struct module *m)
 {
