Return-Path: <linux-kernel-owner+w=401wt.eu-S1752115AbYCLH6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbYCLH6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 03:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbYCLH6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 03:58:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44385 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYCLH6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 03:58:43 -0400
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, "LKML," <linux-kernel@vger.kernel.org>
In-Reply-To: <200803121221.37234.nickpiggin@yahoo.com.au>
References: <200803111749.29143.nickpiggin@yahoo.com.au>
	 <20080311102538.GA30551@elte.hu> <20080311120230.GA5386@elte.hu>
	 <200803121221.37234.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 08:58:24 +0100
Message-Id: <1205308704.8514.197.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 12:21 +1100, Nick Piggin wrote:
> (Back onto lkml)
> 
> On Tuesday 11 March 2008 23:02, Ingo Molnar wrote:
> > another thing to try would be to increase:
> >
> >   /proc/sys/kernel/sched_migration_cost
> >
> > from its 500 usecs default to a few msecs ?
> 
> This doesn't really help either (at 10ms).
> 
> (For the record, I've tried turning SD_WAKE_IDLE, SD_WAKE_AFFINE
> on and off for each domain and that hasn't helped either).
> 
> I've also tried increasing sched_latency_ns as far as it can go.
> BTW. this is a pretty nasty behaviour if you ask my opinion. It
> starts *increasing* the number of involuntary context switches
> as resources get oversubscribed. That's completely unintuitive as
> far as I can see -- when we get overloaded, the obvious thing to
> do is try to increase efficiency, or at least try as hard as
> possible not to lose it. So context switches should be steady or
> decreasing as I add more processes to a runqueue.
> 
> It seems to max out at nearly 100 context switches per second,
> and this has actually shown to be too frequent for modern CPUs
> and big caches.
> 
> Increasing the tunable didn't help for this workload, but it really
> needs to be fixed so it doesn't decrease timeslices as the number
> of processes increases.

/proc/sys/kernel/sched_min_granularity_ns
/proc/sys/kernel/sched_latency_ns

period := max(latency, nr_running * min_granularity)
slice := period * w_{i} / W
W := \Sum_{i} w_{i}

So if you want to increase the slice length for loaded systems, up
min_granularity.

