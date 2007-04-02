Return-Path: <linux-kernel-owner+w=401wt.eu-S965164AbXDBRrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbXDBRrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 13:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965441AbXDBRrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 13:47:36 -0400
Received: from www.osadl.org ([213.239.205.134]:43897 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965164AbXDBRrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 13:47:36 -0400
Subject: Re: [patch 6/13] signal/timer/event fds v9 - timerfd core ...
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704021025570.26489@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.16816.1175371772.6>
	 <1175418341.28263.64.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0704010941490.26331@alien.or.mcafeemobile.com>
	 <1175498549.28263.88.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0704021025570.26489@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 19:47:44 +0200
Message-Id: <1175536065.28263.177.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 10:30 -0700, Davide Libenzi wrote:

> > There is no inaccuracy when you rearm the timer on read: hrtimer_forward
> > takes care, that the period is accurate. It does not start the timer out
> > of the periodic order, i.e. on a different time frame.
> > 
> > Where is the win of keeping the timer running, when nobody cares about
> > the expiry at all ? It just generates interrupts and events for nothing.
> 
> Then you'd lose the ability to know if you lost one or more (yes, you 
> could figure it out by reading the time and with a few calculations). I 
> think that the capping (to a sane value) idea solves the DoS issue and at 
> the same time have the ability to report you missed ticks. What are your 
> strong points against that solution?

Err, the read function 

	ticks = hrtimer_forward(&ctx->tmr, ktime_get(),
                                ctx->tintv);

does give you the number of (lost) ticks.

tmr->expires holds the absolute expiry time of the last event.
hrtimer_forward() adds N intervals to tmr->expires, so that the new
tmr->expires value is greater than now (ktime_get()). It returns N.

So the number of lost ticks is N - 1. No time reading and no magic
math :)

	tglx


