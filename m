Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbXGMFS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbXGMFS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXGMFSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:18:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49479 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbXGMFSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:18:51 -0400
Date: Thu, 12 Jul 2007 22:18:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Jin <joe.jin@oracle.com>
Cc: bill.irwin@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070712221842.f5e47065.akpm@linux-foundation.org>
In-Reply-To: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 10:45:07 +0800 Joe Jin <joe.jin@oracle.com> wrote:

> This patch add nid sanity check on alloc_pages_node().
> While two process change nr_hugepages at a system, alloc_fresh_huge_page()
> been called, at this function, nid defined as a static variable, but, there
> is not any protection of, if 2 process called at the same time, maybe pass a
> invalid nid to alloc_pages_node. 
> 
> We have hit it by following scripts:
> 
> #!/bin/bash
> while : ; do 
> 	echo 1000000000000 > /proc/sys/vm/nr_hugepages 
> 	echo 1 > /proc/sys/vm/nr_hugepages 
> 	echo 10000000000000000000 > /proc/sys/vm/nr_hugepages 
> 	echo 0 > /proc/sys/vm/nr_hugepages 
> done 
> 
> 
> Run the script at _two_ difference terminal, after a short time, a kernel panic
> info will print.
> 
> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> ---
> 
> --- linux-2.6.22/include/linux/gfp.h.orig	2007-07-12 15:06:23.000000000 +0800
> +++ linux-2.6.22/include/linux/gfp.h	2007-07-12 15:02:59.000000000 +0800
> @@ -133,6 +133,9 @@
>  	/* Unknown node is current node */
>  	if (nid < 0)
>  		nid = numa_node_id();
> +	
> +	if (unlikely(nid == MAX_NUMNODES))
> +		nid = first_node(node_online_map);
>  
>  	return __alloc_pages(gfp_mask, order,
>  		NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_mask));

alloc_pages_node() is pretty much the last place where we want to fix this:
it adds more cycles and more code to many important codepaths in the
kernel.

It'd be much better to fix the race within alloc_fresh_huge_page().  That
function is pretty pathetic.

Something like this?

--- a/mm/hugetlb.c~a
+++ a/mm/hugetlb.c
@@ -105,13 +105,20 @@ static void free_huge_page(struct page *
 
 static int alloc_fresh_huge_page(void)
 {
-	static int nid = 0;
+	static int prev_nid;
+	static DEFINE_SPINLOCK(nid_lock);
 	struct page *page;
-	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
-					HUGETLB_PAGE_ORDER);
-	nid = next_node(nid, node_online_map);
+	int nid;
+
+	spin_lock(&nid_lock);
+	nid = next_node(prev_nid, node_online_map);
 	if (nid == MAX_NUMNODES)
 		nid = first_node(node_online_map);
+	prev_nid = nid;
+	spin_unlock(&nid_lock);
+
+	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
+					HUGETLB_PAGE_ORDER);
 	if (page) {
 		set_compound_page_dtor(page, free_huge_page);
 		spin_lock(&hugetlb_lock);
_

