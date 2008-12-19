Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYLSSOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYLSSOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 13:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYLSSN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 13:13:28 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50352 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962AbYLSSN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 13:13:27 -0500
Subject: [PATCH 05/14] kmemleak: Add the slub memory allocation/freeing hooks
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 19 Dec 2008 18:13:24 +0000
Message-ID: <20081219181324.7778.98870.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2008 18:13:25.0564 (UTC) FILETIME=[7C3F1FC0:01C96205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the callbacks to kmemleak_(alloc|free) functions from the
slub allocator.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a2cd47d..bc77176 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -18,6 +18,7 @@
 #include <linux/seq_file.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
+#include <linux/kmemleak.h>
 #include <linux/mempolicy.h>
 #include <linux/ctype.h>
 #include <linux/debugobjects.h>
@@ -140,7 +141,7 @@
  * Set of flags that will prevent slab merging
  */
 #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-		SLAB_TRACE | SLAB_DESTROY_BY_RCU)
+		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE)
 
 #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
 		SLAB_CACHE_DMA)
@@ -1608,6 +1609,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, objsize);
 
+	kmemleak_alloc_recursive(object, objsize, 1, s->flags, gfpflags);
 	return object;
 }
 
@@ -1710,6 +1712,7 @@ static __always_inline void slab_free(struct kmem_cache *s,
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
 
+	kmemleak_free_recursive(x, s->flags);
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	debug_check_no_locks_freed(object, c->objsize);

