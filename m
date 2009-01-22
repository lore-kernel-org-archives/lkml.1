Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZAVW2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZAVW2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZAVW1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:27:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46217 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbZAVW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:27:37 -0500
Date: Thu, 22 Jan 2009 17:27:35 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: lockdep and preemptoff tracer are fighting again.
In-Reply-To: <1232658518.4739.3.camel@laptop>
Message-ID: <alpine.DEB.1.10.0901221714030.5838@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901221523400.5838@gandalf.stny.rr.com> <1232658518.4739.3.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 22 Jan 2009, Peter Zijlstra wrote:

> On Thu, 2009-01-22 at 15:40 -0500, Steven Rostedt wrote:
> > 
> > Hey guys, I can consistently hit this bug when running the preempt tracer:
> > 

[ shortened ]

> > ------------[ cut here ]------------
> > WARNING: at kernel/lockdep.c:2899 check_flags+0x154/0x18b()
> > Call Trace:
> >  [<ffffffff802699bf>] check_flags+0x154/0x18b
> >  [<ffffffff8026de66>] lock_acquire+0x41/0xa9
> >  [<ffffffff80543e27>] _spin_lock_irqsave+0x46/0x59
> >  [<ffffffff8029519c>] ring_buffer_reset_cpu+0x31/0x6b
> >  [<ffffffff80299ec6>] tracing_reset+0x46/0x9b
> >  [<ffffffff8029e33f>] trace_preempt_off+0x100/0x14d
> >  [<ffffffff80546df1>] add_preempt_count+0x12d/0x132
> >  [<ffffffff8024b44f>] __local_bh_disable+0xc0/0xf0
> >  [<ffffffff8024b491>] local_bh_disable+0x12/0x14
> >  [<ffffffff80543b95>] _spin_lock_bh+0x16/0x4c
> >  [<ffffffff804ab49a>] lock_sock_nested+0x28/0xe5
> >  [<ffffffff804eff87>] tcp_sendmsg+0x27/0xac2
> >  [<ffffffff804a82b0>] sock_aio_write+0x109/0x11d
> >  [<ffffffff802d8881>] do_sync_write+0xf0/0x137
> >  [<ffffffff802d921c>] vfs_write+0x103/0x17d
> >  [<ffffffff802d978f>] sys_write+0x4e/0x8c
> >  [<ffffffff8020c64b>] system_call_fastpath+0x16/0x1b
> > ---[ end trace 713cc9df66b54d6e ]---
> > 
> > 
> > The cause is simple. The following happens:
> > 

> > lock_acquire calls check_flags which performs this check:
> > 
> > 	if (!hardirq_count()) {
> > 		if (softirq_count())
> > 			DEBUG_LOCKS_WARN_ON(current->softirqs_enabled);
> > 		else
> > 			DEBUG_LOCKS_WARN_ON(!current->softirqs_enabled);
> > 	}
> > 


> 
> __local_bh_disable()
> {
> 	unsigned long flags;
> 
> 	raw_local_irq_save(flags);
> 
> 	/*
> 	 * comment explaining why add_preempt_count() doesn't work
> 	 */
> 	preempt_count() += SOFTIRQ_OFFSET;
> 	if (softirq_count() == SOFTIRQ_OFFSET)
> 		trace_softirqs_off(ip);
> 	if (preempt_count() == SOFTIRQ_OFFSET)
> 		trace_preempt_off(CALLER_ADDR0, ...);
> 	raw_local_irq_restore(flags);
> }

Almost ;-)

With the above I get:

------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2887 check_flags+0xba/0x18b()
Call Trace:
 [<ffffffff80245ee7>] warn_slowpath+0xd8/0xf7
 [<ffffffff802699a1>] check_flags+0xba/0x18b
 [<ffffffff8026dee2>] lock_acquire+0x41/0xa9
 [<ffffffff80543c3f>] _spin_lock_bh+0x40/0x4c
 [<ffffffff804ab51a>] lock_sock_nested+0x28/0xe5
 [<ffffffff804f0007>] tcp_sendmsg+0x27/0xac2
 [<ffffffff804a8330>] sock_aio_write+0x109/0x11d
 [<ffffffff802d88fd>] do_sync_write+0xf0/0x137
 [<ffffffff802d9298>] vfs_write+0x103/0x17d
 [<ffffffff802d980b>] sys_write+0x4e/0x8c
 [<ffffffff8020c64b>] system_call_fastpath+0x16/0x1b
---[ end trace 5057c94a6be2ce17 ]---

Which is hitting:

	if (irqs_disabled_flags(flags)) {
		if (DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)) {
			printk("possible reason: unannotated irqs-off.\n");
		}
	} else {


Which is caused by the "raw_local_irq_save(flags) in the local_bh_disable 
;-)


The solution is to move the "if (preempt_count() == SOFTIRQ_OFFSET)" 
outside the raw_local_irq_restore(flags). There should be nothing wrong 
with doing this outside the irqs disabled. The check in add_preempt_count 
does not disable interrupts either.

Patch soon on its way, Thanks!

-- Steve

