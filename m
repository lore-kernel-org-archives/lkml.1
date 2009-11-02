Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZKBPDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZKBPDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbZKBPDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:03:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbZKBPDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:03:03 -0500
Message-ID: <4AEEF47F.7090101@redhat.com>
Date: Mon, 02 Nov 2009 10:02:23 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/3][RFC] tracing/kprobes: prevent jprobes from	crashing
 function graph tracer
References: <20091029205151.852744305@goodmis.org> <4AEA10EC.8000103@redhat.com> <20091102003723.GF5263@nowhere>
In-Reply-To: <20091102003723.GF5263@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frederic Weisbecker wrote:
> On Thu, Oct 29, 2009 at 06:02:20PM -0400, Masami Hiramatsu wrote:
>> Steven Rostedt wrote:
>>> Lately I've been testing with an allyesconfig. When I ran the function graph
>>> tracer, it immediately crashed the kernel. Thanks to the new frame pointer
>>> test in function graph, it reported directly what the issue was and then
>>> panicked the kernel to prevent any unexpected damage from happening.
>>>
>>> It pointed the error to be with jtcp_rcv_established. Which is a jprobe
>>> function added to tcp_rcv_established at bootup when CONFIG_NET_TCPPROBE
>>> is enabled.
>>>
>>> Jprobes and the function graph tracer use the same mechanism to trace
>>> the exit of a function. Unfortunately, only one can be done at a time.
>>> The function graph tracer replaces the return address with its own handler,
>>> but so does jprobes. The two are not compatible.
>>
>> AFAIK, Jprobe doesn't trace the exit of a function. I assume that
>> jprobe's user handler causes the problem, since the handler never
>> returns normal way.
>> Instead of that, it just calls jprobe_return() which causes
>> int3 to be trapped by kprobe's break handler. And the break handler
>> fixup regs->ip to back to traced function.
>>
>> Actually, this will cause a problem with function graph tracer.
>> The f-g-tracer push the return address into the special stack and replaces
>> it with fixup function (This is similar (not same) mechanism of kretprobe.)
>> And then the traced function returns, it returns to the fixup function and
>> it pops the return address up and back to the real caller.
>>
>> So, if the f-g-tracer traces jprobe user handler, the pop operation
>> will be skipped because the the handler never returns.
>
>
> I'm not sure I've well understood how is performed the call to the jprobe
> handler.
> But if I understand well we have:
>
> 	func() {
> 		int3() {
> 			jprobe_handler() {
> 				(-)
> 				set ip after iret to user_handler()
> 			}
> 		}
> 		user_handler() {
> 			jprobe_return() {
> 				(+)
> 				int3() {
> 					set ip after iret to func+...()
> 				}
> 			       |
> 			       |
> 			       |
>                  <--------------
>                  (execute the rest of func())
> 	}
>
> If we replace (-) with pause_graph_tracing() and (+) with
> unpause_graph_tracing(), this should do the trick...I hope.

I'm not so sure about pause_graph_tracing(), however, it seems that
int3() and jprobe_handler() already pushed on the stack of the
func graph tracer at (-). If it's true, where are those entries
popped up?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

