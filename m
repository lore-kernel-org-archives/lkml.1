Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYGEFZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYGEFZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 01:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYGEFZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 01:25:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51127 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbYGEFZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 01:25:42 -0400
Message-ID: <486F055B.3010308@cn.fujitsu.com>
Date: Sat, 05 Jul 2008 13:23:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] hotplug_cpu vs no_hz
References: <486C7349.9010707@cn.fujitsu.com> <19f34abd0807030207t189ae63eo6c6aea03263a96ad@mail.gmail.com>
In-Reply-To: <19f34abd0807030207t189ae63eo6c6aea03263a96ad@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> Hi!
> 
> On Thu, Jul 3, 2008 at 8:35 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> after several seconds ~ several hours, "echo 1 > /sys/devices/system/cpu/cpu1/online"
>> was blocked, cpu#1 can not be used and the output of dmesg:
>>
>> BUG: soft lockup - CPU#1 stuck for 61s! [events/1:9898]
>> CPU 1:
>> Modules linked in:
>> Pid: 9898, comm: events/1 Not tainted 2.6.26-rc8-official-LAI-00089-ge1441b9 #5
>> RIP: 0010:[<ffffffff80237612>]  [<ffffffff80237612>] __do_softirq+0x4b/0xc7
>> RSP: 0018:ffff81006b42ff20  EFLAGS: 00000206
>> RAX: ffff81006a9b9fd8 RBX: ffff81006b42ff40 RCX: 0000000000000006
>> RDX: 0000000000000042 RSI: ffffffff8022da16 RDI: ffffffff8022da16
>> RBP: ffff81006b42fea0 R08: ffff81007f2c9178 R09: ffff81007f2c9140
>> R10: ffff8100807cc000 R11: 0000000000000000 R12: ffffffff8020be36
>> R13: ffff81006b42fea0 R14: ffffffff807a5100 R15: 0000000000000042
>> FS:  0000000000000000(0000) GS:ffff81007fb3ccc0(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> CR2: 00007f4cc97b6000 CR3: 0000000000201000 CR4: 00000000000006a0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>
>> Call Trace:
>>  <IRQ>  [<ffffffff8020c38c>] ? call_softirq+0x1c/0x28
>>  [<ffffffff8020dad6>] ? do_softirq+0x34/0x72
>>  [<ffffffff80237586>] ? irq_exit+0x3f/0x80
>>  [<ffffffff8021b128>] ? smp_apic_timer_interrupt+0x8b/0xa7
>>  [<ffffffff8020be36>] ? apic_timer_interrupt+0x66/0x70
>>  <EOI>  [<ffffffff8022da16>] ? finish_task_switch+0x31/0x82
>>  [<ffffffff80590e7d>] ? thread_return+0x3d/0x9c
>>  [<ffffffff80241ca1>] ? worker_thread+0xa3/0xe5
>>  [<ffffffff80244780>] ? autoremove_wake_function+0x0/0x38
>>  [<ffffffff80241bfe>] ? worker_thread+0x0/0xe5
>>  [<ffffffff80244645>] ? kthread+0x49/0x78
>>  [<ffffffff8020c018>] ? child_rip+0xa/0x12
>>  [<ffffffff802445fc>] ? kthread+0x0/0x78
>>  [<ffffffff8020c00e>] ? child_rip+0x0/0x12
> 
> I believe I have experienced this as well, and I tried to debug it
> with Peter Zijlstra (Cc added).
> 
> I only managed to get this message once. But I made a patch that could
> help us debug this, see
> 
> commit 8d5be7f4e8515af461cbc8f07687ccc81507d508
> Date:   Wed Jun 25 08:50:10 2008 +0200
> 
>     softlockup: show irqtrace
> 
> from the core/softlockup branch in the -tip tree. (This commit is also
> present in tip/master.)

I have applied it in new test.

> 
> In order to see the effect of this, you need CONFIG_TRACE_IRQFLAGS=y.
> This will tell us when/where irqs were last disabled and will
> hopefully give a hint of where the block is really occurring. (Unless
> it is already obvious to you or others; it isn't to me :-))
> 
> Thanks,
> 
> 
> Vegard
> 

I pulled the most recent tree, but messages like
"BUG: soft lockup - CPU#1 stuck for 61s! [events/1:9898]"
can not be triggered.

This is the new dmesg:
(But i hasn't tested that whether these messages occurred when CONFIG_NO_HZ=n)

 =======================
INFO: task bash:18198 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
bash          D 4e69057c     0 18198  18191
       f5b4ce00 00000086 f7332248 4e69057c 0000321b f7341d40 f7341fac c20126c0
       00000000 f7341d40 c04586c0 f7341d40 00000000 f5b4ce00 c02f67be f73430c0
       4e690578 7fffffff 7fffffff f5be5ea8 00000002 c02f6b11 f771f390 00000000
Call Trace:
 [<c02f67be>] schedule+0x775/0x7c5
 [<c02f6b11>] schedule_timeout+0x13/0x86
 [<c02f6924>] wait_for_common+0xb2/0xf4
 [<c0119017>] default_wake_function+0x0/0x8
 [<c012f068>] synchronize_rcu+0x2a/0x32
 [<c012f036>] wakeme_after_rcu+0x0/0x8
 [<c011d240>] update_sched_domains+0x29/0x44
 [<c02f976a>] notifier_call_chain+0x2a/0x47
 [<c02e9e2d>] _cpu_down+0x6f/0x205
 [<c0151dff>] __alloc_pages_internal+0xd0/0x365
 [<c02e9fe3>] cpu_down+0x20/0x2c
 [<c02eaef8>] store_online+0x24/0x56
 [<c02eaed4>] store_online+0x0/0x56
 [<c023f48e>] sysdev_store+0x1e/0x22
 [<c01a3546>] sysfs_write_file+0xa4/0xd8
 [<c01a34a2>] sysfs_write_file+0x0/0xd8
 [<c016c514>] vfs_write+0x83/0x120
 [<c016cad4>] sys_write+0x3c/0x63
 [<c0103882>] syscall_call+0x7/0xb
 =======================
INFO: task crond:18687 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
crond         D 3ef0cf27     0 18687  14998
       f59d7e00 00000086 00000000 3ef0cf27 00003245 f7831d40 f7831fac c20126c0
       00000000 00000000 00000000 00000000 00000000 00000004 f5b9def6 f6377a84
       f6377a84 7fffffff 7fffffff f5b9df4c 00000002 c02f6b11 00000000 00000000
Call Trace:
 [<c02f6b11>] schedule_timeout+0x13/0x86
 [<c01b0120>] key_alloc+0x1f9/0x2c4
 [<c02f6924>] wait_for_common+0xb2/0xf4
 [<c0119017>] default_wake_function+0x0/0x8
 [<c012f068>] synchronize_rcu+0x2a/0x32
 [<c012f036>] wakeme_after_rcu+0x0/0x8
 [<c01b216d>] install_session_keyring+0xb3/0xc3
 [<c01b2804>] join_session_keyring+0x1a/0xa6
 [<c0103882>] syscall_call+0x7/0xb
 =======================



