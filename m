Return-Path: <linux-kernel-owner+w=401wt.eu-S1761703AbZC3VsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761703AbZC3VsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760767AbZC3VsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:48:13 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:45691 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbZC3VsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:48:12 -0400
Message-ID: <49D13DDB.7010302@cosmosbay.com>
Date: Mon, 30 Mar 2009 23:47:07 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Darren Hart <dvhltc@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [tip PATCH v6 8/8] RFC: futex: add requeue_pi calls
References: <20090330213306.606.9540.stgit@Aeon> <20090330213840.606.59261.stgit@Aeon>
In-Reply-To: <20090330213840.606.59261.stgit@Aeon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 30 Mar 2009 23:47:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart a écrit :
> PI Futexes and their underlying rt_mutex cannot be left ownerless if there are
> pending waiters as this will break the PI boosting logic, so the standard
> requeue commands aren't sufficient.  The new commands properly manage pi futex
> ownership by ensuring a futex with waiters has an owner at all times.  This
> will allow glibc to properly handle pi mutexes with pthread_condvars.
> 
> The approach taken here is to create two new futex op codes:
> 
> FUTEX_WAIT_REQUEUE_PI:
> Tasks will use this op code to wait on a futex (such as a non-pi waitqueue)
> and wake after they have been requeued to a pi futex.  Prior to returning to
> userspace, they will acquire this pi futex (and the underlying rt_mutex).
> 
> futex_wait_requeue_pi() is the result of a high speed collision between
> futex_wait() and futex_lock_pi() (with the first part of futex_lock_pi() being
> done by futex_proxy_trylock_atomic() on behalf of the top_waiter).
> 
> FUTEX_REQUEUE_PI (and FUTEX_CMP_REQUEUE_PI):
> This call must be used to wake tasks waiting with FUTEX_WAIT_REQUEUE_PI,
> regardless of how many tasks the caller intends to wake or requeue.
> pthread_cond_broadcast() should call this with nr_wake=1 and
> nr_requeue=INT_MAX.  pthread_cond_signal() should call this with nr_wake=1 and
> nr_requeue=0.  The reason being we need both callers to get the benefit of the
> futex_proxy_trylock_atomic() routine.  futex_requeue() also enqueues the
> top_waiter on the rt_mutex via rt_mutex_start_proxy_lock().
> 
> Changelog:
> V6: -Moved non requeue_pi related fixes/changes into separate patches
>     -Make use of new double_unlock_hb()
>     -Futex key management updates
>     -Removed unnecessary futex_requeue_pi_cleanup() routine
>     -Return -EINVAL if futex_wake is called with q.rt_waiter != NULL
>     -Rewrote futex_wait_requeue_pi() wakeup logic
>     -Rewrote requeue/wakeup loop
>     -Renamed futex_requeue_pi_init() to futex_proxy_trylock_atomic()
>     -Handle third party owner, removed -EMORON :-(
>     -Comment updates
> V5: -Update futex_requeue to allow for nr_requeue == 0
>     -Whitespace cleanup
>     -Added task_count var to futex_requeue to avoid confusion between
>      ret, res, and ret used to count wakes and requeues
> V4: -Cleanups to pass checkpatch.pl
>     -Added missing goto out; in futex_wait_requeue_pi()
>     -Moved rt_mutex_handle_wakeup to the rt_mutex_enqueue_task patch as they
>      are a functional pair.
>     -Fixed several error exit paths that failed to unqueue the futex_q, which
>      not only would leave the futex_q on the hb, but would have caused an exit
>      race with the waiter since they weren't synchonized on the hb lock.  Thanks
>      Sripathi for catching this.
>     -Fix pi_state handling in futex_requeue
>     -Several other minor fixes to futex_requeue_pi
>     -add requeue_futex function and force the requeue in requeue_pi even for the
>      task we wake in the requeue loop
>     -refill the pi state cache at the beginning of futex_requeue for requeue_pi
>     -have futex_requeue_pi_init ensure it stores off the pi_state for use in
>      futex_requeue
>     - Delayed starting the hrtimer until after TASK_INTERRUPTIBLE is set
>     - Fixed NULL pointer bug when futex_wait_requeue_pi() has no timer and
>       receives a signal after waking on uaddr2.  Added has_timeout to the
>       restart->futex structure.
> V3: -Added FUTEX_CMP_REQUEUE_PI op
>     -Put fshared support back.  So long as it is encoded in the op code, we
>      assume both the uaddr's are either private or share, but not mixed.
>     -Fixed access to expected value of uaddr2 in futex_wait_requeue_pi()
> V2: -Added rt_mutex enqueueing to futex_requeue_pi_init
>     -Updated fault handling and exit logic
> V1: -Initial verion
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sripathi Kodi <sripathik@in.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Dinakar Guniguntala <dino@in.ibm.com>
> Cc: Ulrich Drepper <drepper@redhat.com>
> Cc: Eric Dumazet <dada1@cosmosbay.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jakub Jelinek <jakub@redhat.com>
> ---
> 
>  include/linux/futex.h       |    8 +
>  include/linux/thread_info.h |    3 
>  kernel/futex.c              |  533 +++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 524 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/futex.h b/include/linux/futex.h
> index 3bf5bb5..b05519c 100644
> --- a/include/linux/futex.h
> +++ b/include/linux/futex.h
> +static long futex_lock_pi_restart(struct restart_block *restart)
> +{
> +	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
> +	ktime_t t, *tp = NULL;
> +	int fshared = restart->futex.flags & FLAGS_SHARED;
> +
> +	if (restart->futex.flags | FLAGS_HAS_TIMEOUT) {

if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {

> +		t.tv64 = restart->futex.time;
> +		tp = &t;
> +	}
> +	restart->fn = do_no_restart_syscall;
> +
> +	return (long)futex_lock_pi(uaddr, fshared, restart->futex.val, tp, 0);
> +}
>  
>  /*
>   * Userspace attempted a TID -> 0 atomic transition, and failed.
> @@ -1772,6 +1968,290 @@ pi_faulted:
>  	return ret;
>  }
>  

> +
> +static long futex_wait_requeue_pi_restart(struct restart_block *restart)
> +{
> +	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
> +	u32 __user *uaddr2 = (u32 __user *)restart->futex.uaddr2;
> +	int fshared = restart->futex.flags & FLAGS_SHARED;
> +	int clockrt = restart->futex.flags & FLAGS_CLOCKRT;
> +	ktime_t t, *tp = NULL;
> +
> +	if (restart->futex.flags | FLAGS_HAS_TIMEOUT) {

if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {

> +		t.tv64 = restart->futex.time;
> +		tp = &t;
> +	}
> +	restart->fn = do_no_restart_syscall;
> +


Strange your compiler dit not complains...

