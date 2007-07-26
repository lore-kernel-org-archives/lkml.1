Return-Path: <linux-kernel-owner+w=401wt.eu-S1763481AbXGZMLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763481AbXGZMLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbXGZMLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:11:33 -0400
Received: from 41.150.104.212.access.eclipse.net.uk ([212.104.150.41]:58048
	"EHLO localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751614AbXGZMLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:11:32 -0400
Date: Thu, 26 Jul 2007 13:11:30 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
Subject: [PATCH] sparsemem: ensure we initialise the node mapping for SPARSEMEM_STATIC
Message-ID: <20070726121130.GA6977@shadowen.org>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Booting SPARSEMEM on NUMA systems trips a BUG in page_alloc.c:

	Initializing HighMem for node 0 (00038000:00100000)
	Initializing HighMem for node 1 (00100000:001ffe00)
	------------[ cut here ]------------
	kernel BUG at /home/apw/git/linux-2.6/mm/page_alloc.c:456!
	[...]

This occurs because the section to node id mapping is not being
setup correctly during init under SPARSEMEM_STATIC, leading to an
attempt to free pages from all nodes into the zones on node 0.

When the zone_table[] was removed in the following commit, a new
section to node mapping table was introduced:

    commit 89689ae7f95995723fbcd5c116c47933a3bb8b13
    [PATCH] Get rid of zone_table[]

That conversion inadvertantly only initialised the node mapping in
SPARSEMEM_EXTREME.  Ensure we initialise the node mapping in
SPARSEMEM_STATIC.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
diff --git a/mm/sparse.c b/mm/sparse.c
index 0320f86..5bfd9a7 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -43,6 +43,15 @@ int page_to_nid(struct page *page)
 	return section_to_node_table[page_to_section(page)];
 }
 EXPORT_SYMBOL(page_to_nid);
+
+void set_section_nid(unsigned long section_nr, int nid)
+{
+	section_to_node_table[section_nr] = nid;
+}
+#else /* !NODE_NOT_IN_PAGE_FLAGS */
+void set_section_nid(unsigned long section_nr, int nid)
+{
+}
 #endif
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
@@ -70,10 +79,6 @@ static int __meminit sparse_index_init(unsigned long section_nr, int nid)
 	struct mem_section *section;
 	int ret = 0;
 
-#ifdef NODE_NOT_IN_PAGE_FLAGS
-	section_to_node_table[section_nr] = nid;
-#endif
-
 	if (mem_section[root])
 		return -EEXIST;
 
@@ -150,6 +155,7 @@ void __init memory_present(int nid, unsigned long start, unsigned long end)
 		struct mem_section *ms;
 
 		sparse_index_init(section, nid);
+		set_section_nid(section, nid);
 
 		ms = __nr_to_section(section);
 		if (!ms->section_mem_map)
