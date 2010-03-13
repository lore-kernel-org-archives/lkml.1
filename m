Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936232Ab0CMBB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:01:28 -0500
Received: from www.tglx.de ([62.245.132.106]:38200 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936208Ab0CMBBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 20:01:23 -0500
Date: Sat, 13 Mar 2010 01:59:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       u.kleine-koenig@pengutronix.de, a.p.zijlstra@chello.nl,
       andrea.gallo@stericsson.com, dbrownell@users.sourceforge.net,
       eric.y.miao@gmail.com, hugh.dickins@tiscali.co.uk, jamie@shareable.org,
       John Stultz <johnstul@us.ibm.com>, linux@bohmer.net, nico@marvell.com,
       Rusty Russell <rusty@rustcorp.com.au>, Greg KH <greg@kroah.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2/3] genirq: warn about IRQF_SHARED|IRQF_DISABLED at the
 right place
In-Reply-To: <20100312155015.090ba541.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1003130130090.22855@localhost.localdomain>
References: <201003112208.o2BM8wJU013575@imap1.linux-foundation.org> <alpine.LFD.2.00.1003130031300.22855@localhost.localdomain> <20100312155015.090ba541.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Back to LKML and Cc'ed a few more folks

On Fri, 12 Mar 2010, Andrew Morton wrote:

> On Sat, 13 Mar 2010 00:32:28 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 11 Mar 2010, akpm@linux-foundation.org wrote:
> > 
> > > From: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
> > > 
> > > For shared irqs IRQF_DISABLED is only guaranteed for the first handler. 
> > > So only warn starting at the second registration.
> > > 
> > > The warning is moved to __setup_irq having the additional benefit of
> > > catching actions registered using setup_irq not only register_irq.
> > > 
> > > This doesn't fix the cases where setup order is wrong but it should report
> > > the broken cases more reliably.
> > 
> > Please drop this. It's just useless shuffling off code for no real
> > benefit.
> > 
> 
> I think that warning on the second-registered IRQ was probably a
> mistake.  Because registering just the first IRQF_DISABLED handler only
> works by luck, and is vlunerable to someone else adding a handler later.
> 
> But extending the warning so that it also covers setup_irq() seems
> sensible enough.

Well, this is a crappy concept anyway and it would be way more
worthwhile to figure out why we need IRQF_DISABLED at all.

An irq handler should just run always with irqs disabled. The flag is
just there to deal with crappy drivers which take hundreds of
microseconds or more in their interrupt service routines. 

hint: IDE, USB ...

I'm simply refusing to apply patches which just shuffle code around to
warn about obscure use cases instead of tackling the real problem of
long running irq handlers which prevent us to get rid of IRQF_DISABLED
and just run all interrupt handlers with irqs disabled. Getting rid of
that would also simplify stuff which needs to be aware of reentrancy
now.

Thanks,

	tglx
