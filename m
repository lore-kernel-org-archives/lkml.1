Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbXEZBwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbXEZBwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 21:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXEZBwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 21:52:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56493 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752653AbXEZBwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 21:52:33 -0400
Date: Fri, 25 May 2007 18:52:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <20070525061200.GG7653@kernel.dk>
Message-ID: <Pine.LNX.4.64.0705251850350.9013@schroedinger.engr.sgi.com>
References: <376320.95285.qm@web52612.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705221524490.16904@schroedinger.engr.sgi.com>
 <20070523071103.GE4705@kernel.dk> <Pine.LNX.4.64.0705231003460.19822@schroedinger.engr.sgi.com>
 <20070524072550.GC15375@kernel.dk> <Pine.LNX.4.64.0705240953270.28086@schroedinger.engr.sgi.com>
 <20070525061200.GG7653@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I finally figured out the second issue. Took some time to get that figure 
out. Sorry. But now all the bug reports make sense.

Here is the fix


SLUB: Fix NUMA / SYSFS bootstrap issue

The kmem_cache_node cache is very special because it is needed for
NUMA bootstrap. Under certain conditions (like for example if lockdep is
enabled and significantly increases the size of spinlock_t) the structure
may become exactly the size as one of the larger caches in the kmalloc array.

That early during bootstrap we cannot perform merging properly. The unique
id for the kmem_cache_node cache will match one of the kmalloc array. Sysfs
will complain about a duplicate directory entry. All of this occurs while
the console is not yet fully operational. Thus boot may appear to be
silently failing.

The kmem_cache_node cache is very special. During early boostrap the main
allocation function is not operational yet and so we have to run our
own small special alloc function during early boot. It is also special in
that it is never freed.

We really do not want any merging on that cache. Set the refcount -1 and
forbid merging of slabs that have a negative refcount.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-05-25 18:28:42.000000000 -0700
+++ slub/mm/slub.c	2007-05-25 18:29:46.000000000 -0700
@@ -2473,6 +2473,7 @@ void __init kmem_cache_init(void)
 	 */
 	create_kmalloc_cache(&kmalloc_caches[0], "kmem_cache_node",
 		sizeof(struct kmem_cache_node), GFP_KERNEL);
+	kmalloc_caches[0].refcount = -1;
 #endif
 
 	/* Able to allocate the per node structures */
@@ -2520,6 +2521,12 @@ static int slab_unmergeable(struct kmem_
 	if (s->ctor)
 		return 1;
 
+	/*
+	 * We may have set a slab to be unmergeable during bootstrap.
+	 */
+	if (s->refcount < 0)
+		return 1;
+
 	return 0;
 }
 
