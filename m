Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbZDCAqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbZDCAqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZDCApy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:45:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48958 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbZDCApx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:45:53 -0400
Message-ID: <49D55C21.2060706@redhat.com>
Date: Thu, 02 Apr 2009 20:45:21 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH -tip 2/6 V4] x86: add arch-dep register and stack	access
 API to ptrace
References: <49D4F4DF.1040605@redhat.com> <20090402234835.GA6112@nowhere>
In-Reply-To: <20090402234835.GA6112@nowhere>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Apr 02, 2009 at 01:24:47PM -0400, Masami Hiramatsu wrote:
>> Add following APIs for accessing registers and stack entries from pt_regs.
>> - query_register_offset(const char *name)
>>    Query the offset of "name" register.
>>
>> - query_register_name(unsigned offset)
>>    Query the name of register by its offset.
>>
>> - get_register(struct pt_regs *regs, unsigned offset)
>>    Get the value of a register by its offset.
>>
>> - valid_stack_address(struct pt_regs *regs, unsigned long addr)
>>    Check the address is in the stack.
>>
>> - get_stack_nth(struct pt_regs *reg, unsigned nth)
>>    Get Nth entry of the stack. (N >= 0)
>>
>> - get_argument_nth(struct pt_regs *reg, unsigned nth)
>>    Get Nth argument at function call. (N >= 0)
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>
>>  arch/x86/include/asm/ptrace.h |   66 +++++++++++++++++++++++++++++++++++++++++
>>  arch/x86/kernel/ptrace.c      |   59 +++++++++++++++++++++++++++++++++++++
>>  2 files changed, 125 insertions(+), 0 deletions(-)
>>
>>
>> diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
>> index aed0894..44773b8 100644
>> --- a/arch/x86/include/asm/ptrace.h
>> +++ b/arch/x86/include/asm/ptrace.h
>> @@ -7,6 +7,7 @@
>>
>>  #ifdef __KERNEL__
>>  #include <asm/segment.h>
>> +#include <asm/page_types.h>
>>  #endif
>>
>>  #ifndef __ASSEMBLY__
>> @@ -215,6 +216,71 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
>>  	return regs->sp;
>>  }
>>
>> +/* Query offset/name of register from its name/offset */
>> +extern int query_register_offset(const char *name);
>> +extern const char *query_register_name(unsigned offset);
>> +#define MAX_REG_OFFSET (offsetof(struct pt_regs, sp))
>> +
>> +/* Get register value from its offset */
>> +static inline unsigned long get_register(struct pt_regs *regs, unsigned offset)
>> +{
>> +	if (unlikely(offset > MAX_REG_OFFSET))
>> +		return 0;
>> +	return *(unsigned long *)((unsigned long)regs + offset);
>> +}
>> +
>> +/* Check the address in the stack */
>> +static inline int valid_stack_address(struct pt_regs *regs, unsigned long addr)
>> +{
>> +	return ((addr & ~(THREAD_SIZE - 1))  ==
>> +		(kernel_trap_sp(regs) & ~(THREAD_SIZE - 1)));
>> +}
>> +
>> +/* Get Nth entry of the stack */
>> +static inline unsigned long get_stack_nth(struct pt_regs *regs, unsigned n)
>> +{
>> +	unsigned long *addr = (unsigned long *)kernel_trap_sp(regs);
>> +	addr += n;
>> +	if (valid_stack_address(regs, (unsigned long)addr))
>> +		return *addr;
>> +	else
>> +		return 0;
>> +}
>> +
>> +/* Get Nth argument at function call */
>> +static inline unsigned long get_argument_nth(struct pt_regs *regs, unsigned n)
>> +{
>> +#ifdef CONFIG_X86_32
>> +#define NR_REGPARMS 3
>> +	if (n < NR_REGPARMS) {
>> +		switch (n) {
>> +		case 0: return regs->ax;
>> +		case 1: return regs->dx;
>> +		case 2: return regs->cx;
>> +		}
>> +		return 0;
>> +#else /* CONFIG_X86_64 */
>> +#define NR_REGPARMS 6
>> +	if (n < NR_REGPARMS) {
>> +		switch (n) {
>> +		case 0: return regs->di;
>> +		case 1: return regs->si;
>> +		case 2: return regs->dx;
>> +		case 3: return regs->cx;
>> +		case 4: return regs->r8;
>> +		case 5: return regs->r9;
>> +		}
>> +		return 0;
>> +#endif
>> +	} else {
>> +		/*
>> +		 * The typical case: arg n is on the stack.
>> +		 * (Note: stack[0] = return address, so skip it)
>> +		 */
>> +		return get_stack_nth(regs, 1 + n - NR_REGPARMS);
>> +	}
>> +}
>> +
>>  /*
>>   * These are defined as per linux/ptrace.h, which see.
>>   */
>> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
>> index 5c6e463..8d65dcb 100644
>> --- a/arch/x86/kernel/ptrace.c
>> +++ b/arch/x86/kernel/ptrace.c
>> @@ -46,6 +46,65 @@ enum x86_regset {
>>  	REGSET_IOPERM32,
>>  };
>>
>> +struct pt_regs_offset {
>> +	const char *name;
>> +	int offset;
>> +};
>> +
>> +#define REG_OFFSET(r) offsetof(struct pt_regs, r)
>> +#define REG_OFFSET_NAME(r) {.name = #r, .offset = REG_OFFSET(r)}
>> +#define REG_OFFSET_END {.name = NULL, .offset = 0}
>> +
>> +static struct pt_regs_offset regoffset_table[] = {
>> +#ifdef CONFIG_X86_64
>> +	REG_OFFSET_NAME(r15),
>> +	REG_OFFSET_NAME(r14),
>> +	REG_OFFSET_NAME(r13),
>> +	REG_OFFSET_NAME(r12),
>> +	REG_OFFSET_NAME(r11),
>> +	REG_OFFSET_NAME(r10),
>> +	REG_OFFSET_NAME(r9),
>> +	REG_OFFSET_NAME(r8),
>> +#endif
>> +	REG_OFFSET_NAME(bx),
>> +	REG_OFFSET_NAME(cx),
>> +	REG_OFFSET_NAME(dx),
>> +	REG_OFFSET_NAME(si),
>> +	REG_OFFSET_NAME(di),
>> +	REG_OFFSET_NAME(bp),
>> +	REG_OFFSET_NAME(ax),
>> +#ifdef CONFIG_X86_32
>> +	REG_OFFSET_NAME(ds),
>> +	REG_OFFSET_NAME(es),
>> +	REG_OFFSET_NAME(fs),
>> +	REG_OFFSET_NAME(gs),
>> +#endif
>> +	REG_OFFSET_NAME(orig_ax),
>> +	REG_OFFSET_NAME(ip),
>> +	REG_OFFSET_NAME(cs),
> 
> 
> 
> You seem to have also forgotten ss here.

Oh, I forgot it because ss usually ignored in the kernel...
Anyway, it should be supported.


>> +	REG_OFFSET_NAME(flags),
>> +	REG_OFFSET_NAME(sp),
>> +	REG_OFFSET_END,
>> +};
>> +
>> +int query_register_offset(const char *name)
>> +{
>> +	struct pt_regs_offset *roff = regoffset_table;
>> +	for (roff = regoffset_table; roff->name != NULL; roff++)
>> +		if (!strcmp(roff->name, name))
>> +			return (unsigned)roff->offset;
> 
> 
> 
> Tiny thing here: could you set the full (unsigned int) cast?

or, I don't need to cast it...

>> +	return -EINVAL;
>> +}
>> +
>> +const char *query_register_name(unsigned offset)
>> +{
>> +	struct pt_regs_offset *roff = regoffset_table;
>> +	for (roff = regoffset_table; roff->name != NULL; roff++)
>> +		if (roff->offset == offset)
>> +			return roff->name;
>> +	return NULL;
>> +}
>> +
>>  /*
>>   * does not yet catch signals sent when the child dies.
>>   * in exit.c or in signal.c.
> 
> 
> All in one it looks good!

Thanks!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

