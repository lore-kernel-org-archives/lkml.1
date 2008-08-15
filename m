Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYHOWBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYHOWBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYHOWBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:01:34 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54488 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYHOWBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:01:33 -0400
Subject: [BUG] __GFP_THISNODE is not always honored
From: Adam Litke <agl@us.ibm.com>
To: linux-mm <linux-mm@kvack.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       nacc <nacc@linux.vnet.ibm.com>, mel@csn.ul.ie, apw <apw@shadowen.org>,
       agl <agl@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: IBM
Date: Fri, 15 Aug 2008 17:01:25 -0500
Message-Id: <1218837685.12953.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running the libhugetlbfs test suite on a NUMA machine with 2.6.27-rc3, I
discovered some strange behavior with __GFP_THISNODE.  The hugetlb function
alloc_fresh_huge_page_node() calls alloc_pages_node() with __GFP_THISNODE but
occasionally a page that is not on the requested node is returned.  Since the
hugetlb code assumes that the page will be on the requested node, badness follows
when the page is added to the wrong node's free_list.

There is clearly something wrong with the buddy allocator since __GFP_THISNODE
cannot be trusted.  Until that is fixed, the hugetlb code should not assume
that the newly allocated page is on the node asked for.  This patch prevents
the hugetlb pool counters from being corrupted and allows the code to cope with
unbalanced numa allocations.

So far my debugging has led me to get_page_from_freelist() inside the
for_each_zone_zonelist() loop.  When buffered_rmqueue() returns a page I
compare the value of page_to_nid(page), zone->node and the node that the
hugetlb code requested with __GFP_THISNODE.  These all match -- except when the
problem triggers.  In that case, zone->node matches the node we asked for but
page_to_nid() does not.

Workaround patch:
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 67a7119..7a30a61 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -568,7 +568,7 @@ static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 			__free_pages(page, huge_page_order(h));
 			return NULL;
 		}
-		prep_new_huge_page(h, page, nid);
+		prep_new_huge_page(h, page, page_to_nid(page));
 	}
 
 	return page;

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

