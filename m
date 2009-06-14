Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbZFNHMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbZFNHMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 03:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZFNHMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 03:12:42 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54971 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZFNHMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 03:12:41 -0400
Date: Sun, 14 Jun 2009 10:12:39 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <alpine.DEB.1.10.0906121317140.23840@gentwo.org>
Message-ID: <Pine.LNX.4.64.0906141011280.8507@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
 <alpine.DEB.1.10.0906121317140.23840@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Christoph Lameter wrote:
> On Fri, 12 Jun 2009, Pekka J Enberg wrote:
> 
> > @@ -3434,6 +3451,8 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
> >  	unsigned long save_flags;
> >  	void *objp;
> >
> > +	flags &= slab_gfp_mask;
> > +
> >  	lockdep_trace_alloc(flags);
> >
> >  	if (slab_should_failslab(cachep, flags))
> 
> Adds code to hot code path.
> 
> > @@ -1595,6 +1601,8 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
> >  	unsigned long flags;
> >  	unsigned int objsize;
> >
> > +	gfpflags &= slab_gfp_mask;
> > +
> >  	lockdep_trace_alloc(gfpflags);
> >  	might_sleep_if(gfpflags & __GFP_WAIT);
> >
> 
> Adds code to hot code path.
> 
> The allocators mask flags passed to the page allocator through
> GFP_RECLAIM_MASK|GFP_CONSTRAINT_MASK. This is done outside of the critical
> code paths.
> 
> The might_sleep issues may be fixed by adding another check to
> __might_sleep().

How about something like this? There should be no extra code in fastpaths 
for production configs with this one.

			Pekka

diff --git a/mm/slub.c b/mm/slub.c
index 4d6004c..5e8cea1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1613,6 +1613,8 @@ another_slab:
 	deactivate_slab(s, c);
 
 new_slab:
+	gfpflags &= slab_gfp_mask;
+
 	new = get_partial(s, gfpflags, node);
 	if (new) {
 		c->page = new;
@@ -1668,13 +1670,14 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
 	unsigned int objsize;
+	gfp_t real_gfp;
 
-	gfpflags &= slab_gfp_mask;
+	real_gfp = gfpflags & slab_gfp_mask;
 
-	lockdep_trace_alloc(gfpflags);
-	might_sleep_if(gfpflags & __GFP_WAIT);
+	lockdep_trace_alloc(real_gfp);
+	might_sleep_if(real_gfp & __GFP_WAIT);
 
-	if (should_failslab(s->objsize, gfpflags))
+	if (should_failslab(s->objsize, real_gfp))
 		return NULL;
 
 	local_irq_save(flags);
