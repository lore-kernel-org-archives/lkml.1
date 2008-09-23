Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbYIWVqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbYIWVqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYIWVqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:46:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:31554 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbYIWVqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:46:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,295,1220252400"; 
   d="scan'208";a="383619492"
Date: Tue, 23 Sep 2008 14:46:00 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct
Message-ID: <20080923214558.GA13357@linux-os.sc.intel.com>
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.819383000@linux-os.sc.intel.com> <48CBF25B.5030107@goop.org> <20080914132952.GC554@elte.hu> <48CD1D1E.1050906@goop.org> <20080914142213.GA28162@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914142213.GA28162@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 07:22:13AM -0700, Ingo Molnar wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > > it should be defined in include/asm-x86/page.h though, not in
> > > page-flags.h - other architectures are using this flag for other
> > > purposes.
> >
> > No, other shared-use flags are all defined in page-flags.h:
> >
> > enum pageflags {
> > [...]
> >       __NR_PAGEFLAGS,
> >
> >       /* Filesystems */
> >       PG_checked = PG_owner_priv_1,
> >
> >       /* XEN */
> >       PG_pinned = PG_owner_priv_1,
> >       PG_savepinned = PG_dirty,
> >
> >       /* SLOB */
> >       PG_slob_page = PG_active,
> >       PG_slob_free = PG_private,
> >
> >       /* SLUB */
> >       PG_slub_frozen = PG_active,
> >       PG_slub_debug = PG_error,
> > };
> >
> >
> > We could #ifdef CONFIG_X86 just to make it clear we're talking about a
> > specific X86 usage.  But page-flags.h does seem to have become the
> > central authority on all struct page flags usage.
> 
> well, in case of the PG_arch_* flags, they are all defined in
> architecture files:
> 
> ./include/asm-parisc/pgtable.h:#define PG_dcache_dirty         PG_arch_1
> ./include/asm-mips/cacheflush.h:#define PG_dcache_dirty                 PG_arch_1
> ./arch/sparc64/mm/init.c:#define PG_dcache_dirty                PG_arch_1
> ./arch/sh/include/cpu-sh4/cpu/cacheflush.h:#define PG_mapped    PG_arch_1
> ./arch/sh/include/cpu-sh3/cpu/cacheflush.h:#define PG_mapped    PG_arch_1
> ./arch/arm/include/asm/cacheflush.h:#define PG_dcache_dirty PG_arch_1
> 
> they are explicitly reserved for per architecture details.
> 

Below is the updated patch.

Thanks,
Venki

x86: track memtype for RAM in page struct

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: track memtype for RAM in page struct

Track the memtype for RAM pages in page struct instead of using the memtype
list. This avoids the explosion in the number of entries in memtype list
(of the order of 20,000 with AGP) and makes the PAT tracking simpler. We are
using PG_arch_1 bit in page->flags.

We still use the memtype list for non RAM pages.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/ioremap.c        |   19 +++++++++
 arch/x86/mm/pat.c            |   83 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/cacheflush.h |    1 
 include/asm-x86/page.h       |    1 
 4 files changed, 104 insertions(+)

Index: tip/arch/x86/mm/ioremap.c
===================================================================
--- tip.orig/arch/x86/mm/ioremap.c	2008-09-23 13:31:31.000000000 -0700
+++ tip/arch/x86/mm/ioremap.c	2008-09-23 13:32:26.000000000 -0700
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
--- tip.orig/arch/x86/mm/pat.c	2008-09-23 13:31:31.000000000 -0700
+++ tip/arch/x86/mm/pat.c	2008-09-23 13:32:26.000000000 -0700
@@ -211,6 +211,75 @@ static struct memtype *cached_entry;
 static u64 cached_start;
 
 /*
+ * RED-PEN:  TODO: Add PageReserved() check as well here,
+ * once we add SetPageReserved() to all the drivers using
+ * set_memory_* or set_pages_*.
+ *
+ * This will help prevent accidentally freeing pages
+ * before setting the attribute back to WB.
+ */
+
+/*
+ * For RAM pages, mark the pages as non WB memory type using
+ * PG_non_WB (PG_arch_1). We allow only one set_memory_uc() or
+ * set_memory_wc() on a RAM page at a time before marking it as WB again.
+ * This is ok, because only one driver will be owning the page and
+ * doing set_memory_*() calls.
+ *
+ * For now, we use PG_non_WB to track that the RAM page is being mapped
+ * as non WB. In future, we will have to use one more flag
+ * (or some other mechanism in page_struct) to distinguish between
+ * UC and WC mapping.
+ */
+static int reserve_ram_pages_type(u64 start, u64 end, unsigned long req_type,
+		       unsigned long *new_type)
+{
+	struct page *page;
+	u64 pfn, end_pfn;
+
+	for (pfn = (start >> PAGE_SHIFT); pfn < (end >> PAGE_SHIFT); ++pfn) {
+		page = pfn_to_page(pfn);
+		if (page_mapped(page) || test_bit(PG_non_WB, &page->flags))
+			goto out;
+
+		set_bit(PG_non_WB, &page->flags);
+	}
+	return 0;
+
+out:
+	end_pfn = pfn;
+	for (pfn = (start >> PAGE_SHIFT); pfn < end_pfn; ++pfn) {
+		page = pfn_to_page(pfn);
+		clear_bit(PG_non_WB, &page->flags);
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
+		if (page_mapped(page) || !test_bit(PG_non_WB, &page->flags))
+			goto out;
+
+		clear_bit(PG_non_WB, &page->flags);
+	}
+	return 0;
+
+out:
+	end_pfn = pfn;
+	for (pfn = (start >> PAGE_SHIFT); pfn < end_pfn; ++pfn) {
+		page = pfn_to_page(pfn);
+		set_bit(PG_non_WB, &page->flags);
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
--- tip.orig/include/asm-x86/page.h	2008-09-23 13:31:31.000000000 -0700
+++ tip/include/asm-x86/page.h	2008-09-23 13:32:26.000000000 -0700
@@ -57,6 +57,7 @@ typedef struct { pgdval_t pgd; } pgd_t;
 typedef struct { pgprotval_t pgprot; } pgprot_t;
 
 extern int page_is_ram(unsigned long pagenr);
+extern int pagerange_is_ram(unsigned long start, unsigned long end);
 extern int devmem_is_allowed(unsigned long pagenr);
 extern void map_devmem(unsigned long pfn, unsigned long size,
 		       pgprot_t vma_prot);
Index: tip/include/asm-x86/cacheflush.h
===================================================================
--- tip.orig/include/asm-x86/cacheflush.h	2008-09-23 13:32:10.000000000 -0700
+++ tip/include/asm-x86/cacheflush.h	2008-09-23 13:33:06.000000000 -0700
@@ -24,6 +24,7 @@
 #define copy_from_user_page(vma, page, vaddr, dst, src, len)	\
 	memcpy((dst), (src), (len))
 
+#define PG_non_WB				PG_arch_1
 
 /*
  * The set_memory_* API can be used to change various attributes of a virtual
