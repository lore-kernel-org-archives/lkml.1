Return-Path: <linux-kernel-owner+w=401wt.eu-S1760055AbXKNPan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbXKNPan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbXKNPa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:30:28 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:46721 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbXKNPa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:30:26 -0500
Subject: Re: [RFC] [PATCH] hugetlbfs :shmget with SHM_HUGETLB only works as
	root
From: aglitke <agl@us.ibm.com>
To: ciju@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, wli@holomorphy.com
In-Reply-To: <473B0317.6010603@linux.vnet.ibm.com>
References: <473B0317.6010603@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: IBM
Date: Wed, 14 Nov 2007 09:31:41 -0600
Message-Id: <1195054301.18047.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ciju:

I am still not exactly sure why this patch is needed.  As I read
user_shm_lock():

> lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
> if (lock_limit == RLIM_INFINITY)
> 	allowed = 1;
> lock_limit >>= PAGE_SHIFT;
> spin_lock(&shmlock_user_lock);
> if (!allowed &&
>     locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
> 	goto out;

... if the user's locked limit (ulimit -l) is set to unlimited, allowed
(above) is set to 1.  In that case, the second part of that if() is
bypassed, and the function grants permission.  Therefore, the easy
solution is to make sure your user's lock_limit is RLIM_INFINITY.

On Wed, 2007-11-14 at 19:45 +0530, Ciju Rajan K wrote:
<snip>
> @@ -248,8 +249,14 @@ int user_shm_lock(size_t size, struct us
>          allowed = 1;
>      lock_limit >>= PAGE_SHIFT;
>      spin_lock(&shmlock_user_lock);
> +#ifdef CONFIG_HUGETLB_PAGE
> +    if (!allowed &&
> +        locked + user->locked_shm > lock_limit &&
> +        (!(capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group))))

This will allow any user in hugetlb_shm_group to make unlimited use of
huge page shm segments _and_ normal page shm segments.  Definitely not
what you want.

> +#else
>      if (!allowed &&
>          locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
> +#endif
>          goto out;
>      get_uid(user);
>      user->locked_shm += locked;
> 

Please don't add new #ifdefs into .c files, headers only.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

