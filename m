Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbXFNQFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbXFNQFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbXFNQE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:04:56 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:36119 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbXFNQEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:04:55 -0400
To: mingo@elte.hu
CC: chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de
In-reply-to: <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Fri, 25 May 2007 11:51:29 +0200)
Subject: Re: [BUG] long freezes on thinkpad t60
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu> <20070524125453.GA7554@elte.hu> <E1HrDuQ-0005m7-00@dorka.pomaz.szeredi.hu> <20070524141059.GA19872@elte.hu> <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu> <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu> <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Jun 2007 18:04:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've got some more info about this bug.  It is gathered with
nmi_watchdog=2 and a modified nmi_watchdog_tick(), which instead of
calling die_nmi() just prints a line and calls show_registers().

This makes the machine actually survive the NMI tracing.  The attached
traces are gathered over about an hour of stressing.  An mp3 player is
also going on continually, and I can hear a couple of seconds of
"looping" quite often, but it gets as far as the NMI trace only
rarely.  AFAICS only the last pair shows a trace for both CPUs during
the same "freeze".

I've put some effort into understanding what's going on, but I'm not
familiar with how interrupts work and that sort of thing.

The pattern that emerges is that on CPU0 we have an interrupt, which
is trying to acquire the rq lock, but can't.

On CPU1 we have strace which is doing wait_task_inactive(), which sort
of spins acquiring and releasing the rq lock.  I've checked some of
the traces and it is just before acquiring the rq lock, or just after
releasing it, but is not actually holding it.

So is it possible that wait_task_inactive() could be starving the
other waiters of the rq spinlock?  Any ideas?

Thanks,
Miklos

NMI Watchdog detected LOCKUP on CPU 1
CPU 1 
Modules linked in: fuse e1000
Pid: 4625, comm: strace Not tainted 2.6.22-rc4 #10
RIP: 0010:[<ffffffff80227ce5>]  [<ffffffff80227ce5>] task_rq_lock+0x14/0x6f
RSP: 0018:ffff81001cf17ed8  EFLAGS: 00000046
RAX: 0000000000000246 RBX: ffff81001c9da540 RCX: ffff81003fd1e5e8
RDX: 0000000000000001 RSI: ffff81001cf17f10 RDI: ffff81001c9da540
RBP: ffff81001cf17ef8 R08: 0000000000000003 R09: 0000000000000000
R10: 00007fffbcd7c018 R11: 0000000000000246 R12: ffff81001c9da540
R13: ffff81001cf17f10 R14: ffff81001c9da540 R15: 00007fffbcd7d44c
FS:  00002b05ee28a6f0(0000) GS:ffff810001fd8ec0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002aaaac02f000 CR3: 000000001ce52000 CR4: 00000000000006e0
Process strace (pid: 4625, threadinfo ffff81001cf16000, task ffff810037d35860)
Stack:  ffff81001c9da540 ffff81001c9da540 00007fffbcd7c018 0000000000000078
 ffff81001cf17f28 ffffffff8022c252 ffff810037d35860 0000000000000246
 ffff81001c9da540 0000000000000000 0000000000000000 ffffffff802365e3
Call Trace:
 [<ffffffff8022c252>] wait_task_inactive+0x1a/0x5f
 [<ffffffff802365e3>] ptrace_check_attach+0xaf/0xb6
 [<ffffffff8023664c>] sys_ptrace+0x62/0xa2
 [<ffffffff8020954e>] system_call+0x7e/0x83


