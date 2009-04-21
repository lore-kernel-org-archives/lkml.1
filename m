Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbZDUWBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbZDUWBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 18:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbZDUWA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 18:00:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45808 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbZDUWAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:00:22 -0400
Date: Tue, 21 Apr 2009 18:00:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2 v3] tracing/events: provide string with undefined
 size support
In-Reply-To: <alpine.DEB.2.00.0904211749580.10097@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0904211759540.10097@gandalf.stny.rr.com>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <1240117295-6873-2-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0904211749580.10097@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 21 Apr 2009, Steven Rostedt wrote:

> 
> Hi Frederic,
> 
> Cool stuff!
> 
> 
> On Sun, 19 Apr 2009, Frederic Weisbecker wrote:
> 
> > This patch provides the support for dynamic size strings on
> > event tracing.
> > 
> > The key concept is to use a structure with an ending char array field of
> > undefined size and use such ability to allocate the minimal size on the
> > ring buffer to make one or more string entries fit inside, as opposite
> > to a fixed length strings with upper bound.
> > 
> > The strings themselves are represented using fields which have an offset
> > value from the beginning of the entry.
> > 
> > This patch provides three new macros:
> > 
> > __string(item, src)
> > 
> > This one declares a string to the structure inside TP_STRUCT__entry.
> > You need to provide the name of the string field and the source that will
> > be copied inside.
> > This will also add the dynamic size of the string needed for the ring
> > buffer entry allocation.
> > A stack allocated structure is used to temporarily store the offset
> > of each strings, avoiding double calls to strlen() on each event
> > insertion.
> > 
> > __get_str(field)
> > 
> > This one will give you a pointer to the string you have created. This
> > is an abstract helper to resolve the absolute address given the field
> > name which is a relative address from the beginning of the trace_structure.
> > 
> > __assign_str(dst, src)
> > 
> > Use this macro to automatically perform the string copy from src to
> > dst. src must be a variable to assign and dst is the name of a __string
> > field.
> > 
> > Example on how to use it:
> > 
> > TRACE_EVENT(my_event,
> > 	TP_PROTO(char *src1, char *src2),
> > 
> > 	TP_ARGS(src1, src2),
> > 	TP_STRUCT__entry(
> > 		__string(str1, src1)
> > 		__string(str2, src2)
> > 	),
> > 	TP_fast_assign(
> > 		__assign_str(str1, src1);
> > 		__assign_str(str2, src2);
> > 	),
> > 	TP_printk("%s %s", __get_str(src1), __get_str(src2))
> > )
> > 
> > Of course you can mix-up any __field or __array inside this
> > TRACE_EVENT. The position of the __string or __assign_str
> > doesn't matter.
> > 
> > Changes in v2:
> > 
> > Address the suggestion of Steven Rostedt: drop the opening_string() macro
> > and redefine __ending_string() to get the size of the string to be copied
> > instead of overwritting the whole ring buffer allocation.
> > 
> > Changes in v3:
> > 
> > Address other suggestions of Steven Rostedt and Peter Zijlstra with
> > some changes: drop the __ending_string and the need to have only one
> > string field.
> > Use offsets instead of absolute addresses.
> > 
> > [ Impact: better usage of memory for string tracing ]
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  include/trace/ftrace.h |   88 ++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 files changed, 85 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > index 39a3351..353b7db 100644
> > --- a/include/trace/ftrace.h
> > +++ b/include/trace/ftrace.h
> > @@ -27,6 +27,9 @@
> >  #undef __field
> >  #define __field(type, item)		type	item;
> >  
> > +#undef __string
> > +#define __string(item, src)		int	__str_loc_##item;
> > +
> >  #undef TP_STRUCT__entry
> >  #define TP_STRUCT__entry(args...) args
> >  
> > @@ -35,14 +38,53 @@
> >  	struct ftrace_raw_##name {				\
> >  		struct trace_entry	ent;			\
> >  		tstruct						\
> > +		char			__str_data[0];		\
> >  	};							\
> >  	static struct ftrace_event_call event_##name
> >  
> >  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
> >  
> > +
> >  /*
> >   * Stage 2 of the trace events.
> >   *
> > + * Include the following:
> > + *
> > + * struct ftrace_str_offsets_<call> {
> > + *	int				<str1>;
> > + *	int				<str2>;
> > + *	[...]
> > + * };
> > + *
> > + * The __string() macro will create each int <str>, this is to
> > + * keep the offset of each string from the beggining of the event
> > + * once we perform the strlen() of the src strings.
> > + *
> > + */
> > +
> > +#undef TRACE_FORMAT
> > +#define TRACE_FORMAT(call, proto, args, fmt)
> > +
> > +#undef __array
> > +#define __array(type, item, len)
> > +
> > +#undef __field
> > +#define __field(type, item);
> > +
> > +#undef __string
> > +#define __string(item, src)	int item;
> > +
> > +#undef TRACE_EVENT
> > +#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> > +	struct ftrace_str_offsets_##call {				\
> > +		tstruct;						\
> > +	};
> > +
> > +#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
> > +
> > +/*
> > + * Stage 3 of the trace events.
> > + *
> >   * Override the macros in <trace/trace_events.h> to include the following:
> >   *
> >   * enum print_line_t
> > @@ -80,6 +122,9 @@
> >  #undef TP_printk
> >  #define TP_printk(fmt, args...) fmt "\n", args
> >  
> > +#undef __get_str
> > +#define __get_str(field)	(char *)__entry + __entry->__str_loc_##field
> 
> Because __get_str() is used it the "code" part of the macro, we probably 
> should put parenthesis around it:
> 
> #define __get_str(field)	((char *)__entry + __entry->__str_loc__##field)
> 
> 
> > +
> >  #undef TRACE_EVENT
> >  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> >  enum print_line_t							\
> > @@ -146,6 +191,16 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
> >  	if (!ret)							\
> >  		return 0;
> >  
> > +#undef __string
> > +#define __string(item, src)						       \
> > +	ret = trace_seq_printf(s, "\tfield: __str_loc " #item ";\t"	       \
> > +			       "offset:%u;tsize:%u;\n",			       \
> > +			       (unsigned int)offsetof(typeof(field),	       \
> > +					__str_loc_##item),		       \
> > +			       (unsigned int)sizeof(field.__str_loc_##item));  \
> > +	if (!ret)							       \
> > +		return 0;
> > +
> >  #undef __entry
> >  #define __entry REC
> >  
> > @@ -189,6 +244,12 @@ ftrace_format_##call(struct trace_seq *s)				\
> >  	if (ret)							\
> >  		return ret;
> >  
> > +#undef __string
> > +#define __string(item, src)						       \
> > +	ret = trace_define_field(event_call, "__str_loc", #item,	       \
> > +				offsetof(typeof(field), __str_loc_##item),     \
> > +				sizeof(field.__str_loc_##item));
> > +
> >  #undef TRACE_EVENT
> >  #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
> >  int									\
> > @@ -212,7 +273,7 @@ ftrace_define_fields_##call(void)					\
> >  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
> >  
> >  /*
> > - * Stage 3 of the trace events.
> > + * Stage 4 of the trace events.
> >   *
> >   * Override the macros in <trace/trace_events.h> to include the following:
> >   *
> > @@ -409,6 +470,23 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
> >  #undef __entry
> >  #define __entry entry
> >  
> > +#undef __field
> > +#define __field(type, item)
> > +
> > +#undef __array
> > +#define __array(type, item, len)
> > +
> > +#undef __string
> > +#define __string(item, src)						       \
> > +	__str_offsets.item = __str_size +				       \
> > +			     offsetof(typeof(*entry), __str_data);	       \
> > +	__str_size += strlen(src) + 1;
> > +
> > +#undef __assign_str
> > +#define __assign_str(dst, src)						\
> > +	__entry->__str_loc_##dst = __str_offsets.dst;			\
> > +	strcpy(__get_str(dst), src);
> > +
> >  #undef TRACE_EVENT
> >  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> >  _TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
> > @@ -417,18 +495,22 @@ static struct ftrace_event_call event_##call;				\
> >  									\
> >  static void ftrace_raw_event_##call(proto)				\
> >  {									\
> > +	struct ftrace_str_offsets_##call __maybe_unused __str_offsets;  \
> >  	struct ftrace_event_call *call = &event_##call;			\
> >  	struct ring_buffer_event *event;				\
> >  	struct ftrace_raw_##call *entry;				\
> >  	unsigned long irq_flags;					\
> > +	int __str_size = 0;						\
> >  	int pc;								\
> >  									\
> >  	local_save_flags(irq_flags);					\
> >  	pc = preempt_count();						\
> >  									\
> > +	tstruct;							\
> > +									\
> >  	event = trace_current_buffer_lock_reserve(event_##call.id,	\
> > -				  sizeof(struct ftrace_raw_##call),	\
> > -				  irq_flags, pc);			\
> > +				 sizeof(struct ftrace_raw_##call) + __str_size,\
> > +				 irq_flags, pc);			\
> >  	if (!event)							\
> >  		return;							\
> >  	entry	= ring_buffer_event_data(event);			\
> > -- 
> > 1.6.1
> 
> Other than my comment above...
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Actually I looked at this code deeper than an Ack.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

