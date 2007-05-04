Return-Path: <linux-kernel-owner+w=401wt.eu-S1422704AbXEDTJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbXEDTJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422717AbXEDTJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:09:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422704AbXEDTJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:09:27 -0400
Date: Fri, 4 May 2007 21:09:23 +0200
From: Tomas Janousek <tjanouse@redhat.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, tsmetana@redhat.com, riel@redhat.com
Subject: Re: Broken process startup times after suspend (regression)
Message-ID: <20070504190923.GA24554@redhat.com>
References: <20070503150320.GA21471@redhat.com> <1178222360.6085.14.camel@localhost.localdomain> <20070504161302.GA8962@redhat.com> <1178302732.5929.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178302732.5929.23.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 04, 2007 at 11:18:52AM -0700, john stultz wrote:
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 6af959c..b10d9b7 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1056,6 +1056,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >  
> >  	p->lock_depth = -1;		/* -1 = no lock */
> >  	do_posix_clock_monotonic_gettime(&p->start_time);
> > +	bbtime_get_ts(&p->real_start_time);
> >  	p->security = NULL;
> >  	p->io_context = NULL;
> >  	p->io_wait = NULL;
> 
> Since both do_posix_clock_monotonic_gettime and bbtime_get_ts actually
> read the timekeeping hardware (which could cost around 1.5us each), we
> probably will want to optimize this down to a single read, or just avoid
> the hardware read and take lower-granularity xtime value.
> 
> However, I'm not sure how fine-grained the start_time values need to be.

We can add a function like monotonic_to_bb probably? Nothing else crossed my
mind.

> > diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> > index b74860a..cd744a1 100644
> > --- a/kernel/hrtimer.c
> > +++ b/kernel/hrtimer.c
> > @@ -128,6 +128,33 @@ void ktime_get_ts(struct timespec *ts)
> >  }
> >  EXPORT_SYMBOL_GPL(ktime_get_ts);
> >  
> > +/**
> > + * bbtime_get_ts - get the boot based clock in timespec format
> > + * @ts:		pointer to timespec variable
> > + *
> > + * The function calculates the boot based clock from the realtime
> > + * clock, the wall_to_monotonic offset and the total sleep time and
> > + * stores the result in normalized timespec format in the variable
> > + * pointed to by @ts.
> 
> You might want to clarify this as being the "monotonic boot time", or
> the time the system has been running including sleep time and that calls
> to settimeofday() will not affect this value.

I just copied the text from the ktime_get_ts, but yes, why not.

> > + */
> > +void bbtime_get_ts(struct timespec *ts)
> 
> Any reason you added this in hrtimer.c instead of timer.c? I think
> keeping the new functions closer together would make the subtle
> difference between them more clear, and would allow total_sleep_time to
> be static to one file.

The same as above, I copied the ktime_get_ts and put it under that. Will doing
the diff against -mm solve this automagically? :)

> > @@ -832,6 +836,21 @@ void getnstimeofday(struct timespec *ts)
> >  EXPORT_SYMBOL(getnstimeofday);
> >  
> >  /**
> > + * getboottime - Return the real time of system boot.
> > + * @ts: 	pointer to the timespec to be set
> 
> Might want to clarify this as being the "boot time" based on the current
> CLOCK_REALTIME clock, noting that calls to settimeofday() would affect
> this value.

Ok.

> The only other gotcha is that this patch conflicts with a 2.6.22 queued
> patch in -mm that moves the majority of timekeeping code in
> kernel/timer.c to kernel/time/timekeeping.c
> 
> So it might be easiest to re-diff this against -mm and send it to Andrew
> for inclusion along with the cleanups. However, since this is a fix, it
> should have priority over cleanups. I just don't want to upset Andrew's
> tree too much :)
> 
> Your thoughts?

I'll look at that and will see.

Thanks for the comments,
-- 
TJ. (Brno, CZ), BaseOS, Red Hat
