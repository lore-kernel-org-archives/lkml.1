Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbYJGKjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbYJGKjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYJGKjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:39:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51511 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbYJGKjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:39:44 -0400
Date: Tue, 7 Oct 2008 06:39:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power
 optimization
In-Reply-To: <87y711moz2.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.1.10.0810070635580.19491@gandalf.stny.rr.com>
References: <20081006102640.481acd23@infradead.org> <87y711moz2.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 6 Oct 2008, Andi Kleen wrote:
> 
> > +void trace_power_end(struct power_trace *it)
> > +{
> > +	struct ring_buffer_event *event;
> > +	struct trace_power *entry;
> > +	struct trace_array_cpu *data;
> > +	unsigned long irq_flags;
> > +	struct trace_array *tr = power_trace;
> > +
> > +	if (!trace_power_enabled)
> > +		return;
> > +
> > +	preempt_disable();
> > +	it->end = ktime_get();
> > +	data = tr->data[smp_processor_id()];
> > +
> > +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> > +					 &irq_flags);
> > +	if (!event)
> > +		goto out;
> > +	entry	= ring_buffer_event_data(event);
> > +	tracing_generic_entry_update(&entry->ent, 0, 0);
> > +	entry->ent.type = TRACE_POWER;
> > +	entry->state_data = *it;
> > +	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> 
> When ring_buffer_lock_reserve really disables interrupts (I haven't
> checked since it's not in 2.6.27rc8) you could avoid the
> preempt_disable by moving the data = tr->data ... one below.

The ring_buffer_lock_reserve use to disable interrupts (I'll be removing
the flags argument soon). Now it just does a minimum of preempt_disable.
So your suggestion about moving the smp_processor_id() calls below that
is still valid. The reserve will always disable preemption.

-- Steve

> 
> Similar comments to trace_power_mark. Also it would be probably good 
> to use a common function instead of duplicating so much code.
> 
> 
