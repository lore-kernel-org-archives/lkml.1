Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYHUULw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYHUULw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYHUULl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:11:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:30022 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbYHUULi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VImzIi/tG2oAGjT1izymwaBsSNL9QEU+KezTu/R1dhZFDPAguDkUB+NdCSA224Qnju
         Oq5cj6kenY0/YujcjyZNWyjCMbMGqSzK7JwQrp4/VpgC3p3hp0Ec9Z/FuW44gjPihybq
         M5DjRw+a+LFJATEarEUBDV6am27e9qwHDmyNo=
Date: Thu, 21 Aug 2008 22:10:23 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Sean MacLennan <smaclennan@pikatech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Section mismatch contig_page_data and bootmem_node_data
Message-ID: <20080821201002.GA6321@joi>
References: <20080820135551.74911cb3@lappy.seanm.ca> <20080820190436.GA5388@joi> <20080820151531.38fc1071@lappy.seanm.ca> <87myj74azn.fsf@skyscraper.fehenstaub.lan> <20080821000844.GA10031@joi> <873aky4zk7.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873aky4zk7.fsf@skyscraper.fehenstaub.lan>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 09:06:32AM +0200, Johannes Weiner wrote:
> Marcin Slusarz <marcin.slusarz@gmail.com> writes:
> 
> > On Wed, Aug 20, 2008 at 11:45:00PM +0200, Johannes Weiner wrote:
> >> Hi,
> >> 
> >> > On Wed, 20 Aug 2008 21:05:41 +0200
> >> > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> >> >
> >> >> I thought about this warning today and found 2 other solutions:
> >> >> 1) Mark contig_page_data as __ref (but it might hide real bugs).
> >> >> 2) Remove bdata from struct pglist_data and access it directly through
> >> >>    bootmem_node_data. It requires passing node number to all functions
> >> >>    which use bdata, but unfortunately arch/ia64/mm/discontig.c handles
> >> >>    node numbering its own way. I'm still investigating it.
> >> 
> >> Yeah, I gave it a shot once too but dropped it again after I looked at
> >> ia64 code.
> >> 
> >> Perhaps we can just remove the static assignment and do it at boot up?
> >
> > That won't work - modpost will warn at different place about section
> > mismatch. But even if it would work, we lose potentially useful
> > analysis of all uses of pglist_data->bdata.
> 
> Right, but the current way of handling things completely circumvents the
> section checking, no?

Yes.
 
> > But I think I found better solution - replace "struct bootmem_data *bdata"
> > in struct pglist_data with "int bootmem_node;" and change all uses of bdata
> > to &bootmem_node_data[struct pglist_data *->bootmem_node].
> 
> Good idea.  You don't even need a new number here, pgdat->node_id should
> be usable out of the box to index into the bdata array.

I'm not sure node_id is always initialized properly in case on ia64/discontig
code. node_id is changed in only one place - free_area_init_node, but I'm not
sure whether this code is called for pgdat_list entries...

Below is a patch which implements original approach (does not reuse node_id).
(Compile and boot tested only on x86-64).
---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] bootmem: don't embed bootmem_data in pglist_data

Replace direct pointer from struct pglist_data to struct bootmem_data
with index into bootmem_node_data.

As bootmem_node_data are discarded after bootup this change allows
more fine-grained analysis of access to bootmem data - every access
to bootmem_node_data from non-__init function will now emit section
mismatch warning.

