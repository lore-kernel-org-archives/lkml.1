Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZBJN2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZBJN2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbZBJN2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:28:35 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39735 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbZBJN2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:28:34 -0500
Date: Tue, 10 Feb 2009 13:28:29 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, davem@davemlloft.net,
       heiko.carstens@de.ibm.com, stable@kernel.org
Subject: Re: [BUGFIX][PATCH] Aditional fix for memmap initalization
Message-ID: <20090210132829.GD11649@csn.ul.ie>
References: <200902051729.n15HTsCC000590@imap1.linux-foundation.org> <20090206171724.77c4b5ed.kamezawa.hiroyu@jp.fujitsu.com> <20090206185514.8355c61b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090206185514.8355c61b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 06:55:14PM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 6 Feb 2009 17:17:24 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Thu, 05 Feb 2009 09:29:54 -0800
> > akpm@linux-foundation.org wrote:
> > 
> > > 
> > > The patch titled
> > >      mm: fix memmap init to initialize valid memmap for memory hole
> > > has been added to the -mm tree.  Its filename is
> > >      mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch
> <snip>
> > > The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > Sorry, Kosaki reported me that this patch breaks ia64 compile/boot.
> > So, I'm fixing the bug in cooperation with him, now.
> > I think I can send a fix soon. But I hope this patch set for BOOT will be
> > tested under various arch/configs before going up to.
> > 
> 
> This is an add-on fix. Tested on ia64 DISCONTIGMEM/SPARSEMEM, x86-64 fake-numa.
> 
> The patch mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch
> breaks ia64's compile and boot.
> 
> After investigation, changing return value of early_pfn_to_nid() doesn't seem
> to be very good.

Damn, I thought they looked ok at the time. Clearly I didn't look carefully
enough.

> This patch adds early_pfn_to_nid_solid() for our purpose
> (init memmap) and fixes all breakage.
> 
> Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  arch/ia64/mm/numa.c   |   12 ++++++++++--
>  arch/x86/mm/numa_64.c |    6 +++++-
>  include/linux/mm.h    |    1 +
>  mm/page_alloc.c       |   39 +++++++++++++++++++++++++++++----------
>  4 files changed, 45 insertions(+), 13 deletions(-)
> 
> Index: mmotm-2.6.29-Feb05/include/linux/mm.h
> ===================================================================
> --- mmotm-2.6.29-Feb05.orig/include/linux/mm.h
> +++ mmotm-2.6.29-Feb05/include/linux/mm.h
> @@ -1049,6 +1049,7 @@ extern void work_with_active_regions(int
>  extern void sparse_memory_present_with_active_regions(int nid);
>  #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
>  extern int early_pfn_to_nid(unsigned long pfn);
> +extern int early_pfn_to_solid(unsigned long pfn);

I don't understand for sure what _solid means. I think you might mean the
opposite of "hole" but it's an unusual choice of words and I'm surprised
the boot-init API has to be expanded.

>  #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
>  #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
>  extern void set_dma_reserve(unsigned long new_dma_reserve);
> Index: mmotm-2.6.29-Feb05/arch/ia64/mm/numa.c
> ===================================================================
> --- mmotm-2.6.29-Feb05.orig/arch/ia64/mm/numa.c
> +++ mmotm-2.6.29-Feb05/arch/ia64/mm/numa.c
> @@ -58,7 +58,7 @@ paddr_to_nid(unsigned long paddr)
>   * SPARSEMEM to allocate the SPARSEMEM sectionmap on the NUMA node where
>   * the section resides.
>   */
> -int early_pfn_to_nid(unsigned long pfn)
> +int early_pfn_to_nid_solid(unsigned long pfn)
>  {
>  	int i, section = pfn >> PFN_SECTION_SHIFT, ssec, esec;
>  
> @@ -70,9 +70,17 @@ int early_pfn_to_nid(unsigned long pfn)
>  			return node_memblk[i].nid;
>  	}
>  
> -	return 0;
> +	return -1;
>  }
>  
> +int early_pfn_to_nid(unsigned long pfn)
> +{
> +	int nid = early_pfn_to_nid_solid(pfn);
> +
> +	if (nid < 0) /* see page_alloc.c */
> +		return 0;
> +	return nid;
> +}
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  /*
>   *  SRAT information is stored in node_memblk[], then we can use SRAT
> Index: mmotm-2.6.29-Feb05/arch/x86/mm/numa_64.c
> ===================================================================
> --- mmotm-2.6.29-Feb05.orig/arch/x86/mm/numa_64.c
> +++ mmotm-2.6.29-Feb05/arch/x86/mm/numa_64.c
> @@ -166,10 +166,14 @@ int __init compute_hash_shift(struct boo
>  	return shift;
>  }
>  
> -int early_pfn_to_nid(unsigned long pfn)
> +int early_pfn_to_nid_solid(unsigned long pfn)
>  {
>  	return phys_to_nid(pfn << PAGE_SHIFT);
>  }
> +int early_pfn_to_nid(unsigned long pfn)
> +{
> +	return early_pfn_to_nid_solid(pfn);
> +}
>  
>  static void * __init early_node_mem(int nodeid, unsigned long start,
>  				    unsigned long end, unsigned long size,
> Index: mmotm-2.6.29-Feb05/mm/page_alloc.c
> ===================================================================
> --- mmotm-2.6.29-Feb05.orig/mm/page_alloc.c
> +++ mmotm-2.6.29-Feb05/mm/page_alloc.c
> @@ -2554,6 +2554,21 @@ static inline unsigned long wait_table_b
>   * higher will lead to a bigger reserve which will get freed as contiguous
>   * blocks as reclaim kicks in
>   */
> +#ifdef CONFIG_NODE_SPAN_OTHER_NODE

