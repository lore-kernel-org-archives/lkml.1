Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbXHVUTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbXHVUTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759962AbXHVUTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:19:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50085 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756434AbXHVUTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:19:17 -0400
Date: Wed, 22 Aug 2007 13:19:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070822200910.GA25687@Krystal>
Message-ID: <Pine.LNX.4.64.0708221316240.15775@schroedinger.engr.sgi.com>
References: <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com>
 <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
 <20070822000323.GG29691@Krystal> <p73fy2cz7bs.fsf@bingen.suse.de>
 <20070822003834.GB1400@Krystal> <Pine.LNX.4.64.0708211757360.3118@schroedinger.engr.sgi.com>
 <20070822134532.GA3769@Krystal> <Pine.LNX.4.64.0708221224550.14795@schroedinger.engr.sgi.com>
 <20070822200910.GA25687@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007, Mathieu Desnoyers wrote:

> * Christoph Lameter (clameter@sgi.com) wrote:
> >  void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
> > @@ -1577,7 +1590,10 @@ static void __slab_free(struct kmem_cach
> >  {
> >  	void *prior;
> >  	void **object = (void *)x;
> > +	unsigned long flags;
> >  
> > +	local_irq_save(flags);
> > +	put_cpu_no_resched();
> 
> Those two lines may skip a preempt_check.

Yes we cannot execute something else here.
 
> Could we change them to this instead ?
>   
>   put_cpu();
>   local_irq_save(flags);

Then the thread could be preempted and rescheduled on a different cpu 
between put_cpu and local_irq_save() which means that we loose the
state information of the kmem_cache_cpu structure.

> Otherwise, it would be good to call
> 
>   preempt_check_resched();
> 
>   After each local_irq_restore() in this function.

We could do that but maybe the frequency of these checks would be too 
high? When should the resched checks be used?
