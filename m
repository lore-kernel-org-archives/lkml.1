Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZALTUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZALTUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbZALTUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:20:23 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:43728 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbZALTUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:20:21 -0500
Message-ID: <496B97F1.70200@cosmosbay.com>
Date: Mon, 12 Jan 2009 20:20:17 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@redhat.com>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ring_buffer: NUMA aware page allocations
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 12 Jan 2009 20:20:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert & Steven

While browsing oprofile code in current tree, I discovered 
drivers/oprofile/cpu_buffer.c was using new ring_buffer code.

Apparently we lost in the conversion NUMA allocations, unless
I am mistaken, since rb_allocate_pages() uses plain
__get_free_page(GFP_KERNEL) calls to allocate pages.

All "buffer_page" structs are allocated with kzalloc_node(),
but not the pages themselves.

Thank you

[PATCH] ring_buffer: NUMA aware page allocations

rb_allocate_pages() & ring_buffer_resize() should use alloc_pages_node()
instead of __get_free_page() to allocate pages.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8b0daf0..feb8482 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -333,21 +333,22 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 {
 	struct list_head *head = &cpu_buffer->pages;
 	struct buffer_page *bpage, *tmp;
-	unsigned long addr;
+	struct page *page;
 	LIST_HEAD(pages);
 	unsigned i;
+	int node = cpu_to_node(cpu_buffer->cpu);
 
 	for (i = 0; i < nr_pages; i++) {
 		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
-				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
+				    GFP_KERNEL, node);
 		if (!bpage)
 			goto free_pages;
 		list_add(&bpage->list, &pages);
 
-		addr = __get_free_page(GFP_KERNEL);
-		if (!addr)
+		page = alloc_pages_node(node, GFP_KERNEL, 0);
+		if (!page)
 			goto free_pages;
-		bpage->page = (void *)addr;
+		bpage->page = page_address(page);
 		rb_init_page(bpage->page);
 	}
 
@@ -605,7 +606,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	unsigned nr_pages, rm_pages, new_pages;
 	struct buffer_page *bpage, *tmp;
 	unsigned long buffer_size;
-	unsigned long addr;
+	struct page *page;
 	LIST_HEAD(pages);
 	int i, cpu;
 
@@ -663,17 +664,19 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	new_pages = nr_pages - buffer->pages;
 
 	for_each_buffer_cpu(buffer, cpu) {
+		int node = cpu_to_node(cpu);
+
 		for (i = 0; i < new_pages; i++) {
 			bpage = kzalloc_node(ALIGN(sizeof(*bpage),
 						  cache_line_size()),
-					    GFP_KERNEL, cpu_to_node(cpu));
+					    GFP_KERNEL, node);
 			if (!bpage)
 				goto free_pages;
 			list_add(&bpage->list, &pages);
-			addr = __get_free_page(GFP_KERNEL);
-			if (!addr)
+			page = alloc_pages_node(node, GFP_KERNEL, 0);
+			if (!page)
 				goto free_pages;
-			bpage->page = (void *)addr;
+			bpage->page = page_address(page);
 			rb_init_page(bpage->page);
 		}
 	}
