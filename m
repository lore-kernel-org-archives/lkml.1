Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab0COIjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 04:39:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50997 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759885Ab0COIjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 04:39:11 -0400
Date: Mon, 15 Mar 2010 09:38:51 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       a.p.zijlstra@chello.nl, andrea.gallo@stericsson.com,
       dbrownell@users.sourceforge.net, eric.y.miao@gmail.com,
       hugh.dickins@tiscali.co.uk, jamie@shareable.org,
       John Stultz <johnstul@us.ibm.com>, linux@bohmer.net, nico@marvell.com,
       Rusty Russell <rusty@rustcorp.com.au>, Greg KH <greg@kroah.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2/3] genirq: warn about IRQF_SHARED|IRQF_DISABLED at
	the right place
Message-ID: <20100315083851.GB31275@pengutronix.de>
References: <201003112208.o2BM8wJU013575@imap1.linux-foundation.org> <alpine.LFD.2.00.1003130031300.22855@localhost.localdomain> <20100312155015.090ba541.akpm@linux-foundation.org> <alpine.LFD.2.00.1003130130090.22855@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1003130130090.22855@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Mar 13, 2010 at 01:59:50AM +0100, Thomas Gleixner wrote:
> 
> Back to LKML and Cc'ed a few more folks
> 
> On Fri, 12 Mar 2010, Andrew Morton wrote:
> 
> > On Sat, 13 Mar 2010 00:32:28 +0100 (CET)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Thu, 11 Mar 2010, akpm@linux-foundation.org wrote:
> > > 
> > > > From: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
> > > > 
> > > > For shared irqs IRQF_DISABLED is only guaranteed for the first handler. 
> > > > So only warn starting at the second registration.
> > > > 
> > > > The warning is moved to __setup_irq having the additional benefit of
> > > > catching actions registered using setup_irq not only register_irq.
> > > > 
> > > > This doesn't fix the cases where setup order is wrong but it should report
> > > > the broken cases more reliably.
> > > 
> > > Please drop this. It's just useless shuffling off code for no real
> > > benefit.
> > > 
> > 
> > I think that warning on the second-registered IRQ was probably a
> > mistake.  Because registering just the first IRQF_DISABLED handler only
> > works by luck, and is vlunerable to someone else adding a handler later.
> > 
> > But extending the warning so that it also covers setup_irq() seems
> > sensible enough.
> 
> Well, this is a crappy concept anyway and it would be way more
> worthwhile to figure out why we need IRQF_DISABLED at all.
> 
> An irq handler should just run always with irqs disabled. The flag is
> just there to deal with crappy drivers which take hundreds of
> microseconds or more in their interrupt service routines. 
> 
> hint: IDE, USB ...
> 
> I'm simply refusing to apply patches which just shuffle code around to
> warn about obscure use cases instead of tackling the real problem of
> long running irq handlers which prevent us to get rid of IRQF_DISABLED
> and just run all interrupt handlers with irqs disabled. Getting rid of
> that would also simplify stuff which needs to be aware of reentrancy
> now.
The intention for my patch is a problem that have occured at least twice
in the past on the linux-arm-kernel mailing list.  On at91 the timer irq
is shared with some peripherals and we got reports that on these
machines the timer core BUGged because irq were not disabled.  Up to now
the reporters didn't help to debug that to the end.  So I'd consider it
nice to make it easy for the next person running into that problem now
that we know that there is a problem in that area.

I still think the patch is worthwhile as I think we're not getting rid
of IRQF_DISABLED in the next few release cycles, are we?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
