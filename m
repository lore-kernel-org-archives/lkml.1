Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbZCUU5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbZCUU5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 16:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZCUU5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 16:57:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57516 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZCUU5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 16:57:06 -0400
Message-ID: <49C554B4.7020303@redhat.com>
Date: Sat, 21 Mar 2009 16:57:24 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH -tip 3/5 V2] tracing: kprobe-tracer plugin	supports
 arguments
References: <49C44400.6070804@redhat.com> <20090321025551.GG6044@nowhere>
In-Reply-To: <20090321025551.GG6044@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
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
> 
> 
> I wonder if it wouldn't be better to make this tracer depend on
> CONFIG_FRAME_POINTER. So that wherever we probe inside a function,
> the argument asked keeps being reliable. esp will move, ebp will not until
> we quit the frame.

Hm, AFAIK, CONFIG_FRAME_POINTER is for unwinding stacks, but I doubt
it is useful for getting function arguments, because first nth parameters
are passed by registers which will easily be broken and compilers may
change register assignment in the function body.

I guess that most of debugging users will disassemble kernel binary
when setting a probe (I recommend it, at least with this version.)
So they can find what they want by analyzing assemble code.

Anyway, I think it is possible to get a stack entry referred from
ebp(stack frame register) by implementing below item.
> - Support indirect memory fetch from registers etc.

This will allow us to access memory indirectly like as;
 p sys_open+10 r5[8]

This will mean "record *(ulong)(pt_regs->bp+8) at sys_open+10"
(syntax is not fixed yet.)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


