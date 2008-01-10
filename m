Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbYAJTzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbYAJTzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbYAJTyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:54:51 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:58811 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbYAJTyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:54:49 -0500
Date: Thu, 10 Jan 2008 14:54:04 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [RFC PATCH 01/22 -v2] Add basic support for gcc profiler
 instrumentation
In-Reply-To: <478661B9.7050406@siemens.com>
Message-ID: <Pine.LNX.4.58.0801101411000.15391@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org> <20080109233042.386384204@goodmis.org>
 <478661B9.7050406@siemens.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 10 Jan 2008, Jan Kiszka wrote:

> Steven Rostedt wrote:
> > Index: linux-compile-i386.git/Makefile
> > ===================================================================
> > --- linux-compile-i386.git.orig/Makefile	2008-01-09 14:09:36.000000000 -0500
> > +++ linux-compile-i386.git/Makefile	2008-01-09 14:10:07.000000000 -0500
> > @@ -509,6 +509,10 @@ endif
> >
> >  include $(srctree)/arch/$(SRCARCH)/Makefile
> >
> > +# MCOUNT expects frame pointer
>
> This comment looks stray.

Actually it's not ;-)

The original code had something like this:

#if CONFIG_MCOUNT
KBUILD_CFLAGS += ...
#else
#if CONFIG_FRAME_POINTER
KBUILD_CFLAGS += ...
#else
KBUILD_CFLAGS += ...
#endif
#endif

And Sam Ravnborg suggested to put that logic into the Kbuild system. For
which I did, but I put that comment there to just let others know that
MCOUNT expects the flags of FRAME_POINTER. But, I guess we can nuke that
comment anyway. It just leads to confusion.

>
> > +ifdef CONFIG_MCOUNT
> > +KBUILD_CFLAGS	+= -pg
> > +endif
> >  ifdef CONFIG_FRAME_POINTER
> >  KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
> >  else
> > Index: linux-compile-i386.git/arch/x86/Kconfig
> > ===================================================================
> > --- linux-compile-i386.git.orig/arch/x86/Kconfig	2008-01-09 14:09:36.000000000 -0500
> > +++ linux-compile-i386.git/arch/x86/Kconfig	2008-01-09 14:10:07.000000000 -0500
> > @@ -28,6 +28,10 @@ config GENERIC_CMOS_UPDATE
> >  	bool
> >  	default y
> >
> > +config ARCH_HAS_MCOUNT
> > +       bool
> > +       default y
> > +
> >  config CLOCKSOURCE_WATCHDOG
> >  	bool
> >  	default y
> > Index: linux-compile-i386.git/arch/x86/kernel/Makefile_32
> > ===================================================================
> > --- linux-compile-i386.git.orig/arch/x86/kernel/Makefile_32	2008-01-09 14:09:36.000000000 -0500
> > +++ linux-compile-i386.git/arch/x86/kernel/Makefile_32	2008-01-09 14:10:07.000000000 -0500
> > @@ -23,6 +23,7 @@ obj-$(CONFIG_APM)		+= apm_32.o
> >  obj-$(CONFIG_X86_SMP)		+= smp_32.o smpboot_32.o tsc_sync.o
> >  obj-$(CONFIG_SMP)		+= smpcommon_32.o
> >  obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_32.o
> > +obj-$(CONFIG_MCOUNT)		+= mcount-wrapper.o
>
> So far the code organization is different for 32 and 64 bit. I would
> suggest to either
>
>  o move both trampolines into entry_*.S or
>  o put them in something like mcount-wrapper_32/64.S.

Yeah, that's a relic from -rt. I never liked that, but I was just too lazy
to change it. I think I'll move the mcount_wrapper into entry_32.S

>
> >  obj-$(CONFIG_X86_MPPARSE)	+= mpparse_32.o
> >  obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_32.o nmi_32.o
> >  obj-$(CONFIG_X86_IO_APIC)	+= io_apic_32.o
> > Index: linux-compile-i386.git/arch/x86/kernel/mcount-wrapper.S
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-compile-i386.git/arch/x86/kernel/mcount-wrapper.S	2008-01-09 14:10:07.000000000 -0500
> > @@ -0,0 +1,25 @@
> > +/*
> > + *  linux/arch/x86/mcount-wrapper.S
> > + *
> > + *  Copyright (C) 2004 Ingo Molnar
> > + */
> > +
> > +.globl mcount
> > +mcount:
> > +	cmpl $0, mcount_enabled
> > +	jz out
> > +
> > +	push %ebp
> > +	mov %esp, %ebp
>
> What is the benefit of having a call frame in this trampoline? We used
> to carry this in the i386 mcount tracer for Adeos/I-pipe too (it was
> derived from the -rt code), but I just successfully tested a removal
> patch. Also glibc [1] doesn't include it.

Hmm, what about having frame pointers on? Isn't that a requirement?

>
> > +	pushl %eax
> > +	pushl %ecx
> > +	pushl %edx
> > +
> > +	call __mcount
>
> I think this indirection should be avoided, just like the 64-bit version
> and glibc do.

I thought about that too, but didn't have the time to look into the
calling convention for that. <does a quick look at glibc>

