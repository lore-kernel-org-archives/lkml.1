Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXIYXpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXIYXpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbXIYXnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:43:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57661 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752413AbXIYXmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:51 -0400
Message-Id: <20070925234250.804801585@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:11 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [07/17] vmalloc_address(): Determine vmalloc address from page struct
Content-Disposition: inline; filename=vcompound_vmalloc_address
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we need to figure out which vmalloc address is in use
for a certain page struct. There is no easy way to figure out
the vmalloc address from the page struct. So simply search through
the kernel page tables to find the address. This is a fairly expensive
process. Use sparingly (or provide a better implementation).

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |    1 
 mm/vmalloc.c       |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c	2007-09-24 16:59:54.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-09-24 17:00:07.000000000 -0700
@@ -196,6 +196,83 @@ struct page *vmalloc_to_page(const void 
 EXPORT_SYMBOL(vmalloc_to_page);
 
 /*
+ * Determine vmalloc address from a page struct.
+ *
+ * Linear search through all ptes of the vmalloc area.
+ */
+static unsigned long vaddr_pte_range(pmd_t *pmd, unsigned long addr,
+		unsigned long end, unsigned long pfn)
+{
+	pte_t *pte;
+
+	pte = pte_offset_kernel(pmd, addr);
+	do {
+		pte_t ptent = *pte;
+		if (pte_present(ptent) && pte_pfn(ptent) == pfn)
+			return addr;
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+	return 0;
+}
+
+static inline unsigned long vaddr_pmd_range(pud_t *pud, unsigned long addr,
+		unsigned long end, unsigned long pfn)
+{
+	pmd_t *pmd;
+	unsigned long next;
+	unsigned long n;
+
+	pmd = pmd_offset(pud, addr);
+	do {
+		next = pmd_addr_end(addr, end);
+		if (pmd_none_or_clear_bad(pmd))
+			continue;
+		n = vaddr_pte_range(pmd, addr, next, pfn);
+		if (n)
+			return n;
+	} while (pmd++, addr = next, addr != end);
+	return 0;
+}
+
+static inline unsigned long vaddr_pud_range(pgd_t *pgd, unsigned long addr,
+		unsigned long end, unsigned long pfn)
+{
+	pud_t *pud;
+	unsigned long next;
+	unsigned long n;
+
+	pud = pud_offset(pgd, addr);
+	do {
+		next = pud_addr_end(addr, end);
+		if (pud_none_or_clear_bad(pud))
+			continue;
+		n = vaddr_pmd_range(pud, addr, next, pfn);
+		if (n)
+			return n;
+	} while (pud++, addr = next, addr != end);
+	return 0;
+}
+
+void *vmalloc_address(struct page *page)
+{
+	pgd_t *pgd;
+	unsigned long next, n;
+	unsigned long addr = VMALLOC_START;
+	unsigned long pfn = page_to_pfn(page);
+
+	pgd = pgd_offset_k(VMALLOC_START);
+	do {
+		next = pgd_addr_end(addr, VMALLOC_END);
+		if (pgd_none_or_clear_bad(pgd))
+			continue;
+		n = vaddr_pud_range(pgd, addr, next, pfn);
+		if (n)
+			return (void *)n;
+	} while (pgd++, addr = next, addr < VMALLOC_END);
+	return NULL;
+}
+EXPORT_SYMBOL(vmalloc_address);
+
+/*
  * Map a vmalloc()-space virtual address to the physical page frame number.
  */
 unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-09-24 17:00:33.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-09-24 17:00:42.000000000 -0700
@@ -296,6 +296,7 @@ static inline int get_page_unless_zero(s
 
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
+void *vmalloc_address(struct page *);
 
 /* Determine if an address is within the vmalloc range */
 static inline int is_vmalloc_addr(const void *x)

-- 
