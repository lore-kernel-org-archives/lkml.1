Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYKMQea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYKMQea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYKMQeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:34:22 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42607 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYKMQeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:34:21 -0500
Date: Thu, 13 Nov 2008 16:33:32 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] slab: document SLAB_DESTROY_BY_RCU
In-Reply-To: <1226586509.7685.4929.camel@twins>
Message-ID: <Pine.LNX.4.64.0811131625130.16744@blonde.site>
References: <1226586509.7685.4929.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Peter Zijlstra wrote:
> Subject: slab: document SLAB_DESTROY_BY_RCU

Yes, that's good, thanks Peter.  But I still think it's even
better with at least a pointer to the original description in
mm/slab.c: I've added one or two lines to the comment below.


From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Explain this SLAB_DESTROY_BY_RCU thing...

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
 include/linux/slab.h |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

Index: linux-2.6/include/linux/slab.h
===================================================================
--- linux-2.6.orig/include/linux/slab.h
+++ linux-2.6/include/linux/slab.h
@@ -23,6 +23,34 @@
 #define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
 #define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
 #define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
+/*
+ * SLAB_DESTROY_BY_RCU - **WARNING** READ THIS!
+ *
+ * This delays freeing the SLAB page by a grace period, it does _NOT_
+ * delay object freeing. This means that if you do kmem_cache_free()
+ * that memory location is free to be reused at any time. Thus it may
+ * be possible to see another object there in the same RCU grace period.
+ *
+ * This feature only ensures the memory location backing the object
+ * stays valid, the trick to using this is relying on an independent
+ * object validation pass. Something like:
+ *
+ *  rcu_read_lock()
+ * again:
+ *  obj = lockless_lookup(key);
+ *  if (obj) {
+ *    if (!try_get_ref(obj)) // might fail for free objects
+ *      goto again;
+ *
+ *    if (obj->key != key) { // not the object we expected
+ *      put_ref(obj);
+ *      goto again;
+ *    }
+ *  }
+ *  rcu_read_unlock();
+ *
+ * See also the comment on struct slab_rcu in mm/slab.c.
+ */
 #define SLAB_DESTROY_BY_RCU	0x00080000UL	/* Defer freeing slabs to RCU */
 #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
 #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
