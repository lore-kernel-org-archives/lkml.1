Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbYGFOut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbYGFOut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 10:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbYGFOul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 10:50:41 -0400
Received: from gw.goop.org ([64.81.55.164]:52085 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756900AbYGFOuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 10:50:40 -0400
Message-ID: <4870DBB6.30107@goop.org>
Date: Sun, 06 Jul 2008 07:50:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Generic callfunction IPI problems
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I'm seeing these oopses when running under Xen:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff8105de9a>] generic_smp_call_function_interrupt+0xfb/0x118
PGD 0 
Oops: 0000 [1] SMP 
CPU 15 
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.26-rc8-tip #306
RIP: e030:[<ffffffff8105de9a>]  [<ffffffff8105de9a>] generic_smp_call_function_interrupt+0xfb/0x118
RSP: e02b:ffff88007f653e98  EFLAGS: 00010046
RAX: ffffffff815fe6e0 RBX: ffff88007e523cc8 RCX: 0000000000000001
RDX: ffffc10000200200 RSI: 0000000000000001 RDI: ffffffff81693240
RBP: ffff88007f653eb8 R08: ffff88007f653ec8 R09: 0002db11ddd83820
R10: ffff880000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 000000000000000f R15: 0000000000000040
FS:  00007f1dadd907a0(0000) GS:ffff88007ff30080(0000) knlGS:0000000000000000
CS:  e033 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001001000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000000
Process swapper (pid: 0, threadinfo ffff88007ff90000, task ffff88007ff57100)
Stack:  ffff88007ff2f4c0 0000000000000000 0000000000000000 000000000000004d
 ffff88007f653ec8 ffffffff8100dea7 ffff88007f653ef8 ffffffff810747c5
 ffffffff816959c0 000000000000004d ffff88007ff2f4c0 ffffffff81695a10
Call Trace:
 <IRQ>  [<ffffffff8100dea7>] xen_call_function_interrupt+0xe/0x167
 [<ffffffff810747c5>] handle_IRQ_event+0x2e/0x65
 [<ffffffff81075e5b>] handle_level_irq+0xb5/0x116
 [<ffffffff81013f34>] do_IRQ+0xf7/0x177
 [<ffffffff811ba227>] xen_evtchn_do_upcall+0xb3/0x136
 [<ffffffff8141558e>] xen_do_hypervisor_callback+0x1e/0x30
 <EOI>  [<ffffffff810093aa>] ? _stext+0x3aa/0x1000
 [<ffffffff810093aa>] ? _stext+0x3aa/0x1000
 [<ffffffff8100a42e>] ? xen_safe_halt+0x10/0x1a
 [<ffffffff8100ba26>] ? xen_idle+0x46/0x5c
 [<ffffffff8100eb60>] ? cpu_idle+0xca/0x101
 [<ffffffff8140bc7d>] ? cpu_bringup_and_idle+0x8a/0x8f


Code: e8 fc 96 fc ff 90 41 f6 44 24 20 01 74 08 41 83 64 24 20 fe eb 11 49 8d 7c 24 38 48 c7 c6 90 dd 05 81 e8 6f 92 01 00 4d 8b 24 24 <49> 8b 04 24 49 81 fc e0 e6 5f 81 0f 18 08 0f 85 11 ff ff ff 5b 
RIP  [<ffffffff8105de9a>] generic_smp_call_function_interrupt+0xfb/0x118
 RSP <ffff88007f653e98>
CR2: 0000000000000000
Kernel panic - not syncing: Fatal exception in interrupt


They're pretty rare - this system did a kernbench run on a 16 vcpu 
system with no problems, then oopsed this way when I left it idle overnight.

One interesting data point is that I've been experimenting with more 
virtualization-friendly spinlock algorithms.  If I replace ticket locks 
with the old lock-byte algorithm, I see this much more frequently (and a 
spin-and-block algorithm generally doesn't get through boot).  I wonder 
if there's a race which is masked by ticket locks' strict FIFO 
algorithm?  (But this particular oops was with completely standard 
ticketlocks in place.)

I've been running your old generic IPI patches for a while with no 
problems; this seems to be specific to the version in tip.git.  I 
haven't looked to see what differences there are yet.

I've also only observed problems under Xen, but I haven't done much 
testing on real hardware.

Thanks,
    J
