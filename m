Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYFWLoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYFWLoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYFWLoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:44:07 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58691 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYFWLoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:44:04 -0400
Date: Mon, 23 Jun 2008 15:46:32 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: v2.6.26-rc7: BUG task_struct: Poison overwritten
Message-ID: <20080623114632.GA173@tv-sign.ru>
References: <20080621192400.GA2992@damson.getinternet.no> <20080621192845.GB2992@damson.getinternet.no> <19f34abd0806211341i3a3ecd0bi1c849a2fbc4e9c7e@mail.gmail.com> <1214083307.3223.289.camel@lappy.programming.kicks-ass.net> <19f34abd0806211557v6763bd3fo2d99d4f26cb0d3a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806211557v6763bd3fo2d99d4f26cb0d3a5@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22, Vegard Nossum wrote:
>
> I was poking around in kernel/sched.c and noticed something odd: In
> migrate_dead(), we have this code:
>
>         /*
>          * Drop lock around migration; if someone else moves it,
>          * that's OK. No task can be added to this CPU, so iteration is
>          * fine.
>          */
>         spin_unlock_irq(&rq->lock);
>         move_task_off_dead_cpu(dead_cpu, p);
>         spin_lock_irq(&rq->lock);
>
> which is fine in itself, I guess. But spin_unlock_irq() will enable
> interrupts. And move_task_off_dead_cpu() has this comment:
>
> /*
>  * Figure out where task on dead CPU should go, use force if necessary.
>  * NOTE: interrupts should be disabled by the caller
>  */
> static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
> {
>
> ...but here, interrupts will not be disabled. On the other hand
> __migrate_task_irq() (called by move_task_off_dead_cpu()) calls
> local_irq_disable() itself... What do you think of this? Is the
> comment wrong? Or is there a difference between "interrupts" and
> "local_irq"?

Yes, the comment is wrong, thanks.

It wasn't updated by

"do CPU_DEAD migrating under read_lock(tasklist) instead of write_lock_irq(tasklist)"
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f7b4cddcc5aca03e80e357360c9424dfba5056c2

Previously move_task_off_dead_cpu() was called under write_lock_irq(tasklist),
and we can't take tasklist for writing without disabling irqs.

If you don't see other problems, could you make a patch to fix the comment?

Oleg.

