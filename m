Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbYD3HLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbYD3HLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbYD3HLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:11:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57952 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbYD3HLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:11:03 -0400
Date: Wed, 30 Apr 2008 16:15:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com
Subject: Re: sparc64 bootup regression...
Message-Id: <20080430161540.bfff2c45.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080429233832.168fb6ee.akpm@linux-foundation.org>
References: <20080429.231241.221824292.davem@davemloft.net>
	<20080429233832.168fb6ee.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 23:38:32 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 29 Apr 2008 23:12:41 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> 
> > 
> > This commit causes bootup failures on sparc64:
> > 
> > commit 86f6dae1377523689bd8468fed2f2dd180fc0560
> > Author: Yasunori Goto <y-goto@jp.fujitsu.com>
> > Date:   Mon Apr 28 02:13:33 2008 -0700
> > 
> >     memory hotplug: allocate usemap on the section with pgdat
> >     
> >     Usemaps are allocated on the section which has pgdat by this.
> >     
> >     Because usemap size is very small, many other sections usemaps are allocated
> >     on only one page.  If a section has usemap, it can't be removed until removing
> >     other sections.  This dependency is not desirable for memory removing.
> >     
> >     Pgdat has similar feature.  When a section has pgdat area, it must be the last
> >     section for removing on the node.  So, if section A has pgdat and section B
> >     has usemap for section A, Both sections can't be removed due to dependency
> >     each other.
> >     
> >     To solve this issue, this patch collects usemap on same section with pgdat.
> >     If other sections doesn't have any dependency, this section will be able to be
> >     removed finally.
> 
> Thanks.  Does a straightforward revert fix it?  If so, we could do that while heads
> are being scratched.

How about this ? If this is messy (or doesn't work), Goto-san will rework
his own patch by himself. (this patch is against -mm but I think no HUNK to
git tree)

==
This kind of page allocation, which specifies the address range,
can fail easily.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiruyo@jp.fujitsu.com>

Index: mm-2.6.25-mm1/mm/sparse.c
===================================================================
--- mm-2.6.25-mm1.orig/mm/sparse.c
+++ mm-2.6.25-mm1/mm/sparse.c
@@ -264,10 +264,16 @@ static unsigned long *__init sparse_earl
 	 * To solve above issue, this collects all usemap on the same section
 	 * which has pgdat.
 	 */
+#ifdef CONFIG_NUMA /* contig_page_data for !NUMA case is not good to do this */
 	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
 	usemap = alloc_bootmem_section(usemap_size(), section_nr);
 	if (usemap)
 		return usemap;
+#endif
+	/* above allocation can fail. */
+	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	if (usemap)
+		return usemap;
 
 	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
 	nid = 0;








