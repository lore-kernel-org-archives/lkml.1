Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbXFYWQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbXFYWQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXFYWQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:16:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbXFYWQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:16:16 -0400
Date: Mon, 25 Jun 2007 15:15:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Message-Id: <20070625151508.86fa3778.akpm@linux-foundation.org>
In-Reply-To: <200706252309.47467.zippel@linux-m68k.org>
References: <20070625200601.GA18980@elte.hu>
	<200706252309.47467.zippel@linux-m68k.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 23:09:46 +0200
Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Monday 25 June 2007, Ingo Molnar wrote:
> 
> > the patch improves the sysbench OLTP macrobenchmark significantly:
> 
> Has that any real practical relevance?

Interesting question.  The patch adds a new test-n-branch to gettimeofday()
so if gettimeofday() is used much more frequently than time(), we lose.

> > @@ -373,6 +376,20 @@ void do_gettimeofday (struct timeval *tv
> >
> >  	tv->tv_sec = sec;
> >  	tv->tv_usec = usec;
> > +
> > +	/*
> > +	 * Make sure xtime.tv_sec [returned by sys_time()] always
> > +	 * follows the gettimeofday() result precisely. This
> > +	 * condition is extremely unlikely, it can hit at most
> > +	 * once per second:
> > +	 */
> > +	if (unlikely(xtime.tv_sec != tv->tv_sec)) {
> > +		unsigned long flags;
> > +
> > +		write_seqlock_irqsave(&xtime_lock);
> > +		update_wall_time();
> > +		write_seqlock_irqrestore(&xtime_lock);
> > +	}
> >  }
> >
> >  EXPORT_SYMBOL(do_gettimeofday);
> 
> Is this the do_gettimeofday() inside CONFIG_TIME_INTERPOLATION?

Yes.

> What did you test?
> There can be many ways to read the clock, do you want to put this hook 
> everywhere?

Yeah, it isn't immediately obvious (to this little black duck) why similar
fixups weren't needed in timekeeping.c.


