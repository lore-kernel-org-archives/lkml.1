Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZGGHl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZGGHl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbZGGHlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:41:02 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:55005 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbZGGHlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:41:00 -0400
Date: Tue, 7 Jul 2009 09:40:18 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] optimized ktime_get[_ts] for GENERIC_TIME=y
Message-ID: <20090707094018.08406c49@skybase>
In-Reply-To: <alpine.LFD.2.00.0907062215380.19480@localhost.localdomain>
References: <20090706154933.5a1f8990@skybase>
	<alpine.LFD.2.00.0907062215380.19480@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009 22:31:39 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 6 Jul 2009, Martin Schwidefsky wrote:
> > +ktime_t ktime_get(void)
> > +{
> > +	cycle_t cycle_now, cycle_delta;
> > +	struct timespec time;
> > +	unsigned long seq;
> > +	s64 nsecs;
> > +
> > +	do {
> > +		seq = read_seqbegin(&xtime_lock);
> > +		time.tv_sec = xtime.tv_sec + wall_to_monotonic.tv_sec;
> > +		time.tv_nsec = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
> 
> That's actually a violation of the timespec semantics. tv_nsec can end
> up greater than (10^9 - 1). Please use separate sec and nsec variables.

Well the tv_sec/tv_nsec fields of a timespec are long values. But its
no problem to switch to local variables.

>   	        secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
>   	     	nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
> 
> > +		/* read clocksource: */
> > +		cycle_now = clocksource_read(clock);
> > +
> > +		/* calculate the delta since the last update_wall_time: */
> > +		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> > +
> > +		/* convert to nanoseconds: */
> > +		nsecs = cyc2ns(clock, cycle_delta);
> 
> So that needs to be changed to:
> 
> 		nsecs += cyc2ns(clock, cycle_delta);

Ok.

> > +
> > +	} while (read_seqretry(&xtime_lock, seq));
> > +	nsecs += time.tv_sec * 1000000000ULL + time.tv_nsec;
> > +	return (ktime_t) { .tv64 = nsecs };
> 
> This will break all 32bit architectures which do not have
> CONFIG_KTIME_SCALAR set.

Yep, that is a bug.
 
> With the above changes applied:
> 
>   return ktime_add_ns(ktime_set(secs, 0), nsecs);
> 
> will do the trick. Might need some comments though :)

Ok, will update the patch. Thanks for the review.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

