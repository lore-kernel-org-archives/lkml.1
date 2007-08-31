Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbXHaQdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbXHaQdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759201AbXHaQdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:33:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:60471 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759069AbXHaQdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:33:12 -0400
Date: Fri, 31 Aug 2007 09:32:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] detect & print stack overruns at oops time
Message-Id: <20070831093253.98f4b640.randy.dunlap@oracle.com>
In-Reply-To: <46D7A71A.7050800@redhat.com>
References: <46D7A71A.7050800@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 00:28:58 -0500 Eric Sandeen wrote:

> Index: linux-2.6.22-rc4/arch/i386/mm/fault.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/arch/i386/mm/fault.c
> +++ linux-2.6.22-rc4/arch/i386/mm/fault.c
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

Hi,

Is there something that tells us what <Thread> is doing all of this
bad juju?

> +#ifdef CONFIG_DEBUG_STACK_USAGE
> +			int free;
> +			unsigned long *n = stackend;
> +			while (!*n)
> +				n++;
> +			free = (unsigned long)n - (unsigned long)stackend;
> +			if (free)
> +				printk(KERN_ALERT "Thread used within %d bytes"
> +					" of stack end\n", free);
> +#endif
> +			/* won't catch 100% - stack may have 0s here by chance */
> +			if (*stackend)  /* was init'd to 0 */
> +				printk(KERN_ALERT "Thread overran the stack?\n");
> +		}
> +
>  		printk(KERN_ALERT " printing eip:\n");
>  		printk("%08lx\n", regs->eip);
>  

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