This patch fixes following section mismatch warning:
WARNING: vmlinux.o(.data+0x1f5c0): Section mismatch in reference from the variable contig_page_data to the variable .init.data:bootmem_node_data
The variable contig_page_data references
the variable __initdata bootmem_node_data
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
---
 arch/alpha/mm/numa.c             |    5 +++--
 arch/arm/mm/discontig.c          |   32 ++++++++++++++++----------------
 arch/arm/plat-omap/fb.c          |    2 +-
 arch/avr32/mm/init.c             |    5 +++--
 arch/ia64/mm/discontig.c         |    5 ++---
 arch/ia64/mm/init.c              |    2 +-
 arch/m32r/mm/discontig.c         |    6 +++---
 arch/m32r/mm/init.c              |    4 ++--
 arch/m68k/mm/init.c              |    2 +-
 arch/mips/sgi-ip27/ip27-memory.c |    2 +-
 arch/mn10300/mm/init.c           |    9 ++++-----
 arch/parisc/mm/init.c            |    2 +-
 arch/powerpc/mm/numa.c           |    2 +-
 arch/sh/mm/init.c                |    5 +++--
 arch/sh/mm/numa.c                |    4 ++--
 arch/sparc64/mm/init.c           |    2 +-
 arch/x86/mm/discontig_32.c       |    2 +-
 arch/x86/mm/numa_64.c            |    2 +-
 include/linux/mmzone.h           |    4 +++-
 mm/bootmem.c                     |   30 +++++++++++++++++++-----------
 mm/page_alloc.c                  |    2 +-
 21 files changed, 70 insertions(+), 59 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 443bc7c..f9c49cb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -527,7 +527,7 @@ typedef struct pglist_data {
 #ifdef CONFIG_FLAT_NODE_MEM_MAP
 	struct page *node_mem_map;
 #endif
-	struct bootmem_data *bdata;
+	int bootmem_node_id;
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/*
 	 * Must be held any time you expect node_start_pfn, node_present_pages
@@ -548,6 +548,8 @@ typedef struct pglist_data {
 	int kswapd_max_order;
 } pg_data_t;
 
+#define BOOTMEM_NODE_DATA(pgdat) (&bootmem_node_data[pgdat->bootmem_node_id])
+
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
 #define node_spanned_pages(nid)	(NODE_DATA(nid)->node_spanned_pages)
 #ifdef CONFIG_FLAT_NODE_MEM_MAP
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index af982f7..fefeacd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4064,7 +4064,7 @@ void __init set_dma_reserve(unsigned long new_dma_reserve)
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-struct pglist_data contig_page_data = { .bdata = &bootmem_node_data[0] };
+struct pglist_data contig_page_data = { .bootmem_node_id = 0 };
 EXPORT_SYMBOL(contig_page_data);
 #endif
 
diff --git a/arch/alpha/mm/numa.c b/arch/alpha/mm/numa.c
index a13de49..5436a19 100644
--- a/arch/alpha/mm/numa.c
+++ b/arch/alpha/mm/numa.c
@@ -140,13 +140,14 @@ setup_memory_node(int nid, void *kernel_end)
 		printk(" not enough mem to reserve NODE_DATA");
 		return;
 	}
-	NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
+	NODE_DATA(nid)->bootmem_node_id = nid;
 
 	printk(" Detected node memory:   start %8lu, end %8lu\n",
 	       node_min_pfn, node_max_pfn);
 
 	DBGDCONT(" DISCONTIG: node_data[%d]   is at 0x%p\n", nid, NODE_DATA(nid));
-	DBGDCONT(" DISCONTIG: NODE_DATA(%d)->bdata is at 0x%p\n", nid, NODE_DATA(nid)->bdata);
+	DBGDCONT(" DISCONTIG: NODE_DATA(%d)->bdata is at 0x%p\n", nid,
+			BOOTMEM_NODE_DATA(NODE_DATA(nid)));
 
 	/* Find the bounds of kernel memory.  */
 	start_kernel_pfn = PFN_DOWN(KERNEL_START_PHYS);
diff --git a/arch/arm/mm/discontig.c b/arch/arm/mm/discontig.c
index c8c0c4b..5876611 100644
--- a/arch/arm/mm/discontig.c
+++ b/arch/arm/mm/discontig.c
@@ -22,23 +22,23 @@
  */
 
 pg_data_t discontig_node_data[MAX_NUMNODES] = {
-  { .bdata = &bootmem_node_data[0] },
-  { .bdata = &bootmem_node_data[1] },
-  { .bdata = &bootmem_node_data[2] },
-  { .bdata = &bootmem_node_data[3] },
+  { .bootmem_node_id = 0 },
+  { .bootmem_node_id = 1 },
+  { .bootmem_node_id = 2 },
+  { .bootmem_node_id = 3 },
 #if MAX_NUMNODES == 16
-  { .bdata = &bootmem_node_data[4] },
-  { .bdata = &bootmem_node_data[5] },
-  { .bdata = &bootmem_node_data[6] },
-  { .bdata = &bootmem_node_data[7] },
-  { .bdata = &bootmem_node_data[8] },
-  { .bdata = &bootmem_node_data[9] },
-  { .bdata = &bootmem_node_data[10] },
-  { .bdata = &bootmem_node_data[11] },
-  { .bdata = &bootmem_node_data[12] },
-  { .bdata = &bootmem_node_data[13] },
-  { .bdata = &bootmem_node_data[14] },
-  { .bdata = &bootmem_node_data[15] },
+  { .bootmem_node_id = 4 },
+  { .bootmem_node_id = 5 },
+  { .bootmem_node_id = 6 },
+  { .bootmem_node_id = 7 },
+  { .bootmem_node_id = 8 },
+  { .bootmem_node_id = 9 },
+  { .bootmem_node_id = 10 },
+  { .bootmem_node_id = 11 },
+  { .bootmem_node_id = 12 },
+  { .bootmem_node_id = 13 },
+  { .bootmem_node_id = 14 },
+  { .bootmem_node_id = 15 },
 #endif
 };
 
diff --git a/arch/arm/plat-omap/fb.c b/arch/arm/plat-omap/fb.c
index 17a92a3..8df8094 100644
--- a/arch/arm/plat-omap/fb.c
+++ b/arch/arm/plat-omap/fb.c
@@ -181,7 +181,7 @@ void __init omapfb_reserve_sdram(void)
 	if (config_invalid)
 		return;
 
-	bdata = NODE_DATA(0)->bdata;
+	bdata = BOOTMEM_NODE_DATA(NODE_DATA(0));
 	sdram_start = bdata->node_min_pfn << PAGE_SHIFT;
 	sdram_size = (bdata->node_low_pfn << PAGE_SHIFT) - sdram_start;
 	reserved = 0;
diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index fa92ff6..b3a39aa 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -80,8 +80,9 @@ void __init paging_init(void)
 		unsigned long zones_size[MAX_NR_ZONES];
 		unsigned long low, start_pfn;
 
-		start_pfn = pgdat->bdata->node_min_pfn;
-		low = pgdat->bdata->node_low_pfn;
+		bootmem_data_t *bdata = BOOTMEM_NODE_DATA(pgdat);
+		start_pfn = bdata->node_min_pfn;
+		low = bdata->node_low_pfn;
 
 		memset(zones_size, 0, sizeof(zones_size));
 		zones_size[ZONE_NORMAL] = low - start_pfn;
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index 78026aa..3c7430d 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -170,7 +170,6 @@ static void __init fill_pernode(int node, unsigned long pernode,
 {
 	void *cpu_data;
 	int cpus = early_nr_cpus_node(node);
-	struct bootmem_data *bdp = &bootmem_node_data[node];
 
 	mem_data[node].pernode_addr = pernode;
 	mem_data[node].pernode_size = pernodesize;
@@ -186,7 +185,7 @@ static void __init fill_pernode(int node, unsigned long pernode,
 	mem_data[node].node_data = __va(pernode);
 	pernode += L1_CACHE_ALIGN(sizeof(struct ia64_node_data));
 
-	pgdat_list[node]->bdata = bdp;
+	pgdat_list[node]->bootmem_node_id = node;
 	pernode += L1_CACHE_ALIGN(sizeof(pg_data_t));
 
 	cpu_data = per_cpu_node_setup(cpu_data, node);
@@ -298,7 +297,7 @@ static void __init reserve_pernode_space(void)
 		if (node_isset(node, memory_less_mask))
 			continue;
 
-		bdp = pdp->bdata;
+		bdp = BOOTMEM_NODE_DATA(pdp);
 
 		/* First the bootmem_map itself */
 		pages = bdp->node_low_pfn - bdp->node_min_pfn;
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 200100e..f207b59 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -646,7 +646,7 @@ mem_init (void)
 	kclist_add(&kcore_kernel, _stext, _end - _stext);
 
 	for_each_online_pgdat(pgdat)
-		if (pgdat->bdata->node_bootmem_map)
+		if (BOOTMEM_NODE_DATA(pgdat)->node_bootmem_map)
 			totalram_pages += free_all_bootmem_node(pgdat);
 
 	reserved_pages = 0;
diff --git a/arch/m32r/mm/discontig.c b/arch/m32r/mm/discontig.c
index cbc3c4c..f2b8fbd 100644
--- a/arch/m32r/mm/discontig.c
+++ b/arch/m32r/mm/discontig.c
@@ -80,7 +80,7 @@ unsigned long __init setup_memory(void)
 	for_each_online_node(nid) {
 		mp = &mem_prof[nid];
 		NODE_DATA(nid)=(pg_data_t *)&m32r_node_data[nid];
-		NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
+		NODE_DATA(nid)->bootmem_node_id = nid;
 		min_pfn = mp->start_pfn;
 		max_pfn = mp->start_pfn + mp->pages;
 		bootmap_size = init_bootmem_node(NODE_DATA(nid), mp->free_pfn,
@@ -123,8 +123,8 @@ unsigned long __init setup_memory(void)
 	return max_low_pfn;
 }
 
-#define START_PFN(nid)		(NODE_DATA(nid)->bdata->node_min_pfn)
-#define MAX_LOW_PFN(nid)	(NODE_DATA(nid)->bdata->node_low_pfn)
+#define START_PFN(nid)   (BOOTMEM_NODE_DATA(NODE_DATA(nid))->node_min_pfn)
+#define MAX_LOW_PFN(nid) (BOOTMEM_NODE_DATA(NODE_DATA(nid))->node_low_pfn)
 
 unsigned long __init zone_sizes_init(void)
 {
diff --git a/arch/m32r/mm/init.c b/arch/m32r/mm/init.c
index 24d429f..431beca 100644
--- a/arch/m32r/mm/init.c
+++ b/arch/m32r/mm/init.c
@@ -57,8 +57,8 @@ void free_initrd_mem(unsigned long, unsigned long);
 #endif
 
 /* It'd be good if these lines were in the standard header file. */
-#define START_PFN(nid)		(NODE_DATA(nid)->bdata->node_min_pfn)
-#define MAX_LOW_PFN(nid)	(NODE_DATA(nid)->bdata->node_low_pfn)
+#define START_PFN(nid)   (BOOTMEM_NODE_DATA(NODE_DATA(nid))->node_min_pfn)
+#define MAX_LOW_PFN(nid) (BOOTMEM_NODE_DATA(NODE_DATA(nid))->node_low_pfn)
 
 #ifndef CONFIG_DISCONTIGMEM
 unsigned long __init zone_sizes_init(void)
diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index 81bb08c..a4182f8 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -56,7 +56,7 @@ void __init m68k_setup_node(int node)
 		pg_data_table[i] = pg_data_map + node;
 	}
 #endif
-	pg_data_map[node].bdata = bootmem_node_data + node;
+	pg_data_map[node].bootmem_node_id = node;
 	node_set_online(node);
 }
 
diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
index 060d853..66d440e 100644
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -401,7 +401,7 @@ static void __init node_mem_init(cnodeid_t node)
 	 */
 	__node_data[node] = __va(slot_freepfn << PAGE_SHIFT);
 
-	NODE_DATA(node)->bdata = &bootmem_node_data[node];
+	NODE_DATA(node)->bootmem_node_id = node;
 	NODE_DATA(node)->node_start_pfn = start_pfn;
 	NODE_DATA(node)->node_spanned_pages = end_pfn - start_pfn;
 
diff --git a/arch/mn10300/mm/init.c b/arch/mn10300/mm/init.c
index 8cee387..8235f5c 100644
--- a/arch/mn10300/mm/init.c
+++ b/arch/mn10300/mm/init.c
@@ -49,6 +49,7 @@ void __init paging_init(void)
 	unsigned long zones_size[MAX_NR_ZONES] = {0,};
 	pte_t *ppte;
 	int loop;
+	bootmem_data_t *bdata = BOOTMEM_NODE_DATA(&contig_page_data);
 
 	/* main kernel space -> RAM mapping is handled as 1:1 transparent by
 	 * the MMU */
@@ -66,9 +67,7 @@ void __init paging_init(void)
 	}
 
 	/* declare the sizes of the RAM zones (only use the normal zone) */
-	zones_size[ZONE_NORMAL] =
-		contig_page_data.bdata->node_low_pfn -
-		contig_page_data.bdata->node_min_pfn;
+	zones_size[ZONE_NORMAL] = bdata->node_low_pfn - bdata->node_min_pfn;
 
 	/* pass the memory from the bootmem allocator to the main allocator */
 	free_area_init(zones_size);
@@ -87,8 +86,8 @@ void __init mem_init(void)
 	if (!mem_map)
 		BUG();
 
-#define START_PFN	(contig_page_data.bdata->node_min_pfn)
-#define MAX_LOW_PFN	(contig_page_data.bdata->node_low_pfn)
+#define START_PFN   (BOOTMEM_NODE_DATA(&contig_page_data)->node_min_pfn)
+#define MAX_LOW_PFN (BOOTMEM_NODE_DATA(&contig_page_data)->node_low_pfn)
 
 	max_mapnr = num_physpages = MAX_LOW_PFN - START_PFN;
 	high_memory = (void *) __va(MAX_LOW_PFN * PAGE_SIZE);
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 7c155c2..cb89f02 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -261,7 +261,7 @@ static void __init setup_bootmem(void)
 #ifdef CONFIG_DISCONTIGMEM
 	for (i = 0; i < MAX_PHYSMEM_RANGES; i++) {
 		memset(NODE_DATA(i), 0, sizeof(pg_data_t));
-		NODE_DATA(i)->bdata = &bootmem_node_data[i];
+		NODE_DATA(i)->bootmem_node_id = i;
 	}
 	memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
 
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index d9a1813..cfcdb42 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -815,7 +815,7 @@ void __init do_init_bootmem(void)
   		dbg("node %d\n", nid);
 		dbg("NODE_DATA() = %p\n", NODE_DATA(nid));
 
-		NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
+		NODE_DATA(nid)->bootmem_node_id = nid;
 		NODE_DATA(nid)->node_start_pfn = start_pfn;
 		NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
 
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index b75a7ac..74745f1 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -149,9 +149,10 @@ void __init paging_init(void)
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 		unsigned long low, start_pfn;
+		bootmem_data_t *bdata = BOOTMEM_NODE_DATA(pgdat);
 
-		start_pfn = pgdat->bdata->node_min_pfn;
-		low = pgdat->bdata->node_low_pfn;
+		start_pfn = bdata->node_min_pfn;
+		low = bdata->node_low_pfn;
 
 		if (max_zone_pfns[ZONE_NORMAL] < low)
 			max_zone_pfns[ZONE_NORMAL] = low;
diff --git a/arch/sh/mm/numa.c b/arch/sh/mm/numa.c
index 095d93b..48e4878 100644
--- a/arch/sh/mm/numa.c
+++ b/arch/sh/mm/numa.c
@@ -34,7 +34,7 @@ void __init setup_memory(void)
 	NODE_DATA(0) = pfn_to_kaddr(free_pfn);
 	memset(NODE_DATA(0), 0, sizeof(struct pglist_data));
 	free_pfn += PFN_UP(sizeof(struct pglist_data));
-	NODE_DATA(0)->bdata = &bootmem_node_data[0];
+	NODE_DATA(0)->bootmem_node_id = 0;
 
 	/* Set up node 0 */
 	setup_bootmem_allocator(free_pfn);
@@ -65,7 +65,7 @@ void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end)
 	free_pfn += PFN_UP(sizeof(struct pglist_data));
 	memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
 
-	NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
+	NODE_DATA(nid)->bootmem_node_id = nid;
 	NODE_DATA(nid)->node_start_pfn = start_pfn;
 	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
 
diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
index b4aeb0f..43ea6dc 100644
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -829,7 +829,7 @@ static void __init allocate_node_data(int nid)
 	NODE_DATA(nid) = __va(paddr);
 	memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
 
-	NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
+	NODE_DATA(nid)->bootmem_node_id = nid;
 #endif
 
 	p = NODE_DATA(nid);
diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index 62fa440..76e95af 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -384,7 +384,7 @@ void __init initmem_init(unsigned long start_pfn,
 	for_each_online_node(nid)
 		memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
 
-	NODE_DATA(0)->bdata = &bootmem_node_data[0];
+	NODE_DATA(0)->bootmem_node_id = 0;
 	setup_bootmem_allocator();
 }
 
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index a4dd793..cebd2e3 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -196,7 +196,7 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 		nodedata_phys + pgdat_size - 1);
 
 	memset(NODE_DATA(nodeid), 0, sizeof(pg_data_t));
-	NODE_DATA(nodeid)->bdata = &bootmem_node_data[nodeid];
+	NODE_DATA(nodeid)->bootmem_node_id = nodeid;
 	NODE_DATA(nodeid)->node_start_pfn = start_pfn;
 	NODE_DATA(nodeid)->node_spanned_pages = last_pfn - start_pfn;
 
diff --git a/mm/bootmem.c b/mm/bootmem.c
index ad8eec6..d9a06ee 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -125,7 +125,8 @@ static unsigned long __init init_bootmem_core(bootmem_data_t *bdata,
 unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,
 				unsigned long startpfn, unsigned long endpfn)
 {
-	return init_bootmem_core(pgdat->bdata, freepfn, startpfn, endpfn);
+	return init_bootmem_core(BOOTMEM_NODE_DATA(pgdat),
+				freepfn, startpfn, endpfn);
 }
 
 /**
@@ -137,9 +138,10 @@ unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,
  */
 unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 {
+	bootmem_data_t *bdata =	BOOTMEM_NODE_DATA(NODE_DATA(0));
 	max_low_pfn = pages;
 	min_low_pfn = start;
-	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
+	return init_bootmem_core(bdata, start, 0, pages);
 }
 
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
@@ -211,8 +213,9 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
  */
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
+	bootmem_data_t *bdata = BOOTMEM_NODE_DATA(pgdat);
 	register_page_bootmem_info_node(pgdat);
-	return free_all_bootmem_core(pgdat->bdata);
+	return free_all_bootmem_core(bdata);
 }
 
 /**
@@ -222,7 +225,8 @@ unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
  */
 unsigned long __init free_all_bootmem(void)
 {
-	return free_all_bootmem_core(NODE_DATA(0)->bdata);
+	bootmem_data_t *bdata = BOOTMEM_NODE_DATA(NODE_DATA(0));
+	return free_all_bootmem_core(bdata);
 }
 
 static void __init __free(bootmem_data_t *bdata,
@@ -334,11 +338,12 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 			      unsigned long size)
 {
 	unsigned long start, end;
+	bootmem_data_t *bdata = BOOTMEM_NODE_DATA(pgdat);
 
 	start = PFN_UP(physaddr);
 	end = PFN_DOWN(physaddr + size);
 
-	mark_bootmem_node(pgdat->bdata, start, end, 0, 0);
+	mark_bootmem_node(bdata, start, end, 0, 0);
 }
 
 /**
@@ -375,11 +380,12 @@ int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
 	unsigned long start, end;
+	bootmem_data_t *bdata = BOOTMEM_NODE_DATA(pgdat);
 
 	start = PFN_DOWN(physaddr);
 	end = PFN_UP(physaddr + size);
 
-	return mark_bootmem_node(pgdat->bdata, start, end, 1, flags);
+	return mark_bootmem_node(bdata, start, end, 1, flags);
 }
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
@@ -643,7 +649,8 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
-	return ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
+	bootmem_data_t *bdata = BOOTMEM_NODE_DATA(pgdat);
+	return ___alloc_bootmem_node(bdata, size, align, goal, 0);
 }
 
 #ifdef CONFIG_SPARSEMEM
@@ -672,9 +679,9 @@ void * __init alloc_bootmem_section(unsigned long size,
 void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
-	void *ptr;
+	bootmem_data_t *bdata = BOOTMEM_NODE_DATA(pgdat);
+	void *ptr = alloc_bootmem_core(bdata, size, align, goal, 0);
 
-	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
 
@@ -722,6 +729,7 @@ void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
-	return ___alloc_bootmem_node(pgdat->bdata, size, align,
-				goal, ARCH_LOW_ADDRESS_LIMIT);
+	bootmem_data_t *bdata = BOOTMEM_NODE_DATA(pgdat);
+	return ___alloc_bootmem_node(bdata, size, align, goal,
+					ARCH_LOW_ADDRESS_LIMIT);
 }
-- 
1.5.4.5