This is a typo of CONFIG_NODES_SPAN_OTHER_NODES, right?. In other words, it
would appear we are now unconditionally returning true and on systems where
nodes are spanning, we are going to initialise the PFNs twice and have PFNs
belonging to the wrong nodes.

> +static inline bool init_pfn_under_nid(unsigned long pfn, int nid)

This function name is confusing because it doesn't actually init
anything.

> +{
> +	int nid_in_map = early_pfn_to_nid_solid(pfn);
> +
> +	if (nid_in_map == -1)
> +		return true;
> +	return (nid_in_map == nid);
> +}
> +#else
> +static inline bool init_pfn_under_nid(unsigned long pfn, int nid)
> +{
> +	return true;
> +}
> +#endif
>  static void setup_zone_migrate_reserve(struct zone *zone)
>  {
>  	unsigned long start_pfn, pfn, end_pfn;
> @@ -2630,18 +2645,13 @@ void __meminit memmap_init_zone(unsigned
>  		 * exist on hotplugged memory.
>  		 */
>  		if (context == MEMMAP_EARLY) {
> -			int nid_from_node_memory_map;
> -
>  			if (!early_pfn_valid(pfn))
>  				continue;
>  			/*
> -			 * early_pfn_to_nid() returns -1 if the page doesn't
> -			 * exist in early_node_map[]. Initialize it in force
> -			 * and set PG_reserved at el.
> +			 * This returns false if the page exists and it's
> +			 * not under this node.
>  			 */
> -			nid_from_node_memory_map = early_pfn_to_nid(pfn);
> -			if (nid_from_node_memory_map > -1 &&
> -				nid_from_node_memory_map != nid)
> +			if (!init_pfn_under_nid(pfn, nid))
>  				continue;
>  		}
>  		page = pfn_to_page(pfn);
> @@ -2996,7 +3006,7 @@ static int __meminit next_active_region_
>   * was used and there are no special requirements, this is a convenient
>   * alternative
>   */
> -int __meminit early_pfn_to_nid(unsigned long pfn)
> +int __meminit early_pfn_to_nid_solid(unsigned long pfn)
>  {
>  	int i;
>  
> @@ -3007,9 +3017,18 @@ int __meminit early_pfn_to_nid(unsigned 
>  		if (start_pfn <= pfn && pfn < end_pfn)
>  			return early_node_map[i].nid;
>  	}
> -
>  	return -1;
>  }
> +/* Allow fallback to 0 */
> +int __meminit early_pfn_to_nid(unsigned long pfn)
> +{
> +	int nid;
> +
> +	nid = early_pfn_to_nid_solid(pfn);
> +	if (nid < 0)
> +		return 0;
> +	return nid;
> +}
>  #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
>  
>  /* Basic iterator support to walk early_node_map[] */
> 

It feels like we are changing more than we need to. Could we achieve the same
fix by just altering early_pfn_in_nid() to return true if the PFN matches
the NID or is in a hole and ok to initialise.  Something like this patch maybe?

=====
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 09c14e2..c3140df 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1070,11 +1070,7 @@ void sparse_init(void);
 #define sparse_index_init(_sec, _nid)  do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
-#ifdef CONFIG_NODES_SPAN_OTHER_NODES
-#define early_pfn_in_nid(pfn, nid)	(early_pfn_to_nid(pfn) == (nid))
-#else
-#define early_pfn_in_nid(pfn, nid)	(1)
-#endif
+int __meminit early_pfn_in_nid(unsigned long pfn, int nid);
 
 #ifndef early_pfn_valid
 #define early_pfn_valid(pfn)	(1)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5675b30..708837e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3005,6 +3005,34 @@ int __meminit early_pfn_to_nid(unsigned long pfn)
 }
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
+#ifdef CONFIG_NODES_SPAN_OTHER_NODES
+/*
+ * Returns true if the PFN is within the NID or it is within a hole.
+ * If the PFN is in a hole, we still initialise the memmap so that
+ * walkers of the memmap do not get confused
+ */
+int __meminit early_pfn_in_nid(unsigned long pfn, int nid)
+{
+	int i;
+
+	for (i = 0; i < nr_nodemap_entries; i++) {
+		unsigned long start_pfn = early_node_map[i].start_pfn;
+		unsigned long end_pfn = early_node_map[i].end_pfn;
+
+		if (start_pfn <= pfn && pfn < end_pfn)
+			return early_node_map[i].nid == nid;
+	}
+
+	/* The PFN is within a hole so it'll be ok to initialise */
+	return 1;
+}
+#else
+int __meminit early_pfn_in_nid(unsigned long pfn, int nid)
+{
+	return 1;
+}
+#endif
+
 /* Basic iterator support to walk early_node_map[] */
 #define for_each_active_range_index_in_nid(i, nid) \
 	for (i = first_active_region_index_in_nid(nid); i != -1; \

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
