Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbZJEWW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbZJEWW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZJEWW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:22:28 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:41589 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124AbZJEWW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:22:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAMcIykpMROOX/2dsb2JhbACBUtBvgiiCAgQ
Date: Mon, 5 Oct 2009 18:21:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Michael Schnell <mschnell@lumino.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Userspace RCU: (ab)using futexes to save cpu cycles and
	energy
Message-ID: <20091005222149.GB21419@Krystal>
References: <20090923174820.GA12827@Krystal> <20091001144037.GB6205@linux.vnet.ibm.com> <20091004143745.GA19785@Krystal> <4AC99D55.8000102@lumino.de> <20091005125533.GA1857@Krystal> <20091005132236.GA7416@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091005132236.GA7416@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:10:33 up 48 days,  9:00,  3 users,  load average: 0.84, 0.51,
	0.31
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> (added some CC's, given the length of the answer. Thanks for asking)  ;)
> (Sorry for duplicate, messed up LKML email in original post)
> 
> * Michael Schnell (mschnell@lumino.de) wrote:
> > I still don't understand what the advantage of FUTEX is, if the thread
> > to be waked is always blocked, and thus the fast path is not in use.
> > 
> > -Michael
> 
> Hrm, your assumption about the common case does not seem to fit my
> scenarios. Typically, the wakeup will find the waiter not blocked, and
> thus skip the call to sys_futex. Here is why.
> 
> I use this scheme in two different implementations:
> 
> 1) in call_rcu(), to wake up the worker thread after adding work to the
> queue.
> 
> This worker thread, when woken up, sleeps for a few milliseconds before
> starting to dequeue work. Therefore, if the system is relatively busy,
> call_rcu() will usually see the worker thread while it's sleeping (and
> therefore _not_ waiting on the futex). Also, if work is enqueued while
> the worker thread is executing past RCU callbacks, the worker thread
> will detect it and won't wait on the futex.
> 
> Therefore, this is, by design, a very unlikely event to have call_rcu()
> calling sys_futex.
> 
> 2) in rcu_read_unlock(), to wake up synchronize_rcu() waiting on past
>    reader's grace periods.
> 
> Here, synchronize_rcu() busy-waits for the reader's G.P. to end, and if
> this does not work, after a few attempts (like the pthread mutexes), it
> adapts and uses sys_futex. The waker only need to call sys_futex if
> there is a synchronize_rcu() currently running which had to call
> sys_futex after a few active attempts failed.
> 
> As you see, in both cases, the common case, "fast path", is to find the
> futex unlocked and not having to take any lock.
> 
> 
> Now, about the slow path. I think it's worth discussing too. Indeed,
> sys_futex takes a per-address spinlock, which happens to serialize all
> sys_futex operations on the wakeup side. Therefore, for wakeup designs
> relying on calling sys_futex for wakeup very frequently, this is really
> bad.
> 
> There might be ways to mitigate this problem though: changing the
> sys_futex implementation to use lock-free lists might help.
> 
> One advantage of calling sys_futex without holding a userspace mutex is
> that the contention duration on the per-address spinlock is much shorter
> than the contention on the mutex, because of the system call execution
> overhead.
> 
> We could probably turn the sys_futex-dependent locking scheme into
> something more portable and manage to keep the same fast-path behavior
> if we replace the way I use sys_futex by a pthread cond var, e.g. :
> 
> Instead of having:
> 
> 
> static inline void wake_up_gp(void)
> {
>         if (unlikely(uatomic_read(&gp_futex) == -1)) {
>                 uatomic_set(&gp_futex, 0);
>                 futex(&gp_futex, FUTEX_WAKE, 1,
>                       NULL, NULL, 0);
>         }
> }
> 
> static void wait_gp(void)
> {
> 	uatomic_dec(&gp_futex);
>         smp_mb();
> 	if (!num_old_reader_gp()) {
>         	smp_mb();
> 		atomic_set(&gp_futex, 0);
> 		return;
> 	}
>         /* Read reader_gp before read futex */
>         smp_rmb();
>         if (uatomic_read(&gp_futex) == -1)
>                 futex(&gp_futex, FUTEX_WAIT, -1,
>                       NULL, NULL, 0);
> }
> 
> We could have:
> 
> static inline void wake_up_gp(void)
> {
> 	/* just released old reader gp */
> 	smp_mb();
>         if (unlikely(uatomic_read(&gp_wait) == -1)) {
>                 uatomic_set(&gp_wait, 0);
>                 pthread_cond_broadcast(&rcucond);
>         }
> }
> 
> static void wait_gp(void)
> {
> 	uatomic_dec(&gp_wait);
>         smp_mb();
> 	if (!num_old_reader_gp()) {
>         	smp_mb();
> 		atomic_set(&gp_wait, 0);
> 		goto unlock;
> 	}
>         /* Read reader_gp before read futex */
>         smp_rmb();
> 	pthread_mutex_lock(&rcumutex);
>         if (uatomic_read(&gp_wait) == -1) {
>                 pthread_cond_wait(&rcucond, &rcumutex);
> 		pthread_mutex_unlock(&rcumutex);
> 	}
> }
> 
> Is that what you had in mind ?
> 

Hrm, thinking about it, the pthread_cond_wait/pthread_cond_broadcast
scheme I proposed above is racy.

If a wait_gp executes concurrently with wake_up_gp, we can end up doing:

gp_wait = 0

*    wait_gp:       uatomic_dec(&gp_wait);
*    wait_gp:       smp_mb()
*    wait_gp:       if (!num_old_reader_gp()) { (false)
*    wait_gp:       pthread_mutex_lock(&rcumutex);
*    wait_gp:       if (uatomic_read(&gp_wait) == -1) { (true)
* wake_up_gp:  unlikely(uatomic_read(&gp_wait) == -1) { (true)
* wake_up_gp:  uatomic_set(&gp_wait, 0);
* wait_up_gp:  pthread_cond_broadcast(&rcucond);
*    wait_gp:       pthread_cond_wait(&rcucond, &rcumutex);

might wait forever (or until the next wakeup).

We would need an extra mutex in the wakeup, e.g.:

static inline void wake_up_gp(void)
{
	/* just released old reader gp */
	smp_mb();
        if (unlikely(uatomic_read(&gp_wait) == -1)) {
		pthread_mutex_lock(&rcumutex);
                uatomic_set(&gp_wait, 0);
                pthread_cond_broadcast(&rcucond);
		pthread_mutex_unlock(&rcumutex);
        }
}

static void wait_gp(void)
{
	uatomic_dec(&gp_wait);
        smp_mb();
	if (!num_old_reader_gp()) {
        	smp_mb();
		atomic_set(&gp_wait, 0);
		goto unlock;
	}
        /* Read reader_gp before read futex */
        smp_rmb();
	pthread_mutex_lock(&rcumutex);
        if (uatomic_read(&gp_wait) == -1) {
                pthread_cond_wait(&rcucond, &rcumutex);
		pthread_mutex_unlock(&rcumutex);
	}
}

This should work better, but I'll need to do a formal model to convince
myself.

Mathieu

> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
