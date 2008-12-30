Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbYL3OQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbYL3OQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 09:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYL3OQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 09:16:17 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:19296 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbYL3OQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 09:16:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aIk9iWskgJL1iWKwMlX6MDgQqFAhLFb5a6z3+n2kh2e1DOU36lA9BLRtzv2wmocpPN
         t740aJmRbDZc6fEOPckp1UP1quiPAKTsc1/CI6AbfS3a2El7Rmh4cKP+VsVEup6qYbyy
         8zCxfX89qcb7/iXOfVgBbcNTA0c7ILiE/VUnE=
Date: Tue, 30 Dec 2008 15:16:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081230141608.GA5722@nowhere>
References: <4959443f.09a1660a.44f3.2686@mx.google.com> <20081229220937.GC5829@nowhere> <1230623364.6091.9.camel@penberg-laptop> <20081230081600.GD2455@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230081600.GD2455@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 09:16:00AM +0100, Ingo Molnar wrote:
> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Hi Frederic,
> > 
> > On Mon, 2008-12-29 at 23:09 +0100, Frederic Weisbecker wrote:
> > > Pekka, note that I would be pleased to add statistical tracing on
> > > this tracer, but I would need a hashtable, or an array, or a list, or whatever
> > > iterable to insert the data into the stat tracing api.
> > > 
> > > But I don't know your projects about this... whether you wanted to use a section
> > > or something else...
> > 
> > It really depends on what we're tracing. If we're interested in just the 
> > allocation hotspots, a section will do just fine. However, if we're 
> > tracing memory footprint, we need to take into store the object pointer 
> > returned from kmalloc() and kmem_cache_alloc() so we can update 
> > call-site statistics properly upon kfree().
> > 
> > So I suppose we need both, a section for per call-site statistics and a 
> > hash table for the object -> call-site mapping.
> 
> 1)
> 
> i think the call_site based tracking should be a built-in capability - the 
> branch tracer needs that too for example. That would also make it very 
> simple on the usage place: you wouldnt have to worry about sections in 
> slub.c/etc.


I think that too. Can we use sections here? The traced functions are not
directly kmalloc/kmem_cache_alloc and to use a section which contains the
per site allocation requests, such a thing is required (we can't build a section
with per site allocations requests by using intermediate level allocation function
I fear...).
 

> 2)
> 
> i think a possibly useful intermediate object would be the slab cache 
> itself, which could be the basis for some highlevel stats too. It would 
> probably overlap /proc/slabinfo statistics but it's a natural part of this 
> abstraction i think.
> 
> 3)
> 
> the most lowlevel (and hence most allocation-footprint sensitive) object 
> to track would be the memory object itself. I think the best approach 
> would be to do a static, limited size hash that could track up to N memory 
> objects.
> The advantage of such an approach is that it does not impact allocation 
> patterns at all (besides the one-time allocation cost of the hash itself 
> during tracer startup).
> 
> The disadvantage is when an overflow happens: the sizing heuristics would 
> get the size correct most of the time anyway, so it's not a practical 
> issue. There would be some sort of sizing control similar to 
> /debug/tracing/buffer_size_kb, and a special trace entry that signals an 
> 'overflow' of the hash table. (in that case we wont track certain objects 
> - but it would be clear from the trace output what happens and the hash 
> size can be adjusted.)
> 
> Another advantage would be that it would trivially not interact with any 
> allocator - because the hash itself would never 'allocate' in any dynamic 
> way. Either there are free entries available (in which case we use it), or 
> not - in which case we emit an hash-overflow trace entry.
> 
> And this too would be driven from ftrace mainly - the SLAB code would only 
> offer the alloc+free callbacks with the object IDs. [ and this means that 
> we could detect memory leaks by looking at the hash table and print out 
> the age of entries :-) ]
> 
> How does this sound to you?
> 
> 	Ingo

That looks good. Since we can have an overflow event, it would always be possible
to built-in enlarge it for debugging purposes....

