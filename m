Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZGJPAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZGJPAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZGJPAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:00:03 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:60523 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZGJPAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:00:02 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/2] sched: Move the sleeping while atomic checks early
 in cond_resched()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247237391-5352-2-git-send-email-fweisbec@gmail.com>
References: <1247237391-5352-1-git-send-email-fweisbec@gmail.com>
	 <1247237391-5352-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 16:59:55 +0200
Message-Id: <1247237995.7529.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 16:49 +0200, Frederic Weisbecker wrote:

> index 0cb0d8d..e357dc7 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2279,11 +2279,13 @@ extern int _cond_resched(void);
>  #ifdef CONFIG_PREEMPT_BKL
>  static inline int cond_resched(void)
>  {
> +	might_sleep();
>  	return 0;
>  }
>  #else
>  static inline int cond_resched(void)
>  {
> +	might_sleep();
>  	return _cond_resched();
>  }
>  #endif

# define might_resched() _cond_resched()

# define might_sleep() \
	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)


Doesn't seem to make it any better that, but yeah, moving that
__might_sleep() did occur to me earlier today when I touched that code.

> diff --git a/kernel/sched.c b/kernel/sched.c
> index 87ecac1..c22804b 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6605,9 +6605,6 @@ SYSCALL_DEFINE0(sched_yield)
>  
>  static void __cond_resched(void)
>  {
> -#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
> -	__might_sleep(__FILE__, __LINE__);
> -#endif
>  	/*
>  	 * The BKS might be reacquired before we have dropped
>  	 * PREEMPT_ACTIVE, which could trigger a second



