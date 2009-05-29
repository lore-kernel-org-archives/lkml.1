Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZE2BN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZE2BN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 21:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZE2BNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 21:13:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33953 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZE2BNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 21:13:51 -0400
Date: Thu, 28 May 2009 21:13:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: wuzhangjin@gmail.com
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzj@lemote.com>, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH v1 1/5] mips static function tracer support
In-Reply-To: <4c501e9dec76ac317021c9d7dd62a8a5ed13812c.1243543471.git.wuzj@lemote.com>
Message-ID: <alpine.DEB.2.00.0905281713260.11238@gandalf.stny.rr.com>
References: <cover.1243543471.git.wuzj@lemote.com> <4c501e9dec76ac317021c9d7dd62a8a5ed13812c.1243543471.git.wuzj@lemote.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 May 2009, wuzhangjin@gmail.com wrote:

> From: Wu Zhangjin <wuzj@lemote.com>
> 
> if -pg of gcc is enabled. a calling to _mcount will be inserted to each
> kernel function. so, there is a possibility to trace the functions in
> _mcount.
> 
> here is the implementation of mips specific _mcount for static function
> tracer.
> 
> -ffunction-sections option not works with -pg, so disable it if enables
> FUNCTION_TRACER.
> 
> Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
> ---
>  arch/mips/Kconfig              |    2 +
>  arch/mips/Makefile             |    2 +
>  arch/mips/include/asm/ftrace.h |   25 ++++++++++-
>  arch/mips/kernel/Makefile      |    8 +++
>  arch/mips/kernel/mcount.S      |   98 ++++++++++++++++++++++++++++++++++++++++
>  arch/mips/kernel/mips_ksyms.c  |    5 ++
>  6 files changed, 139 insertions(+), 1 deletions(-)
>  create mode 100644 arch/mips/kernel/mcount.S
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 09b1287..d5c01ca 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -4,6 +4,8 @@ config MIPS
>  	select HAVE_IDE
>  	select HAVE_OPROFILE
>  	select HAVE_ARCH_KGDB
> +	select HAVE_FUNCTION_TRACER
> +	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	# Horrible source of confusion.  Die, die, die ...
>  	select EMBEDDED
>  	select RTC_LIB
> diff --git a/arch/mips/Makefile b/arch/mips/Makefile
> index c4cae9e..f86fb15 100644
> --- a/arch/mips/Makefile
> +++ b/arch/mips/Makefile
> @@ -48,7 +48,9 @@ ifneq ($(SUBARCH),$(ARCH))
>    endif
>  endif
>  
> +ifndef CONFIG_FUNCTION_TRACER
>  cflags-y := -ffunction-sections
> +endif
>  cflags-y += $(call cc-option, -mno-check-zero-division)
>  
>  ifdef CONFIG_32BIT
> diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.h
> index 40a8c17..5f8ebcf 100644
> --- a/arch/mips/include/asm/ftrace.h
> +++ b/arch/mips/include/asm/ftrace.h
> @@ -1 +1,24 @@
> -/* empty */
> +/*
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive for
> + * more details.
> + *
> + * Copyright (C) 2009 DSLab, Lanzhou University, China
> + * Author: Wu Zhangjin <wuzj@lemote.com>
> + */
> +
> +#ifndef _ASM_MIPS_FTRACE_H
> +#define _ASM_MIPS_FTRACE_H
> +
> +#ifdef CONFIG_FUNCTION_TRACER
> +
> +#define MCOUNT_ADDR ((unsigned long)(_mcount))
> +#define MCOUNT_INSN_SIZE 4		/* sizeof mcount call */
> +
> +#ifndef __ASSEMBLY__
> +extern void _mcount(void);
> +#define mcount _mcount
> +
> +#endif /* __ASSEMBLY__ */
> +#endif /* CONFIG_FUNCTION_TRACER */
> +#endif /* _ASM_MIPS_FTRACE_H */
> diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
> index e961221..d167dde 100644
> --- a/arch/mips/kernel/Makefile
> +++ b/arch/mips/kernel/Makefile
> @@ -8,6 +8,12 @@ obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
>  		   ptrace.o reset.o setup.o signal.o syscall.o \
>  		   time.o topology.o traps.o unaligned.o watch.o
>  
> +ifdef CONFIG_FUNCTION_TRACER
> +# Do not profile debug and lowlevel utilities
> +CFLAGS_REMOVE_mcount.o = -pg

mcount.S is an assembly file, the above is for C files. So it is not 
needed.

-- Steve

> +CFLAGS_REMOVE_early_printk.o = -pg
> +endif
> +
>  obj-$(CONFIG_CEVT_BCM1480)	+= cevt-bcm1480.o
>  obj-$(CONFIG_CEVT_R4K_LIB)	+= cevt-r4k.o
>  obj-$(CONFIG_MIPS_MT_SMTC)	+= cevt-smtc.o
> @@ -24,6 +30,8 @@ obj-$(CONFIG_SYNC_R4K)		+= sync-r4k.o
>  obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
>  obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
>  
> +obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
> +
>  obj-$(CONFIG_CPU_LOONGSON2)	+= r4k_fpu.o r4k_switch.o
>  obj-$(CONFIG_CPU_MIPS32)	+= r4k_fpu.o r4k_switch.o
>  obj-$(CONFIG_CPU_MIPS64)	+= r4k_fpu.o r4k_switch.o
> diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
> new file mode 100644
> index 0000000..268724e
> --- /dev/null
