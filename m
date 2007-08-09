Return-Path: <linux-kernel-owner+w=401wt.eu-S936114AbXHIIjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936114AbXHIIjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbXHIIjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:39:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:59489 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569AbXHIIjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r1ck9IWkLAPLYJWqtyuvwHTbwLmVglsc0XiGsj15uiTM1mesZyS5Dxk+GZ5lJgjhvxDM3KDdXxvjdLXLinP6Zbl/6zQF8FCjSspeB5WLh/XqyKbNtTbR2vMwFQsRRoVCBbcCpPVZAIZyyybqXdIF8kdEH5nHJdDLEyxXk5BjXpA=
Message-ID: <b647ffbd0708090139k2ddcc100q443821a03c6733f3@mail.gmail.com>
Date: Thu, 9 Aug 2007 10:39:13 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Question: RT schedular : task_tick_rt(struct rq *rq, struct task_struct *p) : decreases overhead when rq->nr_running == 1
Cc: "Mitchell Erblich" <erblichs@earthlink.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070809083606.GA24130@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <000501c7d945$f30af1a0$6501a8c0@earthlink.net>
	 <20070808123418.GA30248@elte.hu>
	 <b647ffbd0708090111r50d29dbp779e014db1a63296@mail.gmail.com>
	 <20070809082656.GA21973@elte.hu> <20070809083606.GA24130@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> FYI, that's the patch i applied:

Thanks. Added my SOB below.

>
> --------------------------->
> Subject: sched: optimize task_tick_rt() a bit
> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
>
> Mitchell Erblich suggested a change to not requeue SCHED_RR
> tasks if there's only a single task on the runqueue, by
> checking for rq->nr_running == 1.
>
> provide a more efficient implementation of that, to check that
> particular RT priority-queue only.
>
> [ From: mingo@elte.hu ]
>
> Also first requeue the task then set need_resched - results
> in slightly better machine-instruction ordering. Also clean
> up the code a bit.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>


> ---
>  kernel/sched_rt.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> Index: linux/kernel/sched_rt.c
> ===================================================================
> --- linux.orig/kernel/sched_rt.c
> +++ linux/kernel/sched_rt.c
> @@ -207,10 +207,15 @@ static void task_tick_rt(struct rq *rq,
>                 return;
>
>         p->time_slice = static_prio_timeslice(p->static_prio);
> -       set_tsk_need_resched(p);
>
> -       /* put it at the end of the queue: */
> -       requeue_task_rt(rq, p);
> +       /*
> +        * Requeue to the end of queue if we are not the only element
> +        * on the queue:
> +        */
> +       if (p->run_list.prev != p->run_list.next) {
> +               requeue_task_rt(rq, p);
> +               set_tsk_need_resched(p);
> +       }
>  }
>
>  static struct sched_class rt_sched_class __read_mostly = {
>


-- 
Best regards,
Dmitry Adamushko
