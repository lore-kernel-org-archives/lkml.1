Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYGaNJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYGaNJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 09:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbYGaNJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 09:09:05 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60595 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbYGaNJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 09:09:04 -0400
Date: Thu, 31 Jul 2008 17:12:26 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] wait_task_inactive: don't use the dummy version when !SMP && PREEMPT
Message-ID: <20080731131226.GB76@tv-sign.ru>
References: <20080730170949.GA18682@tv-sign.ru> <alpine.LFD.1.10.0807301038170.3334@nehalem.linux-foundation.org> <b647ffbd0807301246s1def837ar8c389a3d3f7ec2cc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0807301246s1def837ar8c389a3d3f7ec2cc@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Dmitry Adamushko wrote:
>
> 2008/7/30 Linus Torvalds <torvalds@linux-foundation.org>:
> >
> > Oh, and shouldn't it do a "yield()" instead of a cpu_relax() on UP?
>
> This part could have been skipped for UP. task_running(rq, p) just
> can't give 'true' for UP (otherwise it's a bug). The only relevant
> part is "on_rq = p->se.on_rq".

That was my understanding, thanks for your confirmation.

> (if [1], then I think a separate function for PREEMPT would look
> better, i.e. without parts with task_running())

in that case we can also eliminate task_rq_lock() afaics.

> e.g. consider this code from kthread_bind():
>
>         /* Must have done schedule() in kthread() before we set_task_cpu */
>         wait_task_inactive(k, 0);
>
>         set_task_cpu(k, cpu);
>         k->cpus_allowed = cpumask_of_cpu(cpu);
>         k->rt.nr_cpus_allowed = 1;
>         k->flags |= PF_THREAD_BOUND;
>
> set_task_cpu(k, cpu) is safe _only_ if 'k' is not on the run-queue
> (and can't be placed onto it behind our back -- heh, a bit subtle).
>
> Now, for !SMP + PREEMPT it's not a case. set_task_cpu() may be called
> while 'k' is still on the run-queue (more precisely, preempted in
> kthread() between complete(&create->started); and schedule();).
>
> Yes, set_task_cpu() is a "nop" for UP so that's ok in this particular
> case. But let's suppose, another use-case would be introduced with
> 'false' assumptions causing troubles for !SMP.

Completely agreed.


Currently the only user which can suffer on UP && PREEMPT is
task_current_syscall(). As Roland suggested we can fix it if we change
the !SMP version to return ->nivcsw + ->nvcsw. But personally I don't
like the fact that we will have the subltle difference in behaviour
depending on CONFIG_SMP. We have to wait for .on_rq == 0 on SMP, imho
it is better to do the same on UP even if none of the current callers
needs this.

That said, I think this problem is minor and I don't (and can't) have
the strong opinion on how to fix it. I'd better wait for the authoritative
verdict.

Oleg.

