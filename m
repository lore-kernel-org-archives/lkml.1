Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYFXIuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYFXIuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbYFXIud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:50:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52956 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYFXIub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:50:31 -0400
Date: Tue, 24 Jun 2008 17:41:23 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [Patch](memory hotplug)Allocate usemap on the section with pgdat (take 4)
Cc: Andy Whitcroft <apw@shadowen.org>, David Miller <davem@davemloft.net>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
       Tony Breeds <tony@bakeyournoodle.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20080624113345.E1B8.E1E9C6FF@jp.fujitsu.com>
References: <20080623204934.GB1824@csn.ul.ie> <20080624113345.E1B8.E1E9C6FF@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080624173302.E1C2.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Here is take 4.
Mel-san's comments are refrected. (some cleanups)

At present, there is no regression report after take 3.
I wish this patch would be merged into -next or -mm.

Please apply.

Thanks.

---

Usemaps are allocated on the section which has pgdat by this.

Because usemap size is very small, many other sections usemaps
are allocated on only one page. If a section has usemap, it
can't be removed until removing other sections.
This dependency is not desirable for memory removing.

Pgdat has similar feature. When a section has pgdat area, it 
must be the last section for removing on the node.
So, if section A has pgdat and section B has usemap for section A,
Both sections can't be removed due to dependency each other.

To solve this issue, this patch collects usemap on same
section with pgdat as much as possible.
If other sections doesn't have any dependency, this section will
be able to be removed finally.

Change log of take 4.
 - Some cleanups.
   * Add KERN_INFO and KERN_CONT for printk messages.
   * Remove redundant nid calculation in 
     sparse_early_usemap_alloc_section().
     pgdat is passed directly, and function name is changed to
     sparse_early_usemap_alloc_pgdat_section(pgdat).
     (Because argument becomes pgdat, not pnum).
   * Comment was changed to be read easier.

Change log of take 3.
 - Change dependency message and comment.
  (Thanks! > Andy Whitcroft-san)

Change log of take 2.
 - This feature becomes effective only when CONFIG_MEMORY_HOTREMOVE is on.
   If hotremove is off, this feature is not necessary.
 - Allow allocation on other section if alloc_bootmem_section() fails.
   This removes previous regression.
 - Show message if allocation on same section fails.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---

 mm/sparse.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

Index: current/mm/sparse.c
===================================================================
--- current.orig/mm/sparse.c	2008-06-17 15:34:29.000000000 +0900
+++ current/mm/sparse.c	2008-06-24 15:29:21.000000000 +0900
@@ -269,16 +269,92 @@
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+static unsigned long * __init
+sparse_early_usemap_alloc_pgdat_section(struct pglist_data *pgdat)
+{
+	unsigned long section_nr;
+
+	/*
+	 * A page may contain usemaps for other sections preventing the
+	 * page being freed and making a section unremovable while
+	 * other sections referencing the usemap retmain active. Similarly,
+	 * a pgdat can prevent a section being removed. If section A
+	 * contains a pgdat and section B contains the usemap, both
+	 * sections become inter-dependent. This allocates usemaps
+	 * from the same section as the pgdat where possible to avoid
+	 * this problem.
+	 */
+	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
+	return alloc_bootmem_section(usemap_size(), section_nr);
+}
+
+static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
+{
+	unsigned long usemap_snr, pgdat_snr;
+	static unsigned long old_usemap_snr = NR_MEM_SECTIONS;
+	static unsigned long old_pgdat_snr = NR_MEM_SECTIONS;
+	struct pglist_data *pgdat = NODE_DATA(nid);
+	int usemap_nid;
+
+	usemap_snr = pfn_to_section_nr(__pa(usemap) >> PAGE_SHIFT);
+	pgdat_snr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
+	if (usemap_snr == pgdat_snr)
+		return;
+
+	if (old_usemap_snr == usemap_snr && old_pgdat_snr == pgdat_snr)
+		/* skip redundant message */
+		return;
+
+	old_usemap_snr = usemap_snr;
+	old_pgdat_snr = pgdat_snr;
+
+	usemap_nid = sparse_early_nid(__nr_to_section(usemap_snr));
+	if (usemap_nid != nid) {
+		printk(KERN_INFO
+		       "node %d must be removed before remove section %ld\n",
+		       nid, usemap_snr);
+		return;
+	}
+	/*
+	 * There is a circular dependency.
+	 * Some platforms allow un-removable section because they will just
+	 * gather other removable sections for dynamic partitioning.
+	 * Just notify un-removable section's number here.
+	 */
+	printk(KERN_INFO "Section %ld and %ld (node %d)", usemap_snr,
+	       pgdat_snr, nid);
+	printk(KERN_CONT
+	       " have a circular dependency on usemap and pgdat allocations\n");
+}
+#else
+static unsigned long * __init
+sparse_early_usemap_alloc_pgdat_section(struct pglist_data *pgdat)
+{
+	return NULL;
+}
+
+static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
+{
+}
+#endif /* CONFIG_MEMORY_HOTREMOVE */
+
 static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
 {
 	unsigned long *usemap;
 	struct mem_section *ms = __nr_to_section(pnum);
 	int nid = sparse_early_nid(ms);
 
-	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	usemap = sparse_early_usemap_alloc_pgdat_section(NODE_DATA(nid));
 	if (usemap)
 		return usemap;
 
+	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	if (usemap) {
+		check_usemap_section_nr(nid, usemap);
+		return usemap;
+	}
+
 	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
 	nid = 0;
 

-- 
Yasunori Goto 


