Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbYENNcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbYENNcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYENNch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:32:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbYENNcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:32:36 -0400
Message-ID: <482AE9E2.6040801@redhat.com>
Date: Wed, 14 May 2008 09:32:18 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]: sparc64: Add ftrace support.
References: <20080513.220659.95712585.davem@davemloft.net>
In-Reply-To: <20080513.220659.95712585.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  arch/sparc64/Kconfig         |    1 +
>  arch/sparc64/Kconfig.debug   |    2 +-
>  arch/sparc64/kernel/Makefile |    1 +
>  arch/sparc64/kernel/ftrace.c |   99 ++++++++++++++++++++++++++++++++++++++++++
>  arch/sparc64/lib/mcount.S    |   58 +++++++++++++++++++++++--
>  5 files changed, 156 insertions(+), 5 deletions(-)
>  create mode 100644 arch/sparc64/kernel/ftrace.c
> 
> diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
> index 4c40862..56344b1 100644
> --- a/arch/sparc64/Kconfig
> +++ b/arch/sparc64/Kconfig
> @@ -15,6 +15,7 @@ config SPARC64
>  	select HAVE_LMB
>  	select HAVE_ARCH_KGDB
>  	select HAVE_IMMEDIATE
> +	select HAVE_FTRACE
>  
>  config GENERIC_TIME
>  	bool
> diff --git a/arch/sparc64/Kconfig.debug b/arch/sparc64/Kconfig.debug
> index 6a4d28a..d6d32d1 100644
> --- a/arch/sparc64/Kconfig.debug
> +++ b/arch/sparc64/Kconfig.debug
> @@ -33,7 +33,7 @@ config DEBUG_PAGEALLOC
>  
>  config MCOUNT
>  	bool
> -	depends on STACK_DEBUG
> +	depends on STACK_DEBUG || FTRACE
>  	default y
>  
>  config FRAME_POINTER
> diff --git a/arch/sparc64/kernel/Makefile b/arch/sparc64/kernel/Makefile
> index 311c797..52e933f 100644
> --- a/arch/sparc64/kernel/Makefile
> +++ b/arch/sparc64/kernel/Makefile
> @@ -14,6 +14,7 @@ obj-y		:= process.o setup.o cpu.o idprom.o \
>  		   power.o sbus.o sparc64_ksyms.o chmc.o \
>  		   visemul.o prom.o of_device.o hvapi.o sstate.o mdesc.o
>  
> +obj-$(CONFIG_DYNAMIC_FTRACE) += ftrace.o
>  obj-$(CONFIG_STACKTRACE) += stacktrace.o
>  obj-$(CONFIG_PCI)	 += ebus.o pci_common.o \
>  			    pci_psycho.o pci_sabre.o pci_schizo.o \
> diff --git a/arch/sparc64/kernel/ftrace.c b/arch/sparc64/kernel/ftrace.c
> new file mode 100644
> index 0000000..f449e6d
> --- /dev/null
> +++ b/arch/sparc64/kernel/ftrace.c
> @@ -0,0 +1,99 @@
> +#include <linux/spinlock.h>
> +#include <linux/hardirq.h>
> +#include <linux/ftrace.h>
> +#include <linux/percpu.h>
> +#include <linux/init.h>
> +#include <linux/list.h>
> +
> +static const u32 ftrace_nop = 0x01000000;
> +
> +notrace int ftrace_ip_converted(unsigned long ip)

FYI,

If you look in the kernel/Makefile you will see a way to have the whole 
file not be traced. This will eliminate the need for the "notrace" 
annotation on all functions. I haven't update the x86 version of ftrace 
to do this so you probably just copied the old method from us.

If you add the following in arch/sparc64/kernel/Makefile

ifdef CONFIG_DYNAMIC_FTRACE
obj-y += ftrace.o
# Do not trace the ftrace code itself
ORIG_CFLAGS := $(KBUILD_CFLAGS)
KBUILD_CFLAGS = $(if $(filter-out ftrace, $(basename $(notdir $@))), \
	$(ORIG_CFLAGS), \
	$(subst -pg,,$(ORIG_CFLAGS)))
endif

Then you wont need the "notrace" annotations on the functions.

/me needs to send Ingo a patch to do this for x86 as well.

