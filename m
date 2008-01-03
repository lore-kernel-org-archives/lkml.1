Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbYACRf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbYACRf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYACRfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:35:15 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:53010 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbYACRfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:35:12 -0500
X-Greylist: delayed 751 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 12:35:11 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAMmrfEdMROHU/2dsb2JhbACBV6hd
Date: Thu, 3 Jan 2008 12:35:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 01/11] Add basic support for gcc profiler
	instrumentation
Message-ID: <20080103173506.GA30582@Krystal>
References: <20080103071609.478486470@goodmis.org> <20080103072226.776141236@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080103072226.776141236@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:23:25 up 60 days, 22:28,  5 users,  load average: 0.13, 0.25,
	0.26
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
...
> Index: linux-compile.git/arch/x86/Kconfig
> ===================================================================
> --- linux-compile.git.orig/arch/x86/Kconfig	2008-01-03 01:02:28.000000000 -0500
> +++ linux-compile.git/arch/x86/Kconfig	2008-01-03 01:02:33.000000000 -0500
> @@ -28,6 +28,12 @@ config GENERIC_CMOS_UPDATE
>  	bool
>  	default y
>  
> +# function tracing might turn this off:
> +config REGPARM
> +	bool
> +	depends on !MCOUNT
> +	default y
> +
>  config CLOCKSOURCE_WATCHDOG
>  	bool
>  	default y
....
> Index: linux-compile.git/arch/x86/kernel/mcount-wrapper.S
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-compile.git/arch/x86/kernel/mcount-wrapper.S	2008-01-03 01:02:33.000000000 -0500
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
> +	pushl %eax
> +	pushl %ecx
> +	pushl %edx
> +
> +	call __mcount
> +
> +	popl %edx
> +	popl %ecx
> +	popl %eax
> +	popl %ebp

Writing this stack setup in assembly may be the one thing that conflicts
with REGPARM ?

