Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZEUD46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZEUD46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 23:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbZEUD4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 23:56:50 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33605 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZEUD4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 23:56:49 -0400
Message-ID: <4A14D0FF.60202@us.ibm.com>
Date: Wed, 20 May 2009 20:56:47 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip-core tree with Linus' tree
References: <20090521113902.3deb5031.sfr@canb.auug.org.au>
In-Reply-To: <20090521113902.3deb5031.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip-core tree got a conflict in
> kernel/futex.c between commit 64d1304a64477629cb16b75491a77bafe6f86963
> ("futex: setup writeable mapping for futex ops which modify user space
> data") from Linus' tree and a couple of commits from the tip-core tree.
> 
> I fixed it up (see below - but please check in particular, I have no idea
> if the call to get_futex_key() in futex_wait_requeue_pi() should take
> VERIFY_READ or VERIFY_WRITE).
> 
> I can carry this fixup as necessary.

I suspect Thomas will be catching that up in the next day or so in tip
(or I can).  If you need something now, the uaddr is VERIFY_READ and
uaddr2 is VERIFY_WRITE.  See below...

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc kernel/futex.c
> index d546b2d,0c406a3..0000000
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@@ -813,13 -1092,43 +1094,43 @@@ static int futex_requeue(u32 __user *ua
>   	struct futex_hash_bucket *hb1, *hb2;
>   	struct plist_head *head1;
>   	struct futex_q *this, *next;
> - 	int ret, drop_count = 0;
> + 	u32 curval2;
> + 
> + 	if (requeue_pi) {
> + 		/*
> + 		 * requeue_pi requires a pi_state, try to allocate it now
> + 		 * without any locks in case it fails.
> + 		 */
> + 		if (refill_pi_state_cache())
> + 			return -ENOMEM;
> + 		/*
> + 		 * requeue_pi must wake as many tasks as it can, up to nr_wake
> + 		 * + nr_requeue, since it acquires the rt_mutex prior to
> + 		 * returning to userspace, so as to not leave the rt_mutex with
> + 		 * waiters and no owner.  However, second and third wake-ups
> + 		 * cannot be predicted as they involve race conditions with the
> + 		 * first wake and a fault while looking up the pi_state.  Both
> + 		 * pthread_cond_signal() and pthread_cond_broadcast() should
> + 		 * use nr_wake=1.
> + 		 */
> + 		if (nr_wake != 1)
> + 			return -EINVAL;
> + 	}
>   
>   retry:
> + 	if (pi_state != NULL) {
> + 		/*
> + 		 * We will have to lookup the pi_state again, so free this one
> + 		 * to keep the accounting correct.
> + 		 */
> + 		free_pi_state(pi_state);
> + 		pi_state = NULL;
> + 	}
> + 
>  -	ret = get_futex_key(uaddr1, fshared, &key1);
>  +	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
>   	if (unlikely(ret != 0))
>   		goto out;
>  -	ret = get_futex_key(uaddr2, fshared, &key2);
>  +	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_READ);

This one should be VERIFY_WRITE in the case of requeue_pi==1 as we
attempt to take this futex on behalf of the waiting task (either setting
the FUTEX_HAS_WAITERS flag or setting it as the owner).  So maybe
something like:

+	ret = get_futex_key(uaddr2, fshared, &key2,
			    requeue_pi == 1 ? VERIFY_WRITE : VERIFY_READ);

Alternatively just put it in an if/else block to avoid the inline
tertiary operator.

> + static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
> + 				 u32 val, ktime_t *abs_time, u32 bitset,
> + 				 int clockrt, u32 __user *uaddr2)
> + {
> + 	struct hrtimer_sleeper timeout, *to = NULL;
> + 	struct rt_mutex_waiter rt_waiter;
> + 	struct rt_mutex *pi_mutex = NULL;
> + 	DECLARE_WAITQUEUE(wait, current);
> + 	struct restart_block *restart;
> + 	struct futex_hash_bucket *hb;
> + 	union futex_key key2;
> + 	struct futex_q q;
> + 	int res, ret;
> + 	u32 uval;
> + 
> + 	if (!bitset)
> + 		return -EINVAL;
> + 
> + 	if (abs_time) {
> + 		to = &timeout;
> + 		hrtimer_init_on_stack(&to->timer, clockrt ? CLOCK_REALTIME :
> + 				      CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
> + 		hrtimer_init_sleeper(to, current);
> + 		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
> + 					     current->timer_slack_ns);
> + 	}
> + 
> + 	/*
> + 	 * The waiter is allocated on our stack, manipulated by the requeue
> + 	 * code while we sleep on uaddr.
> + 	 */
> + 	debug_rt_mutex_init_waiter(&rt_waiter);
> + 	rt_waiter.task = NULL;
> + 
> + 	q.pi_state = NULL;
> + 	q.bitset = bitset;
> + 	q.rt_waiter = &rt_waiter;
> + 
> + 	key2 = FUTEX_KEY_INIT;
>  -	ret = get_futex_key(uaddr2, fshared, &key2);
> ++	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_READ);

This one should be VERIFY_WRITE (it's the pi futex, so we set it's value
here in the kernel).

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
