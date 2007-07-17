Return-Path: <linux-kernel-owner+w=401wt.eu-S936578AbXGQVpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936578AbXGQVpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbXGQVpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:45:43 -0400
Received: from 1wt.eu ([62.212.114.60]:3435 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbXGQVpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:45:42 -0400
Date: Tue, 17 Jul 2007 23:44:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070717214441.GA20208@1wt.eu>
References: <20070706173319.GA2356@elte.hu> <20070708174612.GA4035@1wt.eu> <20070709223950.GA29653@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070709223950.GA29653@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

sorry for the long delay, I've spent a week doing non-kernel work.

On Tue, Jul 10, 2007 at 12:39:50AM +0200, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > > The biggest user-visible change in -v19 is reworked sleeper 
> > > fairness: it's similar in behavior to -v18 but works more 
> > > consistently across nice levels. Fork-happy workloads (like kernel 
> > > builds) should behave better as well. There are also a handful of 
> > > speedups: unsigned math, 32-bit speedups, O(1) task pickup, 
> > > debloating and other micro-optimizations.
> > 
> > Interestingly, I also noticed the possibility of O(1) task pickup when 
> > playing with v18, but did not detect any noticeable improvement with 
> > it. Of course, it depends on the workload and I probably didn't 
> > perform the most relevant tests.
> 
> yeah - it's a small tweak. CFS is O(31) in sleep/wakeup so it's now all 
> a big O(1) family again :)

Yes, that's what I tried to explain to a guy once : what I like with log(N)
algos is that even with N very large, log(N) is always small, and it's
sometimes faster to perform log(N) fast operations than 1 slow operation.
That's also why I don't care about balanced trees : my unbalanced trees may
hold 32 levels for 32 carefully chosen values, while balanced trees will
have 5 levels (worst difference between both). If I can insert and delete
a node 6 times faster, I always win. And quite frankly, I'm not interested
at the 32 entries case in a tree :-)

> > V19 works very well here on 2.6.20.14. I could start 32k busy loops at 
> > nice +19 (I exhausted the 32k pids limit), and could still perform 
> > normal operations. I noticed that 'vmstat' scans all the pid entries 
> > under /proc, which takes ages to collect data before displaying a 
> > line. Obviously, the system sometimes shows some short latencies, but 
> > not much more than what you get from and SSH through a remote DSL 
> > connection.
> 
> great! I did not try to push it this far, yet.

Well, I borrowed two 1GB sticks because I discovered that one of my 512MB
had one defect bit. It was finally an opportunity for me to push the test
this far.

> > Here's a vmstat 1 output :
> > 
> >  r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
> > 32437  0  0      0 809724    488   6196    0    0     1     0  135     0 24 72 4
> > 32436  0  0      0 811336    488   6196    0    0     0     0  717     0 78 22 0
> 
> crazy :-)

indeed :-)

> > Amusingly, I started mpg123 during this test and it skipped quite a 
> > bit. After setting all tasks to SCHED_IDLE, it did not skip anymore. 
> > All this seems to behave like one could expect.
> 
> yeah. It behaves better than i expected in fact - 32K tasks is pushing 
> things quite a bit. (we've got a 32K PID limit for example)

Yes, and in fact, I suspect that we still have an O(N) or O(N^2) pid
allocation algo somewhere (I did not look at the code), because forking
was very very slow when reaching those numbers. I'll possibly check this
when I have some spare time, because it reminds me a trivial source port
ring allocator I wrote a few years ago which was O(1). With 32k pids, it
will only require 64kB RAM for the whole system, and we may even optimize
it to spread CPUs entry points in order to nearly always avoid lock
contention.

> > I also started 30k processes distributed in 130 groups of 234 chained 
> > by pipes in which one byte is passed. I get an average of 8000 in the 
> > run queue. The context switch rate is very low and sometimes even null 
> > in this test, maybe some of them are starving, I really do not know :
> > 
> >  r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
> > 7752  0  1      0 656892    244   4196    0    0     0     0  725     0 16 84  0
> 
> hm, could you profile this? We could have some bottleneck somewhere 
> (likely not in the scheduler) with that many tasks being runnable. [ 
> With CFS you can actually run a profiler under this workload ;-) ]

I may probably try some time later (not this week-end, I have some 2.4 to
work on).

> > In my tree, I have replaced the rbtree with the ebtree we talked 
> > about, but it did not bring any performance boost because, eventhough 
> > insert() and delete() are faster, the scheduler is already quite good 
> > at avoiding them as much as possible, mostly relying on rb_next() 
> > which has the same cost in both trees. All in all, the only variations 
> > I noticed were caused by cacheline alignment when I tried to reorder 
> > fields in the eb_node. So I will stop my experimentations here since I 
> > don't see any more room for improvement.
> 
> well, just a little bit of improvement would be nice to have too :)

Yes but I prefer to merge it where it really bring something (I'll have a
look at epoll, I noticed epollctl() was 30% slower under 2.6 with an rbtree
as it is under 2.4 with a hash). Then people will tell me "you're completely
dumb, you could have improved it that way!" and then, once it's optimized to
be always faster than the rbtree, we can switch CFS to it again ;-)

> 	Ingo

Cheers,
Willy

