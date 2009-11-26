Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbZKZQ0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbZKZQ0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760711AbZKZQ0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:26:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:57041 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760796AbZKZQ0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:26:21 -0500
Subject: Re: [patch] sched: fix b5d9d734 blunder in task_new_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1258891664.14325.30.camel@marge.simson.net>
References: <1258891664.14325.30.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 17:26:25 +0100
Message-ID: <1259252785.31676.216.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 13:07 +0100, Mike Galbraith wrote:
> @@ -2589,16 +2588,10 @@ void sched_fork(struct task_struct *p, i
>          */
>         p->prio = current->normal_prio;
>  
> -       if (!rt_prio(p->prio))
> +       if (!task_has_rt_policy(p))
>                 p->sched_class = &fair_sched_class;
>  
> -#ifdef CONFIG_SMP
> -       cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
> -#endif
> -       local_irq_save(flags);
> -       update_rq_clock(cpu_rq(cpu));
> -       set_task_cpu(p, cpu);
> -       local_irq_restore(flags);
> +       __set_task_cpu(p, cpu); 

OK, so I figured out why it was in sched_fork() and not in
wake_up_new_task().

It is because in sched_fork() the new task isn't in the tasklist yet and
can therefore not race with any other migration logic.


