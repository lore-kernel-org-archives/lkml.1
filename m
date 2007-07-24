Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbXGXVsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbXGXVsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760136AbXGXVru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:47:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760104AbXGXVrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:47:49 -0400
Message-ID: <46A672F8.2040305@redhat.com>
Date: Tue, 24 Jul 2007 17:45:28 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: "Li, Tong N" <tong.n.li@intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <46A53C88.6060006@redhat.com> <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com> <46A64002.8080103@redhat.com> <46A6576A.9020506@nortel.com> <46A66393.5000705@redhat.com> <1185310691.7737.40.camel@tongli.jf.intel.com> <46A66A88.8070307@redhat.com> <46A66DB8.4030608@nortel.com>
In-Reply-To: <46A66DB8.4030608@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Chris Snook wrote:
> 
>> I don't think Chris's scenario has much bearing on your patch.  What 
>> he wants is to have a task that will always be running, but can't 
>> monopolize either CPU. This is useful for certain realtime workloads, 
>> but as I've said before, realtime requires explicit resource 
>> allocation.  I don't think this is very relevant to SCHED_FAIR balancing.
> 
> I'm not actually using the scenario I described, its just sort of a 
> worst-case load-balancing thought experiment.
> 
> What we want to be able to do is to specify a fraction of each cpu for 
> each task group.  We don't want to have to affine tasks to particular cpus.

A fraction of *each* CPU, or a fraction of *total* CPU?  Per-cpu granularity 
doesn't make anything more fair.  You've got a big bucket of MIPS you want to 
divide between certain groups, but it shouldn't make a difference which CPUs 
those MIPS come from, other than the fact that we try to minimize overhead 
induced by migration.

> This means that the load balancer must be group-aware, and must trigger 
> a re-balance (possibly just for a particular group) as soon as the cpu 
> allocation for that group is used up on a particular cpu.

If I have two threads with the same priority, and two CPUs, the scheduler will 
put one on each CPU, and they'll run happily without any migration or balancing. 
  It sounds like you're saying that every X milliseconds, you want both to 
expire, be forbidden from running on the current CPU for the next X 
milliseconds, and then migrated to the other CPU.  There's no gain in fairness 
here, and there's a big drop in performance.

I suggested local fairness as a means to achieve global fairness because it 
could reduce overhead, and by adding the margin of error at each level in the 
locality hierarchy, you can get an algorithm which naturally tolerates the level 
of unfairness beyond which it is impossible to optimize.  Strict local fairness 
for its own sake doesn't accomplish anything that's better than global fairness.

	-- Chris
