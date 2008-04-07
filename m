Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbYDGNBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbYDGNBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 09:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYDGNA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 09:00:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38422 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYDGNA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 09:00:58 -0400
Date: Mon, 07 Apr 2008 21:48:36 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch 004/005](memory hotplug)allocate usemap on the section with pgdat
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <20080407213519.886E.E1E9C6FF@jp.fujitsu.com>
References: <20080407213519.886E.E1E9C6FF@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080407214736.8878.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
section with pgdat.
If other sections doesn't have any dependency, this section will
be able to be removed finally.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---

 mm/sparse.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: current/mm/sparse.c
===================================================================
--- current.orig/mm/sparse.c	2008-04-07 20:12:55.000000000 +0900
+++ current/mm/sparse.c	2008-04-07 20:13:15.000000000 +0900
@@ -239,11 +239,22 @@
 
 static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
 {
-	unsigned long *usemap;
+	unsigned long *usemap, section_nr;
 	struct mem_section *ms = __nr_to_section(pnum);
 	int nid = sparse_early_nid(ms);
+	struct pglist_data *pgdat = NODE_DATA(nid);
 
-	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	/*
+	 * Usemap's page can't be freed until freeing other sections
+	 * which use it. And, Pgdat has same feature.
+	 * If section A has pgdat and section B has usemap for other
+	 * sections (includes section A), both sections can't be removed,
+	 * because there is the dependency each other.
+	 * To solve above issue, this collects all usemap on the same section
+	 * which has pgdat.
+	 */
+	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
+	usemap = alloc_bootmem_section(usemap_size(), section_nr);
 	printk(KERN_INFO "sparse_early_usemap_alloc: usemap = %p size = %ld\n",
 		usemap, usemap_size());
 	if (usemap)

-- 
Yasunori Goto 


