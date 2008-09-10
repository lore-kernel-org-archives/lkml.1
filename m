Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYIJPBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYIJPBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYIJPBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:01:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:54188 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYIJPBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:01:09 -0400
Subject: Re: [patch] x86: some lock annotations for user copy paths
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080910144812.GB18644@wotan.suse.de>
References: <20080910113717.GB16811@wotan.suse.de>
	 <1221046892.30429.85.camel@twins.programming.kicks-ass.net>
	 <20080910114755.GA9696@elte.hu> <20080910121217.GA16013@elte.hu>
	 <20080910144812.GB18644@wotan.suse.de>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 17:01:04 +0200
Message-Id: <1221058864.30429.291.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 16:48 +0200, Nick Piggin wrote:

> @@ -3016,3 +3016,18 @@ void print_vma_addr(char *prefix, unsign
>  	}
>  	up_read(&current->mm->mmap_sem);
>  }
> +
> +void might_fault(void)
> +{
> +	/*
> +	 * it would be nicer only to annotatea paths which are not under
> +	 * pagefault_disable, however that requires a larger audit and
> +	 * providing helpers like get_user_atomic.
> +	 */
> +	if (!in_atomic()) {
> +		might_sleep();
> +		if (current->mm)
> +			might_lock_read(&current->mm->mmap_sem);
> +	}
> +}
> +EXPORT_SYMBOL(might_fault);

>From the nitpick squad :-), I prefer the form:

void might_fault(void)
{
	if (in_atomic())
		return;

	might_sleep();

	if (!current->mm)
		might_lock_read(&current->mm->mmap_sem);
}


Due to it being one nesting level less.

> Index: linux-2.6/include/linux/kernel.h
> ===================================================================
> --- linux-2.6.orig/include/linux/kernel.h
> +++ linux-2.6/include/linux/kernel.h
> @@ -140,6 +140,15 @@ extern int _cond_resched(void);
>  		(__x < 0) ? -__x : __x;		\
>  	})
>  
> +#ifdef CONFIG_LOCKDEP
> +void might_fault(void);
> +#else
> +static inline void might_fault(void)
> +{
> +	might_sleep();
> +}
> +#endif
> +
>  extern struct atomic_notifier_head panic_notifier_list;
>  extern long (*panic_blink)(long time);
>  NORET_TYPE void panic(const char * fmt, ...)

This forgets that in_atomic() again - possibly triggering might_sleep()
where not appropriate.

I'm not sure its worth it to out-of-line the thing though (its only big
on debug builds), and CONFIG_LOCKDEP is the wrong CONFIG_* variable, I
think CONFIG_PROVE_LOCKING would be the appropriate one.

