Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZJYTcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZJYTcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 15:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZJYTcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 15:32:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:44690 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbZJYTcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 15:32:11 -0400
Date: Sun, 25 Oct 2009 12:33:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
Message-ID: <20091025123319.2b76bf69@infradead.org>
In-Reply-To: <1256492289.14241.40.camel@marge.simson.net>
References: <20091024125853.35143117@infradead.org>
	<20091024130432.0c46ef27@infradead.org>
	<20091024130728.051c4d7c@infradead.org>
	<1256453725.12138.40.camel@marge.simson.net>
	<20091025095109.449bac9e@infradead.org>
	<1256492289.14241.40.camel@marge.simson.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Oct 2009 18:38:09 +0100
Mike Galbraith <efault@gmx.de> wrote:
> > > Even if you're sharing a cache, there are reasons to wake
> > > affine.  If the wakee can preempt the waker while it's still
> > > eligible to run, wakee not only eats toasty warm data, it can
> > > hand the cpu back to the waker so it can make more and repeat
> > > this procedure for a while without someone else getting in
> > > between, and trashing cache. 
> > 
> > and on the flipside, and this is the workload I'm looking at,
> > this is halving your performance roughly due to one core being
> > totally busy while the other one is idle.
> 
> Yeah, the "one pgsql+oltp pair" in the numbers I posted show that
> problem really well.  If you can hit an idle shared cache at low load,
> go for it every time. 

sadly the current code does not do this ;(
my patch might be too big an axe for it, but it does solve this part ;)

I'll keep digging to see if we can do a more micro-incursion.

> Hm.  That looks like a bug, but after any task has scheduled a few
> times, if it looks like a synchronous task, it'll glue itself to it's
> waker's runqueue regardless.  Initial wakeup may disperse, but it will
> come back if it's not overlapping.

the problem is the "synchronous to WHAT" question.
It may be synchronous to the disk for example; in the testcase I'm
looking at, we get "send message to X. do some more code. hit a page
cache miss and do IO" quite a bit.

> > The numbers you posted are for a database, and only measure
> > throughput. There's more to the world than just databases /
> > throughput-only computing, and I'm trying to find low impact ways
> > to reduce the latency aspect of things. One obvious candidate is
> > hyperthreading/SMT where it IS basically free to switch to a
> > sibbling, so wake-affine does not really make sense there.
> 
> It's also almost free on my Q6600 if we aimed for idle shared cache.

yeah multicore with shared cache falls for me in the same bucket.
 
> I agree fully that affinity decisions could be more perfect than they
> are.  Getting it wrong is very expensive either way.

Looks like we agree on a key principle:
If there is a free cpu "close enough" (SMT or MC basically), the
wakee should just run on that. 

we may not agree on what to do if there's no completely free logical
cpu, but a much lighter loaded one instead.
but first we need to let code speak ;)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
