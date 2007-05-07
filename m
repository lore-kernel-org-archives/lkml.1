Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbXEGKre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbXEGKre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 06:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932263AbXEGKrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 06:47:33 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46763 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbXEGKrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 06:47:32 -0400
Date: Mon, 7 May 2007 16:17:24 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [BUG] cpu-hotplug: Can't offline the CPU with naughty realtime processes
Message-ID: <20070507104724.GA10624@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satoru,

On Mon, May 07, 2007 at 07:10:05PM +0900, Satoru Takeuchi wrote:
> Hi,
> 
> I found a bug on 2.6.21 cpu-hotplug code.

IIRC, __stop_machine_run is used by subsystems other than cpu-hotplug. 
So we're not the only ones bugged.

> 
> When process A on CPU0 try to offline the CPU1 on which the process B,
> realtime process (its task->policy == SCHED_FIFO or SCHED_RR) running
> without sleep or yield, both CPU0 and CPU1 get hang. It's because of
> the following code on __stop_machine_run().
> 
> struct task_struct *__stop_machine_run(int (*fn)(void *), void *data,
> 				       unsigned int cpu)
> {
> 	...
> 	p = kthread_create(do_stop, &smdata, "kstopmachine");
> 	if (!IS_ERR(p)) {
> 		kthread_bind(p, cpu);
> 		wake_up_process(p);
> 		wait_for_completion(&smdata.done);
> 	}
> 	...
> }
> 
> kstopmachine is created, bound to the CPU1, and woken up here, but
> this process can't start to run because reschedule doesn't occur on
> CPU1. Hence CPU0 also be able to run because it's waiting completion
> of CPU1's offline work.


But each of these stop_machine_run threads run at MAX_RT_PRIO - 1 
with SCHED_FIFO. So unless B is also running at MAX_RT_PRIO - 1,
there should not be a hang. Moreover, I doubt if we have kernel threads(B)
which runs at MAX_RT_PRIO - 1.

Nevertheless, with the freezer based approach that we're experimenting,
this problem shouldn't arise. We expect the whole system to get frozen
before we actually do a cpu_down() (which will then call
__stop_machine_run). So any such rogue RT task will have to first fail
the freezer ( which it will), but that's ok, since on a freezer-fail,
we just thaw all the processes and get the system up and running again.
Yeah, the cpu-hotplug operation will fail though.


> 
> Thanks,
> 
> Sat

Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
