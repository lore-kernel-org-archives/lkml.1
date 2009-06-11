Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbZFKF7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbZFKF7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 01:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZFKF7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 01:59:00 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58472 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbZFKF67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 01:58:59 -0400
Message-ID: <4A309D16.4040505@us.ibm.com>
Date: Wed, 10 Jun 2009 22:58:46 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bug: fio traps into kernel without exiting because futex has
 a deadloop
References: <1244689688.2560.268.camel@ymzhang>
In-Reply-To: <1244689688.2560.268.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:

Hi Zhang,

> I investigate a fio hang issue. When I run fio multi-process
> testing on many disks, fio traps into kernel and doesn't exit
> (mostly hit once after runing sub test cases for ﻿hundreds of times).
> 
> Oprofile data shows kernel consumes time with some futex functions.
> Command kill couldn't kill the process and machine reboot also hangs.
> 
> Eventually, I locate the root cause as a bug of futex. Kernel enters
> a deadloop between 'retry' and 'goto retry' in function futex_wake_op.
> By unknown reason (might be an issue of fio or glibc), parameter uaddr2
> points to an area which is READONLY. So futex_atomic_op_inuser returns
> -EFAULT when trying to changing the data at uaddr2, but later get_user
> still succeeds becasue the area is READONLY. Then go back to retry.
> 
> I create a simple test case to trigger it, which just shmat an READONLY
> area for address uaddr2.
> 
> It could be used as a DOS attack.

Nice work on the diagnosis.  I recall discussing something like this a 
couple weeks back.  I thought this was fixed with a patch to ensure the 
pages were writable.  Cc'ing Thomas G. to confirm.  I didn't see a 
kernel version in your report, what are you running?

--
Darren

