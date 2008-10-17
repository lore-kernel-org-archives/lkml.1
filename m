Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbYJQFqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbYJQFqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 01:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYJQFq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 01:46:29 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:5256 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbYJQFq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 01:46:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqwEAM8S9kg7p+/x/2dsb2JhbACBcsA0gWs
X-IronPort-AV: E=Sophos;i="4.33,429,1220193000"; 
   d="scan'208";a="212721175"
Message-ID: <48F834BD.3070702@call-direct.com.au>
Date: Fri, 17 Oct 2008 16:46:21 +1000
From: Iwo Mergler <iwo@call-direct.com.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] Fix for genalloc locking
References: <48F83400.90901@call-direct.com.au>
In-Reply-To: <48F83400.90901@call-direct.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Genalloc was using a rwlock without irqsave/irqrestore. This
caused problems when used with a mix of int/non-int calls.
Replaced all locking functions with the irqsave/restore
variants.

Signed-off-by: Iwo.Mergler@call-direct.com.au

---
 lib/genalloc.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index f6d276d..337f05a 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -49,6 +49,7 @@ EXPORT_SYMBOL(gen_pool_create);
 int gen_pool_add(struct gen_pool *pool, unsigned long addr, size_t size,
 		 int nid)
 {
+	unsigned long rwflags;
 	struct gen_pool_chunk *chunk;
 	int nbits = size >> pool->min_alloc_order;
 	int nbytes = sizeof(struct gen_pool_chunk) +
@@ -62,9 +63,9 @@ int gen_pool_add(struct gen_pool *pool, unsigned long addr, size_t size,
 	chunk->start_addr = addr;
 	chunk->end_addr = addr + size;
 
-	write_lock(&pool->lock);
+	write_lock_irqsave(&pool->lock, rwflags);
 	list_add(&chunk->next_chunk, &pool->chunks);
-	write_unlock(&pool->lock);
+	write_unlock_irqrestore(&pool->lock, rwflags);
 
 	return 0;
 }
@@ -83,9 +84,9 @@ void gen_pool_destroy(struct gen_pool *pool)
 	struct gen_pool_chunk *chunk;
 	int order = pool->min_alloc_order;
 	int bit, end_bit;
+	unsigned long rwflags;
 
-
-	write_lock(&pool->lock);
+	write_lock_irqsave(&pool->lock, rwflags);
 	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 		list_del(&chunk->next_chunk);
@@ -116,13 +117,14 @@ unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
 	unsigned long addr, flags;
 	int order = pool->min_alloc_order;
 	int nbits, bit, start_bit, end_bit;
+	unsigned long rwflags;
 
 	if (size == 0)
 		return 0;
 
 	nbits = (size + (1UL << order) - 1) >> order;
 
-	read_lock(&pool->lock);
+	read_lock_irqsave(&pool->lock, rwflags);
 	list_for_each(_chunk, &pool->chunks) {
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 
@@ -149,12 +151,12 @@ unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
 			while (nbits--)
 				__set_bit(start_bit++, chunk->bits);
 			spin_unlock_irqrestore(&chunk->lock, flags);
-			read_unlock(&pool->lock);
+			read_unlock_irqrestore(&pool->lock, rwflags);
 			return addr;
 		}
 		spin_unlock_irqrestore(&chunk->lock, flags);
 	}
-	read_unlock(&pool->lock);
+	read_unlock_irqrestore(&pool->lock, rwflags);
 	return 0;
 }
 EXPORT_SYMBOL(gen_pool_alloc);
@@ -174,10 +176,11 @@ void gen_pool_free(struct gen_pool *pool, unsigned long addr, size_t size)
 	unsigned long flags;
 	int order = pool->min_alloc_order;
 	int bit, nbits;
+	unsigned long rwflags;
 
 	nbits = (size + (1UL << order) - 1) >> order;
 
-	read_lock(&pool->lock);
+	read_lock_irqsave(&pool->lock, rwflags);
 	list_for_each(_chunk, &pool->chunks) {
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 
@@ -192,6 +195,6 @@ void gen_pool_free(struct gen_pool *pool, unsigned long addr, size_t size)
 		}
 	}
 	BUG_ON(nbits > 0);
-	read_unlock(&pool->lock);
+	read_unlock_irqrestore(&pool->lock, rwflags);
 }
 EXPORT_SYMBOL(gen_pool_free);
-- 
1.6.0


