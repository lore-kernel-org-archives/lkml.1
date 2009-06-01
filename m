Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZFAILV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZFAILV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZFAILG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:11:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43742 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbZFAILF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:11:05 -0400
Date: Mon, 1 Jun 2009 17:55:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: linux-next: manual merge of the kmemcheck tree with the kmemleak
 tree
Message-Id: <20090601175534.7e6e4c12.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the kmemcheck tree got a conflict in
mm/slub.c between commit 5247520db9023300947e5b77943bc0719f33d4b9
("kmemleak: Add the slub memory allocation/freeing hooks") from the
kmemleak tree and commit 18fd427debcf37c06917b55295df682fd05fee76 ("slub:
add hooks for kmemcheck") from the kmemcheck tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/slub.c
index 6674a79,4ac5e3e..0000000
--- a/mm/slub.c
+++ b/mm/slub.c
@@@ -144,10 -143,10 +145,10 @@@
   * Set of flags that will prevent slab merging
   */
  #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 -		SLAB_TRACE | SLAB_DESTROY_BY_RCU)
 +		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE)
  
  #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
- 		SLAB_CACHE_DMA)
+ 		SLAB_CACHE_DMA | SLAB_NOTRACK)
  
  #ifndef ARCH_KMALLOC_MINALIGN
  #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
@@@ -1618,7 -1637,7 +1641,8 @@@ static __always_inline void *slab_alloc
  	if (unlikely((gfpflags & __GFP_ZERO) && object))
  		memset(object, 0, objsize);
  
 +	kmemleak_alloc_recursive(object, objsize, 1, s->flags, gfpflags);
+ 	kmemcheck_slab_alloc(s, gfpflags, object, c->objsize);
  	return object;
  }
  
@@@ -1748,9 -1767,9 +1772,10 @@@ static __always_inline void slab_free(s
  	struct kmem_cache_cpu *c;
  	unsigned long flags;
  
 +	kmemleak_free_recursive(x, s->flags);
  	local_irq_save(flags);
  	c = get_cpu_slab(s, smp_processor_id());
+ 	kmemcheck_slab_free(s, object, c->objsize);
  	debug_check_no_locks_freed(object, c->objsize);
  	if (!(s->flags & SLAB_DEBUG_OBJECTS))
  		debug_check_no_obj_freed(object, c->objsize);
