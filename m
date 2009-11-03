Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZKCSK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZKCSK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZKCSK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:10:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59924 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbZKCSK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:10:56 -0500
Date: Tue, 3 Nov 2009 19:10:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, 64-bit: Move K8 B step iret fixup to fault entry
	asm (v2)
Message-ID: <20091103181014.GA19715@elte.hu>
References: <1257270936-5496-1-git-send-email-brgerst@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257270936-5496-1-git-send-email-brgerst@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brian Gerst <brgerst@gmail.com> wrote:

> Move the handling of truncated %rip from an iret fault to the fault
> entry path.
> 
> This allows x86-64 to use the standard search_extable() function.
> 
> v2: Fixed jump to error_swapgs to be unconditional.

v1 is already in the tip:x86/asm topic tree. Mind sending a delta fix 
against:

  http://people.redhat.com/mingo/tip.git/README

?

Also, i'm having second thoughts about the change:

> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> ---
>  arch/x86/include/asm/uaccess.h |    1 -
>  arch/x86/kernel/entry_64.S     |   11 ++++++++---
>  arch/x86/mm/extable.c          |   31 -------------------------------
>  3 files changed, 8 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
> index d2c6c93..abd3e0e 100644
> --- a/arch/x86/include/asm/uaccess.h
> +++ b/arch/x86/include/asm/uaccess.h
> @@ -570,7 +570,6 @@ extern struct movsl_mask {
>  #ifdef CONFIG_X86_32
>  # include "uaccess_32.h"
>  #else
> -# define ARCH_HAS_SEARCH_EXTABLE
>  # include "uaccess_64.h"
>  #endif
>  
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index b5c061f..1579a6c 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1491,12 +1491,17 @@ error_kernelspace:
>  	leaq irq_return(%rip),%rcx
>  	cmpq %rcx,RIP+8(%rsp)
>  	je error_swapgs
> -	movl %ecx,%ecx	/* zero extend */
> -	cmpq %rcx,RIP+8(%rsp)
> -	je error_swapgs
> +	movl %ecx,%eax	/* zero extend */
> +	cmpq %rax,RIP+8(%rsp)
> +	je bstep_iret
>  	cmpq $gs_change,RIP+8(%rsp)
>  	je error_swapgs
>  	jmp error_sti
> +
> +bstep_iret:
> +	/* Fix truncated RIP */
> +	movq %rcx,RIP+8(%rsp)
> +	jmp error_swapgs
>  END(error_entry)
>  
>  
> diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
> index 61b41ca..d0474ad 100644
> --- a/arch/x86/mm/extable.c
> +++ b/arch/x86/mm/extable.c
> @@ -35,34 +35,3 @@ int fixup_exception(struct pt_regs *regs)
>  
>  	return 0;
>  }
> -
> -#ifdef CONFIG_X86_64
> -/*
> - * Need to defined our own search_extable on X86_64 to work around
> - * a B stepping K8 bug.
> - */
> -const struct exception_table_entry *
> -search_extable(const struct exception_table_entry *first,
> -	       const struct exception_table_entry *last,
> -	       unsigned long value)
> -{
> -	/* B stepping K8 bug */
> -	if ((value >> 32) == 0)
> -		value |= 0xffffffffUL << 32;
> -
> -	while (first <= last) {
> -		const struct exception_table_entry *mid;
> -		long diff;
> -
> -		mid = (last - first) / 2 + first;
> -		diff = mid->insn - value;
> -		if (diff == 0)
> -			return mid;
> -		else if (diff < 0)
> -			first = mid+1;
> -		else
> -			last = mid-1;
> -	}
> -	return NULL;
> -}
> -#endif

is this the only way how we can end up having a truncated 64-bit RIP 
passed in to search_exception_tables()/search_extable()? Before your 
commit we basically had a last-ditch safety net in 64-bit kernels that 
zero-extended truncated RIPs - no matter how they got there (via known 
or unknown erratums).

Thanks,

	Ingo
