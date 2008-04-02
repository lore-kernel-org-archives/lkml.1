Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYDBMOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYDBMOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYDBMN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:13:56 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:13122 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754129AbYDBMNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:13:55 -0400
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, paulmck@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20080402115337.GD12774@kernel.dk>
References: <20080402105539.GA5610@linux.vnet.ibm.com>
	 <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com>
	 <20080402110718.GU12774@kernel.dk> <1207134536.8514.773.camel@twins>
	 <20080402111422.GW12774@kernel.dk> <1207135212.8514.782.camel@twins>
	 <20080402113258.GY12774@kernel.dk> <1207136230.8514.791.camel@twins>
	 <20080402114243.GZ12774@kernel.dk> <1207136867.8514.796.camel@twins>
	 <20080402115337.GD12774@kernel.dk>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 14:13:42 +0200
Message-Id: <1207138422.8514.799.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 13:53 +0200, Jens Axboe wrote:

> > Yeah, SLAB_DESTROY_BY_RCU should have a _HUGE_ comment explaining it,
> > I'm sure this is not the first (nor the last) time people get that
> > wrong.
> 
> It should, SLAB_DESTROY_BY_RCU is definitely useful, but it is expected
> to be an 'easier' way of doing the call_rcu() manually. So it definitely
> needs more documentation.
> 

Ok I gave it a go, how bad is this text?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/include/linux/slab.h b/include/linux/slab.h
index f950a89..e049ddc 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -25,6 +25,32 @@
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
+ */
 #define SLAB_DESTROY_BY_RCU	0x00080000UL	/* Defer freeing slabs to RCU */
 #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
 #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */


