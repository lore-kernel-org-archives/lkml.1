Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbZKTI0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbZKTI0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbZKTI0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:26:24 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:48413 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZKTI0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:26:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=v8upeY8ts93f1Il9sKalPr/9lMBwd2KJQEG5g4pSAnEZR5lmCpmdkBllYrHvT6x+IB
         p4yMDdKOseoywiq3lFHsqVNFS0NFgZVqK76csGGMGLawtI1AlPwOXBN9by5jd1rTAOX+
         0bib9+CubS70K4fWI8esPh5PlEBSCicIXyBMk=
MIME-Version: 1.0
In-Reply-To: <1258671113.11284.299.camel@laptop>
References: <1258451500-6714-1-git-send-email-jupyung@gmail.com>
	 <1258671113.11284.299.camel@laptop>
Date: Fri, 20 Nov 2009 17:26:30 +0900
Message-ID: <8144bd4b0911200026w48b1b14eg69d205725ca40f76@mail.gmail.com>
Subject: Re: [PATCH 1/1] sched: move update_curr() in check_preempt_wakeup() 
	to avoid redundant call
From: jupyung lee <jupyung@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Nov 20, 8:00 am, Peter Zijlstra <pet...@infradead.org> wrote:
> On Tue, 2009-11-17 at 18:51 +0900, Jupyung Lee wrote:
> > Impact: micro-optimization
>
> > If a RT task is woken up while a non-RT task is running,
> > check_preempt_wakeup() is called to check whether the new task can
> > preempt the old task. The function returns quickly without going deeper
> > because it is apparent that a RT task can always preempt a non-RT task.
>
> > In this situation, check_preempt_wakeup() always calls update_curr() to
> > update vruntime value of the currently running task. However, the function
> > call is unnecessary and redundant at that moment because (1) a non-RT task can
> > always be preempted by a RT task regardless of its vruntime value, and
> > (2) update_curr() will be called shortly when the context switch between two occurs.
>
> > By moving update_curr() in check_preempt_wakeup(), we can avoid redundant
> > call to update_curr(), slightly reducing the time taken to wake up RT tasks.
>
> So far so good, but then you let me figure out why you placed it where
> you did.
>

Currently, in check_preempt_wakeup(), update_curr(cfs_rq) is located as follows:

-----------------------------------------------------------------------------------------

   update_curr(cfs_rq);

   if (unlikely(rt_prio(p->prio))) {   .... /* A */
       resched_task(curr);
       return;
   }

   if (unlikely(p->sched_class != &fair_sched_class))  .... /* B */
       return;

   if (unlikely(se == pse))  .... /* C */
       return;

   if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags &
WF_FORK)) .... /* D */
       set_next_buddy(pse);

   if (test_tsk_need_resched(curr))  .... /* E */
       return;

   if (unlikely(p->policy != SCHED_NORMAL))  .... /* F */
       return;

   if (unlikely(curr->policy == SCHED_IDLE)) {  .... /* G */
       resched_task(curr);
       return;
   }

   if ((sched_feat(WAKEUP_SYNC) && sync) ||  .... /* H */
       (sched_feat(WAKEUP_OVERLAP) &&
        (se->avg_overlap < sysctl_sched_migration_cost &&
         pse->avg_overlap < sysctl_sched_migration_cost))) {
       resched_task(curr);
       return;
   }

   if (sched_feat(WAKEUP_RUNNING)) {  .... /* I */
       if (pse->avg_running < se->avg_running) {
           set_next_buddy(pse);
           resched_task(curr);
           return;
       }
   }

   if (!sched_feat(WAKEUP_PREEMPT))  .... /* J */
       return;

   find_matching_se(&se, &pse);

   BUG_ON(!pse);

   if (wakeup_preempt_entity(se, pse) == 1) {  .... /* K */
       resched_task(curr);

-----------------------------------------------------------------------------------------

Among operations A to L, only 'K' is dependent on update_curr(), which updates
curr->vruntime; wakeup_preempt_entity() compares curr->vruntime with
se->vruntime.
Thus, it is straightforward to move update_curr() just above 'K'. It
allows us to avoid
unnecessary function call to update_curr() when we do not go up to 'K'.
As I said above, calling the function update_curr() here is
unnecessary and redundant
except the case 'K' because it will be called shortly when the context
switch between two occurs.

> Anyway, I think the patch is good and took the patch, thanks!
>

Thanks.

Jupyung
