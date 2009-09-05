Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZIEVhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZIEVhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 17:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZIEVhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 17:37:23 -0400
Received: from ms01.sssup.it ([193.205.80.99]:59069 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751830AbZIEVhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 17:37:23 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Sep 2009 17:37:22 EDT
Date: Sat, 5 Sep 2009 22:40:37 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Anirban Sinha <ASinha@zeugmasystems.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
Message-ID: <20090905204037.GE4953@gandalf.sssup.it>
References: <DDFD17CC94A9BD49A82147DDF7D545C501F0F575@exchange.ZeugmaSystems.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501F0F575@exchange.ZeugmaSystems.local>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Anirban Sinha <ASinha@zeugmasystems.com>
> Date: Fri, Sep 04, 2009 05:55:15PM -0700
>
> Hi Ingo and rest:
> 
> I have been playing around with the sched_rt_runtime_us cap that can be
> used to limit the amount of CPU time allocated towards scheduling rt
> group threads. I am using 2.6.26 with CONFIG_GROUP_SCHED disabled (we
> use only the root user in our embedded setup). I have no other CPU
> intensive workloads (RT or otherwise) running on my system. I have
> changed no other scheduling parameters from /proc. 
> 
> I have written a small test program that:
> 
> (a) forks two threads, one SCHED_FIFO and one SCHED_OTHER (this thread
> is reniced to -20) and ties both of them to a specific core.
> (b) runs both the threads in a tight loop (same number of iterations for
> both threads) until the SCHED_FIFO thread terminates.
> (c) calculates the number of completed iterations of the regular
> SCHED_OTHER thread against the fixed number of iterations of the
> SCHED_FIFO thread. It then calculates a percentage based on that.
> 
> I am running the above workload against varying sched_rt_runtime_us
> values (200 ms to 700 ms) keeping the sched_rt_period_us constant at
> 1000 ms. I have also experimented a little bit by decreasing the value
> of sched_rt_period_us (thus increasing the sched granularity) with no
> apparent change in behavior. 
> 
> My observations are listed in tabular form: 
> 
> Ratio of                  # of completed iterations of reg thread /
> sched_rt_runtime_us /     # of iterations of RT thread (in %)
> sched_rt_runtime_us       
> 
> 0.2                      100 % (regular thread completed all its
> iterations).
> 0.3                      73 %
> 0.4                      45 %
> 0.5                      17 %
> 0.6                      0 % (SCHED_OTHER thread completely throttled.
> Never ran)
> 0.7                      0 %
> 
> This result kind of baffles me. Even when we cap the RT group to a
> fraction of 0.6 of overall CPU time, the rest 0.4 \should\ still be
> available for running regular threads. So my SCHED_OTHER \should\ make
> some progress as opposed to being completely throttled. Similarly, with
> any fraction less than 0.5, the SCHED_OTHER should complete before
> SCHED_FIFO.
> 
> I do not have an easy way to verify my results over the latest kernel
> (2.6.31). Was there any regressions in the scheduling subsystem in
> 2.6.26? Can this behavior be explained? Do we need to tweak any other
> /proc parameters?
> 

You say you pin the threads to a single core: how many cores does your
system have?

I don't know if 2.6.26 had anything wrong (from a quick look the relevant
code seems similar to what we have now), but something like that can be
the consequence of the runtime migration logic moving bandwidth from a
second core to the one executing the two tasks.

If this is the case, this behavior is the expected one, the scheduler
tries to reduce the number of migrations, concentrating the bandwidth
of rt tasks on a single core.  With your workload it doesn't work well
because runtime migration has freed the other core(s) from rt bandwidth,
so these cores are available to SCHED_OTHER ones, but your SCHED_OTHER
thread is pinned and cannot make use of them.
