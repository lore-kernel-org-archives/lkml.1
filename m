Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZC3InW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZC3InW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 04:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZC3InK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 04:43:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:9340 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbZC3InJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 04:43:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BAcLGvOIgBLBPZ7Rcvh0UaZEjE/oOcB/cbfnnJiU/uiKqtX8GIrB9yisv2oLXT5vL
	cpVPAr4uHRUjRpe8va10Q==
Date: Mon, 30 Mar 2009 01:41:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch 1/3] slub: add per-cache slab thrash ratio
In-Reply-To: <1238397091.26742.35.camel@penberg-laptop>
Message-ID: <alpine.DEB.2.00.0903300128100.26320@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com>  <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <1238397091.26742.35.camel@penberg-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Pekka Enberg wrote:

> > The slab_thrash_ratio for each cache do not have non-zero defaults
> > (yet?).
> 
> If we're going to merge this code, I think it would be better to put a
> non-zero default there; otherwise we won't be able to hit potential
> performance regressions or bugs. Furthermore, the optimization is not
> very useful on large scale if people need to enable it themselves.
> 
> Maybe stick 20 there and run tbench, sysbench, et al to see if it makes
> a difference? I'm cc'ing Mel in case he has some suggestions how to test
> it.
> 

It won't cause a regression if sane SLAB_THRASHING_THRESHOLD and 
slab_thrash_ratio values are set since the contention on list_lock will 
always be slower than utilizing a more free cpu slab when its thrashing.

I agree that there should be a default value and I was originally going 
to propose the following as the fourth patch in the series, but I wanted 
to generate commentary on the approach first and there's always a 
hesitation when changing the default behavior of the entire allocator for 
workloads with very specific behavior that trigger this type of problem.

The fact that we need a tunable for this is unfortunate, but there doesn't 
seem to be any other way to detect such situations and adjust the partial 
list handling so that list_lock isn't contended so much and the allocation 
slowpath to fastpath ratio isn't so high.

I'd be interested to hear other people's approaches.
---
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -147,6 +147,12 @@
  */
 #define SLAB_THRASHING_THRESHOLD 3
 
+/*
+ * Default slab thrash ratio, used to define when a slab is thrashing for a
+ * particular cpu.
+ */
+#define DEFAULT_SLAB_THRASH_RATIO 20
+
 #define DEBUG_DEFAULT_FLAGS (SLAB_DEBUG_FREE | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
 
@@ -2392,7 +2398,14 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 	 */
 	set_min_partial(s, ilog2(s->size));
 	s->refcount = 1;
-	s->min_free_watermark = 0;
+	s->min_free_watermark = oo_objects(s->oo) *
+					DEFAULT_SLAB_THRASH_RATIO / 100;
+	/*
+	 * It doesn't make sense to define a slab as thrashing if its threshold
+	 * is fewer than 4 objects.
+	 */
+	if (s->min_free_watermark < 4)
+		s->min_free_watermark = 0;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
 #endif
