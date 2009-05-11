Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbZEKOkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbZEKOkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZEKOkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:40:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60634 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbZEKOkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:40:19 -0400
Message-ID: <4A0838E6.2000309@redhat.com>
Date: Mon, 11 May 2009 10:40:38 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, lkml <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Tom Zanussi <zanussi@comcast.net>
Subject: Re: [PATCH -tip v5 0/7] tracing: kprobe-based event tracer and x86
 instruction decoder
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509044302.GH8007@elte.hu>
In-Reply-To: <20090509044302.GH8007@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Hi,
>>
>> Here are the patches of kprobe-based event tracer for x86, version 
>> 5, which allows you to probe various kernel events through ftrace 
>> interface.
>>
>> This version supports only x86(-32/-64) (but porting it on other 
>> arch just needs kprobes/kretprobes and register and stack access 
>> APIs).
>>
>> This patchset also includes x86(-64) instruction decoder which 
>> supports non-SSE/FP opcodes and includes x86 opcode map. I think 
>> it will be possible to share this opcode map with KVM's decoder.
>>
>> This series can be applied on the latest linux-2.6-tip tree.
>>
>> This patchset includes following changes:
>> - Add x86 instruction decoder [1/7]
>> - Check insertion point safety in kprobe [2/7]
>> - Cleanup fix_riprel() with insn decoder [3/7]
>> - Add kprobe-tracer plugin [4/7]
>> - Fix kernel_trap_sp() on x86 according to systemtap runtime. [5/7]
>> - Add arch-dep register and stack fetching functions [6/7]
>> - Support fetching various status (register/stack/memory/etc.) [7/7]
>>
>> Future items:
>> - .init function tracing support.
>> - Support primitive types(long, ulong, int, uint, etc) for args.
> 
> Ok, this looks pretty complete already.
> 
> Two high-level comments:
> 
>  - There's no self-test - would it be possible to add one? See 
>    trace_selftest* in kernel/trace/

I'm not so sure. Currently, it seems that those self-tests are
only for tracers which define new event-entry on ring-buffer.
Since this tracer just use ftrace_bprintk, it might need
another kind of selftest. e.g. comparing outputs with
expected patterns.
In that case, would it be better to make a user-space self test
including filters and tracepoints?

>  - No generic integration.

Right, this just rides on the ftrace's printk :-)

> 
> It would be nice if these ops:
> 
>> E.g.
>>   echo p do_sys_open a0 a1 a2 a3 > /debug/tracing/kprobe_events
>>
>>  This sets a kprobe on the top of do_sys_open() function with recording
>> 1st to 4th arguments.
>>
>>   echo r do_sys_open rv rp >> /debug/tracing/kprobe_events
> 
> were just generally available in just about any other tracer - a bit 
> like the event tracer.
> 
> It would also be nice to use the 'function attributes' facilities of 
> the function tracer, combined with a new special syntax of the 
> function-filter regex parser, to enable the recovery of return 
> values (or the call arguments), for selected set of functions.
>
> For example, today we can already do things like:
> 
>   echo 'sys_read:traceon:4' > /debug/tracing/set_ftrace_filter
> 
> for 'trace triggers': the above will trigger tracing to be enabled 
> on the entry of sys_read(), 4 times.
> 
> Likewise, something like:
> 
>   echo 'sys_read:args' > /debug/tracing/set_ftrace_filter
>   echo 'sys_read:return' > /debug/tracing/set_ftrace_filter
> 
> Could activate kprobes based argument and return-value tracing.


Ah, that's a good idea. And also, I have another idea for using
filters with kprobes, which is adding new kprobe-entry as a new
trace-event when user defines a new probe via kprobe_events.
Thus, user can use it as a dynamic-defined tracepoint.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

