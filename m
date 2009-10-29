Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbZJ2WRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbZJ2WRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbZJ2WRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:17:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45808 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959AbZJ2WRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:17:31 -0400
Subject: Re: [PATCH 0/3][RFC] tracing/kprobes: prevent jprobes from
 crashing function graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
In-Reply-To: <4AEA10EC.8000103@redhat.com>
References: <20091029205151.852744305@goodmis.org>
	 <4AEA10EC.8000103@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 29 Oct 2009 18:17:33 -0400
Message-Id: <1256854653.26028.3255.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 18:02 -0400, Masami Hiramatsu wrote:
> > 
> > Jprobes and the function graph tracer use the same mechanism to trace
> > the exit of a function. Unfortunately, only one can be done at a time.
> > The function graph tracer replaces the return address with its own handler,
> > but so does jprobes. The two are not compatible.
> 
> AFAIK, Jprobe doesn't trace the exit of a function. I assume that
> jprobe's user handler causes the problem, since the handler never
> returns normal way.
> Instead of that, it just calls jprobe_return() which causes
> int3 to be trapped by kprobe's break handler. And the break handler
> fixup regs->ip to back to traced function.

Ah, yes, my documenting this is wrong. It's the skipped jprobe that
messed it up.

> 
> Actually, this will cause a problem with function graph tracer.
> The f-g-tracer push the return address into the special stack and replaces
> it with fixup function (This is similar (not same) mechanism of kretprobe.)
> And then the traced function returns, it returns to the fixup function and
> it pops the return address up and back to the real caller.
> 
> So, if the f-g-tracer traces jprobe user handler, the pop operation
> will be skipped because the the handler never returns.

Exactly!

> 
> > The solution I am proposing with this patch set is to add a call in
> > ftrace that lets other code in the kernel permanently disable functions from
> > being traced by the function and function graph tracer. As a probe function
> > is registered with jprobes, it calls this new function and that entry
> > will be removed from being traced.
> >
> > I tested this with this patch series and it does solve the problem.
> > 
> > Some issues though:
> > 
> > 1) this only works when DYNAMIC_FTRACE is enabled. We can prevent
> > function graph tracing with jprobes when DYNAMIC_FTRACE is not
> > enabled through Kconfig dependencies. Or have the registering of
> > a jprobe permanently disable function graph tracing.
> 
> IMHO, those *probe handler should be tagged as __kprobes and notrace.

Yeah, I agree. But how do you guarantee that it does. If one forgets,
than we still have the issue. We can perhaps test to make sure the
function is in the kprobes section. But that does not mean they will not
be notraced. The __kprobes and notrace are no longer in the same set.

> 
> > 2) This also prevents the function tracer from being able to trace a
> > function probe, even though the function tracer is not at issue
> > with this bug.
> 
> I think we can skip those user handlers, because those are irregular
> functions and user can control (enable/disable) it.

True, but it may be nice to still trace them.

> 
> BTW, in this specific case, I assume that it can use tracepoint
> instead of jprobe and move tcp_probe to a part of ftrace :-), isn't it?
> (Or, if it is just for a debugging, Systemtap can help it.)

That's a question for the networking guys.

-- Steve