Code: 49 89 45 00 49 8b 46 08 48 c7 c3 40 a6 5e 80 49 89 dc 8b 40 
NMI Watchdog detected LOCKUP on CPU 1
CPU 1 
Modules linked in: fuse e1000
Pid: 4625, comm: strace Not tainted 2.6.22-rc4 #10
RIP: 0010:[<ffffffff8043bb1b>]  [<ffffffff8043bb1b>] _spin_unlock_irqrestore+0x8/0x9
RSP: 0018:ffff81001cf17f00  EFLAGS: 00000246
RAX: 0000000000000001 RBX: ffff81001c9dabe0 RCX: ffff81003fdabee8
RDX: 0000000000000001 RSI: 0000000000000246 RDI: ffff810001e0e640
RBP: ffff81001cf17f28 R08: 0000000000000003 R09: 0000000000000000
R10: 00007fffbcd7c018 R11: 0000000000000246 R12: ffff81001c9dabe0
R13: 00007fffbcd7c018 R14: 0000000000000078 R15: 00007fffbcd7d44c
FS:  00002b05ee28a6f0(0000) GS:ffff810001fd8ec0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b9e0d9c4000 CR3: 000000001ce52000 CR4: 00000000000006e0
Process strace (pid: 4625, threadinfo ffff81001cf16000, task ffff810037d35860)
Stack:  ffffffff8022c27c ffff810037d35860 0000000000000246 ffff81001c9dabe0
 0000000000000000 0000000000000000 ffffffff802365e3 ffff81001c9dabe0
 ffff81001c9dabe0 0000000000000003 ffffffff8023664c 00002b05ee28a690
Call Trace:
 [<ffffffff8022c27c>] wait_task_inactive+0x44/0x5f
 [<ffffffff802365e3>] ptrace_check_attach+0xaf/0xb6
 [<ffffffff8023664c>] sys_ptrace+0x62/0xa2
 [<ffffffff8020954e>] system_call+0x7e/0x83


Code: c3 c7 07 01 00 00 00 fb c3 f0 83 2f 01 79 05 e8 51 41 ea ff 
NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: fuse e1000
Pid: 4663, comm: fusexmp_fh Not tainted 2.6.22-rc4 #10
RIP: 0010:[<ffffffff8043ba34>]  [<ffffffff8043ba34>] _spin_lock+0xa/0xf
RSP: 0018:ffffffff805f2d98  EFLAGS: 00000046
RAX: ffffffff805a2000 RBX: ffffffff805ea640 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff805f2e00 RDI: ffff810001e0e640
RBP: ffffffff805f2dc0 R08: ffff81003fe2ff08 R09: ffffffff803cac69
R10: 0000000000000282 R11: 0000000000000000 R12: ffff810001e0e640
R13: ffffffff805f2e00 R14: ffff81003fe00e00 R15: 0000000000000000
FS:  0000000042804940(0063) GS:ffffffff805a2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b9e0dc00000 CR3: 000000001ce65000 CR4: 00000000000006e0
Process fusexmp_fh (pid: 4663, threadinfo ffff81001ca86000, task ffff81003f1cb520)
Stack:  ffffffff80227d0e 0000000000000003 0000000000000001 ffff81003fe00e00
 ffff810001fd8e58 ffffffff805f2e30 ffffffff80229c58 ffffffff805f2ec0
 0000000000000000 0000001100000011 ffffffff803cac69 0000000000000000
Call Trace:
 <IRQ>  [<ffffffff80227d0e>] task_rq_lock+0x3d/0x6f
 [<ffffffff80229c58>] try_to_wake_up+0x24/0x362
 [<ffffffff803cac69>] azx_interrupt+0x76/0xc3
 [<ffffffff8024071d>] autoremove_wake_function+0x9/0x2e
 [<ffffffff802276e3>] __wake_up_common+0x3e/0x68
 [<ffffffff80227c7d>] __wake_up+0x38/0x4f
 [<ffffffff8023d621>] __queue_work+0x23/0x33
 [<ffffffff802f422b>] cursor_timer_handler+0x0/0x2c
 [<ffffffff8023d68d>] queue_work+0x37/0x40
 [<ffffffff802f423f>] cursor_timer_handler+0x14/0x2c
 [<ffffffff80236e2d>] run_timer_softirq+0x130/0x19f
 [<ffffffff80233d7e>] __do_softirq+0x55/0xc3
 [<ffffffff8020a6dc>] call_softirq+0x1c/0x28
 [<ffffffff8020c05b>] do_softirq+0x2c/0x7d
 [<ffffffff8020c162>] do_IRQ+0xb6/0xd4
 [<ffffffff80209a61>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802386ac>] ptrace_stop+0x170/0x172
 [<ffffffff80210d79>] sched_clock+0x0/0x1a
 [<ffffffff80439a36>] __sched_text_start+0xce/0x76b
 [<ffffffff80240714>] autoremove_wake_function+0x0/0x2e
 [<ffffffff802386ac>] ptrace_stop+0x170/0x172
 [<ffffffff802398cf>] ptrace_notify+0x71/0x96
 [<ffffffff8020c479>] syscall_trace+0x26/0x5d
 [<ffffffff80273550>] sys_read+0x60/0x6e
 [<ffffffff8020974b>] int_very_careful+0x35/0x3e


