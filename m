Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbYAKAH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbYAKAH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 19:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYAKAHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 19:07:20 -0500
Received: from lizzard.sbs.de ([194.138.37.39]:17112 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbYAKAHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 19:07:19 -0500
X-Greylist: delayed 20760 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 19:07:18 EST
Message-ID: <478661B9.7050406@siemens.com>
Date: Thu, 10 Jan 2008 19:19:37 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Philippe Gerum <rpm@xenomai.org>
Subject: Re: [RFC PATCH 01/22 -v2] Add basic support for gcc profiler instrumentation
References: <20080109232914.676624725@goodmis.org> <20080109233042.386384204@goodmis.org>
In-Reply-To: <20080109233042.386384204@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Index: linux-compile-i386.git/Makefile
> ===================================================================
> --- linux-compile-i386.git.orig/Makefile	2008-01-09 14:09:36.000000000 -0500
> +++ linux-compile-i386.git/Makefile	2008-01-09 14:10:07.000000000 -0500
> @@ -509,6 +509,10 @@ endif
>  
>  include $(srctree)/arch/$(SRCARCH)/Makefile
>  
> +# MCOUNT expects frame pointer

This comment looks stray.

> +ifdef CONFIG_MCOUNT
> +KBUILD_CFLAGS	+= -pg
> +endif
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
>  else
> Index: linux-compile-i386.git/arch/x86/Kconfig
> ===================================================================
> --- linux-compile-i386.git.orig/arch/x86/Kconfig	2008-01-09 14:09:36.000000000 -0500
> +++ linux-compile-i386.git/arch/x86/Kconfig	2008-01-09 14:10:07.000000000 -0500
> @@ -28,6 +28,10 @@ config GENERIC_CMOS_UPDATE
>  	bool
>  	default y
>  
> +config ARCH_HAS_MCOUNT
> +       bool
> +       default y
> +
>  config CLOCKSOURCE_WATCHDOG
>  	bool
>  	default y
> Index: linux-compile-i386.git/arch/x86/kernel/Makefile_32
> ===================================================================
> --- linux-compile-i386.git.orig/arch/x86/kernel/Makefile_32	2008-01-09 14:09:36.000000000 -0500
> +++ linux-compile-i386.git/arch/x86/kernel/Makefile_32	2008-01-09 14:10:07.000000000 -0500
> @@ -23,6 +23,7 @@ obj-$(CONFIG_APM)		+= apm_32.o
>  obj-$(CONFIG_X86_SMP)		+= smp_32.o smpboot_32.o tsc_sync.o
>  obj-$(CONFIG_SMP)		+= smpcommon_32.o
>  obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_32.o
> +obj-$(CONFIG_MCOUNT)		+= mcount-wrapper.o

So far the code organization is different for 32 and 64 bit. I would
suggest to either

 o move both trampolines into entry_*.S or
 o put them in something like mcount-wrapper_32/64.S.

>  obj-$(CONFIG_X86_MPPARSE)	+= mpparse_32.o
>  obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_32.o nmi_32.o
>  obj-$(CONFIG_X86_IO_APIC)	+= io_apic_32.o
> Index: linux-compile-i386.git/arch/x86/kernel/mcount-wrapper.S
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-compile-i386.git/arch/x86/kernel/mcount-wrapper.S	2008-01-09 14:10:07.000000000 -0500
> @@ -0,0 +1,25 @@
> +/*
> + *  linux/arch/x86/mcount-wrapper.S
> + *
> + *  Copyright (C) 2004 Ingo Molnar
> + */
> +
> +.globl mcount
> +mcount:
> +	cmpl $0, mcount_enabled
> +	jz out
> +
> +	push %ebp
> +	mov %esp, %ebp

What is the benefit of having a call frame in this trampoline? We used
to carry this in the i386 mcount tracer for Adeos/I-pipe too (it was
derived from the -rt code), but I just successfully tested a removal
patch. Also glibc [1] doesn't include it.

> +	pushl %eax
> +	pushl %ecx
> +	pushl %edx
> +
> +	call __mcount

I think this indirection should be avoided, just like the 64-bit version
and glibc do.

> +
> +	popl %edx
> +	popl %ecx
> +	popl %eax
> +	popl %ebp
> +out:
> +	ret

...

> Index: linux-compile-i386.git/lib/tracing/mcount.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-compile-i386.git/lib/tracing/mcount.c	2008-01-09 14:10:07.000000000 -0500
> @@ -0,0 +1,77 @@
> +/*
> + * Infrastructure for profiling code inserted by 'gcc -pg'.
> + *
> + * Copyright (C) 2007 Arnaldo Carvalho de Melo <acme@redhat.com>
> + *
> + * Converted to be more generic:
> + *   Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
> + *
> + * From code in the latency_tracer, that is:
> + *
> + *  Copyright (C) 2004-2006 Ingo Molnar
> + *  Copyright (C) 2004 William Lee Irwin III
> + */
> +
> +#include <linux/module.h>
> +#include <linux/mcount.h>
> +
> +/*
> + * Since we have nothing protecting between the test of
> + * mcount_trace_function and the call to it, we can't
> + * set it to NULL without risking a race that will have
> + * the kernel call the NULL pointer. Instead, we just
> + * set the function pointer to a dummy function.
> + */
> +notrace void dummy_mcount_tracer(unsigned long ip,
> +				 unsigned long parent_ip)
> +{
> +	/* do nothing */
> +}
> +
> +mcount_func_t mcount_trace_function __read_mostly = dummy_mcount_tracer;
> +int mcount_enabled __read_mostly;
> +
> +/** __mcount - hook for profiling
> + *
> + * This routine is called from the arch specific mcount routine, that in turn is
> + * called from code inserted by gcc -pg.
> + */
> +notrace void __mcount(void)
> +{
> +	mcount_trace_function(CALLER_ADDR1, CALLER_ADDR2);
> +}

mcount_trace_function should always be called from the assembly
trampoline, IMO.

> +EXPORT_SYMBOL_GPL(mcount);
> +/*
> + * The above EXPORT_SYMBOL is for the gcc call of mcount and not the
> + * function __mcount that it is underneath. I put the export there
> + * to fool checkpatch.pl. It wants that export to be with the
> + * function, but that function happens to be in assembly.
> + */
> +
> +/**
> + * register_mcount_function - register a function for profiling
> + * @func - the function for profiling.
> + *
> + * Register a function to be called by all functions in the
> + * kernel.
> + *
> + * Note: @func and all the functions it calls must be labeled
> + *       with "notrace", otherwise it will go into a
> + *       recursive loop.
> + */
> +int register_mcount_function(mcount_func_t func)
> +{
> +	mcount_trace_function = func;
> +	return 0;
> +}
> +
> +/**
> + * clear_mcount_function - reset the mcount function
> + *
> + * This NULLs the mcount function and in essence stops
> + * tracing.  There may be lag
> + */
> +void clear_mcount_function(void)
> +{
> +	mcount_trace_function = dummy_mcount_tracer;
> +}
> Index: linux-compile-i386.git/include/linux/mcount.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-compile-i386.git/include/linux/mcount.h	2008-01-09 15:17:20.000000000 -0500
> @@ -0,0 +1,21 @@
> +#ifndef _LINUX_MCOUNT_H
> +#define _LINUX_MCOUNT_H
> +
> +#ifdef CONFIG_MCOUNT
> +extern int mcount_enabled;
> +
> +#include <linux/linkage.h>
> +
> +#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> +#define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
> +#define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))

Still used when __mcount would be gone?

> +
> +typedef void (*mcount_func_t)(unsigned long ip, unsigned long parent_ip);
> +
> +extern void mcount(void);
> +
> +int register_mcount_function(mcount_func_t func);
> +void clear_mcount_function(void);
> +
> +#endif /* CONFIG_MCOUNT */
> +#endif /* _LINUX_MCOUNT_H */
> Index: linux-compile-i386.git/arch/x86/kernel/entry_64.S
> ===================================================================
> --- linux-compile-i386.git.orig/arch/x86/kernel/entry_64.S	2008-01-09 14:09:36.000000000 -0500
> +++ linux-compile-i386.git/arch/x86/kernel/entry_64.S	2008-01-09 14:10:07.000000000 -0500
> @@ -53,6 +53,46 @@
>  
>  	.code64
>  
> +#ifdef CONFIG_MCOUNT
> +
> +ENTRY(mcount)
> +	cmpl $0, mcount_enabled
> +	jz out
> +
> +	push %rbp
> +	mov %rsp,%rbp

Same as for x86_32.

> +
> +	push %r11
> +	push %r10

glibc [2] doesn't save those two, and we were also happy without them so
far. Or are there nasty corner-cases in the kernel?

> +	push %r9
> +	push %r8
> +	push %rdi
> +	push %rsi
> +	push %rdx
> +	push %rcx
> +	push %rax

SAVE_ARGS/RESTORE_ARGS and glibc use explicit rsp manipulation + movq
instead of push/pop. I wonder if there is a small advantage, but I'm not
that deep into this arch.

> +
> +	mov 0x0(%rbp),%rax
> +	mov 0x8(%rbp),%rdi
> +	mov 0x8(%rax),%rsi

See [2] for saving one instruction here. :)

> +
> +	call   *mcount_trace_function
> +
> +	pop %rax
> +	pop %rcx
> +	pop %rdx
> +	pop %rsi
> +	pop %rdi
> +	pop %r8
> +	pop %r9
> +	pop %r10
> +	pop %r11
> +
> +	pop %rbp
> +out:
> +	ret
> +#endif
> +
>  #ifndef CONFIG_PREEMPT
>  #define retint_kernel retint_restore_args
>  #endif	

This generic approach is very appreciated here as well. It would take
away the burden of maintaining the arch-dependent stubs within I-pipe.

What we could contribute later on is a blackfin trampoline, there is
just still a bug in their toolchain which breaks mcount for modules. But
I could check with the bfin guys again about the progress and underline
the importance of this long-pending issue.

Jan

[1]http://sources.redhat.com/cgi-bin/cvsweb.cgi/libc/sysdeps/i386/i386-mcount.S?rev=1.6&content-type=text/x-cvsweb-markup&cvsroot=glibc
[2]http://sources.redhat.com/cgi-bin/cvsweb.cgi/libc/sysdeps/x86_64/_mcount.S?rev=1.5&content-type=text/x-cvsweb-markup&cvsroot=glibc

