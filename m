Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbXGHRrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbXGHRrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 13:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbXGHRrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 13:47:12 -0400
Received: from 1wt.eu ([62.212.114.60]:3312 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbXGHRrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 13:47:12 -0400
Date: Sun, 8 Jul 2007 19:46:13 +0200
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
Message-ID: <20070708174612.GA4035@1wt.eu>
References: <20070706173319.GA2356@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070706173319.GA2356@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo !

On Fri, Jul 06, 2007 at 07:33:19PM +0200, Ingo Molnar wrote:
> 
> i'm pleased to announce release -v19 of the CFS scheduler patchset.
> 
> The rolled-up CFS patch against today's -git kernel, v2.6.22-rc7, 
> v2.6.22-rc6-mm1, v2.6.21.5 or v2.6.20.14 can be downloaded from the 
> usual place:
> 
>     http://people.redhat.com/mingo/cfs-scheduler/
>  
> The biggest user-visible change in -v19 is reworked sleeper fairness: 
> it's similar in behavior to -v18 but works more consistently across nice 
> levels. Fork-happy workloads (like kernel builds) should behave better 
> as well. There are also a handful of speedups: unsigned math, 32-bit 
> speedups, O(1) task pickup, debloating and other micro-optimizations.

Interestingly, I also noticed the possibility of O(1) task pickup when
playing with v18, but did not detect any noticeable improvement with it.
Of course, it depends on the workload and I probably didn't perform the
most relevant tests.

V19 works very well here on 2.6.20.14. I could start 32k busy loops at
nice +19 (I exhausted the 32k pids limit), and could still perform normal
operations. I noticed that 'vmstat' scans all the pid entries under /proc,
which takes ages to collect data before displaying a line. Obviously, the
system sometimes shows some short latencies, but not much more than what
you get from and SSH through a remote DSL connection.

Here's a vmstat 1 output :

 r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
32437  0  0      0 809724    488   6196    0    0     1     0  135     0 24 72 4
32436  0  0      0 811336    488   6196    0    0     0     0  717     0 78 22 0
32436  0  0      0 812956    488   6196    0    0     0     0  727     0 79 21 0
32436  0  0      0 810164    400   6196    0    0     0     0  707     0 80 20 0
32436  0  0      0 815116    400   6436    0    0     0     0  769     0 77 23 0
32436  0  0      0 811644    400   6436    0    0     0     0  715     0 80 20 0

Amusingly, I started mpg123 during this test and it skipped quite a bit.
After setting all tasks to SCHED_IDLE, it did not skip anymore. All this
seems to behave like one could expect.

I also started 30k processes distributed in 130 groups of 234 chained by pipes
in which one byte is passed. I get an average of 8000 in the run queue. The
context switch rate is very low and sometimes even null in this test, maybe
some of them are starving, I really do not know :

 r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
7752  0  1      0 656892    244   4196    0    0     0     0  725     0 16 84  0
7781  0  1      0 656768    244   4196    0    0     0     0  724     0 16 84  0
8000  0  1      0 656916    244   4196    0    0     0     0 2631     0  9 91  0
8025  0  1      0 656916    244   4196    0    0     0     0 2023     0 11 89  0
8083  0  1      0 659124    244   4196    0    0     0     0 3379     0 10 90  0
8054  0  1      0 658752    244   4196    0    0     0     0  726     0 17 83  0

With fewer of them, I can achieve very high context switch rates, well above
what I got with v18 (around 515k) :

 r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
48  0  0      0 1977580   5196  49900    0    0     0    28  261 579893 23 77  0
44  0  0      0 1977580   5196  49900    0    0     0     0  253 578454 17 83  0
48  0  0      0 1977580   5196  49900    0    0     0     0  254 574118 22 78  0
41  0  0      0 1977580   5196  49900    0    0     0     0  253 579261 23 77  0

(this is still on my dual athlon 1.5 GHz).

In my tree, I have replaced the rbtree with the ebtree we talked about,
but it did not bring any performance boost because, eventhough insert()
and delete() are faster, the scheduler is already quite good at avoiding
them as much as possible, mostly relying on rb_next() which has the same
cost in both trees. All in all, the only variations I noticed were caused
by cacheline alignment when I tried to reorder fields in the eb_node. So
I will stop my experimentations here since I don't see any more room for
improvement.

>  - debug: split out the debugging data into CONFIG_SCHED_DEBUG.

Hmmm that must be why I do not have /proc/sched_debug anymore ;-)

> As usual, any sort of feedback, bugreport, fix and suggestion is more 
> than welcome!

Done !

Cheers,
Willy