Code: 7e f9 eb f2 c3 f0 81 2f 00 00 00 01 74 05 e8 19 42 ea ff c3 
NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: fuse e1000
Pid: 4628, comm: fusexmp_fh Not tainted 2.6.22-rc4 #10
RIP: 0010:[<ffffffff8043bae1>]  [<ffffffff8043bae1>] _spin_lock_irq+0xb/0x10
RSP: 0018:ffff81001c861dd8  EFLAGS: 00000046
RAX: 000000000000000a RBX: 0000000000000000 RCX: 00000000000000fa
RDX: 0000000000000000 RSI: ffff81001cf64b20 RDI: ffff810001e0e640
RBP: ffff81001c861e80 R08: ffff8100373ff410 R09: ffff81001c861ea0
R10: 0000000000000008 R11: ffff81001c861bc8 R12: 0000000000604030
R13: 00000000408008e0 R14: ffff810001e0e640 R15: 0000000000021000
FS:  0000000040800940(0063) GS:ffffffff805a2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b9e107a7000 CR3: 000000001ce65000 CR4: 00000000000006e0
Process fusexmp_fh (pid: 4628, threadinfo ffff81001c860000, task ffff81001cf64b20)
Stack:  ffffffff80439ab2 0000000000000011 0000000000040004 0000000000001214
 000000000000000a ffff81001cf64b20 0000000000001154 000000f385ef0145
 0000000000001565 0000000000000000 0000000000000000 ffff81001cf64b20
Call Trace:
 [<ffffffff80439ab2>] __sched_text_start+0x14a/0x76b
 [<ffffffff80240714>] autoremove_wake_function+0x0/0x2e
 [<ffffffff802386ac>] ptrace_stop+0x170/0x172
 [<ffffffff802398cf>] ptrace_notify+0x71/0x96
 [<ffffffff8020c479>] syscall_trace+0x26/0x5d
 [<ffffffff80273550>] sys_read+0x60/0x6e
 [<ffffffff8020974b>] int_very_careful+0x35/0x3e


Code: 7e f9 eb f2 c3 53 48 89 fb e8 4b 84 df ff f0 ff 0b 79 09 f3 
NMI Watchdog detected LOCKUP on CPU 1
CPU 1 
Modules linked in: fuse e1000
Pid: 4805, comm: strace Not tainted 2.6.22-rc4 #10
RIP: 0010:[<ffffffff80227ce5>]  [<ffffffff80227ce5>] task_rq_lock+0x14/0x6f
RSP: 0018:ffff81003b477ed8  EFLAGS: 00000046
RAX: 0000000000000246 RBX: ffff81000afbd6a0 RCX: ffff81003f420f28
RDX: 0000000000000001 RSI: ffff81003b477f10 RDI: ffff81000afbd6a0
RBP: ffff81003b477ef8 R08: 0000000000000003 R09: 0000000000000000
R10: 00007fff64f0c038 R11: 0000000000000246 R12: ffff81000afbd6a0
R13: ffff81003b477f10 R14: ffff81000afbd6a0 R15: 00007fff64f0d46c
FS:  00002b55460fa6f0(0000) GS:ffff810001fd8ec0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b27b874c000 CR3: 0000000037140000 CR4: 00000000000006e0
Process strace (pid: 4805, threadinfo ffff81003b476000, task ffff810037d35860)
Stack:  ffff81000afbd6a0 ffff81000afbd6a0 00007fff64f0c038 0000000000000078
 ffff81003b477f28 ffffffff8022c252 ffff810037d35860 0000000000000246
 ffff81000afbd6a0 0000000000000000 0000000000000000 ffffffff802365e3
Call Trace:
 [<ffffffff8022c252>] wait_task_inactive+0x1a/0x5f
 [<ffffffff802365e3>] ptrace_check_attach+0xaf/0xb6
 [<ffffffff8023664c>] sys_ptrace+0x62/0xa2
 [<ffffffff8020954e>] system_call+0x7e/0x83


