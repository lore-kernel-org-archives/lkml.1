Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbZADVOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbZADVOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZADVOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:14:41 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54800 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZADVOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:14:40 -0500
Date: Sun, 4 Jan 2009 13:14:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, dhaval@linux.vnet.ibm.com,
       jens.axboe@oracle.com, mingo@elte.hu, andi@firstfloor.org,
       akpm@linux-foundation.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       rostedt@goodmis.org, tglx@linutronix.de, manfred@colorfullife.com
Subject: Re: [PATCH] Make treercu safe for suspend and resume
Message-ID: <20090104211438.GT6958@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090104194111.GA16398@linux.vnet.ibm.com> <20090104204108.GA16467@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104204108.GA16467@alice>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 09:41:08PM +0100, Eric Sesterhenn wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > Hello!
> > 
> > Kudos to both Dhaval Giani and Jens Axboe for finding a bug in treercu
> > that causes warnings after suspend-resume cycles in Dhaval's case and
> > during stress tests in Jens's case.  It would also probably cause failures
> > if heavily stressed.  The solution, ironically enough, is to revert to
> > rcupreempt's code for initializing the dynticks state.  And the patch
> > even results in smaller code -- so what was I thinking???
> > 
> > This is 2.6.29 material, given that people really do suspend and resume
> > Linux these days.  ;-)
> 
> sadly even with this patch i still get this oops when doing
> modprobe rcutorture; sleep 2s; rmmod rcutorture

I would have been extremely surprised had that patch fixed this problem,
but thank you very much for trying it out!  What can I say, I worked on
the easy ones first.  ;-)

							Thanx, Paul

> [   74.413097] BUG: unable to handle kernel NULL pointer dereference at
> (null)
> [   74.413424] IP: [<(null)>] (null)
> [   74.413651] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [   74.413956] last sysfs file: /sys/block/ram9/range
> [   74.414039] Modules linked in: [last unloaded: rcutorture]
> [   74.414039] 
> [   74.414039] Pid: 4997, comm: rcu_torture_wri Tainted: G        W
> (2.6.28-05692-g7d3b56b-dirty #167) System Name
> [   74.414039] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
> [   74.414039] EIP is at 0x0
> [   74.414039] EAX: d0afd130 EBX: 00000000 ECX: c01612a6 EDX: 00000006
> [   74.414039] ESI: d0afd130 EDI: 0000001c EBP: c0b03fe0 ESP: c0b03fd4
> [   74.414039]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [   74.414039] Process rcu_torture_wri (pid: 4997, ti=c0b03000
> task=c98bce00 task.ti=c988b000)
> [   74.414039] Stack:
> [   74.414039]  c01612ad 00000200 00000001 c0b03ff8 c012aa97 0000000a
> c988beac 00000046
> [   74.414039]  c012aa28 c988bebc c01042c2
> [   74.414039] Call Trace:
> [   74.414039]  [<c01612ad>] ? rcu_process_callbacks+0x65/0x79
> [   74.414039]  [<c012aa97>] ? __do_softirq+0x6f/0xf6
> [   74.414039]  [<c012aa28>] ? __do_softirq+0x0/0xf6
> [   74.414039]  <IRQ> <0> [<c012a9a5>] ? irq_exit+0x40/0x7c
> [   74.414039]  [<c0110ce1>] ? smp_apic_timer_interrupt+0x68/0x73
> [   74.414039]  [<c0103521>] ? apic_timer_interrupt+0x2d/0x34
> [   74.414039]  [<c01219f7>] ? finish_task_switch+0x4d/0x8b
> [   74.414039]  [<c014007b>] ? tick_check_oneshot_change+0xb1/0xf9
> [   74.414039]  [<c07a091f>] ? _spin_unlock_irq+0x2d/0x47
> [   74.414039]  [<c01219f7>] ? finish_task_switch+0x4d/0x8b
> [   74.414039]  [<c01219aa>] ? finish_task_switch+0x0/0x8b
> [   74.414039]  [<c079e366>] ? schedule+0x404/0x450
> [   74.414039]  [<c079e582>] ? schedule_timeout+0x70/0x95
> [   74.414039]  [<c012e13a>] ? process_timeout+0x0/0xf
> [   74.414039]  [<c079e57d>] ? schedule_timeout+0x6b/0x95
> [   74.414039]  [<c079e5c0>] ?
> schedule_timeout_uninterruptible+0x19/0x1b
> [   74.414039]  [<c0136bcc>] ? kthread+0x3e/0x66
> [   74.414039]  [<c0136b8e>] ? kthread+0x0/0x66
> [   74.414039]  [<c0103643>] ? kernel_thread_helper+0x7/0x10
> [   74.414039] Code:  Bad EIP value.
> [   74.414039] EIP: [<00000000>] 0x0 SS:ESP 0068:c0b03fd4
> [   74.422275] ---[ end trace 4eaa2a86a8e2da22 ]---
> [   74.422406] Kernel panic - not syncing: Fatal exception in interrupt
> 
> Greetings Eric
