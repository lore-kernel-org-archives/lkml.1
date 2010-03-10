Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab0CJIg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:36:26 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60322 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab0CJIgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:36:22 -0500
Message-ID: <4B975A00.3090404@dcl.info.waseda.ac.jp>
Date: Wed, 10 Mar 2010 17:36:16 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>
Subject: Re: Question about policy of calling lockdep functions in trylocks
References: <4B8CCFFC.2020704@dcl.info.waseda.ac.jp> <1267521211.25158.13.camel@laptop> <4B8D15F8.9010306@dcl.info.waseda.ac.jp>
In-Reply-To: <4B8D15F8.9010306@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/10 22:43, Hitoshi Mitake wrote:
 > On 03/02/10 18:13, Peter Zijlstra wrote:
 >> On Tue, 2010-03-02 at 17:44 +0900, Hitoshi Mitake wrote:
 >>> Hi,
 >>>
 >>> I have a question about policy of callings lockdep functions in
 >>> trylocks.
 >>>
 >>> Normal locks like __raw_spin_lock are defined like this:
 >>>
 >>> static inline void __raw_spin_lock(raw_spinlock_t *lock)
 >>> {
 >>> preempt_disable();
 >>> spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 >>> LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 >>> }
 >>>
 >>> And LOCK_CONTENDED is defined:
 >>> #define LOCK_CONTENDED(_lock, try, lock) \
 >>> do { \
 >>> if (!try(_lock)) { \
 >>> lock_contended(&(_lock)->dep_map, _RET_IP_); \
 >>> lock(_lock); \
 >>> } \
 >>> lock_acquired(&(_lock)->dep_map, _RET_IP_); \
 >>> } while (0)
 >>>
 >>> So, acquiring and releasing lock with no contention calls lockdep
 >>> functions like this:
 >>>
 >>> lock_acquire -> lock_acquired -> lock_release
 >>>
 >>> And acquiring and releasing lock with contention calls lockdep 
functions
 >>> like this:
 >>>
 >>> lock_acquire -> lock_contended -> lock_acquired -> lock_release
 >>>
 >>> But I found that locks with try like __raw_spin_trylock is defined like
 >>> this:
 >>>
 >>> static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 >>> {
 >>> preempt_disable();
 >>> if (do_raw_spin_trylock(lock)) {
 >>> spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 >>> return 1;
 >>> }
 >>> preempt_enable();
 >>> return 0;
 >>> }
 >>>
 >>> So, trying acquiring and releasing lock with no contention calls 
lockdep
 >>> functions like this:
 >>>
 >>> lock_acquire -> lock_release
 >>>
 >>> And failed trying acquiring calls no lockdep function.
 >>>
 >>> I felt that policy of calling lockdep functions is strange.
 >>> Trylocks should be like this:
 >>>
 >>> static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 >>> {
 >>> preempt_disable();
 >>> spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 >>> if (do_raw_spin_trylock(lock)) {
 >>> spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 >>> lock_acquired(&lock->dep_map, _RET_IP_);
 >>> return 1;
 >>> }
 >>> lock_contended(&lock->dep_map, _RET_IP_);
 >>> preempt_enable();
 >>> return 0;
 >>> }
 >>
 >> Did you mean to call acquire twice?
 >
 > Sorry, this is my mistake.
 > I've forgot to remove spin_acquire() after do_raw_spin_trylock().
 >
 >>
 >>>
 >>> This is my question.
 >>> Are there some reasons current calling lockdep functions of trylocks?
 >>> If not, can I change these trylocks like I described above?
 >>>
 >>> The reason why I'm asking about it is perf lock.
 >>> For state machine of perf lock, these event sequenses are very
 >>> confusable.
 >>> Because sequence of trylock is subset of normal lock. This is 
ambiguity.
 >>
 >> Well, trylocks cannot contend, so the lock_contended() call doesn't make
 >> sense, I don't think it will confuse lockstat, since acquire will simply
 >> reset the state again, but it will waste cycles, nor is there a reason
 >> to call acquired without first having call contended. So no.
 >>
 >> What exactly is the problem, the lack of callbacks for a failed trylock?
 >> Why would you want one?
 >>
 >> Because other than that I see no problem, you get an acquire(.try=1) and
 >> a release() to match and lockstat measure and accounts the hold-time.
 >
 > Ah, I've forgot about try and read parameters of lock_acquire().
 > These parameters are enough things for me.
 > perf lock can separate event sequences of normal locks and trylocks with
 > these.
 >

Sorry, I have another suggestion.

Some subsystems of kernel use functions of lockdep such as lock_acquire()
only for lockdep_map objects without actual locks.
e.g. rcu_read_lock() of RCU: Frederic did lots of work on recursion of 
this function.

It seems that they are using functions of lockdep purely for validation 
of dependency.
These are not actual locks. But produces trace events of locks,
and lockdep calculates their holded time (in /proc/lock_stats).

I think this situation is not so good.
Because
  * overhead of validation is equal to sum of ones of validation and 
holdtime,
  * overhead of holdtime is equal to sum of ones of validation and holdtime,
  * and overhead of tracing lock events is equal to sum of ones of 
validation, holdtime and tracing :(

So I'd like to suggest that separating these features.

The way is like this,
  1) current struct of locks are holding lockdep_map,
     changing this lockdep_map to more general structure.
     (Temporary, I'd like to call it "struct lock_monitor")

  2) Rename current functions of lockdep.
     e.g. lock_acquire() -> lockdep_acquire()

  3) Prepare more general functions for hooking lock events,
     void lock_acquire(struct lockdep_map *lock, ...)
      ->
       void lock_acquire(struct lock_monitor *lock, ...)

New lock_acquire() should call hook functions
of validation, holdtime and tracing.
If so, overhead of each features can be separated.

There are at least 3 requested features related to analyzing lock,
  * validation ... what lockdep does
  * in kernel histogram ... more rich /proc/lock_stat, Jason Baron may 
be interested in this
  * tracing and analyzing ... what perf lock wants to do
So I think this is worth to do.

I'm doing it (not finished yet), and noticed that
patch series for this will be very big one.
Because many lockdep users are in kernel here and there.

So I'd like to ask your opinion before implementing and posting, Peter.
How do you think?

Thanks,
	Hitoshi
