Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab0CBIor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:44:47 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:56251 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab0CBIoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:44:46 -0500
Message-ID: <4B8CCFFC.2020704@dcl.info.waseda.ac.jp>
Date: Tue, 02 Mar 2010 17:44:44 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Question about policy of calling lockdep functions in trylocks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I have a question about policy of callings lockdep functions in trylocks.

Normal locks like __raw_spin_lock are defined like this:

static inline void __raw_spin_lock(raw_spinlock_t *lock)
{
	preempt_disable();
	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
}

And LOCK_CONTENDED is defined:
#define LOCK_CONTENDED(_lock, try, lock)			\
do {								\
	if (!try(_lock)) {					\
		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
		lock(_lock);					\
	}							\
	lock_acquired(&(_lock)->dep_map, _RET_IP_);			\
} while (0)

So, acquiring and releasing lock with no contention calls lockdep
functions like this:

     lock_acquire -> lock_acquired -> lock_release

And acquiring and releasing lock with contention calls lockdep functions
like this:

     lock_acquire -> lock_contended -> lock_acquired -> lock_release

But I found that locks with try like __raw_spin_trylock is defined like
this:

static inline int __raw_spin_trylock(raw_spinlock_t *lock)
{
	preempt_disable();
	if (do_raw_spin_trylock(lock)) {
		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
		return 1;
	}
	preempt_enable();
	return 0;
}

So, trying acquiring and releasing lock with no contention calls lockdep
functions like this:

     lock_acquire -> lock_release

And failed trying acquiring calls no lockdep function.

I felt that policy of calling lockdep functions is strange.
Trylocks should be like this:

static inline int __raw_spin_trylock(raw_spinlock_t *lock)
{
	preempt_disable();
	spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
	if (do_raw_spin_trylock(lock)) {
		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
		lock_acquired(&lock->dep_map, _RET_IP_);
		return 1;
	}
	lock_contended(&lock->dep_map, _RET_IP_);
	preempt_enable();
	return 0;
}

This is my question.
Are there some reasons current calling lockdep functions of trylocks?
If not, can I change these trylocks like I described above?

The reason why I'm asking about it is perf lock.
For state machine of perf lock, these event sequenses are very confusable.
Because sequence of trylock is subset of normal lock. This is ambiguity.

Thanks,
	Hitoshi
