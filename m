Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYIMAKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYIMAKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYIMAK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:10:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:16989 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbYIMAK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:10:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,392,1217833200"; 
   d="scan'208";a="45762583"
Message-Id: <20080913000051.819383000@linux-os.sc.intel.com>
References: <20080913000003.732756000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 12 Sep 2008 17:00:04 -0700
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 1/2] x86: track memtype for RAM in page struct
Content-Disposition: inline; filename=use_pg_arch_1_for_ram_tracking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/2] x86: track memtype for RAM in page struct

Track the memtype for RAM pages in page struct instead of using the memtype
list. This avoids the explosion in the number of entries in memtype list
(of the order of 20,000 with AGP) and makes the PAT tracking simpler. We are
using PG_arch_1 bit in page->flags.

We still use the memtype list for non RAM pages.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/ioremap.c  |   19 +++++++++++
 arch/x86/mm/pat.c      |   83 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/page.h |    1 
 3 files changed, 103 insertions(+)

Index: tip/arch/x86/mm/ioremap.c
===================================================================
--- tip.orig/arch/x86/mm/ioremap.c	2008-09-12 16:03:33.000000000 -0700
+++ tip/arch/x86/mm/ioremap.c	2008-09-12 16:23:33.000000000 -0700
@@ -102,6 +102,25 @@ int page_is_ram(unsigned long pagenr)
 	return 0;
 }
 
+int pagerange_is_ram(unsigned long start, unsigned long end)
+{
+	int ram_page = 0, not_rampage = 0;
+	unsigned long page_nr;
+
+	for (page_nr = (start >> PAGE_SHIFT); page_nr < (end >> PAGE_SHIFT);
+	     ++page_nr) {
+		if (page_is_ram(page_nr))
+			ram_page = 1;
+		else
+			not_rampage = 1;
+
+		if (ram_page == not_rampage)
+			return -1;
+	}
+
+	return ram_page;
+}
+
 /*
  * Fix up the linear direct mapping of the kernel to avoid cache attribute
  * conflicts.
Index: tip/arch/x86/mm/pat.c
===================================================================
--- tip.orig/arch/x86/mm/pat.c	2008-09-12 16:03:33.000000000 -0700
+++ tip/arch/x86/mm/pat.c	2008-09-12 16:23:33.000000000 -0700
@@ -211,6 +211,75 @@ static struct memtype *cached_entry;
 static u64 cached_start;
 
 /*
+ * RED-PEN:  TODO: Add PageReserved() check aswell here,
+ * once we add SetPageReserved() to all the drivers using
+ * set_memory_* or set_pages_*
+ *
+ * This will help prevent accidentally freeing pages
+ * before setting the attribute back to WB.
+ */
+
+/*
+ * For RAM pages, mark the pages with non WB attribute using
+ * PG_arch_1. We allow only one set_memory_uc() or set_memory_wc()
+ * on a RAM page at a time before marking it as WB again. This is ok,
+ * because only one(driver) will be owning the page and doing set_memory_*()
+ * calls.
+ *
+ * For now, we use PG_arch_1 to track that the RAM page is being mapped
+ * as non WB. In future, based on the need we can use one or more flags
+ * (or some other mechanism in page_struct) to keep track of the actual
+ * attribute that the page is mapped to.
+ */
+static int reserve_ram_pages_type(u64 start, u64 end, unsigned long req_type,
+		       unsigned long *new_type)
+{
+	struct page *page;
+	u64 pfn, end_pfn;
+
+	for (pfn = (start >> PAGE_SHIFT); pfn < (end >> PAGE_SHIFT); ++pfn) {
+		page = pfn_to_page(pfn);
+		if (page_mapped(page) || test_bit(PG_arch_1, &page->flags))
+			goto out;
+
+		set_bit(PG_arch_1, &page->flags);
+	}
+	return 0;
+
+out:
+	end_pfn = pfn;
+	for (pfn = (start >> PAGE_SHIFT); pfn < end_pfn; ++pfn) {
+		page = pfn_to_page(pfn);
+		clear_bit(PG_arch_1, &page->flags);
+	}
+
+	return -EINVAL;
+}
+
+static int free_ram_pages_type(u64 start, u64 end)
+{
+	struct page *page;
+	u64 pfn, end_pfn;
+
+	for (pfn = (start >> PAGE_SHIFT); pfn < (end >> PAGE_SHIFT); ++pfn) {
+		page = pfn_to_page(pfn);
+		if (page_mapped(page) || !test_bit(PG_arch_1, &page->flags))
+			goto out;
+
+		clear_bit(PG_arch_1, &page->flags);
+	}
+	return 0;
+
+out:
+	end_pfn = pfn;
+	for (pfn = (start >> PAGE_SHIFT); pfn < end_pfn; ++pfn) {
+		page = pfn_to_page(pfn);
+		set_bit(PG_arch_1, &page->flags);
+	}
+	return -EINVAL;
+}
+
+/*
  * req_type typically has one of the:
  * - _PAGE_CACHE_WB
  * - _PAGE_CACHE_WC
@@ -232,6 +301,7 @@ int reserve_memtype(u64 start, u64 end, 
 	unsigned long actual_type;
 	struct list_head *where;
 	int err = 0;
+	int is_range_ram;
 
  	BUG_ON(start >= end); /* end is exclusive */
 
@@ -270,6 +340,12 @@ int reserve_memtype(u64 start, u64 end, 
 		actual_type = pat_x_mtrr_type(start, end,
 					      req_type & _PAGE_CACHE_MASK);
 
+	is_range_ram = pagerange_is_ram(start,end);
+	if (is_range_ram == 1)
+		return reserve_ram_pages_type(start, end, req_type, new_type);
+	else if (is_range_ram < 0)
+		return -EINVAL;
+
 	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
@@ -358,6 +434,7 @@ int free_memtype(u64 start, u64 end)
 {
 	struct memtype *entry;
 	int err = -EINVAL;
+	int is_range_ram;
 
 	if (!pat_enabled)
 		return 0;
@@ -366,6 +443,12 @@ int free_memtype(u64 start, u64 end)
 	if (is_ISA_range(start, end - 1))
 		return 0;
 
+	is_range_ram = pagerange_is_ram(start,end);
+	if (is_range_ram == 1)
+		return free_ram_pages_type(start, end);
+	else if (is_range_ram < 0)
+		return -EINVAL;
+
 	spin_lock(&memtype_lock);
 	list_for_each_entry(entry, &memtype_list, nd) {
 		if (entry->start == start && entry->end == end) {
Index: tip/include/asm-x86/page.h
===================================================================
--- tip.orig/include/asm-x86/page.h	2008-09-12 16:03:33.000000000 -0700
+++ tip/include/asm-x86/page.h	2008-09-12 16:23:33.000000000 -0700
@@ -57,6 +57,7 @@ typedef struct { pgdval_t pgd; } pgd_t;
 typedef struct { pgprotval_t pgprot; } pgprot_t;
 
 extern int page_is_ram(unsigned long pagenr);
+extern int pagerange_is_ram(unsigned long start, unsigned long end);
 extern int devmem_is_allowed(unsigned long pagenr);
 extern void map_devmem(unsigned long pfn, unsigned long size,
 		       pgprot_t vma_prot);

-- 

