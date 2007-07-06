Return-Path: <linux-kernel-owner+w=401wt.eu-S1762794AbXGFUF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762794AbXGFUF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762796AbXGFUFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:05:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760809AbXGFUFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:05:17 -0400
Message-Id: <200707062003.l66K3McB001808@pasta.boston.redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Chris Friesen <cfriesen@nortel.com>,
       Clemens Koller <clemens.koller@anagramm.de>,
       Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
In-Reply-To: Your message of "Fri, 06 Jul 2007 07:17:26 +0200."
             <1183699046.3289.51.camel@chaos>
Date: Fri, 06 Jul 2007 16:03:22 -0400
From: Ernie Petrides <petrides@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 6-Jul-2007 at 7:17 +0200, Thomas Gleixner wrote:

> On Thu, 2007-07-05 at 19:12 -0400, Ernie Petrides wrote:
> > On Thursday, 5-Jul-2007 at 16:49 MDT, Chris Friesen wrote:
> >
> > > Ernie Petrides wrote:
> > >
> > > > Only kernels built with the CONFIG_HIGH_RES_TIMERS option enabled were
> > > > vulnerable.
> > >
> > > As I mentioned in my post to Thomas, we have high res timers disabled
> > > and were still affected.  Granted, our kernel has been modified so it is
> > > possible that vanilla would not be affected....I haven't tested it.
> > >
> > > Chris
> >
> > That's odd, because Thomas's patch removed two calls to clock_was_set(),
> > which is a no-op when CONFIG_HIGH_RES_TIMERS is not enabled (at least in
> > the 2.6.21 source tree).
> >
> > Also, I personally tested with the reproducer you posted here, initially
> > on a box running 2.6.22-rc4, and there were no problems (but I'm not sure
> > what config options were enabled on that kernel).  I did reproduce the
> > problem on a stock 2.6.21 kernel with CONFIG_HIGH_RES_TIMERS enabled.
>
> It needs a running smp_call_function() to be interrupted by the timer
> interrupt, which calls clock_was_set(). So it's not that easy to
> reproduce.

I think it's reproducible at will when CONFIG_BUG is enabled, because the
WARN_ON() on line 546 of arch/i386/kernel/smp.c fires in smp_call_function(),
causing lots of console output.  By the time on_each_cpu() later reenables
interrupts, another clock interrupt is pending, and (I think) causes a
self-deadlock on the xtime_lock in vmi_account_real_cycles().

That's my (unproven) theory, anyway.  :)

At any rate, I reproduced it twice in two tries on stock 2.6.21.

Cheers.  -ernie
