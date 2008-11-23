Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYKWUjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYKWUjm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYKWUjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:39:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49417 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYKWUja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:39:30 -0500
Date: Sun, 23 Nov 2008 22:39:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, roland@redhat.com, mingo@elte.hu,
       rnalumasu@gmail.com
Subject: Re: + do_wait-wakeup-optimization.patch added to -mm tree
Message-ID: <20081123213929.GA9097@redhat.com>
References: <200811212015.mALKFMs4019558@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811212015.mALKFMs4019558@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Roland McGrath <roland@redhat.com>
>
> +static int needs_wakeup(struct task_struct *task, struct do_wait_queue_entry *w)
> +{
> +	if ((w->options & __WNOTHREAD) && task->parent != w->wq.private)
> +		return 0;
> +
> +	if (eligible_child(w->type, w->pid, w->options,
> +			   task, task->exit_signal))
> +		return 1;
> +
> +	if (thread_group_leader(task)) {
> +		/*
> +		 * In a group leader, do_notify_parent() may have
> +		 * just reset task->exit_signal because SIGCHLD was
> +		 * ignored, but that doesn't prevent the wakeup.
> +		 */
> +		if (!task_detached(task) ||
> +		    !eligible_child(w->type, w->pid, w->options,
> +				    task, SIGCHLD))
> +			return 0;
> +	} else {
> +		/*
> +		 * In a non-leader, this might be the release_task()
> +		 * case, where it's the leader rather than task
> +		 * whose parent is being woken.
> +		 */
> +		if (!eligible_child(w->type, w->pid, w->options,
> +				    task->group_leader,
> +				    task_detached(task->group_leader) ?
> +				    SIGCHLD : task->group_leader->exit_signal))
> +			return 0;
> +	}
> +
> +	return 1;
> +}

Unless I missed something, this is not right.

This "task" is current, iow it is the caller of do_notify_parent(). Sometime
it is OK (release_task, exit_notify), but in general not, afaics.

Let's suppose the ptracer finds the EXIT_ZOMBIE tracee and notifies its
->real_parent which sleeps in do_wait(). In that case the usage of
eligible_child(task == ptracer) above is bogus, and checking for
group_leader is not rifgt too.

> +static int do_wait_wake_function(wait_queue_t *curr, unsigned mode, int sync,
> +				 void *key)
> +{
> +	struct task_struct *task = current;

I think we can fix (and simplify) this code if we change __wake_up_parent(),
it should call __wake_up(key => p), so we can do

	struct task_struct *task = key;

> +	if (!needs_wakeup(task, w))
> +		return 0;
> +
> +	return default_wake_function(curr, mode, sync, key);

perhaps autoremove_wake_function() makes more sense.

Oleg.

