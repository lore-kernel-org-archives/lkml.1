Return-Path: <linux-kernel-owner+w=401wt.eu-S1761814AbXHVJD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761814AbXHVJD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758211AbXHVIxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:37 -0400
Received: from 1wt.eu ([62.212.114.60]:2114 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758659AbXHVIxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:33 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084029.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:23 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Gurudas Pai <gurudas.pai@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 39/58] hugetlb: fix race in alloc_fresh_huge_page()
Content-Disposition: inline; filename=0039-hugetlb-fix-race-in-alloc_fresh_huge_page.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That static `nid' index needs locking.  Without it we can end up calling
alloc_pages_node() with an illegal node ID and the kernel crashes.

Acked-by: Gurudas Pai <gurudas.pai@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 mm/hugetlb.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 36db012..7c07eb2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -101,13 +101,20 @@ static void free_huge_page(struct page *page)
 
 static int alloc_fresh_huge_page(void)
 {
-	static int nid = 0;
+	static int prev_nid;
 	struct page *page;
-	page = alloc_pages_node(nid, GFP_HIGHUSER|__GFP_COMP|__GFP_NOWARN,
-					HUGETLB_PAGE_ORDER);
-	nid = next_node(nid, node_online_map);
+	static DEFINE_SPINLOCK(nid_lock);
+	int nid;
+
+	spin_lock(&nid_lock);
+	nid = next_node(prev_nid, node_online_map);
 	if (nid == MAX_NUMNODES)
 		nid = first_node(node_online_map);
+	prev_nid = nid;
+	spin_unlock(&nid_lock);
+
+	page = alloc_pages_node(nid, GFP_HIGHUSER|__GFP_COMP|__GFP_NOWARN,
+					HUGETLB_PAGE_ORDER);
 	if (page) {
 		set_compound_page_dtor(page, free_huge_page);
 		spin_lock(&hugetlb_lock);
-- 
1.5.2.5

-- 
