Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYBLVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYBLVyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYBLVyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:54:15 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49464 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYBLVyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:54:13 -0500
Subject: Re: [-mm PATCH] register_memory/unregister_memory clean ups
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, greg@kroah.com,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <1202849972.11188.71.camel@nimitz.home.sr71.net>
References: <20080211114818.74c9dcc7.akpm@linux-foundation.org>
	 <1202765553.25604.12.camel@dyn9047017100.beaverton.ibm.com>
	 <20080212154309.F9DA.Y-GOTO@jp.fujitsu.com>
	 <1202836953.25604.42.camel@dyn9047017100.beaverton.ibm.com>
	 <1202849972.11188.71.camel@nimitz.home.sr71.net>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 13:56:55 -0800
Message-Id: <1202853415.25604.59.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 12:59 -0800, Dave Hansen wrote:
> On Tue, 2008-02-12 at 09:22 -0800, Badari Pulavarty wrote:
> > +static void __remove_section(struct zone *zone, unsigned long phys_start_pfn)
> > +{
> > +	if (!pfn_valid(phys_start_pfn))
> > +		return;
> 
> I think you need at least a WARN_ON() there.  
> 
> I'd probably also not use pfn_valid(), personally.  
> 
> > +	unregister_memory_section(__pfn_to_section(phys_start_pfn));
> > +	__remove_zone(zone, phys_start_pfn);
> > +	sparse_remove_one_section(zone, phys_start_pfn, PAGES_PER_SECTION);
> > +}
> 
> Can none of this ever fail?
> 
> I also think having a function called __remove_section() that takes a
> pfn is a bad idea.  How about passing an actual 'struct mem_section *'
> into it?  One of the reasons I even made that structure was so that you
> could hand it around to things and never be confused about pfn vs. paddr
> vs. vaddr vs. section_nr.  Please use it.

Yes. I got similar feedback from Andy. I was closely trying to mimic
__add_pages() for easy review/understanding.

I have an updated version (not fully tested) which takes section_nr as
argument instead of playing with pfns. Please review this one and see if
it matches your taste :)

> 
> >  /*
> >   * Reasonably generic function for adding memory.  It is
> >   * expected that archs that support memory hotplug will
> > @@ -135,6 +153,21 @@ int __add_pages(struct zone *zone, unsig
> >  }
> >  EXPORT_SYMBOL_GPL(__add_pages);
> > 
> > +void __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
> > +		 unsigned long nr_pages)
> > +{
> > +	unsigned long i;
> > +	int start_sec, end_sec;
> > +
> > +	start_sec = pfn_to_section_nr(phys_start_pfn);
> > +	end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
> > +
> > +	for (i = start_sec; i <= end_sec; i++)
> > +		__remove_section(zone, i << PFN_SECTION_SHIFT);
> > +
> > +}
> > +EXPORT_SYMBOL_GPL(__remove_pages);
> 
> I'd like to see some warnings in there if nr_pages or phys_start_pfn are
> not section-aligned and some other sanity checks.  If someone is trying
> to remove non-section-aligned areas, we either have something wrong, or
> some other work to do, first keeping track of what section portions are
> "removed".
> 

Yes. I did most of this already (thanks for pointing out again).


> > +void sparse_remove_one_section(struct zone *zone, unsigned long start_pfn,
> > +			   int nr_pages)
..
> 
> > +		usemap = ms->pageblock_flags;
> > +		memmap = sparse_decode_mem_map((unsigned long)memmap,
> > +				section_nr);
> > +		ms->section_mem_map = 0;
> > +		ms->pageblock_flags = NULL;
> > +	}
> > +	pgdat_resize_unlock(pgdat, &flags);
> 
> Ugh.  Please put this in its own helper.  Also, sparse_decode_mem_map()
> has absolutely no other users.  Please modify it so that you don't have
> to do this gunk, like put the '& SECTION_MAP_MASK' in there.  You
> probably just need:
> 
> struct page *sparse_decode_mem_map(unsigned long coded_mem_map, unsigned long pnum)
> {
> 	/*
> 	 * mask off the extra low bits of information
> 	 */
> 	coded_mem_map &= SECTION_MAP_MASK;
>         return ((struct page *)coded_mem_map) + section_nr_to_pfn(pnum);
> }
> 
> Then, you can just do this:
> 
> 	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
> 
> No casting, no temp variables.  *PLEASE* look around at things and feel
> free to modify to modify them.  Otherwise, it'll just become a mess.
> (oh, and get rid of the unused attribute on it).

Good suggestion. 

> 
> > +
> > +	/*
> > +	 * Its ugly, but this is the best I can do - HELP !!
> > +	 * We don't know where the allocations for section memmap and usemap
> > +	 * came from. If they are allocated at the boot time, they would come
> > +	 * from bootmem. If they are added through hot-memory-add they could be
> > +	 * from sla or vmalloc. If they are allocated as part of hot-mem-add
> > +	 * free them up properly. If they are allocated at boot, no easy way
> > +	 * to correctly free them :(
> > +	 */
> > +	if (usemap) {
> > +		if (PageSlab(virt_to_page(usemap))) {
> > +			kfree(usemap);
> > +			if (memmap)
> > +				__kfree_section_memmap(memmap, nr_pages);
> > +		}
> > +	}
> > +}
> 
> Do what we did with the memmap and store some of its origination
> information in the low bits.

