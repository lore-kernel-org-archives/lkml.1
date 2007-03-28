Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbXC1HFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbXC1HFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 03:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933727AbXC1HFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 03:05:07 -0400
Received: from mail.suse.de ([195.135.220.2]:56784 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933490AbXC1HFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 03:05:05 -0400
Date: Wed, 28 Mar 2007 09:04:59 +0200
From: Nick Piggin <npiggin@suse.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>, Ingo Molnar <mingo@elte.hu>,
       Nikita Danilov <nikita@clusterfs.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] queued spinlocks (i386)
Message-ID: <20070328070459.GC12508@wotan.suse.de>
References: <20070325155407.GA497@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325155407.GA497@tv-sign.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 07:54:07PM +0400, Oleg Nesterov wrote:
> I am sorry for being completely off-topic, but I've been wondering for the
> long time...
> 
> What if we replace raw_spinlock_t.slock with "struct task_struct *owner" ?
> 
> 	void _spin_lock(spinlock_t *lock)
> 	{
> 		struct task_struct *owner;
> 
> 		for (;;) {
> 			preempt_disable();
> 			if (likely(_raw_spin_trylock(lock)))
> 				break;
> 			preempt_enable();
> 
> 			while (!spin_can_lock(lock)) {
> 				rcu_read_lock();
> 				owner = lock->owner;
> 				if (owner && current->prio < owner->prio &&
> 				    !test_tsk_thread_flag(owner, TIF_NEED_RESCHED))
> 					set_tsk_thread_flag(owner, TIF_NEED_RESCHED);
> 				rcu_read_unlock();
> 				cpu_relax();
> 			}
> 		}
> 
> 		lock->owner = current;
> 	}
> 
> 	void _spin_unlock(spinlock_t *lock)
> 	{
> 		lock->owner = NULL;
> 		_raw_spin_unlock(lock);
> 		preempt_enable();
> 	}
> 
> Now we don't need need_lockbreak(lock), need_resched() is enough, and we take
> ->prio into consideration.
> 
> Makes sense? Or stupid?

Well with my queued spinlocks, all that lockbreak stuff can just come out
of the spin_lock, break_lock out of the spinlock structure, and
need_lockbreak just becomes (lock->qhead - lock->qtail > 1).


