Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab0CHWZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:25:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:48292 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755931Ab0CHWZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:25:36 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX188G9hIoEI8n3kpYE62slTFhGt8/UoqmwKOCeS5Jv
	b+1TNBQ+ePGWUV
Subject: Re: [patch 1/2] sched: check for prev_cpu == this_cpu in
 wake_affine()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1268075392.2830.57.camel@sbs-t61.sc.intel.com>
References: <20100305184213.829832580@sbs-t61.sc.intel.com>
	 <1267817792.6384.37.camel@marge.simson.net>
	 <1268075392.2830.57.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Date: Mon, 08 Mar 2010 23:25:29 +0100
Message-Id: <1268087129.6439.175.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 11:09 -0800, Suresh Siddha wrote:
> hi Mike,
> 
> On Fri, 2010-03-05 at 11:36 -0800, Mike Galbraith wrote:
> > Yeah, but with the 1 task + non-sync wakeup scenario, we miss the boat
> > because select_idle_sibling() uses wake_affine() success as it's
> > enabler.
> 
> But the wake_affine() decision is broken when this_cpu == prev_cpu. All
> we need to do is to fix that, to recover that ~9% improvement.

The wake_affine() decision isn't broken, it simply meaningless in that
case.  The primary decision is this cpu or previous cpu.  That's all
wake_affine() does.  If we have a serious imbalance, it says no, which
means "better luck next time", nothing more.  It's partner in crime is
active load balancing.

WRT the 9% improvement... we're talking about a single core yes?  No
alien cache with massive misses possible, yes?  IFF that's true, the
worst that can happen is you eat the price of running two schedulers vs
one.  The closer you get to a pure scheduler load, the more that appears
to matter.  In real life, there's very very frequently much more going
on that just scheduling, so these "is it 700ns or one whole usec"
benchmarks can distort reality.  If you are very close to only
scheduling, yes, select_idle_sibling() is a loser.  The cost of the
second scheduler is nowhere near free.

You can't get cheaper than one scheduler and preemption.  However, even
with something like TCP_RR (highly synchronous), I get better throughput
than a single core/single scheduler.  That for a pure latency benchmark,
communicating just as fast as the network stack can service.

The reason is fairness.  We don't insta-preempt, we have a bar that must
be reached.  If I tweak to increase preemption, you'll _see_ the cost of
running that second scheduler.  In reality, we have an idle core, this
load is entirely latency dominated, so cost of tapping that core is
negated.  It's a win, even for this heavy switching latency measurement
benchmark.  It's only a win because it does do a bit more than merely
schedule.

(worst case is pipes, pure scheduler, as pure as it gets, but even with
that there are cases where throughput gains are dramatic, because when
using two cores, you don't have to care about fairness, which is well
known to not necessarily be throughput's best friend)

marge:/root/tmp # netperf.sh 10
Starting netserver at port 12865
Starting netserver at hostname 0.0.0.0 port 12865 and family AF_UNSPEC
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 127.0.0.1 (127.0.0.1) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

16384  87380  1        1       10.00    107340.56
16384  87380
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 127.0.0.1 (127.0.0.1) port 0 AF_INET : cpu bind
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

16384  87380  1        1       10.00    103564.71
16384  87380

The first instance is free floating, the second is pinned to one core.
If I twiddle preemption, pinned will out perform free floating.  With
the preemption bar in place (a must), it's a modest win.

> > I have a slightly different patch for that in my tree.  There's no need
> > to even call wake_affine() since the result is meaningless.
> 
> I don't think your below fix is correct because:
> 
> 
> > -	if (affine_sd && wake_affine(affine_sd, p, sync))
> > -		return cpu;
> > +	if (affine_sd) {
> > +		if (cpu == prev_cpu)
> > +			return cpu;
> 
> 
> by this time, we have overwritten cpu using the select_idle_sibling()
> logic and cpu no longer points to this_cpu.

Yes, maybe.  And wake_affine() will say yeah or nay.  It only matters if
the decision _sticks_, ie we can't/don't adapt.  We only need
wake_affine() because of the "not now".  Set it up to always select an
idle core if available, watch what happens to buddy loads.
 
> What we need is a comparison with this_cpu.

I disagree.  It's really cheap to say if it was affine previously, wake
it affine again, but thereby you tie tasks to one core for no good
reason.  As tested, tasks which demonstrably _can_ effectively use two
cores were tied to one core with your patch, and suffered dramatic
throughput loss.

I really don't think a pure scheduler benchmark has any meaning beyond
overhead measurement.

	-Mike

