Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbXHOCLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbXHOCLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 22:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbXHOCLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 22:11:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49374 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752969AbXHOCLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 22:11:09 -0400
Date: Tue, 14 Aug 2007 19:11:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Michael Ellerman <michael@ellerman.id.au>
cc: Lucio Correia <ljhc@br.ibm.com>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arndb@arndb.de>
Subject: Re: SLUB doesn't work with kdump kernel on Cell
In-Reply-To: <dc1166600708141757q26c005d7o4c9c4d69e9d28460@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708141910230.1409@schroedinger.engr.sgi.com>
References: <1186604151.3608.46.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0708081321400.14478@schroedinger.engr.sgi.com> 
 <1187106239.3298.2.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0708141241450.30435@schroedinger.engr.sgi.com>
 <dc1166600708141757q26c005d7o4c9c4d69e9d28460@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can you try this patch?

>From 74863f472810cb58dc56dde050616581d38f7673 Mon Sep 17 00:00:00 2001
From: Christoph Lameter <christoph@qirst.com>
Date: Tue, 14 Aug 2007 19:09:00 -0700
Subject: [PATCH] SLUB: Do not fail on broken memory configurations

Print a big fat warning and do what is necessary to continue if a node
is marked as up but allocations from the node do not succeed.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/slub.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 1488e71..fc82751 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1877,9 +1877,16 @@ static struct kmem_cache_node * __init early_kmem_cache_node_alloc(gfp_t gfpflag
 
 	BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
 
-	page = new_slab(kmalloc_caches, gfpflags | GFP_THISNODE, node);
-
+	page = new_slab(kmalloc_caches, gfpflags, node);
 	BUG_ON(!page);
+
+	if (page_to_nid(page) != node) {
+		printk(KERN_ERR "SLUB: Unable to allocate memory from "
+				"node %d\n", node);
+		printk(KERN_ERR "SLUB: Allocating a useless per node structure"
+				" in order to be able to continue\n");
+	}
+
 	n = page->freelist;
 	BUG_ON(!n);
 	page->freelist = get_freepointer(kmalloc_caches, n);
-- 
1.5.2.4


