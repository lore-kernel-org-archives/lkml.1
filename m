Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbYCNOxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbYCNOxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYCNOxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:53:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41572 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYCNOxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:53:23 -0400
Date: Fri, 14 Mar 2008 23:44:35 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Subject: [PATCH 3/3 (RFC)](memory hotplug) align maps for easy removing
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <20080314231112.20D7.E1E9C6FF@jp.fujitsu.com>
References: <20080314231112.20D7.E1E9C6FF@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080314234205.20DD.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To free memmap and usemap easier, this patch aligns these maps to page size.

I know usemap size is too small to align page size.
It will be waste of area. So, there may be better way than this.

Followings are pros. and cons with other my ideas.
But I'm not sure which is better way. 

a) Packing many section's usemap on one page. Count how many sections use
   it in page_count.
  Pros.
    - Avoid waisting area.
  Cons.
    - This usemap's page will be hard(or impossible) to remove due to
      dependency.
      It should be allocated on un-movable zone/node.
      (I'm not sure it's impact of performance.)
    - Nodes' structures may have to be packed like usemap???

b) Pack memmap and usemap in one allocation.
  Pros.
    - May avoid wasting area if its size is suitable.
  Cons.
    - If size is not suitable, it will be same as this patch.
    - This way is not good for VMEMMAP_SPARSEMEM.
      At least, it is reverse way against Yinghai-san's fix.

c) This way.
  Pros.
    - Very easy to remove.
  Cons.
    - Waist of area.

Any other idea is welcome.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 mm/sparse.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: current/mm/sparse.c
===================================================================
--- current.orig/mm/sparse.c	2008-03-11 20:15:41.000000000 +0900
+++ current/mm/sparse.c	2008-03-11 20:58:18.000000000 +0900
@@ -244,7 +244,8 @@
 	struct mem_section *ms = __nr_to_section(pnum);
 	int nid = sparse_early_nid(ms);
 
-	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	usemap = alloc_bootmem_pages_node(NODE_DATA(nid),
+					  PAGE_ALIGN(usemap_size()));
 	if (usemap)
 		return usemap;
 
@@ -264,8 +265,8 @@
 	if (map)
 		return map;
 
-	map = alloc_bootmem_node(NODE_DATA(nid),
-			sizeof(struct page) * PAGES_PER_SECTION);
+	map = alloc_bootmem_pages_node(NODE_DATA(nid),
+		       PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION));
 	return map;
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */

-- 
Yasunori Goto 


