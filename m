Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbXJUL75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbXJUL75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbXJUL7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:59:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:14684 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbXJUL7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=shjlBeHglM+3p3hdgv5VK0r9NCWC1QUdIRpMcwbDSZ2V9XkBryCuqynbZvcU6fN1+pPYOAbl+rl3SZkezuq+juOAOOmfJbetczXH7DPN/oFl9uCKnAtMZzW66DXy9dPb3mQ7BLIomMnaym5kGjWbxdzBAsmBjsMoV6VANAyNgjI=
Message-ID: <b647ffbd0710210459y6116e85ek3d6feba6ec98231@mail.gmail.com>
Date: Sun, 21 Oct 2007 13:59:47 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [patch 6/8] pull RT tasks
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20071019184336.983272715@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071019184254.456160632@goodmis.org>
	 <20071019184336.983272715@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/10/2007, Steven Rostedt <rostedt@goodmis.org> wrote:

> [ ... ]
>
> @@ -2927,6 +2927,13 @@ static void idle_balance(int this_cpu, s
>         int pulled_task = -1;
>         unsigned long next_balance = jiffies + HZ;
>
> +       /*
> +        * pull_rt_task returns true if the run queue changed.
> +        * But this does not mean we have a task to run.
> +        */
> +       if (unlikely(pull_rt_task(this_rq)) && this_rq->nr_running)
> +               return;
> +
>         for_each_domain(this_cpu, sd) {
>                 unsigned long interval;
>
> @@ -3614,6 +3621,7 @@ need_resched_nonpreemptible:
>         if (unlikely(!rq->nr_running))
>                 idle_balance(cpu, rq);
>
> +       schedule_balance_rt(rq, prev);

we do pull_rt_task() in idle_balance() so, I think, there is no need
to do it twice.
i.e.
         if (unlikely(!rq->nr_running))
                 idle_balance(cpu, rq);
+       else
+               schedule_balance_rt(rq, prev);

hum?

moreover (continuing my previous idea on "don't pull more than 1 task
at once"), I wonder whether you really see cases when more than 1 task
have been successfully _pushed_ over to other run-queues at once...

I'd expect the push/pull algorithm to naturally avoid such a
possibility. Let's say we have a few RT tasks on our run-queue that
are currently runnable (but not running)... the question is 'why do
they still here?'

(1) because the previous attempt to _push_ them failed;
(2) because they were not _pulled_ from other run-queues.

both cases should mean that other run-queues have tasks with higher
prios running at the moment.

yes, there is a tiny window in schedule() between deactivate_task() [
which can make this run-queue to look like we can push over to it ]
and idle_balance() -> pull_rt_task() _or_ schedule_balance_rt() ->
pull_rt_task() [ where this run-queue will try to pull tasks on its
own ]

_but_ the run-queue is locked in this case so we wait in
double_lock_balance() (from push_rt_task()) and run into the
competition with 'src_rq' (which is currently in the 'tiny window' as
described above trying to run pull_rt_task()) for getting both self_rq
and src_rq locks...

this way, push_rt_task() always knows the task to be pushed (so it can
be a bit optimized) --- as it's either a newly woken up RT task with
(p->prio > rq->curr->prio) _or_ a preempted RT task (so we know 'task'
for both cases).

To sum it up, I think that the pull/push algorithm should be able to
naturally accomplish the proper job pushing/pulling 1 task at once (as
described above)... any additional actions are just overhead or there
is some problem with the algorithm (ah well, or with my understanding
:-/ )


-- 
Best regards,
Dmitry Adamushko
