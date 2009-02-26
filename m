Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZBZQVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZBZQVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZBZQUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:20:55 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:15166 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbZBZQUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:20:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RckX7g7oc9JiTHKDvUNYpXEnWq0KE/eIicM4SdzYrdRAaJtzDqHzXFXLUbya0QLlxk
         x2Qnr1bRjItJz1TzGQWxz8LNtuUf2Sga5VnyhpSdlLF2j1TSQ/SOiQIFTH0svxqGHrGI
         mnQ4A9Ouzxkz/cF21aySENj3hlMitUN9wBQkE=
Date: Thu, 26 Feb 2009 17:20:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090226162046.GA5889@nowhere>
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com> <20090225165747.GC3123@redhat.com> <20090225173412.GA14269@Krystal> <20090226151105.GA3122@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226151105.GA3122@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 10:11:05AM -0500, Jason Baron wrote:
> On Wed, Feb 25, 2009 at 12:34:12PM -0500, Mathieu Desnoyers wrote:
> > * Jason Baron (jbaron@redhat.com) wrote:
> > > On Wed, Feb 25, 2009 at 11:48:28AM -0500, Masami Hiramatsu wrote:
> > > > KOSAKI Motohiro wrote:
> > > > >>  /**
> > > > >>   * handle_IRQ_event - irq action chain handler
> > > > >>   * @irq:	the interrupt number
> > > > >> @@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
> > > > >>  		local_irq_enable_in_hardirq();
> > > > >>  
> > > > >>  	do {
> > > > >> +		trace_irq_entry(irq);
> > > > >>  		ret = action->handler(irq, action->dev_id);
> > > > >> +		trace_irq_exit(irq, ret);
> > > > >>  		if (ret == IRQ_HANDLED)
> > > > >>  			status |= action->flags;
> > > > >>  		retval |= ret;
> > > > > 
> > > > > Nobdy want unnecessary redundant tracepoint.
> > > > > Please discuss with mathieu, and merge his tracepoint.
> > > > 
> > > > Hmm, from the viewpoint of trouble shooting, the place of LTTng's tracepoint
> > > > is enough. However, from the same viewpoint, it should pass irq-number
> > > > to irq-exit event too, because we may lost some previous events by buffer-overflow
> > > > etc.
> > > > 
> > > >          trace_irq_entry(irq, NULL);
> > > >          ret = _handle_IRQ_event(irq, action);
> > > >          trace_irq_exit(irq, ret);
> > > >                         ^^^^
> > > > 
> > > 
> > > the lttng tracepoints wrap the calls to _handle_IRQ_event in 3
> > > different places. So the above suggested irq tracepoint provides the
> > > same information with 4 less tracepoints in the code. So I believe its
> > > simpler - plus we can understand which action handlers are handling the
> > > interrupt.
> > > 
> > 
> > The main thing I dislike about only tracing action->handler() calls is
> > that you are not tracing an IRQ per se, but rather the invocation of a
> > given handler within the interrupt. For instance, it would be difficult
> > to calculate the maximum interrupt latency for a given interrupt line,
> > because you don't have the "real" irq entry/exit events, just the
> > individual handler() calls.
> > 
> > But I agree that knowing which handler is called is important.
> > 
> > How about this compromise :
> > 
> > trace_irq_entry(irq, action)
> >   _handle_IRQ_event()
> >     for each action  {
> >       trace_irq_handler(action, ret);
> >       ret = action->handler(irq, action->dev_id);
> >       ...
> >     }
> > trace_irq_exit(action_ret);
> > 
> > Would that give you the information you need ?
> > 
> > Here trace_irq_handler would be passed the _current_ action invoked and
> > the _previous_ action return value. Note that we should initialize
> > irqreturn_t ret to some initial value if we do this. That should keep
> > the tracing overhead minimal.
> > 
> 
> maybe...although that would require re-arranging the 'while' loop in
> 'handle_IRQ_event' from a do..while loop to a 'while' loop, which will
> require an extra branch check, and then we still have to record the last 'ret'
> value. I'm not that keen on re-arranging this for trace data...
> 
> Using Steve's new 'DEFINE_TRACE_FMT', I can get function graph trace
> as follows using the original two tracepoints (patch below):
> 
>  3)               |                      handle_IRQ_event() {
>  3)               |                        /* (irq_handler_entry) irq=28 handler=eth0 */
>  3)               |                        e1000_intr_msi() {
>  3)   2.460 us    |                          __napi_schedule();
>  3)   9.416 us    |                        }
>  3)               |                        /* (irq_handler_exit) irq=28 handler=eth0 return=handled */
>  3) + 22.935 us   |                      }
> 
> thanks,
> 
> -Jason
> 


I'm impressed by this new TRACE_FMT system.
It means that I will just need to toggle a value on a /debug/trace/events/irq_stuff/enable
to have the useful informations as comments inside a trace, or in a whole dedicated traces.

I've played with it a part of the night to test the bprintk patch, this is awesome!

