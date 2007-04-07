Return-Path: <linux-kernel-owner+w=401wt.eu-S965645AbXDGJQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbXDGJQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965680AbXDGJQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:16:10 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:35846 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965645AbXDGJQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:16:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WvrONKP/qPwjtnMA8Tw2scFAj9+EqD10h+twCVVfLOMmS/J0cIMHmIDWzQkeSRvqcvfqLe4DhZgjTLic8yJzGqa/EJfE/cPBQCv3Sag6cXnet4o7rcKIwYi22kBX4c1ITS0XrriGXDbEHtLe4KvRzDbuLQbBDYlO0Di42068w/s=
Message-ID: <b647ffbd0704070216n72f72240va80e137cf530d4de@mail.gmail.com>
Date: Sat, 7 Apr 2007 11:16:05 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] [sched] redundant reschedule when set_user_nice() boosts a prio of a task from the "expired" array
Cc: "Ingo Molnar" <mingo@elte.hu>, "Con Kolivas" <kernel@kolivas.org>,
       "Mike Galbraith" <efault@gmx.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070406170319.2c961eba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
	 <20070404141546.GA862@elte.hu>
	 <b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com>
	 <20070406170319.2c961eba.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 4 Apr 2007 22:05:40 +0200 "Dmitry Adamushko"
> > [...]
> >
> > o  Make TASK_PREEMPTS_CURR(task, rq) return "true" only if the task's
> > prio is higher than the current's one and the task is in the "active"
> > array.
> > This ensures we don't make redundant resched_task() calls when the
> > task is in the "expired" array (as may happen now in set_user_prio(),
> > rt_mutex_setprio() and pull_task() ) ;
> >
> > o  generilise conditions for a call to resched_task() in
> > set_user_nice(), rt_mutex_setprio() and sched_setscheduler()
> >
>
> grief.  This patch conflicts seriously with the staircase scheduler in -mm.
> So to merge it I need to
>
> - apply it
> - then apply a revert-it-again patch
> - then apply staircase
> - then ask Con to cook up a staircase-based equivalent of your change.

I'll make a SD-based version and send it to Con.


> so
>
> - your code only gets publically tested in its against-staircase version
>
> - the against-mainline version will get merged without having been
>   publically tested outside of staircase
>
> which is probably all OK for a 2.6.22-rc1 thing, provided Ingo can give a
> confident ack.

Ok, thanks.

btw, just out of curiosity. The very first approach I was thinking of
- was to move a task from the "expired" to the "active" array when its
priority is boosted (like rt_mutex_setprio() does for rt tasks).

Reasoning: getting a higher static_prio means getting an additional
quota of timeslice which still could be used during this rotation.

delta = task_timeslice(p->static_prio) - task_timeslice(old_static_prio)

Aha.. /here I'm looking at the mainline now/ another funny thing is
that a time_slice is not immediately affected by the change of
static_prio in set_user_nice(). If a task is in the expired array, it
will run the next rotation with the *old* time_slice (i.e. calculated
in task_running_tick() before putting the task in the expired array
and based on the *old* static_prio).
In theory, set_user_nice() could adjust a p->time_slice with "delta"
being calculated as shown above.. But ok, it's not more than a minor
inconsistency (of course, if I'm not missing something).


>
> > --- linux-2.6.21-rc5/kernel/sched-orig.c        2007-04-04
> > 18:26:19.000000000 +0200
> > +++ linux-2.6.21-rc5/kernel/sched.c     2007-04-04 18:26:43.000000000 +0200
> > @@ -168,7 +168,7 @@ unsigned long long __attribute__((weak))
> >                 (MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))
> >
> >  #define TASK_PREEMPTS_CURR(p, rq) \
> > -       ((p)->prio < (rq)->curr->prio)
> > +       (((p)->prio < (rq)->curr->prio) && ((p)->array == (rq)->active))
>
> Your patch was wordwrapped and had its tabs replaced with spaces.  Please
> fix your email client.

I apologize for this. Will fix.


-- 
Best regards,
Dmitry Adamushko
