Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbZCTDkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbZCTDkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZCTDkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:40:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56302 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbZCTDkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:40:07 -0400
Message-ID: <49C31021.5020305@redhat.com>
Date: Thu, 19 Mar 2009 23:40:17 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH -tip 7/9] tracing: kprobe-tracer plugin supports
 arguments
References: <49C2B4D0.8030904@redhat.com> <20090320005135.GC6895@nowhere>
In-Reply-To: <20090320005135.GC6895@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
>> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
>> index 33bb355..e801e8c 100644
>> --- a/kernel/trace/trace_kprobe.c
>> +++ b/kernel/trace/trace_kprobe.c
>> @@ -27,15 +27,124 @@
>>  #include <linux/types.h>
>>  #include <linux/string.h>
>>  #include <linux/ctype.h>
>> +#include <linux/ptrace.h>
>>
>>  #include <linux/ftrace.h>
>>  #include "trace.h"
>>
>> +/* TODO: Move these functions to arch/XXX/include/asm/ptrace.h */
>> +#define STACK_MASK (THREAD_SIZE - 1)
>> +#define valid_stack_addr(regs, addr) \
>> +	(((addr) & ~STACK_MASK) == (kernel_trap_sp(regs) & ~STACK_MASK))
>> +
>> +#if defined(__i386__)
>> +#define MAX_REG_NUM 15
>> +#elif defined(__x86_64__)
>> +#define MAX_REG_NUM 21
>> +#else
>> +#define MAX_REG_NUM (sizeof(struct pt_regs)/sizeof(unsigned long))
>> +#endif
>> +
>> +static unsigned long fetch_register(struct pt_regs *regs, void *num)
>> +{
>> +	if (unlikely((unsigned)num > MAX_REG_NUM))
>> +		return 0;
>> +	return *((unsigned long *)regs + (unsigned)num);
>> +}
>> +
>> +static unsigned long fetch_stack(struct pt_regs *regs, void *num)
>> +{
>> +	unsigned long *addr = (unsigned long *)kernel_trap_sp(regs);
>> +	addr += (unsigned)num;
>> +	if (valid_stack_addr(regs, (unsigned long)addr))
>> +		return *addr;
>> +	else
>> +		return 0;
>> +}
>> +
>> +static unsigned long fetch_memory(struct pt_regs *regs, void *addr)
>> +{
>> +	unsigned long retval;
>> +	probe_kernel_address(addr, retval);
>> +	return retval;
>> +}
> 
> 
> It will return a random value.

ah, thanks. I'll check the retval of probe_kernel_address().

>> +
>> +#if defined(__i386__)
>> +#define REGPARMS 3
>> +static unsigned long fetch_argument(struct pt_regs *regs, void *data)
>> +{
>> +	unsigned long n = (unsigned long)data;
>> +	if (n > REGPARMS) {
>> +		/*
>> +		 * The typical case: arg n is on the stack.
>> +		 * stack[0] = return address
>> +		 */
>> +		return fetch_stack(regs, (void *)(n - REGPARMS));
>> +	} else {
>> +		switch (n) {
>> +		case 1: return regs->ax;
>> +		case 2: return regs->dx;
>> +		case 3: return regs->cx;
>> +		}
>> +		return 0;
>> +	}
>> +}
>> +#elif define(__x86_64__)
>> +#define REGPARMS 6
> 
> 
> These helpers could be defined in the appropriate arch directory.
> They may even be reused by further debugging engines.

Agreed. Since we don't have any those infrastructure (arch/*/lib/debug.c ?)
yet, I just put it in trace_kprobe.c.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

