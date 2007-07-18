Return-Path: <linux-kernel-owner+w=401wt.eu-S965069AbXGRXrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069AbXGRXrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937680AbXGRXoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:44:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:33513 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937650AbXGRXov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:44:51 -0400
Date: Wed, 18 Jul 2007 16:43:40 -0700 (PDT)
From: Jeremy Katz <jeremy.katz@windriver.com>
X-X-Sender: jkatz@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
In-Reply-To: <Pine.LNX.4.63.0707181159010.3157@localhost.localdomain>
Message-ID: <Pine.LNX.4.63.0707181631450.3157@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain> 
 <1184662429.12353.426.camel@chaos>  <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
  <1184703427.12353.476.camel@chaos>  <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain>
  <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain> 
 <1184738755.12353.481.camel@chaos> <1184741938.12353.484.camel@chaos>
 <Pine.LNX.4.63.0707181159010.3157@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 18 Jul 2007 23:43:40.0580 (UTC) FILETIME=[781C9E40:01C7C995]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Jeremy Katz wrote:

> On Wed, 18 Jul 2007, Thomas Gleixner wrote:
>
>>> Also can you please enable CONFIG_PROVE_LOCKING, which might catch any
>>> locking problem, which might be related to this.
>> 
>> Another test: Can you please disable CONFIG_SCHED_SMT to narrow it down
>> further ?
>
> I'll try both of these.

I'm still seeing the sys_timer_delete version with your patch, and 
sys_timer_delete and posix_timer_event without. The itimer_delete version 
is currently missing in action, but getting any particular one to perform 
on demand is currently not in my power.


Jeremy



