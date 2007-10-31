Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbXJaJ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbXJaJ7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbXJaJ7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:59:07 -0400
Received: from mga05.intel.com ([192.55.52.89]:26586 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752539AbXJaJ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:59:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,351,1188802800"; 
   d="scan'208";a="364131025"
Subject: Re: aim7 -30% regression in 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1193733390.3019.210.camel@ymzhang>
References: <1193391787.3019.174.camel@ymzhang>
	 <20071026112307.GA30406@elte.hu> <1193624538.3019.189.camel@ymzhang>
	 <1193650626.3019.198.camel@ymzhang> <1193710325.3019.203.camel@ymzhang>
	 <20071030072658.GB20372@elte.hu>  <1193733390.3019.210.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Wed, 31 Oct 2007 17:57:48 +0800
Message-Id: <1193824668.3019.236.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 16:36 +0800, Zhang, Yanmin wrote:
> On Tue, 2007-10-30 at 08:26 +0100, Ingo Molnar wrote:
> > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > 
> > > sub-bisecting captured patch 
> > > 38ad464d410dadceda1563f36bdb0be7fe4c8938(sched: uniform tunings) 
> > > caused 20% regression of aim7.
> > > 
> > > The last 10% should be also related to sched parameters, such like 
> > > sysctl_sched_min_granularity.
> > 
> > ah, interesting. Since you have CONFIG_SCHED_DEBUG enabled, could you 
> > please try to figure out what the best value for 
> > /proc/sys/kernel_sched_latency, /proc/sys/kernel_sched_nr_latency and 
> > /proc/sys/kernel_sched_min_granularity is?
> > 
> > there's a tuning constraint for kernel_sched_nr_latency: 
> > 
> > - kernel_sched_nr_latency should always be set to 
> >   kernel_sched_latency/kernel_sched_min_granularity. (it's not a free 
> >   tunable)
> > 
> > i suspect a good approach would be to double the value of 
> > kernel_sched_latency and kernel_sched_nr_latency in each tuning 
> > iteration, while keeping kernel_sched_min_granularity unchanged. That 
> > will excercise the tuning values of the 2.6.23 kernel as well.
> I followed your idea to test 2.6.24-rc1. The improvement is slow.
> When sched_nr_latency=2560 and sched_latency_ns=640000000, the performance
> is still about 15% less than 2.6.23.

I got the aim7 30% regression on my new upgraded stoakley machine. I found
this mahcine is slower than the old one. Maybe BIOS has issues, or memeory(Might not
be dual-channel?) is slow. So I retested it on the old machine and found on the old
stoakley machine, the regression is about 6%, quite similiar to the regression on tigerton
machine.

By sched_nr_latency=640 and sched_latency_ns=640000000 on the old stoakley machine,
the regression becomes about 2%. Other latency has more regression.

On my tulsa machine, by sched_nr_latency=640 and sched_latency_ns=640000000,
the regression becomes less than 1% (The original regression is about 20%).

When I ran a bad script to change the values of sched_nr_latency and sched_latency_ns,
I hit OOPS on my tulsa machine. Below is the log. It looks like sched_nr_latency becomes
0.


*******************Log************************************

divide error: 0000 [1] SMP 
CPU 1 
Modules linked in: megaraid_mbox megaraid_mm
Pid: 7326, comm: sh Not tainted 2.6.24-rc1 #2
RIP: 0010:[<ffffffff8022c2bf>]  [<ffffffff8022c2bf>] __sched_period+0x22/0x2e
RSP: 0018:ffff810105909e38  EFLAGS: 00010046
RAX: 000000005a000000 RBX: 0000000000000000 RCX: 000000002d000000
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
RBP: ffff810105909e40 R08: ffff810103bfed50 R09: 00000000ffffffff
R10: 0000000000000038 R11: 0000000000000296 R12: ffff810100d6db40
R13: ffff8101058c4148 R14: 0000000000000001 R15: ffff810104c34088
FS:  00002b851bc59f50(0000) GS:ffff810100cb1b40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000006c64d8 CR3: 000000010752c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sh (pid: 7326, threadinfo ffff810105908000, task ffff810104c34040)
Stack:  0000000000000800 ffff810105909e58 ffffffff8022c2db 00000000079d292b
 ffff810105909e88 ffffffff8022c36e ffff810100d6db40 ffff8101058c4148
 ffff8101058c4100 0000000000000001 ffff810105909ec8 ffffffff80232d0a
Call Trace:
 [<ffffffff8022c2db>] __sched_vslice+0x10/0x1d
 [<ffffffff8022c36e>] place_entity+0x86/0xc3
 [<ffffffff80232d0a>] task_new_fair+0x48/0xa5
 [<ffffffff8020b63e>] system_call+0x7e/0x83
 [<ffffffff80233325>] wake_up_new_task+0x70/0xa4
 [<ffffffff80235612>] do_fork+0x137/0x204
 [<ffffffff802818bd>] vfs_write+0x121/0x136
 [<ffffffff8023f017>] recalc_sigpending+0xe/0x25
 [<ffffffff8023f0ef>] sigprocmask+0x9e/0xc0
 [<ffffffff8020b957>] ptregscall_common+0x67/0xb0


Code: 48 f7 f3 48 89 c1 5b c9 48 89 c8 c3 55 48 89 e5 53 48 89 fb 
RIP  [<ffffffff8022c2bf>] __sched_period+0x22/0x2e
 RSP <ffff810105909e38>
divide error: 0000 [2] SMP 
CPU 0 
Modules linked in: megaraid_mbox megaraid_mm
Pid: 3674, comm: automount Tainted: G      D 2.6.24-rc1 #2
RIP: 0010:[<ffffffff8022c2bf>]  [<ffffffff8022c2bf>] __sched_period+0x22/0x2e
RSP: 0018:ffff81010690de38  EFLAGS: 00010046
RAX: 000000005a000000 RBX: 0000000000000000 RCX: 000000002d000000
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
RBP: ffff81010690de40 R08: ffff81010690c000 R09: 00000000ffffffff
R10: 0000000000000038 R11: ffff810104007040 R12: ffff810001033880
R13: ffff810100f2a828 R14: 0000000000000001 R15: ffff810104007088
FS:  0000000040021950(0063) GS:ffffffff8074e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b6cc4245000 CR3: 0000000105972000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process automount (pid: 3674, threadinfo ffff81010690c000, task ffff810104007040)
Stack:  0000000000000800 ffff81010690de58 ffffffff8022c2db 000000057aef240d
 ffff81010690de88 ffffffff8022c36e ffff810001033880 ffff810100f2a828
 ffff810100f2a7e0 0000000000000000 ffff81010690dec8 ffffffff80232d0a
Call Trace:
 [<ffffffff8022c2db>] __sched_vslice+0x10/0x1d
 [<ffffffff8022c36e>] place_entity+0x86/0xc3
 [<ffffffff80232d0a>] task_new_fair+0x48/0xa5
 [<ffffffff8020b63e>] system_call+0x7e/0x83
 [<ffffffff80233325>] wake_up_new_task+0x70/0xa4
 [<ffffffff80235612>] do_fork+0x137/0x204
 [<ffffffff8020b957>] ptregscall_common+0x67/0xb0


Code: 48 f7 f3 48 89 c1 5b c9 48 89 c8 c3 55 48 89 e5 53 48 89 fb 
RIP  [<ffffffff8022c2bf>] __sched_period+0x22/0x2e
 RSP <ffff81010690de38>

