Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbXCWFzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbXCWFzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 01:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXCWFzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 01:55:24 -0400
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:58675 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201AbXCWFzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 01:55:23 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: RSDL v0.31
Date: Fri, 23 Mar 2007 16:59:19 +1100
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Willy Tarreau <w@1wt.eu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703042335.26785.a1426z@gawab.com> <200703230950.51716.kernel@kolivas.org> <1174624794.6554.64.camel@Homer.simpson.net>
In-Reply-To: <1174624794.6554.64.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703231659.20291.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 March 2007 15:39, Mike Galbraith wrote:
> On Fri, 2007-03-23 at 09:50 +1100, Con Kolivas wrote:
> > Now to figure out some meaningful cheap way of improving this accounting.
>
> The accounting is easy iff tick resolution is good enough, the deadline
> mechanism is harder.  I did the "quota follows task" thing, but nothing
> good happens.  That just ensured that the deadline mechanism kicks in
> constantly because tick theft is a fact of tick-based life.  A
> reasonable fudge factor would help, but...
>
> I see problems wrt with trying to implement the deadline mechanism.
>
> As implemented, it can't identify who is doing the stealing (which
> happens constantly, even if userland if 100% hog) because of tick
> resolution accounting.  If you can't identify the culprit, you can't
> enforce the quota, and quotas which are not enforced are, strictly
> speaking, not quotas.  At tick time, you can only close the barn door
> after the cow has been stolen, and the thief can theoretically visit
> your barn an infinite number of times while you aren't watching the
> door.  ("don't blink" scenarios, and tick is backward-assward blink)
>
> You can count nanoseconds in schedule, and store the actual usage, but
> then you still have the problem of inaccuracies in sched_clock() from
> cross-cpu wakeup and migration.  Cross-cpu wakeups happen quite a lot.
> If sched_clock() _were_ absolutely accurate, you wouldn't need the
> runqueue deadline mechanism, because at slice tick time you can see
> everything you will ever see without moving enforcement directly into
> the most critical of paths.
>
> IMHO, unless it can be demonstrated that timeslice theft is a problem
> with a real-life scenario, you'd be better off dropping the queue
> ticking.  Time slices are a deadline mechanism, and in practice the god
> of randomness ensures that even fast movers do get caught often enough
> to make ticking tasks sufficient.
>
> (that was a very long-winded reply to one sentence because I spent a lot
> of time looking into this very subject and came to the conclusion that
> you can't get there from here.  fwiw, ymmv and all that of course;)
>
> > Thanks again!
>
> You're welcome.

The deadline mechanism is easy to hit and works. Try printk'ing it. There is 
some leeway to take tick accounting into the equation and I don't believe 
nanosecond resolution is required at all for this (how much leeway would you 
give then ;)). Eventually there is nothing to stop us using highres timers 
(blessed if they work as planned everywhere eventually) to do the events and 
do away with scheduler_tick entirely. For now ticks works fine; a reasonable 
estimate for smp migration will suffice (patch forthcoming).

-- 
-ck
