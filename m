Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZKMJAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZKMJAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbZKMJA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:00:27 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51310 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbZKMJA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:00:26 -0500
Message-ID: <4AFD2027.5060303@in.ibm.com>
Date: Fri, 13 Nov 2009 14:30:23 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: -next: Nov 12 - kernel BUG at kernel/sched.c:7359!
References: <20091112195101.63263490.sfr@canb.auug.org.au> <4AFBF73B.5040500@in.ibm.com> <1258027820.4039.129.camel@laptop> <4AFBFE3D.80507@in.ibm.com>  <1258028831.4039.152.camel@laptop> <1258045831.4039.736.camel@laptop>
In-Reply-To: <1258045831.4039.736.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> So what we need to do is make the whole of select_task_rq_fair()
> cpu_online/active_mask aware, or give up and simply punt:
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 1f2e99d..62df61c 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2377,6 +2377,9 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
>  	task_rq_unlock(rq, &flags);
>
>  	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
> +	if (!cpu_active(cpu))
> +		cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
> +
>  	if (cpu != orig_cpu) {
>  		local_irq_save(flags);
>  		rq = cpu_rq(cpu);
>
>
> Something I think Mike also tried and didn't deadlock for him..
>
> Sachin, Mike, could you try the above snippet and verify if it does
> indeed solve your respective issues?
>   
Unfortunately the above patch made things worse. With this patch
the machine failed to boot with following oops

CPU0: Dual-Core AMD Opteron(tm) Processor 2218 stepping 02
BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
IP: [<ffffffff81061f17>] set_task_cpu+0x189/0x1ed
PGD 0
Oops: 0000 [#1] SMP
last sysfs file:
CPU 0
Modules linked in:
Pid: 3, comm: kthreadd Not tainted 2.6.32-rc7-next-20091113 #1 BladeCenter LS21 -[79716AA]-
RIP: 0010:[<ffffffff81061f17>]  [<ffffffff81061f17>] set_task_cpu+0x189/0x1ed
RSP: 0018:ffff88012b357dd0  EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000004
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff88012b340000
RBP: ffff88012b357e10 R08: 0000000000000004 R09: ffff88012b3401f8
R10: 00000000000cffa7 R11: 0000000000000000 R12: ffff88012b340000
R13: 000000000c28ccf6 R14: 0000000000000004 R15: ffff880028214cc0
FS:  0000000000000000(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000020 CR3: 000000000174e000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kthreadd (pid: 3, threadinfo ffff88012b356000, task ffff88012b3431c0)
Stack:
 ffff880028214d20 0000000000000000 0000000028215640 0000000000000000
<0> ffff88012b340000 0000000000000001 ffff880028214cc0 0000000000000000
<0> ffff88012b357e60 ffffffff81063a75 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff81063a75>] try_to_wake_up+0x103/0x31f
 [<ffffffff81063c9e>] default_wake_function+0xd/0xf
 [<ffffffff810519a7>] __wake_up_common+0x46/0x76
 [<ffffffff810648ae>] ? migration_thread+0x0/0x285
 [<ffffffff810577c8>] complete+0x38/0x4b
 [<ffffffff8108040a>] kthread+0x67/0x85
 [<ffffffff810298fa>] child_rip+0xa/0x20
 [<ffffffff810803a3>] ? kthread+0x0/0x85
 [<ffffffff810298f0>] ? child_rip+0x0/0x20
Code: 00 8b 05 dd d7 df 04 85 c0 74 19 45 31 c0 31 c9 ba 01 00 00 00 be 01 00 00 00 bf 04 00 00 00 e8 79 02 07 00 48 8b 55 c8 44 89 f1 <48> 8b 42 20 48 8b 55 c0 49 03 84 24 88 00 00 00 48 2b 42 20 49
RIP  [<ffffffff81061f17>] set_task_cpu+0x189/0x1ed
 RSP <ffff88012b357dd0>
CR2: 0000000000000020
---[ end trace 4eaa2a86a8e2da22 ]---

I tried this with today's next (2.6.32-rc7-20091113) + the above patch.
Here is how the code looks after applying the patch...

        task_rq_unlock(rq, &flags);

        cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
        if (!cpu_active(cpu))
                cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);

        if (cpu != orig_cpu)
                set_task_cpu(p, cpu);

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

