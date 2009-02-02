Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZBBJlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZBBJlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZBBJlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:41:01 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40458 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbZBBJk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:40:59 -0500
Date: Mon, 2 Feb 2009 11:40:56 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: akpm@linux-foundation.org, cl@linux-foundation.org, rientjes@google.com,
       jeffm@suse.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB/SLUB fixes for 2.6.29-rc3
Message-ID: <Pine.LNX.4.64.0902021137250.20661@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

The branch has a build failure fix for SLAB by Jeff Mahoney and a small 
off-by-one fixlet for SLUB by David Rientjes.

                Pekka

David Rientjes (1):
      slub: fix per cpu kmem_cache_cpu array memory leak

Jeff Mahoney (1):
      kmalloc: return NULL instead of link failure

Pekka Enberg (1):
      Merge branches 'topic/slab/fixes' and 'topic/slub/fixes' into for-linus

 include/linux/slab_def.h |   10 ++--------
 mm/slub.c                |    2 +-
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 39c3a5e..6ca6a7b 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -43,10 +43,7 @@ static inline void *kmalloc(size_t size, gfp_t flags)
 			i++;
 #include <linux/kmalloc_sizes.h>
 #undef CACHE
-		{
-			extern void __you_cannot_kmalloc_that_much(void);
-			__you_cannot_kmalloc_that_much();
-		}
+		return NULL;
 found:
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)
@@ -77,10 +74,7 @@ static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 			i++;
 #include <linux/kmalloc_sizes.h>
 #undef CACHE
-		{
-			extern void __you_cannot_kmalloc_that_much(void);
-			__you_cannot_kmalloc_that_much();
-		}
+		return NULL;
 found:
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)
diff --git a/mm/slub.c b/mm/slub.c
index 6392ae5..bdc9abb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1996,7 +1996,7 @@ static struct kmem_cache_cpu *alloc_kmem_cache_cpu(struct kmem_cache *s,
 static void free_kmem_cache_cpu(struct kmem_cache_cpu *c, int cpu)
 {
 	if (c < per_cpu(kmem_cache_cpu, cpu) ||
-			c > per_cpu(kmem_cache_cpu, cpu) + NR_KMEM_CACHE_CPU) {
+			c >= per_cpu(kmem_cache_cpu, cpu) + NR_KMEM_CACHE_CPU) {
 		kfree(c);
 		return;
 	}
