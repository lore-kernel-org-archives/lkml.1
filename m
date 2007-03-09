Return-Path: <linux-kernel-owner+w=401wt.eu-S2992918AbXCIDNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992918AbXCIDNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992917AbXCIDNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:13:19 -0500
Received: from ozlabs.org ([203.10.76.45]:45410 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992918AbXCIDNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:13:18 -0500
Subject: [PATCH 3/9] lguest: cleanup: allocate separate pages for switcher
	code
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@osdl.org>
Cc: Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1173409696.32234.69.camel@localhost.localdomain>
References: <1173409524.32234.67.camel@localhost.localdomain>
	 <1173409696.32234.69.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 14:12:18 +1100
Message-Id: <1173409939.32234.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need physically-contiguous pages for the hypervisor, since we
use map_vm_area anyway.

Two other related cleanups: pass the number of pages to
init_pagetables() so we can remove the constant from the header, and
call populate_hypervisor_pte_page() on each page as we allocate it,
rather than as a separate loop.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 9fea34a28460 arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c	Thu Mar 08 16:09:00 2007 +1100
+++ b/arch/i386/lguest/core.c	Thu Mar 08 16:21:42 2007 +1100
@@ -24,17 +24,21 @@ static char __initdata hypervisor_blob[]
 #include "hypervisor-blob.c"
 };
 
