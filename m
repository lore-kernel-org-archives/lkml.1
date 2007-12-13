Return-Path: <linux-kernel-owner+w=401wt.eu-S1763966AbXLMR2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763966AbXLMR2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbXLMR2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:28:32 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:41697 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758803AbXLMR2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:28:31 -0500
Date: Thu, 13 Dec 2007 20:29:26 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Petr Tesarik <ptesarik@suse.cz>, Tony Luck <tony.luck@intel.com>,
       Matthew Wilcox <willy@debian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch_ptrace_stop
Message-ID: <20071213172926.GA423@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>
> +static int sigkill_pending(struct task_struct *tsk)
> +{
> +	return ((sigismember(&tsk->pending.signal, SIGKILL) ||
> +		 sigismember(&tsk->signal->shared_pending.signal, SIGKILL)) &&
> +		!unlikely(sigismember(&tsk->blocked, SIGKILL)));
> +}

How is it possible that SIGKILL is blocked?

>  static void ptrace_stop(int exit_code, int nostop_code, siginfo_t *info)
>  {
> +	int killed = 0;
> +
> +	if (arch_ptrace_stop_needed(exit_code, info)) {
> +		/*
> +		 * The arch code has something special to do before a
> +		 * ptrace stop.  This is allowed to block, e.g. for faults
> +		 * on user stack pages.  We can't keep the siglock while
> +		 * calling arch_ptrace_stop, so we must release it now.
> +		 * To preserve proper semantics, we must do this before
> +		 * any signal bookkeeping like checking group_stop_count.
> +		 * Meanwhile, a SIGKILL could come in before we retake the
> +		 * siglock.  That must prevent us from sleeping in TASK_TRACED.
> +		 * So after regaining the lock, we must check for SIGKILL.
> +		 */
> +		spin_unlock_irq(&current->sighand->siglock);
> +		arch_ptrace_stop(exit_code, info);
> +		spin_lock_irq(&current->sighand->siglock);
> +		killed = sigkill_pending(current);
> +	}
> +
>  	/*
>  	 * If there is a group stop in progress,
>  	 * we must participate in the bookkeeping.
> @@ -1604,7 +1635,7 @@ static void ptrace_stop(int exit_code, i
>  	spin_unlock_irq(&current->sighand->siglock);
>  	try_to_freeze();
>  	read_lock(&tasklist_lock);
> -	if (may_ptrace_stop()) {
> +	if (!unlikely(killed) && may_ptrace_stop()) {

Could you please explain this change in more details?

Currently ptrace_stop() schedules in TASK_TRACED state even if we have a
pending SIGKILL. With this patch this is still possible, but unless
arch_ptrace_stop_needed() is true and thus we will check sigkill_pending().

Suppose the task was SIGKILL'ed and does ptrace_notify(PTRACE_EVENT_EXIT),
now the resulting action depends on arch_ptrace_stop_needed().

I don't claim this is wrong, just trying to understand.

Thanks,

Oleg.