Hmm. my understand of memmap is limited. Can you help me out here ?
I was trying to use free_bootmem_node() to free up the allocations,
but I need nodeid from which allocation came from :(

Here is the updated (currently testing) patch.

Thanks,
Badari

Generic helper function to remove section mappings and sysfs entries
for the section of the memory we are removing.  offline_pages() correctly 
adjusted zone and marked the pages reserved.

Issue: If mem_map, usemap allocation could come from different places -
kmalloc, vmalloc, alloc_pages or bootmem. There is no easy way
to find and free up properly. Especially for bootmem, we need to
know which node the allocation came from.

---
 include/linux/memory_hotplug.h |    4 +++
 mm/memory_hotplug.c            |   30 ++++++++++++++++++++++++++++
 mm/sparse.c                    |   43 ++++++++++++++++++++++++++++++++++++++---
 3 files changed, 74 insertions(+), 3 deletions(-)

Index: linux-2.6.24/mm/memory_hotplug.c
===================================================================
--- linux-2.6.24.orig/mm/memory_hotplug.c	2008-02-07 17:16:52.000000000 -0800
+++ linux-2.6.24/mm/memory_hotplug.c	2008-02-12 13:35:52.000000000 -0800
@@ -102,6 +102,15 @@ static int __add_section(struct zone *zo
 	return register_new_memory(__pfn_to_section(phys_start_pfn));
 }
 
+static void __remove_section(struct zone *zone, unsigned long section_nr)
+{
+	if (!valid_section_nr(section_nr))
+		return;
+
+	unregister_memory_section(__nr_to_section(section_nr));
+	sparse_remove_one_section(zone, section_nr);
+}
+
 /*
  * Reasonably generic function for adding memory.  It is
  * expected that archs that support memory hotplug will
@@ -135,6 +144,27 @@ int __add_pages(struct zone *zone, unsig
 }
 EXPORT_SYMBOL_GPL(__add_pages);
 
+void __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
+		 unsigned long nr_pages)
+{
+	unsigned long i;
+	int sections_to_remove;
+
+	/*
+	 * We can only remove entire sections
+	 */
+	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
+	BUG_ON(nr_pages % PAGES_PER_SECTION);
+
+	sections_to_remove = nr_pages / PAGES_PER_SECTION;
+
+	for (i = 0; i < sections_to_remove; i++) {
+		unsigned long pfn = phys_start_pfn + i*PAGES_PER_SECTION;
+		__remove_section(zone, pfn_to_section_nr(pfn));
+	}
+}
+EXPORT_SYMBOL_GPL(__remove_pages);
+
 static void grow_zone_span(struct zone *zone,
 		unsigned long start_pfn, unsigned long end_pfn)
 {
Index: linux-2.6.24/mm/sparse.c
===================================================================
--- linux-2.6.24.orig/mm/sparse.c	2008-02-07 17:16:52.000000000 -0800
+++ linux-2.6.24/mm/sparse.c	2008-02-12 13:40:58.000000000 -0800
@@ -198,12 +198,13 @@ static unsigned long sparse_encode_mem_m
 }
 
 /*
- * We need this if we ever free the mem_maps.  While not implemented yet,
- * this function is included for parity with its sibling.
+ * Decode mem_map from the coded memmap
  */
-static __attribute((unused))
+static
 struct page *sparse_decode_mem_map(unsigned long coded_mem_map, unsigned long pnum)
 {
+	/* mask off the extra low bits of information */
+	coded_mem_map &= SECTION_MAP_MASK;
 	return ((struct page *)coded_mem_map) + section_nr_to_pfn(pnum);
 }
 
@@ -415,4 +416,40 @@ out:
 	}
 	return ret;
 }
+
+void sparse_remove_one_section(struct zone *zone, unsigned long section_nr)
+{
+	struct pglist_data *pgdat = zone->zone_pgdat;
+	struct mem_section *ms;
+	struct page *memmap = NULL;
+	unsigned long *usemap = NULL;
+	unsigned long flags;
+
+	pgdat_resize_lock(pgdat, &flags);
+	ms = __nr_to_section(section_nr);
+	if (ms->section_mem_map) {
+		usemap = ms->pageblock_flags;
+		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
+		ms->section_mem_map = 0;
+		ms->pageblock_flags = NULL;
+	}
+	pgdat_resize_unlock(pgdat, &flags);
+
+	/*
+	 * Its ugly, but this is the best I can do - HELP !!
+	 * We don't know where the allocations for section memmap and usemap
+	 * came from. If they are allocated at the boot time, they would come
+	 * from bootmem. If they are added through hot-memory-add they could be
+	 * from slab, vmalloc. If they are allocated as part of hot-mem-add
+	 * free them up properly. If they are allocated at boot, no easy way
+	 * to correctly free them :(
+	 */
+	if (usemap) {
+		if (PageSlab(virt_to_page(usemap))) {
+			kfree(usemap);
+			if (memmap)
+				__kfree_section_memmap(memmap, PAGES_PER_SECTION);
+		}
+	}
+}
 #endif
Index: linux-2.6.24/include/linux/memory_hotplug.h
===================================================================
--- linux-2.6.24.orig/include/linux/memory_hotplug.h	2008-02-07 17:16:52.000000000 -0800
+++ linux-2.6.24/include/linux/memory_hotplug.h	2008-02-12 13:37:47.000000000 -0800
@@ -64,6 +64,8 @@ extern int offline_pages(unsigned long, 
 /* reasonably generic interface to expand the physical pages in a zone  */
 extern int __add_pages(struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
+extern void __remove_pages(struct zone *zone, unsigned long start_pfn,
+	unsigned long nr_pages);
 
 /*
  * Walk thorugh all memory which is registered as resource.
@@ -188,5 +190,7 @@ extern int arch_add_memory(int nid, u64 
 extern int remove_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 								int nr_pages);
+extern void sparse_remove_one_section(struct zone *zone,
+					unsigned long section_nr);
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */


