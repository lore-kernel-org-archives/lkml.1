Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbZDPHnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbZDPHnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZDPHm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:42:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:19887 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbZDPHm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:42:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TkleMyMTU4ZDp8rt5PD0/IEdi/o67ZJGFk8Jpka71fDZrt1avRBj34fk+Tzor/c0mG
         hcpwbm5HbZCb4TEsGvQtJL+EfFAn8wONKQKzDJlrAerkTnzN3nKvWB3/i0rRB4HR7B/U
         vG7srElGS5eOSxzfwaM5/hXzm6yyMv/GQq/zM=
Date: Thu, 16 Apr 2009 09:42:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 1/2] tracing/events: provide string with undefined
	size support
Message-ID: <20090416074250.GB6021@nowhere>
References: <1239838050-8567-1-git-send-email-fweisbec@gmail.com> <49E68635.8050404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E68635.8050404@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 09:13:25AM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > Impact: less memory usage for tracing
> > 
> > This patch provides the support for dynamic size strings on
> > event tracing.
> > 
> 
> blktrace TRACE_EVENTs need this too. :)


:-)


 
> > The key concept is to use a structure with an ending char array field of
> > undefined size and use such ability to allocate the minimal size on the ring
> > buffer to make the entry fit inside as opposite to a fixed length strings with
> > upper bound.
> > 
> > This patch provides two new macros:
> > 
> > -__ending_string(name)
> > 
> > This one declares the string to the structure inside TP_STRUCT__entry.
> > Only the name is needed.
> > Two constraints: only one __ending_string() per TRACE_EVENT can be added and
> > it must be the last field to be declared. Hence the __ending prefix.
> > 
> > - open_string_assign(call, dst, src)
> > 
> > This one does the copy inside TP__fast_assign() of the source
> > string to the destination. The name of the tracepoint (call) must be provided
> > for now. Hopefully I will find a solution to avoid it later.
> > 
> > Two constraint: can be used only once and always on the beginning because
> > it needs to manage the ring buffer reservation by itself. Hence the open prefix.
> > 
> > How does it works?
> > 
> 
> I'll let you know if I meet any problem when using this in blktrace
> TRACE_EVENTs.



Thanks Li!
Just wait a bit while I integrate Steven's idea, a v2 should come soon :)


 
> > A new has_ending_string field has been added to struct ftrace_event_call and is
> > false by default.
> > Once a TRACE_EVENT uses an __ending_string field, it is set to 1.
> > 
> > Until now, the ring buffer reservation was done in ftrace_raw_event_##call().
> > It is still the case if we don't have an __ending_string() field. If we have one,
> > open_string_assign() will manage it itself to allocate the appropriate size,
> > depending of the size of the string to be copied for each trace.
> > 
> > The choice between the usual static allocation and the new dynamic one depends
> > on the "has_ending_string" value.
> > 
> > It also support filtering because these strings behave essentially
> > like usual fixed length string.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  include/linux/ftrace_event.h |    1 +
> >  include/trace/ftrace.h       |   62 ++++++++++++++++++++++++++++++++++++-----
> >  2 files changed, 55 insertions(+), 8 deletions(-)
> 
> ...
> 
> > +/*
> > + * If we have and ending undefined string size, then the size of
> > + * the entry is dynamic. In such case we override the ring buffer
> > + * reservation to manage it ourselves with our dynamic string size.
> > + */
> > +#undef open_string_assign
> > +#define open_string_assign(call, dst, src)				       \
> > +	event = trace_current_buffer_lock_reserve(			       \
> > +			event_##call.id,				       \
> > +			sizeof(struct ftrace_raw_##call) + strlen(src) + 1,    \
> > +			irq_flags, pc);					       \
> > +	if (!event)							       \
> > +		return;							       \
> > +	entry	= ring_buffer_event_data(event);			       \
> 
> small nits, below is better since we have only one assignment:
> 
> 	entry = ring_buffer_event_data(event);



Hm, I don't understand what you are suggesting.

Frederic.



> > +	strcpy(entry->dst, src);
> > +
> >  #undef TRACE_EVENT
> >  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> >  _TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
> > @@ -418,20 +461,23 @@ static struct ftrace_event_call event_##call;				\
> >  static void ftrace_raw_event_##call(proto)				\
> >  {									\
> >  	struct ftrace_event_call *call = &event_##call;			\
> > -	struct ring_buffer_event *event;				\
> > -	struct ftrace_raw_##call *entry;				\
> > +	struct ring_buffer_event *event = NULL;				\
> > +	struct ftrace_raw_##call *entry = NULL;				\
> >  	unsigned long irq_flags;					\
> >  	int pc;								\
> >  									\
> >  	local_save_flags(irq_flags);					\
> >  	pc = preempt_count();						\
> >  									\
> > -	event = trace_current_buffer_lock_reserve(event_##call.id,	\
> > -				  sizeof(struct ftrace_raw_##call),	\
> > -				  irq_flags, pc);			\
> > -	if (!event)							\
> > -		return;							\
> > -	entry	= ring_buffer_event_data(event);			\
> > +	if (!call->has_ending_string) {					\
> > +		event = trace_current_buffer_lock_reserve(		\
> > +				event_##call.id,			\
> > +				sizeof(struct ftrace_raw_##call),	\
> > +				irq_flags, pc);				\
> > +		if (!event)						\
> > +			return;						\
> > +		entry	= ring_buffer_event_data(event);		\
> 
> ditoo
> 
> > +	}								\
> >  									\
> >  	assign;								\
> >  									\
> 

