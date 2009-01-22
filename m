Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZAVMCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZAVMCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 07:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZAVMCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 07:02:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60569 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZAVMCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 07:02:14 -0500
Date: Thu, 22 Jan 2009 07:02:12 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] trace: do not disable wake up tracer on output of
 trace
In-Reply-To: <20090122084105.GD7438@elte.hu>
Message-ID: <alpine.DEB.1.10.0901220658050.22776@gandalf.stny.rr.com>
References: <20090121235306.224764198@goodmis.org> <20090121235805.771064570@goodmis.org> <20090122084105.GD7438@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 22 Jan 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Impact: fix to erased trace output
> > 
> > To try not to have the outputing of a trace interfere with the wakeup 
> > tracer, it would disable tracing while the output was printing. But if a 
> > trace had started when it was disabled, it can show a partial trace. To 
> > try to solve this, on closing of the tracer, it would clear the trace 
> > buffer.
> > 
> > The latency tracers (wakeup and irqsoff) have two buffers. One for 
> > recording and one for holding the max trace that is printed. The 
> > clearing of the trace above should only affect the recording buffer. But 
> > for some reason it would move the erased trace to the print buffer. 
> > Probably due to a race with the closing of the trace and the saving ofhe 
> > max race.
> 
> hm, that race needs to be fixed then.
> 
> > The above is all pretty useless, and if the user does not want the 
> > printing of the trace to be traced itself, then the user can manual 
> > disable tracing. This patch removes all the code that tries to keep the 
> > output of the tracer from modifying the trace.
> 
> printing of the trace should not be traced. I cannot imagine any usage 
> mode where that would be interesting - and i can imagine a ton of cases 
> where users would be confused/distracted by the tracer in essence zapping 
> their measurement by replacing it with some uninteresting 'the tracer 
> itself has wakeup delays' data.
> 
> auto-disabling latency tracing while the trace is being output is 
> essential. Measurement should never impact the workload that is being 
> measured.
> 
> We should fix that race instead.

Well actually, I don't see the output causing any issues. That's another 
point. Should we work on adding all this complex code for something that 
might not every cause an issues?  I added it because it did cause an issue 
with the irqs off traces, although I'm not sure that is true any 
more either. I just added it to the wakeup tracer just to be consistent.

With the new trace_off switch that disables the ring buffer, and the 
stopping of the swap buffers with the switch off, I do not think that this 
code is even necessary anymore.

I think I'll rip out the code from irqsoff and see if it is still an issue 
there. If not, I think we can get rid of it.

-- Steve

