Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbYF0GXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbYF0GXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYF0GXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:23:08 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:46467 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYF0GXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:23:06 -0400
Date: Fri, 27 Jun 2008 11:54:56 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
       balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080627062456.GA14069@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
	balbir@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com> <48640C04.9020600@firstfloor.org> <1214516584.12265.10.camel@twins.programming.kicks-ass.net> <48641A7D.6080204@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <48641A7D.6080204@firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2008-06-27 00:38:53]:

> Peter Zijlstra wrote:
> 
> >> And your workload manager could just nice processes. It should probably
> >> do that anyways to tell ondemand you don't need full frequency.
> > 
> > Except that I want my nice 19 distcc processes to utilize as much cpu as
> > possible, but just not bother any other stuff I might be doing...
> 
> They already won't do that if you run ondemand and cpufreq. It won't
> crank up the frequency for niced processes.

This may not provide the best power saving if the workload is bursty.
Finishing the job quickly and entering sleep states have better
impact. This is the race-to-idle problem where we want to maximise the
sleep state utilisation relative to reducing the frequency.  The
benefit of this technique is certainly workload specific.  However
even in this particular case, running at the lowest frequency is the
safest option from OS point of view for power savings.  However for
maximum power savings, increasing sleep state utilisation have the
following advantages:

* Sleep states are per core while voltage and frequency control are
  for multiple cores in a multi-core package.  Hence freq change
  decisions needs to be taken at the package level.  Though ondemand
  makes the decision based on per-core utilisation and process
  priority, the actual effect in hardware is the highest freq
  recommended by all cores.  Per core decision is actually only
  a recommendation or a vote.

* Moving tasks to less number of CPU package in a multi socket system
  will provide maximum savings since even shared resources on the idle
  sockets can be in low power states.

Multi socket systems with multi core CPUs have more controls for power
savings that were previously not available on single core systems.
Automatically making the right decision is an ideal solution.  However
since there are trade-offs, we would like the users to experiment with
what suits them the best.  The rational is similar to why we provide
different cpufreq governors and tunables.

If we discover a good automatic technique to choose the right power
saving strategy that is widely acceptable, then certainly we will go
for it.  Can we build the stepping stone to reach there?  Can we consider
these tunables as enablements for end users to try them out easily
and provide feedback? 

> 
> Extending that existing policy to socket load balancing would be only
> natural.

Consolidation based on task priority seems to be the challenge here.
However this is a good point.  This is certainly a parameter for auto
tuning if only we can overcome the challenges in using priority for
task consolidation.

--Vaidy

