Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbZEQMOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbZEQMOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 08:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZEQMOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 08:14:25 -0400
Received: from www.tglx.de ([62.245.132.106]:51941 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbZEQMOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 08:14:24 -0400
Date: Sun, 17 May 2009 14:13:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chris Peterson <cpeterso@cpeterso.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] mod_timer() helper functions?
In-Reply-To: <20090517010347.f25843f9.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0905171408510.3516@localhost.localdomain>
References: <a24804730905160036j2720c557o347cec1513df9c4a@mail.gmail.com> <20090516230350.ec4fb487.akpm@linux-foundation.org> <a24804730905170050m16bfb81cj6c9ee4c99ac9d08f@mail.gmail.com> <20090517010347.f25843f9.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 May 2009, Andrew Morton wrote:

> On Sun, 17 May 2009 00:50:55 -0700 Chris Peterson <cpeterso@cpeterso.com> wrote:
> 
> > >> Reviewing the kernel's nearly one-thousand calls to mod_timer(), there
> > >> are three basic patterns:
> > >>
> > >> __* multi-second timeouts
> > >> __* millisecond timeouts
> > >> __* +1 jiffie ASAP events
> > >>
> > 
> > Is there a functional difference between the following "expire this
> > timer ASAP" statements?
> > 
> > mod_timer(timer, jiffies + 1); /* 48 uses */
> > mod_timer(timer, jiffies); /* 44 uses */
> > mod_timer(timer, jiffies - 1); /* 6 uses */
> 
> That's something which has always worried me.  Lots of code does:
> 
> 	mod_timer(timer, jiffies + 1);
> 
> (for varying values of "1").  What happens if this thread of control
> then gets stalled for a couple of jiffies.  Say it gets preempted or
> there's a long interrupt or whatever.  So there's a several-jiffy
> interval between the caller evaluating jiffies+1 and the entry to
> mod_timer().
> 
> 
> >From my reading, we'll hit
> 
> 		int i;
> 		/* If the timeout is larger than 0xffffffff on 64-bit
> 		 * architectures then we use the maximum timeout:
> 		 */
> 		if (idx > 0xffffffffUL) {
> 			idx = 0xffffffffUL;
> 			expires = idx + base->timer_jiffies;
> 		}
> 		i = (expires >> (TVR_BITS + 3 * TVN_BITS)) & TVN_MASK;
> 		vec = base->tv5.vec + i;
> 
> and the timer gets scheduled at some time in the far-distant future!
> 
> But this is such a glaring and huge problem that surely it cannot
> exist.  But I don't know why not.
> 
> If the bug _does_ exist then mod_timer(timer, jiffies - 1) will set the
> timer to go off in the far future.  mod_timer(timer, jiffies) will
> usually make it go off real soon now, but it's scary.  mod_timer(timer,
> jiffies + 1) is safer, but still vulnerable.

You missed a little detail:

	} else if ((signed long) idx < 0) {
		/*
		 * Can happen if you add a timer with expires == jiffies,
		 * or you set a timer to go off in the past
		 */
		vec = base->tv1.vec + (base->timer_jiffies & TVR_MASK);
	} else {
		int i;
		/* If the timeout is larger than 0xffffffff on 64-bit
		 * architectures then we use the maximum timeout:
		 */

So if the timer is set to go off in the past or right away then it is
enqueued into the timer list bucket which is processed in the next
timer softirq. That's why we use base->timer_jiffies and not jiffies
directly. base->timer_jiffies is incremented in the timer
softirq. softirq and enqueueing are serialized via base->lock.

Thanks,

	tglx
