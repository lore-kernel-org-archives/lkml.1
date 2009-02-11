Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZBKTVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZBKTVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 14:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbZBKTVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 14:21:35 -0500
Received: from mga14.intel.com ([143.182.124.37]:2855 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbZBKTVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 14:21:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,193,1233561600"; 
   d="scan'208";a="109672009"
Subject: [patch] x86, pat: fix warn_on_once() while mapping 0-1MB range
	with /dev/mem
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       jeffm@suse.com
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 11 Feb 2009 11:20:23 -0800
Message-Id: <1234380023.16238.52.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, pat: fix warn_on_once() while mapping 0-1MB range
with /dev/mem

Jeff Mahoney reported:
> With Suse's hwinfo tool, on -tip:
> WARNING: at arch/x86/mm/pat.c:637 reserve_pfn_range+0x5b/0x26d()

reserve_pfn_range() is not tracking the memory range below 1MB
as non-RAM and as such is inconsistent with similar checks in
reserve_memtype() and free_memtype()

Rename the pagerange_is_ram() to pat_pagerange_is_ram() and add the
"track legacy 1MB region as non RAM" condition.

And also, fix reserve_pfn_range() to return -EINVAL, when the pfn
range is RAM. This is to be consistent with this API design.

Reported-and-tested-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---

Index: tip/arch/x86/mm/pat.c
===================================================================
--- tip/arch/x86/mm/pat.c.orig
+++ tip/arch/x86/mm/pat.c
@@ -220,6 +220,33 @@ chk_conflict(struct memtype *new, struct
 static struct memtype *cached_entry;
 static u64 cached_start;
 
+static int pat_pagerange_is_ram(unsigned long start, unsigned long end)
+{
+	int ram_page = 0, not_rampage = 0;
+	unsigned long page_nr;
+
+	for (page_nr = (start >> PAGE_SHIFT); page_nr < (end >> PAGE_SHIFT);
+	     ++page_nr) {
+		/*
+		 * For legacy reasons, physical address range in the legacy ISA
+		 * region is tracked as non-RAM. This will allow users of
+		 * /dev/mem to map portions of legacy ISA region, even when
+		 * some of those portions are listed(or not even listed) with
+		 * different e820 types(RAM/reserved/..)
+		 */
+		if (page_nr >= (ISA_END_ADDRESS >> PAGE_SHIFT) &&
+		    page_is_ram(page_nr))
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
  * For RAM pages, mark the pages as non WB memory type using
  * PageNonWB (PG_arch_1). We allow only one set_memory_uc() or
@@ -345,20 +372,12 @@ int reserve_memtype(u64 start, u64 end, 
 	if (new_type)
 		*new_type = actual_type;
 
-	/*
-	 * For legacy reasons, some parts of the physical address range in the
-	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
-	 * the e820 tables).  So we will track the memory attributes of this
-	 * legacy 1MB region using the linear memtype_list always.
-	 */
-	if (end >= ISA_END_ADDRESS) {
-		is_range_ram = pagerange_is_ram(start, end);
-		if (is_range_ram == 1)
-			return reserve_ram_pages_type(start, end, req_type,
-						      new_type);
-		else if (is_range_ram < 0)
-			return -EINVAL;
-	}
+	is_range_ram = pat_pagerange_is_ram(start, end);
+	if (is_range_ram == 1)
+		return reserve_ram_pages_type(start, end, req_type,
+					      new_type);
+	else if (is_range_ram < 0)
+		return -EINVAL;
 
 	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
@@ -455,19 +474,11 @@ int free_memtype(u64 start, u64 end)
 	if (is_ISA_range(start, end - 1))
 		return 0;
 
-	/*
-	 * For legacy reasons, some parts of the physical address range in the
-	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
-	 * the e820 tables).  So we will track the memory attributes of this
-	 * legacy 1MB region using the linear memtype_list always.
-	 */
-	if (end >= ISA_END_ADDRESS) {
-		is_range_ram = pagerange_is_ram(start, end);
-		if (is_range_ram == 1)
-			return free_ram_pages_type(start, end);
-		else if (is_range_ram < 0)
-			return -EINVAL;
-	}
+	is_range_ram = pat_pagerange_is_ram(start, end);
+	if (is_range_ram == 1)
+		return free_ram_pages_type(start, end);
+	else if (is_range_ram < 0)
+		return -EINVAL;
 
 	spin_lock(&memtype_lock);
 	list_for_each_entry(entry, &memtype_list, nd) {
@@ -635,17 +646,13 @@ static int reserve_pfn_range(u64 paddr, 
 	unsigned long flags;
 	unsigned long want_flags = (pgprot_val(*vma_prot) & _PAGE_CACHE_MASK);
 
-	is_ram = pagerange_is_ram(paddr, paddr + size);
+	is_ram = pat_pagerange_is_ram(paddr, paddr + size);
 
-	if (is_ram != 0) {
-		/*
-		 * For mapping RAM pages, drivers need to call
-		 * set_memory_[uc|wc|wb] directly, for reserve and free, before
-		 * setting up the PTE.
-		 */
-		WARN_ON_ONCE(1);
-		return 0;
-	}
+	/*
+	 * reserve_pfn_range() doesn't support RAM pages.
+	 */
+	if (is_ram != 0)
+		return -EINVAL;
 
 	ret = reserve_memtype(paddr, paddr + size, want_flags, &flags);
 	if (ret)
@@ -702,7 +709,7 @@ static void free_pfn_range(u64 paddr, un
 {
 	int is_ram;
 
-	is_ram = pagerange_is_ram(paddr, paddr + size);
+	is_ram = pat_pagerange_is_ram(paddr, paddr + size);
 	if (is_ram == 0)
 		free_memtype(paddr, paddr + size);
 }
Index: tip/arch/x86/mm/ioremap.c
===================================================================
--- tip/arch/x86/mm/ioremap.c.orig
+++ tip/arch/x86/mm/ioremap.c
@@ -134,25 +134,6 @@ int page_is_ram(unsigned long pagenr)
 	return 0;
 }
 
-int pagerange_is_ram(unsigned long start, unsigned long end)
-{
-	int ram_page = 0, not_rampage = 0;
-	unsigned long page_nr;
-
-	for (page_nr = (start >> PAGE_SHIFT); page_nr < (end >> PAGE_SHIFT);
-	     ++page_nr) {
-		if (page_is_ram(page_nr))
-			ram_page = 1;
-		else
-			not_rampage = 1;
-
-		if (ram_page == not_rampage)
-			return -1;
-	}
-
-	return ram_page;
-}
-
 /*
  * Fix up the linear direct mapping of the kernel to avoid cache
attribute
  * conflicts.
Index: tip/arch/x86/include/asm/page.h
===================================================================
--- tip/arch/x86/include/asm/page.h.orig
+++ tip/arch/x86/include/asm/page.h
@@ -57,7 +57,6 @@ typedef struct { pgdval_t pgd; } pgd_t;
 typedef struct { pgprotval_t pgprot; } pgprot_t;
 
 extern int page_is_ram(unsigned long pagenr);
-extern int pagerange_is_ram(unsigned long start, unsigned long end);
 extern int devmem_is_allowed(unsigned long pagenr);
 extern void map_devmem(unsigned long pfn, unsigned long size,
 		       pgprot_t vma_prot);


