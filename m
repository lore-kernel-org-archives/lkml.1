Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZFWArb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZFWArb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZFWArD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:47:03 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42802 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZFWArA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:47:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19008.9265.758076.907649@cargo.ozlabs.ibm.com>
Date: Tue, 23 Jun 2009 10:39:13 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@gmail.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.5 - Mmaped count
In-Reply-To: <1245674154.19816.228.camel@twins>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	<20090622115239.GF24366@elte.hu>
	<7c86c4470906220525x409bedadj29be01236e42ea1@mail.gmail.com>
	<1245674154.19816.228.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> I think we would have to add that do the data page,.. something like the
> below?
> 
> Paulus?
> 
> ---
> Index: linux-2.6/include/linux/perf_counter.h
> ===================================================================
> --- linux-2.6.orig/include/linux/perf_counter.h
> +++ linux-2.6/include/linux/perf_counter.h
> @@ -232,6 +232,10 @@ struct perf_counter_mmap_page {
>  	__u32	lock;			/* seqlock for synchronization */
>  	__u32	index;			/* hardware counter identifier */
>  	__s64	offset;			/* add to hardware counter value */
> +	__u64	total_time;		/* total time counter active */
> +	__u64	running_time;		/* time counter on cpu */
> +
> +	__u64	__reserved[123];	/* align at 1k */
>  
>  	/*
>  	 * Control data for the mmap() data buffer.
> Index: linux-2.6/kernel/perf_counter.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_counter.c
> +++ linux-2.6/kernel/perf_counter.c
> @@ -1782,6 +1782,12 @@ void perf_counter_update_userpage(struct
>  	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
>  		userpg->offset -= atomic64_read(&counter->hw.prev_count);
>  
> +	userpg->total_time = counter->total_time_enabled +
> +			atomic64_read(&counter->child_total_time_enabled);
> +
> +	userpg->running_time = counter->total_time_running +
> +			atomic64_read(&counter->child_total_time_running);

Hmmm, when the counter is running, what you want is not so much the
total time so far as a way to compute the total time so far from the
current TSC/timebase value.  So we would need to export tstamp_enabled
and tstamp_running plus a scale/offset for converting the TSC/timebase
value to nanoseconds consistent with ctx->time.  On powerpc that's
pretty straightforward because the timebases, but on x86 I gather the
offset and maybe also the scale would need to be per-cpu (which is OK,
because all the values in the mmapped page are only useful on one
specific CPU).

How would we compute the scale and offset on x86, given the current
TSC value and ctx->time?

Paul.
