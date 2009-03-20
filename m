Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbZCTL34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbZCTL34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759831AbZCTL3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:29:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53988 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759318AbZCTL3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:29:38 -0400
Message-ID: <49C37E28.2020304@redhat.com>
Date: Fri, 20 Mar 2009 07:29:44 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH -tip 7/9] tracing: kprobe-tracer plugin supports
 arguments
References: <49C2B4D0.8030904@redhat.com> <20090320081914.GD6398@in.ibm.com>
In-Reply-To: <20090320081914.GD6398@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
> On Thu, Mar 19, 2009 at 05:10:40PM -0400, Masami Hiramatsu wrote:
> 
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
> 
> #elif defined(__x86_64__)

Ahh, yes.

> 
>> +#define REGPARMS 6
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
>> +		case 1: return regs->di;
>> +		case 2: return regs->si;
>> +		case 3: return regs->dx;
>> +		case 4: return regs->cx;
>> +		case 5: return regs->r8;
>> +		case 6: return regs->r9;
>> +		}
>> +		return 0;
>> +	}
>> +}
>> +#else
>> +static unsigned long fetch_argument(struct pt_regs *regs, void *data)
>> +{
>> +	return fetch_stack(regs, data);
>> +}
>> +#endif
> 
> As mentioned in another email, if we can generalize something similar to
> syscall_get_arguments, this can be made to work for many !x86 archs.
> AFAICS the calling conventions mandated by the ABI are followed at
> syscall time, isn't it?

No, function calling conventions depend on gcc(i386)/ABI specification
(x86-64). And on i386, this just works on most of functions which are
compiled with -mregparm=3, and without asmlinkage(for asmlinkage functions,
all arguments are passed over stack).
So, it just provides a "user-friendly" interface :) , not a strict defined
interface.

Thanks,

> 
> Ananth

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

