Return-Path: <linux-kernel-owner+w=401wt.eu-S1756426AbZGIVgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbZGIVgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZGIVgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:36:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53613 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbZGIVgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:36:17 -0400
Date: Thu, 9 Jul 2009 23:33:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/2] is_current_single_threaded: don't use
	->mmap_sem
Message-ID: <20090709213300.GA10256@redhat.com>
References: <20090709212849.GA10245@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709212849.GA10245@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09, Oleg Nesterov wrote:
>
> is_current_single_threaded() can safely miss a freshly forked CLONE_VM
> task, but in this case it must not miss its parent. That is why we take
> mm->mmap_sem for writing to make sure a thread/task with the same ->mm
> can't pass exit_mm() and disappear.
>
> However we can avoid ->mmap_sem and rely on rcu/barriers:
>
> 	- if we do not see the exiting parent on thread/process list
> 	  we see the result of list_del_rcu(), in this case we must
> 	  also see the result of list_add_rcu() which does wmb().
>
> 	- if we do see the parent but its ->mm == NULL, we need rmb()
> 	  to make sure we can't miss the child.

To simplify the review, below is the code after the patch.

Oleg.

/*
 * Returns true if the task does not share ->mm with another thread/process.
 */
bool is_current_single_threaded(void)
{
	struct task_struct *task = current;
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
			/*
			 * t->mm == NULL. Make sure next_thread/next_task
			 * will see other CLONE_VM tasks which might be
			 * forked before exiting.
			 */
			smp_rmb();
		} while_each_thread(p, t);
	}
	ret = true;
found:
	rcu_read_unlock();

	return ret;
}

