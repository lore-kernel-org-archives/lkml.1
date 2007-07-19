Return-Path: <linux-kernel-owner+w=401wt.eu-S966079AbXGSTZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966079AbXGSTZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965630AbXGSTZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:25:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:49088 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965500AbXGSTZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:25:12 -0400
Date: Thu, 19 Jul 2007 12:24:02 -0700 (PDT)
From: Jeremy Katz <jeremy.katz@windriver.com>
X-X-Sender: jkatz@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
In-Reply-To: <1184824221.12353.526.camel@chaos>
Message-ID: <Pine.LNX.4.63.0707191218460.25702@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain> 
 <1184662429.12353.426.camel@chaos>  <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
  <1184703427.12353.476.camel@chaos>  <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain>
  <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain> 
 <1184738755.12353.481.camel@chaos> <1184741938.12353.484.camel@chaos> 
 <Pine.LNX.4.63.0707181159010.3157@localhost.localdomain> 
 <Pine.LNX.4.63.0707181631450.3157@localhost.localdomain> <1184824221.12353.526.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 19 Jul 2007 19:24:03.0162 (UTC) FILETIME=[5DA903A0:01C7CA3A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Thomas Gleixner wrote:

> On Wed, 2007-07-18 at 16:43 -0700, Jeremy Katz wrote:
>> On Wed, 18 Jul 2007, Jeremy Katz wrote:
>>
>>> On Wed, 18 Jul 2007, Thomas Gleixner wrote:
>>>
>>>>> Also can you please enable CONFIG_PROVE_LOCKING, which might catch any
>>>>> locking problem, which might be related to this.
>>>>
>>>> Another test: Can you please disable CONFIG_SCHED_SMT to narrow it down
>>>> further ?
>>>
>>> I'll try both of these.
>>
>> I'm still seeing the sys_timer_delete version with your patch, and
>> sys_timer_delete and posix_timer_event without. The itimer_delete version
>> is currently missing in action, but getting any particular one to perform
>> on demand is currently not in my power.
>
> Ok, let me summarize:
>
> 2.6.22 + hrt6
>
> Both problems are there whether CONFIG_SCHED_SMT is on or not

If both means BUG triggered in sigqueue_free and send_sigqueue, then yes.

>
> 2.6.22 + hrt6 + posixtimer patch
>
> Both problems are there whether CONFIG_SCHED_SMT is on
> The timer callback problem is gone when CONFIG_SCHED_SMT is off

It turns out that the callback problem just took longer to show up with 
CONFIG_SCHED_SMT off.  I saw this when I came in this morning:

------------[ cut here ]------------
Kernel BUG at c012682d [verbose debug info unavailable]
invalid opcode: 0000 [#6]
SMP
Modules linked in:
CPU:    3
EIP:    0060:[<c012682d>]    Not tainted VLI
EFLAGS: 00010046   (2.6.22.1-WR1.4aq_cgl #5)
EIP is at send_sigqueue+0xe0/0xe8
eax: 00000020   ebx: f735e7d8   ecx: f73ea030   edx: f735e7d8
esi: f73ea030   edi: 00000020   ebp: c050cf84   esp: c050cf70
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process hrtm_test (pid: 11102, ti=c050c000 task=f6a2d550 task.ti=f6fb7000)
Stack: 00000000 f722c89c f722c894 f722c8e0 f735e864 c050cf94 c012d519 
f722c894
        00000025 c050cfc0 c012d595 c2a41990 c2a41980 c050cfb4 00000046 
00000000
        00000282 c012d54d f722c8e0 c2a41980 c050cfdc c0131c20 00000000 
c2a41a18
Call Trace:
  [<c01035c4>] show_trace_log_lvl+0x1a/0x30
  [<c010367b>] show_stack_log_lvl+0x8d/0xaa
  [<c01038b5>] show_registers+0x1cd/0x2cb
  [<c0103b0a>] die+0x113/0x207
  [<c03a926d>] do_trap+0x8f/0xc6
  [<c0103df5>] do_invalid_op+0x88/0x92
  [<c03a903a>] error_code+0x72/0x78
  [<c012d519>] posix_timer_event+0x71/0xa5
  [<c012d595>] posix_timer_fn+0x48/0xdd
  [<c0131c20>] run_hrtimer_softirq+0x5a/0xba
  [<c01211ac>] __do_softirq+0x7e/0xf9
  [<c0104708>] do_softirq+0x8c/0x101
  [<c0121292>] irq_exit+0x4b/0x4d
  [<c010f315>] smp_apic_timer_interrupt+0x2f/0x39
  [<c01032db>] apic_timer_interrupt+0x33/0x38
  [<c0125308>] __sigqueue_free+0x24/0x33
  [<c01266f7>] sigqueue_free+0x1f/0x75
  [<c012d771>] release_posix_timer+0x1b/0x7a
  [<c012e00c>] sys_timer_delete+0xda/0x10f
  [<c0102802>] syscall_call+0x7/0xb
  =======================
Code: 45 ec 01 00 00 00 eb c8 89 fa 89 f0 e8 ac 99 06 00 eb 93 81 7b 14 fe 
ff 01 00 75 13 83 43 1c 01 eb ae c7 45 ec ff ff ff ff eb b8 <0f> 0b eb fe 
0f 0b eb fe 55 89 e5 57 89 c7 56 89 ce 53 89 d3 83
EIP: [<c012682d>] send_sigqueue+0xe0/0xe8 SS:ESP 0068:c050cf70
Kernel panic - not syncing: Fatal exception in interrupt
BUG: spinlock lockup on CPU#2, hrtm_test/1355, f722c89c
  [<c01035c4>] show_trace_log_lvl+0x1a/0x30
  [<c01035ec>] show_trace+0x12/0x14
  [<c01036e6>] dump_stack+0x16/0x18
  [<c0275dca>] __spin_lock_debug+0xb3/0xc5
  [<c0275e31>] _raw_spin_lock+0x55/0x73
  [<c03a8ba6>] _spin_lock+0x32/0x38
  [<c012daa4>] lock_timer+0x3d/0xab
  [<c012df5d>] sys_timer_delete+0x2b/0x10f
  [<c0102802>] syscall_call+0x7/0xb
  =======================
BUG: spinlock lockup on CPU#0, hrtm_test/1374, c04918d0
BUG: spinlock lockup on CPU#1, hrtm_test/1387, c04918d0
  [<c01035c4>] show_trace_log_lvl+0x1a/0x30
  [<c01035ec>] show_trace+0x12/0x14
  [<c01036e6>] dump_stack+0x16/0x18
  [<c0275dca>] __spin_lock_debug+0xb3/0xc5
  [<c0275e31>] _raw_spin_lock+0x55/0x73
  [<c03a8961>] _spin_lock_irqsave+0x3f/0x4b
  [<c012da85>] lock_timer+0x1e/0xab
  [<c012df5d>] sys_timer_delete+0x2b/0x10f
  [<c0102802>] syscall_call+0x7/0xb
  =======================
  [<c01035c4>] show_trace_log_lvl+0x1a/0x30
  [<c01035ec>] show_trace+0x12/0x14
  [<c01036e6>] dump_stack+0x16/0x18
  [<c0275dca>] __spin_lock_debug+0xb3/0xc5
  [<c0275e31>] _raw_spin_lock+0x55/0x73
  [<c03a8961>] _spin_lock_irqsave+0x3f/0x4b
  [<c012da85>] lock_timer+0x1e/0xab
  [<c012df5d>] sys_timer_delete+0x2b/0x10f
  [<c0102802>] syscall_call+0x7/0xb
  =======================

Jeremy
