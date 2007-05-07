Return-Path: <linux-kernel-owner+w=401wt.eu-S933876AbXEGNnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876AbXEGNnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933826AbXEGNnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:43:15 -0400
Received: from ozlabs.org ([203.10.76.45]:53356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933815AbXEGNnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:43:15 -0400
Subject: Re: [BUG] cpu-hotplug: Can't offline the CPU with naughty realtime
	processes
From: Rusty Russell <rusty@rustcorp.com.au>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com>
References: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 07 May 2007 23:42:53 +1000
Message-Id: <1178545373.28438.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 19:10 +0900, Satoru Takeuchi wrote:
> Hi,
> 
> I found a bug on 2.6.21 cpu-hotplug code.
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

Yes, we should probably move the set_scheduler call in stop_machine
(where the thread up-prioritizes itself) to before wake_up_process(p),
to avoid this happening.

Others have suggested we use the freezer; I've always distrusted that
code.  It's much trickier than stop_machine().

I look forward to your patch!
Rusty.

