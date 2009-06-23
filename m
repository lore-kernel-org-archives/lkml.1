Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbZFWGN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbZFWGN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZFWGNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:13:51 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:7051 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbZFWGNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:13:51 -0400
X-SourceIP: 213.93.53.227
Subject: Re: I.5 - Mmaped count
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: eranian@gmail.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <19008.9265.758076.907649@cargo.ozlabs.ibm.com>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622115239.GF24366@elte.hu>
	 <7c86c4470906220525x409bedadj29be01236e42ea1@mail.gmail.com>
	 <1245674154.19816.228.camel@twins>
	 <19008.9265.758076.907649@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 08:13:56 +0200
Message-Id: <1245737636.19816.1470.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 10:39 +1000, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > I think we would have to add that do the data page,.. something like the
> > below?
> > 
> > Paulus?
> > 
> > ---
> > Index: linux-2.6/include/linux/perf_counter.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/perf_counter.h
> > +++ linux-2.6/include/linux/perf_counter.h
> > @@ -232,6 +232,10 @@ struct perf_counter_mmap_page {
> >  	__u32	lock;			/* seqlock for synchronization */
> >  	__u32	index;			/* hardware counter identifier */
> >  	__s64	offset;			/* add to hardware counter value */
> > +	__u64	total_time;		/* total time counter active */
> > +	__u64	running_time;		/* time counter on cpu */
> > +
> > +	__u64	__reserved[123];	/* align at 1k */
> >  
> >  	/*
> >  	 * Control data for the mmap() data buffer.
> > Index: linux-2.6/kernel/perf_counter.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/perf_counter.c
> > +++ linux-2.6/kernel/perf_counter.c
> > @@ -1782,6 +1782,12 @@ void perf_counter_update_userpage(struct
> >  	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
> >  		userpg->offset -= atomic64_read(&counter->hw.prev_count);
> >  
> > +	userpg->total_time = counter->total_time_enabled +
> > +			atomic64_read(&counter->child_total_time_enabled);
> > +
> > +	userpg->running_time = counter->total_time_running +
> > +			atomic64_read(&counter->child_total_time_running);
> 
> Hmmm, when the counter is running, what you want is not so much the
> total time so far as a way to compute the total time so far from the
> current TSC/timebase value.  So we would need to export tstamp_enabled
> and tstamp_running plus a scale/offset for converting the TSC/timebase
> value to nanoseconds consistent with ctx->time.  On powerpc that's
> pretty straightforward because the timebases, but on x86 I gather the
> offset and maybe also the scale would need to be per-cpu (which is OK,
> because all the values in the mmapped page are only useful on one
> specific CPU).
> 
> How would we compute the scale and offset on x86, given the current
> TSC value and ctx->time?

With pain and suffering ;-)

The userpage would have to provide a multiplier and offset, and we'd
have to register a cpufreq notifier hook and iterate all active counters
and update these mult,offset bits when the cpu freq changes.

An alternative could be to simply ensure we update these timestamps at
least once per the RR interval (tick), that way the times are more or
less recent and could still be used for scaling purposes.

The most important data in these timestamps is their ratio, not their
absolute value, therefore if we keep the ratio statistically significant
we're good enough.

