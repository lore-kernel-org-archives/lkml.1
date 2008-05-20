Return-Path: <linux-kernel-owner+w=401wt.eu-S932947AbYETOcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbYETOcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764911AbYETOcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:32:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34013 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763784AbYETOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:32:11 -0400
Date: Tue, 20 May 2008 10:32:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Michael Ellerman <michael@ellerman.id.au>
cc: Ingo Molnar <mingo@elte.hu>, proski@gnu.org, a.p.zijlstra@chello.nl,
       pq@iki.fi, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       sandmann@redhat.com, paulus@samba.org
Subject: Re: [PATCH 2/2] ftrace: support for PowerPC
In-Reply-To: <1211292277.7960.8.camel@localhost>
Message-ID: <Pine.LNX.4.58.0805201017140.1838@gandalf.stny.rr.com>
References: <20080515034942.109223655@goodmis.org>  <20080515035918.896765954@goodmis.org>
 <1211292277.7960.8.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 21 May 2008, Michael Ellerman wrote:

> On Wed, 2008-05-14 at 23:49 -0400, Steven Rostedt wrote:
> > plain text document attachment (ftrace-powerpc-port.patch)
> > This patch adds full support for ftrace for PowerPC (both 64 and 32 bit).
> > This includes dynamic tracing and function filtering.
>
> Hi Steven,
>
> Just a few comments inline ..

Hi Michael,

I really appreciate this. It's been a few years since I did any real PPC
programming, so any comments are most definitely welcome.


>
> > Index: linux-sched-devel.git/arch/powerpc/kernel/Makefile
> > ===================================================================
> > --- linux-sched-devel.git.orig/arch/powerpc/kernel/Makefile	2008-05-14 19:30:53.000000000 -0700
> > +++ linux-sched-devel.git/arch/powerpc/kernel/Makefile	2008-05-14 19:31:56.000000000 -0700
> > @@ -12,6 +12,18 @@ CFLAGS_prom_init.o      += -fPIC
> >  CFLAGS_btext.o		+= -fPIC
> >  endif
> >
> > +ifdef CONFIG_FTRACE
> > +# Do not trace early boot code
> > +CFLAGS_REMOVE_cputable.o = -pg
> > +CFLAGS_REMOVE_prom_init.o = -pg
>
> Why do we not want to trace early boot? Just because it's not useful?

The -pg flag makes calls to the mcount code. I didn't look too deeply, but
at least in my first prototypes the early boot up code would crash when
calling mcount. I found that simply keeping them from calling mcount made
things OK. Perhaps I'm just hiding the problem, but the tracing wont
happen anyway that early. We need to set up memory before tracing starts.

>
> > Index: linux-sched-devel.git/arch/powerpc/kernel/entry_32.S
> > ===================================================================
> > --- linux-sched-devel.git.orig/arch/powerpc/kernel/entry_32.S	2008-05-14 19:30:50.000000000 -0700
> > +++ linux-sched-devel.git/arch/powerpc/kernel/entry_32.S	2008-05-14 19:31:56.000000000 -0700
> > @@ -1035,3 +1035,133 @@ machine_check_in_rtas:
> >  	/* XXX load up BATs and panic */
> >
> ... snip
>
> > +_GLOBAL(mcount)
> > +_GLOBAL(_mcount)
> > +	stwu	r1,-48(r1)
> > +	stw	r3, 12(r1)
> > +	stw	r4, 16(r1)
> > +	stw	r5, 20(r1)
> > +	stw	r6, 24(r1)
> > +	mflr	r3
> > +	lwz	r4, 52(r1)
> > +	mfcr	r5
> > +	stw	r7, 28(r1)
> > +	stw	r8, 32(r1)
> > +	stw	r9, 36(r1)
> > +	stw	r10,40(r1)
> > +	stw	r3, 44(r1)
> > +	stw	r5, 8(r1)
> > +
> > +	LOAD_REG_ADDR(r5, ftrace_trace_function)
> > +#if 0
> > +	mtctr	r3
> > +	mr	r1, r5
> > +	bctrl
> > +#endif
> > +	lwz	r5,0(r5)
> > +#if 1
> > +	mtctr	r5
> > +	bctrl
> > +#else
> > +	bl	ftrace_stub
> > +#endif
>
> #if 0, #if 1 ?

Ouch! Thanks, that's leftover from debugging.

>
> > Index: linux-sched-devel.git/arch/powerpc/kernel/ftrace.c
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-sched-devel.git/arch/powerpc/kernel/ftrace.c	2008-05-14 19:31:56.000000000 -0700
> > @@ -0,0 +1,165 @@
> > +/*
> > + * Code for replacing ftrace calls with jumps.
> > + *
> > + * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
> > + *
> > + * Thanks goes out to P.A. Semi, Inc for supplying me with a PPC64 box.
> > + *
> > + */
> > +
> > +#include <linux/spinlock.h>
> > +#include <linux/hardirq.h>
> > +#include <linux/ftrace.h>
> > +#include <linux/percpu.h>
> > +#include <linux/init.h>
> > +#include <linux/list.h>
> > +
> > +#include <asm/cacheflush.h>
> > +
> > +#define CALL_BACK		4
>
> I don't grok what you're doing with CALL_BACK, you add it in places and
> subtract in others - and it looks like you could do neither, but I haven't
> gone over it in detail.

I tried hard to make most of the complex logic stay in generic code.

What dynamic ftrace does is at start up the code is simply a nop. Then
after initialization of ftrace, it calls kstop-machine that will call into
the arch code to convert the nop to a call to a "record_ip" function.
That record_ip function will start recording the return address of the
mcount function (__builtin_return_address(0)).

