Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbZL2PWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbZL2PWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZL2PWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:22:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33021 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbZL2PWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:22:12 -0500
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: fork and terminate task logic
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1255707661.6228.455.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707661.6228.455.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 16:20:41 +0100
Message-ID: <1262100041.7135.157.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:41 +0200, Raistlin wrote:
> +++ b/kernel/sched.c
> @@ -2561,8 +2561,20 @@ void sched_fork(struct task_struct *p, int clone_flags)
>          * Make sure we do not leak PI boosting priority to the child.
>          */
>         p->prio = current->normal_prio;
> +       if (deadline_task(p)) {
> +               p->sched_class = &deadline_sched_class;
>  
> -       if (!rt_prio(p->prio))
> +               /*
> +                * the child will be SCHED_DEADLINE, but with zero bandwidth.
> +                * The parent (or some other task) must call setscheduler_ex
> +                * on it, or it won't ever start.
> +                */
> +               init_deadline_task(p);
> +               p->dl.flags &= ~DL_NEW;
> +               p->dl.flags |= DL_THROTTLED;

I recently added ->task_fork(), which is called after the class
assignment.

> +       } else if (rt_prio(p->prio))
> +               p->sched_class = &rt_sched_class;
> +       else
>                 p->sched_class = &fair_sched_class;
>  
>  #ifdef CONFIG_SMP
> @@ -2744,6 +2756,10 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>         if (mm)
>                 mmdrop(mm);
>         if (unlikely(prev_state == TASK_DEAD)) {
> +               /* a deadline task is dying: stop the bandwidth timer */
> +               if (deadline_task(prev))
> +                       hrtimer_cancel(&prev->dl.dl_timer);
> +
>                 /*
>                  * Remove function-return probe instances associated with this
>                  * task and put them back on the free list. 

Shouldn't this be done in the ->dequeue_task() callback?

