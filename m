Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbXCYQu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbXCYQu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXCYQu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:50:29 -0400
Received: from mail.screens.ru ([213.234.233.54]:35892 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbXCYQu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:50:29 -0400
Date: Sun, 25 Mar 2007 19:54:07 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Nick Piggin <npiggin@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       Ingo Molnar <mingo@elte.hu>, Nikita Danilov <nikita@clusterfs.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] queued spinlocks (i386)
Message-ID: <20070325155407.GA497@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am sorry for being completely off-topic, but I've been wondering for the
long time...

What if we replace raw_spinlock_t.slock with "struct task_struct *owner" ?

	void _spin_lock(spinlock_t *lock)
	{
		struct task_struct *owner;

		for (;;) {
			preempt_disable();
			if (likely(_raw_spin_trylock(lock)))
				break;
			preempt_enable();

			while (!spin_can_lock(lock)) {
				rcu_read_lock();
				owner = lock->owner;
				if (owner && current->prio < owner->prio &&
				    !test_tsk_thread_flag(owner, TIF_NEED_RESCHED))
					set_tsk_thread_flag(owner, TIF_NEED_RESCHED);
				rcu_read_unlock();
				cpu_relax();
			}
		}

		lock->owner = current;
	}

	void _spin_unlock(spinlock_t *lock)
	{
		lock->owner = NULL;
		_raw_spin_unlock(lock);
		preempt_enable();
	}

Now we don't need need_lockbreak(lock), need_resched() is enough, and we take
->prio into consideration.

Makes sense? Or stupid?

Oleg.

