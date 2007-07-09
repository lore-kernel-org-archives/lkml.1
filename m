Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbXGIWki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbXGIWki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbXGIWka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:40:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54857 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbXGIWk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:40:29 -0400
Date: Tue, 10 Jul 2007 00:39:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070709223950.GA29653@elte.hu>
References: <20070706173319.GA2356@elte.hu> <20070708174612.GA4035@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070708174612.GA4035@1wt.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> > The biggest user-visible change in -v19 is reworked sleeper 
> > fairness: it's similar in behavior to -v18 but works more 
> > consistently across nice levels. Fork-happy workloads (like kernel 
> > builds) should behave better as well. There are also a handful of 
> > speedups: unsigned math, 32-bit speedups, O(1) task pickup, 
> > debloating and other micro-optimizations.
> 
> Interestingly, I also noticed the possibility of O(1) task pickup when 
> playing with v18, but did not detect any noticeable improvement with 
> it. Of course, it depends on the workload and I probably didn't 
> perform the most relevant tests.

yeah - it's a small tweak. CFS is O(31) in sleep/wakeup so it's now all 
a big O(1) family again :)

> V19 works very well here on 2.6.20.14. I could start 32k busy loops at 
> nice +19 (I exhausted the 32k pids limit), and could still perform 
> normal operations. I noticed that 'vmstat' scans all the pid entries 
> under /proc, which takes ages to collect data before displaying a 
> line. Obviously, the system sometimes shows some short latencies, but 
> not much more than what you get from and SSH through a remote DSL 
> connection.

great! I did not try to push it this far, yet.

> Here's a vmstat 1 output :
> 
>  r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
> 32437  0  0      0 809724    488   6196    0    0     1     0  135     0 24 72 4
> 32436  0  0      0 811336    488   6196    0    0     0     0  717     0 78 22 0

crazy :-)

> Amusingly, I started mpg123 during this test and it skipped quite a 
> bit. After setting all tasks to SCHED_IDLE, it did not skip anymore. 
> All this seems to behave like one could expect.

yeah. It behaves better than i expected in fact - 32K tasks is pushing 
things quite a bit. (we've got a 32K PID limit for example)

> I also started 30k processes distributed in 130 groups of 234 chained 
> by pipes in which one byte is passed. I get an average of 8000 in the 
> run queue. The context switch rate is very low and sometimes even null 
> in this test, maybe some of them are starving, I really do not know :
> 
>  r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
> 7752  0  1      0 656892    244   4196    0    0     0     0  725     0 16 84  0

hm, could you profile this? We could have some bottleneck somewhere 
(likely not in the scheduler) with that many tasks being runnable. [ 
With CFS you can actually run a profiler under this workload ;-) ]

> In my tree, I have replaced the rbtree with the ebtree we talked 
> about, but it did not bring any performance boost because, eventhough 
> insert() and delete() are faster, the scheduler is already quite good 
> at avoiding them as much as possible, mostly relying on rb_next() 
> which has the same cost in both trees. All in all, the only variations 
> I noticed were caused by cacheline alignment when I tried to reorder 
> fields in the eb_node. So I will stop my experimentations here since I 
> don't see any more room for improvement.

well, just a little bit of improvement would be nice to have too :)

	Ingo
