Return-Path: <linux-kernel-owner+w=401wt.eu-S1761492AbYFDRdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761492AbYFDRdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761341AbYFDRdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:33:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49662 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761335AbYFDRdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:33:20 -0400
Date: Wed, 4 Jun 2008 11:33:18 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] schedule: fix TASK_WAKEKILL vs SIGKILL race
Message-ID: <20080604173318.GH3549@parisc-linux.org>
References: <20080604170905.GA10273@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604170905.GA10273@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 09:09:05PM +0400, Oleg Nesterov wrote:
> Note this "__TASK_STOPPED | __TASK_TRACED" check in signal_pending_state().
> Probably it would be better to remove it, but this will change the current
> behaviour and thus needs a separate discussion.

We're changing the behaviour anyway.  Let's have the discussion and get
it right.

In my opinion, not checking for TASK_STOPPED or TASK_TRACED previously was
an oversight.  This should be fixed.

> Note also that with or without this patch TASK_WAKEKILL is not exactly right
> wrt /sbin/init, but this is another issue.

That's certainly an interesting conversation to have.

> +int signal_pending_state(long state, struct task_struct *p)
> +{
> +	if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
> +		return 0;
> +	if (!signal_pending(p))
> +		return 0;
> +
> +	if (state & TASK_INTERRUPTIBLE)
> +		return 1;
> +	if (state & (__TASK_STOPPED | __TASK_TRACED))
> +		return 0;

Just deleting the above two lines should do it?

> +	return __fatal_signal_pending(p);
> +}
> +
>  struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)
>  {
>  	struct sighand_struct *sighand;
> --- 26-rc2/kernel/sched.c~1_SCHED_KILLABLE	2008-05-18 15:44:18.000000000 +0400
> +++ 26-rc2/kernel/sched.c	2008-06-04 17:42:59.000000000 +0400
> @@ -4510,12 +4510,10 @@ need_resched_nonpreemptible:
>  	clear_tsk_need_resched(prev);
>  
>  	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> -		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
> -				signal_pending(prev))) {
> +		if (unlikely(signal_pending_state(prev->state, prev)))
>  			prev->state = TASK_RUNNING;
> -		} else {
> +		else
>  			deactivate_task(rq, prev, 1);
> -		}

Getting rid of the extra braces is against CodingStyle:

  Do not unnecessarily use braces where a single statement will do.

  if (condition)
          action();

  This does not apply if one branch of a conditional statement is a single
  statement. Use braces in both branches.

  if (condition) {
          do_this();
          do_that();
  } else {
          otherwise();
  }

This patch is going to add quite a few cycles to schedule().  Has anyone
done any benchmarks with a schedule-heavy workload?

I don't think signal_pending_state() should be in signal.c, just put it
in sched.c along with its only caller.  That way, gcc can choose to
inline it if that's more efficient.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