Code: 49 89 45 00 49 8b 46 08 48 c7 c3 40 a6 5e 80 49 89 dc 8b 40 
NMI Watchdog detected LOCKUP on CPU 1
CPU 1 
Modules linked in: fuse e1000
Pid: 4929, comm: strace Not tainted 2.6.22-rc4 #10
RIP: 0010:[<ffffffff80227ce5>]  [<ffffffff80227ce5>] task_rq_lock+0x14/0x6f
RSP: 0018:ffff810008b11ed8  EFLAGS: 00000046
RAX: 0000000000000246 RBX: ffff810036b65620 RCX: ffff81003f613ca8
RDX: 0000000000000001 RSI: ffff810008b11f10 RDI: ffff810036b65620
RBP: ffff810008b11ef8 R08: 0000000000000003 R09: 0000000000000000
R10: 00007ffff9c16a78 R11: 0000000000000246 R12: ffff810036b65620
R13: ffff810008b11f10 R14: ffff810036b65620 R15: 00007ffff9c17eac
FS:  00002b87b13f16f0(0000) GS:ffff810001fd8ec0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002ac368d9c000 CR3: 0000000005a4a000 CR4: 00000000000006e0
Process strace (pid: 4929, threadinfo ffff810008b10000, task ffff810037d35860)
Stack:  ffff810036b65620 ffff810036b65620 00007ffff9c16a78 0000000000000078
 ffff810008b11f28 ffffffff8022c252 ffff810037d35860 0000000000000246
 ffff810036b65620 0000000000000000 0000000000000000 ffffffff802365e3
Call Trace:
 [<ffffffff8022c252>] wait_task_inactive+0x1a/0x5f
 [<ffffffff802365e3>] ptrace_check_attach+0xaf/0xb6
 [<ffffffff8023664c>] sys_ptrace+0x62/0xa2
 [<ffffffff8020954e>] system_call+0x7e/0x83


Code: 49 89 45 00 49 8b 46 08 48 c7 c3 40 a6 5e 80 49 89 dc 8b 40 
NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: fuse e1000
Pid: 4936, comm: fusexmp_fh Not tainted 2.6.22-rc4 #10
RIP: 0010:[<ffffffff8043ba34>]  [<ffffffff8043ba34>] _spin_lock+0xa/0xf
RSP: 0018:ffffffff805f2d20  EFLAGS: 00000046
RAX: ffffffff805a2000 RBX: ffffffff805ea640 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff805f2d88 RDI: ffff810001e0e640
RBP: ffffffff805f2d48 R08: ffff810016fc5bf0 R09: ffff81003f595fe0
R10: ffff81003f122200 R11: ffffffff803625b7 R12: ffff810001e0e640
R13: ffffffff805f2d88 R14: ffff81001cfab760 R15: 0000000000000000
FS:  0000000042003940(0063) GS:ffffffff805a2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000001cbc038 CR3: 0000000003cc0000 CR4: 00000000000006e0
Process fusexmp_fh (pid: 4936, threadinfo ffff8100120a6000, task ffff81001cf64480)
Stack:  ffffffff80227d0e 0000000000000003 0000000000000001 ffff81001cfab760
 ffff810034577f68 ffffffff805f2db8 ffffffff80229c58 0000000000000001
 0000000000000282 0000000000000003 ffffffff805f2db0 ffffffff80227c7d