> +{
> +	u32 insn = *(u32 *) ip;
> +
> +	return (insn == ftrace_nop);
> +}
> +
> +notrace unsigned char *ftrace_nop_replace(void)
> +{
> +	return (char *)&ftrace_nop;
> +}
> +
> +notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
> +{
> +	static u32 call;
> +	s32 off;
> +
> +	off = ((s32)addr - (s32)ip);
> +	call = 0x40000000 | ((u32)off >> 2);
> +
> +	return (unsigned char *) &call;
> +}
> +
> +notrace int
> +ftrace_modify_code(unsigned long ip, unsigned char *old_code,
> +		   unsigned char *new_code)
> +{
> +	u32 old = *(u32 *)old_code;
> +	u32 new = *(u32 *)new_code;
> +	u32 replaced;
> +	int faulted;
> +
> +	__asm__ __volatile__(
> +	"1:	cas	[%[ip]], %[old], %[new]\n"
> +	"	flush	%[ip]\n"
> +	"	mov	0, %[faulted]\n"
> +	"2:\n"
> +	"	.section .fixup,#alloc,#execinstr\n"
> +	"	.align	4\n"
> +	"3:	sethi	%%hi(2b), %[faulted]\n"
> +	"	jmpl	%[faulted] + %%lo(2b), %%g0\n"
> +	"	 mov	1, %[faulted]\n"
> +	"	.previous\n"
> +	"	.section __ex_table,\"a\"\n"
> +	"	.align	4\n"
> +	"	.word	1b, 3b\n"
> +	"	.previous\n"
> +	: "=r" (replaced), [faulted] "=r" (faulted)
> +	: [new] "0" (new), [old] "r" (old), [ip] "r" (ip)
> +	: "memory");

I'm so use to the %1 %2 and %3's I should update the x86 code to use the 
names as well. (nice)

> +
> +	if (replaced != old && replaced != new)
> +		faulted = 2;

Thanks for putting in the "2", I may plan on doing something different 
later if the code didn't "fault" but something else happened. I should 
also make MACROS out of that and not uses 1 and 2.

> +
> +	return faulted;
> +}
> +
> +notrace int ftrace_update_ftrace_func(ftrace_func_t func)
> +{
> +	unsigned long ip = (unsigned long)(&ftrace_call);
> +	unsigned char old[4], *new;
> +
> +	memcpy(old, &ftrace_call, 4);
> +	new = ftrace_call_replace(ip, (unsigned long)func);
> +	return ftrace_modify_code(ip, old, new);
> +}
> +
> +notrace int ftrace_mcount_set(unsigned long *data)
> +{
> +	unsigned long ip = (long)(&mcount_call);
> +	unsigned long *addr = data;
> +	unsigned char old[4], *new;
> +
> +	/*
> +	 * Replace the mcount stub with a pointer to the
> +	 * ip recorder function.
> +	 */
> +	memcpy(old, &mcount_call, 4);
> +	new = ftrace_call_replace(ip, *addr);
> +	*addr = ftrace_modify_code(ip, old, new);
> +
> +	return 0;
> +}
> +
> +
> +int __init ftrace_dyn_arch_init(void *data)
> +{
> +	ftrace_mcount_set(data);
> +	return 0;
> +}
> diff --git a/arch/sparc64/lib/mcount.S b/arch/sparc64/lib/mcount.S
> index 9e4534b..7735a7a 100644
> --- a/arch/sparc64/lib/mcount.S
> +++ b/arch/sparc64/lib/mcount.S
> @@ -28,10 +28,13 @@ ovstack:
>  	.skip		OVSTACKSIZE
>  #endif
>  	.text
> -	.align 32
> -	.globl mcount, _mcount
> -mcount:
> +	.align		32
> +	.globl		_mcount
> +	.type		_mcount,#function
> +	.globl		mcount
> +	.type		mcount,#function
>  _mcount:
> +mcount:
>  #ifdef CONFIG_STACK_DEBUG
>  	/*
>  	 * Check whether %sp is dangerously low.
> @@ -55,6 +58,53 @@ _mcount:
>  	 or		%g3, %lo(panicstring), %o0
>  	call		prom_halt
>  	 nop
> +1:
> +#endif
> +#ifdef CONFIG_FTRACE
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +	mov		%o7, %o0
> +	.globl		mcount_call
> +mcount_call:
> +	call		ftrace_stub
> +	 mov		%o0, %o7

WOW! Sparc64 has some really efficient context saving!

> +#else
> +	sethi		%hi(ftrace_trace_function), %g1
> +	sethi		%hi(ftrace_stub), %g2
> +	ldx		[%g1 + %lo(ftrace_trace_function)], %g1
> +	or		%g2, %lo(ftrace_stub), %g2
> +	cmp		%g1, %g2
> +	be,pn		%icc, 1f
> +	 mov		%i7, %o1
> +	jmpl		%g1, %g0
> +	 mov		%o7, %o0
> +	/* not reached */
> +1:
>  #endif
> -1:	retl
> +#endif
> +	retl
>  	 nop
> +	.size		_mcount,.-_mcount
> +	.size		mcount,.-mcount
> +
> +#ifdef CONFIG_FTRACE
> +	.globl		ftrace_stub
> +	.type		ftrace_stub,#function
> +ftrace_stub:
> +	retl
> +	 nop
> +	.size		ftrace_stub,.-ftrace_stub
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +	.globl		ftrace_caller
> +	.type		ftrace_caller,#function
> +ftrace_caller:
> +	mov		%i7, %o1
> +	mov		%o7, %o0
> +	.globl		ftrace_call
> +ftrace_call:
> +	call		ftrace_stub
> +	 mov		%o0, %o7
> +	retl
> +	 nop
> +	.size		ftrace_caller,.-ftrace_caller
> +#endif
> +#endif

Looks great!

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve
