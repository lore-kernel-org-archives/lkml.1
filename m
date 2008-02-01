Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbYBAPST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbYBAPST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYBAPSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:18:12 -0500
Received: from www.tglx.de ([62.245.132.106]:37231 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbYBAPSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:18:11 -0500
Date: Fri, 1 Feb 2008 16:16:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Toyo Abe <toyoa@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] hrtimer_nanosleep: fix *rmtp handling
In-Reply-To: <20080201142905.GA25833@tv-sign.ru>
Message-ID: <alpine.LFD.1.00.0802011616000.9204@apollo.tec.linutronix.de>
References: <20080201133758.GA25623@tv-sign.ru> <20080201142905.GA25833@tv-sign.ru>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Oleg Nesterov wrote:

> (Andrew, the same patch, but re-diffed without the first one in series).

I pick them up and feed them through hrtimer.git, once all bugs are
shaken out :)

Thanks,
	tglx 

> [PATCH 2/5] hrtimer_nanosleep: fix *rmtp handling
> 
> Spotted by Pavel Emelyanov and Alexey Dobriyan.
> 
> hrtimer_nanosleep() sets restart_block->arg1 = rmtp, but this rmtp points to
> the local variable which lives in the caller's stack frame. This means that
> if sys_restart_syscall() actually happens and it is interrupted as well, we
> don't update the user-space variable, but write into the already dead stack
> frame.
> 
> Change the callers to pass "__user *rmtp" to hrtimer_nanosleep(), and change
> hrtimer_nanosleep() to use copy_to_user() to actually update *rmtp.
> 
> Small problem remains. man 2 nanosleep states that *rtmp should be written if
> nanosleep() was interrupted (it says nothing whether it is OK to update *rmtp
> if nanosleep returns 0), but (with or without this patch) we can dirty *rem
> even if nanosleep() returns 0.
> 
> NOTE: this patch doesn't change compat_sys_nanosleep(), because it has other
> bugs. Fixed by the next patch.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
>  include/linux/hrtimer.h |    2 -
>  kernel/hrtimer.c        |   51 +++++++++++++++++++++++++-----------------------
>  kernel/posix-timers.c   |   14 +------------
>  3 files changed, 30 insertions(+), 37 deletions(-)
> 
> --- MM/include/linux/hrtimer.h~HRT_RMTP	2008-01-27 17:07:39.000000000 +0300
> +++ MM/include/linux/hrtimer.h	2008-01-31 14:01:53.000000000 +0300
> @@ -313,7 +313,7 @@ static inline u64 hrtimer_forward_now(st
>  
>  /* Precise sleep: */
>  extern long hrtimer_nanosleep(struct timespec *rqtp,
> -			      struct timespec *rmtp,
> +			      struct timespec __user *rmtp,
>  			      const enum hrtimer_mode mode,
>  			      const clockid_t clockid);
>  extern long hrtimer_nanosleep_restart(struct restart_block *restart_block);
> --- MM/kernel/hrtimer.c~HRT_RMTP	2008-02-01 13:43:52.000000000 +0300
> +++ MM/kernel/hrtimer.c	2008-02-01 13:56:44.000000000 +0300
> @@ -1317,11 +1317,26 @@ static int __sched do_nanosleep(struct h
>  	return t->task == NULL;
>  }
>  
> +static int update_rmtp(struct hrtimer *timer, struct timespec __user *rmtp)
> +{
> +	struct timespec rmt;
> +	ktime_t rem;
> +
> +	rem = ktime_sub(timer->expires, timer->base->get_time());
> +	if (rem.tv64 <= 0)
> +		return 0;
> +	rmt = ktime_to_timespec(rem);
> +
> +	if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
> +		return -EFAULT;
> +
> +	return 1;
> +}
> +
>  long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
>  {
>  	struct hrtimer_sleeper t;
> -	struct timespec *rmtp;
> -	ktime_t time;
> +	struct timespec __user  *rmtp;
>  
>  	restart->fn = do_no_restart_syscall;
>  
> @@ -1331,12 +1346,11 @@ long __sched hrtimer_nanosleep_restart(s
>  	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
>  		return 0;
>  
> -	rmtp = (struct timespec *)restart->arg1;
> +	rmtp = (struct timespec __user *)restart->arg1;
>  	if (rmtp) {
> -		time = ktime_sub(t.timer.expires, t.timer.base->get_time());
> -		if (time.tv64 <= 0)
> -			return 0;
> -		*rmtp = ktime_to_timespec(time);
> +		int ret = update_rmtp(&t.timer, rmtp);
> +		if (ret <= 0)
> +			return ret;
>  	}
>  
>  	restart->fn = hrtimer_nanosleep_restart;
> @@ -1345,12 +1359,11 @@ long __sched hrtimer_nanosleep_restart(s
>  	return -ERESTART_RESTARTBLOCK;
>  }
>  
> -long hrtimer_nanosleep(struct timespec *rqtp, struct timespec *rmtp,
> +long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
>  		       const enum hrtimer_mode mode, const clockid_t clockid)
>  {
>  	struct restart_block *restart;
>  	struct hrtimer_sleeper t;
> -	ktime_t rem;
>  
>  	hrtimer_init(&t.timer, clockid, mode);
>  	t.timer.expires = timespec_to_ktime(*rqtp);
> @@ -1362,10 +1375,9 @@ long hrtimer_nanosleep(struct timespec *
>  		return -ERESTARTNOHAND;
>  
>  	if (rmtp) {
> -		rem = ktime_sub(t.timer.expires, t.timer.base->get_time());
> -		if (rem.tv64 <= 0)
> -			return 0;
> -		*rmtp = ktime_to_timespec(rem);
> +		int ret = update_rmtp(&t.timer, rmtp);
> +		if (ret <= 0)
> +			return ret;
>  	}
>  
>  	restart = &current_thread_info()->restart_block;
> @@ -1381,8 +1393,7 @@ long hrtimer_nanosleep(struct timespec *
>  asmlinkage long
>  sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
>  {
> -	struct timespec tu, rmt;
> -	int ret;
> +	struct timespec tu;
>  
>  	if (copy_from_user(&tu, rqtp, sizeof(tu)))
>  		return -EFAULT;
> @@ -1390,15 +1401,7 @@ sys_nanosleep(struct timespec __user *rq
>  	if (!timespec_valid(&tu))
>  		return -EINVAL;
>  
> -	ret = hrtimer_nanosleep(&tu, rmtp ? &rmt : NULL, HRTIMER_MODE_REL,
> -				CLOCK_MONOTONIC);
> -
> -	if (ret && rmtp) {
> -		if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
> -			return -EFAULT;
> -	}
> -
> -	return ret;
> +	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
>  }
>  
>  /*
> --- MM/kernel/posix-timers.c~HRT_RMTP	2008-01-27 17:07:40.000000000 +0300
> +++ MM/kernel/posix-timers.c	2008-02-01 13:18:51.000000000 +0300
> @@ -982,20 +982,10 @@ sys_clock_getres(const clockid_t which_c
>  static int common_nsleep(const clockid_t which_clock, int flags,
>  			 struct timespec *tsave, struct timespec __user *rmtp)
>  {
> -	struct timespec rmt;
> -	int ret;
> -
> -	ret = hrtimer_nanosleep(tsave, rmtp ? &rmt : NULL,
> +	return hrtimer_nanosleep(tsave, rmtp,
>  				flags & TIMER_ABSTIME ?
> -				HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
> +					HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
>  				which_clock);
> -
> -	if (ret && rmtp) {
> -		if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
> -			return -EFAULT;
> -	}
> -
> -	return ret;
>  }
>  
>  asmlinkage long
> 
