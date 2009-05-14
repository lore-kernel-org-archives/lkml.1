Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbZENUlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbZENUlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZENUlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:41:06 -0400
Received: from www.tglx.de ([62.245.132.106]:56334 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbZENUlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:41:05 -0400
Date: Thu, 14 May 2009 22:40:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/2] sched, timers: move calc_load() to scheduler
In-Reply-To: <1242331227.6642.1637.camel@laptop>
Message-ID: <alpine.LFD.2.00.0905142224230.3561@localhost.localdomain>
References: <20090514105915.973318588@linutronix.de>  <20090514110712.521114248@linutronix.de> <1242331227.6642.1637.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Peter Zijlstra wrote:
> On Thu, 2009-05-14 at 11:21 +0000, Thomas Gleixner wrote:
> > plain text document attachment (move-calc-load-to-scheduler-v1.patch)
> 
> > +/*
> > + * calc_load - update the avenrun load estimates 10 ticks after the
> > + * CPUs have updated calc_load_tasks.
> > + */
> > +void calc_global_load(void)
> > +{
> > +	unsigned long upd = calc_load_update + 10;
> > +	long active;
> > +
> > +	if (time_before(jiffies, upd))
> > +		return;
> >  
> > +	active = atomic_long_read(&calc_load_tasks);
> > +	active = active > 0 ? active * FIXED_1 : 0;
> >  
> > +	avenrun[0] = calc_load(avenrun[0], EXP_1, active);
> > +	avenrun[1] = calc_load(avenrun[1], EXP_5, active);
> > +	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
> > +
> > +	calc_load_update += LOAD_FREQ;
> > +}
> 
> > @@ -1211,7 +1160,8 @@ static inline void update_times(unsigned
> >  void do_timer(unsigned long ticks)
> >  {
> >  	jiffies_64 += ticks;
> > -	update_times(ticks);
> > +	update_wall_time();
> > +	calc_global_load();
> >  }
> 
> I can see multiple cpus fall into calc_global_load() concurrently, which
> would 'age' the load faster than expected.
> 
> Should we plug that hole?

They can't. do_timer() is called by exactly one CPU under xtime
lock. What we removed is the loop over all online CPUs to retrieve the
number of active tasks.

Thanks,

	tglx
