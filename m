Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbZC3Ki2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbZC3Ki2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 06:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbZC3KiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 06:38:19 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:55126 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbZC3KiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 06:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZS9jMGaamk0ovU4d0Ilb7yur4DjemphJXoLivd9GYqw3xPfPK3+Uupt9OvNP4aHpnk
         IamZAzuASggfjlMu2lrylf1xLOChM8jatMrj3agvgXfuCN+5kyIOGOgb0zj4xrOBWwXq
         AUlQH5XPbtwdAfGvsPx1lLXgSAi8vwLGWRcYE=
Date: Mon, 30 Mar 2009 12:38:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/filters: add run-time field descriptions to
	TRACE_EVENT_FORMAT events
Message-ID: <20090330103808.GB6058@nowhere>
References: <1238390524.6368.64.camel@bookworm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238390524.6368.64.camel@bookworm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,



On Mon, Mar 30, 2009 at 12:22:04AM -0500, Tom Zanussi wrote:
> This patch adds run-time field descriptions to all the event formats
> exported using TRACE_EVENT_FORMAT.  It also hooks up all the tracers
> that use them (i.e. the tracers in the 'ftrace subsystem') so they can
> also have their output filtered by the event-filtering mechanism.
> 
> When I was testing this, there were a couple of things that fooled me
> into thinking the filters weren't working, when actually they were -
> I'll mention them here so others don't make the same mistakes (and file
> bug reports. ;-)
> 
> One is that some of the tracers trace multiple events e.g. the
> sched_switch tracer uses the context_switch and wakeup events, and if
> you don't set filters on all of the traced events, the unfiltered output
> from the events without filters on them can make it look like the
> filtering as a whole isn't working properly, when actually it is doing
> what it was asked to do - it just wasn't asked to do the right thing.
> 
> The other is that for the really high-volume tracers e.g. the function
> tracer, the volume of filtered events can be so high that it pushes the
> unfiltered events out of the ring buffer before they can be read so e.g.
> cat'ing the trace file repeatedly shows either no output, or once in
> awhile some output but that isn't there the next time you read the
> trace, which isn't what you normally expect when reading the trace file.
> If you read from the trace_pipe file though, you can catch them before
> they disappear.



Oh, do you know why these unfiltered event are disappearing?


> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> ---
>  kernel/trace/kmemtrace.c            |    8 +++++
>  kernel/trace/trace.c                |   35 +++++++++++++++++++++
>  kernel/trace/trace.h                |   15 +++++++++
>  kernel/trace/trace_branch.c         |    4 ++
>  kernel/trace/trace_event_types.h    |    6 ++-
>  kernel/trace/trace_events.c         |    7 ++++
>  kernel/trace/trace_events_filter.c  |    4 +-
>  kernel/trace/trace_events_stage_2.h |    7 ----
>  kernel/trace/trace_export.c         |   57 +++++++++++++++++++++++++++++++++--
>  kernel/trace/trace_hw_branches.c    |    3 ++
>  kernel/trace/trace_power.c          |    6 ++++
>  11 files changed, 138 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
> index 5011f4d..5962377 100644
> --- a/kernel/trace/kmemtrace.c
> +++ b/kernel/trace/kmemtrace.c
> @@ -42,6 +42,8 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
>  				   gfp_t gfp_flags,
>  				   int node)
>  {
> +	extern struct ftrace_event_call event_kmem_alloc;


I think you should avoid "extern" inside a function.
You can include trace_event_types.h where they are defined.



> +	struct ftrace_event_call *call = &event_kmem_alloc;
>  	struct trace_array *tr = kmemtrace_array;
>  	struct kmemtrace_alloc_entry *entry;
>  	struct ring_buffer_event *event;
> @@ -62,6 +64,8 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
>  	entry->gfp_flags	= gfp_flags;
>  	entry->node		= node;
>  
> +	filter_check_discard(call, entry, event);
> +
>  	ring_buffer_unlock_commit(tr->buffer, event);
>  
>  	trace_wake_up();
> @@ -71,6 +75,8 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
>  				  unsigned long call_site,
>  				  const void *ptr)
>  {
> +	extern struct ftrace_event_call event_kmem_free;
> +	struct ftrace_event_call *call = &event_kmem_free;
>  	struct trace_array *tr = kmemtrace_array;
>  	struct kmemtrace_free_entry *entry;
>  	struct ring_buffer_event *event;
> @@ -86,6 +92,8 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
>  	entry->call_site	= call_site;
>  	entry->ptr		= ptr;
>  
> +	filter_check_discard(call, entry, event);
> +
>  	ring_buffer_unlock_commit(tr->buffer, event);
>  
>  	trace_wake_up();
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 2a81dec..3624b25 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -898,6 +898,8 @@ trace_function(struct trace_array *tr,
>  	       unsigned long ip, unsigned long parent_ip, unsigned long flags,
>  	       int pc)
>  {
> +	extern struct ftrace_event_call event_function;


Ditto.


> +	struct ftrace_event_call *call = &event_function;
>  	struct ring_buffer_event *event;
>  	struct ftrace_entry *entry;
>  
> @@ -912,6 +914,9 @@ trace_function(struct trace_array *tr,
>  	entry	= ring_buffer_event_data(event);
>  	entry->ip			= ip;
>  	entry->parent_ip		= parent_ip;
> +
> +	filter_check_discard(call, entry, event);



trace_function may be called for every functions in the kernel.
So this is a very hot path.

It would be better to have a:

if (unlikely(filter_enabled))
	filter_check_discard(...)

or something like that to not make the weight of filtering
more heavy than a ghost in the off case (=no filter set).



>  	ring_buffer_unlock_commit(tr->buffer, event);
>  }
>  
> @@ -921,6 +926,8 @@ static int __trace_graph_entry(struct trace_array *tr,
>  				unsigned long flags,
>  				int pc)
>  {
> +	extern struct ftrace_event_call event_funcgraph_entry;
> +	struct ftrace_event_call *call = &event_funcgraph_entry;
>  	struct ring_buffer_event *event;
>  	struct ftrace_graph_ent_entry *entry;
>  
> @@ -933,6 +940,7 @@ static int __trace_graph_entry(struct trace_array *tr,
>  		return 0;
>  	entry	= ring_buffer_event_data(event);
>  	entry->graph_ent			= *trace;
> +	filter_check_discard(call, entry, event);



That's the same for this function but worst! Because the function
graph tracer is even more costly than the function tracer.


>  	ring_buffer_unlock_commit(global_trace.buffer, event);
>  
>  	return 1;
> @@ -943,6 +951,8 @@ static void __trace_graph_return(struct trace_array *tr,
>  				unsigned long flags,
>  				int pc)
>  {
> +	extern struct ftrace_event_call event_funcgraph_exit;
> +	struct ftrace_event_call *call = &event_funcgraph_exit;
>  	struct ring_buffer_event *event;
>  	struct ftrace_graph_ret_entry *entry;
>  
> @@ -955,6 +965,7 @@ static void __trace_graph_return(struct trace_array *tr,
>  		return;
>  	entry	= ring_buffer_event_data(event);
>  	entry->ret				= *trace;
> +	filter_check_discard(call, entry, event);



Ditto.



>  	ring_buffer_unlock_commit(global_trace.buffer, event);
>  }
>  #endif
> @@ -973,6 +984,8 @@ static void __ftrace_trace_stack(struct trace_array *tr,
>  				 int skip, int pc)
>  {
>  #ifdef CONFIG_STACKTRACE
> +	extern struct ftrace_event_call event_kernel_stack;
> +	struct ftrace_event_call *call = &event_kernel_stack;
>  	struct ring_buffer_event *event;
>  	struct stack_entry *entry;
>  	struct stack_trace trace;
> @@ -990,6 +1003,7 @@ static void __ftrace_trace_stack(struct trace_array *tr,
>  	trace.entries		= entry->caller;
>  
>  	save_stack_trace(&trace);
> +	filter_check_discard(call, entry, event);


Should be also the same for this one because the function tracer can
rely on stack trace, providing a double cost.

May be we could put a pointer to a global var on the
struct ftrace_event_call so that we can check quickly whether we have
filters to check or not.

Say we have:

bool function_filtering;
bool function_graph_filtering;


When we set the event:

struct ftrace_event_call function_event = {
	.filter_on = &function_filtering;
};


And when you set a filter:

*event->filter_on = true;



>  	ring_buffer_unlock_commit(tr->buffer, event);
>  #endif
>  }
> @@ -1015,6 +1029,8 @@ static void ftrace_trace_userstack(struct trace_array *tr,
>  				   unsigned long flags, int pc)
>  {
>  #ifdef CONFIG_STACKTRACE
> +	extern struct ftrace_event_call event_user_stack;
> +	struct ftrace_event_call *call = &event_user_stack;
>  	struct ring_buffer_event *event;
>  	struct userstack_entry *entry;
>  	struct stack_trace trace;
> @@ -1036,6 +1052,7 @@ static void ftrace_trace_userstack(struct trace_array *tr,
>  	trace.entries		= entry->caller;
>  
>  	save_stack_trace_user(&trace);
> +	filter_check_discard(call, entry, event);



I don't remember well but I think the function tracer can rely on it too.



>  	ring_buffer_unlock_commit(tr->buffer, event);
>  #endif
>  }
> @@ -1052,6 +1069,8 @@ ftrace_trace_special(void *__tr,
>  		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
>  		     int pc)
>  {
> +	extern struct ftrace_event_call event_special;
> +	struct ftrace_event_call *call = &event_special;
>  	struct ring_buffer_event *event;
>  	struct trace_array *tr = __tr;
>  	struct special_entry *entry;
> @@ -1064,6 +1083,7 @@ ftrace_trace_special(void *__tr,
>  	entry->arg1			= arg1;
>  	entry->arg2			= arg2;
>  	entry->arg3			= arg3;
> +	filter_check_discard(call, entry, event);



Hmm, the trace_special type can have multiple semantics.
I don't know if it's worth enable filtering for it.



>  	trace_buffer_unlock_commit(tr, event, 0, pc);
>  }
>  
> @@ -1080,6 +1100,8 @@ tracing_sched_switch_trace(struct trace_array *tr,
>  			   struct task_struct *next,
>  			   unsigned long flags, int pc)
>  {
> +	extern struct ftrace_event_call event_context_switch;
> +	struct ftrace_event_call *call = &event_context_switch;
>  	struct ring_buffer_event *event;
>  	struct ctx_switch_entry *entry;
>  
> @@ -1095,6 +1117,9 @@ tracing_sched_switch_trace(struct trace_array *tr,
>  	entry->next_prio		= next->prio;
>  	entry->next_state		= next->state;
>  	entry->next_cpu	= task_cpu(next);
> +
> +	filter_check_discard(call, entry, event);
> +
>  	trace_buffer_unlock_commit(tr, event, flags, pc);
>  }
>  
> @@ -1104,6 +1129,8 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
>  			   struct task_struct *curr,
>  			   unsigned long flags, int pc)
>  {
> +	extern struct ftrace_event_call event_wakeup;
> +	struct ftrace_event_call *call = &event_wakeup;
>  	struct ring_buffer_event *event;
>  	struct ctx_switch_entry *entry;
>  
> @@ -1120,6 +1147,8 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
>  	entry->next_state		= wakee->state;
>  	entry->next_cpu			= task_cpu(wakee);
>  
> +	filter_check_discard(call, entry, event);
> +
>  	ring_buffer_unlock_commit(tr->buffer, event);
>  	ftrace_trace_stack(tr, flags, 6, pc);
>  	ftrace_trace_userstack(tr, flags, pc);
> @@ -1221,6 +1250,8 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
>  		(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
>  	static u32 trace_buf[TRACE_BUF_SIZE];
>  
> +	extern struct ftrace_event_call event_bprint;
> +	struct ftrace_event_call *call = &event_bprint;
>  	struct ring_buffer_event *event;
>  	struct trace_array *tr = &global_trace;
>  	struct trace_array_cpu *data;
> @@ -1260,6 +1291,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
>  	entry->fmt			= fmt;
>  
>  	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
> +	filter_check_discard(call, entry, event);
>  	ring_buffer_unlock_commit(tr->buffer, event);
>  
>  out_unlock:
> @@ -1279,6 +1311,8 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
>  	static raw_spinlock_t trace_buf_lock = __RAW_SPIN_LOCK_UNLOCKED;
>  	static char trace_buf[TRACE_BUF_SIZE];
>  
> +	extern struct ftrace_event_call event_print;
> +	struct ftrace_event_call *call = &event_print;
>  	struct ring_buffer_event *event;
>  	struct trace_array *tr = &global_trace;
>  	struct trace_array_cpu *data;
> @@ -1314,6 +1348,7 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
>  
>  	memcpy(&entry->buf, trace_buf, len);
>  	entry->buf[len] = 0;
> +	filter_check_discard(call, entry, event);
>  	ring_buffer_unlock_commit(tr->buffer, event);
>  
>   out_unlock:
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index fec6521..cfb07ef 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -860,6 +860,21 @@ extern void filter_free_subsystem_preds(struct event_subsystem *system);
>  extern int filter_add_subsystem_pred(struct event_subsystem *system,
>  				     struct filter_pred *pred);
>  
> +static inline void
> +filter_check_discard(struct ftrace_event_call *call, void *rec,
> +		     struct ring_buffer_event *event)
> +{
> +	if (call->preds && !filter_match_preds(call, rec))


Ah you have made it more lightweight than I thought.
I don't remember, is call->preds == NULL when we disable
a filter? I mean, after we have enabled it once?



> +		ring_buffer_event_discard(event);
> +}
> +
> +#define __common_field(type, item)					\
> +	ret = trace_define_field(event_call, #type, "common_" #item,	\
> +				 offsetof(typeof(field.ent), item),	\
> +				 sizeof(field.ent.item));		\
> +	if (ret)							\
> +		return ret;
> +
>  void event_trace_printk(unsigned long ip, const char *fmt, ...);
>  extern struct ftrace_event_call __start_ftrace_events[];
>  extern struct ftrace_event_call __stop_ftrace_events[];
> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> index e6e3291..8ee5f1d 100644
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -30,6 +30,8 @@ static struct trace_array *branch_tracer;
>  static void
>  probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  {
> +	extern struct ftrace_event_call event_branch;
> +	struct ftrace_event_call *call = &event_branch;
>  	struct trace_array *tr = branch_tracer;
>  	struct ring_buffer_event *event;
>  	struct trace_branch *entry;
> @@ -73,6 +75,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  	entry->line = f->line;
>  	entry->correct = val == expect;
>  
> +	filter_check_discard(call, entry, event);
> +
>  	ring_buffer_unlock_commit(tr->buffer, event);
>  
>   out:
> diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
> index fd78bee..95b147a 100644
> --- a/kernel/trace/trace_event_types.h
> +++ b/kernel/trace/trace_event_types.h
> @@ -122,8 +122,10 @@ TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
>  TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
>  	TRACE_STRUCT(
>  		TRACE_FIELD(unsigned int, line, line)
> -		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE+1], func, func)
> -		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE+1], file, file)
> +		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE+1], func,
> +				    TRACE_FUNC_SIZE+1, func)
> +		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE+1], file,
> +				    TRACE_FUNC_SIZE+1, file)
>  		TRACE_FIELD(char, correct, correct)
>  	),
>  	TP_RAW_FMT("%u:%s:%s (%u)")
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 64ec4d2..be9299a 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -680,6 +680,7 @@ static struct dentry *
>  event_subsystem_dir(const char *name, struct dentry *d_events)
>  {
>  	struct event_subsystem *system;
> +	struct dentry *entry;
>  
>  	/* First see if we did not already create this dir */
>  	list_for_each_entry(system, &event_subsystems, list) {
> @@ -708,6 +709,12 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
>  
>  	system->preds = NULL;
>  
> +	entry = debugfs_create_file("filter", 0644, system->entry, system,
> +				    &ftrace_subsystem_filter_fops);
> +	if (!entry)
> +		pr_warning("Could not create debugfs "
> +			   "'%s/filter' entry\n", name);
> +
>  	return system->entry;
>  }
>  
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 026be41..470ad94 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -185,7 +185,7 @@ void filter_free_subsystem_preds(struct event_subsystem *system)
>  	}
>  
>  	events_for_each(call) {
> -		if (!call->name || !call->regfunc)
> +		if (!call->define_fields)
>  			continue;
>  
>  		if (!strcmp(call->system, system->name))
> @@ -324,7 +324,7 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
>  	events_for_each(call) {
>  		int err;
>  
> -		if (!call->name || !call->regfunc)
> +		if (!call->define_fields)
>  			continue;
>  
>  		if (strcmp(call->system, system->name))
> diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
> index 30743f7..1c94b87 100644
> --- a/kernel/trace/trace_events_stage_2.h
> +++ b/kernel/trace/trace_events_stage_2.h
> @@ -146,13 +146,6 @@ ftrace_format_##call(struct trace_seq *s)				\
>  	if (ret)							\
>  		return ret;
>  
> -#define __common_field(type, item)					\
> -	ret = trace_define_field(event_call, #type, "common_" #item,	\
> -				 offsetof(typeof(field.ent), item),	\
> -				 sizeof(field.ent.item));		\
> -	if (ret)							\
> -		return ret;
> -
>  #undef TRACE_EVENT
>  #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
>  int									\
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index 4d9952d..47989be 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -30,7 +30,7 @@
>  
>  
>  #undef TRACE_FIELD_SPECIAL
> -#define TRACE_FIELD_SPECIAL(type_item, item, cmd)			\
> +#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)			\
>  	ret = trace_seq_printf(s, "\tfield special:" #type_item ";\t"	\
>  			       "offset:%u;\tsize:%u;\n",		\
>  			       (unsigned int)offsetof(typeof(field), item), \
> @@ -85,18 +85,69 @@ ftrace_format_##call(struct trace_seq *s)				\
>  #define TRACE_ENTRY	entry
>  
>  #undef TRACE_FIELD_SPECIAL
> -#define TRACE_FIELD_SPECIAL(type_item, item, cmd) \
> +#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)	\
>  	cmd;
>  
>  #undef TRACE_EVENT_FORMAT
>  #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
> +int ftrace_define_fields_##call(void);					\
> +static int ftrace_raw_init_event_##call(void);				\
>  									\
> -static struct ftrace_event_call __used					\
> +struct ftrace_event_call __used						\
>  __attribute__((__aligned__(4)))						\
>  __attribute__((section("_ftrace_events"))) event_##call = {		\
>  	.name			= #call,				\
>  	.id			= proto,				\
>  	.system			= __stringify(TRACE_SYSTEM),		\
> +	.raw_init		= ftrace_raw_init_event_##call,		\
>  	.show_format		= ftrace_format_##call,			\
> +	.define_fields		= ftrace_define_fields_##call,		\
> +};									\
> +static int ftrace_raw_init_event_##call(void)				\
> +{									\
> +	INIT_LIST_HEAD(&event_##call.fields);				\
> +	return 0;							\
> +}									\
> 
> +#include "trace_event_types.h"
> +
> +#undef TRACE_FIELD
> +#define TRACE_FIELD(type, item, assign)					\
> +	ret = trace_define_field(event_call, #type, #item,		\
> +				 offsetof(typeof(field), item),		\
> +				 sizeof(field.item));			\
> +	if (ret)							\
> +		return ret;
> +
> +#undef TRACE_FIELD_SPECIAL
> +#define TRACE_FIELD_SPECIAL(type, item, len, cmd)			\
> +	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
> +				 offsetof(typeof(field), item),		\
> +				 sizeof(field.item));			\
> +	if (ret)							\
> +		return ret;
> +
> +#undef TRACE_FIELD_ZERO_CHAR
> +#define TRACE_FIELD_ZERO_CHAR(item)
> +
> +#undef TRACE_EVENT_FORMAT
> +#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
> +int									\
> +ftrace_define_fields_##call(void)					\
> +{									\
> +	struct ftrace_event_call *event_call = &event_##call;		\
> +	struct args field;						\
> +	int ret;							\
> +									\
> +	__common_field(unsigned char, type);				\
> +	__common_field(unsigned char, flags);				\
> +	__common_field(unsigned char, preempt_count);			\
> +	__common_field(int, pid);					\
> +	__common_field(int, tgid);					\
> +									\
> +	tstruct;							\
> +									\
> +	return ret;							\
>  }
> +
>  #include "trace_event_types.h"
> diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
> index 7bfdf4c..bca7791 100644
> --- a/kernel/trace/trace_hw_branches.c
> +++ b/kernel/trace/trace_hw_branches.c
> @@ -168,6 +168,8 @@ static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
>  
>  void trace_hw_branch(u64 from, u64 to)
>  {
> +	extern struct ftrace_event_call event_hw_branch;
> +	struct ftrace_event_call *call = &event_hw_branch;
>  	struct trace_array *tr = hw_branch_trace;
>  	struct ring_buffer_event *event;
>  	struct hw_branch_entry *entry;
> @@ -194,6 +196,7 @@ void trace_hw_branch(u64 from, u64 to)
>  	entry->ent.type = TRACE_HW_BRANCHES;
>  	entry->from = from;
>  	entry->to   = to;
> +	filter_check_discard(call, entry, event);
>  	trace_buffer_unlock_commit(tr, event, 0, 0);
>  
>   out:
> diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
> index bae791e..20ef32d 100644
> --- a/kernel/trace/trace_power.c
> +++ b/kernel/trace/trace_power.c
> @@ -36,6 +36,8 @@ static void probe_power_start(struct power_trace *it, unsigned int type,
>  
>  static void probe_power_end(struct power_trace *it)
>  {
> +	extern struct ftrace_event_call event_power;
> +	struct ftrace_event_call *call = &event_power;
>  	struct ring_buffer_event *event;
>  	struct trace_power *entry;
>  	struct trace_array_cpu *data;
> @@ -54,6 +56,7 @@ static void probe_power_end(struct power_trace *it)
>  		goto out;
>  	entry	= ring_buffer_event_data(event);
>  	entry->state_data = *it;
> +	filter_check_discard(call, entry, event);
>  	trace_buffer_unlock_commit(tr, event, 0, 0);
>   out:
>  	preempt_enable();
> @@ -62,6 +65,8 @@ static void probe_power_end(struct power_trace *it)
>  static void probe_power_mark(struct power_trace *it, unsigned int type,
>  				unsigned int level)
>  {
> +	extern struct ftrace_event_call event_power;
> +	struct ftrace_event_call *call = &event_power;
>  	struct ring_buffer_event *event;
>  	struct trace_power *entry;
>  	struct trace_array_cpu *data;
> @@ -84,6 +89,7 @@ static void probe_power_mark(struct power_trace *it, unsigned int type,
>  		goto out;
>  	entry	= ring_buffer_event_data(event);
>  	entry->state_data = *it;
> +	filter_check_discard(call, entry, event);
>  	trace_buffer_unlock_commit(tr, event, 0, 0);
>   out:
>  	preempt_enable();
> -- 
> 1.5.6.3
> 



All ine one it looks nice!

