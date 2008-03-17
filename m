Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYCQBAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYCQBAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYCQBA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:00:28 -0400
Received: from n70.bullet.mail.sp1.yahoo.com ([98.136.44.38]:39197 "HELO
	n70.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751313AbYCQBA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:00:27 -0400
X-Yahoo-Newman-Id: 585809.14307.bm@omp406.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vFitfZfiZzMuTaq+5808jtSNrazJHjjioZfC0P3Y5nsp/JMv7KOfS5hYKgm9dnW9ZWv4OdnPmlSZ1L8BodMlgmWGQpoASYGOU0af7UDvzN45UaSkRge9GlF4OkVI3Q8BbLgu+nOrvEQI6xHxLsvxrDbLsTdFc2HqY3N+G8hJP5s=  ;
X-YMail-OSG: Dp_SYZwVM1kR2YwMgyI_j6Yed6QDKI7zYhz4S6_8T2ll0etSqDVqGyNQEl4TQ66Yu72shpTdyA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Date: Mon, 17 Mar 2008 11:44:35 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, "LKML," <linux-kernel@vger.kernel.org>
References: <200803111749.29143.nickpiggin@yahoo.com.au> <200803121221.37234.nickpiggin@yahoo.com.au> <1205308704.8514.197.camel@twins>
In-Reply-To: <1205308704.8514.197.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171144.35479.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 18:58, Peter Zijlstra wrote:
> On Wed, 2008-03-12 at 12:21 +1100, Nick Piggin wrote:
> > (Back onto lkml)
> >
> > On Tuesday 11 March 2008 23:02, Ingo Molnar wrote:
> > > another thing to try would be to increase:
> > >
> > >   /proc/sys/kernel/sched_migration_cost
> > >
> > > from its 500 usecs default to a few msecs ?
> >
> > This doesn't really help either (at 10ms).
> >
> > (For the record, I've tried turning SD_WAKE_IDLE, SD_WAKE_AFFINE
> > on and off for each domain and that hasn't helped either).
> >
> > I've also tried increasing sched_latency_ns as far as it can go.
> > BTW. this is a pretty nasty behaviour if you ask my opinion. It
> > starts *increasing* the number of involuntary context switches
> > as resources get oversubscribed. That's completely unintuitive as
> > far as I can see -- when we get overloaded, the obvious thing to
> > do is try to increase efficiency, or at least try as hard as
> > possible not to lose it. So context switches should be steady or
> > decreasing as I add more processes to a runqueue.
> >
> > It seems to max out at nearly 100 context switches per second,
> > and this has actually shown to be too frequent for modern CPUs
> > and big caches.
> >
> > Increasing the tunable didn't help for this workload, but it really
> > needs to be fixed so it doesn't decrease timeslices as the number
> > of processes increases.
>
> /proc/sys/kernel/sched_min_granularity_ns
> /proc/sys/kernel/sched_latency_ns
>
> period := max(latency, nr_running * min_granularity)
> slice := period * w_{i} / W
> W := \Sum_{i} w_{i}
>
> So if you want to increase the slice length for loaded systems, up
> min_granularity.

OK, but the very concept of reducing efficiency when load increases
is nasty, and leads to nasty feedback loops. It's just a very bad
behaviour to have out of the box, and as a general observation, 10ms
is too short a default timeslice IMO.

I don't see how it is really helpful for interactive processes either.
By definition, if they are not CPU bound, then they should be run
quite soon after waking up; if they are CPU bound, then reducing
efficiency by increasing context switches is effectively going to
increase their latency anyway.

Can this be changed by default, please?

