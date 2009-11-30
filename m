Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZK3Oio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZK3Oio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZK3Oin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:38:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45514 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbZK3Oin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:38:43 -0500
Date: Mon, 30 Nov 2009 14:37:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@marvell.com>,
       Jamie Lokier <jamie@shareable.org>, LKML <linux-kernel@vger.kernel.org>,
       Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
	IRQF_SHARED|IRQF_DISABLED)
Message-ID: <20091130143703.GA7028@n2100.arm.linux.org.uk>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 02:54:54PM +0100, Thomas Gleixner wrote:
> The correct solution IMNSHO is to get rid of IRQF_DISABLED and run
> interrupt handlers always with interrupts disabled and require them
> not to reenable interrupts themself.

I think Linus advocated at one point making the default be "irqs disabled"
and only only if a flag was passed would handlers run with IRQs enabled.
However, that might have been a step towards having all handlers running
with IRQs disabled.

I'm all in favour of it.  There are a large number of relatively simple
interrupt handlers out there which don't care about whether they're
called with IRQs disabled or not.

However, I think we still have a number of corner cases.  The SMC91x
driver comes to mind, with its stupidly small FIFOs, where the majority
of implementations have to have the packets loaded via PIO - and this
seems to generally happen from IRQ context.

The upshot of that is switching the SMC91x interrupt handler to run with
IRQs disabled will mean that serial can suffer with overruns, especially
if the serial port FIFO is also small.

The alternative is to push the "expensive" packet-loading parts of SMC91x
support into a tasklet, but that's probably going to impact performance
of the driver.

What I'm saying is that I think it's a good idea, but we should be
cautious about forcing a blanket change - to do so I believe risks creating
performance regressions.

Maybe a "safer" way forward is to go and find all those request_irq()
sites and add IRQF_DISABLED to them all, wait for regression reports and
selectively remove the IRQF_DISABLED flags?  We would then be able to
build up a picture of the problematical drivers that need to be reworked,
and whether the "run everything with irqs disabled" is even a practical
proposition.


Now, at the risk of covering old ground, how about we have two separate
irqaction lists, one for handlers to be called with irqs disabled and
one for handlers with irqs enabled.  We run the irqs-disabled list
first, naturally with irqs disabled.  If, at the end of that run (or
maybe after each handler), IRQs have ended being enabled, print some
diagnostics.  (We're going to need something like this to ensure that
drivers interrupt handlers don't enable IRQs themselves.)  Then enable
IRQs and run the irqs-enabled chain.
