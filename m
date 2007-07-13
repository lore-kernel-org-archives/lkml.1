Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbXGMMU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbXGMMU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbXGMMUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:20:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30918 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbXGMMUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:20:18 -0400
Date: Fri, 13 Jul 2007 20:18:46 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Jin <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org, gurudas.pai@oracle.com,
       Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-ID: <20070713121846.GA25236@joejin-pc.cn.oracle.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com> <20070712221842.f5e47065.akpm@linux-foundation.org> <20070713064004.GA21833@joejin-pc.cn.oracle.com> <20070712234938.c77f3a48.akpm@linux-foundation.org> <20070713080336.GB21833@joejin-pc.cn.oracle.com> <20070713011543.22797645.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713011543.22797645.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Patch gone too ;) I deleted it.  I was hoping that you'd send me the final
> finished product (please).
> 

Ha.., the patch against 2.6.22, at your patch have use htlb_alloc_mask, but I
cannot found it at 2.6.22 kernel tree, I think you must use difference kernel
tree :)

Thanks,
Joe

--- linux-2.6.22/mm/hugetlb.c.orig	2007-07-12 15:02:19.000000000 +0800
+++ linux-2.6.22/mm/hugetlb.c	2007-07-13 17:33:45.000000000 +0800
@@ -101,13 +101,20 @@ static void free_huge_page(struct page *
 
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
