Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbXFWIFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbXFWIFO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 04:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXFWIEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 04:04:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47192 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXFWIEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 04:04:50 -0400
Date: Sat, 23 Jun 2007 09:04:32 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: [PATCH] x86: simplify notify_page_fault()
Message-ID: <20070623080432.GA28898@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
	linux-kernel@vger.kernel.org, patches@x86-64.org
References: <45A255AF.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45A255AF.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 08, 2007 at 01:31:11PM +0000, Jan Beulich wrote:
> Remove all parameters from this function that aren't really variable.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> --- linux-2.6.20-rc4/arch/i386/mm/fault.c	2007-01-08 09:57:20.000000000 +0100
> +++ 2.6.20-rc4-x86-simplify-notify_page_fault/arch/i386/mm/fault.c	2007-01-08 10:32:45.000000000 +0100
> @@ -46,17 +46,17 @@ int unregister_page_fault_notifier(struc
>  }
>  EXPORT_SYMBOL_GPL(unregister_page_fault_notifier);
>  
> -static inline int notify_page_fault(enum die_val val, const char *str,
> -			struct pt_regs *regs, long err, int trap, int sig)
> +static inline int notify_page_fault(struct pt_regs *regs, long err)
>  {
>  	struct die_args args = {
>  		.regs = regs,
> -		.str = str,
> +		.str = "page fault",
>  		.err = err,
> -		.trapnr = trap,
> -		.signr = sig
> +		.trapnr = 14,
> +		.signr = SIGSEGV
>  	};
> -	return atomic_notifier_call_chain(&notify_page_fault_chain, val, &args);
> +	return atomic_notifier_call_chain(&notify_page_fault_chain,
> +	                                  DIE_PAGE_FAULT, &args);
>  }

Btw, WTF

>  
>  /*
> @@ -353,8 +353,7 @@ fastcall void __kprobes do_page_fault(st
>  	if (unlikely(address >= TASK_SIZE)) {
>  		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
>  			return;
> -		if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
> -						SIGSEGV) == NOTIFY_STOP)
> +		if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
>  			return;
>  		/*
>  		 * Don't take the mm semaphore here. If we fixup a prefetch
> @@ -363,8 +362,7 @@ fastcall void __kprobes do_page_fault(st
>  		goto bad_area_nosemaphore;
>  	}
>  
> -	if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
> -					SIGSEGV) == NOTIFY_STOP)
> +	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
>  		return;
>  
>  	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
> --- linux-2.6.20-rc4/arch/x86_64/mm/fault.c	2007-01-08 09:57:27.000000000 +0100
> +++ 2.6.20-rc4-x86-simplify-notify_page_fault/arch/x86_64/mm/fault.c	2007-01-08 10:33:11.000000000 +0100
> @@ -56,17 +56,17 @@ int unregister_page_fault_notifier(struc
>  }
>  EXPORT_SYMBOL_GPL(unregister_page_fault_notifier);
>  
> -static inline int notify_page_fault(enum die_val val, const char *str,
> -			struct pt_regs *regs, long err, int trap, int sig)
> +static inline int notify_page_fault(struct pt_regs *regs, long err)
>  {
>  	struct die_args args = {
>  		.regs = regs,
> -		.str = str,
> +		.str = "page fault",
>  		.err = err,
> -		.trapnr = trap,
> -		.signr = sig
> +		.trapnr = 14,
> +		.signr = SIGSEGV
>  	};
> -	return atomic_notifier_call_chain(&notify_page_fault_chain, val, &args);
> +	return atomic_notifier_call_chain(&notify_page_fault_chain,
> +	                                  DIE_PAGE_FAULT, &args);
>  }
>  
>  void bust_spinlocks(int yes)
> @@ -376,8 +376,7 @@ asmlinkage void __kprobes do_page_fault(
>  			if (vmalloc_fault(address) >= 0)
>  				return;
>  		}
> -		if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
> -						SIGSEGV) == NOTIFY_STOP)
> +		if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
>  			return;
>  		/*
>  		 * Don't take the mm semaphore here. If we fixup a prefetch
> @@ -386,8 +385,7 @@ asmlinkage void __kprobes do_page_fault(
>  		goto bad_area_nosemaphore;
>  	}
>  
> -	if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
> -					SIGSEGV) == NOTIFY_STOP)
> +	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
>  		return;
>  
>  	if (likely(regs->eflags & X86_EFLAGS_IF))
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
