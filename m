Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbZDPHfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbZDPHfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZDPHfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:35:41 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:47695 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZDPHfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:35:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ihmTdyK33IX1+4+2W9lOjXYZVCsYkA5h15JNqALP6X4jBsDDQok/s6AvrjyvCowoaV
         QJ9J/TuO+xyFvG9mcrlky3bUAn5Q3SKdJtLdF2+HMoxA6A8pvgMIeElGA4jVmo4aLzoo
         nPinQiZ8xmLIJxWIY7JnQPU6MFLDy010wOZGg=
Date: Thu, 16 Apr 2009 09:35:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 1/2] tracing/events: provide string with undefined
	size support
Message-ID: <20090416073531.GA6021@nowhere>
References: <1239838050-8567-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0904152118040.4459@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904152118040.4459@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 09:33:15PM -0400, Steven Rostedt wrote:
> 
> On Thu, 16 Apr 2009, Frederic Weisbecker wrote:
> 
> > Impact: less memory usage for tracing
> > 
> > This patch provides the support for dynamic size strings on
> > event tracing.
> > 
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
> 
> And I thought I was the only one that could master CPP wackiness ;-)


:-)


> 
> BTW, I was confused on IRC, because I was thinking this was printf like,
> but no, we only need to be concerned about a string.
> 
> But I have another idea:
> 
> 
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  include/linux/ftrace_event.h |    1 +
> >  include/trace/ftrace.h       |   62 ++++++++++++++++++++++++++++++++++++-----
> >  2 files changed, 55 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> > index 75f3ac0..b49bfbf 100644
> > --- a/include/linux/ftrace_event.h
> > +++ b/include/linux/ftrace_event.h
> > @@ -100,6 +100,7 @@ struct ftrace_event_call {
> >  	int			n_preds;
> >  	struct filter_pred	**preds;
> >  	void			*mod;
> > +	bool			has_ending_string;
> >  
> >  #ifdef CONFIG_EVENT_PROFILE
> >  	atomic_t	profile_count;
> > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > index 60c5323..8ea750e 100644
> > --- a/include/trace/ftrace.h
> > +++ b/include/trace/ftrace.h
> > @@ -27,6 +27,9 @@
> >  #undef __field
> >  #define __field(type, item)		type	item;
> >  
> > +#undef __ending_string
> > +#define __ending_string(item)			char	item[];
> > +
> >  #undef TP_STRUCT__entry
> >  #define TP_STRUCT__entry(args...) args
> >  
> > @@ -146,12 +149,23 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
> >  	if (!ret)							\
> >  		return 0;
> >  
> > +#undef __ending_string
> > +#define __ending_string(item)						      \
> > +	ret = trace_seq_printf(s, "\tfield: char " #item "[];\t"	      \
> > +			       "offset:%u;\n",				      \
> > +			       (unsigned int)offsetof(typeof(field), item));   \
> > +	if (!ret)							      \
> > +		return 0;
> > +
> >  #undef __entry
> >  #define __entry REC
> >  
> >  #undef TP_printk
> >  #define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
> >  
> > +#undef open_string_assign
> > +#define open_string_assign(call, dst, src)	strcpy(__entry->dst, src)
> > +
> >  #undef TP_fast_assign
> >  #define TP_fast_assign(args...) args
> >  
> > @@ -189,6 +203,19 @@ ftrace_format_##call(struct trace_seq *s)				\
> >  	if (ret)							\
> >  		return ret;
> >  
> > +/*
> > + * We choose a size of MAX_FILTER_STR_VAL, then we behave like
> > + * a usual string with the maximum size to keep being filterable.
> > + */
> > +#undef __ending_string
> > +#define __ending_string(item)						\
> > +	ret = trace_define_field(event_call, "char []", #item,		\
> > +				 offsetof(typeof(field), item),		\
> > +				 MAX_FILTER_STR_VAL);			\
> > +	if (ret)							\
> > +		return ret;						\
> > +	event_call->has_ending_string = true;
> > +
> >  #undef TRACE_EVENT
> >  #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
> >  int									\
> > @@ -409,6 +436,22 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
> >  #undef __entry
> >  #define __entry entry
> >  
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
> > +	}								\
> >  									\
> >  	assign;								\
> >  									\
> 
> 
> We can get rid of the has_ending_string and open_string_assign and have 
> this:
> 
>  
>         TP_STRUCT__entry(
>                 __field(unsigned long, wait_usec)
>                 __field(unsigned long, wait_nsec_rem)
>                 __ending_string(name)
>         ),
>         TP_fast_assign(
>                 __entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
>                 __entry->wait_usec = (unsigned long) waittime;
>                 strcpy(__entry->name, lock->name);
>         ),
> 
> 
> Then we could do the following in the print the assign:
> 
> #undef __field
> #define __field(a,b)
> #undef __array
> #define __array(a,b,c)
> #undef __ending_sting
> #define __ending_string(name) __str_size__ += strlen(name) + 1;
> 
> #define TRACE_EVENT(call, proto, args, tstruct, assign, print)
> static void ftrace_raw_event_##call(proto)
> {
> 	int __str_size__ = 0;
> 
> 	tstruct
> 
> 	event = trace_current_buffer_lock_reserve(event_##call.id,
> 				sizeof(struct ftrace_raw_##call) +
> 				__str_size__,
> 				irq_flags, pc)
> 	if (!event)
> 		return;
> 
> 	entry = ring_buffer_event_data(event);
> 
> 	assign
> }
> 
> 
> Yes, I did not add other declarations nor the backslashes for the macro, 
> but you get what I'm doing, right?



Oh!
I'm surprised, this is much more proper this way and also so obvious too!

Thanks a lot, I will integrate this simplification in a v2.



> -- Steve
> 

