Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbZE2BPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbZE2BPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 21:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbZE2BPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 21:15:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:49738 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbZE2BPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 21:15:37 -0400
Message-ID: <4A1F3724.8050103@kernel.org>
Date: Thu, 28 May 2009 18:15:16 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: mingo@elte.hu, Christoph Lameter <cl@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, mpm@selenic.com,
       npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] slab: remove bootmem calling
References: <1243517365.11533.65.camel@penberg-laptop>
In-Reply-To: <1243517365.11533.65.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_init/kmem_cache_init is moved up

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/page_cgroup.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/page_cgroup.c
===================================================================
--- linux-2.6.orig/mm/page_cgroup.c
+++ linux-2.6/mm/page_cgroup.c
@@ -47,6 +47,8 @@ static int __init alloc_node_page_cgroup
 	struct page_cgroup *base, *pc;
 	unsigned long table_size;
 	unsigned long start_pfn, nr_pages, index;
+	struct page *page;
+	unsigned int order;
 
 	start_pfn = NODE_DATA(nid)->node_start_pfn;
 	nr_pages = NODE_DATA(nid)->node_spanned_pages;
@@ -55,11 +57,13 @@ static int __init alloc_node_page_cgroup
 		return 0;
 
 	table_size = sizeof(struct page_cgroup) * nr_pages;
-
-	base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
-			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
-	if (!base)
+	order = get_order(table_size);
+	page = alloc_pages_node(nid, GFP_NOWAIT | __GFP_ZERO, order);
+	if (!page)
+		page = alloc_pages_node(-1, GFP_NOWAIT | __GFP_ZERO, order);
+	if (!page)
 		return -ENOMEM;
+	base = page_address(page);
 	for (index = 0; index < nr_pages; index++) {
 		pc = base + index;
 		__init_page_cgroup(pc, start_pfn + index);


