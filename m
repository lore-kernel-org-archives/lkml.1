Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbXENK3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbXENK3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759847AbXENK2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:28:55 -0400
Received: from holomorphy.com ([66.93.40.71]:52453 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760639AbXENK2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:28:53 -0400
Date: Mon, 14 May 2007 03:29:29 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, efault@gmx.de, tingy@cs.umass.edu,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514102929.GL31925@holomorphy.com>
References: <20070514083358.GA29775@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514083358.GA29775@in.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 02:03:58PM +0530, Srivatsa Vaddagiri wrote:
> 	I have been brooding over how fair clock is computed/used in
> CFS and thought I would ask the experts to avoid wrong guesses!
> As I understand, fair_clock is a monotonously increasing clock which
> advances at a pace inversely proportional to the load on the runqueue.
> If load = 1 (task), it will advance at same pace as wall clock, as 
> load increases it advances slower than wall clock.
> In addition, following calculations depend on fair clock: task's wait
> time on runqueue and sleep time outside the runqueue (both reflected in
> p->wait_run_time).

It's not hard to see that that's a mistake. The great thing about virtual
deadline schedulers, though, is that all it takes to completely rewrite
the policy is changing the numbers calculated for these things.


On Mon, May 14, 2007 at 02:03:58PM +0530, Srivatsa Vaddagiri wrote:
> Few questions that come up are:
> 1. Why can't fair clock be same as wall clock at all times? i.e fair
>    clock progresses at same pace as wall clock independent of the load on
>    the runqueue.
>    It would still give the ability to measure time spent waiting on runqueue 
>    or sleeping and use that calculated time to give latency/bandwidth
>    credit? 
>    In case of EEVDF, the use of virtual clock seems more
>    understandable, if we consider the fact that each client gets 'wi' real
>    time units in 1 virtual time unit. That doesnt seem to be the case in
>    CFS as Ting Yang explained +/- lags here 
>    http://lkml.org/lkml/2007/5/2/612 ..

It's not just more understandable, it doesn't break down with
increasing numbers of tasks.


On Mon, May 14, 2007 at 02:03:58PM +0530, Srivatsa Vaddagiri wrote:
> 2. Preemption granularity - sysctl_sched_granularity
> 	This seems to be measured in the fair clock scale rather than
> 	wall clock scale. As a consequence of this, the time taken
> 	for a task to relinquish to competetion is dependent on number N
> 	of tasks? For ex: if there a million cpu hungry tasks, then the
> 	time taken to switch between two tasks is more compared to the
> 	case where just two cpu hungry tasks are running. Is there
> 	any advantage of using fair clock scale to detect preemtion points?

I'm not convinced this is a great way to mitigate context switch
overhead. I'd recommend heuristically adjusting the latency parameters
(l_i) to try to mitigate context switch overhead or otherwise express
the tradeoff between latency and throughput instead of introducing an
arbitrary delay like sched_granularity_ns. I suspect it'll have to
restart from a point much closer to EEVDF for that to be effective.


-- wli