Call Trace:
 <IRQ>  [<ffffffff80227d0e>] task_rq_lock+0x3d/0x6f
 [<ffffffff80229c58>] try_to_wake_up+0x24/0x362
 [<ffffffff80227c7d>] __wake_up+0x38/0x4f
 [<ffffffff80237103>] lock_timer_base+0x26/0x4b
 [<ffffffff802276e3>] __wake_up_common+0x3e/0x68
 [<ffffffff80227c7d>] __wake_up+0x38/0x4f
 [<ffffffff802d3e4d>] blk_run_queue+0x28/0x73
 [<ffffffff803b69e3>] snd_timer_user_tinterrupt+0x13c/0x147
 [<ffffffff803b5104>] snd_timer_interrupt+0x264/0x2d4
 [<ffffffff803bf0d7>] snd_pcm_period_elapsed+0x21a/0x283
 [<ffffffff803cac61>] azx_interrupt+0x6e/0xc3
 [<ffffffff80252710>] handle_IRQ_event+0x25/0x53
 [<ffffffff80233d7e>] __do_softirq+0x55/0xc3
 [<ffffffff80253bbf>] handle_fasteoi_irq+0x94/0xd1
 [<ffffffff8020a6dc>] call_softirq+0x1c/0x28
 [<ffffffff8020c118>] do_IRQ+0x6c/0xd4
 [<ffffffff80209a61>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802385af>] ptrace_stop+0x73/0x172
 [<ffffffff802398cf>] ptrace_notify+0x71/0x96
 [<ffffffff8020c479>] syscall_trace+0x26/0x5d
 [<ffffffff80273550>] sys_read+0x60/0x6e
 [<ffffffff8020974b>] int_very_careful+0x35/0x3e


Code: 7e f9 eb f2 c3 f0 81 2f 00 00 00 01 74 05 e8 19 42 ea ff c3 
NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: fuse e1000
Pid: 4933, comm: fusexmp_fh Not tainted 2.6.22-rc4 #10
RIP: 0010:[<ffffffff8043ba34>]  [<ffffffff8043ba34>] _spin_lock+0xa/0xf
RSP: 0018:ffffffff805f2bd0  EFLAGS: 00000046
RAX: ffffffff805a2000 RBX: ffffffff805ea640 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff805f2c38 RDI: ffff810001e0e640
RBP: ffffffff805f2bf8 R08: ffff81003fe2ff08 R09: ffffffff805ea640
R10: ffff810081824000 R11: ffffffff8021a502 R12: ffff810001e0e640
R13: ffffffff805f2c38 R14: ffff81003fe00e00 R15: 0000000000000000
FS:  0000000041001940(0063) GS:ffffffff805a2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002aaab0190718 CR3: 0000000003cc0000 CR4: 00000000000006e0
Process fusexmp_fh (pid: 4933, threadinfo ffff81000ae20000, task ffff81001cf64b20)
Stack:  ffffffff80227d0e 0000000000000003 0000000000000001 ffff81003fe00e00
 ffff810001fd8e58 ffffffff805f2c68 ffffffff80229c58 0000000000000282
 000000003f580500 0000000000000286 ffff810017f5a240 ffff810017f5a29c
Call Trace:
 <IRQ>  [<ffffffff80227d0e>] task_rq_lock+0x3d/0x6f
 [<ffffffff80229c58>] try_to_wake_up+0x24/0x362
 [<ffffffff803618f9>] scsi_delete_timer+0xd/0x25
 [<ffffffff8024071d>] autoremove_wake_function+0x9/0x2e
 [<ffffffff802276e3>] __wake_up_common+0x3e/0x68
 [<ffffffff80227c7d>] __wake_up+0x38/0x4f
 [<ffffffff8023d621>] __queue_work+0x23/0x33
 [<ffffffff8023d68d>] queue_work+0x37/0x40
 [<ffffffff8039b980>] input_event+0x422/0x44a
 [<ffffffff803a01a5>] atkbd_interrupt+0x248/0x503
 [<ffffffff8020c162>] do_IRQ+0xb6/0xd4
 [<ffffffff8039882a>] serio_interrupt+0x37/0x6f
 [<ffffffff80399473>] i8042_interrupt+0x1f4/0x20a
 [<ffffffff80252710>] handle_IRQ_event+0x25/0x53
 [<ffffffff80253ce0>] handle_edge_irq+0xe4/0x128
 [<ffffffff8020c118>] do_IRQ+0x6c/0xd4
 [<ffffffff80209a61>] ret_from_intr+0x0/0xa
 [<ffffffff8021a502>] flat_send_IPI_mask+0x0/0x4c
 [<ffffffff80233d73>] __do_softirq+0x4a/0xc3
 [<ffffffff8020a6dc>] call_softirq+0x1c/0x28
 [<ffffffff8020c05b>] do_softirq+0x2c/0x7d
 [<ffffffff8020c162>] do_IRQ+0xb6/0xd4
 [<ffffffff80209a61>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802386ac>] ptrace_stop+0x170/0x172
 [<ffffffff804399f1>] __sched_text_start+0x89/0x76b
 [<ffffffff80240714>] autoremove_wake_function+0x0/0x2e
 [<ffffffff802386ac>] ptrace_stop+0x170/0x172
 [<ffffffff802398cf>] ptrace_notify+0x71/0x96
 [<ffffffff8020c479>] syscall_trace+0x26/0x5d
 [<ffffffff80273550>] sys_read+0x60/0x6e
 [<ffffffff8020974b>] int_very_careful+0x35/0x3e


