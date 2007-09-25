Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbXIYTy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbXIYTy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbXIYTyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:54:18 -0400
Received: from www.osadl.org ([213.239.205.134]:50992 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754911AbXIYTyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:54:17 -0400
Subject: Re: [PATCH] UML - time build fix
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
In-Reply-To: <20070925173713.GA8262@c2.user-mode-linux.org>
References: <20070925173713.GA8262@c2.user-mode-linux.org>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 21:54:15 +0200
Message-Id: <1190750055.17409.38.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-09-25 at 13:37 -0400, Jeff Dike wrote:
> Put back an implementation of timeval_to_ns in
> arch/um/os-Linux/time.c.  tglx pointed out in his review of tickless
> support that there was a perfectly good implementation of it in
> linux/time.h.  The problem is that this is userspace code which can't
> pull in kernel headers and there doesn't seem to be a libc version.

Oops. Did not notice. Can't we move it into some header file which is
accessible from everywhere ?

	tglx

> So, I'm copying the version from linux/time.h rather than resurrecting
> my version.  This causes some declaration changes as it now returns a
> signed value rather than an unsigned value.
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  arch/um/include/os.h    |    4 ++--
>  arch/um/os-Linux/time.c |   22 +++++++++++++++++++---
>  2 files changed, 21 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.22/arch/um/include/os.h
> ===================================================================
> --- linux-2.6.22.orig/arch/um/include/os.h	2007-09-25 09:26:42.000000000 -0400
> +++ linux-2.6.22/arch/um/include/os.h	2007-09-25 09:28:42.000000000 -0400
> @@ -252,9 +252,9 @@ extern void os_dump_core(void);
>  extern void idle_sleep(unsigned long long nsecs);
>  extern int set_interval(void);
>  extern int timer_one_shot(int ticks);
> -extern unsigned long long disable_timer(void);
> +extern long long disable_timer(void);
>  extern void uml_idle_timer(void);
> -extern unsigned long long os_nsecs(void);
> +extern long long os_nsecs(void);
>  
>  /* skas/mem.c */
>  extern long run_syscall_stub(struct mm_id * mm_idp,
> Index: linux-2.6.22/arch/um/os-Linux/time.c
> ===================================================================
> --- linux-2.6.22.orig/arch/um/os-Linux/time.c	2007-09-25 09:26:42.000000000 -0400
> +++ linux-2.6.22/arch/um/os-Linux/time.c	2007-09-25 09:28:42.000000000 -0400
> @@ -39,7 +39,23 @@ int timer_one_shot(int ticks)
>  	return 0;
>  }
>  
> -unsigned long long disable_timer(void)
> +/**
> + * timeval_to_ns - Convert timeval to nanoseconds
> + * @ts:		pointer to the timeval variable to be converted
> + *
> + * Returns the scalar nanosecond representation of the timeval
> + * parameter.
> + *
> + * Ripped from linux/time.h because it's a kernel header, and thus
> + * unusable from here.
> + */
> +static inline long long timeval_to_ns(const struct timeval *tv)
> +{
> +	return ((long long) tv->tv_sec * UM_NSEC_PER_SEC) +
> +		tv->tv_usec * UM_NSEC_PER_USEC;
> +}
> +
> +long long disable_timer(void)
>  {
>  	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
>  
> @@ -47,10 +63,10 @@ unsigned long long disable_timer(void)
>  		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
>  		       "errno = %d\n", errno);
>  
> -	return tv_to_nsec(&time.it_value);
> +	return timeval_to_ns(&time.it_value);
>  }
>  
> -unsigned long long os_nsecs(void)
> +long long os_nsecs(void)
>  {
>  	struct timeval tv;
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

