Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYIRCmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYIRCmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 22:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYIRCmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 22:42:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:53977 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbYIRCmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 22:42:31 -0400
Subject: Re: How how latent should non-preemptive scheduling be?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080917145400.29d1809c@infradead.org>
References: <fa.vMKgvqjqmYnI2J40GHoTENeYm8U@ifi.uio.no>
	 <fa.808p0ZtU9DCpeky4KfNS8Drdw9w@ifi.uio.no> <48D17B47.7080704@yahoo.com>
	 <20080917145400.29d1809c@infradead.org>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 04:42:19 +0200
Message-Id: <1221705739.15314.20.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-17 at 14:54 -0700, Arjan van de Ven wrote:
> On Wed, 17 Sep 2008 22:48:55 +0100
> Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> 
> > Arjan van de Ven wrote:
> > > this says you haven't done "make install" on the latencytop
> > > directory so it's not translating things for you.. can you do that
> > > please?
> > 
> > > Cause                                                Maximum
> > > 
> Percentage 
> 
> Scheduler: waiting for cpu                        208 msec         59.4 %
> 
> 
> you're rather CPU bound, and your process was woken up but didn't run for over 200 milliseconds..
> that sounds like a scheduler fairness issue!

Really hard subject. Perfect fairness requires 0 latency - which with a
CPU only being able to run one thing at a time is impossible. So what
latency ends up being is a measure for the convergence towards fairness.

Anyway - 200ms isn't too weird depending on the circumstances. We start
out with a 20ms latency for UP, we then multiply with 1+log2(nr_cpus)
which in say a quad core machine ends up with 60ms. That ought to mean
that under light load the max latency should not exceed twice that
(basically a consequence of the Nyquist-Shannon sampling theorem IIRC).

Now, if you get get under some load (by default: nr_running > 5) the
expected latency starts to linearly grow with nr_running.

>From what I gather from the reply to this email the machine was not
doing much (and after having looked up the original email I see its a
eeeeeeeee atom - which is dual cpu iirc, so that yields 40ms default) -
so 200 is definately on the high side.

What you can do to investigate this, is use the sched_wakeup tracer from
ftrace, that should give a function trace of the highest wakeup latency
showing what the kernel is doing.

