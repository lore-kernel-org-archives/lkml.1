Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZK3Vcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZK3Vcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbZK3Vci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:32:38 -0500
Received: from www.tglx.de ([62.245.132.106]:48889 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbZK3Vci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:32:38 -0500
Date: Mon, 30 Nov 2009 22:31:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
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
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
In-Reply-To: <1259611151.2076.101.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0911302225050.24119@localhost.localdomain>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>  <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>  <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>  <1259589780.26472.18.camel@laptop> 
 <alpine.LFD.2.00.0911301519120.24119@localhost.localdomain> <1259611151.2076.101.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, Benjamin Herrenschmidt wrote:
> Well, thing is, in cases where we have a sane PIC, the PIC itself is
> perfectly good at keeping the source and anything of the same priority
> or lower masked while we handle an irq.

Unfortunately the majority of PICs does not fall into that category.
 
> So disabling local CPU IRQs will basically add an unnecessary blocking
> of both timer interrupts and perfmon interrupts while doing so.
> 
> Yes, all driver interrupt handlers -should- be only running short amount
> of code in their handlers but you know how it is. The drift introduced
> on timer and perfmon events can be a problem, the later might even make
> it difficult to figure out what an -interrupt- is taking more time than
> it should.

The timer problem only affects the old style tick/jiffies driven
hardware where you have no continous clock source for keeping track of
time. Even x86 managed to do something about that recently :)

Are the perf events on power generally coming through the standard irq
handler code path and/or sensitive to local_irq_disable() ?

> I would suggest we timestamp the handlers in the core btw and warn if
> they take too long so we get a chance to track down the bad guys.

The hassle is to find a time which we think is appropriate as a
threshold which is of course depending on the cpu power of a
system. Also I wonder whether we'd need to make such a warning thing
aware of irq nesting.

Thanks,

	tglx
