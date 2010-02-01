Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab0BAK2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:28:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52456 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab0BAK2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:28:45 -0500
Date: Mon, 1 Feb 2010 11:28:43 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, Abhishek Sagar <sagar.abhishek@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ftrace: re-enable dynamic ftrace for ARM
Message-ID: <20100201102843.GA31714@pengutronix.de>
References: <1264959196-5175-1-git-send-email-rabin@rab.in> <1264959196-5175-2-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1264959196-5175-2-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

On Sun, Jan 31, 2010 at 11:03:16PM +0530, Rabin Vincent wrote:
> This adds mcount recording and updates dynamic ftrace for ARM to work
> with the new ftrace dyamic tracing implementation.
> 
> With dynamic tracing, mcount() is implemented as a nop.  Callsites are
> patched on startup with nops, and dynamically patched to call to the
> ftrace_caller() routine as needed.
> 
> One oddity of the ARM implementation is that we need to handle two kinds
> of mcounts.  Newer GCC versions renamed the mcount routine (to
> __gnu_mcount_nc) and changed the semantics (lr is pushed on the stack
> before the call).  We detect which one is used at run-time.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Abhishek Sagar <sagar.abhishek@gmail.com>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  arch/arm/Kconfig               |    2 +
>  arch/arm/include/asm/ftrace.h  |   14 +++++
>  arch/arm/kernel/entry-common.S |   25 ++++++---
>  arch/arm/kernel/ftrace.c       |  122 ++++++++++++++++++++++++++--------------
>  scripts/recordmcount.pl        |    2 +
>  5 files changed, 115 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 4c33ca8..dc92691 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -17,6 +17,8 @@ config ARM
>  	select HAVE_KPROBES if (!XIP_KERNEL)
>  	select HAVE_KRETPROBES if (HAVE_KPROBES)
>  	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
> +	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
> +	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL && !THUMB2_KERNEL)
>  	select HAVE_GENERIC_DMA_COHERENT
>  	select HAVE_KERNEL_GZIP
>  	select HAVE_KERNEL_LZO
> diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
> index 103f7ee..12f445d 100644
> --- a/arch/arm/include/asm/ftrace.h
> +++ b/arch/arm/include/asm/ftrace.h
> @@ -8,6 +8,20 @@
>  #ifndef __ASSEMBLY__
>  extern void mcount(void);
>  extern void __gnu_mcount_nc(void);
> +
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +struct dyn_arch_ftrace {
> +	bool	gnu_mcount;
> +};
> +
> +static inline unsigned long ftrace_call_adjust(unsigned long addr)
> +{
> +	return addr;
> +}
> +
> +extern void ftrace_caller_gnu(void);
> +#endif
> +
>  #endif
>  
>  #endif
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index 2c1db77..2a7ab14 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -93,16 +93,25 @@ ENDPROC(ret_from_fork)
>  
>  #ifdef CONFIG_FUNCTION_TRACER
>  #ifdef CONFIG_DYNAMIC_FTRACE
> +ENTRY(__gnu_mcount_nc)
> +	mov	ip, lr
> +	ldm	sp!, {lr}
> +	mov	pc, ip
> +
>  ENTRY(mcount)
> -	stmdb sp!, {r0-r3, lr}
> -	mov r0, lr
> -	sub r0, r0, #MCOUNT_INSN_SIZE
> +	stmdb	sp!, {lr}
> +	ldr	lr, [fp, #-4]
> +	ldmia	sp!, {pc}
>  
> -	.globl mcount_call
> -mcount_call:
> -	bl ftrace_stub
> -	ldr lr, [fp, #-4]			@ restore lr
> -	ldmia sp!, {r0-r3, pc}
> +ENTRY(ftrace_caller_gnu)
> +	add	sp, sp,	#4
> +
> +	/*
> +	 * We take advantage of the fact that we build with frame pointers and
> +	 * -mapcs-frame to combine the ftrace_caller implementations for the
> +	 * two mcounts with just the above adjustment.  This will need to be
> +	 * revisited if Thumb-2 support is added.
> +	 */
>  
>  ENTRY(ftrace_caller)
>  	stmdb sp!, {r0-r3, lr}
> diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
> index c638427..1d5d268 100644
> --- a/arch/arm/kernel/ftrace.c
> +++ b/arch/arm/kernel/ftrace.c
> @@ -7,11 +7,12 @@
>   *
>   * Defines low-level handling of mcount calls when the kernel
>   * is compiled with the -pg flag. When using dynamic ftrace, the
> - * mcount call-sites get patched lazily with NOP till they are
> - * enabled. All code mutation routines here take effect atomically.
> + * mcount call-sites get patched with NOP till they are enabled.
> + * All code mutation routines here take effect atomically.
>   */
>  
>  #include <linux/ftrace.h>
> +#include <linux/uaccess.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/ftrace.h>
> @@ -20,17 +21,26 @@
>  #define BL_OPCODE      0xeb000000
>  #define BL_OFFSET_MASK 0x00ffffff
>  
> -static unsigned long bl_insn;
> -static const unsigned long NOP = 0xe1a00000; /* mov r0, r0 */
> +#define	NOP		0xe1a00000	/* mov r0, r0 */
> +#define	GNU_NOP		0xe8bd4000	/* pop {lr} */
>  
> -unsigned char *ftrace_nop_replace(void)
> +#define GNU_MCOUNT_ADDR	((unsigned long) __gnu_mcount_nc)
> +#define GNU_FTRACE_ADDR ((unsigned long) ftrace_caller_gnu)
> +
> +static unsigned long ftrace_nop_replace(struct dyn_ftrace *rec)
> +{
> +	return rec->arch.gnu_mcount ? GNU_NOP : NOP;
> +}
> +
> +static unsigned long ftrace_caller_addr(struct dyn_ftrace *rec)
>  {
> -	return (char *)&NOP;
> +	return rec->arch.gnu_mcount ? GNU_FTRACE_ADDR : FTRACE_ADDR;
>  }
>  
>  /* construct a branch (BL) instruction to addr */
> -unsigned char *ftrace_call_replace(unsigned long pc, unsigned long addr)
> +static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
>  {
> +	unsigned long bl_insn;
>  	long offset;
>  
>  	offset = (long)addr - (long)(pc + PC_OFFSET);
> @@ -39,65 +49,93 @@ unsigned char *ftrace_call_replace(unsigned long pc, unsigned long addr)
>  		 * doesn't generate branches outside of kernel text.
>  		 */
>  		WARN_ON_ONCE(1);
> -		return NULL;
> +		return 0;
>  	}
>  	offset = (offset >> 2) & BL_OFFSET_MASK;
>  	bl_insn = BL_OPCODE | offset;
> -	return (unsigned char *)&bl_insn;
> +	return bl_insn;
>  }
>  
> -int ftrace_modify_code(unsigned long pc, unsigned char *old_code,
> -		       unsigned char *new_code)
> +static int ftrace_modify_code(unsigned long pc, unsigned long old,
> +			      unsigned long new)
>  {
> -	unsigned long err = 0, replaced = 0, old, new;
> +	unsigned long replaced;
>  
> -	old = *(unsigned long *)old_code;
> -	new = *(unsigned long *)new_code;
> +	if (probe_kernel_read(&replaced, (void *)pc, MCOUNT_INSN_SIZE))
> +		return -EFAULT;
>  
> -	__asm__ __volatile__ (
> -		"1:  ldr    %1, [%2]  \n"
> -		"    cmp    %1, %4    \n"
> -		"2:  streq  %3, [%2]  \n"
> -		"    cmpne  %1, %3    \n"
> -		"    movne  %0, #2    \n"
> -		"3:\n"
> +	if (replaced != old)
> +		return -EINVAL;
>  
> -		".section .fixup, \"ax\"\n"
> -		"4:  mov  %0, #1  \n"
> -		"    b    3b      \n"
> -		".previous\n"
> +	if (probe_kernel_write((void *)pc, &new, MCOUNT_INSN_SIZE))
> +		return -EPERM;
>  
> -		".section __ex_table, \"a\"\n"
> -		"    .long 1b, 4b \n"
> -		"    .long 2b, 4b \n"
> -		".previous\n"
> +	flush_icache_range(pc, pc + MCOUNT_INSN_SIZE);
>  
> -		: "=r"(err), "=r"(replaced)
> -		: "r"(pc), "r"(new), "r"(old), "0"(err), "1"(replaced)
> -		: "memory");
> -
> -	if (!err && (replaced == old))
> -		flush_icache_range(pc, pc + MCOUNT_INSN_SIZE);
> -
> -	return err;
> +	return 0;
>  }
>  
>  int ftrace_update_ftrace_func(ftrace_func_t func)
>  {
> -	int ret;
>  	unsigned long pc, old;
> -	unsigned char *new;
> +	unsigned long new;
>  
>  	pc = (unsigned long)&ftrace_call;
>  	memcpy(&old, &ftrace_call, MCOUNT_INSN_SIZE);
>  	new = ftrace_call_replace(pc, (unsigned long)func);
> -	ret = ftrace_modify_code(pc, (unsigned char *)&old, new);
> +
> +	return ftrace_modify_code(pc, old, new);
> +}
> +
> +int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
> +{
> +	unsigned long new, old;
> +	unsigned long ip = rec->ip;
> +
> +	old = ftrace_nop_replace(rec);
> +	new = ftrace_call_replace(ip, ftrace_caller_addr(rec));
> +
> +	return ftrace_modify_code(rec->ip, old, new);
> +}
> +
> +static int ftrace_detect_make_nop(struct module *mod,
> +				  struct dyn_ftrace *rec, unsigned long addr)
> +{
> +	unsigned long ip = rec->ip;
> +	unsigned long call;
> +	int ret;
> +
> +	call = ftrace_call_replace(ip, GNU_MCOUNT_ADDR);
> +	ret = ftrace_modify_code(ip, call, GNU_NOP);
> +	if (!ret)
> +		rec->arch.gnu_mcount = true;
> +	else if (ret == -EINVAL) {
> +		call = ftrace_call_replace(ip, addr);
> +		ret = ftrace_modify_code(ip, call, NOP);
> +	}
> +
>  	return ret;
>  }
Wouldn't it be nice to patch out the instruction pushing lr to the
stack (in the gnu case)?  Should work, shouldn't it.

Thanks for looking into that.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
