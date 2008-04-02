Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbYDBUSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbYDBUSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761174AbYDBUQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:16:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54480 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbYDBUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:15:54 -0400
Date: Wed, 2 Apr 2008 13:15:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402201551.GL9333@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI> <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu> <20080402105539.GA5610@linux.vnet.ibm.com> <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com> <20080402160809.GA4123@linux.vnet.ibm.com> <19f34abd0804020915k210277bbmb6b9aa28f282bb42@mail.gmail.com> <Pine.LNX.4.64.0804021924280.6839@sbz-30.cs.Helsinki.FI> <20080402182352.GF9333@linux.vnet.ibm.com> <84144f020804021253i7e08e83fve3f2707063fc64d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020804021253i7e08e83fve3f2707063fc64d1@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 10:53:53PM +0300, Pekka Enberg wrote:
> Hi Paul,
> 
> On Wed, Apr 02, 2008 at 07:32:26PM +0300, Pekka J Enberg wrote:
> > > Well, maybe we can add two new states: RCU_FREED and RCU_VALIDATED? The
> > > object is flagged with the first one as soon as an object is handed over
> > > to kmem_cache_free() and the latter needs to hook to the validation phase
> > > of RCU (how is that done btw?). Then kmemcheck could even give a better
> > > error message: "RCU-freed object used without validation."
> > >
> > > And with delayed free for kmemcheck we discussed before, we'd hold on to
> > > the objects long enough to actually see these error conditions.
> 
> On Wed, Apr 2, 2008 at 9:23 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >  Well, one approach would be to add an rcu_head to the kmem_cache
> >  structure, along with a flag stating that the rcu_head is in use.  I hope
> >  that there is a better approach, as this introduces a lock roundtrip
> >  into kmemcheck_slab_free().  Is there a better place to put the rcu_head?
> >  Perhaps into the per-CPU allocator?  But then we have to track which
> >  CPU has which mark pending, and there are only so many bits in a byte,
> >  as the SGI guys would be quick to point out
> 
> I suppose you haven't actually run kmemcheck on your machine? We're
> taking a page fault for _every_ memory access so a lock round-trip in
> the SLAB_RCU case is probably not that bad performance-wise :-).

Coward that I am, no I have not.  ;-)

The thing that worries me even more than the lock is the need to keep
track of the addresses.

Then again, if you are taking a page fault on every access, perhaps not
such a big deal to allocate the memory and link it into a list...
But yikes!!!  ;-)

							Thanx, Paul
