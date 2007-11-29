Return-Path: <linux-kernel-owner+w=401wt.eu-S1762882AbXK2ScR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762882AbXK2ScR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757721AbXK2ScB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:32:01 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:49212 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757301AbXK2ScA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:32:00 -0500
Message-ID: <474F05C0.9040002@linux.vnet.ibm.com>
Date: Fri, 30 Nov 2007 00:02:32 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Reply-To: ciju@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: aglitke <agl@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] hugetlbfs :shmget with SHM_HUGETLB only works as
 root
References: <473B0317.6010603@linux.vnet.ibm.com> <1195054301.18047.20.camel@localhost.localdomain> <20071114220038.GD1806@holomorphy.com>
In-Reply-To: <20071114220038.GD1806@holomorphy.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wli,
   I tested your patch. But that is not solving the problem.
   If the code change to user_shm_lock() is not a good solution, could 
you please suggest a method so that the normal user is able to allocate 
the huge pages, if his gid is added to /proc/sys/vm/hugetlb_shm_group

Thanks
Ciju

William Lee Irwin III wrote:
> On Wed, Nov 14, 2007 at 09:31:41AM -0600, aglitke wrote:
>> ... if the user's locked limit (ulimit -l) is set to unlimited, allowed
>> (above) is set to 1.  In that case, the second part of that if() is
>> bypassed, and the function grants permission.  Therefore, the easy
>> solution is to make sure your user's lock_limit is RLIM_INFINITY.
> 
> This function deserves a minor cleanup and a bit more commenting.
> 
> Reading user->locked_shm within shmlock_user_lock would be nice, too.
> 
> Maybe something like this (untested, uncompiled) would do.
> 
> 
> -- wli
> 
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 7b26560..5f51792 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -234,6 +234,12 @@ asmlinkage long sys_munlockall(void)
>  /*
>   * Objects with different lifetime than processes (SHM_LOCK and SHM_HUGETLB
>   * shm segments) get accounted against the user_struct instead.
> + * First, user_shm_lock() checks that the user has permission to lock
> + * enough memory; then if so, the locked shm is accounted to the user's
> + * system-wide state. shmlock_user_lock protects the per-user field
> + * tracking how much locked_shm is in use within the struct user_struct.
> + * shmlock_user_lock is taken early to guard the read-only check that
> + * user->locked_shm is in-bounds against updates to user->locked_shm.
>   */
>  static DEFINE_SPINLOCK(shmlock_user_lock);
> 
> @@ -242,19 +248,22 @@ int user_shm_lock(size_t size, struct user_struct *user)
>  	unsigned long lock_limit, locked;
>  	int allowed = 0;
> 
> +	spin_lock(&shmlock_user_lock);
>  	locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>  	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
>  	if (lock_limit == RLIM_INFINITY)
>  		allowed = 1;
> -	lock_limit >>= PAGE_SHIFT;
> -	spin_lock(&shmlock_user_lock);
> -	if (!allowed &&
> -	    locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
> -		goto out;
> -	get_uid(user);
> -	user->locked_shm += locked;
> -	allowed = 1;
> -out:
> +	else {
> +		lock_limit >>= PAGE_SHIFT;
> +		if (locked + user->locked_shm <= lock_limit)
> +			allowed = 1;
> +		else if (capable(CAP_IPC_LOCK))
> +			allowed = 1;
> +	}
> +	if (allowed) {
> +		get_uid(user);
> +		user->locked_shm += locked;
> +	}
>  	spin_unlock(&shmlock_user_lock);
>  	return allowed;
>  }

