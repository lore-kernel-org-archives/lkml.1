Return-Path: <linux-kernel-owner+w=401wt.eu-S965570AbXDCMsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570AbXDCMsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 08:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965777AbXDCMsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 08:48:52 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57158 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965570AbXDCMsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 08:48:51 -0400
Date: Tue, 3 Apr 2007 18:26:19 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070403125619.GA32444@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu> <20070402092818.GE2456@in.ibm.com> <20070402111828.GA14771@elte.hu> <20070402124200.GA9566@in.ibm.com> <20070402185607.GA2081@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402185607.GA2081@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 08:56:07PM +0200, Ingo Molnar wrote:
> ok. But the only real problem would be for_each_online_cpu() loops that 
> might sleep, correct? 

I would shy from saying that "that's the only problem". It could also be

	for_each_cpu_mask(some_mask)
		do_something_which_sleeps();

where some_mask is suppsoed to represent a subset of online cpus.

For ex: policy->cpus is a mask maintained by cpufreq, which it iterates thr' 
whenever changing cpu frequency. The cpus in that mask are supposed to be 
a subset of online cpus (with CPU_ONLINE/DEAD handlers in cpufreq.c adjusting 
the mask upon hotplug).

We could adopt a similar trick (get/put_each_cpu_mask) that you describe
below in those extended cases as well.

> the 10% loops that _can_ schedule would trigger the __might_sleep() 
> atomicity test in schedule()), and those would have to be converted a 
> bit more cleverly, on a case by case basis.

The real question is how do we convert over those sleeping
for_each_cpu_mask users (for ex: flush_workqueue) such that they don't
block freezer/hotplug for long periods?

One option is to probably rewrite them to understand that
online[or a derived]_map could have changed everytime they come out of a 
(un)interruptible sleep and deal with arising races appropriately. That
would mean a bit of maintenance headache unfortunately (I was hoping
freezer will lead to zero maintenance headache :)

Besides, how problematic is this in practise (that threads sleep for
extended durations in TASK_INTERRUPTIBLE state breaking
freezer/suspend/hotplug)?

Should we ignore this for the timebeing and take up later as and when
users report problems?

-- 
Regards,
vatsa