Stack dumps with 2.6.22.1 + hrt6:
------------[ cut here ]------------
Kernel BUG at c01266fb [verbose debug info unavailable]
invalid opcode: 0000 [#1]
SMP
Modules linked in:
CPU:    1
EIP:    0060:[<c01266fb>]    Not tainted VLI
EFLAGS: 00010246   (2.6.22.1-WR1.4aq_cgl #4)
EIP is at sigqueue_free+0x23/0x75
eax: 00000000   ebx: f6f5f868   ecx: 00000000   edx: 00000000
esi: f73d1614   edi: 00000000   ebp: f737ff8c   esp: f737ff84
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process hrtm_test (pid: 1442, ti=f737f000 task=f738b590 task.ti=f737f000)
Stack: 00000286 f73d1614 f737ff9c c012d771 f73d1614 0000067c f737ffb0 
c012dfff
        00000282 0000067c 00000000 f737f000 c0102802 0000067c 466afff4 
92607898
        00000000 00000000 936a43c8 00000107 c010007b 0000007b 00000000 
00000107
Call Trace:
  [<c01035c4>] show_trace_log_lvl+0x1a/0x30
  [<c010367b>] show_stack_log_lvl+0x8d/0xaa
  [<c01038b5>] show_registers+0x1cd/0x2cb
  [<c0103b0a>] die+0x113/0x207
  [<c03a925d>] do_trap+0x8f/0xc6
  [<c0103df5>] do_invalid_op+0x88/0x92
  [<c03a902a>] error_code+0x72/0x78
  [<c012d771>] release_posix_timer+0x1b/0x7a
  [<c012dfff>] sys_timer_delete+0xda/0x10f
  [<c0102802>] syscall_call+0x7/0xb
  =======================
Code: 74 04 83 48 08 01 5d c3 55 89 e5 56 53 89 c3 8b 40 08 a8 01 74 15 39 
1b 75 15 83 e0 fe 89 43 08 89 d8 e8 ed eb ff ff 5b 5e 5d c3 <0f> 0b eb fe 
64 a1 00f0 4f c0 8b b0 50 04 00 00 b8 00 3e 4b c0
EIP: [<c01266fb>] sigqueue_free+0x23/0x75 SS:ESP 0068:f737ff84


------------[ cut here ]------------
Kernel BUG at c012682d [verbose debug info unavailable]
invalid opcode: 0000 [#5]
SMP
Modules linked in:
CPU:    3
EIP:    0060:[<c012682d>]    Not tainted VLI
EFLAGS: 00010046   (2.6.22.1-WR1.4aq_cgl #4)
EIP is at send_sigqueue+0xe0/0xe8
eax: 00000020   ebx: f6d44c58   ecx: f71e8aa0   edx: f6d44c58
esi: f71e8aa0   edi: 00000020   ebp: c050cf84   esp: c050cf70
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=c050c000 task=c2e00aa0 task.ti=c2e02000)
Stack: 00000000 f6f6bd9c f6f6bd94 f6f6bde0 f6d44ce4 c050cf94 c012d519 
f6f6bd94
        00000003 c050cfc0 c012d595 c2a41990 c2a41980 c050cfb4 00000046 
00000000
        00000282 c012d54d f6f6bde0 c2a41980 c050cfdc c0131c14 00000000 
c2a41a18
Call Trace:
  [<c01035c4>] show_trace_log_lvl+0x1a/0x30
  [<c010367b>] show_stack_log_lvl+0x8d/0xaa
  [<c01038b5>] show_registers+0x1cd/0x2cb
  [<c0103b0a>] die+0x113/0x207
  [<c03a925d>] do_trap+0x8f/0xc6
  [<c0103df5>] do_invalid_op+0x88/0x92
  [<c03a902a>] error_code+0x72/0x78
  [<c012d519>] posix_timer_event+0x71/0xa5
  [<c012d595>] posix_timer_fn+0x48/0xdd
  [<c0131c14>] run_hrtimer_softirq+0x5a/0xba
  [<c01211ac>] __do_softirq+0x7e/0xf9
  [<c0104708>] do_softirq+0x8c/0x101
  [<c0121292>] irq_exit+0x4b/0x4d
  [<c010f315>] smp_apic_timer_interrupt+0x2f/0x39
  [<c01032db>] apic_timer_interrupt+0x33/0x38
  [<c0100b5c>] mwait_idle+0x12/0x14
  [<c0100a11>] cpu_idle+0x7b/0x7d
  [<c04d06d5>] start_secondary+0xe8/0x30c
  [<00000000>] 0x0
  =======================
Code: 45 ec 01 00 00 00 eb c8 89 fa 89 f0 e8 a0 99 06 00 eb 93 81 7b 14 fe 
ff 01 00 75 13 83 43 1c 01 eb ae c7 45 ec ff ff ff ff eb b8 <0f> 0b eb fe 
0f 0b eb fe 55 89 e5 57 89 c7 56 89 ce 53 89 d3 83
EIP: [<c012682d>] send_sigqueue+0xe0/0xe8 SS:ESP 0068:c050cf70
Kernel panic - not syncing: Fatal exception in interrupt



With 2.6.22.1 + hrt6 + tglx's proposed fix:
------------[ cut here ]------------
Kernel BUG at c01266fb [verbose debug info unavailable]
invalid opcode: 0000 [#1]
SMP
Modules linked in:
CPU:    0
EIP:    0060:[<c01266fb>]    Not tainted VLI
EFLAGS: 00010246   (2.6.22.1-WR1.4aq_cgl #5)
EIP is at sigqueue_free+0x23/0x75
eax: 00000000   ebx: f7349358   ecx: 00000000   edx: 00000000
esi: f7354194   edi: 00000000   ebp: f709af8c   esp: f709af84
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process hrtm_test (pid: 1424, ti=f709a000 task=f70d0ae0 task.ti=f709a000)
Stack: 00000286 f7354194 f709af9c c012d771 f7354194 00000190 f709afb0 
c012e00c
        00000282 00000190 00000000 f709a000 c0102802 00000190 466afff4 
8fa00fe0
        00000000 00000000 972753c8 00000107 ffff007b c010007b 00000000 
00000107
Call Trace:
  [<c01035c4>] show_trace_log_lvl+0x1a/0x30
  [<c010367b>] show_stack_log_lvl+0x8d/0xaa
  [<c01038b5>] show_registers+0x1cd/0x2cb
  [<c0103b0a>] die+0x113/0x207
  [<c03a926d>] do_trap+0x8f/0xc6
  [<c0103df5>] do_invalid_op+0x88/0x92
  [<c03a903a>] error_code+0x72/0x78
  [<c012d771>] release_posix_timer+0x1b/0x7a
  [<c012e00c>] sys_timer_delete+0xda/0x10f
  [<c0102802>] syscall_call+0x7/0xb
  =======================
Code: 74 04 83 48 08 01 5d c3 55 89 e5 56 53 89 c3 8b 40 08 a8 01 74 15 39 
1b 75 15 83 e0 fe 89 43 08 89 d8 e8 ed eb ff ff 5b 5e 5d c3 <0f> 0b eb fe 
64 a1 00 f0 4f c0 8b b0 50 04 00 00 b8 00 3e 4b c0
EIP: [<c01266fb>] sigqueue_free+0x23/0x75 SS:ESP 0068:f709af84
