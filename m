Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZK3ODh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZK3ODh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbZK3ODg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:03:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43100 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbZK3ODg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:03:36 -0500
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 15:03:00 +0100
Message-ID: <1259589780.26472.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 14:54 +0100, Thomas Gleixner wrote:
> On Mon, 30 Nov 2009, Uwe Kleine-König wrote:
> > For shared irqs IRQF_DISABLED is only guaranteed for the first handler.
> > So only warn starting at the second registration.
> > 
> > The warning is moved to __setup_irq having the additional benefit of
> > catching actions registered using setup_irq not only register_irq.
> > 
> > This doesn't fix the cases where setup order is wrong but it should
> > report the broken cases more reliably.
> 
> The whole IRQF_DISABLED trickery is questionable and I'm pretty
> unhappy about the warning in general.
> 
> While it is true that there is no guarantee of IRQF_DISABLED on shared
> interrupts (at least not for the secondary handlers) we really need to
> think about the reason why we want to run interrupt handlers with
> interrupts enabled at all.
> 
> The separation of interrupt handlers which run with interrupts
> disabled/enabled goes all the way back to Linux 1.0, which had two
> interrupt handling modes:
> 
> 1) handlers installed with SA_INTERRUPT ran atomically with interrupts
>    disabled.
> 
> 2) handlers installed without SA_INTERRUPT ran with interrupts enabled
>    as they did more complex stuff like signal handling in the kernel.
> 
> The interrupt which was always run with interrupts disabled was the
> timer interrupt because some of the "slower" interrupt handlers were
> relying on jiffies being updated, which is only possible when they run
> with interrupts enabled and no such handler can interrupt the timer
> interrupt.
> 
> In the 2.1.x timeframe the discussion about shared interrupt handlers
> and the treatment of SA_INTERRUPT (today IRQF_DISABLED) was resolved
> by changing the code to what we have right now. If you read back in
> the archives you will find the same arguments as we have seen in this
> thread and a boatload of different solutions to that.
> 
> The real question is why we want to run an interrupt handler with
> interrupts enabled at all. There are two reaons AFAICT:
> 
> 1) interrupt handler relies on jiffies being updated:
> 
>    I don't think that this is the case anymore and if we still have
>    code which does it is probably historic crap which is unused for
>    quite a time.
> 
> 2) interrupt handler runs a long time:
> 
>    I'm sure we still have some of those especially in the
>    archaelogical corners of drivers/* and in the creative space of the
>    embedded "oh, I don't know why but it works" departement. That's
>    code which needs to be fixed anyway.
> 
> The correct solution IMNSHO is to get rid of IRQF_DISABLED and run
> interrupt handlers always with interrupts disabled and require them
> not to reenable interrupts themself.
> 
> Thoughts ?

I'm all for removing that brain damage:

  http://lkml.org/lkml/2009/3/2/33

We should convert the broken hardware PIO and 3com interrupt things to
threaded interrupts, and simply mandate all IRQ handlers run short and
with IRQs disabled.

Except I guess that will upset some of the IRQ priority folks, like
power, where they (iirc) have a stack per irq prio level.

But its not like the core kernel knows about these nesting rules and can
actually track any of that muck.

