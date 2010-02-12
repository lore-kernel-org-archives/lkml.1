Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0BLVsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:48:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab0BLVsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:48:10 -0500
Message-ID: <4B75CC76.4030301@redhat.com>
Date: Fri, 12 Feb 2010 16:47:34 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] s390: add pt_regs register and stack access API
References: <20100210162610.GC6933@osiris.boeblingen.de.ibm.com> <4B73691A.8080100@redhat.com> <20100212123840.GB27548@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100212123840.GB27548@osiris.boeblingen.de.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Wed, Feb 10, 2010 at 09:19:06PM -0500, Masami Hiramatsu wrote:
>>> +int regs_query_register_offset(const char *name);
>>> +const char *regs_query_register_name(unsigned int offset);
>>> +unsigned long regs_get_argument_nth(struct pt_regs *regs, unsigned int n);
>>
>> Hmm, the latest kprobe-tracer on -tip/master doesn't support
>> regs_get_argument_nth() anymore, because the function ABI
>> strongly depends on each function interface, compile option
>> etc. So I removed it (14640106f243a3b29944d7198569090fa6546f2d
>> and aa5add93e92019018e905146f8c3d3f8e3c08300).
>>
>> Yeah, those patches are still on -tip tree. Since I'm working on
>> -tip/master for kprobe-tracer etc., please work on -tip tree.
> 
> Ok, here is an updated patch without regs_get_argument_nth:
> 
> Subject: [PATCH] s390: add pt_regs register and stack access API
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> This API is needed for the kprobe-based event tracer.

Thank you,
At least interfaces looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>

> 
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/s390/Kconfig              |    1 
>  arch/s390/include/asm/ptrace.h |   13 ++++++++-
>  arch/s390/kernel/ptrace.c      |   58 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 71 insertions(+), 1 deletion(-)
> 
> --- a/arch/s390/include/asm/ptrace.h
> +++ b/arch/s390/include/asm/ptrace.h
> @@ -492,13 +492,24 @@ struct user_regs_struct
>  struct task_struct;
>  extern void user_enable_single_step(struct task_struct *);
>  extern void user_disable_single_step(struct task_struct *);
> +extern void show_regs(struct pt_regs * regs);
>  
>  #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
>  #define instruction_pointer(regs) ((regs)->psw.addr & PSW_ADDR_INSN)
>  #define user_stack_pointer(regs)((regs)->gprs[15])
>  #define regs_return_value(regs)((regs)->gprs[2])
>  #define profile_pc(regs) instruction_pointer(regs)
> -extern void show_regs(struct pt_regs * regs);
> +
> +int regs_query_register_offset(const char *name);
> +const char *regs_query_register_name(unsigned int offset);
> +unsigned long regs_get_register(struct pt_regs *regs, unsigned int offset);
> +unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs, unsigned int n);
> +
> +static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
> +{
> +	return regs->gprs[15] & PSW_ADDR_INSN;
> +}
> +
>  #endif /* __KERNEL__ */
>  #endif /* __ASSEMBLY__ */
>  
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -90,6 +90,7 @@ config S390
>  	select HAVE_SYSCALL_TRACEPOINTS
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_FUNCTION_GRAPH_TRACER
> +	select HAVE_REGS_AND_STACK_ACCESS_API
>  	select HAVE_DEFAULT_NO_SPIN_MUTEXES
>  	select HAVE_OPROFILE
>  	select HAVE_KPROBES
> --- a/arch/s390/kernel/ptrace.c
> +++ b/arch/s390/kernel/ptrace.c
> @@ -992,3 +992,61 @@ const struct user_regset_view *task_user
>  #endif
>  	return &user_s390_view;
>  }
> +
> +static const char *gpr_names[NUM_GPRS] = {
> +	"r0", "r1",  "r2",  "r3",  "r4",  "r5",  "r6",  "r7",
> +	"r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
> +};
> +
> +unsigned long regs_get_register(struct pt_regs *regs, unsigned int offset)
> +{
> +	if (offset >= NUM_GPRS)
> +		return 0;
> +	return regs->gprs[offset];
> +}
> +
> +int regs_query_register_offset(const char *name)
> +{
> +	unsigned long offset;
> +
> +	if (!name || *name != 'r')
> +		return -EINVAL;
> +	if (strict_strtoul(name + 1, 10, &offset))
> +		return -EINVAL;
> +	if (offset >= NUM_GPRS)
> +		return -EINVAL;
> +	return offset;
> +}
> +
> +const char *regs_query_register_name(unsigned int offset)
> +{
> +	if (offset >= NUM_GPRS)
> +		return NULL;
> +	return gpr_names[offset];
> +}
> +
> +static int regs_within_kernel_stack(struct pt_regs *regs, unsigned long addr)
> +{
> +	unsigned long ksp = kernel_stack_pointer(regs);
> +
> +	return (addr & ~(THREAD_SIZE - 1)) == (ksp & ~(THREAD_SIZE - 1));
> +}
> +
> +/**
> + * regs_get_kernel_stack_nth() - get Nth entry of the stack
> + * @regs:pt_regs which contains kernel stack pointer.
> + * @n:stack entry number.
> + *
> + * regs_get_kernel_stack_nth() returns @n th entry of the kernel stack which
> + * is specifined by @regs. If the @n th entry is NOT in the kernel stack,
> + * this returns 0.
> + */
> +unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs, unsigned int n)
> +{
> +	unsigned long addr;
> +
> +	addr = kernel_stack_pointer(regs) + n * sizeof(long);
> +	if (!regs_within_kernel_stack(regs, addr))
> +		return 0;
> +	return *(unsigned long *)addr;
> +}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

