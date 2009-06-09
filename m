Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbZFITWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbZFITWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZFITWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:22:09 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:63981 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZFITWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:22:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KZY9FCy/CZXaqe2O3CoSGSpV8fD/Ey7G7HpkFeQpgSw+QhYkXf2oDIA+pg+mUXfhSO
         7h9hzaY9FvuxKUCj4krDCL+En9nctLQxqr0cN5P446YsCN1OwjgXmgorIeIz87DradN3
         /iLD3m3+ruDM8AYKiWWtRiU3rHAWgki4XlMTs=
Date: Tue, 9 Jun 2009 21:22:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 2/5] tracing/events: nicer print format for parsing
Message-ID: <20090609192159.GD6057@nowhere>
References: <20090609014534.790466803@goodmis.org> <20090609014746.481457542@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609014746.481457542@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 09:45:36PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The current print format that is exported to userspace is simply a
> copy of the printk format used to output the data. It would take a
> full C parser to parse it. But as more tools are made to read the
> binary data from ftrace, the larger the need for a nice parsing
> format to facilitate tools in reading the binary buffer.
> 
> For example we currently have:
> 
> irq_handler_entry:
>  print fmt: "irq=%d handler=%s", REC->irq, (char *)((void *)REC + REC->__data_loc
> _name)
> 
> softirq_entry:
>  print fmt: "softirq=%d action=%s", REC->vec, ({ static const struct trace_print_
> flags symbols[] = { { HI_SOFTIRQ, "HI" }, { TIMER_SOFTIRQ, "TIMER" }, { NET_TX_S
> OFTIRQ, "NET_TX" }, { NET_RX_SOFTIRQ, "NET_RX" }, { BLOCK_SOFTIRQ, "BLOCK" }, {
> TASKLET_SOFTIRQ, "TASKLET" }, { SCHED_SOFTIRQ, "SCHED" }, { HRTIMER_SOFTIRQ, "HR
> TIMER" }, { RCU_SOFTIRQ, "RCU" }, { -1, ((void *)0) }}; ftrace_print_symbols_seq
> (p, REC->vec, symbols); })
> 
> kmalloc:
>  print fmt: "call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s", RE
> C->call_site, REC->ptr, REC->bytes_req, REC->bytes_alloc, (REC->gfp_flags) ? ({
> static const struct trace_print_flags flags[] = { {(unsigned long)(((gfp_t)0x10u
> ) | ((gfp_t)0x40u) | ((gfp_t)0x80u) | ((gfp_t)0x20000u) | ((gfp_t)0x02u) | ((gfp
> _t)0x100000u)), "GFP_HIGHUSER_MOVABLE"}, {(unsigned long)(((gfp_t)0x10u) | ((gfp
> _t)0x40u) | ((gfp_t)0x80u) | ((gfp_t)0x20000u) | ((gfp_t)0x02u)), "GFP_HIGHUSER"
> }, {(unsigned long)(((gfp_t)0x10u) | ((gfp_t)0x40u) | ((gfp_t)0x80u) | ((gfp_t)0
> x20000u)), "GFP_USER"}, {(unsigned long)(((gfp_t)0x10u) | ((gfp_t)0x40u) | ((gfp
> _t)0x80u) | ((gfp_t)0x80000u)), "GFP_TEMPORARY"}, {(unsigned long)(((gfp_t)0x10u
> ) | ((gfp_t)0x40u) | ((gfp_t)0x80u)), "GFP_KERNEL"}, {(unsigned long)(((gfp_t)0x
> 10u) | ((gfp_t)0x40u)), "GFP_NOFS"}, {(unsigned long)(((gfp_t)0x20u)), "GFP_ATOM
> IC"}, {(unsigned long)(((gfp_t)0x10u)), "GFP_NOIO"}, {(unsigned long)((gfp_t)0x2
> 0u), "GFP_HIGH"}, {(unsigned long)((gfp_t)0x10u), "GFP_WAIT"}, {(unsigned long)(
> (gfp_t)0x40u), "GFP_IO"}, {(unsigned long)((gfp_t)0x100u), "GFP_COLD"}, {(unsign
> ed long)((gfp_t)0x200u), "GFP_NOWARN"}, {(unsigned long)((gfp_t)0x400u), "GFP_RE
> PEAT"}, {(unsigned long)((gfp_t)0x800u), "GFP_NOFAIL"}, {(unsigned long)((gfp_t)
> 0x1000u), "GFP_NORETRY"}, {(unsigned long)((gfp_t)0x4000u), "GFP_COMP"}, {(unsig
> ned long)((gfp_t)0x8000u), "GFP_ZERO"}, {(unsigned long)((gfp_t)0x10000u), "GFP_
> NOMEMALLOC"}, {(unsigned long)((gfp_t)0x20000u), "GFP_HARDWALL"}, {(unsigned lon
> g)((gfp_t)0x40000u), "GFP_THISNODE"}, {(unsigned long)((gfp_t)0x80000u), "GFP_RE
> CLAIMABLE"}, {(unsigned long)((gfp_t)0x100000u), "GFP_MOVABLE"}, { -1, ((void *)
> 0) }}; ftrace_print_flags_seq(p, "|", REC->gfp_flags, flags); }) : "GFP_NOWAIT"



