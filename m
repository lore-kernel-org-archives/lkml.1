Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbZCYSb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbZCYSb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZCYSaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:30:30 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:49789 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbZCYSa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:30:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYEAEMVyklMQW1W/2dsb2JhbACBUNIIg3UG
Date: Wed, 25 Mar 2009 14:30:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 2/9] LTTng instrumentation - irq
Message-ID: <20090325183024.GA6746@Krystal>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.080628193@polymtl.ca> <20090324173354.GC3129@redhat.com> <20090324175049.GC31117@elte.hu> <20090324175750.GE3129@redhat.com> <20090324191252.GA11665@elte.hu> <20090324201146.GA4350@Krystal> <20090324205120.GB24320@elte.hu> <20090325084724.GA28171@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090325084724.GA28171@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:25:26 up 25 days, 14:51,  1 user,  load average: 1.46, 0.77,
	0.78
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > If we want to do this logically, without thinking about tracer 
> > > performance impact, we could/should do :
> > > 
> > > trace_irq_entry(irqno, pt_regs)
> > >   for_each_handler() {
> > >     trace_irq_handler_entry(action)
> > >     action->handler()
> > >     trace_irq_handler_exit(ret)
> > >   }
> > > trace_irq_exit(retval)
> > 
> > Not really.
> 
> Put differently: we seem to agree on handler invocation entry/exit 
> events (and those are handled by Jason's patch already), and that's 
> good.
> 

Yes, we need to get this information into the trace stream somehow.

> I dont think we need two events for physical IRQ events though. One 
> is enough: entry event. What meaning does 'retval' have in your 
> pseudo-code above? None typically.
> 

Hrm, an event means more that the "payload" it has. Just saving "here is
a return from interrupt handler" without any return value is valuable
per se because it lets the trace analyzer know when the hardirq handler
ended.

e.g., if we instrument the x86 local apic irq handler only with an "irq
entry" event, we would not be able to detect if the following events are
nested on top of the IRQ handler or are executed in thread context.

Having those two hardirq entry/exit events is also especially useful to
figure out the maximum interrupt latency caused by long interrupt
handlers (or that could be many handlers hooked on the same interrupt
line).

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
