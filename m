Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbXIXPxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbXIXPxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758911AbXIXPxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:53:34 -0400
Received: from www.osadl.org ([213.239.205.134]:57132 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755721AbXIXPxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:53:33 -0400
Subject: Re: [patch 1/3] new timerfd API - new timerfd API
From: Thomas Gleixner <tglx@linutronix.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0709240838250.23830@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.19354.1190587749.1>
	 <1190622364.4035.182.camel@chaos>
	 <Pine.LNX.4.64.0709240838250.23830@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 17:53:30 +0200
Message-Id: <1190649210.4035.224.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 08:42 -0700, Davide Libenzi wrote:
> > > +			ticks += (u64)
> > >  				hrtimer_forward(&ctx->tmr,
> > >  						hrtimer_cb_get_time(&ctx->tmr),
> > 
> > You need to use ctx->tmr.base->get_time() here, otherwise you might read
> > a stale time value (in case that CONFIG_HIGH_RES_TIMERS is off).
> 
> Is the particular position of hrtimer_cb_get_time() in the code that would 
> break here? Because function was added by your patch ;)
> Did something change later?

For non high res systems we speed up the access to now by storing the
current time when we start to process the hrtimer softirq callbacks.

hrtimer_cb_get_time(timer) reads timer->base->now

For high resolution systems hrtimer_cb_get_time() resolves to
timer->base->get_time().

In the timerfd case we are not in softirq context and we read at any
given later time. Also on SMP the base->now variable might be changed by
the softirq running on the other CPU.

	tglx


