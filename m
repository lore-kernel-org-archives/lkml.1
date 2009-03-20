Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZCTEl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZCTEl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 00:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZCTElt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 00:41:49 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54319 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZCTEls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 00:41:48 -0400
Date: Fri, 20 Mar 2009 10:11:25 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH -tip 7/9] tracing: kprobe-tracer plugin supports
	arguments
Message-ID: <20090320044125.GB6398@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <49C2B4D0.8030904@redhat.com> <20090320005135.GC6895@nowhere> <49C31021.5020305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C31021.5020305@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 11:40:17PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
> >> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> >> index 33bb355..e801e8c 100644
> >> --- a/kernel/trace/trace_kprobe.c
> >> +++ b/kernel/trace/trace_kprobe.c
> >> @@ -27,15 +27,124 @@
> >>  #include <linux/types.h>
> >>  #include <linux/string.h>
> >>  #include <linux/ctype.h>
> >> +#include <linux/ptrace.h>
> >>
> >>  #include <linux/ftrace.h>
> >>  #include "trace.h"
> >>
> >> +/* TODO: Move these functions to arch/XXX/include/asm/ptrace.h */
> >> +#define STACK_MASK (THREAD_SIZE - 1)
> >> +#define valid_stack_addr(regs, addr) \
> >> +	(((addr) & ~STACK_MASK) == (kernel_trap_sp(regs) & ~STACK_MASK))
> >> +
> >> +#if defined(__i386__)
> >> +#define MAX_REG_NUM 15
> >> +#elif defined(__x86_64__)
> >> +#define MAX_REG_NUM 21
> >> +#else
> >> +#define MAX_REG_NUM (sizeof(struct pt_regs)/sizeof(unsigned long))
> >> +#endif
> >> +
> >> +static unsigned long fetch_register(struct pt_regs *regs, void *num)
> >> +{
> >> +	if (unlikely((unsigned)num > MAX_REG_NUM))
> >> +		return 0;
> >> +	return *((unsigned long *)regs + (unsigned)num);
> >> +}
> >> +
> >> +static unsigned long fetch_stack(struct pt_regs *regs, void *num)
> >> +{
> >> +	unsigned long *addr = (unsigned long *)kernel_trap_sp(regs);
> >> +	addr += (unsigned)num;
> >> +	if (valid_stack_addr(regs, (unsigned long)addr))
> >> +		return *addr;
> >> +	else
> >> +		return 0;
> >> +}
> >> +
> >> +static unsigned long fetch_memory(struct pt_regs *regs, void *addr)
> >> +{
> >> +	unsigned long retval;
> >> +	probe_kernel_address(addr, retval);
> >> +	return retval;
> >> +}
> > 
> > 
> > It will return a random value.
> 
> ah, thanks. I'll check the retval of probe_kernel_address().
> 
> >> +
> >> +#if defined(__i386__)
> >> +#define REGPARMS 3
> >> +static unsigned long fetch_argument(struct pt_regs *regs, void *data)
> >> +{
> >> +	unsigned long n = (unsigned long)data;
> >> +	if (n > REGPARMS) {
> >> +		/*
> >> +		 * The typical case: arg n is on the stack.
> >> +		 * stack[0] = return address
> >> +		 */
> >> +		return fetch_stack(regs, (void *)(n - REGPARMS));
> >> +	} else {
> >> +		switch (n) {
> >> +		case 1: return regs->ax;
> >> +		case 2: return regs->dx;
> >> +		case 3: return regs->cx;
> >> +		}
> >> +		return 0;
> >> +	}
> >> +}
> >> +#elif define(__x86_64__)
> >> +#define REGPARMS 6
> > 
> > 
> > These helpers could be defined in the appropriate arch directory.
> > They may even be reused by further debugging engines.
> 
> Agreed. Since we don't have any those infrastructure (arch/*/lib/debug.c ?)
> yet, I just put it in trace_kprobe.c.

A better option could be to generalize syscall_get_arguments() to work
for functions other than just syscalls where pt_regs are available.

Ananth
