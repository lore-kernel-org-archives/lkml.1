Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbZDPNlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbZDPNlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZDPNlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:41:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40032 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZDPNln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:41:43 -0400
Date: Thu, 16 Apr 2009 15:36:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rework/fix is_single_threaded()
Message-ID: <20090416133658.GA6532@redhat.com>
References: <20090413214513.GA1119@redhat.com> <14878.1239876272@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14878.1239876272@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > - Fix the comment, is_single_threaded(p) actually means that nobody shares
> >   ->mm with p.
> >
> >   I think this helper should be renamed,
>
> What we want to know when we ask this function is whether or not a process is
> single-threaded, hence the name.  The fact that because:
>
> 	CLONE_THREAD => CLONE_SIGHAND => CLONE_VM
>
> we can work this out purely by checking that there aren't any processes that
> share VM space with us is immaterial.

Confused... I already asked this in http://marc.info/?t=123853355800001
"what is_single_threaded() does?" and perhaps I misunderstood you.

So, once again, what it should do? If we only care about CLONE_THREAD (implies
CLONE_VM), then we can just do

	bool is_single_threaded(struct task_struct *p)
	{
		return atomic_read(&p->signal->live) == 1;
	}

But, if it should check p doesn't share VM space (this is what it does
with or without the patch), then we have to scan all processes.

> > and it should not have arguments.  With or without this patch it must not be
> > used unless p == current, otherwise we can't safely use p->signal or p->mm.
>
> Well, I can live with that, but you need to check with the SELinux people too.
> Whilst they do currently limit the selinux_setprocattr() to current only, they
> still hand the task pointer that function is given around.

Yes, I see. But (apart from "not safe" above), from the security pov it doesn't
make sense to call is_single_threaded(p) unless p == current ? The task can
fork right after the check.

> > - Use down_write(mm->mmap_sem) + rcu_read_lock() instead of tasklist_lock
> >   to iterate over the process list. If there is another CLONE_VM process
> >   it can't pass exit_mm() which takes the same mm->mmap_sem. We can miss
> >   a freshly forked CLONE_VM task, but this doesn't matter because we must
> >   see its parent and return false.
>
> Hmmm...  I'd quite like to avoid using down_write() if possible.

Cough. And I'd like to avoid taking tasklist_lock as much as possible ;)
tasklist is the global and overused lock. Not good to take it to scan the
process list.

> Why do we
> need to do this?  Is it just to stop processes that might cease using mm from
> doing so until we've finished?

Suppose we have a process P which shares ->mm with "task" (the argument), so
we should return "false".

P does clone(CLONE_VM) and exits. rcu_read_lock() can't guarantee we will
see the new task with the same ->mm. And without ->mmap_sem P can call
exit_mm() and set P->mm = NULL.

Hmm. But we can just add a barrier?

	bool is_single_threaded(struct task_struct *task)
	{
		struct mm_struct *mm = task->mm;
		struct task_struct *p, *t;
		bool ret;

		if (atomic_read(&task->signal->live) != 1)
			return false;

		if (atomic_read(&mm->mm_users) == 1)
			return true;

		ret = false;
		rcu_read_lock();
		for_each_process(p) {
			if (unlikely(p->flags & PF_KTHREAD))
				continue;
			if (unlikely(p == task->group_leader))
				continue;

			t = p;
			do {
				if (unlikely(t->mm == mm))
					goto found;
				if (likely(t->mm))
					break;

				/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				   t->mm == NULL. Perhaps it had the same ->mm ?
				   If t has forked CLONE_VM task and called exit_mm(),
				   make sure next_thread() or for_each_process()->next_task()
				   will see it.
				   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				*/
				smp_rmb();

			} while_each_thread(p, t);
		}
		ret = true;
	found:
		rcu_read_unlock();

		return ret;
	}

What do you think?

Oleg.