> 
> 'git log kernel/futex.c' shows below commit creates the issue obviously.
> 
> commit e4dc5b7a36a49eff97050894cf1b3a9a02523717
> Author: Darren Hart <dvhltc@us.ibm.com>
> Date:   Thu Mar 12 00:56:13 2009 -0700
> 
>     futex: clean up fault logic
>     
>     Impact: cleanup
>     
>     Older versions of the futex code held the mmap_sem which had to
>     be dropped in order to call get_user(), so a two-pronged fault
>     handling mechanism was employed to handle faults of the atomic
>     operations.  The mmap_sem is no longer held, so get_user()
>     should be adequate.  This patch greatly simplifies the logic and
>     improves legibility.
> 
> 
> Reverting it fixes the issue. In addition, the patch deletes some comments
> around calling futex_handle_fault, but forgots in futex_unlock_pi.
> 
> There is a confliction to revert the commit. I worked out a patch.
> 
> The futex codes seem complicated. We could work out cleanup patches later after
> applying the reverting patch.
> 
> ---
> 
> --- linux-2.6.30-rc8/kernel/futex.c	2009-06-10 06:32:19.000000000 +0800
> +++ linux-2.6.30-rc8_futex/kernel/futex.c	2009-06-10 00:07:08.000000000 +0800
> @@ -300,6 +300,41 @@ static int get_futex_value_locked(u32 *d
>  	return ret ? -EFAULT : 0;
>  }
> 
> +/*
> + * Fault handling.
> + */
> +static int futex_handle_fault(unsigned long address, int attempt)
> +{
> +	struct vm_area_struct * vma;
> +	struct mm_struct *mm = current->mm;
> +	int ret = -EFAULT;
> +
> +	if (attempt > 2)
> +		return ret;
> +
> +	down_read(&mm->mmap_sem);
> +	vma = find_vma(mm, address);
> +	if (vma && address >= vma->vm_start &&
> +	    (vma->vm_flags & VM_WRITE)) {
> +		int fault;
> +		fault = handle_mm_fault(mm, vma, address, 1);
> +		if (unlikely((fault & VM_FAULT_ERROR))) {
> +#if 0
> +			/* XXX: let's do this when we verify it is OK */
> +			if (ret & VM_FAULT_OOM)
> +				ret = -ENOMEM;
> +#endif
> +		} else {
> +			ret = 0;
> +			if (fault & VM_FAULT_MAJOR)
> +				current->maj_flt++;
> +			else
> +				current->min_flt++;
> +		}
> +	}
> +	up_read(&mm->mmap_sem);
> +	return ret;
> +}
> 
>  /*
>   * PI code:
> @@ -722,9 +757,9 @@ futex_wake_op(u32 __user *uaddr1, int fs
>  	struct futex_hash_bucket *hb1, *hb2;
>  	struct plist_head *head;
>  	struct futex_q *this, *next;
> -	int ret, op_ret;
> +	int ret, op_ret, attempt = 0;
> 
> -retry:
> +retryfull:
>  	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
>  	if (unlikely(ret != 0))
>  		goto out;
> @@ -735,8 +770,9 @@ retry:
>  	hb1 = hash_futex(&key1);
>  	hb2 = hash_futex(&key2);
> 
> +retry:
>  	double_lock_hb(hb1, hb2);
> -retry_private:
> +
>  	op_ret = futex_atomic_op_inuser(op, uaddr2);
>  	if (unlikely(op_ret < 0)) {
>  		u32 dummy;
> @@ -757,16 +793,28 @@ retry_private:
>  			goto out_put_keys;
>  		}
> 
> +		/*
> +		 * futex_atomic_op_inuser needs to both read and write
> +		 * *(int __user *)uaddr2, but we can't modify it
> +		 * non-atomically.  Therefore, if get_user below is not
> +		 * enough, we need to handle the fault ourselves, while
> +		 * still holding the mmap_sem.
> +		 */
> +		if (attempt++) {
> +			ret = futex_handle_fault((unsigned long)uaddr2,
> +						 attempt);
> +			if (ret)
> +				goto out_put_keys;
> +			goto retry;
> +		}
> +
>  		ret = get_user(dummy, uaddr2);
>  		if (ret)
>  			goto out_put_keys;
> 
> -		if (!fshared)
> -			goto retry_private;
> -
>  		put_futex_key(fshared, &key2);
>  		put_futex_key(fshared, &key1);
> -		goto retry;
> +		goto retryfull;
>  	}
> 
>  	head = &hb1->chain;
> @@ -826,7 +874,6 @@ retry:
>  	hb1 = hash_futex(&key1);
>  	hb2 = hash_futex(&key2);
> 
> -retry_private:
>  	double_lock_hb(hb1, hb2);
> 
>  	if (likely(cmpval != NULL)) {
> @@ -837,16 +884,15 @@ retry_private:
>  		if (unlikely(ret)) {
>  			double_unlock_hb(hb1, hb2);
> 
> +			put_futex_key(fshared, &key2);
> +			put_futex_key(fshared, &key1);
> +
>  			ret = get_user(curval, uaddr1);
> -			if (ret)
> -				goto out_put_keys;
> 
> -			if (!fshared)
> -				goto retry_private;
> +			if (!ret)
> +				goto retry;
> 
> -			put_futex_key(fshared, &key2);
> -			put_futex_key(fshared, &key1);
> -			goto retry;
> +			goto out_put_keys;
>  		}
>  		if (curval != *cmpval) {
>  			ret = -EAGAIN;
> @@ -1026,7 +1072,7 @@ static int fixup_pi_state_owner(u32 __us
>  	struct futex_pi_state *pi_state = q->pi_state;
>  	struct task_struct *oldowner = pi_state->owner;
>  	u32 uval, curval, newval;
> -	int ret;
> +	int ret, attempt = 0;
> 
>  	/* Owner died? */
>  	if (!pi_state->owner)
> @@ -1097,7 +1143,7 @@ retry:
>  handle_fault:
>  	spin_unlock(q->lock_ptr);
> 
> -	ret = get_user(uval, uaddr);
> +	ret = futex_handle_fault((unsigned long)uaddr, attempt++);
> 
>  	spin_lock(q->lock_ptr);
> 
> @@ -1146,7 +1192,6 @@ retry:
>  	if (unlikely(ret != 0))
>  		goto out;
> 
> -retry_private:
>  	hb = queue_lock(&q);
> 
>  	/*
> @@ -1173,16 +1218,13 @@ retry_private:
> 
>  	if (unlikely(ret)) {
>  		queue_unlock(&q, hb);
> +		put_futex_key(fshared, &q.key);
> 
>  		ret = get_user(uval, uaddr);
> -		if (ret)
> -			goto out_put_key;
> 
> -		if (!fshared)
> -			goto retry_private;
> -
> -		put_futex_key(fshared, &q.key);
> -		goto retry;
> +		if (!ret)
> +			goto retry;
> +		goto out;
>  	}
>  	ret = -EWOULDBLOCK;
>  	if (unlikely(uval != val)) {
> @@ -1316,7 +1358,7 @@ static int futex_lock_pi(u32 __user *uad
>  	struct futex_hash_bucket *hb;
>  	u32 uval, newval, curval;
>  	struct futex_q q;
> -	int ret, lock_taken, ownerdied = 0;
> +	int ret, lock_taken, ownerdied = 0, attempt = 0;
> 
>  	if (refill_pi_state_cache())
>  		return -ENOMEM;
> @@ -1336,7 +1378,7 @@ retry:
>  	if (unlikely(ret != 0))
>  		goto out;
> 
> -retry_private:
> +retry_unlocked:
>  	hb = queue_lock(&q);
> 
>  retry_locked:
> @@ -1561,15 +1603,18 @@ uaddr_faulted:
>  	 */
>  	queue_unlock(&q, hb);
> 
> -	ret = get_user(uval, uaddr);
> -	if (ret)
> -		goto out_put_key;
> +	if (attempt++) {
> +		ret = futex_handle_fault((unsigned long)uaddr, attempt);
> +		if (ret)
> +			goto out_put_key;
> +		goto retry_unlocked;
> +	}
> 
> -	if (!fshared)
> -		goto retry_private;
> +	ret = get_user(uval, uaddr);
> +	if (!ret)
> +		goto retry_unlocked;
> 
> -	put_futex_key(fshared, &q.key);
> -	goto retry;
> +	goto out_put_key;
>  }
> 
> 
> @@ -1585,7 +1630,7 @@ static int futex_unlock_pi(u32 __user *u
>  	u32 uval;
>  	struct plist_head *head;
>  	union futex_key key = FUTEX_KEY_INIT;
> -	int ret;
> +	int ret, attempt = 0;
> 
>  retry:
>  	if (get_user(uval, uaddr))
> @@ -1601,6 +1646,7 @@ retry:
>  		goto out;
> 
>  	hb = hash_futex(&key);
> +retry_unlocked:
>  	spin_lock(&hb->lock);
> 
>  	/*
> @@ -1665,9 +1711,17 @@ pi_faulted:
>  	 * we have to drop the mmap_sem in order to call get_user().
>  	 */
>  	spin_unlock(&hb->lock);
> -	put_futex_key(fshared, &key);
> +
> +	if (attempt++) {
> +		ret = futex_handle_fault((unsigned long)uaddr, attempt);
> +		if (ret)
> +			goto out;
> +		uval = 0;
> +		goto retry_unlocked;
> +	}
> 
>  	ret = get_user(uval, uaddr);
> +	put_futex_key(fshared, &key);
>  	if (!ret)
>  		goto retry;
> 
> 
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
