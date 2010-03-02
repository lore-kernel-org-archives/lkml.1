Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab0CBJNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:13:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab0CBJNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:13:36 -0500
Subject: Re: Question about policy of calling lockdep functions in trylocks
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B8CCFFC.2020704@dcl.info.waseda.ac.jp>
References: <4B8CCFFC.2020704@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 10:13:31 +0100
Message-ID: <1267521211.25158.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 17:44 +0900, Hitoshi Mitake wrote:
> Hi,
> 
> I have a question about policy of callings lockdep functions in trylocks.
> 
> Normal locks like __raw_spin_lock are defined like this:
> 
> static inline void __raw_spin_lock(raw_spinlock_t *lock)
> {
> 	preempt_disable();
> 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
> 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
> }
> 
> And LOCK_CONTENDED is defined:
> #define LOCK_CONTENDED(_lock, try, lock)			\
> do {								\
> 	if (!try(_lock)) {					\
> 		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
> 		lock(_lock);					\
> 	}							\
> 	lock_acquired(&(_lock)->dep_map, _RET_IP_);			\
> } while (0)
> 
> So, acquiring and releasing lock with no contention calls lockdep
> functions like this:
> 
>      lock_acquire -> lock_acquired -> lock_release
> 
> And acquiring and releasing lock with contention calls lockdep functions
> like this:
> 
>      lock_acquire -> lock_contended -> lock_acquired -> lock_release
> 
> But I found that locks with try like __raw_spin_trylock is defined like
> this:
> 
> static inline int __raw_spin_trylock(raw_spinlock_t *lock)
> {
> 	preempt_disable();
> 	if (do_raw_spin_trylock(lock)) {
> 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
> 		return 1;
> 	}
> 	preempt_enable();
> 	return 0;
> }
> 
> So, trying acquiring and releasing lock with no contention calls lockdep
> functions like this:
> 
>      lock_acquire -> lock_release
> 
> And failed trying acquiring calls no lockdep function.
> 
> I felt that policy of calling lockdep functions is strange.
> Trylocks should be like this:
> 
> static inline int __raw_spin_trylock(raw_spinlock_t *lock)
> {
> 	preempt_disable();
> 	spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
> 	if (do_raw_spin_trylock(lock)) {
> 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
> 		lock_acquired(&lock->dep_map, _RET_IP_);
> 		return 1;
> 	}
> 	lock_contended(&lock->dep_map, _RET_IP_);
> 	preempt_enable();
> 	return 0;
> }

Did you mean to call acquire twice?

> 
> This is my question.
> Are there some reasons current calling lockdep functions of trylocks?
> If not, can I change these trylocks like I described above?
> 
> The reason why I'm asking about it is perf lock.
> For state machine of perf lock, these event sequenses are very confusable.
> Because sequence of trylock is subset of normal lock. This is ambiguity.

Well, trylocks cannot contend, so the lock_contended() call doesn't make
sense, I don't think it will confuse lockstat, since acquire will simply
reset the state again, but it will waste cycles, nor is there a reason
to call acquired without first having call contended. So no.

What exactly is the problem, the lack of callbacks for a failed trylock?
Why would you want one?

Because other than that I see no problem, you get an acquire(.try=1) and
a release() to match and lockstat measure and accounts the hold-time.





