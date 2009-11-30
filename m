Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbZK3Tva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbZK3Tva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZK3Tv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:51:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37552 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZK3Tv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:51:28 -0500
Date: Mon, 30 Nov 2009 20:51:29 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
	IRQF_SHARED|IRQF_DISABLED)
Message-ID: <20091130195129.GA19172@pengutronix.de>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Nov 30, 2009 at 02:54:54PM +0100, Thomas Gleixner wrote:
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

I think there is

 3) you can only benefit from decent priority hardware if irqs are
    processed while irqs are enabled.

I think 

	git grep handle_fasteoi_irq

gives an overview here: some hits in arch/powerpc, arch/sparc and
arch/x86/kernel/apic/io_apic.c.  (There is handle_prio_irq in
arch/arm/mach-ns9xxx, but the priodecoder is crappy and actually it
should use handle_level_irq IIRC.)

Best regards
Uwe
 
-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
