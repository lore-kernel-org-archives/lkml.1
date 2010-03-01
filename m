Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab0CAT3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:29:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58395 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab0CAT3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:29:30 -0500
X-Authority-Analysis: v=1.0 c=1 a=MrHG-AeuP_8A:10 a=7U3hwN5JcxgA:10 a=r6hnVDmuhv8coAofd30A:9 a=rnPoROnrAMNfpSkrxoS_K42-XTgA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [GIT PULL] x86/cpu changes for v2.6.34
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100301131701.GA5562@nowhere>
References: <20100227150942.GA6394@elte.hu>
	 <alpine.LFD.2.00.1002281205320.27475@localhost.localdomain>
	 <alpine.LFD.2.00.1002281239550.3637@localhost.localdomain>
	 <20100301080058.GA8049@elte.hu>  <20100301131701.GA5562@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Mar 2010 14:29:26 -0500
Message-ID: <1267471766.10871.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-01 at 14:17 +0100, Frederic Weisbecker wrote:
> On Mon, Mar 01, 2010 at 09:00:58AM +0100, Ingo Molnar wrote:
> > Weird. It seems to be around multiples of .8: 0.8, 1.6, 2.4, with some extra 
> > overhead.
> > 
> > Almost as if some calibration routine or some other busy-loop misses the train 
> > occasionally.
> > 
> > The way i'd go about debugging this is to narrow down the approximate place 
> > the slowdown happens, then enable CONFIG_FUNCTION_TRACER (and disable 
> > CONFIG_DYNAMIC_FTRACE=y, to not have to deal with the dynamic patching 
> > aspects), and do a single-shot tracing session of only that section, on only 
> > one CPU:
> > 
> > 	if (smp_processor_id() == 7)
> > 		ftrace_enabled = 1;
> > 
> > 	... bootup sequence ...
> > 
> > 	if (smp_processor_id() == 7)
> > 		ftrace_enabled = 0;
> > 
> > And recover the resulting trace from /debug/tracing/trace - it should have the reason
> > in it plain and simple.
> > 
> > ( Unfortunately i'm not 100% sure that setting ftrace_enabled to 1 is enough. 
> >   I asked for a simple ad-hoc enable/disable function tracing mechanism _ages_ 
> >   ago - Steve, Frederic, what happened to that? ftrace_start()/stop() does not 
> >   seem to allow that. )
> 

Setting ftrace_enabled = 0 should stop the function tracer, but may not
stop the function graph tracer.

> 
> 
> I don't remember such request. But that would be useful indeed.
> We could simply pair the setting of an early tracer with tracing
> disabled and then manually delimit the places to trace with
> tracing_on/tracing_off().

It's best to use tracing_off() and tracing_on() for such things.

> 
> Whatever.
> 
> For now what you can do is setting the function_graph tracer
> on bootup:
> 
> 	ftrace=function_graph
> 
> and call ftrace_graph_stop() in the place you want the trace

tracing_off() is the best API for this. Although you still have the
overhead of the tracer. But you can just
 echo nop > /debug/tracing/current_tracer
to remove the overhead after bootup.

-- Steve

> to finish (you could use ftrace_graph_filter= to delimit
> the function tracing window, but that won't work without
> dynamic tracing, neither with __init functions).
> 
> So, after the boot you can look at /debug/tracing/per_cpu/cpu7/trace
> and the end of the trace should contain what you want.
> 


