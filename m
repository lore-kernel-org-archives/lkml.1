Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXEGKr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXEGKr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 06:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbXEGKr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 06:47:28 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53566 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbXEGKr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 06:47:27 -0400
Date: Mon, 7 May 2007 16:25:16 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Gautham shenoy <ego@in.ibm.com>
Subject: Re: [BUG] cpu-hotplug: Can't offline the CPU with naughty realtime processes
Message-ID: <20070507105516.GL7311@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 07:10:05PM +0900, Satoru Takeuchi wrote:
> Hi,
> 
> I found a bug on 2.6.21 cpu-hotplug code.
> 
> When process A on CPU0 try to offline the CPU1 on which the process B,
> realtime process (its task->policy == SCHED_FIFO or SCHED_RR) running
> without sleep or yield, both CPU0 and CPU1 get hang. 

One could argue that this can be tackled in userspace by SIGSTOPping all
such real-time threads before hotplugging CPUs and SIGCONTing them after
hotplug is complete.

Would this simple solution be acceptable?

Otherwise, we need to have:

1.  __stop_machine_run() set the priority/policy of the first kthread
   (do_stop) to MAX_RT_PRIO-1/SCHED_FIFO *before* waking it up

2. scheduler gives some API to add a thread to /front/ of runqueue
   (enqueue_task_head is internal to sched.c) and use that API in
   activating all stop_machine related threads.

> It's because of the following code on __stop_machine_run().
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

-- 
Regards,
vatsa
