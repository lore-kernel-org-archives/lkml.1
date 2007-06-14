Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbXFNNtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbXFNNtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 09:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXFNNtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 09:49:09 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:46514 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbXFNNtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 09:49:08 -0400
Date: Thu, 14 Jun 2007 09:48:47 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] sched: fix SysRq-N (normalize RT tasks)
In-reply-to: <20070614094830.GA494@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>
Message-id: <200706140948.48005.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070614094830.GA494@elte.hu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007, Ingo Molnar wrote:
>From: Ingo Molnar <mingo@elte.hu>
>Subject: [patch] sched: fix SysRq-N (normalize RT tasks)
>
>Gene Heskett reported the following problem while testing CFS: SysRq-N
>is not always effective in normalizing tasks back to SCHED_OTHER.
>
>the reason for that turns out to be the following bug:
>normalize_rt_tasks() uses for_each_process() to iterate through all
>tasks in the system. The problem is, this method does not iterate
>through all tasks, it iterates through all thread groups. The proper
>mechanism to enumerate all tasks is to use a do_each_thread() +
>while_each_thread() loop.
>
>obvious bugfix for v2.6.22 inclusion. -stable candidate as well.
>
>Reported-by: Gene Heskett <gene.heskett@gmail.com>
>Signed-off-by: Ingo Molnar <mingo@elte.hu>
>---
> kernel/sched.c |    8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>
>Index: linux/kernel/sched.c
>===================================================================
>--- linux/kernel/sched.c
>+++ linux/kernel/sched.c
>@@ -7071,12 +7071,13 @@ EXPORT_SYMBOL(__might_sleep);
> void normalize_rt_tasks(void)
> {
> 	struct prio_array *array;
>-	struct task_struct *p;
>+	struct task_struct *g, *p;
> 	unsigned long flags;
> 	struct rq *rq;
>
> 	read_lock_irq(&tasklist_lock);
>-	for_each_process(p) {
>+
>+	do_each_thread(g, p) {
> 		if (!rt_task(p))
> 			continue;
>
>@@ -7094,7 +7095,8 @@ void normalize_rt_tasks(void)
>
> 		__task_rq_unlock(rq);
> 		spin_unlock_irqrestore(&p->pi_lock, flags);
>-	}
>+	} while_each_thread(g, p);
>+
> 	read_unlock_irq(&tasklist_lock);
> }

Ingo:  I appended this patch to the cfs-v16 patch for 2.6.22-rc4, and got this 
while applying it:

patching file kernel/sched.c
Hunk #1 FAILED at 7071.
Hunk #2 FAILED at 7095.
2 out of 2 hunks FAILED -- saving rejects to file kernel/sched.c.rej
done

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
One man tells a falsehood, a hundred repeat it as true.
