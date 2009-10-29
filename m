Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbZJ2WDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbZJ2WDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZJ2WDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:03:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150AbZJ2WDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:03:31 -0400
Message-ID: <4AEA10EC.8000103@redhat.com>
Date: Thu, 29 Oct 2009 18:02:20 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/3][RFC] tracing/kprobes: prevent jprobes from crashing
 function graph tracer
References: <20091029205151.852744305@goodmis.org>
In-Reply-To: <20091029205151.852744305@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Lately I've been testing with an allyesconfig. When I ran the function graph
> tracer, it immediately crashed the kernel. Thanks to the new frame pointer
> test in function graph, it reported directly what the issue was and then
> panicked the kernel to prevent any unexpected damage from happening.
> 
> It pointed the error to be with jtcp_rcv_established. Which is a jprobe
> function added to tcp_rcv_established at bootup when CONFIG_NET_TCPPROBE
> is enabled.
> 
> Jprobes and the function graph tracer use the same mechanism to trace
> the exit of a function. Unfortunately, only one can be done at a time.
> The function graph tracer replaces the return address with its own handler,
> but so does jprobes. The two are not compatible.

AFAIK, Jprobe doesn't trace the exit of a function. I assume that
jprobe's user handler causes the problem, since the handler never
returns normal way.
Instead of that, it just calls jprobe_return() which causes
int3 to be trapped by kprobe's break handler. And the break handler
fixup regs->ip to back to traced function.

Actually, this will cause a problem with function graph tracer.
The f-g-tracer push the return address into the special stack and replaces
it with fixup function (This is similar (not same) mechanism of kretprobe.)
And then the traced function returns, it returns to the fixup function and
it pops the return address up and back to the real caller.

So, if the f-g-tracer traces jprobe user handler, the pop operation
will be skipped because the the handler never returns.

> The solution I am proposing with this patch set is to add a call in
> ftrace that lets other code in the kernel permanently disable functions from
> being traced by the function and function graph tracer. As a probe function
> is registered with jprobes, it calls this new function and that entry
> will be removed from being traced.
>
> I tested this with this patch series and it does solve the problem.
> 
> Some issues though:
> 
> 1) this only works when DYNAMIC_FTRACE is enabled. We can prevent
> function graph tracing with jprobes when DYNAMIC_FTRACE is not
> enabled through Kconfig dependencies. Or have the registering of
> a jprobe permanently disable function graph tracing.

IMHO, those *probe handler should be tagged as __kprobes and notrace.

> 2) This also prevents the function tracer from being able to trace a
> function probe, even though the function tracer is not at issue
> with this bug.

I think we can skip those user handlers, because those are irregular
functions and user can control (enable/disable) it.

BTW, in this specific case, I assume that it can use tracepoint
instead of jprobe and move tcp_probe to a part of ftrace :-), isn't it?
(Or, if it is just for a debugging, Systemtap can help it.)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

