Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab0CEU0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:26:01 -0500
Received: from mail.gmx.net ([213.165.64.20]:44920 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750941Ab0CEU0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:26:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/QaYFJeLLQjbePk0MErP33ca8aW+q0f2fblZqW0v
	hU4eyMxgLmArPu
Subject: Re: [patch 2/2] sched: fix select_idle_sibling() logic in
 select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20100305184213.922106492@sbs-t61.sc.intel.com>
References: <20100305184213.829832580@sbs-t61.sc.intel.com>
	 <20100305184213.922106492@sbs-t61.sc.intel.com>
Content-Type: text/plain
Date: Fri, 05 Mar 2010 21:25:55 +0100
Message-Id: <1267820755.6384.85.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 10:39 -0800, Suresh Siddha wrote:
> plain text document attachment (fix_lat_ctx.patch)
> Performance improvements with this patch:
> "lat_ctx -s 0 2" ~22usec (before-this-patch)	~5usec (after-this-patch)

Hm.  On my Q6600 box, it's nowhere near that.

> There are number of things wrong with the select_idle_sibling() logic
> 
> a) Once we select the idle sibling, we use that domain (spanning the cpu that
>    the task is currently woken-up and the idle sibling that we found) in our
>    wake_affine() comparisons. This domain is completely different from the
>    domain(we are supposed to use) that spans the cpu that the task currently
>    woken-up and the cpu where the task previously ran.
> 
> b) We do select_idle_sibling() check only for the cpu that the task is
>    currently woken-up on. If the wake_affine makes the decision of selecting
>    the cpu where the task previously ran, doing a select_idle_sibling() check
>    for that cpu also helps and we don't do this currently.
>  
> c) Also, selelct_idle_sibling() should also treat the current cpu as an idle
>    cpu if it is a sync wakeup and we have only one task running.

I'm going to have to crawl over and test the above, but this bit sounds
like a decidedly un-good thing to do.  Maybe I'm misunderstanding.

Check these lmbench3 numbers, ie the AF UNIX numbers in the last three
runs vs the three above that.  That's what I get with the load running
on one core because I disabled select_idle_sibling() for these runs to
compare cost/benefit of using an idle shared cache core.  The wakeup in
question is a sync wakeup, otherwise, we'd be taking the same beating
TCP is in stock 31.12 and stock 33.  (first 2 sets of triple runs)

Calling the waking cpu idle in that case is a mistake.  Just because the
sync hint was used does not mean there is no gain to be had.  In the
case of this benchmark proggy, that gain is a _lot_, same for the TCP
proggy after I enabled sync hint in smpx tree.  We don't want high
frequency cache misses for sure, but we also don't want to assume
there's nothing to be had by using another core.  There's currently no
way to tell if you can gain by using another core or not, other than to
try it.

If you run tip, you can see a throughput gain even with the pipe test,
because there's a buffer increase patch there, which combined with
owner_spin, produces a gain even with the highly synchronous pipe test,
select_idle_sibling() is only the enabler (hard to spin if on same core
as mutex owner:).


*Local* Communication latencies in microseconds - smaller is better
---------------------------------------------------------------------
Host                 OS 2p/0K  Pipe AF     UDP  RPC/   TCP  RPC/ TCP
                        ctxsw       UNIX         UDP         TCP conn
--------- ------------- ----- ----- ---- ----- ----- ----- ----- ----
marge     2.6.31.12-smp 0.730 2.845 4.85 6.463  11.3  26.2  14.9  31.
marge     2.6.31.12-smp 0.750 2.864 4.78 6.460  11.2  22.9  14.6  31.
marge     2.6.31.12-smp 0.710 2.835 4.81 6.478  11.5  11.0  14.5  30.
marge        2.6.33-smp 1.320 4.552 5.02 9.169  12.5  26.5  15.4  18.
marge        2.6.33-smp 1.450 4.621 5.45 9.286  12.5  11.4  15.4  18.
marge        2.6.33-smp 1.450 4.589 5.53 9.168  12.6  27.5  15.4  18.
marge       2.6.33-smpx 1.160 3.565 5.97 7.513  11.3 9.776  13.9  18.
marge       2.6.33-smpx 1.140 3.569 6.02 7.479  11.2 9.849  14.0  18.
marge       2.6.33-smpx 1.090 3.563 6.39 7.450  11.2 9.785  14.0  18.
marge       2.6.33-smpx 0.730 2.665 4.85 6.565  11.9  10.3  15.2  31.
marge       2.6.33-smpx 0.740 2.701 4.03 6.573  11.7  10.3  15.4  31.
marge       2.6.33-smpx 0.710 2.753 4.86 6.533  11.7  10.3  15.3  31.


*Local* Communication bandwidths in MB/s - bigger is better
-----------------------------------------------------------------------------
Host                OS  Pipe AF    TCP  File   Mmap  Bcopy  Bcopy  Mem   Mem
                             UNIX      reread reread (libc) (hand) read write
--------- ------------- ---- ---- ---- ------ ------ ------ ------ ---- -----
marge     2.6.31.12-smp 2821 2971 762. 2829.2 4799.0 1243.0 1230.3 4469 1682.
marge     2.6.31.12-smp 2824 2931 760. 2833.3 4736.5 1239.5 1235.8 4462 1678.
marge     2.6.31.12-smp 2796 2936 1139 2843.3 4815.7 1242.8 1234.6 4471 1685.
marge        2.6.33-smp 2670 5151 739. 2816.6 4768.5 1243.7 1237.2 4389 1684.
marge        2.6.33-smp 2627 5126 1135 2806.9 4783.1 1245.1 1236.1 4413 1684.
marge        2.6.33-smp 2582 5037 1137 2799.6 4755.4 1242.0 1239.1 4471 1683.
marge       2.6.33-smpx 2848 5184 2972 2820.5 4804.8 1242.6 1236.9 4315 1686.
marge       2.6.33-smpx 2804 5183 2934 2822.8 4759.3 1245.0 1234.7 4462 1688.
marge       2.6.33-smpx 2729 5177 2920 2837.6 4820.0 1246.9 1238.5 4467 1684.
marge       2.6.33-smpx 2843 2896 1928 2786.5 4751.2 1242.2 1238.6 4493 1682.
marge       2.6.33-smpx 2869 2886 1936 2841.4 4748.9 1244.3 1237.7 4456 1683.
marge       2.6.33-smpx 2845 2895 1947 2836.0 4813.6 1242.7 1236.3 4473 1674.