-#define MAX_LGUEST_GUESTS						  \
-	(((PAGE_SIZE << HYPERVISOR_PAGE_ORDER) - sizeof(hypervisor_blob)) \
+/* 64k ought to be enough for anybody! */
+#define HYPERVISOR_PAGES (65536 / PAGE_SIZE)
+
+#define MAX_LGUEST_GUESTS						\
+	(((HYPERVISOR_PAGES * PAGE_SIZE) - sizeof(hypervisor_blob))	\
 	 / sizeof(struct lguest_state))
 
 static struct vm_struct *hypervisor_vma;
+/* Pages for hypervisor itself */
+static struct page *hype_page[HYPERVISOR_PAGES];
 static int cpu_had_pge;
 static struct {
 	unsigned long offset;
 	unsigned short segment;
 } lguest_entry __attribute_used__;
-struct page *hype_pages; /* Contiguous pages. */
 struct lguest lguests[MAX_LGUEST_GUESTS];
 DEFINE_MUTEX(lguest_lock);
 
@@ -58,15 +62,19 @@ struct lguest_state *__lguest_states(voi
 
 static __init int map_hypervisor(void)
 {
-	unsigned int i;
-	int err;
-	struct page *pages[HYPERVISOR_PAGES], **pagep = pages;
-
-	hype_pages = alloc_pages(GFP_KERNEL|__GFP_ZERO, HYPERVISOR_PAGE_ORDER);
-	if (!hype_pages)
-		return -ENOMEM;
-
-	hypervisor_vma = __get_vm_area(PAGE_SIZE << HYPERVISOR_PAGE_ORDER,
+	int i, err;
+	struct page **pagep = hype_page;
+
+	for (i = 0; i < ARRAY_SIZE(hype_page); i++) {
+		unsigned long addr = get_zeroed_page(GFP_KERNEL);
+		if (!addr) {
+			err = -ENOMEM;
+			goto free_some_pages;
+		}
+		hype_page[i] = virt_to_page(addr);
+	}
+
+	hypervisor_vma = __get_vm_area(ARRAY_SIZE(hype_page) * PAGE_SIZE,
 				       VM_ALLOC, HYPE_ADDR, VMALLOC_END);
 	if (!hypervisor_vma) {
 		err = -ENOMEM;
@@ -74,9 +82,6 @@ static __init int map_hypervisor(void)
 		goto free_pages;
 	}
 
-	for (i = 0; i < HYPERVISOR_PAGES; i++)
-		pages[i] = hype_pages + i;
-
 	err = map_vm_area(hypervisor_vma, PAGE_KERNEL, &pagep);
 	if (err) {
 		printk("lguest: map_vm_area failed: %i\n", err);
@@ -100,14 +105,20 @@ free_vma:
 free_vma:
 	vunmap(hypervisor_vma->addr);
 free_pages:
-	__free_pages(hype_pages, HYPERVISOR_PAGE_ORDER);
+	i = ARRAY_SIZE(hype_page);
+free_some_pages:
+	for (--i; i >= 0; i--)
+		__free_pages(hype_page[i], 0);
 	return err;
 }
 
 static __exit void unmap_hypervisor(void)
 {
+	unsigned int i;
+
 	vunmap(hypervisor_vma->addr);
-	__free_pages(hype_pages, HYPERVISOR_PAGE_ORDER);
+	for (i = 0; i < ARRAY_SIZE(hype_page); i++)
+		__free_pages(hype_page[i], 0);
 }
 
 /* IN/OUT insns: enough to get us past boot-time probing. */
@@ -390,7 +401,7 @@ static int __init init(void)
 	if (err)
 		return err;
 
-	err = init_pagetables(hype_pages);
+	err = init_pagetables(hype_page, HYPERVISOR_PAGES);
 	if (err) {
 		unmap_hypervisor();
 		return err;
diff -r 9fea34a28460 arch/i386/lguest/lg.h
--- a/arch/i386/lguest/lg.h	Thu Mar 08 16:09:00 2007 +1100
+++ b/arch/i386/lguest/lg.h	Thu Mar 08 16:21:42 2007 +1100
@@ -2,9 +2,6 @@
 #define _LGUEST_H
 
 #include <asm/desc.h>
-/* 64k ought to be enough for anybody! */
-#define HYPERVISOR_PAGE_ORDER (16 - PAGE_SHIFT)
-#define HYPERVISOR_PAGES (1 << HYPERVISOR_PAGE_ORDER)
 
 #define GDT_ENTRY_LGUEST_CS	10
 #define GDT_ENTRY_LGUEST_DS	11
@@ -43,7 +40,7 @@ struct lguest_regs
 };
 
 __exit void free_pagetables(void);
-__init int init_pagetables(struct page *hype_pages);
+__init int init_pagetables(struct page **hype_page, int pages);
 
 /* Full 4G segment descriptors, suitable for CS and DS. */
 #define FULL_EXEC_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9b00})
@@ -122,7 +119,6 @@ struct lguest
 	struct host_trap interrupt[LGUEST_IRQS];
 };
 
-extern struct page *hype_pages; /* Contiguous pages. */
 extern struct lguest lguests[];
 extern struct mutex lguest_lock;
 
diff -r 9fea34a28460 arch/i386/lguest/page_tables.c
--- a/arch/i386/lguest/page_tables.c	Thu Mar 08 16:09:00 2007 +1100
+++ b/arch/i386/lguest/page_tables.c	Thu Mar 08 16:24:56 2007 +1100
@@ -328,9 +328,23 @@ static void free_hypervisor_pte_pages(vo
 		free_page((long)hypervisor_pte_page(i));
 }
 
-static __init int alloc_hypervisor_pte_pages(void)
+static __init void populate_hypervisor_pte_page(int cpu,
+						struct page *hype_page[],
+						int pages)
 {
 	int i;
+	u32 *pte = hypervisor_pte_page(cpu);
+
+	for (i = 0; i < pages; i++) {
+		/* First entry set dynamically in map_trap_page */
+		pte[i+1] = ((page_to_pfn(hype_page[i]) << PAGE_SHIFT) 
+			    | _PAGE_KERNEL_EXEC);
+	}
+}
+
+__init int init_pagetables(struct page **hype_page, int pages)
+{
+	unsigned int i;
 
 	for_each_possible_cpu(i) {
 		hypervisor_pte_page(i) = (u32 *)get_zeroed_page(GFP_KERNEL);
@@ -338,36 +352,11 @@ static __init int alloc_hypervisor_pte_p
 			free_hypervisor_pte_pages();
 			return -ENOMEM;
 		}
+		populate_hypervisor_pte_page(i, hype_page, pages);
 	}
 	return 0;
 }
 
-static __init void populate_hypervisor_pte_page(int cpu)
-{
-	int i;
-	u32 *pte = hypervisor_pte_page(cpu);
-
-	for (i = 0; i < HYPERVISOR_PAGES; i++) {
-		/* First entry set dynamically in map_trap_page */
-		pte[i+1] = ((page_to_pfn(&hype_pages[i]) << PAGE_SHIFT)
-			    | _PAGE_KERNEL_EXEC);
-	}
-}
-
-__init int init_pagetables(struct page hype_pages[])
-{
-	int ret;
-	unsigned int i;
-
-	ret = alloc_hypervisor_pte_pages();
-	if (ret)
-		return ret;
-
-	for_each_possible_cpu(i)
-		populate_hypervisor_pte_page(i);
-	return 0;
-}
-
 __exit void free_pagetables(void)
 {
 	free_hypervisor_pte_pages();


