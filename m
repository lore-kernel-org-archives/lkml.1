Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZJIH4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZJIH4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZJIH4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:56:08 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:64643 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbZJIH4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dmi1DU4/RfhbjRPKenRbEzdYldDvhCcMX9tj3hxcJY8LrYvfhW+OfTmROOw0ZVwFLG
         J+xjoDEyt2UP6OvPyiKsjpEQxkk8pOH2yBAoe1udUN4agzuYETGWc3YXcpo1B8NtXYqO
         TJ2dUNGkdS9Aj5pdJ4r7DHEH5Xa4hQnlWGOYM=
MIME-Version: 1.0
In-Reply-To: <1255070103.7639.30.camel@marge.simson.net>
References: <200910051500.55875.elendil@planet.nl>
	 <200910081655.37485.elendil@planet.nl>
	 <1255026217.6643.12.camel@marge.simson.net>
	 <200910082259.35204.elendil@planet.nl>
	 <1255070103.7639.30.camel@marge.simson.net>
Date: Fri, 9 Oct 2009 09:55:28 +0200
Message-ID: <2d0a357f0910090055v7a454ca5rb895fecbb9747ecd@mail.gmail.com>
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for 
	CPU"
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Frans Pop <elendil@planet.nl>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

will you (re)send this patch as a new one with correct subject line to LKML?
Otherwise, it might disapper in this long thread.

Kind Regards,
- Sedat -

On Fri, Oct 9, 2009 at 8:35 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Thu, 2009-10-08 at 22:59 +0200, Frans Pop wrote:
>> On Thursday 08 October 2009, Mike Galbraith wrote:
>> > I still see very high latencies coming out of idle (last noted was >
>> > 300ms, NO_HZ) with this patch,
>> >
>> > Like this:
>> >
>> > Cause                                           Maximum    Percentage
>> > Scheduler: waiting for cpu                   604.2 msec        49.0 %
>>
>> I'm not seeing anything even remotely like that.
>
> Instrumenting, I saw (stale) clock deltas of >900ms coming out of idle,
> delta being the difference between rq->clock when we hit update_curr()
> and discover that this queue was idle, and what the clock will be an
> instant or two later when somebody winds the clock.
>
> I've been watching latencytop for a while now to make sure latency is
> really dead.  I see no twitching, so...
>
> sched: update the clock of runqueue select_task_rq() selected.
>
> In try_to_wake_up(), we update the runqueue clock, but select_task_rq()
> may select a different runqueue than the one we updated, leaving the new
> runqueue's clock stale for a bit.
>
> This patch cures occasional huge latencies reported by latencytop when
> coming out of idle on a mostly idle NO_HZ box.
>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
>
> ---
>  kernel/sched.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2311,7 +2311,7 @@ static int try_to_wake_up(struct task_st
>  {
>        int cpu, orig_cpu, this_cpu, success = 0;
>        unsigned long flags;
> -       struct rq *rq;
> +       struct rq *rq, *orig_rq;
>
>        if (!sched_feat(SYNC_WAKEUPS))
>                wake_flags &= ~WF_SYNC;
> @@ -2319,7 +2319,7 @@ static int try_to_wake_up(struct task_st
>        this_cpu = get_cpu();
>
>        smp_wmb();
> -       rq = task_rq_lock(p, &flags);
> +       rq = orig_rq = task_rq_lock(p, &flags);
>        update_rq_clock(rq);
>        if (!(p->state & state))
>                goto out;
> @@ -2350,6 +2350,10 @@ static int try_to_wake_up(struct task_st
>                set_task_cpu(p, cpu);
>
>        rq = task_rq_lock(p, &flags);
> +
> +       if (rq != orig_rq)
> +               update_rq_clock(rq);
> +
>        WARN_ON(p->state != TASK_WAKING);
>        cpu = task_cpu(p);
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
