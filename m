Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXFNOMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXFNOMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 10:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbXFNOMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 10:12:40 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:14862 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXFNOMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 10:12:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LFVPJKxgdlj7SFNh7q6pu6wkwUi0sVdx6+vxqywCwZRpYfbd7QoXaUHHF5uxlsR3pz5NOmwIgcZrK+CHgP5ayEYGoMe1OCBdhvqek2LtkDpZoqIoRD6Nggu7e4+h/2M5YoHdqcVdgW9fu+9l5SGqLCfJAtxr4DjwP9GQSxhn3ls=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] sched: fix SysRq-N (normalize RT tasks)
Date: Thu, 14 Jun 2007 10:12:30 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>
References: <20070614094830.GA494@elte.hu>
In-Reply-To: <20070614094830.GA494@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141012.31048.gene.heskett@gmail.com>
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

When I looked at sched.c, I found it about 1000 lines shorter than the offsets 
listed above.  So I took it back out and will test the plain 
2.6.22-rc4-cfs-v16 shortly.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
To save a single life is better than to build a seven story pagoda.
