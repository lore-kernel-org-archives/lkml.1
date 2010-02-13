Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab0BMLLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 06:11:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60739 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab0BMLLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 06:11:14 -0500
X-Authority-Analysis: v=1.0 c=1 a=EPSL5sjMBdAA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=Vd06avjZsPwgv1jucm8A:9 a=gBS89OFOsOo6KZ7pKjDxRgtakqAA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/2][RFC] tracing: Add extract out softirq names used
 by irq trace events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <1266057549.557.59605.camel@twins>
References: <20100212190907.954438555@goodmis.org>
	 <20100212191037.283998401@goodmis.org>  <1266057549.557.59605.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 13 Feb 2010 06:11:09 -0500
Message-ID: <1266059470.24271.116.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-13 at 11:39 +0100, Peter Zijlstra wrote:
> On Fri, 2010-02-12 at 14:09 -0500, Steven Rostedt wrote:
> > plain text document attachment (irq-events.patch)
> > The irq trace events that map the softirq vectors to strings
> > shows up in the format files as names. To allow binary parsers to
> > be able to convert these names to their actual numbers, this patch
> > extracts those enums.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > ---
> >  include/trace/events/irq.h |   11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > Index: linux-trace.git/include/trace/events/irq.h
> > ===================================================================
> > --- linux-trace.git.orig/include/trace/events/irq.h	2010-02-12 13:29:44.000000000 -0500
> > +++ linux-trace.git/include/trace/events/irq.h	2010-02-12 13:33:20.000000000 -0500
> > @@ -7,6 +7,17 @@
> >  #include <linux/tracepoint.h>
> >  #include <linux/interrupt.h>
> >  
> > +EXTRACT_TRACE_SYMBOL(HI_SOFTIRQ);
> > +EXTRACT_TRACE_SYMBOL(TIMER_SOFTIRQ);
> > +EXTRACT_TRACE_SYMBOL(NET_TX_SOFTIRQ);
> > +EXTRACT_TRACE_SYMBOL(NET_RX_SOFTIRQ);
> > +EXTRACT_TRACE_SYMBOL(BLOCK_SOFTIRQ);
> > +EXTRACT_TRACE_SYMBOL(BLOCK_IOPOLL_SOFTIRQ);
> > +EXTRACT_TRACE_SYMBOL(TASKLET_SOFTIRQ);
> > +EXTRACT_TRACE_SYMBOL(SCHED_SOFTIRQ);
> > +EXTRACT_TRACE_SYMBOL(HRTIMER_SOFTIRQ);
> > +EXTRACT_TRACE_SYMBOL(RCU_SOFTIRQ);
> > +
> 
> Still sucks you have to explicitly iterate them all, and far away from
> the actual definition site too, its just asking to get out of whack with
> reality.

We don't care about adding them near the definition site. We care about
what is used. In this same file we have:

#define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
#define show_softirq_name(val)                          \
        __print_symbolic(val,                           \
                         softirq_name(HI),              \
                         softirq_name(TIMER),           \
                         softirq_name(NET_TX),          \
                         softirq_name(NET_RX),          \
                         softirq_name(BLOCK),           \
                         softirq_name(BLOCK_IOPOLL),    \
                         softirq_name(TASKLET),         \
                         softirq_name(SCHED),           \
                         softirq_name(HRTIMER),         \
                         softirq_name(RCU))

Which uses the variables. If another softirq name is added, the
TRACE_EVENT already misses it. That's not the point of the EXTRACT
macro. The point is, if a TRACE_EVENT uses a name that is not a macro,
this gives a way for it to display that value.

-- Steve