I agree with the fact that it must be simplified.



 
> The language that is added by this patch is of the following:
> 
>  * FMT :=  constant string FMT | COMMAND FMT | empty
>  * COMMAND := <TYPE:FIELD> | <mask:FIELD:DELIM:MASKS> | <sym:FIELD:SYMBOLS> |
>  *               <if:FIELD:TRUE:FALSE>
>  * TYPE := int | hex | ptr | string | strarray
>  * FIELD := defined by the event structure
>  * MASKS := MASK=NAME,MASKS | MASK=NAME
>  * MASK := the bit mask to match
>  * DELIM := delimiter to separate the fields. None and ':' are both allowed
>  * SYMBOLS := SYM=NAME,SYMBOLS | SYM=NAME
>  * SYM := the symbol value to test against
>  * TRUE := print when field is non zero
>  * FALSE := print when field is zero or NULL
>  * NAME := the name to write when a match is found
>  *
>  * A '\<' would print '<'


But I wonder if the above new language is not breaking the charm
of the TRACE_EVENT(), which charm is that it's easy to implement (hopefully).

Everyone knows the printk formats. And I guess this new thing is easy and
quick to learn. But because it's a new unknown language, the TRACE_EVENT
will become less readable, less reachable for newcomers in TRACE_EVENT.

I don't know...

