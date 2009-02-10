Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbZBJWux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbZBJWux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZBJWup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:50:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54780 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbZBJWuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:50:44 -0500
Date: Tue, 10 Feb 2009 23:47:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] forget_original_parent: cleanup ptrace pathes
Message-ID: <20090210224751.GA9478@redhat.com>
References: <20090129080603.GA26882@redhat.com> <20090205024021.04DDDFC381@magilla.sf.frob.com> <20090205153301.GC20953@redhat.com> <20090209023626.03C7DFC330@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209023626.03C7DFC330@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08, Roland McGrath wrote:
>
> "Better" is obviously subjective.

Yes. I understand.

> > Oh. We can do this right now. But I don't think this makes the code
> > better. We should restart the list_for_each_entry_safe() loop again
> > and againg until we can't find the task to reap.
>
> Sure, but "restarting" doesn't mean walking any part of the list again--the
> parts you've walked earlier are already gone.  It just means the pure
> overhead of the restart (unlock/relock et al).

Yes.

> > And we have the small problem with atomicity, we should call
> > find_new_reaper() every time we re-lock tasklist.
>
> Ok.  That's right.  I don't think it hurts anything.

It doesn't really hurt, but a bit ugly. Imho.

How about below? Modulo comments and some other cleanups. For example,
I think it is better to move the changing of ->real_parent into
reparent_thread().

Oleg.

kernel/ptrace.c:

	// also used by ptrace_detach()
	int __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
	{
		__ptrace_unlink(p);

		if (p->exit_state != EXIT_ZOMBIE)
			return 0;
		/*
		 * If it's a zombie, our attachedness prevented normal
		 * parent notification or self-reaping.  Do notification
		 * now if it would have happened earlier.  If it should
		 * reap itself we return true.
		 *
		 * If it's our own child, there is no notification to do.
		 * But if our normal children self-reap, then this child
		 * was prevented by ptrace and we must reap it now.
		 */
		if (!task_detached(p) && thread_group_empty(p)) {
			if (!same_thread_group(p->real_parent, tracer))
				do_notify_parent(p, p->exit_signal);
			else if (ignoring_children(tracer->sighand))
				p->exit_signal = -1;
		}

		if (!task_detached(p))
			return 0;

		/* Mark it as in the process of being reaped. */
		p->exit_state = EXIT_DEAD;
		return 1;
	}

	void ptrace_xxx(struct task_struct *tracer)
	{
		struct task_struct *p, *n;
		LIST_HEAD(ptrace_dead);

		write_lock_irq(&tasklist_lock);
		list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
			if (__ptrace_detach(tracer, p))
				list_add(&p->ptrace_entry, &ptrace_dead);
		}
		write_unlock_irq(&tasklist_lock);

		list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
			list_del_init(&p->ptrace_entry);
			release_task(p);
		}
	}

kernel/exit.c:

	static int reparent_thread(struct task_struct *father, struct task_struct *p)
	{
		int dead;

		if (p->pdeath_signal)
			/* We already hold the tasklist_lock here.  */
			group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);

		if (task_detached(p))
			return 0;
		/* If this is a threaded reparent there is no need to
		 * notify anyone anything has happened.
		 */
		if (same_thread_group(p->real_parent, father))
			return 0;

		/* We don't want people slaying init.  */
		p->exit_signal = SIGCHLD;

		/* If we'd notified the old parent about this child's death,
		 * also notify the new parent.
		 */
		dead = 0;
		if (!p->ptrace &&
		    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
			do_notify_parent(p, p->exit_signal);
			if (task_detached(p)) {
				p->exit_state = EXIT_DEAD;
				dead = 1;
			}
		}

		kill_orphaned_pgrp(p, father);

		return dead;
	}

	static void forget_original_parent(struct task_struct *father)
	{
		struct task_struct *p, *n, *reaper;
		struct list_head *xxx;
		LIST_HEAD(child_dead);

		ptrace_xxx(father);

		write_lock_irq(&tasklist_lock);
		reaper = find_new_reaper(father);

		list_for_each_entry_safe(p, n, &father->children, sibling) {
			p->real_parent = reaper;
			if (p->parent == father) {
				BUG_ON(p->ptrace);
				p->parent = p->real_parent;
			}

			xxx = &p->real_parent->children;
			if (reparent_thread(father, p))
				xxx = &child_dead;
			list_move_tail(&p->sibling, xxx);;
		}
		write_unlock_irq(&tasklist_lock);

		list_for_each_entry_safe(p, n, &child_dead, sibling) {
			list_del_init(&p->sibling);
			release_task(p);
		}
	}

