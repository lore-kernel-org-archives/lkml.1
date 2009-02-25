Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZBYRe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZBYRe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 12:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZBYReR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 12:34:17 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:40950 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752898AbZBYReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 12:34:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8EAK8KpUlMQWWY/2dsb2JhbACBbtdshBEG
Date: Wed, 25 Feb 2009 12:34:12 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090225173412.GA14269@Krystal>
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com> <20090225165747.GC3123@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090225165747.GC3123@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:22:19 up 4 days,  8:56,  4 users,  load average: 0.03, 0.24,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Wed, Feb 25, 2009 at 11:48:28AM -0500, Masami Hiramatsu wrote:
> > KOSAKI Motohiro wrote:
> > >>  /**
> > >>   * handle_IRQ_event - irq action chain handler
> > >>   * @irq:	the interrupt number
> > >> @@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
> > >>  		local_irq_enable_in_hardirq();
> > >>  
> > >>  	do {
> > >> +		trace_irq_entry(irq);
> > >>  		ret = action->handler(irq, action->dev_id);
> > >> +		trace_irq_exit(irq, ret);
> > >>  		if (ret == IRQ_HANDLED)
> > >>  			status |= action->flags;
> > >>  		retval |= ret;
> > > 
> > > Nobdy want unnecessary redundant tracepoint.
> > > Please discuss with mathieu, and merge his tracepoint.
> > 
> > Hmm, from the viewpoint of trouble shooting, the place of LTTng's tracepoint
> > is enough. However, from the same viewpoint, it should pass irq-number
> > to irq-exit event too, because we may lost some previous events by buffer-overflow
> > etc.
> > 
> >          trace_irq_entry(irq, NULL);
> >          ret = _handle_IRQ_event(irq, action);
> >          trace_irq_exit(irq, ret);
> >                         ^^^^
> > 
> 
> the lttng tracepoints wrap the calls to _handle_IRQ_event in 3
> different places. So the above suggested irq tracepoint provides the
> same information with 4 less tracepoints in the code. So I believe its
> simpler - plus we can understand which action handlers are handling the
> interrupt.
> 

The main thing I dislike about only tracing action->handler() calls is
that you are not tracing an IRQ per se, but rather the invocation of a
given handler within the interrupt. For instance, it would be difficult
to calculate the maximum interrupt latency for a given interrupt line,
because you don't have the "real" irq entry/exit events, just the
individual handler() calls.

But I agree that knowing which handler is called is important.

How about this compromise :

trace_irq_entry(irq, action)
  _handle_IRQ_event()
    for each action  {
      trace_irq_handler(action, ret);
      ret = action->handler(irq, action->dev_id);
      ...
    }
trace_irq_exit(action_ret);

Would that give you the information you need ?

Here trace_irq_handler would be passed the _current_ action invoked and
the _previous_ action return value. Note that we should initialize
irqreturn_t ret to some initial value if we do this. That should keep
the tracing overhead minimal.

Mathieu

> thanks,
> 
> -Jason
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
