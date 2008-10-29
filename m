Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbYJ2GTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbYJ2GTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 02:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYJ2GSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 02:18:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51000 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbYJ2GSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 02:18:49 -0400
Date: Wed, 29 Oct 2008 07:18:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@osdl.org, viro@zeniv.linux.org.uk, acme@ghostprotocols.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] headers: move release_kernel_lock(),
	reacquire_kernel_lock() to sched.c
Message-ID: <20081029061827.GA7936@elte.hu>
References: <20081029044351.GA2304@x200.localdomain> <20081029044447.GB2304@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029044447.GB2304@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> >From 21b76c6e7d2340805664b91dc1c83eb23c6f785d Mon Sep 17 00:00:00 2001
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Date: Mon, 27 Oct 2008 00:57:28 +0300
> Subject: [PATCH 1/2] headers: move release_kernel_lock(), reacquire_kernel_lock() to sched.c
> 
> Both are used only by scheduler, both are low-level enough to not allow in
> drivers. Removal allows to remove sched.h from smp_lock.h, which is needed
> solely for inline function.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>  include/linux/smp_lock.h |   18 ------------------
>  kernel/sched.c           |   20 ++++++++++++++++++++
>  2 files changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
> index 813be59..6052f02 100644
> --- a/include/linux/smp_lock.h
> +++ b/include/linux/smp_lock.h
> @@ -8,22 +8,6 @@
>  
>  extern int __lockfunc __reacquire_kernel_lock(void);
>  extern void __lockfunc __release_kernel_lock(void);
> -
> -/*
> - * Release/re-acquire global kernel lock for the scheduler
> - */
> -#define release_kernel_lock(tsk) do { 		\
> -	if (unlikely((tsk)->lock_depth >= 0))	\
> -		__release_kernel_lock();	\
> -} while (0)
> -
> -static inline int reacquire_kernel_lock(struct task_struct *task)
> -{
> -	if (unlikely(task->lock_depth >= 0))
> -		return __reacquire_kernel_lock();
> -	return 0;
> -}
> -
>  extern void __lockfunc lock_kernel(void)	__acquires(kernel_lock);
>  extern void __lockfunc unlock_kernel(void)	__releases(kernel_lock);
>  
> @@ -43,9 +27,7 @@ static inline void cycle_kernel_lock(void)
>  
>  #define lock_kernel()				do { } while(0)
>  #define unlock_kernel()				do { } while(0)
> -#define release_kernel_lock(task)		do { } while(0)
>  #define cycle_kernel_lock()			do { } while(0)
> -#define reacquire_kernel_lock(task)		0
>  #define kernel_locked()				1
>  
>  #endif /* CONFIG_LOCK_KERNEL */
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 6625c3c..96a4462 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -79,6 +79,26 @@
>  
>  #include "sched_cpupri.h"
>  
> +#ifdef CONFIG_LOCK_KERNEL
> +/*
> + * Release/re-acquire global kernel lock for the scheduler
> + */
> +#define release_kernel_lock(tsk) do { 		\
> +	if (unlikely((tsk)->lock_depth >= 0))	\
> +		__release_kernel_lock();	\
> +} while (0)
> +
> +static inline int reacquire_kernel_lock(struct task_struct *task)
> +{
> +	if (unlikely(task->lock_depth >= 0))
> +		return __reacquire_kernel_lock();
> +	return 0;
> +}
> +#else
> +#define release_kernel_lock(task)		do { } while(0)
> +#define reacquire_kernel_lock(task)		0
> +#endif

please dont move #ifdefs and interfaces into a .c file - if then move 
it into another header file.

	Ingo
