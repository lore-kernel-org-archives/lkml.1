Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbYEVDdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbYEVDdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 23:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYEVDcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 23:32:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793AbYEVDcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 23:32:50 -0400
Date: Wed, 21 May 2008 20:32:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, morgan@kernel.org,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jmorris@namei.org,
       ltp-list@lists.sourceforge.net
Subject: Re: [PATCH] fix sys_prctl() returned uninitialized value
Message-Id: <20080521203212.ddf05254.akpm@linux-foundation.org>
In-Reply-To: <4834E639.2010209@cn.fujitsu.com>
References: <4834E639.2010209@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 11:19:21 +0800 Shi Weihua <shiwh@cn.fujitsu.com> wrote:

> When we test kernel by the latest LTP(20080430) on ia64,
> the following failure occured:
> -------------------------------------
> prctl01     1  PASS  :  Test Passed
> prctl01     0  WARN  :  prctl() returned 2048 errno = 0 : Success
> prctl01     1  PASS  :  Test Passed
> prctl01     2  FAIL  :  Test Failed
> -------------------------------------
> 
> We found commit 3898b1b4ebff8dcfbcf1807e0661585e06c9a91c
> causes this failure by git-bisect.
> And, we found 'error' has not been initialized in the function 
> sys_prctl()(kernel/sys.c). When the capability module is not taking
> responsibility for this call, sys_prctl() may return a wrong value.
> 
> Now, i fixed it.
> 
> Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 
> ---
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 895d2d4..26eb0f7 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1652,7 +1652,7 @@ asmlinkage long sys_umask(int mask)
>  asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
>  			  unsigned long arg4, unsigned long arg5)
>  {
> -	long uninitialized_var(error);
> +	long error = 0;
>  
>  	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
>  		return error;

Oh dear, there are so many things wrong with this...

- if security_task_prctl() is returning "fail" then why on earth
  isn't it setting the error code?

- cap_task_prctl() _does_ set `error' is if returns non-zero, so it
  must be one of the other myriad backend implementations of
  security_task_prctl() which is busted.  Which one is it?

- With the above patch applied, sys_prctl() will return zero (ie:
  "success") even though it just failed.

- Can't we remove the sixth argument to security_task_prctl() and
  just return the result code like a sane function would do?  
