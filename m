Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbXFUHaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbXFUHaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 03:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXFUHaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 03:30:06 -0400
Received: from mx12.go2.pl ([193.17.41.142]:33629 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751964AbXFUHaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 03:30:04 -0400
Date: Thu, 21 Jun 2007 09:38:00 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Miklos Szeredi <miklos@szeredi.hu>,
       cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621073800.GA1685@ff.dom.local>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 10:34:15AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 20 Jun 2007, Jarek Poplawski wrote:
> > 
> > I don't agree with this (+ I know it doesn't matter).
> > 
> > The real bug is what Chuck Ebbert wrote: "Spinlocks aren't fair".
> > And here they are simply lawlessly not fair.
> 
> Well, that's certainly a valid standpoint. I wouldn't claim you're 
> _wrong_.
> 
> At least in theory.
> 
> In *practice*, fair spinlocks are simply not possible. Not as in "it's 
> hard to do", but as in "you simply cannot do it".

I think we can agree it was more about some minimal fairness.

...
> Which gets us to the next level: we can consider hardware that isn't 
> "fair" in its cache coherency to be buggy hardware.

IMHO, we shouldn't try to blame the hardware until we know exactly
the source of this bug.

...
> In other words, spinlocks are optimized for *lack* of contention. If a 
> spinlock has contention, you don't try to make the spinlock "fair". No, 
> you try to fix the contention instead!
> 
> That way, you fix many things. You probably speed things up, _and_ you 
> make it fairer. It might sometimes take some brains and effort, but it's 
> worth it.

I could agree with this, but only when we know exactly what place
should be fixed if we don't care about speed. Then, of course, the
cost could be estimated. But after last Ingo's patch I'm not sure
he, or anybody else here, has this knowledge. I'd also remind that
adding one smp_mb() also did the work, and it doesn't look like a
big performance hit. We should only better know why this works.

> The patch I sent out was an example of that. You *can* fix contention 
> problems. Does it take clever approaches? Yes. It's why we have hashed 
> spinlocks, RCU, and code sequences that are entirely lockless and use 
> optimistic approaches. And suddenly you get fairness *and* performance!
> 
> It's a win-win situation. It does require a bit of effort, but hey, we're 
> good at effort.

Not necessarily so. Until the exact reason isn't known "for sure",
this one place could be fixed, but the same problem could appear
somewhere else in more masked form or is far less repeatable.

BTW, I've looked a bit at these NMI watchdog traces, and now I'm not
even sure it's necessarily the spinlock's problem (but I don't exclude
this possibility yet). It seems both processors use task_rq_lock(), so
there could be also a problem with that loop. The way the correctness
of the taken lock is verified is racy: there is a small probability
that if we have taken the wrong lock the check inside the loop is done
just before the value is beeing changed elsewhere under the right lock.
Another possible problem could be a result of some wrong optimization
or wrong propagation of change of this task_rq(p) value.

Thanks for response & best regards,
Jarek P.
