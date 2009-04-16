Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbZDPO7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbZDPO7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbZDPO7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:59:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35765 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbZDPO7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:59:33 -0400
Date: Thu, 16 Apr 2009 16:54:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rework/fix is_single_threaded()
Message-ID: <20090416145444.GA12884@redhat.com>
References: <20090413214513.GA1119@redhat.com> <14878.1239876272@redhat.com> <20090416133658.GA6532@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416133658.GA6532@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Oleg Nesterov wrote:
>
> Suppose we have a process P which shares ->mm with "task" (the argument), so
> we should return "false".
>
> P does clone(CLONE_VM) and exits. rcu_read_lock() can't guarantee we will
> see the new task with the same ->mm. And without ->mmap_sem P can call
> exit_mm() and set P->mm = NULL.
>
> Hmm. But we can just add a barrier?
>
> 	bool is_single_threaded(struct task_struct *task)
> 	{
> 		struct mm_struct *mm = task->mm;
> 		struct task_struct *p, *t;
> 		bool ret;
>
> 		if (atomic_read(&task->signal->live) != 1)
> 			return false;
>
> 		if (atomic_read(&mm->mm_users) == 1)
> 			return true;
>
> 		ret = false;
> 		rcu_read_lock();
> 		for_each_process(p) {
> 			if (unlikely(p->flags & PF_KTHREAD))
> 				continue;
> 			if (unlikely(p == task->group_leader))
> 				continue;
>
> 			t = p;
> 			do {
> 				if (unlikely(t->mm == mm))
> 					goto found;
> 				if (likely(t->mm))
> 					break;
>
> 				/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> 				   t->mm == NULL. Perhaps it had the same ->mm ?
> 				   If t has forked CLONE_VM task and called exit_mm(),
> 				   make sure next_thread() or for_each_process()->next_task()
> 				   will see it.
> 				   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> 				*/
> 				smp_rmb();

Sorry, forgot to mention...

But what if P does clone(CLONE_VM), exits, and for_each_process/while_each_thread
doesn't see it? IOW, what if we already see the result of list_del_rcu() ?

I think, in that case we must also see the result of clone()->list_add_tail_rcu()
which has a barrier, so we are safe.

Hmm. I feel this all has a simpler explanation, or I missed something...

Oleg.

