Return-Path: <linux-kernel-owner+w=401wt.eu-S1763568AbZBYXNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763568AbZBYXNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbZBYXNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:13:31 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:39282 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763501AbZBYXN3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:13:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8EAItbpUlMQWWY/2dsb2JhbACBb9Z4glSBPQY
Date: Wed, 25 Feb 2009 18:13:25 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       Dominique Toupin <dominique.toupin@ericsson.com>
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090225231325.GB21928@Krystal>
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com> <20090225165747.GC3123@redhat.com> <20090225173412.GA14269@Krystal> <alpine.DEB.2.00.0902251250110.12697@gandalf.stny.rr.com> <20090225221210.GA20133@Krystal> <20090225222001.GC5838@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090225222001.GC5838@nowhere>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:08:26 up 4 days, 14:42,  2 users,  load average: 0.30, 0.32,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Wed, Feb 25, 2009 at 05:12:10PM -0500, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > 
> > > 
> > > On Wed, 25 Feb 2009, Mathieu Desnoyers wrote:
> > > 
> > > > * Jason Baron (jbaron@redhat.com) wrote:
> > > > > On Wed, Feb 25, 2009 at 11:48:28AM -0500, Masami Hiramatsu wrote:
> > > > > > KOSAKI Motohiro wrote:
> > > > > > >>  /**
> > > > > > >>   * handle_IRQ_event - irq action chain handler
> > > > > > >>   * @irq:	the interrupt number
> > > > > > >> @@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
> > > > > > >>  		local_irq_enable_in_hardirq();
> > > > > > >>  
> > > > > > >>  	do {
> > > > > > >> +		trace_irq_entry(irq);
> > > > > > >>  		ret = action->handler(irq, action->dev_id);
> > > > > > >> +		trace_irq_exit(irq, ret);
> > > > > > >>  		if (ret == IRQ_HANDLED)
> > > > > > >>  			status |= action->flags;
> > > > > > >>  		retval |= ret;
> > > > > > > 
> > > > > > > Nobdy want unnecessary redundant tracepoint.
> > > > > > > Please discuss with mathieu, and merge his tracepoint.
> > > > > > 
> > > > > > Hmm, from the viewpoint of trouble shooting, the place of LTTng's tracepoint
> > > > > > is enough. However, from the same viewpoint, it should pass irq-number
> > > > > > to irq-exit event too, because we may lost some previous events by buffer-overflow
> > > > > > etc.
> > > > > > 
> > > > > >          trace_irq_entry(irq, NULL);
> > > > > >          ret = _handle_IRQ_event(irq, action);
> > > > > >          trace_irq_exit(irq, ret);
> > > > > >                         ^^^^
> > > > > > 
> > > > > 
> > > > > the lttng tracepoints wrap the calls to _handle_IRQ_event in 3
> > > > > different places. So the above suggested irq tracepoint provides the
> > > > > same information with 4 less tracepoints in the code. So I believe its
> > > > > simpler - plus we can understand which action handlers are handling the
> > > > > interrupt.
> > > > > 
> > > > 
> > > > The main thing I dislike about only tracing action->handler() calls is
> > > > that you are not tracing an IRQ per se, but rather the invocation of a
> > > > given handler within the interrupt. For instance, it would be difficult
> > > > to calculate the maximum interrupt latency for a given interrupt line,
> > > > because you don't have the "real" irq entry/exit events, just the
> > > > individual handler() calls.
> > > 
> > > Then use the function_graph tracer.
> > > 
> > 
> > Sadly, the function tracer cannot be enabled on production systems.
> > Therefore it's not a usable solution in the context where I need this.
> > 
> > Mathieu
> 
> 
> Why?
> If this is about the interrupt latency caused by stop_machine, I still don't understand.
> This latency happens before the tracing (function filter which use patching), not during
> tracing.
> 

Given this scenario :

A telecommunication system runs, but the client notices something wrong.
They call their service provider. The provider enables tracing
_remotely_ on the _production system_ while it's _active in the field_.

Bam, those few milliseconds interrupt latencies become unacceptable.

Hopefully this scenario makes the use-case clearer. The problem is not
that interrupt latencies would occur while tracing is on, but rather
that it would happen on a running production system when switching
tracing on. This is what is totally unacceptable for this use-case.

For more details about such requirements, I'm CCing Dominique Toupin
from Ericsson who I'm sure would be happy to give more details about
this if needed.

Mathieu




>  
> > >  # echo smp_apic_timer_interrupt > /debug/tracing/set_ftrace_filter 
> > >  # echo __irqentry_text_start >> /debug/tracing/set_ftrace_filter
> > >  # echo function_graph > /debug/tracing/current_tracer 
> > >  # cat /debug/tracing/trace
> > > 
> > > # tracer: function_graph
> > > #
> > > # CPU  DURATION                  FUNCTION CALLS
> > > # |     |   |                     |   |   |   |
> > >  ------------------------------------------
> > >  1)  kblockd-4012  =>    <idle>-0   
> > >  ------------------------------------------
> > > 
> > >  1)   ==========> |
> > >  1) + 35.783 us   |  smp_apic_timer_interrupt();
> > >  ------------------------------------------
> > >  2)  kstop/2-4013  =>    <idle>-0   
> > >  ------------------------------------------
> > > 
> > >  2)   ==========> |
> > >  2) + 13.819 us   |  smp_apic_timer_interrupt();
> > >  ------------------------------------------
> > >  3)  kstop/3-4014  =>    <idle>-0   
> > >  ------------------------------------------
> > > 
> > >  3)   ==========> |
> > >  3) + 24.919 us   |  __irqentry_text_start();
> > >  ------------------------------------------
> > >  0)  kstop/0-4011  =>    <idle>-0   
> > >  ------------------------------------------
> > > 
> > >  0)   ==========> |
> > >  0) + 24.444 us   |  smp_apic_timer_interrupt();
> > >  ------------------------------------------
> > >  1)    <idle>-0    =>   bash-3899   
> > >  ------------------------------------------
> > > 
> > >  1)   ==========> |
> > >  1) + 13.642 us   |  smp_apic_timer_interrupt();
> > >  2)   ==========> |
> > >  2) + 15.014 us   |  smp_apic_timer_interrupt();
> > >  3)   ==========> |
> > >  3) + 31.004 us   |  smp_apic_timer_interrupt();
> > >  ------------------------------------------
> > >  0)    <idle>-0    =>   sshd-3892   
> > >  ------------------------------------------
> > > 
> > >  0)   ==========> |
> > >  0) + 15.655 us   |  __irqentry_text_start();
> > >  0)   ==========> |
> > >  0) + 37.722 us   |  __irqentry_text_start();
> > >  ------------------------------------------
> > >  0)   sshd-3892    =>    <idle>-0   
> > >  ------------------------------------------
> > > 
> > >  0)   ==========> |
> > >  0) + 26.139 us   |  __irqentry_text_start();
> > >  3)   ==========> |
> > >  3) + 27.240 us   |  __irqentry_text_start();
> > >  3)   ==========> |
> > >  3) + 21.987 us   |  __irqentry_text_start();
> > > 
> > > 
> > > And there you have your latencies ;-)
> > > 
> > > With Jasons added trace points, we could add the to the event tracer
> > > and those would show up as comments here.
> > > 
> > > -- Steve
> > > 
> > > 
> > > 
> > > > 
> > > > But I agree that knowing which handler is called is important.
> > > > 
> > > > How about this compromise :
> > > > 
> > > > trace_irq_entry(irq, action)
> > > >   _handle_IRQ_event()
> > > >     for each action  {
> > > >       trace_irq_handler(action, ret);
> > > >       ret = action->handler(irq, action->dev_id);
> > > >       ...
> > > >     }
> > > > trace_irq_exit(action_ret);
> > > > 
> > > > Would that give you the information you need ?
> > > > 
> > > > Here trace_irq_handler would be passed the _current_ action invoked and
> > > > the _previous_ action return value. Note that we should initialize
> > > > irqreturn_t ret to some initial value if we do this. That should keep
> > > > the tracing overhead minimal.
> > > > 
> > > 
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
