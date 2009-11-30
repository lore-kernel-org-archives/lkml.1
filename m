Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbZK3UFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbZK3UFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZK3UFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:05:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:59378 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbZK3UFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:05:12 -0500
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
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
In-Reply-To: <alpine.LFD.2.00.0911301519120.24119@localhost.localdomain>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
	 <1259589780.26472.18.camel@laptop>
	 <alpine.LFD.2.00.0911301519120.24119@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 06:59:11 +1100
Message-ID: <1259611151.2076.101.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 15:24 +0100, Thomas Gleixner wrote:
> 
> > Except I guess that will upset some of the IRQ priority folks, like
> > power, where they (iirc) have a stack per irq prio level.
> 
> Is that actually used ? Ben ?

Nah, we have 2 dedicated stacks.. one for external interrupts and one
for softirq. On embedded we also have a separate stack for the critical
interrupts and machine checks but both are special (critical interrupts
are aking to FIQ on ARM).

> > But its not like the core kernel knows about these nesting rules and
> can actually track any of that muck.
> 
> True.

Well, thing is, in cases where we have a sane PIC, the PIC itself is
perfectly good at keeping the source and anything of the same priority
or lower masked while we handle an irq.

So disabling local CPU IRQs will basically add an unnecessary blocking
of both timer interrupts and perfmon interrupts while doing so.

Yes, all driver interrupt handlers -should- be only running short amount
of code in their handlers but you know how it is. The drift introduced
on timer and perfmon events can be a problem, the later might even make
it difficult to figure out what an -interrupt- is taking more time than
it should.

I would suggest we timestamp the handlers in the core btw and warn if
they take too long so we get a chance to track down the bad guys.

Cheers,
Ben.


