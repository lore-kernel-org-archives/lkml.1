Return-Path: <linux-kernel-owner+w=401wt.eu-S936479AbXHIILn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936479AbXHIILn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763164AbXHIIL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:11:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:13059 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbXHIIL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=srqG9DCEPoA82gNo4QlyXqT/topEPIdfZ3m8qF8r85+EhGenbkqRxPETn9jtM8WUccUCLv6/LY32Pv801RGlxZmV5ujDbfXK166D0UbA9ybJTHC3LWzJDKtCHE/qtPZubJO8dmpuLRBavwFzMzh/NqTOibebd39L3ED+OzE3LF4=
Message-ID: <b647ffbd0708090111r50d29dbp779e014db1a63296@mail.gmail.com>
Date: Thu, 9 Aug 2007 10:11:25 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Question: RT schedular : task_tick_rt(struct rq *rq, struct task_struct *p) : decreases overhead when rq->nr_running == 1
Cc: "Mitchell Erblich" <erblichs@earthlink.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070808123418.GA30248@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <000501c7d945$f30af1a0$6501a8c0@earthlink.net>
	 <20070808123418.GA30248@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Mitchell Erblich <erblichs@earthlink.net> wrote:
>
> > After
> >     p->time_slice = static_prio_timeslice(p->static_prio);
> >
> > Why isn't their a check like
> >     if  (rq->nr_running == 1)
> >          return;
> >
> > Which world remove the need for any recheduling or requeue'ing...
>
> your change is a possible optimization, but this is a pretty rare
> codepath because the overwhelming majority of RT apps uses SCHED_FIFO.
> Plus, the time_slice going down to 0 is a relatively rare event even for
> SCHED_RR tasks. [ ... ]

I doubt it's a worth optimization. It's a rare codepath and, moreover,
this optimization is sub-optimal. e.g. the rest of tasks that
contributed to 'rq->nr_running > 1' could be SCHED_NORMAL (or of lower
rt_prio) and so resched_task() is useless as well.

I guess, the following thing would do a better job:

- we do need reschedule() _only_  if there are other task on the
_same_ queue (for this prio level) :

(1) if there is a task with a higher prio, resched_task() would be
called in other place;
(2) if there are tasks of lower prio, we don't care.

I may be wrong, but at the first glance it looks like the following
trick would do the job.. no?

p.s. even if it's ok, it's still a rare codepath (although, it adds
some code to the rare path.. so the drawback is only code-size, I
guess).

--- kernel/sched_rt-prev.c      2007-08-09 09:55:10.000000000 +0200
+++ kernel/sched_rt.c   2007-08-09 09:58:53.000000000 +0200
@@ -207,6 +207,11 @@ static void task_tick_rt(struct rq *rq,
                return;

        p->time_slice = static_prio_timeslice(p->static_prio);
+
+       /* We are the only element on the queue. */
+       if (p->run_list.prev == p->run_list.next)
+               return;
+
        set_tsk_need_resched(p);

        /* put it at the end of the queue: */


-- 
Best regards,
Dmitry Adamushko