# objdump --start-address 0x`nm /lib/libc-2.7.so | sed -ne '/ mcount$/s/^\([0-9a-f]*\).*/\1/p'` -D /lib/libc-2.7.so |head -28 |tail -12
49201cd0 <_mcount>:
49201cd0:       50                      push   %eax
49201cd1:       51                      push   %ecx
49201cd2:       52                      push   %edx
49201cd3:       8b 54 24 0c             mov    0xc(%esp),%edx
49201cd7:       8b 45 04                mov    0x4(%ebp),%eax
49201cda:       e8 91 f4 ff ff          call   49201170
<__mcount_internal>
49201cdf:       5a                      pop    %edx
49201ce0:       59                      pop    %ecx
49201ce1:       58                      pop    %eax
49201ce2:       c3                      ret
49201ce3:       90                      nop

Until I found out about the frame pointers, I'll leave in the ebp copy.

>
> > +
> > +	popl %edx
> > +	popl %ecx
> > +	popl %eax
> > +	popl %ebp
> > +out:
> > +	ret
>
> ....

[...]

> > +/** __mcount - hook for profiling
> > + *
> > + * This routine is called from the arch specific mcount routine, that in turn is
> > + * called from code inserted by gcc -pg.
> > + */
> > +notrace void __mcount(void)
> > +{
> > +	mcount_trace_function(CALLER_ADDR1, CALLER_ADDR2);
> > +}
>
> mcount_trace_function should always be called from the assembly
> trampoline, IMO.

I'll try that.

> > Index: linux-compile-i386.git/include/linux/mcount.h
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-compile-i386.git/include/linux/mcount.h	2008-01-09 15:17:20.000000000 -0500
> > @@ -0,0 +1,21 @@
> > +#ifndef _LINUX_MCOUNT_H
> > +#define _LINUX_MCOUNT_H
> > +
> > +#ifdef CONFIG_MCOUNT
> > +extern int mcount_enabled;
> > +
> > +#include <linux/linkage.h>
> > +
> > +#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> > +#define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
> > +#define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
>
> Still used when __mcount would be gone?

Will be used later on by the tracers. Actually, I wish this was in a more
generic kernel header, since I find myself typing
"__builtin_return_address" quite often.

>
> > +
> > +typedef void (*mcount_func_t)(unsigned long ip, unsigned long parent_ip);
> > +
> > +extern void mcount(void);
> > +
> > +int register_mcount_function(mcount_func_t func);
> > +void clear_mcount_function(void);
> > +
> > +#endif /* CONFIG_MCOUNT */
> > +#endif /* _LINUX_MCOUNT_H */
> > Index: linux-compile-i386.git/arch/x86/kernel/entry_64.S
> > ===================================================================
> > --- linux-compile-i386.git.orig/arch/x86/kernel/entry_64.S	2008-01-09 14:09:36.000000000 -0500
> > +++ linux-compile-i386.git/arch/x86/kernel/entry_64.S	2008-01-09 14:10:07.000000000 -0500
> > @@ -53,6 +53,46 @@
> >
> >  	.code64
> >
> > +#ifdef CONFIG_MCOUNT
> > +
> > +ENTRY(mcount)
> > +	cmpl $0, mcount_enabled
> > +	jz out
> > +
> > +	push %rbp
> > +	mov %rsp,%rbp
>
> Same as for x86_32.

Same checking for frame pointers too.

>
> > +
> > +	push %r11
> > +	push %r10
>
> glibc [2] doesn't save those two, and we were also happy without them so
> far. Or are there nasty corner-cases in the kernel?

Probably not. I'll see what happens without them.

>
> > +	push %r9
> > +	push %r8
> > +	push %rdi
> > +	push %rsi
> > +	push %rdx
> > +	push %rcx
> > +	push %rax
>
> SAVE_ARGS/RESTORE_ARGS and glibc use explicit rsp manipulation + movq
> instead of push/pop. I wonder if there is a small advantage, but I'm not
> that deep into this arch.

Yeah, it's probably a bit faster to do the mov instead. I'll add that.

>
> > +
> > +	mov 0x0(%rbp),%rax
> > +	mov 0x8(%rbp),%rdi
> > +	mov 0x8(%rax),%rsi
>
> See [2] for saving one instruction here. :)

hehe, yeah, will do.

>
> > +
> > +	call   *mcount_trace_function
> > +
> > +	pop %rax
> > +	pop %rcx
> > +	pop %rdx
> > +	pop %rsi
> > +	pop %rdi
> > +	pop %r8
> > +	pop %r9
> > +	pop %r10
> > +	pop %r11
> > +
> > +	pop %rbp
> > +out:
> > +	ret
> > +#endif
> > +
> >  #ifndef CONFIG_PREEMPT
> >  #define retint_kernel retint_restore_args
> >  #endif
>
> This generic approach is very appreciated here as well. It would take
> away the burden of maintaining the arch-dependent stubs within I-pipe.
>
> What we could contribute later on is a blackfin trampoline, there is
> just still a bug in their toolchain which breaks mcount for modules. But
> I could check with the bfin guys again about the progress and underline
> the importance of this long-pending issue.

Thanks,

-- Steve

