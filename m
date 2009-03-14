Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbZCNAX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbZCNAX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZCNASg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:36 -0400
Received: from kroah.org ([198.145.64.141]:46725 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752676AbZCNASe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:40 2009
Message-Id: <20090314000740.790717520@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 14/96] mm: clean up for early_pfn_to_nid()
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=mm-clean-up-for-early_pfn_to_nid.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit f2dbcfa738368c8a40d4a5f0b65dc9879577cb21 upstream.

What's happening is that the assertion in mm/page_alloc.c:move_freepages()
is triggering:

	BUG_ON(page_zone(start_page) != page_zone(end_page));

Once I knew this is what was happening, I added some annotations:

	if (unlikely(page_zone(start_page) != page_zone(end_page))) {
		printk(KERN_ERR "move_freepages: Bogus zones: "
		       "start_page[%p] end_page[%p] zone[%p]\n",
		       start_page, end_page, zone);
		printk(KERN_ERR "move_freepages: "
		       "start_zone[%p] end_zone[%p]\n",
		       page_zone(start_page), page_zone(end_page));
		printk(KERN_ERR "move_freepages: "
		       "start_pfn[0x%lx] end_pfn[0x%lx]\n",
		       page_to_pfn(start_page), page_to_pfn(end_page));
		printk(KERN_ERR "move_freepages: "
		       "start_nid[%d] end_nid[%d]\n",
		       page_to_nid(start_page), page_to_nid(end_page));
 ...

And here's what I got:

	move_freepages: Bogus zones: start_page[2207d0000] end_page[2207dffc0] zone[fffff8103effcb00]
	move_freepages: start_zone[fffff8103effcb00] end_zone[fffff8003fffeb00]
	move_freepages: start_pfn[0x81f600] end_pfn[0x81f7ff]
	move_freepages: start_nid[1] end_nid[0]

My memory layout on this box is:

[    0.000000] Zone PFN ranges:
[    0.000000]   Normal   0x00000000 -> 0x0081ff5d
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00020000
[    0.000000]     1: 0x00800000 -> 0x0081f7ff
[    0.000000]     1: 0x0081f800 -> 0x0081fe50
[    0.000000]     1: 0x0081fed1 -> 0x0081fed8
[    0.000000]     1: 0x0081feda -> 0x0081fedb
[    0.000000]     1: 0x0081fedd -> 0x0081fee5
[    0.000000]     1: 0x0081fee7 -> 0x0081ff51
[    0.000000]     1: 0x0081ff59 -> 0x0081ff5d

So it's a block move in that 0x81f600-->0x81f7ff region which triggers
the problem.

This patch:

Declaration of early_pfn_to_nid() is scattered over per-arch include
files, and it seems it's complicated to know when the declaration is used.
 I think it makes fix-for-memmap-init not easy.

This patch moves all declaration to include/linux/mm.h

After this,
  if !CONFIG_NODES_POPULATES_NODE_MAP && !CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
     -> Use static definition in include/linux/mm.h
  else if !CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
     -> Use generic definition in mm/page_alloc.c
  else
     -> per-arch back end function will be called.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: David Miller <davem@davemlloft.net>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/include/asm/mmzone.h |    4 ----
 arch/ia64/mm/numa.c            |    2 +-
 arch/x86/mm/numa_64.c          |    2 +-
 include/asm-x86/mmzone_32.h    |    2 --
 include/asm-x86/mmzone_64.h    |    2 --
 include/linux/mm.h             |   19 ++++++++++++++++---
 mm/page_alloc.c                |    8 +++++++-
 7 files changed, 25 insertions(+), 14 deletions(-)

--- a/arch/ia64/include/asm/mmzone.h
+++ b/arch/ia64/include/asm/mmzone.h
@@ -31,10 +31,6 @@ static inline int pfn_to_nid(unsigned lo
 #endif
 }
 
-#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
-extern int early_pfn_to_nid(unsigned long pfn);
-#endif
-
 #ifdef CONFIG_IA64_DIG /* DIG systems are small */
 # define MAX_PHYSNODE_ID	8
 # define NR_NODE_MEMBLKS	(MAX_NUMNODES * 8)
--- a/arch/ia64/mm/numa.c
+++ b/arch/ia64/mm/numa.c
@@ -58,7 +58,7 @@ paddr_to_nid(unsigned long paddr)
  * SPARSEMEM to allocate the SPARSEMEM sectionmap on the NUMA node where
  * the section resides.
  */
-int early_pfn_to_nid(unsigned long pfn)
+int __meminit __early_pfn_to_nid(unsigned long pfn)
 {
 	int i, section = pfn >> PFN_SECTION_SHIFT, ssec, esec;
 
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -145,7 +145,7 @@ int __init compute_hash_shift(struct boo
 	return shift;
 }
 
-int early_pfn_to_nid(unsigned long pfn)
+int __meminit  __early_pfn_to_nid(unsigned long pfn)
 {
 	return phys_to_nid(pfn << PAGE_SHIFT);
 }
--- a/include/asm-x86/mmzone_32.h
+++ b/include/asm-x86/mmzone_32.h
@@ -32,8 +32,6 @@ static inline void get_memcfg_numa(void)
 	get_memcfg_numa_flat();
 }
 
-extern int early_pfn_to_nid(unsigned long pfn);
-
 extern void resume_map_numa_kva(pgd_t *pgd);
 
 #else /* !CONFIG_NUMA */
--- a/include/asm-x86/mmzone_64.h
+++ b/include/asm-x86/mmzone_64.h
@@ -41,8 +41,6 @@ static inline __attribute__((pure)) int 
 #define node_end_pfn(nid)       (NODE_DATA(nid)->node_start_pfn +	\
 				 NODE_DATA(nid)->node_spanned_pages)
 
-extern int early_pfn_to_nid(unsigned long pfn);
-
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	(64 * 1024 * 1024)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1027,10 +1027,23 @@ extern void free_bootmem_with_active_reg
 typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
 extern void work_with_active_regions(int nid, work_fn_t work_fn, void *data);
 extern void sparse_memory_present_with_active_regions(int nid);
-#ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
-extern int early_pfn_to_nid(unsigned long pfn);
-#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
+
+#if !defined(CONFIG_ARCH_POPULATES_NODE_MAP) && \
+    !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
+static inline int __early_pfn_to_nid(unsigned long pfn)
+{
+	return 0;
+}
+#else
+/* please see mm/page_alloc.c */
+extern int __meminit early_pfn_to_nid(unsigned long pfn);
+#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
+/* there is a per-arch backend function. */
+extern int __meminit __early_pfn_to_nid(unsigned long pfn);
+#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
+#endif
+
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2949,7 +2949,7 @@ static int __meminit next_active_region_
  * was used and there are no special requirements, this is a convenient
  * alternative
  */
-int __meminit early_pfn_to_nid(unsigned long pfn)
+int __meminit __early_pfn_to_nid(unsigned long pfn)
 {
 	int i;
 
@@ -2965,6 +2965,12 @@ int __meminit early_pfn_to_nid(unsigned 
 }
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
+int __meminit early_pfn_to_nid(unsigned long pfn)
+{
+	return __early_pfn_to_nid(pfn);
+}
+
+
 /* Basic iterator support to walk early_node_map[] */
 #define for_each_active_range_index_in_nid(i, nid) \
 	for (i = first_active_region_index_in_nid(nid); i != -1; \


