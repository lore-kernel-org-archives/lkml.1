Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZKQRWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZKQRWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZKQRWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:22:31 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53701 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbZKQRWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:22:30 -0500
Message-ID: <4B02DBCA.4050307@us.ibm.com>
Date: Tue, 17 Nov 2009 09:22:18 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
References: <20091117074655.GA14023@google.com>
In-Reply-To: <20091117074655.GA14023@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse wrote:
> Hi,
> 

Hi Michel,

Thanks for the excellent writeup.  The concept looks reasonable, and 
useful, to me.  Just a few thoughts, comments below.

 > ...

> 
> By doing the futex value update atomically with the kernel's inspection
> of it to decide to wait, we avoid the time window where the futex has
> been set to the 'please wake me up' state, but the thread has not been
> queued onto the hash bucket yet. This has two effects:
> - Avoids a futex syscall with the FUTEX_WAKE operation if there is no
>   thread to be woken yet

This also reduces lock contention on the hash-bucket locks, another plus.

> - In the heavily contended case, avoids waking an extra thread that's
>   only likely to make the contention problem worse.

I'm not seeing this. What is the extra thread that would be woken which 
isn't with FUTEX_SET_WAIT?

 > ...

> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> diff --git a/include/linux/futex.h b/include/linux/futex.h
> index 1e5a26d..c5e887d 100644
> --- a/include/linux/futex.h
> +++ b/include/linux/futex.h
> @@ -20,6 +20,7 @@
>  #define FUTEX_WAKE_BITSET	10
>  #define FUTEX_WAIT_REQUEUE_PI	11
>  #define FUTEX_CMP_REQUEUE_PI	12
> +#define FUTEX_SET_WAIT		13
> 
>  #define FUTEX_PRIVATE_FLAG	128
>  #define FUTEX_CLOCK_REALTIME	256
> @@ -39,6 +40,7 @@
>  					 FUTEX_PRIVATE_FLAG)
>  #define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
>  					 FUTEX_PRIVATE_FLAG)
> +#define FUTEX_SET_WAIT_PRIVATE		(FUTEX_SET_WAIT | FUTEX_PRIVATE_FLAG)
> 
>  /*
>   * Support for robust futexes: the kernel cleans up held futexes at
> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> index a8cc4e1..a199606 100644
> --- a/include/linux/thread_info.h
> +++ b/include/linux/thread_info.h
> @@ -25,6 +25,7 @@ struct restart_block {
>  		struct {
>  			u32 *uaddr;
>  			u32 val;
> +			u32 val2;

It's a nitpic, but val2 is used in the futex syscall arguments already 
and another variable of the same name that is actually initially derived 
from uaddr2... is more likely to confuse than not.  Perhaps "setval"? 
Throughout the patch.


> @@ -1722,52 +1723,61 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
>  	 *
>  	 * The basic logical guarantee of a futex is that it blocks ONLY
>  	 * if cond(var) is known to be true at the time of blocking, for
> -	 * any cond.  If we queued after testing *uaddr, that would open
> -	 * a race condition where we could block indefinitely with
> +	 * any cond.  If we locked the hash-bucket after testing *uaddr, that
> +	 * would open a race condition where we could block indefinitely with
>  	 * cond(var) false, which would violate the guarantee.
>  	 *
> -	 * A consequence is that futex_wait() can return zero and absorb
> -	 * a wakeup when *uaddr != val on entry to the syscall.  This is
> -	 * rare, but normal.
> +	 * On the other hand, we insert q and release the hash-bucket only
> +	 * after testing *uaddr. This guarantees that futex_wait() will NOT
> +	 * absorb a wakeup if *uaddr does not match the desired values
> +	 * while the syscall executes.
>  	 */
>  retry:
>  	q->key = FUTEX_KEY_INIT;
> -	ret = get_futex_key(uaddr, fshared, &q->key, VERIFY_READ);
> +	ret = get_futex_key(uaddr, fshared, &q->key,
> +			    (val == val2) ? VERIFY_READ : VERIFY_WRITE);

Have you compared the performance of FUTEX_WAIT before and after the 
application of this patch? I'd be interested to see your test results on 
a prepatched kernel (with the FUTEX_SET_WAIT side commented out of course).

>  	if (unlikely(ret != 0))
>  		return ret;
> 
>  retry_private:
>  	*hb = queue_lock(q);
> 
> -	ret = get_futex_value_locked(&uval, uaddr);
> -
> -	if (ret) {
> +	pagefault_disable();
> +	if (unlikely(__copy_from_user_inatomic(&uval, uaddr, sizeof(u32)))) {
> +		pagefault_enable();

What about the addition of val2 makes it so we have to expand 
get_futex_value_locked() here with the nested fault handling?

>  		queue_unlock(q, *hb);
> -

Superfluous whitespace change

>  		ret = get_user(uval, uaddr);
> +	fault_common:

Inconsistent label indentation with the rest of the file.

>  		if (ret)
>  			goto out;
> -
>  		if (!fshared)
>  			goto retry_private;
> -
>  		put_futex_key(fshared, &q->key);
>  		goto retry;
>  	}
> -

Several of superfluous whitespace changes

> -	if (uval != val) {
> -		queue_unlock(q, *hb);
> -		ret = -EWOULDBLOCK;
> +	if (val != val2 && uval == val) {
> +		uval = futex_atomic_cmpxchg_inatomic(uaddr, val, val2);
> +		if (unlikely(uval == -EFAULT)) {
> +			pagefault_enable();
> +			queue_unlock(q, *hb);
> +			ret = fault_in_user_writeable(uaddr);
> +			goto fault_common;
> +		}
>  	}
> +	pagefault_enable();
> +
> +	if (uval == val || uval == val2)
> +		return 0;  /* success */

If the comment is necessary, please give it its own line (I've done a 
lot of futex commentary cleanup recently and am a little sensitive to 
maintaining that :-).

I'd rather not add another return point to the code, even if it saves us 
an if statement. You've already tested for uval == val above, perhaps 
this test can be integrated in the above blocks and then use the common 
out: label?

Now I need to review Peter's Adaptive bits and think on how these two 
relate...

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