> +out:
> +	ret
> Index: linux-compile.git/include/linux/linkage.h
> ===================================================================
> --- linux-compile.git.orig/include/linux/linkage.h	2008-01-03 01:02:28.000000000 -0500
> +++ linux-compile.git/include/linux/linkage.h	2008-01-03 01:02:33.000000000 -0500
> @@ -3,6 +3,8 @@
>  
>  #include <asm/linkage.h>
>  
> +#define notrace __attribute__((no_instrument_function))
> +
>  #ifdef __cplusplus
>  #define CPP_ASMLINKAGE extern "C"
>  #else
> Index: linux-compile.git/kernel/sysctl.c
> ===================================================================
> --- linux-compile.git.orig/kernel/sysctl.c	2008-01-03 01:02:28.000000000 -0500
> +++ linux-compile.git/kernel/sysctl.c	2008-01-03 01:02:33.000000000 -0500
> @@ -46,6 +46,7 @@
>  #include <linux/nfs_fs.h>
>  #include <linux/acpi.h>
>  #include <linux/reboot.h>
> +#include <linux/mcount.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/processor.h>
> @@ -470,6 +471,16 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= &proc_dointvec,
>  	},
> +#ifdef CONFIG_MCOUNT
> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "mcount_enabled",
> +		.data		= &mcount_enabled,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec,
> +	},
> +#endif
>  #ifdef CONFIG_KMOD
>  	{
>  		.ctl_name	= KERN_MODPROBE,
> Index: linux-compile.git/lib/Kconfig.debug
> ===================================================================
> --- linux-compile.git.orig/lib/Kconfig.debug	2008-01-03 01:02:28.000000000 -0500
> +++ linux-compile.git/lib/Kconfig.debug	2008-01-03 01:02:33.000000000 -0500
> @@ -517,4 +517,6 @@ config FAULT_INJECTION_STACKTRACE_FILTER
>  	help
>  	  Provide stacktrace filter for fault-injection capabilities
>  
> +source lib/mcount/Kconfig
> +
>  source "samples/Kconfig"
> Index: linux-compile.git/lib/Makefile
> ===================================================================
> --- linux-compile.git.orig/lib/Makefile	2008-01-03 01:02:28.000000000 -0500
> +++ linux-compile.git/lib/Makefile	2008-01-03 01:02:33.000000000 -0500
> @@ -66,6 +66,8 @@ obj-$(CONFIG_AUDIT_GENERIC) += audit.o
>  obj-$(CONFIG_SWIOTLB) += swiotlb.o
>  obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
>  
> +obj-$(CONFIG_MCOUNT) += mcount/
> +
>  lib-$(CONFIG_GENERIC_BUG) += bug.o
>  
>  hostprogs-y	:= gen_crc32table
> Index: linux-compile.git/lib/mcount/Kconfig
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-compile.git/lib/mcount/Kconfig	2008-01-03 01:02:33.000000000 -0500
> @@ -0,0 +1,6 @@
> +
> +# MCOUNT itself is useless, or will just be added overhead.
> +# It needs something to register a function with it.
> +config MCOUNT
> +	bool
> +	depends on DEBUG_KERNEL
> Index: linux-compile.git/lib/mcount/Makefile
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-compile.git/lib/mcount/Makefile	2008-01-03 01:02:33.000000000 -0500
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_MCOUNT) += libmcount.o
> +
> +libmcount-objs := mcount.o
> Index: linux-compile.git/lib/mcount/mcount.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-compile.git/lib/mcount/mcount.c	2008-01-03 01:02:33.000000000 -0500
> @@ -0,0 +1,78 @@
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
> +mcount_func_t mcount_trace_function = dummy_mcount_tracer;
> +int mcount_enabled;
> +
> +/** __mcount - hook for profiling
> + *
> + * This routine is called from the arch specific mcount routine, that in turn is
> + * called from code inserted by gcc -pg.
> + */
> +notrace void __mcount(void)
> +{
> +	if (mcount_trace_function != dummy_mcount_tracer)
> +		mcount_trace_function(CALLER_ADDR1, CALLER_ADDR2);
> +}

I don't see what the mcount_trace_function test gives us here : we
already tested mcount_enabled.

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
> Index: linux-compile.git/include/linux/mcount.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-compile.git/include/linux/mcount.h	2008-01-03 01:02:33.000000000 -0500
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
> Index: linux-compile.git/arch/x86/kernel/entry_64.S
> ===================================================================
> --- linux-compile.git.orig/arch/x86/kernel/entry_64.S	2008-01-03 01:02:28.000000000 -0500
> +++ linux-compile.git/arch/x86/kernel/entry_64.S	2008-01-03 01:02:33.000000000 -0500
> @@ -53,6 +53,52 @@
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
> +
> +	lea dummy_mcount_tracer, %rbp
> +	cmpq %rbp, mcount_trace_function


Ok, so we normally jump over the function call (with mcount_enabled being 0)
but we can call it in rare cases when it is being set concurrently (even
though the mcount_trace_function is there, concurrency could still allow
the call).

Therefore we have one data cache hit when disabled (mcount_enabled), and
must do a supplementary comparison before the call when enabled. I
wonder why the cmpq %rbp, mcount_trace_function test is there at all ?


> +	jz out_rbp
> +
> +	mov %rsp,%rbp
> +
> +	push %r11
> +	push %r10
> +	push %r9
> +	push %r8
> +	push %rdi
> +	push %rsi
> +	push %rdx
> +	push %rcx
> +	push %rax
> +
> +	mov 0x0(%rbp),%rax
> +	mov 0x8(%rbp),%rdi
> +	mov 0x8(%rax),%rsi
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
> +out_rbp:
> +	pop %rbp
> +out:
> +	ret
> +#endif
> +
>  #ifndef CONFIG_PREEMPT
>  #define retint_kernel retint_restore_args
>  #endif	
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
