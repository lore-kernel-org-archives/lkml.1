Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbYE0Vld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbYE0Vld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbYE0VlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:41:09 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38654 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623AbYE0VlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:41:07 -0400
Date: Wed, 28 May 2008 00:38:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: break mutual header inclusion
Message-ID: <20080527213819.GC11310@cs181133002.pp.htv.fi>
References: <20080527204926.GA15020@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080527204926.GA15020@damson.getinternet.no>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 10:49:26PM +0200, Vegard Nossum wrote:
> Hi,
> 
> What do you think about this? The new file (vm86_mask.h) could actually be
> embedded completely in processor-flags.h, but I went for what I believe is
> the safer approach.

Breaking the mutual header inclusion is appreciated, but some comments 
are below.

> This has been compile tested on x86_32 and x86_64 defconfig.
> 
> Vegard
>...
> --- a/include/asm-x86/ptrace.h
> +++ b/include/asm-x86/ptrace.h
> @@ -2,8 +2,10 @@
>  #define _ASM_X86_PTRACE_H
>  
>  #include <linux/compiler.h>	/* For __user */
> +#include <asm/ds.h>		/* the DS BTS struct is used for ptrace too */
> +#include <asm/segment.h>
>  #include <asm/ptrace-abi.h>
> -
> +#include <asm/vm86_mask.h>
>  
>  #ifndef __ASSEMBLY__
>  
> @@ -55,9 +57,6 @@ struct pt_regs {
>  	unsigned long ss;
>  };
>  
> -#include <asm/vm86.h>
> -#include <asm/segment.h>
> -
>  #endif /* __KERNEL__ */
>  
>  #else /* __i386__ */
> @@ -127,9 +126,6 @@ struct pt_regs {
>  
>  #ifdef __KERNEL__
>  
> -/* the DS BTS struct is used for ptrace as well */
> -#include <asm/ds.h>
> -
>  struct task_struct;
>  
>  extern void ptrace_bts_take_timestamp(struct task_struct *, enum bts_qualifier);

Moving #include's out of an #ifdef __KERNEL__ can (and does here) break
our userspace headers.

Running "make headers_check" after touching anything under include/ is
recommended since it catches these problems.

>...
> --- /dev/null
> +++ b/include/asm-x86/vm86_mask.h
> @@ -0,0 +1,12 @@
> +#ifndef ASM_X86_VM86_MASK
> +#define ASM_X86_VM86_MASK
> +
> +#include <asm/processor-flags.h>
> +
> +#ifdef CONFIG_VM86
> +#define X86_VM_MASK	X86_EFLAGS_VM
> +#else
> +#define X86_VM_MASK	0 /* No VM86 support */
> +#endif
> +
> +#endif

Do we need a new header for this or can it go into processor-flags.h ?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

