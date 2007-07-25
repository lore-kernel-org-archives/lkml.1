Return-Path: <linux-kernel-owner+w=401wt.eu-S1762470AbXGYJ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762470AbXGYJ6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 05:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbXGYJ6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 05:58:42 -0400
Received: from brick.kernel.dk ([80.160.20.94]:22679 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456AbXGYJ6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 05:58:42 -0400
Date: Wed, 25 Jul 2007 11:59:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-ID: <20070725095910.GL3287@kernel.dk>
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070725014912.35c7e325.akpm@linux-foundation.org> <20070725085204.GA22067@elte.hu> <20070725020003.63144fd6.akpm@linux-foundation.org> <20070725090439.GA26286@elte.hu> <20070725021730.a9a624b3.akpm@linux-foundation.org> <20070725092342.GA29814@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725092342.GA29814@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25 2007, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > >   * 2^30ns == 1.074s.
> > >   */
> > > -static unsigned long get_timestamp(void)
> > > +static unsigned long get_timestamp(int this_cpu)
> > >  {
> > > -	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
> > > +	return cpu_clock(this_cpu) >> 30;  /* 2^30 ~= 10^9 */
> > >  }
> > >  
> > >  void touch_softlockup_watchdog(void)
> > >  {
> > > -	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
> > > +	int this_cpu = raw_smp_processor_id();
> > > +
> > > +	per_cpu(touch_timestamp, this_cpu) = get_timestamp(this_cpu);
> > >  }
> > >  EXPORT_SYMBOL(touch_softlockup_watchdog);
> > >  
> > > @@ -95,7 +97,7 @@ void softlockup_tick(void)
> > >  		return;
> > 
> > argh.  afacit this was never sent, except as part of some jumbopatch 
> > called "sched: implement cpu_clock(cpu) high-speed time source".
> > 
> > That patch helped.
> > 
> > It's all a plot.
> 
> sorry, it's really my fault: i decoupled it from the jumbopatch (so that 
> the new API could go in first) but forgot to re-send that crutial bit. 
> There's also the patch below (Jens Cc:-ed) to update blktrace. I guess i 
> should do a softlockup.git tree to avoid such foul-ups in the future.
> 
> 	Ingo
> 
> ----------------------->
> Subject: blktrace: use cpu_clock() instead of sched_clock()
> From: Ingo Molnar <mingo@elte.hu>
> 
> use cpu_clock() instead of sched_clock(). (the latter is not a proper
> clock-source)
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

I tested it, seems to work fine for me.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

