Return-Path: <linux-kernel-owner+w=401wt.eu-S932142AbZDXQps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbZDXQps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760184AbZDXQmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:42:51 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41695 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760194AbZDXQms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:42:48 -0400
Subject: [PATCH 05/14] kmemleak: Add the slub memory allocation/freeing hooks
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Date: Fri, 24 Apr 2009 17:41:26 +0100
Message-ID: <20090424164126.4476.88292.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
References: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 16:42:10.0955 (UTC) FILETIME=[9D2C95B0:01C9C4FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the callbacks to kmemleak_(alloc|free) functions from the
slub allocator.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7ab54ec..93f5fb0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -19,6 +19,7 @@
 #include <trace/kmemtrace.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
+#include <linux/kmemleak.h>
 #include <linux/mempolicy.h>
 #include <linux/ctype.h>
 #include <linux/debugobjects.h>
@@ -142,7 +143,7 @@
  * Set of flags that will prevent slab merging
  */
 #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-		SLAB_TRACE | SLAB_DESTROY_BY_RCU)
+		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE)
 
 #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
 		SLAB_CACHE_DMA)
@@ -1614,6 +1615,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, objsize);
 
+	kmemleak_alloc_recursive(object, objsize, 1, s->flags, gfpflags);
 	return object;
 }
 
@@ -1743,6 +1745,7 @@ static __always_inline void slab_free(struct kmem_cache *s,
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
 
+	kmemleak_free_recursive(x, s->flags);
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	debug_check_no_locks_freed(object, c->objsize);

