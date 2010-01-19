Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640Ab0ASHVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0ASHVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548Ab0ASHVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:21:14 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41355 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab0ASHVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:21:12 -0500
Message-ID: <4B5558B1.3070504@linux.vnet.ibm.com>
Date: Tue, 19 Jan 2010 12:31:05 +0530
From: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@ozlabs.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Michael Neuling <mikey@neuling.org>, systemtap@sources.redhat.com,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH -tip tracing/kprobes v2] Powerpc port of the kprobe-based
 event tracer
References: <20100111125952.604518521@mars.in.ibm.com> <20100111130210.GA31980@in.ibm.com> <1263525141.724.393.camel@pasglop>
In-Reply-To: <1263525141.724.393.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Hi Mahesh !
>
Hi Benjamin,

>> +/**
>> + * regs_within_kernel_stack() - check the address in the stack
>> + * @regs:      pt_regs which contains kernel stack pointer.
>> + * @addr:      address which is checked.
>> + *
>> + * regs_within_kernel_stack() checks @addr is within the kernel stack page(s).
>> + * If @addr is within the kernel stack, it returns true. If not, returns false.
>> + */
>> +
>> +static inline bool regs_within_kernel_stack(struct pt_regs *regs,
>> +						unsigned long addr)
>> +{
>> +	return ((addr & ~(THREAD_SIZE - 1))  ==
>> +		(kernel_stack_pointer(regs) & ~(THREAD_SIZE - 1)));
>> +}
> 
> Out of curiosity, what is the above meant for ? I'm trying to understand
> because it will not work with such things as interrupt or softirq
> stack...
> 
This function is used to validate whether the given address falls within 
the stack boundary. This gets invoked through kprobe pre/post handler 
routine's while fetching nth entry from the stack. Even though it is 
called in interrupt context, the pt_regs that we are using is in context 
of kernel routine where the probe was hit.

>> +/**
>> + * regs_get_kernel_stack_nth() - get Nth entry of the stack
>> + * @regs:	pt_regs which contains kernel stack pointer.
>> + * @n:		stack entry number.
>> + *
>> + * regs_get_kernel_stack_nth() returns @n th entry of the kernel stack which
>> + * is specified by @regs. If the @n th entry is NOT in the kernel stack,
>> + * this returns 0.
>> + */
>> +static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
>> +						      unsigned int n)
>> +{
>> +	unsigned long *addr = (unsigned long *)kernel_stack_pointer(regs);
>> +	addr += n;
>> +	if (regs_within_kernel_stack(regs, (unsigned long)addr))
>> +		return *addr;
>> +	else
>> +		return 0;
>> +}
> 
> Is this meant to fetch stack based arguments or do backtraces or similar
> or does this have a different purpose ?
> 
The purpose is to allow kernel developer to fetch/monitor n'th entry on 
the stack when the probe is hit, through ftrace plugin. It can also be 
used to fetch stack based arguments.

Following is the example how kernel developer may use it to fetch n'th 
entry from the stack:

# echo p:myprobe do_sys_open S1=\$stack1 S2=\$stack2 > 
/sys/kernel/debug/tracing/kprobe_events
# echo 1 > /sys/kernel/debug/tracing/events/kprobes/myprobe/enable

# cat trace
# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
            pcscd-4159  [001] 668343.548210: myprobe: 
(.do_sys_open+0x0/0x1a4) S1=c000000000c29d20 S2=c00000000019d774
            pcscd-4159  [001] 668343.548308: myprobe: 
(.do_sys_open+0x0/0x1a4) S1=c000000000c29d20 S2=c00000000019d774
            pcscd-4159  [001] 668343.548331: myprobe: 
(.do_sys_open+0x0/0x1a4) S1=c000000000c29d20 S2=c0000000001f1f30
            pcscd-4159  [001] 668343.548377: myprobe: 
(.do_sys_open+0x0/0x1a4) S1=c000000000c29d20 S2=c00000000019d774
            pcscd-4159  [001] 668343.548399: myprobe: 
(.do_sys_open+0x0/0x1a4) S1=c000000000c29d20 S2=c00000000019d774