Code: 7e f9 eb f2 c3 f0 81 2f 00 00 00 01 74 05 e8 19 42 ea ff c3 
NMI Watchdog detected LOCKUP on CPU 0
CPU 0 
Modules linked in: fuse e1000
Pid: 4936, comm: fusexmp_fh Not tainted 2.6.22-rc4 #10
RIP: 0010:[<ffffffff8043bae1>]  [<ffffffff8043bae1>] _spin_lock_irq+0xb/0x10
RSP: 0018:ffff8100120a7dd8  EFLAGS: 00000046
RAX: 000000000000000a RBX: 0000000000000000 RCX: 00000000000000fa
RDX: 0000000000000000 RSI: ffff81001cf64480 RDI: ffff810001e0e640
RBP: ffff8100120a7e80 R08: ffff8100373ff410 R09: ffff8100120a7ea0
R10: 0000000000000005 R11: ffff8100120a7bc8 R12: 0000000000604030
R13: 00000000420038e0 R14: ffff810001e0e640 R15: 0000000000021000
FS:  0000000042003940(0063) GS:ffffffff805a2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002aaab046d978 CR3: 0000000003cc0000 CR4: 00000000000006e0
Process fusexmp_fh (pid: 4936, threadinfo ffff8100120a6000, task ffff81001cf64480)
Stack:  ffffffff80439ab2 0000000000000011 0000000000040004 0000000000001348
 000000000000000a ffff81001cf64480 00000000000007d4 000002b1f9fb8559
 000000000000910f 0000000000000005 ffff8100120a7ea0 0000000000000000
Call Trace:
 [<ffffffff80439ab2>] __sched_text_start+0x14a/0x76b
 [<ffffffff802386ac>] ptrace_stop+0x170/0x172
 [<ffffffff802398cf>] ptrace_notify+0x71/0x96
 [<ffffffff8020c479>] syscall_trace+0x26/0x5d
 [<ffffffff80273550>] sys_read+0x60/0x6e
 [<ffffffff8020974b>] int_very_careful+0x35/0x3e


Code: 7e f9 eb f2 c3 53 48 89 fb e8 4b 84 df ff f0 ff 0b 79 09 f3 
NMI Watchdog detected LOCKUP on CPU 0
NMI Watchdog detected LOCKUP on CPU 1
CPU 0 
Modules linked in: fuse e1000
Pid: 4937, comm: fusexmp_fh Not tainted 2.6.22-rc4 #10
RIP: 0010:[<ffffffff8043ba34>]  [<ffffffff8043ba34>] _spin_lock+0xa/0xf
RSP: 0018:ffffffff805f2bd0  EFLAGS: 00000046
RAX: ffffffff805a2000 RBX: ffffffff805ea640 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff805f2c38 RDI: ffff810001e0e640
RBP: ffffffff805f2bf8 R08: ffff81003fe2ff08 R09: ffffffff805ea640
R10: ffff810081824000 R11: ffffffff8021a502 R12: ffff810001e0e640
R13: ffffffff805f2c38 R14: ffff81003fe00e00 R15: 0000000000000000
FS:  0000000042804940(0063) GS:ffffffff805a2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002ac36f0b2000 CR3: 0000000003cc0000 CR4: 00000000000006e0
Process fusexmp_fh (pid: 4937, threadinfo ffff8100255a8000, task ffff810036b65620)
Stack:  ffffffff80227d0e 0000000000000003 0000000000000001 ffff81003fe00e00
 ffff810001fd8e58 ffffffff805f2c68 ffffffff80229c58 ffffffff805f2c58
 0000000000000001 0000000000000086 0000000042803fc0 0000000000000092
