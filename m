Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYKUO13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYKUO13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 09:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYKUO1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 09:27:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54397 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYKUO1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 09:27:20 -0500
Date: Fri, 21 Nov 2008 09:27:17 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jim Radford <radford@galvanix.net>
cc: Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: mcount record based dynamic tracing for ARM
In-Reply-To: <20081121035509.GA5266@blackbean.org>
Message-ID: <alpine.DEB.1.10.0811210917380.6447@gandalf.stny.rr.com>
References: <20081118231525.GA16081@blackbean.org> <alpine.DEB.1.10.0811201734050.14652@gandalf.stny.rr.com> <20081120224903.GA3244@blackbean.org> <alpine.DEB.1.10.0811202114560.4464@gandalf.stny.rr.com> <20081121035509.GA5266@blackbean.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Nov 2008, Jim Radford wrote:
> commit 3b17e9f39304e266edf8ef05c4a01e31c6ecbf5c
> Author: Jim Radford <radford@galvanix.com>
> Date:   Thu Nov 20 19:48:39 2008 -0800
> 
>     ftrace: enable dynamic ftrace for arm
>     
>     Update to the latest api and syncing functions with the x86 versions.

Again, Signed-off-by: is missing.

> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 9722f8b..1b4162c 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -16,7 +16,9 @@ config ARM
>  	select HAVE_ARCH_KGDB
>  	select HAVE_KPROBES if (!XIP_KERNEL)
>  	select HAVE_KRETPROBES if (HAVE_KPROBES)
> -	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
> +	select HAVE_FTRACE_MCOUNT_RECORD
> +	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)

Russell mentioned something about the code not being compatible with 
Thumb2, is the above if statement enough?

> +	select HAVE_FUNCTION_TRACER
>  	select HAVE_GENERIC_DMA_COHERENT
>  	help
>  	  The ARM series is a line of low-power-consumption RISC chip designs
> diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
> index 39c8bc1..877c0d4 100644
> --- a/arch/arm/include/asm/ftrace.h
> +++ b/arch/arm/include/asm/ftrace.h
> @@ -7,6 +7,19 @@
>  
>  #ifndef __ASSEMBLY__
>  extern void mcount(void);
> +
> +static inline unsigned long ftrace_call_adjust(unsigned long addr)
> +{
> +	return addr;
> +}
> +
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +
> +struct dyn_arch_ftrace {
> +	/* No extra data needed for x86 */

Do you mean: /* No extra data needed for ARM */

;-)

> +};
> +
> +#endif /*  CONFIG_DYNAMIC_FTRACE */
>  #endif
>  
>  #endif
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index 06269ea..06216af 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -104,14 +104,7 @@ ENDPROC(ret_from_fork)
>  #ifdef CONFIG_FUNCTION_TRACER
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  ENTRY(mcount)
> -	stmdb sp!, {r0-r3, lr}
> -	mov r0, lr
> -	sub r0, r0, #MCOUNT_INSN_SIZE
> -
> -	.globl mcount_call
> -mcount_call:
> -	bl ftrace_stub
> -	ldmia sp!, {r0-r3, pc}
> +	mov pc, lr

This looks OK. The new mcount stub for dynamic ftrace is a simple return.
It has been a while since I've programmed ARM (7 years ago), but I'm 
assuming that loading the program counter with the link register is 
a simple return.

