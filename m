Return-Path: <linux-kernel-owner+w=401wt.eu-S1750846AbZC0ImS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750846AbZC0ImS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 04:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZC0Il7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 04:41:59 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46397 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbZC0Il4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 04:41:56 -0400
Date: Fri, 27 Mar 2009 14:11:44 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] tracing/wakeup: move access to wakeup_cpu
	into spinlock
Message-ID: <20090327084144.GA23318@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <20090326122806.GA4188@in.ibm.com> <20090326132739.GB5960@nowhere> <alpine.DEB.2.00.0903260949340.17665@gandalf.stny.rr.com> <alpine.DEB.2.00.0903261032070.17665@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903261032070.17665@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 10:40:47AM -0400, Steven Rostedt wrote:
> 
> Ingo,
> 
> I believe this is the fix for the oops that Maneesh saw. What he explains 
> he did sounds like it would trigger the race. Reading the trace output
> resets wakeup_task to NULL and wakeup_cpu to -1. And he hit the bug by 
> just reading the trace in a while loop.
> 
> Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace-1
> 
> 
> Steven Rostedt (1):
>       tracing/wakeup: move access to wakeup_cpu into spinlock
> 
> ----
>  kernel/trace/trace_sched_wakeup.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> ---------------------------
> commit 8ac070ca952d14c57e3d772e203fd117161cc596
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Thu Mar 26 10:25:24 2009 -0400
> 
>     tracing/wakeup: move access to wakeup_cpu into spinlock
>     
>     Impact: fix for race condition
>     
>     The code had the following outside the lock:
>     
>             if (next != wakeup_task)
>                     return;
>     
>             pc = preempt_count();
>     
>             /* The task we are waiting for is waking up */
>             data = wakeup_trace->data[wakeup_cpu];
>     
>     On initialization, wakeup_task is NULL and wakeup_cpu -1. This code
>     is not under a lock. If wakeup_task is set on another CPU as that
>     task is waking up, we can see the wakeup_task before wakeup_cpu is
>     set. If we read wakeup_cpu while it is still -1 then we will have
>     a bad data pointer.
>     
>     This patch moves the reading of wakeup_cpu within the protection of
>     the spinlock used to protect the writing of wakeup_cpu and wakeup_task.
>     
>     Reported-by: Maneesh Soni <maneesh@in.ibm.com>
>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
> index 3c5ad6b..9e4ce4c 100644
> --- a/kernel/trace/trace_sched_wakeup.c
> +++ b/kernel/trace/trace_sched_wakeup.c
> @@ -138,9 +138,6 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
> 
>  	pc = preempt_count();
> 
> -	/* The task we are waiting for is waking up */
> -	data = wakeup_trace->data[wakeup_cpu];
> -
>  	/* disable local data, not wakeup_cpu data */
>  	cpu = raw_smp_processor_id();
>  	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
> @@ -154,6 +151,9 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
>  	if (unlikely(!tracer_enabled || next != wakeup_task))
>  		goto out_unlock;
> 
> +	/* The task we are waiting for is waking up */
> +	data = wakeup_trace->data[wakeup_cpu];
> +
>  	trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
>  	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
> 
> 

Hi Steven,

I still the oops with the patch,

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff802d2259>] probe_wakeup_sched_switch+0xd2/0x1ac
PGD 1d68e9067 PUD 1e6cdf067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:0c/0000:0c:00.0/irq
CPU 5 
Modules linked in: autofs4 hidp rfcomm l2cap bluetooth iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod sbs sbshc battery ac parport_pc lp parport sg sr_mod ide_cd_mod cdrom serio_raw acpi_memhotplug button tg3 libphy i2c_piix4 i2c_core pcspkr usb_storage uhci_hcd ohci_hcd ehci_hcd aacraid sd_mod scsi_mod ext3 jbd
Pid: 6095, comm: cat Not tainted 2.6.29-tip-test #2 eserver xSeries 366-[88632RA]-
RIP: 0010:[<ffffffff802d2259>]  [<ffffffff802d2259>] probe_wakeup_sched_switch+0xd2/0x1ac
RSP: 0000:ffff8801e6d03ea0  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8800281989a0 RCX: 0000000000000046
RDX: ffff8800281989a0 RSI: ffffffff8020d56d RDI: ffffffff811de480
RBP: ffff8801e6d03ed0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000046
R13: ffff88022f232820 R14: 0000000000000000 R15: 0000000000000005
FS:  00007f98b94cb6e0(0000) GS:ffff88002818b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 0000000224595000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cat (pid: 6095, threadinfo ffff8801e6d02000, task ffff8801d6935040)
Stack:
 ffff8801d6935040 ffff880224981230 ffff88002819dd40 0000003b4ae00aa0
 00007fffc14df830 ffff88002819dd40 ffff8801e6d03f70 ffffffff806f8264
 0000000000000002 ffff8801e6d03f48 ffff8801d6935040 ffff88022f232820
Call Trace:
 [<ffffffff806f8264>] schedule+0xd99/0x10f9
 [<ffffffff806fb61b>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff8027d2cb>] ? delayed_work_timer_fn+0x0/0x38
 [<ffffffff8020d56d>] retint_careful+0x12/0x2e
Code: 2d ad de f2 00 75 77 48 63 05 ac de f2 00 48 8b 4d 00 45 89 f0 48 8b 3d 8e de f2 00 48 8b 71 08 48 8b 5c c7 28 48 8b 01 4c 89 e1 <48> 8b 50 08 e8 f6 9f ff ff 48 8b 3d 6f de f2 00 48 8b 75 d0 45 
RIP  [<ffffffff802d2259>] probe_wakeup_sched_switch+0xd2/0x1ac
 RSP <ffff8801e6d03ea0>
CR2: 0000000000000008

thanks
Maneesh




-- 
Maneesh Soni
Linux Technology Center
IBM India Systems and Technology Lab,
Bangalore, India.