Frederic.

 
> The above examples would then look like:
> 
> irq_handler_entry:
>  format: irq=<int:irq> handler=<string:name>
> 
> softirq_entry:
>  format: softirq=<int:vec> action=<sym:vec:0=HI,1=TIMER,2=NET_TX,3=NET_RX,4=BLOCK,5=TASKLET,6=SCHED,7=HRTIMER,8=RCU
> 
> kmalloc:
>  format: call_site=<hex:call_site> ptr=<ptr:ptr> bytes_req=<int:bytes_req> bytes_alloc=<int:bytes_alloc> gfp_flags=<mask:gfp_flags:|:0=GFP_NOWAIT,0x1200d2=GFP_HIGHUSER_MOVABLE,0x200d2=GFP_HIGHUSER,0x200d0=GFP_USER,0x800d0=GFP_TEMPORARY,0xd0=GFP_KERNEL,0x50=GFP_NOFS,0x20=GFP_ATOMIC,0x10=GFP_NOIO,0x20=GFP_HIGH,0x10=GFP_WAIT,0x40=GFP_IO,0x100=GFP_COLD,0x200=GFP_NOWARN,0x400=GFP_REPEAT,0x800=GFP_NOFAIL,0x1000=GFP_NORETRY,0x4000=GFP_COMP,0x8000=GFP_ZERO,0x10000=GFP_NOMEMALLOC,0x20000=GFP_HARDWALL,0x40000=GFP_THISNODE,0x80000=GFP_RECLAIMABLE,0x100000=GFP_MOVABLE
> 
> The above "mask" command takes '0' as a special mask that should be done only in the beginning. It will write that symbol out when the mask is zero.
> 
> Another nice thing about this change set is that it can live together with
> the current print format. The old version will show "print fmt:" in
> the output file, where as the new version will use "format:" as shown
> in the above examples.
> 
> Both may be used, but it would be preferable to use the new language.
> If the new language is not adequate for a new trace point we can always
> add new types. Userspace tools should just ignore types it does not
> understand.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace_event.h     |   10 +
>  include/trace/ftrace.h           |   22 ++-
>  kernel/trace/Makefile            |    1 +
>  kernel/trace/trace_read_binary.c |  674 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 705 insertions(+), 2 deletions(-)
>  create mode 100644 kernel/trace/trace_read_binary.c
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 5c093ff..f1b59d3 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -119,6 +119,9 @@ struct ftrace_event_call {
>  	void			*filter;
>  	void			*mod;
>  
> +	struct list_head	print_info;
> +	const char		*print_text;
> +
>  #ifdef CONFIG_EVENT_PROFILE
>  	atomic_t	profile_count;
>  	int		(*profile_enable)(struct ftrace_event_call *);
> @@ -136,6 +139,13 @@ extern int filter_current_check_discard(struct ftrace_event_call *call,
>  					void *rec,
>  					struct ring_buffer_event *event);
>  
> +extern char *ftrace_read_binary(struct trace_seq *p,
> +				struct ftrace_event_call *event,
> +				struct trace_entry *entry);
> +extern int ftrace_initialize_print(struct ftrace_event_call *event,
> +				   const char *fmt, ...)
> +	__attribute__ ((format (printf, 2, 3)));
> +
>  extern int trace_define_field(struct ftrace_event_call *call, char *type,
>  			      char *name, int offset, int size, int is_signed);
>  
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 40ede4d..e3370c5 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -124,6 +124,10 @@
>  #undef TP_printk
>  #define TP_printk(fmt, args...) fmt "\n", args
>  
> +#undef TP_FORMAT
> +#define TP_FORMAT(fmt, args...) \
> +	"%s\n", ftrace_read_binary(p, event_call, entry)
> +
>  #undef __get_dynamic_array
>  #define __get_dynamic_array(field)	\
>  		((void *)__entry + __entry->__data_loc_##field)
> @@ -152,6 +156,7 @@
>  enum print_line_t							\
>  ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
>  {									\
> +	struct ftrace_event_call *event_call __maybe_unused = &event_##call; \
>  	struct trace_seq *s = &iter->seq;				\
>  	struct ftrace_raw_##call *field;				\
>  	struct trace_entry *entry;					\
> @@ -234,7 +239,10 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
>  #define __entry REC
>  
>  #undef TP_printk
> -#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
> +#define TP_printk(fmt, args...) "print fmt: %s, %s\n", #fmt, __stringify(args)
> +
> +#undef TP_FORMAT
> +#define TP_FORMAT(fmt, args...) "format: " fmt "\n",  ##args
>  
>  #undef TP_fast_assign
>  #define TP_fast_assign(args...) args
> @@ -249,7 +257,7 @@ ftrace_format_##call(struct trace_seq *s)				\
>  									\
>  	tstruct;							\
>  									\
> -	trace_seq_printf(s, "\nprint fmt: " print);			\
> +	trace_seq_printf(s, "\n" print);				\
>  									\
>  	return ret;							\
>  }
> @@ -279,6 +287,13 @@ ftrace_format_##call(struct trace_seq *s)				\
>  				offsetof(typeof(field), __data_loc_##item),    \
>  				 sizeof(field.__data_loc_##item), 0);
>  
> +#undef TP_printk
> +#define TP_printk(fmt, args...)
> +
> +#undef TP_FORMAT
> +#define TP_FORMAT(fmt, args...) \
> +	ftrace_initialize_print(event_call, fmt, ##args)
> +
>  #undef __string
>  #define __string(item, src) __dynamic_array(char, item, -1)
>  
> @@ -299,6 +314,8 @@ ftrace_define_fields_##call(void)					\
>  									\
>  	tstruct;							\
>  									\
> +	print;								\
> +									\
>  	return ret;							\
>  }
>  
> @@ -563,6 +580,7 @@ static int ftrace_raw_init_event_##call(void)				\
>  	event_##call.id = id;						\
>  	INIT_LIST_HEAD(&event_##call.fields);				\
>  	init_preds(&event_##call);					\
> +	INIT_LIST_HEAD(&event_##call.print_info);			\
>  	return 0;							\
>  }									\
>  									\
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 06b8585..7c2ff68 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -51,5 +51,6 @@ obj-$(CONFIG_EVENT_TRACING) += trace_export.o
>  obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
>  obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
>  obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
> +obj-$(CONFIG_EVENT_TRACING) += trace_read_binary.o
>  
>  libftrace-y := ftrace.o
> diff --git a/kernel/trace/trace_read_binary.c b/kernel/trace/trace_read_binary.c
> new file mode 100644
> index 0000000..100d5c0
> --- /dev/null
> +++ b/kernel/trace/trace_read_binary.c
> @@ -0,0 +1,674 @@
> +/*
> + * trace_read_binary.c
> + *
> + * Copyright (C) 2009 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + *
> + */
> +
> +#include <linux/ftrace_event.h>
> +#include <linux/hardirq.h>
> +#include <linux/module.h>
> +#include <linux/ctype.h>
> +
> +#include "trace.h"
> +
> +static DEFINE_MUTEX(buffer_lock);
> +static struct trace_seq buffer;
> +
> +/*
> + * Binary string parser. The print format uses a special language to explain
> + * the format to print the entry out. The language is as follows:
> + *
> + * FMT :=  constant string FMT | COMMAND FMT | empty
> + * COMMAND := <TYPE:FIELD> | <mask:FIELD:DELIM:MASKS> | <sym:FIELD:SYMBOLS> |
> + *               <if:FIELD:TRUE:FALSE>
> + * TYPE := int | hex | ptr | string | strarray
> + * FIELD := defined by the event structure
> + * MASKS := MASK=NAME,MASKS | MASK=NAME
> + * MASK := the bit mask to match
> + * DELIM := delimiter to separate the fields. None and ':' are both allowed
> + * SYMBOLS := SYM=NAME,SYMBOLS | SYM=NAME
> + * SYM := the symbol value to test against
> + * TRUE := print when field is non zero
> + * FALSE := print when field is zero or NULL
> + * NAME := the name to write when a match is found
> + *
> + * A '\<' would print '<'
> + */
> +
> +#define TOK_SIZE 32
> +
> +enum field_types {
> +	FIELD_IS_TEXT,
> +	FIELD_IS_INT,
> +	FIELD_IS_PTR,
> +	FIELD_IS_LT,
> +	FIELD_IS_IF,
> +	FIELD_IS_STRING,
> +	FIELD_IS_STRARRAY,
> +	FIELD_IS_HEX,
> +	FIELD_IS_MASK,
> +	FIELD_IS_SYMBOL,
> +};
> +
> +struct sym_mask {
> +	struct list_head			list;
> +	unsigned long long			val;
> +	unsigned short				start;
> +	unsigned short				len;
> +};
> +
> +struct print_info {
> +	struct list_head				list;
> +	enum field_types				type;
> +	union {
> +		struct {
> +			unsigned short			start;
> +			unsigned short			len;
> +		} text;
> +		struct {
> +			struct ftrace_event_field	*field;
> +		} data;
> +		struct {
> +			struct ftrace_event_field	*field;
> +			unsigned short			true_text;
> +			unsigned short			true_len;
> +			unsigned short			false_text;
> +			unsigned short			false_len;
> +		} cond;
> +		struct {
> +			struct ftrace_event_field	*field;
> +			struct list_head		masks;
> +			unsigned short			delim;
> +			unsigned short			len;
> +		} sym_mask;
> +	};
> +};
> +
> +static struct print_info *
> +alloc_print_info(struct ftrace_event_call *call, enum field_types type)
> +{
> +	struct print_info *info;
> +
> +	info = kmalloc(sizeof(*info), GFP_KERNEL);
> +	if (!info)
> +		return NULL;
> +
> +	info->type = type;
> +
> +	list_add_tail(&info->list, &call->print_info);
> +
> +	return info;
> +}
> +
> +static int
> +add_text(struct ftrace_event_call *call, const char *start, const char *end)
> +{
> +	struct print_info *info;
> +
> +	info = alloc_print_info(call, FIELD_IS_TEXT);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	info->text.start = start - call->print_text;
> +	if (!end)
> +		end = call->print_text + strlen(call->print_text);
> +	info->text.len = end - start;
> +
> +	return 0;
> +}
> +
> +static int
> +add_less_than(struct ftrace_event_call *call, const char *start, const char *end)
> +{
> +	struct print_info *info;
> +
> +	info = alloc_print_info(call, FIELD_IS_LT);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	info->text.start = start - call->print_text;
> +	info->text.len = end - start;
> +
> +	return 0;
> +}
> +
> +static int
> +add_data(struct ftrace_event_call *call, enum field_types type,
> +	 struct ftrace_event_field *field)
> +{
> +	struct print_info *info;
> +
> +	info = alloc_print_info(call, type);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	info->data.field = field;
> +
> +	return 0;
> +}
> +
> +static int
> +add_if(struct ftrace_event_call *call, struct ftrace_event_field *field,
> +       const char *fmt, const char *end)
> +{
> +	struct print_info *info;
> +	const char *tok;
> +
> +	info = alloc_print_info(call, FIELD_IS_IF);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	info->cond.field = field;
> +
> +	tok = strchr(fmt, ':');
> +	if (!tok || tok > end)
> +		return -1;
> +
> +	info->cond.true_text = fmt - call->print_text;
> +	info->cond.true_len = tok - fmt;
> +
> +	fmt = tok + 1;
> +
> +	info->cond.false_text = fmt - call->print_text;
> +	info->cond.false_len = end - fmt;
> +
> +	return 0;
> +}
> +
> +static int add_sym_mask(struct ftrace_event_call *call, struct list_head *list,
> +			unsigned long long val,
> +			const char *start, const char *end)
> +{
> +	struct sym_mask *sm;
> +
> +	sm = kmalloc(sizeof(*sm), GFP_KERNEL);
> +	if (!sm)
> +		return -ENOMEM;
> +
> +	list_add_tail(&sm->list, list);
> +	sm->val = val;
> +	sm->start = start - call->print_text;
> +	sm->len = end - start;
> +
> +	return 0;
> +}
> +
> +static const char *
> +add_mask(struct ftrace_event_call *call, struct ftrace_event_field *field,
> +	 const char *delim, unsigned int delim_len,
> +	 const char *fmt, const char *end)
> +{
> +	struct print_info *info;
> +	unsigned long long mask;
> +	const char *tok;
> +
> +	info = alloc_print_info(call, FIELD_IS_MASK);
> +	if (!info)
> +		return end;
> +
> +	info->sym_mask.field = field;
> +
> +	INIT_LIST_HEAD(&info->sym_mask.masks);
> +	info->sym_mask.len = delim_len;
> +	if (delim_len)
> +		info->sym_mask.delim = delim - call->print_text;
> +
> +	do {
> +		while (isspace(*fmt))
> +			fmt++;
> +
> +		tok = strchr(fmt, '=');
> +		if (!tok || tok > end)
> +			goto out_err;
> +
> +		mask = simple_strtoull(fmt, NULL, 0);
> +		fmt = tok + 1;
> +
> +		tok = strchr(fmt, ',');
> +		if (!tok || tok > end)
> +			tok = end;
> +
> +		add_sym_mask(call, &info->sym_mask.masks, mask, fmt, tok);
> +
> +		fmt = tok + 1;
> +	} while (fmt < end);
> +
> +	return end;
> + out_err:
> +	WARN_ON(1);
> +	printk("error in format '%s'\n", fmt);
> +	return end;
> +}
> +
> +static const char *
> +add_symbol(struct ftrace_event_call *call, struct ftrace_event_field *field,
> +	   const char *fmt, const char *end)
> +{
> +	struct print_info *info;
> +	unsigned long long sym;
> +	const char *tok;
> +
> +	info = alloc_print_info(call, FIELD_IS_SYMBOL);
> +	if (!info)
> +		return end;
> +
> +	info->sym_mask.field = field;
> +
> +	INIT_LIST_HEAD(&info->sym_mask.masks);
> +
> +	do {
> +		while (isspace(*fmt))
> +			fmt++;
> +
> +		tok = strchr(fmt, '=');
> +		if (!tok || tok > end)
> +			goto out_err;
> +
> +		sym = simple_strtoull(fmt, NULL, 0);
> +		fmt = tok + 1;
> +
> +		tok = strchr(fmt, ',');
> +		if (!tok || tok > end)
> +			tok = end;
> +
> +		add_sym_mask(call, &info->sym_mask.masks, sym, fmt, tok);
> +
> +		fmt = tok + 1;
> +	} while (fmt < end);
> +
> +	return end;
> + out_err:
> +	WARN_ON(1);
> +	printk("error in format '%s'\n", fmt);
> +	return end;
> +}
> +
> +static struct ftrace_event_field *
> +find_field(struct ftrace_event_call *call, const char *name, int len)
> +{
> +	struct ftrace_event_field *field;
> +
> +	list_for_each_entry(field, &call->fields, link) {
> +		if (!strncmp(field->name, name, len))
> +			return field;
> +	}
> +
> +	return NULL;
> +}
> +
> +const char *handle_field(struct ftrace_event_call *event,
> +			 const char *fmt, enum field_types field_type)
> +{
> +	struct ftrace_event_field *field;
> +	const char *end, *tok, *delim;
> +	unsigned int delim_len;
> +
> +	end = strchr(fmt, '>');
> +	if (!end)
> +		goto out_err;
> +
> +	switch (field_type) {
> +	case FIELD_IS_INT:
> +	case FIELD_IS_PTR:
> +	case FIELD_IS_HEX:
> +	case FIELD_IS_STRING:
> +	case FIELD_IS_STRARRAY:
> +		field = find_field(event, fmt, end - fmt);
> +		if (!field)
> +			goto out_err;
> +
> +		add_data(event, field_type, field);
> +		break;
> +
> +	case FIELD_IS_IF:
> +		tok = strchr(fmt, ':');
> +		if (!tok || tok > end)
> +			goto out_err;
> +
> +		field = find_field(event, fmt, tok - fmt);
> +		if (!field)
> +			goto out_err;
> +
> +		fmt = tok + 1;
> +
> +		add_if(event, field, fmt, end);
> +		break;
> +
> +	case FIELD_IS_MASK:
> +	case FIELD_IS_SYMBOL:
> +		tok = strchr(fmt, ':');
> +		if (!tok || tok > end)
> +			goto out_err;
> +
> +		field = find_field(event, fmt, tok - fmt);
> +		if (!field)
> +			goto out_err;
> +
> +		fmt = tok + 1;
> +
> +		if (field_type == FIELD_IS_MASK) {
> +			tok = strchr(fmt, ':');
> +			if (!tok || tok > end)
> +				goto out_err;
> +
> +			delim = fmt;
> +			delim_len = tok - fmt;
> +
> +			/* we allow ':' as a delimiter */
> +			if (!delim_len && tok[1] == ':') {
> +				tok++;
> +				delim_len++;
> +			}
> +
> +			fmt = tok+1;
> +
> +			end = add_mask(event, field, delim, delim_len,  fmt, end);
> +		} else 
> +			end = add_symbol(event, field, fmt, end);
> +
> +		break;
> +	default:
> +		WARN_ON(1);
> +		printk("unknown field\n");
> +	}
> +
> +	end++;
> +	return end;
> +
> + out_err:
> +	WARN_ON(1);
> +	printk("error in format field: '%s'\n", fmt);
> +	return NULL;
> +}
> +
> +int
> +ftrace_initialize_print(struct ftrace_event_call *event, const char *fmt, ...)
> +{
> +	const char *tok;
> +	va_list ap;
> +	int ret;
> +
> +	mutex_lock(&buffer_lock);
> +	trace_seq_init(&buffer);
> +
> +	va_start(ap, fmt);
> +	ret = trace_seq_vprintf(&buffer, fmt, ap);
> +	va_end(ap);
> +	if (!ret)
> +		goto err_unlock;
> +
> +	ret = trace_seq_putc(&buffer, 0);
> +	if (!ret)
> +		goto err_unlock;
> +
> +	event->print_text = kstrdup(buffer.buffer, GFP_KERNEL);
> +	if (!event->print_text)
> +		goto err_unlock;
> +
> +	mutex_unlock(&buffer_lock);
> +
> +	fmt = event->print_text;
> +
> +	do {
> +		enum field_types field_type;
> +
> +		tok = strchr(fmt, '<');
> +		if (!tok) {
> +			add_text(event, fmt, tok);
> +			break;
> +		}
> +		if (*(tok - 1) == '\\') {
> +			add_less_than(event, fmt, tok);
> +			fmt = tok + 1;
> +			continue;
> +		}
> +
> +		add_text(event, fmt, tok);
> +
> +		fmt = tok + 1;
> +
> +		tok = strchr(fmt, ':');
> +		if (!tok)
> +			goto err_format;
> +
> +		if (strncmp(fmt, "int:", 4) == 0)
> +			field_type = FIELD_IS_INT;
> +
> +		else if (strncmp(fmt, "ptr:", 4) == 0)
> +			field_type = FIELD_IS_PTR;
> +
> +		else if (strncmp(fmt, "string:", 7) ==0)
> +			field_type = FIELD_IS_STRING;
> +
> +		else if (strncmp(fmt, "hex:", 4) == 0)
> +			field_type = FIELD_IS_HEX;
> +
> +		else if (strncmp(fmt, "if:", 3) == 0)
> +			field_type = FIELD_IS_IF;
> +
> +		else if (strncmp(fmt, "mask:", 5) == 0)
> +			field_type = FIELD_IS_MASK;
> +
> +		else if (strncmp(fmt, "sym:", 4) == 0)
> +			field_type = FIELD_IS_SYMBOL;
> +
> +		else if (strncmp(fmt, "strarray:", 9) == 0)
> +			field_type = FIELD_IS_STRARRAY;
> +
> +		else
> +			goto err_format;
> +
> +		tok++;
> +		fmt = handle_field(event, tok, field_type);
> +
> +	} while (fmt);
> +
> +	return 0;
> +
> + err_unlock:
> +	WARN_ON(1);
> +	printk("Can not allocate event print format data\n");
> +	mutex_unlock(&buffer_lock);
> +	return -1;
> +
> + err_format:
> +	WARN_ON(1);
> +	printk("error in format type: '%s'\n", fmt);
> +	return -1;
> +}
> +EXPORT_SYMBOL_GPL(ftrace_initialize_print);
> +
> +
> +static void
> +trace_read_mask(struct trace_seq *s, unsigned long long val,
> +		struct print_info *info, struct ftrace_event_call *event)
> +{
> +	unsigned long long mask;
> +	struct sym_mask *sm;
> +	int first = 1;
> +
> +	list_for_each_entry(sm, &info->sym_mask.masks, list) {
> +		mask = sm->val;
> +
> +		if (first && !mask && !val) {
> +			trace_seq_putmem(s, event->print_text + sm->start,
> +					 sm->len);
> +			return;
> +		}
> +
> +		if (mask && (mask & val) == mask) {
> +			if (first)
> +				first = 0;
> +			else if (info->sym_mask.len)
> +				trace_seq_putmem(s, event->print_text +
> +						 info->sym_mask.delim,
> +						 info->sym_mask.len);
> +			val &= ~mask;
> +
> +			trace_seq_putmem(s, event->print_text + sm->start,
> +					 sm->len);
> +		}
> +	}
> +
> +	if (val)
> +		trace_seq_printf(s, "(%llx)", val);
> +
> +	return;
> +}
> +
> +static void
> +trace_read_symbol(struct trace_seq *s, unsigned long long val,
> +		  struct print_info *info, struct ftrace_event_call *event)
> +{
> +	unsigned long long sym;
> +	struct sym_mask *sm;
> +	int found = 0;
> +
> +	list_for_each_entry(sm, &info->sym_mask.masks, list) {
> +		sym = sm->val;
> +
> +		if (sym == val) {
> +			found = 1;
> +			trace_seq_putmem(s, event->print_text + sm->start,
> +					 sm->len);
> +			break;
> +		}
> +	}
> +
> +	if (!found)
> +		trace_seq_printf(s, "(%llx)", val);
> +
> +}
> +
> +char *
> +ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
> +		   struct trace_entry *entry)
> +{
> +	unsigned long long val, mask;
> +	struct print_info *info;
> +	char *start = s->buffer + s->len;
> +	struct ftrace_event_field *field;
> +	void *p;
> +
> +	list_for_each_entry(info, &event->print_info, list) {
> +
> +		p = entry;
> +
> +		switch (info->type) {
> +		case FIELD_IS_LT:
> +		case FIELD_IS_TEXT:
> +			trace_seq_putmem(s, event->print_text + info->text.start,
> +					 info->text.len);
> +			if (info->type == FIELD_IS_LT)
> +				trace_seq_putc(s, '<');
> +			break;
> +		case FIELD_IS_INT:
> +		case FIELD_IS_HEX:
> +		case FIELD_IS_PTR:
> +			field = info->data.field;
> +			goto skip_if;
> +
> +		case FIELD_IS_IF:
> +			field = info->cond.field;
> + skip_if:
> +			p += field->offset;
> +
> +			switch (field->size) {
> +			case 1:
> +				val = *(char *)p;
> +				mask =  0xffULL;
> +				break;
> +			case 2:
> +				val = *(short *)p;
> +				mask =  0xffffULL;
> +				break;
> +			case 4:
> +				val = *(int *)p;
> +				mask =  0xffffffffULL;
> +				break;
> +			case 8:
> +				val = *(long long*)p;
> +				mask = 0;
> +				break;
> +
> +			default:
> +				trace_seq_printf(s, "<error: bad field size %d?>\n",
> +						 field->size);
> +				return start;
> +			}
> +
> +			if (info->type == FIELD_IS_IF) {
> +				if (val)
> +					trace_seq_putmem(s, event->print_text +
> +							 info->cond.true_text,
> +							 info->cond.true_len);
> +				else
> +					trace_seq_putmem(s, event->print_text +
> +							 info->cond.false_text,
> +							 info->cond.false_len);
> +			} else if (info->type == FIELD_IS_INT)
> +				trace_seq_printf(s, "%lld", val);
> +			else {
> +				/* hex should only print the size specified */
> +				if (mask)
> +					val &= mask;
> +
> +				trace_seq_printf(s, "%llx", val);
> +			}
> +
> +			break;
> +
> +		case FIELD_IS_STRING:
> +			p += info->data.field->offset;
> +			/* indexes are expected to be unsigned short */
> +			WARN_ON(info->data.field->size != 2);
> +			p = (void *)entry + *(unsigned short *)p;
> +			trace_seq_puts(s, p);
> +			break;
> +
> +		case FIELD_IS_STRARRAY:
> +			p += info->data.field->offset;
> +			trace_seq_puts(s, p);
> +			break;
> +
> +		case FIELD_IS_MASK:
> +		case FIELD_IS_SYMBOL:
> +
> +			p += info->sym_mask.field->offset;
> +
> +			switch (info->sym_mask.field->size) {
> +			case 1:
> +				val = *(unsigned char *)p;
> +				break;
> +			case 2:
> +				val = *(unsigned short *)p;
> +				break;
> +			case 4:
> +				val = *(unsigned int *)p;
> +				break;
> +			case 8:
> +				val = *(unsigned long long*)p;
> +				break;
> +
> +			default:
> +				trace_seq_printf(s, "<error: bad field size %d?>\n",
> +						 info->sym_mask.field->size);
> +				return start;
> +			}
> +
> +			if (info->type == FIELD_IS_MASK)
> +				trace_read_mask(s, val, info, event);
> +			else
> +				trace_read_symbol(s, val, info, event);
> +			break;
> +		default:
> +			trace_seq_printf(s, "UNKNOWN TYPE %d\n", info->type);
> +		}
> +	}
> +
> +	trace_seq_putc(s, 0);
> +
> +	return start;
> +}
> +EXPORT_SYMBOL_GPL(ftrace_read_binary);
> -- 
> 1.6.3.1
> 
> -- 

