Return-Path: <linux-kernel-owner+w=401wt.eu-S1759120AbXISDmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbXISDmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbXISDh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:37:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54934 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751994AbXISDgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:42 -0400
Message-Id: <20070919033641.699816118@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:11 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [06/17] vmalloc_address(): Determine vmalloc address from page struct
Content-Disposition: inline; filename=vcompound_vmalloc_address
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we need to figure out which vmalloc address is in use
for a certain page struct. There is no easy way to figure out
the vmalloc address from the page struct. So simply search through
the kernel page table to find the address. This is a fairly expensive
process. Use sparingly (or provide a better implementation).

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/vmalloc.h |    3 +
 mm/vmalloc.c            |   77 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c	2007-09-18 18:35:13.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-09-18 18:35:18.000000000 -0700
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
Index: linux-2.6/include/linux/vmalloc.h
===================================================================
--- linux-2.6.orig/include/linux/vmalloc.h	2007-09-18 18:35:13.000000000 -0700
+++ linux-2.6/include/linux/vmalloc.h	2007-09-18 18:35:48.000000000 -0700
@@ -85,6 +85,9 @@ extern void free_vm_area(struct vm_struc
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
 
+/* Determine address from page struct pointer */
+void *vmalloc_address(struct page *);
+
 /*
  *	Internals.  Dont't use..
  */

-- 