Call Trace:
 <IRQ>  [<ffffffff80227d0e>] task_rq_lock+0x3d/0x6f
 [<ffffffff80229c58>] try_to_wake_up+0x24/0x362
 [<ffffffff803b69e3>] snd_timer_user_tinterrupt+0x13c/0x147
 [<ffffffff8024071d>] autoremove_wake_function+0x9/0x2e
 [<ffffffff802276e3>] __wake_up_common+0x3e/0x68
 [<ffffffff80227c7d>] __wake_up+0x38/0x4f
 [<ffffffff8023d621>] __queue_work+0x23/0x33
 [<ffffffff8023d68d>] queue_work+0x37/0x40
 [<ffffffff8039b980>] input_event+0x422/0x44a
 [<ffffffff803a01a5>] atkbd_interrupt+0x248/0x503
 [<ffffffff8020c162>] do_IRQ+0xb6/0xd4
 [<ffffffff8039882a>] serio_interrupt+0x37/0x6f
 [<ffffffff80399473>] i8042_interrupt+0x1f4/0x20a
 [<ffffffff80252710>] handle_IRQ_event+0x25/0x53
 [<ffffffff80253ce0>] handle_edge_irq+0xe4/0x128
 [<ffffffff8020c118>] do_IRQ+0x6c/0xd4
 [<ffffffff80209a61>] ret_from_intr+0x0/0xa
 [<ffffffff8021a502>] flat_send_IPI_mask+0x0/0x4c
 [<ffffffff80233d73>] __do_softirq+0x4a/0xc3
 [<ffffffff8020a6dc>] call_softirq+0x1c/0x28
 [<ffffffff8020c05b>] do_softirq+0x2c/0x7d
 [<ffffffff8020c162>] do_IRQ+0xb6/0xd4
 [<ffffffff80209a61>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802385af>] ptrace_stop+0x73/0x172
 [<ffffffff802398cf>] ptrace_notify+0x71/0x96
 [<ffffffff8020c479>] syscall_trace+0x26/0x5d
 [<ffffffff8020974b>] int_very_careful+0x35/0x3e


Code: 7e f9 eb f2 c3 f0 81 2f 00 00 00 01 74 05 e8 19 42 ea ff c3 
CPU 1 
Modules linked in: fuse e1000
Pid: 4929, comm: strace Not tainted 2.6.22-rc4 #10
RIP: 0010:[<ffffffff8043bb1b>]  [<ffffffff8043bb1b>] _spin_unlock_irqrestore+0x8/0x9
RSP: 0018:ffff810008b11f00  EFLAGS: 00000246
RAX: 0000000000000001 RBX: ffff810036b65620 RCX: ffff81003f613ca8
RDX: 0000000000000001 RSI: 0000000000000246 RDI: ffff810001e0e640
RBP: ffff810008b11f28 R08: 0000000000000003 R09: 0000000000000000
R10: 00007ffff9c16a78 R11: 0000000000000246 R12: ffff810036b65620
R13: 00007ffff9c16a78 R14: 0000000000000078 R15: 00007ffff9c17eac
FS:  00002b87b13f16f0(0000) GS:ffff810001fd8ec0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002adb2c3cf000 CR3: 0000000005a4a000 CR4: 00000000000006e0
Process strace (pid: 4929, threadinfo ffff810008b10000, task ffff810037d35860)
Stack:  ffffffff8022c27c ffff810037d35860 0000000000000246 ffff810036b65620
 0000000000000000 0000000000000000 ffffffff802365e3 ffff810036b65620
 ffff810036b65620 0000000000000003 ffffffff8023664c 00002b87b13f1690
Call Trace:
 [<ffffffff8022c27c>] wait_task_inactive+0x44/0x5f
 [<ffffffff802365e3>] ptrace_check_attach+0xaf/0xb6
 [<ffffffff8023664c>] sys_ptrace+0x62/0xa2
 [<ffffffff8020954e>] system_call+0x7e/0x83


Code: c3 c7 07 01 00 00 00 fb c3 f0 83 2f 01 79 05 e8 51 41 ea ff 
