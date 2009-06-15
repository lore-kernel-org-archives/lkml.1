Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbZFOO6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbZFOO6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZFOO6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:58:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:32914 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbZFOO6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:58:10 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
In-Reply-To: <alpine.DEB.1.10.0906151051240.19931@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906121317140.23840@gentwo.org>
	 <Pine.LNX.4.64.0906141011280.8507@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906151051240.19931@gentwo.org>
Date: Mon, 15 Jun 2009 17:58:11 +0300
Message-Id: <1245077891.23207.48.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 10:55 -0400, Christoph Lameter wrote:
> On Sun, 14 Jun 2009, Pekka J Enberg wrote:
> 
> > How about something like this? There should be no extra code in fastpaths
> > for production configs with this one.
> 
> Yes something like that would be good. More comments below.
> 
> > index 4d6004c..5e8cea1 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -1613,6 +1613,8 @@ another_slab:
> >  	deactivate_slab(s, c);
> >
> >  new_slab:
> > +	gfpflags &= slab_gfp_mask;
> > +
> 
> Move the processing of GFP_RECLAIM_MASK etc up to here from new_slab? Then
> the flow is also more logical. The flags handling is concentrated in one
> spot in the allocator and its more obvious how we handle gfp flags.

Sure. Will fix.

> > @@ -1668,13 +1670,14 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
> >  	struct kmem_cache_cpu *c;
> >  	unsigned long flags;
> >  	unsigned int objsize;
> > +	gfp_t real_gfp;
> >
> > -	gfpflags &= slab_gfp_mask;
> > +	real_gfp = gfpflags & slab_gfp_mask;
> >
> > -	lockdep_trace_alloc(gfpflags);
> > -	might_sleep_if(gfpflags & __GFP_WAIT);
> > +	lockdep_trace_alloc(real_gfp);
> > +	might_sleep_if(real_gfp & __GFP_WAIT);
> >
> > -	if (should_failslab(s->objsize, gfpflags))
> > +	if (should_failslab(s->objsize, real_gfp))
> >  		return NULL;
> >
> >  	local_irq_save(flags);
> 
> Dont do it there. Only modify the slow path.
> 
> Look at __might_sleep(). It already has an exception for system_state !=
> RUNNING. If it still triggers then add to the condition there.

But does this matter? When the debugging options are turned off, there
are no users for "real_gfp" and thus GCC optimizes everything away. For
debugging configs, the extra cacheline load doesn't matter, does it?

