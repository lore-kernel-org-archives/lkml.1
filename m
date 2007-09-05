Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbXIEJ3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbXIEJ3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 05:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbXIEJ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 05:29:15 -0400
Received: from mx10.go2.pl ([193.17.41.74]:35128 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755882AbXIEJ3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 05:29:14 -0400
Date: Wed, 5 Sep 2007 11:30:47 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] detect & print stack overruns at oops time
Message-ID: <20070905093047.GA1938@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D7A71A.7050800@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-08-2007 07:28, Eric Sandeen wrote:
> In thinking about the 4KSTACKS + STACKOVERFLOW problems, I thought
...
> Thoughts?  This is a separate problem from the piggy dump_stack()
> path, but it seems to me it might be useful in looking at stack-related
> oopses when they do occur.  With this change, it seems feasible
> to turn off DEBUG_STACKOVERFLOW, turn on DEBUG_STACK_USAGE, and just
> get the bad news when it's actually happened.  :) 

Very good idea, but maybe, at least for some time, it should be with
ifdef CONFIG_4KSTACKS, to check if it's really needed if some other
similar checks also set.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Index: linux-2.6.22-rc4/arch/i386/mm/fault.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/arch/i386/mm/fault.c
> +++ linux-2.6.22-rc4/arch/i386/mm/fault.c
> @@ -525,6 +525,8 @@ no_context:
>  
>  	if (oops_may_print()) {
>  		__typeof__(pte_val(__pte(0))) page;
> +		unsigned long *stackend = end_of_stack(tsk);
> +		int overrun;
>  
>  #ifdef CONFIG_X86_PAE
>  		if (error_code & 16) {
> @@ -543,6 +545,27 @@ no_context:
>  			printk(KERN_ALERT "BUG: unable to handle kernel paging"
>  					" request");
>  		printk(" at virtual address %08lx\n",address);
> +
> +		overrun = (unsigned long)stackend - (unsigned long)(&regs->esp);
> +		if (overrun > 0) {
> +			printk(KERN_ALERT "Thread overrunning stack by %d "
> +							"bytes\n", overrun);
> +		} else {
> +#ifdef CONFIG_DEBUG_STACK_USAGE
> +			int free;
> +			unsigned long *n = stackend;
> +			while (!*n)
> +				n++;
> +			free = (unsigned long)n - (unsigned long)stackend;
> +			if (free)

Maybe there should be some min 'free' and max number of printks? There
could be also considered if, with some minimal values of 'free', prink
is the best thing we can do before stack overruning?

> +				printk(KERN_ALERT "Thread used within %d bytes"
> +					" of stack end\n", free);
> +#endif
> +			/* won't catch 100% - stack may have 0s here by chance */
> +			if (*stackend)  /* was init'd to 0 */

Isn't a MAGIC number better for this? (Then of course above n should
start a bit higher.)

Regards,
Jarek P.
