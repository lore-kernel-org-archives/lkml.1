Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbYGCMx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbYGCMx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbYGCMxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:53:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:7056 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbYGCMxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:53:15 -0400
Message-ID: <19f34abd0807030207t189ae63eo6c6aea03263a96ad@mail.gmail.com>
Date: Thu, 3 Jul 2008 11:07:53 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [BUG] hotplug_cpu vs no_hz
Cc: tglx@linutronix.de, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <486C7349.9010707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <486C7349.9010707@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Thu, Jul 3, 2008 at 8:35 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> after several seconds ~ several hours, "echo 1 > /sys/devices/system/cpu/cpu1/online"
> was blocked, cpu#1 can not be used and the output of dmesg:
>
> BUG: soft lockup - CPU#1 stuck for 61s! [events/1:9898]
> CPU 1:
> Modules linked in:
> Pid: 9898, comm: events/1 Not tainted 2.6.26-rc8-official-LAI-00089-ge1441b9 #5
> RIP: 0010:[<ffffffff80237612>]  [<ffffffff80237612>] __do_softirq+0x4b/0xc7
> RSP: 0018:ffff81006b42ff20  EFLAGS: 00000206
> RAX: ffff81006a9b9fd8 RBX: ffff81006b42ff40 RCX: 0000000000000006
> RDX: 0000000000000042 RSI: ffffffff8022da16 RDI: ffffffff8022da16
> RBP: ffff81006b42fea0 R08: ffff81007f2c9178 R09: ffff81007f2c9140
> R10: ffff8100807cc000 R11: 0000000000000000 R12: ffffffff8020be36
> R13: ffff81006b42fea0 R14: ffffffff807a5100 R15: 0000000000000042
> FS:  0000000000000000(0000) GS:ffff81007fb3ccc0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00007f4cc97b6000 CR3: 0000000000201000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>
> Call Trace:
>  <IRQ>  [<ffffffff8020c38c>] ? call_softirq+0x1c/0x28
>  [<ffffffff8020dad6>] ? do_softirq+0x34/0x72
>  [<ffffffff80237586>] ? irq_exit+0x3f/0x80
>  [<ffffffff8021b128>] ? smp_apic_timer_interrupt+0x8b/0xa7
>  [<ffffffff8020be36>] ? apic_timer_interrupt+0x66/0x70
>  <EOI>  [<ffffffff8022da16>] ? finish_task_switch+0x31/0x82
>  [<ffffffff80590e7d>] ? thread_return+0x3d/0x9c
>  [<ffffffff80241ca1>] ? worker_thread+0xa3/0xe5
>  [<ffffffff80244780>] ? autoremove_wake_function+0x0/0x38
>  [<ffffffff80241bfe>] ? worker_thread+0x0/0xe5
>  [<ffffffff80244645>] ? kthread+0x49/0x78
>  [<ffffffff8020c018>] ? child_rip+0xa/0x12
>  [<ffffffff802445fc>] ? kthread+0x0/0x78
>  [<ffffffff8020c00e>] ? child_rip+0x0/0x12

I believe I have experienced this as well, and I tried to debug it
with Peter Zijlstra (Cc added).

I only managed to get this message once. But I made a patch that could
help us debug this, see

commit 8d5be7f4e8515af461cbc8f07687ccc81507d508
Date:   Wed Jun 25 08:50:10 2008 +0200

    softlockup: show irqtrace

from the core/softlockup branch in the -tip tree. (This commit is also
present in tip/master.)

In order to see the effect of this, you need CONFIG_TRACE_IRQFLAGS=y.
This will tell us when/where irqs were last disabled and will
hopefully give a hint of where the block is really occurring. (Unless
it is already obvious to you or others; it isn't to me :-))

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
