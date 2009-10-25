Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZJYRi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZJYRi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 13:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbZJYRiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 13:38:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:53306 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753726AbZJYRiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 13:38:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1//a3dDmR3/U6BZQfVKiDnVH2WQgqRth3CUbiv4GF
	JPSPY4n5fMxOVE
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091025095109.449bac9e@infradead.org>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
	 <20091024130728.051c4d7c@infradead.org>
	 <1256453725.12138.40.camel@marge.simson.net>
	 <20091025095109.449bac9e@infradead.org>
Content-Type: text/plain
Date: Sun, 25 Oct 2009 18:38:09 +0100
Message-Id: <1256492289.14241.40.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-25 at 09:51 -0700, Arjan van de Ven wrote:
> On Sun, 25 Oct 2009 07:55:25 +0100
> Mike Galbraith <efault@gmx.de> wrote:
> > Even if you're sharing a cache, there are reasons to wake affine.  If
> > the wakee can preempt the waker while it's still eligible to run,
> > wakee not only eats toasty warm data, it can hand the cpu back to the
> > waker so it can make more and repeat this procedure for a while
> > without someone else getting in between, and trashing cache. 
> 
> and on the flipside, and this is the workload I'm looking at,
> this is halving your performance roughly due to one core being totally
> busy while the other one is idle.

Yeah, the "one pgsql+oltp pair" in the numbers I posted show that
problem really well.  If you can hit an idle shared cache at low load,
go for it every time.  The rest of the numbers just show how big the
penalty is if you solve affinity problems with an 8" howitzer :)

> My workload is a relatively simple situation: firefox is starting up
> and talking to X. I suspect this is representative for many X using
> applications in the field. The application sends commands to X, but is
> not (yet) going to wait for a response, it has more work to do. 
> In this case the affine behavior does not only cause latency, but it
> also eats the throughput performance.

Yeah.  Damned if you do, damned if you don't.

> This is due to a few things that compound, but a key one is this code:
> 
>         if (sd_flag & SD_BALANCE_WAKE) {
>                 if (sched_feat(AFFINE_WAKEUPS) &&
>                     cpumask_test_cpu(cpu, &p->cpus_allowed))
>                         want_affine = 1;
>                 new_cpu = prev_cpu;
>         }
> 
> the problem is that 
> 
>         if (affine_sd && wake_affine(affine_sd, p, sync)) {
>                 new_cpu = cpu;
>                 goto out;
>         }
> 
> this then will trigger later, as long as there is any domain that has
> SD_WAKE_AFFINE set ;(

And the task looks like a synchronous task.

> (part of that problem is that the code that sets affine_sd is done
> before the
>                if (!(tmp->flags & sd_flag))
>                         continue;
> test)

Hm.  That looks like a bug, but after any task has scheduled a few
times, if it looks like a synchronous task, it'll glue itself to it's
waker's runqueue regardless.  Initial wakeup may disperse, but it will
come back if it's not overlapping.

> The numbers you posted are for a database, and only measure throughput.
> There's more to the world than just databases / throughput-only
> computing, and I'm trying to find low impact ways to reduce the latency
> aspect of things. One obvious candidate is hyperthreading/SMT where it
> IS basically free to switch to a sibbling, so wake-affine does not
> really make sense there.

It's also almost free on my Q6600 if we aimed for idle shared cache.

I agree fully that affinity decisions could be more perfect than they
are.  Getting it wrong is very expensive either way.

	-Mike

