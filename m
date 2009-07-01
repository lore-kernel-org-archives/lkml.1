Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZGALU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZGALU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZGALUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:20:17 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62579 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbZGALTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:19:54 -0400
Message-ID: <4A4B4659.5030008@monstr.eu>
Date: Wed, 01 Jul 2009 13:19:53 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [microblaze-uclinux] [PATCH 10/11] microblaze: use generic system.h
References: <cover.1245345894.git.arnd@arndb.de> <4372408b2a754e861984bf803d8b1ade651eb827.1245347640.git.arnd@arndb.de>
In-Reply-To: <4372408b2a754e861984bf803d8b1ade651eb827.1245347640.git.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch can't be applied because generic implementation expect pointer to task struct
but microblaze low level code expect thread_info. I have one patch for MMU kernel which fixed it
but I don't have it for noMMU kernel.

Thanks,
Michal


Arnd Bergmann wrote:
> From: Remis Lima Baima <remis.developer@googlemail.com>
> 
> Parts of the microblaze system.h can be removed by
> falling back to the asm-generic version.
> 
> Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/microblaze/include/asm/cmpxchg-local.h |    1 +
>  arch/microblaze/include/asm/irqflags.h      |    2 +-
>  arch/microblaze/include/asm/system.h        |  124 +++++++--------------------
>  3 files changed, 32 insertions(+), 95 deletions(-)
>  create mode 100644 arch/microblaze/include/asm/cmpxchg-local.h
>  rewrite arch/microblaze/include/asm/system.h (67%)
> 
> diff --git a/arch/microblaze/include/asm/cmpxchg-local.h b/arch/microblaze/include/asm/cmpxchg-local.h
> new file mode 100644
> index 0000000..d3358a3
> --- /dev/null
> +++ b/arch/microblaze/include/asm/cmpxchg-local.h
> @@ -0,0 +1 @@
> +#include <asm-generic/cmpxchg-local.h>
> diff --git a/arch/microblaze/include/asm/irqflags.h b/arch/microblaze/include/asm/irqflags.h
> index dea6564..a6dbdee 100644
> --- a/arch/microblaze/include/asm/irqflags.h
> +++ b/arch/microblaze/include/asm/irqflags.h
> @@ -9,7 +9,7 @@
>  #ifndef _ASM_MICROBLAZE_IRQFLAGS_H
>  #define _ASM_MICROBLAZE_IRQFLAGS_H
>  
> -#include <linux/irqflags.h>
> +#include <asm/registers.h>
>  
>  # if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
>  
> diff --git a/arch/microblaze/include/asm/system.h b/arch/microblaze/include/asm/system.h
> dissimilarity index 67%
> index b1ed615..a26ef8e 100644
> --- a/arch/microblaze/include/asm/system.h
> +++ b/arch/microblaze/include/asm/system.h
> @@ -1,94 +1,30 @@
> -/*
> - * Copyright (C) 2006 Atmark Techno, Inc.
> - *
> - * This file is subject to the terms and conditions of the GNU General Public
> - * License. See the file "COPYING" in the main directory of this archive
> - * for more details.
> - */
> -
> -#ifndef _ASM_MICROBLAZE_SYSTEM_H
> -#define _ASM_MICROBLAZE_SYSTEM_H
> -
> -#include <asm/registers.h>
> -#include <asm/setup.h>
> -#include <asm/irqflags.h>
> -
> -#include <asm-generic/cmpxchg.h>
> -#include <asm-generic/cmpxchg-local.h>
> -
> -struct task_struct;
> -struct thread_info;
> -
> -extern struct task_struct *_switch_to(struct thread_info *prev,
> -					struct thread_info *next);
> -
> -#define switch_to(prev, next, last)					\
> -	do {								\
> -		(last) = _switch_to(task_thread_info(prev),		\
> -					task_thread_info(next));	\
> -	} while (0)
> -
> -#define smp_read_barrier_depends()	do {} while (0)
> -#define read_barrier_depends()		do {} while (0)
> -
> -#define nop()			asm volatile ("nop")
> -#define mb()			barrier()
> -#define rmb()			mb()
> -#define wmb()			mb()
> -#define set_mb(var, value)	do { var = value; mb(); } while (0)
> -#define set_wmb(var, value)	do { var = value; wmb(); } while (0)
> -
> -#define smp_mb()		mb()
> -#define smp_rmb()		rmb()
> -#define smp_wmb()		wmb()
> -
> -void show_trace(struct task_struct *task, unsigned long *stack);
> -void __bad_xchg(volatile void *ptr, int size);
> -
> -static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
> -								int size)
> -{
> -	unsigned long ret;
> -	unsigned long flags;
> -
> -	switch (size) {
> -	case 1:
> -		local_irq_save(flags);
> -		ret = *(volatile unsigned char *)ptr;
> -		*(volatile unsigned char *)ptr = x;
> -		local_irq_restore(flags);
> -		break;
> -
> -	case 4:
> -		local_irq_save(flags);
> -		ret = *(volatile unsigned long *)ptr;
> -		*(volatile unsigned long *)ptr = x;
> -		local_irq_restore(flags);
> -		break;
> -	default:
> -		__bad_xchg(ptr, size), ret = 0;
> -		break;
> -	}
> -
> -	return ret;
> -}
> -
> -void disable_hlt(void);
> -void enable_hlt(void);
> -void default_idle(void);
> -
> -#define xchg(ptr, x) \
> -	((__typeof__(*(ptr))) __xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
> -
> -void free_init_pages(char *what, unsigned long begin, unsigned long end);
> -void free_initmem(void);
> -extern char *klimit;
> -extern void ret_from_fork(void);
> -
> -#ifdef CONFIG_DEBUG_FS
> -extern struct dentry *of_debugfs_root;
> -#endif
> -
> -#define arch_align_stack(x) (x)
> -
> -#endif /* _ASM_MICROBLAZE_SYSTEM_H */
> +/*
> + * Copyright (C) 2006 Atmark Techno, Inc.
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License. See the file "COPYING" in the main directory of this archive
> + * for more details.
> + */
> +#ifndef _ASM_MICROBLAZE_SYSTEM_H
> +#define _ASM_MICROBLAZE_SYSTEM_H
> +
> +#define __switch_to	_switch_to
> +
> +#include <asm/irqflags.h>
> +#include <asm-generic/system.h>
> +
> +#ifdef CONFIG_DEBUG_FS
> +extern struct dentry *of_debugfs_root;
> +#endif
> +
> +void show_trace(struct task_struct *task, unsigned long *stack);
> +void disable_hlt(void);
> +void enable_hlt(void);
> +void default_idle(void);
> +void free_init_pages(char *what, unsigned long begin, unsigned long end);
> +void free_initmem(void);
> +
> +extern char *klimit;
> +extern void ret_from_fork(void);
> +
> +#endif /* _ASM_MICROBLAZE_SYSTEM_H */

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
