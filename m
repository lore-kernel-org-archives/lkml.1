Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZALRnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZALRnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZALRnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:43:41 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41295 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbZALRnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:43:40 -0500
Date: Mon, 12 Jan 2009 09:43:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC, PATCH] kernel/rcu: add kfree_rcu
Message-ID: <20090112174332.GA14675@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200901021159.n02BxDLg024728@mail.q-ag.de> <49604BAD.5010405@cn.fujitsu.com> <4960603F.2030002@colorfullife.com> <496073AB.2030400@cn.fujitsu.com> <4960A9E8.3090309@colorfullife.com> <20090104200658.GN6958@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104200658.GN6958@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 12:06:58PM -0800, Paul E. McKenney wrote:
> On Sun, Jan 04, 2009 at 01:22:00PM +0100, Manfred Spraul wrote:
> > Lai Jiangshan wrote:
> >> I have not posted it. -:)
> >>   
> > Could you post it?
> >
> > Paul: What would break if we stop processing rcu entries in (cpu) order?
> 
> If I understand, you are suggesting that a given CPU process its RCU
> callbacks out of order.  This would break rcu_barrier(), so please do
> not do this.
> 
> If I misunderstood what you are suggesting, please enlighten me!

One other thing that might be really cool is for memory freed via RCU to
be treated as if it was cache-cold, which it is unless the RCU callback
needs to write to the memory block.  In the case of kfree_rcu(), the
callback should not need to do writes, so it might make sense to handle
the block differently than the typical hot-in-cache free.

							Thanx, Paul

> > The head->func(head) in rcu_do_batch() is probably a nightmare for the 
> > branch target predictor.
> >
> > What about:
> > - shrinking struct rcu_head to just a pointer (let's start with the goodie)
> > - Adding a register_rcu_callback() function.
> > It allocates the per-cpu storage for the rcu grace period lists.
> > Seperate lists for each registered callback - thus no need to copy the 
> > callback target into each rcu_head structure.
> > It returns a pointer/handle to these lists.
> > - call_rcu gets that handle instead of the plain function pointer.
> > - rcu_do_batch enumerates all registered callbacks. Thus first all 
> > callback_struct->func(head) calls for the first registered callback, then 
> > the calls for the 2nd callback, etc.
> > Better for the icache, better for the branch predictor.
> 
> Hmmm...  I guess that rcu_barrier() could put a callback on each of the
> resulting per-CPU lists for each CPU.  Making rcu_barrier() more
> expensive is probably not a problem.  But there would need to be a way
> of marking rcu_barrier()'s rcu_head structures, perhaps the bottom bit
> of the pointer (shudder!).
> 
> The rcu_offline code will of course need to traverse these lists in
> order to move the callbacks from an outgoing CPU.
> 
> It would also be necessary to inspect the current call_rcu() invocations
> in the kernel (not too big a job, as there are only about 100 of them).
> If there are any that rely on callbacks being invoked in order, these
> would need to be addressed if we are to do something like what you
> are suggesting.  I do not recall ever suggesting that people rely on
> such ordering, but given that people can read the code and see that
> rcu_barrier() already relies on it...
> 
> So if we do go this way, we will need to update the documentation.
> 
> The deep embedded guys would like a single-pointer rcu_head, and your
> approach seems better than the one I came up with a couple of years ago
> on page 11 of:
> 
> 	http://www.rdrop.com/users/paulmck/RCU/OLSrtRCU.2006.08.11a.pdf
> 
> At least assuming that the problems can be resolved.
> 
> I don't see how this helps the icache at all, but could see how it might
> help branch prediction.
> 
> > Paul: Do you have a test case that is suitable for benchmarking rcu?
> > Any workloads were rcu appears significantly in oprofile?
> > And: Do you know how many rcu entries are typically alive? How much memory 
> > is used for the function pointers?
> 
> The test cases I know of are those used to validate the performance of
> various RCU patches, most of which have been quite insensitive to the
> update-side overhead.  The only workloads that I am aware of where RCU
> update-side processing shows up are those running on hundreds of CPUs
> (hence hierarchical RCU).  Some workloads have many thousands of RCU
> callbacks in flight -- I believe that Dipankar Sarma measured something
> like 1600 per grace period on a file-system benchmark some years back.
> 
> The amount of memory used for the function pointers can be large, though
> many cases now union this space with other storage (e.g., struct dentry).
> The deep embedded guys have worried about it in the past, though I have
> not heard much from them in the past few years -- something about even
> cellphones having hundreds of megabytes of DRAM, I guess.  ;-)
> 
> So, in short, I am not sure that this will be worth the increase in code
> complexity, but it does sound like an interesting possibility.
> 
> 							Thanx, Paul
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
