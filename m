Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYDBMeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYDBMeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYDBMeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:34:09 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22436 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbYDBMeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:34:07 -0400
Date: Wed, 2 Apr 2008 14:34:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, paulmck@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402123402.GG12774@kernel.dk>
References: <20080402110718.GU12774@kernel.dk> <1207134536.8514.773.camel@twins> <20080402111422.GW12774@kernel.dk> <1207135212.8514.782.camel@twins> <20080402113258.GY12774@kernel.dk> <1207136230.8514.791.camel@twins> <20080402114243.GZ12774@kernel.dk> <1207136867.8514.796.camel@twins> <20080402115337.GD12774@kernel.dk> <1207139162.8514.806.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207139162.8514.806.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02 2008, Peter Zijlstra wrote:
> On Wed, 2008-04-02 at 13:53 +0200, Jens Axboe wrote:
> > On Wed, Apr 02 2008, Peter Zijlstra wrote:
> > > On Wed, 2008-04-02 at 13:42 +0200, Jens Axboe wrote:
> > > > On Wed, Apr 02 2008, Peter Zijlstra wrote:
> > > > > On Wed, 2008-04-02 at 13:32 +0200, Jens Axboe wrote:
> > > > > > On Wed, Apr 02 2008, Peter Zijlstra wrote:
> > > > > > > On Wed, 2008-04-02 at 13:14 +0200, Jens Axboe wrote:
> > > > > > > > On Wed, Apr 02 2008, Peter Zijlstra wrote:
> > > > > > > > > On Wed, 2008-04-02 at 13:07 +0200, Jens Axboe wrote:
> > > > > > > > > > On Wed, Apr 02 2008, Pekka Enberg wrote:
> > > > > > > > > > > Hi Paul,
> > > > > > > > > > > 
> > > > > > > > > > > On Wed, Apr 2, 2008 at 1:55 PM, Paul E. McKenney
> > > > > > > > > > > <paulmck@linux.vnet.ibm.com> wrote:
> > > > > > > > > > > >  I will check this when I get back to some bandwidth -- but in the meantime,
> > > > > > > > > > > >  does kmemcheck special-case SLAB_DESTROY_BY_RCU?  It is legal to access
> > > > > > > > > > > >  newly-freed items in that case, as long as you did rcu_read_lock()
> > > > > > > > > > > >  before gaining a reference to them and don't hold the reference past
> > > > > > > > > > > >  the matching rcu_read_unlock().
> > > > > > > > > > > 
> > > > > > > > > > > No, kmemcheck is work in progress and does not know about
> > > > > > > > > > > SLAB_DESTROY_BY_RCU yet. The reason I asked Vegard to post the warning
> > > > > > > > > > > was because Peter, Vegard, and myself identified this particular
> > > > > > > > > > > warning as a real problem. But yeah, kmemcheck can cause false
> > > > > > > > > > > positives for RCU for now.
> > > > > > > > > > 
> > > > > > > > > > Makes sense, and to me Pauls analysis of the code looks totally correct
> > > > > > > > > > - there's no bug there, at least related to hlist traversal and
> > > > > > > > > > kmem_cache_free(), since we are under rcu_read_lock() and thus hold off
> > > > > > > > > > the grace for freeing.
> > > > > > > > > 
> > > > > > > > > but what holds off the slab allocator re-issueing that same object and
> > > > > > > > > someone else writing other stuff into it?
> > > > > > > > 
> > > > > > > > Nothing, that's how rcu destry works here. But for the validation to be
> > > > > > > > WRONG radix_tree_lookup(..., old_key) must return cic for new_key, not
> > > > > > > > NULL.
> > > > > > > > 
> > > > > > > 
> > > > > > > 
> > > > > > > 	A				B			C
> > > > > > > 
> > > > > > > cfq_cic_lookup(cfqd_1, ioc)
> > > > > > > 
> > > > > > >   rcu_read_lock()
> > > > > > >   cic = radix_tree_lookup(, cfqd_q);
> > > > > > > 
> > > > > > > 					cfq_cic_free()
> > > > > > >   					
> > > > > > > 								cfq_cic_link(cfqd_2, ioc,)
> > > > > > > 
> > > > > > >   rcu_read_unlock()
> > > > > > > 
> > > > > > > 
> > > > > > > and now we have that:
> > > > > > > 
> > > > > > >   cic->key == cfqd_2
> > > > > > > 
> > > > > > > 
> > > > > > > I'm not seeing anything stopping this from happening.
> > > > > > 
> > > > > > I don't follow your A-B-C here, what do they refer to?
> > > > > 
> > > > > A does a radix_tree_lookup() of cfqd_1 (darn typos)
> > > > > B does a kfree of the same cic found by A
> > > > > C does an alloc and gets the same cic as freed by B and inserts it
> > > > >   in a different location.
> > > > > 
> > > > > So that when we return to A, cic->key == cfqd_2 even though we did a
> > > > > lookup for cfqd_1.
> > > > 
> > > > That I follow, my question was if A, B, and C refer to different
> > > > processes but with a shared io context? I'm assuming that is correct...
> > > 
> > > Ah, yeah, whatever is needed to make this race happen :-)
> > 
> > The only place where you'll have multiple processes involved with this
> > at all is if they share io contexts. That is also why the bug isn't that
> > critical, since it's not possible right now (CLONE_IO flag must be
> > used).
> 
> There are 3 races here:
> 
>  1) A continues with another object than intended
>     (requires CLONE_IO)
> 
>  2) A does hlist_for_each_rcu() and races with B,C so that
>     we continue the iteration on a possibly unrelated list.
> 
>  3) cic is freed after the !cic->key check.
> 
> I'm not familiar enough with the code yet to see if 3 really is an
> possibility. But from what I can see there is nothing guarding its
> existence.

All 3 require CLONE_IO, because if that is not set, there's a 1:1
mapping between a process and io context (no sharing occurs).

-- 
Jens Axboe

