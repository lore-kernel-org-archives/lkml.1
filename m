Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZAEV5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZAEV5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZAEV5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:57:30 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37535 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbZAEV53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:57:29 -0500
Date: Mon, 5 Jan 2009 13:57:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Peter Klotz <peter.klotz@aon.at>,
       stable@kernel.org, Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re:
	BUG: soft lockup - is this XFS problem?)
Message-ID: <20090105215727.GQ6959@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090105014821.GA367@wotan.suse.de> <20090105041959.GC367@wotan.suse.de> <20090105064838.GA5209@wotan.suse.de> <49623384.2070801@aon.at> <20090105164135.GC32675@wotan.suse.de> <alpine.LFD.2.00.0901050859430.3057@localhost.localdomain> <20090105180008.GE32675@wotan.suse.de> <alpine.LFD.2.00.0901051027011.3057@localhost.localdomain> <20090105201258.GN6959@linux.vnet.ibm.com> <alpine.LFD.2.00.0901051224110.3057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901051224110.3057@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 12:39:14PM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 5 Jan 2009, Paul E. McKenney wrote:
> > 
> > My guess is that Nick believes that the value in *pslot cannot change
> > in such as way as to cause radix_tree_is_indirect_ptr()'s return value
> > to change within a given RCU grace period, and that Linus disagrees.
> 
> Oh, it's entirely possible that there are some lifetime rules or others 
> that make it impossible for things to go from "not indirect" -> 
> "indirect". So if that was Nick's point, then I'm not "disagreeing" per 
> se.
> 
> What I'm disagreeing about is that Nick apparently thinks that this is all 
> subtle code, and as a result we should add barriers in some very 
> non-obvious places.
> 
> While _I_ think that the problem isn't properly solved by barriers, but by 
> just making the code less subtle. If the barrier only exists because of 
> the reload issue, then the obvious solution - to me - is to just use what 
> is already the proper accessor function that forces a nice reload. That 
> way the compiler is forced to create code that does what the source 
> clearly means it to do, regardless of any barriers at all.
> 
> Barriers in general should be the _last_ thing added. And if they are 
> added, they should be added as deeply in the call-chain as possible, so 
> that we don't need to add them in multiple call-sites. Again, using the 
> rcu_dereference() approach seems to solve that issue too - rather than add 
> three barriers in three different places, we just add the proper 
> dereference in _one_ place.

I don't have any argument with this line of reasoning, and am myself a bit
puzzled as to why rcu_dereference() isn't the right tool for Nick's job.
Then again, I don't claim to fully understand what he is trying to do.

> > Whatever the answer, I would argue for -at- -least- a comment explaining
> > why it is safe.  I am not seeing the objection to rcu_dereference(), but
> > I must confess that it has been awhile since I have looked closely at
> > the radix_tree code.  :-/
> 
> And I'm actually suprised that gcc can generate the problematic code in 
> the first place. I'd expect that a "atomic_add_unless()" would always be 
> at LEAST a compiler barrier, even if it isn't necessarily a CPU memory 
> barrier.
> 
> But because we inline it, and because we allow gcc to see that it doesn't 
> do anything if it gets just the right value from memory, I guess gcc ends 
> up able to change the "for()" loop so that the first iteration can exit 
> specially, and then for that case (and no other case) it can cache 
> variables over the whole atomic_add_unless().
> 
> Again, that's very fragile. The fact that Documentation/atomic_ops.txt 
> says that the failure case doesn't contain any barriers is really _meant_ 
> to be about the architecture-specific CPU barriers, not so much about 
> something as simple as a compiler re-ordering. 
> 
> So while I think that we should use rcu_dereference() (regardless of any 
> other issues), I _also_ think that part of the problem really is the 
> excessive subtlety in the whole code, and the (obviously very surprising) 
> fact that gcc could end up caching an unrelated memory load across that 
> whole atomic op.
> 
> Maybe we should make atomics always imply a compiler barrier, even when 
> they do not imply a memory barrier. The one exception would be the 
> (special) case of "atomic_read()/atomic_set()", which don't really do any 
> kind of complex operation at all, and where we really do want the compiler 
> to be able to coalesce multiple atomic_reads() to a single one.
> 
> In contrast, there's no sense in allowing the compiler to coalesce a 
> "atomic_add_unless()" with anything else. Making it a compiler barrier 
> (possibly by uninlining it, or just adding a barrier to it) would also 
> have avoided the whole subtle case - which is always a good thing.

That makes a lot of sense to me!

							Thanx, Paul
