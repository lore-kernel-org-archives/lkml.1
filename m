Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZB0DIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZB0DIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 22:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZB0DIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 22:08:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53656 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZB0DId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 22:08:33 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] new irq tracer
Cc: kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com
In-Reply-To: <49A57D85.4090201@redhat.com>
References: <20090225165849.GA13463@Krystal> <49A57D85.4090201@redhat.com>
Message-Id: <20090227120225.1528.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 27 Feb 2009 12:08:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>  /**
> >>>>   * handle_IRQ_event - irq action chain handler
> >>>>   * @irq:	the interrupt number
> >>>> @@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
> >>>>  		local_irq_enable_in_hardirq();
> >>>>  
> >>>>  	do {
> >>>> +		trace_irq_entry(irq);
> >>>>  		ret = action->handler(irq, action->dev_id);
> >>>> +		trace_irq_exit(irq, ret);
> >>>>  		if (ret == IRQ_HANDLED)
> >>>>  			status |= action->flags;
> >>>>  		retval |= ret;
> >>> Nobdy want unnecessary redundant tracepoint.
> >>> Please discuss with mathieu, and merge his tracepoint.
> >> Hmm, from the viewpoint of trouble shooting, the place of LTTng's tracepoint
> >> is enough. However, from the same viewpoint, it should pass irq-number
> >> to irq-exit event too, because we may lost some previous events by buffer-overflow
> >> etc.
> >>
> >>          trace_irq_entry(irq, NULL);
> >>          ret = _handle_IRQ_event(irq, action);
> >>          trace_irq_exit(irq, ret);
> >>                         ^^^^
> >>
> > 
> > I seriously doubt we should consider a trace with missing events as
> > "reliable". If your only argument is that when the buffers are not large
> > enough we could lose events, then I think we should just hint people at
> > doing the right thing, which is to tweak the tracer parameters (e.g.
> > larger buffers) so they stop losing events.
> 
> Hi Mathieu,
> 
> I think it depends on what events we'd like to trace on what environment
> (not have so much memories).
> Someone(like me) may want "reliability" for those events, someone not.

I don't think this viewpoint is valueable.
buffer overflow problem depend on the number of AVERAGE output from tracer.
typically, one irq has only one irq handler. 

if this change makes buffer overflow, the tracer buffer management is too silly.
Just change it.



> > A trace with events lost is really a scenario close to a corrupted
> > trace because we don't know which event has been lost, nor where. I
> > don't think we should increase the event size to support that kind of
> > broken scenario.
> 
> Why LTTng doesn't filter those unused arguments inside their handlers?
> Is there no room for compromise on sharing tracepoints with other
> tracers? IMHO, tracepoints in the kernel should be a common
> infrastructure for many users.

Agreed. last mathieu's mail only talk about lttng issue.
I can imazine systemtap folks need explicit irq number argument.


