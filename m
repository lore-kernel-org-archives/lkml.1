Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab0BAKtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:49:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:37089 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab0BAKtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:49:06 -0500
Date: Mon, 1 Feb 2010 21:49:01 +1100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
 switch at runqueue lock/unlock
Message-ID: <20100201104901.GH12759@laptop>
References: <20100131205254.407214951@polymtl.ca>
 <20100131210013.446503342@polymtl.ca>
 <20100201073341.GH9085@laptop>
 <1265017350.24455.122.camel@laptop>
 <20100201101142.GE12759@laptop>
 <1265020561.24455.142.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265020561.24455.142.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:36:01AM +0100, Peter Zijlstra wrote:
> On Mon, 2010-02-01 at 21:11 +1100, Nick Piggin wrote:
> > All, but one at a time, no? How much of a DoS really is taking these
> > locks for a handful of cycles each, per syscall?
> 
> I was more worrying about the cacheline trashing than lock hold times
> there.

Well, same issue really. Look at all the unprived files in /proc
for example that can look through all per-cpu cachelines. It just
takes a single read syscall to do a lot of them too.

 
> > I mean, we have LOTS of syscalls that take locks, and for a lot longer,
> > (look at dcache_lock).
> 
> Yeah, and dcache is a massive pain, isn't it ;-)

My point is, I don't think it is something we can realistically
care much about and it is nowhere near a new or unique problem
being added by this one patch.

It is really a RoS, reduction of service, rather than a DoS. And
any time we allow an unpriv user on our system, we have RoS potential :)

 
> > I think we basically just have to say that locking primitives should be
> > somewhat fair, and not be held for too long, it should more or less
> > work.
> 
> Sure, it'll more of less work, but he's basically making rq->lock a
> global lock instead of a per-cpu lock.
> 
> > If the locks are getting contended, then the threads calling
> > sys_membarrier are going to be spinning longer too, using more CPU time,
> > and will get scheduled away...
> 
> Sure, and increased spinning reduces the total throughput.
> 
> > If there is some particular problem on -rt because of the rq locks,
> > then I guess you could consider whether to add more overhead to your
> > ctxsw path to reduce the problem, or simply not support sys_membarrier
> > for unprived users in the first place.
> 
> Right, for -rt we might need to do that, but its just that rq->lock is a
> very hot lock, and adding basically unlimited trashing to it didn't seem
> like a good idea.
> 
> Also, I'm thinking making it a priv syscall basically renders it useless
> for Mathieu.

Well I just mean that it's something for -rt to work out. Apps can
still work if the call is unsupported completely.
 

> Anyway, it might be I'm just paranoid... but archs with large core count
> and lazy tlb flush seem particularly vulnerable.
