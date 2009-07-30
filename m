Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZG3OTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZG3OTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZG3OTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:19:05 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:50492 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZG3OTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:19:02 -0400
Date: Thu, 30 Jul 2009 16:10:22 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] mm: Add kmalloc NULL tests
Message-ID: <Pine.LNX.4.64.0907301608350.8734@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Check that the result of kmalloc is not NULL before passing it to other
functions.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression *x;
identifier f;
constant char *C;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
... when != x == NULL
    when != x != NULL
    when != (x || ...)
(
kfree(x)
|
f(...,C,...,x,...)
|
*f(...,x,...)
|
*x->f
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 mm/slab.c       |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 7b5d4de..972e427 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1502,6 +1502,7 @@ void __init kmem_cache_init(void)
 
 		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
 
+		BUG_ON(!ptr);
 		BUG_ON(cpu_cache_get(&cache_cache) != &initarray_cache.cache);
 		memcpy(ptr, cpu_cache_get(&cache_cache),
 		       sizeof(struct arraycache_init));
@@ -1514,6 +1515,7 @@ void __init kmem_cache_init(void)
 
 		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
 
+		BUG_ON(!ptr);
 		BUG_ON(cpu_cache_get(malloc_sizes[INDEX_AC].cs_cachep)
 		       != &initarray_generic.cache);
 		memcpy(ptr, cpu_cache_get(malloc_sizes[INDEX_AC].cs_cachep),
