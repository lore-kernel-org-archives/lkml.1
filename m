Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZCLXWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZCLXWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbZCLXWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:22:10 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47902 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbZCLXWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:22:08 -0400
Message-ID: <49B99918.5010806@us.ibm.com>
Date: Thu, 12 Mar 2009 16:22:00 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/6] Additional (get|put)_futex_key() fixes
References: <20090312075349.9856.83687.stgit@Aeon> <20090312075545.9856.75152.stgit@Aeon> <20090312101636.GB7157@elte.hu> <alpine.LFD.2.00.0903121207520.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903121207520.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 12 Mar 2009, Ingo Molnar wrote:
>> * Darren Hart <dvhltc@us.ibm.com> wrote:
>>
>>> futex_requeue and futex_lock_pi still had some bad 
>>> (get|put)_futex_key() usage. This patch adds the missing 
>>> put_futex_keys() and corrects a goto in futex_lock_pi() to 
>>> avoid a double get.
>>>
>>> Build and boot tested on a 4 way Intel x86_64 workstation.  
>>> Passes basic pthread_mutex and PI tests out of 
>>> ltp/testcases/realtime.
>> hm, how bad is the impact - do we need this in v2.6.29?
> 
> I think so. We leak key references in some of the error/retry code
> pathes.  Darrens patch does not apply to mainline. Backport below.
> 

I think you may have made a mistake in the application of the patch.  I 
did a "git cherry-pick" of this patch onto linux-2.6.tip master and it 
didn't complain, the patch itself was only different by a couple of line 
numbers.  Trying to apply this patch manually resulted in:

$ patch -p1 < fixes.diff
patching file kernel/futex.c
Hunk #1 succeeded at 805 (offset 3 lines).
Hunk #2 succeeded at 883 (offset 3 lines).
Hunk #3 succeeded at 1468 (offset 10 lines).
Hunk #4 succeeded at 1611 (offset 10 lines).
Hunk #5 succeeded at 1720 (offset 10 lines).

So I think this patch should be fine.  Before I wrote the patch I 
checked to make sure that my branch had merged tip/master which had the 
most recent futex patches from mainline.

Thanks,

Darren

> Thanks,
> 
> 	tglx
> ---
> Subject: futex: fix key reference leaks
> From: Darren Hart <dvhltc@us.ibm.com>
> Date: Thu, 12 Mar 2009 12:10:01 +0100
> 
> Impact: bugfix
> 
> futex_wake_op, futex_requeue, futex_lock_pi and futex_unlock_pi still
> had some bad (get|put)_futex_key() usage. This patch adds the missing
> put_futex_keys() and corrects a goto in futex_lock_pi() to avoid a
> double get.
> 
> [ tglx: backport to mainline ]
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> ---
> 
>  kernel/futex.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/futex.c
> ===================================================================
> --- linux-2.6.orig/kernel/futex.c
> +++ linux-2.6/kernel/futex.c
> @@ -803,6 +803,9 @@ retry:
>  			goto retry;
>  		}
> 
> +		put_futex_key(fshared, &key2);
> +		put_futex_key(fshared, &key1);
> +
>  		ret = get_user(dummy, uaddr2);
>  		if (ret)
>  			return ret;
> @@ -881,12 +884,15 @@ retry:
>  			if (hb1 != hb2)
>  				spin_unlock(&hb2->lock);
> 
> +			put_futex_key(fshared, &key2);
> +			put_futex_key(fshared, &key1);
> +
>  			ret = get_user(curval, uaddr1);
> 
>  			if (!ret)
>  				goto retry;
> 
> -			goto out_put_keys;
> +			return ret;
>  		}
>  		if (curval != *cmpval) {
>  			ret = -EAGAIN;
> @@ -1459,7 +1465,7 @@ retry_locked:
>  			 */
>  			queue_unlock(&q, hb);
>  			cond_resched();
> -			goto retry;
> +			goto retry_unlocked;
> 
>  		case -ESRCH:
>  			/*
> @@ -1598,6 +1604,7 @@ uaddr_faulted:
>  		goto retry_unlocked;
>  	}
> 
> +	put_futex_key(fshared, &q.key);
>  	ret = get_user(uval, uaddr);
>  	if (!ret)
>  		goto retry;
> @@ -1709,6 +1716,8 @@ pi_faulted:
>  		goto retry_unlocked;
>  	}
> 
> +	put_futex_key(fshared, &key);
> +
>  	ret = get_user(uval, uaddr);
>  	if (!ret)
>  		goto retry;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
