Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab0CDOJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:09:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0CDOJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:09:34 -0500
Date: Thu, 4 Mar 2010 15:08:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-kernel@vger.kernel.org, Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>, Kay Sievers <kay.sievers@vrfy.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
	for child processes
Message-ID: <20100304140822.GA458@redhat.com>
References: <20100202120457.GA19605@omega>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202120457.GA19605@omega>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02, Lennart Poettering wrote:
>
> This patch adds a simple flag for each process that marks it as an
> "anchor" process for all its children and grandchildren. If a child of
> such an anchor dies all its children will not be reparented to init, but
> instead to this anchor, escaping this anchor process is not possible. A
> task with this flag set hence acts is little "sub-init".

Lennart, this patch adds a noticeable linux-only feature. I see
your point, but imho your idea needs the "strong" acks. I cc'ed
some heavyweights, if someone dislikes your idea he can nack it
right now.


Security. This is beyond my understanding, hopefully the cc'ed
experts can help.

Should we clear ->child_anchor flags when the "sub-init" execs? Or,
at least, when the task changes its credentials? Probably not, but
dunno.

The more problematic case is when the descendant of the "sub-init"
execs the setuid application. Should we allow the reparenting to
!/sbin/init task in this case?

Should we clear ->pdeath_signal after reparenting to sub-init ?

Do we need the new security_operations->task_reparent() method ?
Or, perhaps we can reuse ->task_wait() if we add the "parent"
argument?

Something else we should think about?


As for the patch itself,

>  static struct task_struct *find_new_reaper(struct task_struct *father)
>  {
>  	struct pid_namespace *pid_ns = task_active_pid_ns(father);
> -	struct task_struct *thread;
> +	struct task_struct *thread, *anchor;
>
>  	thread = father;
>  	while_each_thread(father, thread) {
> @@ -715,6 +715,11 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
>  		return thread;
>  	}
>
> +	/* find the first ancestor which is marked child_anchor */
> +	for (anchor = father->parent; anchor != &init_task; anchor = anchor->parent)
> +		if (anchor->child_anchor)
> +			return anchor;
> +
>  	if (unlikely(pid_ns->child_reaper == father)) {
>  		write_unlock_irq(&tasklist_lock);
>  		if (unlikely(pid_ns == &init_pid_ns))

This is not exactly right:

	- We can race with the exiting anchor. IOW, we must not reparent
	  to anchor if it has already passed exit_notify(). You can check
	  PF_EXITING flag like while_each_thread() above does.

	- "anchor != &init_task" is not correct, the task must not escape
	  its container. We should stop checking the ->parent list when we
	  hit ->child_reaper, not init_task

	- if a sub-namespace init dies, we shouldn't skip zap_pid_ns_processes()
	  logic, move the "for" loop below. This also closes another possible
	  race, the anchor can be already dead when we take tasklist again.

> @@ -1578,6 +1578,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  			else
>  				error = PR_MCE_KILL_DEFAULT;
>  			break;
> +		case PR_SET_ANCHOR:
> +			me->child_anchor = !!arg2;
> +			error = 0;
> +			break;

It is a bit strange that PR_SET_ANCHOR acts per-thread, not per process.

Suppose that a task A does prtcl(PR_SET_ANCHOR) and marks itself as a local
child reaper. Then its sub-thread B forks() the process C which also forks
the child X. When C dies, X will be re-parented to init. Is this what we
really want?

To me, it looks more natural if PR_SET_ANCHOR marks the whole process as
a local reaper, not only the thread which called PR_SET_ANCHOR.

Oleg.

