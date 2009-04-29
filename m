Return-Path: <linux-kernel-owner+w=401wt.eu-S933348AbZD3Pxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbZD3Pxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932465AbZD3PnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:43:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52632 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbZD3PmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:03 -0400
Message-Id: <821a570574a4dadc0c0c838f90f41dd5df81f090.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 29 Apr 2009 16:55:36 +0200
Subject: [PATCH 11/27] asm-generic: add generic page.h
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX18vDlqze/Vw7hb/y9hRfzXRXm4BPXlB40dCryj
 kvKEcVmrUDS4eR9UOZ4cSAxOzGGXWGwLJERHdw87NPxw21KIup
 YAnXid3eshfTYdetHtNiw==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures that have no mmu should not have to
describe their page tables. This adds a new page.h
file based on the existing nommu architectures
that adds a lot of dummy definitions to let you
correctly compile a nommu kernel.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/page.h |   99 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 99 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/page.h

diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
new file mode 100644
index 0000000..75fec18
--- /dev/null
+++ b/include/asm-generic/page.h
@@ -0,0 +1,99 @@
+#ifndef __ASM_GENERIC_PAGE_H
+#define __ASM_GENERIC_PAGE_H
+/*
+ * Generic page.h implementation, for NOMMU architectures.
+ * This provides the dummy definitions for the memory management.
+ */
+
+#ifdef CONFIG_MMU
+#error need to prove a real asm/page.h
+#endif
+
+
+/* PAGE_SHIFT determines the page size */
+
+#define PAGE_SHIFT	12
+#ifdef __ASSEMBLY__
+#define PAGE_SIZE	(1 << PAGE_SHIFT)
+#else
+#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#endif
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+
+#include <asm/setup.h>
+
+#ifndef __ASSEMBLY__
+
+#define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
+#define free_user_page(page, addr)	free_page(addr)
+
+#define clear_page(page)	memset((page), 0, PAGE_SIZE)
+#define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
+
+#define clear_user_page(page, vaddr, pg)	clear_page(page)
+#define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct {
+	unsigned long pte;
+} pte_t;
+typedef struct {
+	unsigned long pmd[16];
+} pmd_t;
+typedef struct {
+	unsigned long pgd;
+} pgd_t;
+typedef struct {
+	unsigned long pgprot;
+} pgprot_t;
+typedef struct page *pgtable_t;
+
+#define pte_val(x)	((x).pte)
+#define pmd_val(x)	((&x)->pmd[0])
+#define pgd_val(x)	((x).pgd)
+#define pgprot_val(x)	((x).pgprot)
+
+#define __pte(x)	((pte_t) { (x) } )
+#define __pmd(x)	((pmd_t) { (x) } )
+#define __pgd(x)	((pgd_t) { (x) } )
+#define __pgprot(x)	((pgprot_t) { (x) } )
+
+extern unsigned long memory_start;
+extern unsigned long memory_end;
+
+#endif /* !__ASSEMBLY__ */
+
+#ifdef CONFIG_KERNEL_RAM_BASE_ADDRESS
+#define PAGE_OFFSET		(CONFIG_KERNEL_RAM_BASE_ADDRESS)
+#else
+#define PAGE_OFFSET		(0)
+#endif
+
+#ifndef __ASSEMBLY__
+
+#define __va(x) ((void *)((unsigned long)(x) + PAGE_OFFSET))
+#define __pa(x) ((unsigned long) (x) - PAGE_OFFSET)
+
+#define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
+#define pfn_to_virt(pfn)	__va((pfn) << PAGE_SHIFT)
+
+#define virt_to_page(addr)	(mem_map + (((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT))
+#define page_to_virt(page)	((((page) - mem_map) << PAGE_SHIFT) + PAGE_OFFSET)
+
+#ifndef page_to_phys
+#define page_to_phys(page)      ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
+#endif
+
+#define pfn_valid(pfn)		((pfn) < max_mapnr)
+
+#define	virt_addr_valid(kaddr)	(((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
+				((void *)(kaddr) < (void *)memory_end))
+
+#endif /* __ASSEMBLY__ */
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/getorder.h>
+
+#endif /* __ASM_GENERIC_PAGE_H */
-- 
1.5.6.3


