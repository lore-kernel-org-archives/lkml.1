Return-Path: <linux-kernel-owner+w=401wt.eu-S933537AbXDGADe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbXDGADe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933450AbXDGADd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:03:33 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39506 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933537AbXDGADc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:03:32 -0400
Date: Fri, 6 Apr 2007 17:03:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] [sched] redundant reschedule when set_user_nice()
 boosts a prio of a task from the "expired" array
Message-Id: <20070406170319.2c961eba.akpm@linux-foundation.org>
In-Reply-To: <b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com>
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
	<20070404141546.GA862@elte.hu>
	<b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 22:05:40 +0200 "Dmitry Adamushko" <dmitry.adamushko@gmail.com> wrote:

> Ingo,
> 
> following the conversation on "a redundant reschedule call in set_user_prio()",
> here is a possible approach.
> 
> The patch is somewhat intrusive as it even dares to adapt TASK_PREEMPTS_CURR().
> 
> Nevertheless, this adaptation seems to be ok with all the current use-cases.
> 
> Presupposition: TASK_PREEMPTS_CURR(p, rq) will /never/ be used as "a
> mere prio comparator" - e.g. to make decisions on which array a task
> has to be placed in.
> 
> 
> =====
> 
> o  Make TASK_PREEMPTS_CURR(task, rq) return "true" only if the task's
> prio is higher than the current's one and the task is in the "active"
> array.
> This ensures we don't make redundant resched_task() calls when the
> task is in the "expired" array (as may happen now in set_user_prio(),
> rt_mutex_setprio() and pull_task() ) ;
> 
> o  generilise conditions for a call to resched_task() in
> set_user_nice(), rt_mutex_setprio() and sched_setscheduler()
> 

grief.  This patch conflicts seriously with the staircase scheduler in -mm.
So to merge it I need to

- apply it 
- then apply a revert-it-again patch
- then apply staircase
- then ask Con to cook up a staircase-based equivalent of your change.

so

- your code only gets publically tested in its against-staircase version

- the against-mainline version will get merged without having been
  publically tested outside of staircase

which is probably all OK for a 2.6.22-rc1 thing, provided Ingo can give a
confident ack.


Where are we at with staircase anyway?  Is it looking like a 2.6.22 thing? 
I don't personally think we've yet seen enough serious performance testing
to permit a merge, apart from other issues...



> --- linux-2.6.21-rc5/kernel/sched-orig.c        2007-04-04
> 18:26:19.000000000 +0200
> +++ linux-2.6.21-rc5/kernel/sched.c     2007-04-04 18:26:43.000000000 +0200
> @@ -168,7 +168,7 @@ unsigned long long __attribute__((weak))
>                 (MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))
> 
>  #define TASK_PREEMPTS_CURR(p, rq) \
> -       ((p)->prio < (rq)->curr->prio)
> +       (((p)->prio < (rq)->curr->prio) && ((p)->array == (rq)->active))

Your patch was wordwrapped and had its tabs replaced with spaces.  Please
fix your email client.

(I might as well make that paragraph my .signature)