Then later, once a second the ftraced wakes up and checks if any new
functions have been recorded. If they have been, then it calls
kstop_machine againg and for each recorded function, it passes in the
address that was recorded.

The arch is responsible for knowning how to translate the
__builtin_return_address(0) into the address of the location of the call,
to be able to modify that code.

On boot up, all functions call "mcount". The ftraced daemon will convert
those calls to nop, and when tracing is enabled, then they will be
converted to point directly to the tracing function.

This helps tremondously in making ftrace efficient.

>
> > +static unsigned int ftrace_nop = 0x60000000;
>
> I should really add a #define for that.
>
> > +#ifdef CONFIG_PPC32
> > +# define GET_ADDR(addr) addr
> > +#else
> > +/* PowerPC64's functions are data that points to the functions */
> > +# define GET_ADDR(addr) *(unsigned long *)addr
> > +#endif
>
> And that.
>
> ... snip
>
> > +notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
> > +{
> > +	static unsigned int op;
> > +
> > +	addr = GET_ADDR(addr);
> > +
> > +	/* Set to "bl addr" */
> > +	op = 0x48000001 | (ftrace_calc_offset(ip, addr) & 0x03fffffe);
>
> 0x03fffffe should be 0x03fffffc, if you set bit 1 you'll end with a "bla" instruction,
> ie. branch absolute and link. That shouldn't happen as long as ip and addr are
> properly aligned, but still.

Thanks for the update. I guess I miss read the documents I have.

>
> In fact I think you should just use create_function_call() or create_branch() from
> include/asm-powerpc/system.h

Also good to know. I'll look into replacing them with these.

>
> > +#ifdef CONFIG_PPC64
> > +# define _ASM_ALIGN	" .align 3 "
> > +# define _ASM_PTR	" .llong "
> > +#else
> > +# define _ASM_ALIGN	" .align 2 "
> > +# define _ASM_PTR	" .long "
> > +#endif
>
> We already have a #define for .long, it's called PPC_LONG (asm/asm-compat.h)
>
> Perhaps we should add one for .align, PPC_LONG_ALIGN or something?

Ah, thanks. I'll wait till I see a PPC_LONG_ALIGN ;-)


>
> > +notrace int
> > +ftrace_modify_code(unsigned long ip, unsigned char *old_code,
> > +		   unsigned char *new_code)
> > +{
> > +	unsigned replaced;
> > +	unsigned old = *(unsigned *)old_code;
> > +	unsigned new = *(unsigned *)new_code;
> > +	int faulted = 0;
> > +
> > +	/* move the IP back to the start of the call */
> > +	ip -= CALL_BACK;
> > +
> > +	/*
> > +	 * Note: Due to modules and __init, code can
> > +	 *  disappear and change, we need to protect against faulting
> > +	 *  as well as code changing.
> > +	 *
> > +	 * No real locking needed, this code is run through
> > +	 * kstop_machine.
> > +	 */
> > +	asm volatile (
> > +		"1: lwz		%1, 0(%2)\n"
> > +		"   cmpw	%1, %5\n"
> > +		"   bne		2f\n"
> > +		"   stwu	%3, 0(%2)\n"
> > +		"2:\n"
> > +		".section .fixup, \"ax\"\n"
> > +		"3:	li %0, 1\n"
> > +		"	b 2b\n"
> > +		".previous\n"
> > +		".section __ex_table,\"a\"\n"
> > +		_ASM_ALIGN "\n"
> > +		_ASM_PTR "1b, 3b\n"
> > +		".previous"
>
> Or perhaps we just need a macro for adding exception table entries.

Yeah, that was taken from what x86 does.

>
> > +		: "=r"(faulted), "=r"(replaced)
> > +		: "r"(ip), "r"(new),
> > +		  "0"(faulted), "r"(old)
> > +		: "memory");
> > +
> > +	if (replaced != old && replaced != new)
> > +		faulted = 2;
> > +
> > +	if (!faulted)
> > +		flush_icache_range(ip, ip + 8);
> > +
> > +	return faulted;
> > +}
>
> > Index: linux-sched-devel.git/arch/powerpc/kernel/setup_32.c
> > ===================================================================
> > --- linux-sched-devel.git.orig/arch/powerpc/kernel/setup_32.c	2008-05-14 19:30:50.000000000 -0700
> > +++ linux-sched-devel.git/arch/powerpc/kernel/setup_32.c	2008-05-14 19:31:56.000000000 -0700
> > @@ -47,6 +47,11 @@
> >  #include <asm/kgdb.h>
> >  #endif
> >
> > +#ifdef CONFIG_FTRACE
> > +extern void _mcount(void);
> > +EXPORT_SYMBOL(_mcount);
> > +#endif
>
> Can you please put the extern in a header, and the EXPORT_SYMBOL in
> arch/powerpc/kernel/ftrace.c?

Actually, I think Ingo added this into the generic code. I'll see what's
in there now.

>
> > Index: linux-sched-devel.git/arch/powerpc/kernel/setup_64.c
> > ===================================================================
> > --- linux-sched-devel.git.orig/arch/powerpc/kernel/setup_64.c	2008-05-14 19:30:50.000000000 -0700
> > +++ linux-sched-devel.git/arch/powerpc/kernel/setup_64.c	2008-05-14 19:31:56.000000000 -0700
> > @@ -85,6 +85,11 @@ struct ppc64_caches ppc64_caches = {
> >  };
> >  EXPORT_SYMBOL_GPL(ppc64_caches);
> >
> > +#ifdef CONFIG_FTRACE
> > +extern void _mcount(void);
> > +EXPORT_SYMBOL(_mcount);
> > +#endif
>
> Ditto.

Ditto too ;-)


Thanks a lot for you feedback!

-- Steve

