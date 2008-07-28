Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYG1Mxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYG1Mxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 08:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYG1Mxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 08:53:31 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46808 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYG1Mxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 08:53:30 -0400
Date: Mon, 28 Jul 2008 16:57:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Q: wait_task_inactive() and !CONFIG_SMP && CONFIG_PREEMPT
Message-ID: <20080728125704.GA98@tv-sign.ru>
References: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org> <20080727121540.GB178@tv-sign.ru> <20080727200551.D3F6A154284@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727200551.D3F6A154284@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27, Roland McGrath wrote:
>
> > Without CONFIG_SMP wait_task_inactive() is noop, this doesn't look right.
> > Shouldn't we also take CONFIG_PREEMPT into account?
>
> wait_task_inactive is only called when task->state is nonzero (i.e. not
> TASK_RUNNING).  Preemption leaves a task in TASK_RUNNING, so a preempted
> task shouldn't ever be passed to wait_task_inactive.

No, schedule() doesn't change prev->state when the task with ->state !=
TASK_RUNNING gets a preemption. Note this check

	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {

in schedule().

Let's suppose the child does ptrace_stop(). It sets state = TASK_TRACED
and unlocks ->siglock.

If it is preempted by the parent which does ptrace_check_attach(),
wait_task_inactive() must wait until the child leaves the runqueue,
but the dummy version just returns success.

sys_ptrace() continues assuming that the child sleeps in TASK_TRACED,
while it fact it is running, despite its ->state == TASK_TRACED.


As I said, nothing realy bad can happen, the child can't return to the
user-space or something, but this just means that ptrace_check_attach()
afaics doesn't have the strong reasons for wait_task_inactive().

> > Also, the !SMP version of wait_task_inactive() always returns 1, this
> > doesn't conform to the comment near kernel/sched.c:wait_task_inactive().
>
> You mean the "(its total switch count)" part of the comment?
> The normative part was only meant to be "a positive number".

I refer to this patch of the comment:

	If a second call a short while later returns the same number, the
	caller can be sure that @p has remained unscheduled the whole time.

The dummy version always returns the same number == 1.


So. I think that wait_task_inactive() needs "defined(SMP) || defined(PREEMPT)"
and the dummy version should return ->nvcsw too.

Oleg.