>>  /*
>>   * These are defined as per linux/ptrace.h, which see.
>>   */
>> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
>> index ef14988..e816aba 100644
>> --- a/arch/powerpc/kernel/ptrace.c
>> +++ b/arch/powerpc/kernel/ptrace.c
>> @@ -39,6 +39,108 @@
>>  #include <asm/system.h>
>>  
>>  /*
>> + * The parameter save area on the stack is used to store arguments being passed
>> + * to callee function and is located at fixed offset from stack pointer.
>> + */
>> +#ifdef CONFIG_PPC32
>> +#define PARAMETER_SAVE_AREA_OFFSET	24  /* bytes */
>> +#else /* CONFIG_PPC32 */
>> +#define PARAMETER_SAVE_AREA_OFFSET	48  /* bytes */
>> +#endif
>> +
>> +struct pt_regs_offset {
>> +	const char *name;
>> +	int offset;
>> +};
>> +
>> +#define REG_OFFSET_NAME(r) {.name = #r, .offset = offsetof(struct pt_regs, r)}
>> +#define REG_OFFSET_END {.name = NULL, .offset = 0}
>> +
>> +static const struct pt_regs_offset regoffset_table[] = {
>> +	REG_OFFSET_NAME(gpr[0]),
>> +	REG_OFFSET_NAME(gpr[1]),
>> +	REG_OFFSET_NAME(gpr[2]),
>> +	REG_OFFSET_NAME(gpr[3]),
>> +	REG_OFFSET_NAME(gpr[4]),
>> +	REG_OFFSET_NAME(gpr[5]),
>> +	REG_OFFSET_NAME(gpr[6]),
>> +	REG_OFFSET_NAME(gpr[7]),
>> +	REG_OFFSET_NAME(gpr[8]),
>> +	REG_OFFSET_NAME(gpr[9]),
>> +	REG_OFFSET_NAME(gpr[10]),
>> +	REG_OFFSET_NAME(gpr[11]),
>> +	REG_OFFSET_NAME(gpr[12]),
>> +	REG_OFFSET_NAME(gpr[13]),
>> +	REG_OFFSET_NAME(gpr[14]),
>> +	REG_OFFSET_NAME(gpr[15]),
>> +	REG_OFFSET_NAME(gpr[16]),
>> +	REG_OFFSET_NAME(gpr[17]),
>> +	REG_OFFSET_NAME(gpr[18]),
>> +	REG_OFFSET_NAME(gpr[19]),
>> +	REG_OFFSET_NAME(gpr[20]),
>> +	REG_OFFSET_NAME(gpr[21]),
>> +	REG_OFFSET_NAME(gpr[22]),
>> +	REG_OFFSET_NAME(gpr[23]),
>> +	REG_OFFSET_NAME(gpr[24]),
>> +	REG_OFFSET_NAME(gpr[25]),
>> +	REG_OFFSET_NAME(gpr[26]),
>> +	REG_OFFSET_NAME(gpr[27]),
>> +	REG_OFFSET_NAME(gpr[28]),
>> +	REG_OFFSET_NAME(gpr[29]),
>> +	REG_OFFSET_NAME(gpr[30]),
>> +	REG_OFFSET_NAME(gpr[31]),
> 
> I find it weird that you have the [ an ] in the name ... We usually name
> these guys gpr0...gpr31 or even r0...r31. Is that name user visible ?
> Maybe you should use a different macro GPR_OFFSET_NAME(num) that
> generates both gpr[num] for the offsetof and r##num for the register
> name.
>
Yup, make sense. I will make the change. Will use gpr0...gpr31 to be 
consistent with pt_regs structure member name "gpr".

>> +	REG_OFFSET_NAME(nip),
>> +	REG_OFFSET_NAME(msr),
>> +	REG_OFFSET_NAME(orig_gpr3),
>> +	REG_OFFSET_NAME(ctr),
>> +	REG_OFFSET_NAME(link),
>> +	REG_OFFSET_NAME(xer),
>> +	REG_OFFSET_NAME(ccr),
>> +#ifdef CONFIG_PPC64
>> +	REG_OFFSET_NAME(softe),
>> +#else
>> +	REG_OFFSET_NAME(mq),
>> +#endif
>> +	REG_OFFSET_NAME(trap),
>> +	REG_OFFSET_NAME(dar),
>> +	REG_OFFSET_NAME(dsisr),
>> +	REG_OFFSET_NAME(result),
>> +	REG_OFFSET_END,
>> +};
> 
> Do you need to expose orig_gpr3 and result there ?
> 
I had included them to give an exact representation of pt_regs 
structure. However, I am ok with dropping them.
> Cheers,
> Ben.
> 
> 

Thanks for reviewing.
-Mahesh.