>  
>  ENTRY(ftrace_caller)
>  	stmdb sp!, {r0-r3, lr}
> diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
> index 6c90479..d63b5a6 100644
> --- a/arch/arm/kernel/ftrace.c
> +++ b/arch/arm/kernel/ftrace.c
> @@ -23,13 +23,13 @@
>  static unsigned long bl_insn;
>  static const unsigned long NOP = 0xe1a00000; /* mov r0, r0 */
>  
> -unsigned char *ftrace_nop_replace(void)
> +static unsigned char *ftrace_nop_replace(void)
>  {
>  	return (char *)&NOP;
>  }
>  
>  /* construct a branch (BL) instruction to addr */
> -unsigned char *ftrace_call_replace(unsigned long pc, unsigned long addr)
> +static unsigned char *ftrace_call_replace(unsigned long pc, unsigned long addr)
>  {
>  	long offset;
>  
> @@ -46,7 +46,7 @@ unsigned char *ftrace_call_replace(unsigned long pc, unsigned long addr)
>  	return (unsigned char *)&bl_insn;
>  }
>  
> -int ftrace_modify_code(unsigned long pc, unsigned char *old_code,
> +static int ftrace_modify_code(unsigned long pc, unsigned char *old_code,
>  		       unsigned char *new_code)
>  {

The ftrace_modify_code could use a bit of clean up. Unless there is some
strange reason that it can not use the probe_kernel_ functions, it needs
to be updated. That approach is the most robust.  Here's an example of 
what it should look like:

{
	unsigned char replaced[MCOUNT_INSN_SIZE];

	/*
	 * Note: Due to modules and __init, code can
	 *  disappear and change, we need to protect against faulting
	 *  as well as code changing. We do this by using the
	 *  probe_kernel_* functions.
	 *
	 * No real locking needed, this code is run through
	 * kstop_machine, or before SMP starts.
	 */

	/* read the text we want to modify */
	if (probe_kernel_read(replaced, (void *)pc, MCOUNT_INSN_SIZE))
		return -EFAULT;

	/* Make sure it is what we expect it to be */
	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
		return -EINVAL;

	/* replace the text with the new text */
	if (probe_kernel_write((void *)pc, new_code, MCOUNT_INSN_SIZE))
		return -EPERM;

	flush_icache_range(pc, pc + MCOUNT_INSN_SIZE);

	return 0;
}

And the new design expects special return values:

 -EFAULT: error reading the address
 -EINVAL: what was at the address was not what we expected
 -EPERM:  could not write to the address

-- Steve


>  	unsigned long err = 0, replaced = 0, old, new;
> @@ -82,22 +82,46 @@ int ftrace_modify_code(unsigned long pc, unsigned char *old_code,
>  	return err;
>  }
>  
> +int ftrace_make_nop(struct module *mod,
> +		    struct dyn_ftrace *rec, unsigned long addr)
> +{
> +	unsigned char *new, *old;
> +	unsigned long ip = rec->ip;
> +
> +	old = ftrace_call_replace(ip, addr);
> +	new = ftrace_nop_replace();
> +
> +	return ftrace_modify_code(rec->ip, old, new);
> +}
> +
> +int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
> +{
> +	unsigned char *new, *old;
> +	unsigned long ip = rec->ip;
> +
> +	old = ftrace_nop_replace();
> +	new = ftrace_call_replace(ip, addr);
> +
> +	return ftrace_modify_code(rec->ip, old, new);
> +}
> +
>  int ftrace_update_ftrace_func(ftrace_func_t func)
>  {
> +	unsigned long ip = (unsigned long)(&ftrace_call);
> +	unsigned char old[MCOUNT_INSN_SIZE], *new;
>  	int ret;
> -	unsigned long pc, old;
> -	unsigned char *new;
>  
> -	pc = (unsigned long)&ftrace_call;
> -	memcpy(&old, &ftrace_call, MCOUNT_INSN_SIZE);
> -	new = ftrace_call_replace(pc, (unsigned long)func);
> -	ret = ftrace_modify_code(pc, (unsigned char *)&old, new);
> +	memcpy(old, &ftrace_call, sizeof(old));
> +	new = ftrace_call_replace(ip, (unsigned long)func);
> +	ret = ftrace_modify_code(ip, (unsigned char *)&old, new);
> +
>  	return ret;
>  }
>  
>  /* run from kstop_machine */
>  int __init ftrace_dyn_arch_init(void *data)
>  {
> -	ftrace_mcount_set(data);
> +	/* The return code is retured via data */
> +	*(unsigned long *)data = 0;
>  	return 0;
>  }
