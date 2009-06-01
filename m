Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbZFANMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbZFANMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 09:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbZFANMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 09:12:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58699 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbZFANMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 09:12:12 -0400
Date: Mon, 1 Jun 2009 09:12:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/events: introduce __dynamic_array()
In-Reply-To: <4A2384D2.3080403@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0906010912000.14994@gandalf.stny.rr.com>
References: <4A2384B1.90100@cn.fujitsu.com> <4A2384D2.3080403@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 1 Jun 2009, Li Zefan wrote:

> __string() is limited:
> 
>   - it's a char array, but we may want to define array with other types
>   - a source string should be available, but we may just know the string size
> 
> We introduce __dynamic_array() to break those limitations, and __string()
> becomes a wrapper of it. As a side effect, now __get_str() can be used
> in TP_fast_assign but not only TP_print.
> 
> Take XFS for example, we have the string length in the dirent, but the
> string itself is not NULL-terminated, so __dynamic_array() can be used:
> 
> TRACE_EVENT(xfs_dir2,
> 	TP_PROTO(struct xfs_da_args *args),
> 	TP_ARGS(args),
> 
> 	TP_STRUCT__entry(
> 		__field(int, namelen)
> 		__dynamic_array(char, name, args->namelen + 1)
> 		...
> 	),
> 
> 	TP_fast_assign(
> 		char *name = __get_str(name);
> 
> 		if (args->namelen)
> 			memcpy(name, args->name, args->namelen);
> 		name[args->namelen] = '\0';
> 
> 		__entry->namelen = args->namelen;
> 	),
> 
> 	TP_printk("name %.*s namelen %d",
> 		  __entry->namelen ? __get_str(name) : NULL
> 		  __entry->namelen)
> );
> 
> [ Impact: allow defining dynamic size arrays ]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks Li,

I'll pull this in.

-- Steve

> ---
>  include/trace/ftrace.h             |  122 ++++++++++++++++++++++++++----------
>  kernel/trace/trace_events_filter.c |    6 +-
>  2 files changed, 91 insertions(+), 37 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index ee92682..b5478da 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -18,14 +18,17 @@
>  
>  #include <linux/ftrace_event.h>
>  
> +#undef __field
> +#define __field(type, item)		type	item;
> +
>  #undef __array
>  #define __array(type, item, len)	type	item[len];
>  
> -#undef __field
> -#define __field(type, item)		type	item;
> +#undef __dynamic_array
> +#define __dynamic_array(type, item, len) unsigned short __data_loc_##item;
>  
>  #undef __string
> -#define __string(item, src)		unsigned short	__str_loc_##item;
> +#define __string(item, src) __dynamic_array(char, item, -1)
>  
>  #undef TP_STRUCT__entry
>  #define TP_STRUCT__entry(args...) args
> @@ -35,7 +38,7 @@
>  	struct ftrace_raw_##name {				\
>  		struct trace_entry	ent;			\
>  		tstruct						\
> -		char			__str_data[0];		\
> +		char			__data[0];		\
>  	};							\
>  	static struct ftrace_event_call event_##name
>  
> @@ -47,30 +50,31 @@
>   *
>   * Include the following:
>   *
> - * struct ftrace_str_offsets_<call> {
> - *	int				<str1>;
> - *	int				<str2>;
> + * struct ftrace_data_offsets_<call> {
> + *	int				<item1>;
> + *	int				<item2>;
>   *	[...]
>   * };
>   *
> - * The __string() macro will create each int <str>, this is to
> - * keep the offset of each string from the beggining of the event
> - * once we perform the strlen() of the src strings.
> - *
> + * The __dynamic_array() macro will create each int <item>, this is
> + * to keep the offset of each array from the beginning of the event.
>   */
>  
> +#undef __field
> +#define __field(type, item);
> +
>  #undef __array
>  #define __array(type, item, len)
>  
> -#undef __field
> -#define __field(type, item);
> +#undef __dynamic_array
> +#define __dynamic_array(type, item, len)	int item;
>  
>  #undef __string
> -#define __string(item, src)	int item;
> +#define __string(item, src) __dynamic_array(char, item, -1)
>  
>  #undef TRACE_EVENT
>  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> -	struct ftrace_str_offsets_##call {				\
> +	struct ftrace_data_offsets_##call {				\
>  		tstruct;						\
>  	};
>  
> @@ -119,8 +123,12 @@
>  #undef TP_printk
>  #define TP_printk(fmt, args...) fmt "\n", args
>  
> +#undef __get_dynamic_array
> +#define __get_dynamic_array(field)	\
> +		((void *)__entry + __entry->__data_loc_##field)
> +
>  #undef __get_str
> -#define __get_str(field)	((char *)__entry + __entry->__str_loc_##field)
> +#define __get_str(field) (char *)__get_dynamic_array(field)
>  
>  #undef __print_flags
>  #define __print_flags(flag, delim, flag_array...)			\
> @@ -207,16 +215,19 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
>  	if (!ret)							\
>  		return 0;
>  
> -#undef __string
> -#define __string(item, src)						       \
> -	ret = trace_seq_printf(s, "\tfield:__str_loc " #item ";\t"	       \
> +#undef __dynamic_array
> +#define __dynamic_array(type, item, len)				       \
> +	ret = trace_seq_printf(s, "\tfield:__data_loc " #item ";\t"	       \
>  			       "offset:%u;\tsize:%u;\n",		       \
>  			       (unsigned int)offsetof(typeof(field),	       \
> -					__str_loc_##item),		       \
> -			       (unsigned int)sizeof(field.__str_loc_##item));  \
> +					__data_loc_##item),		       \
> +			       (unsigned int)sizeof(field.__data_loc_##item)); \
>  	if (!ret)							       \
>  		return 0;
>  
> +#undef __string
> +#define __string(item, src) __dynamic_array(char, item, -1)
> +
>  #undef __entry
>  #define __entry REC
>  
> @@ -260,11 +271,14 @@ ftrace_format_##call(struct trace_seq *s)				\
>  	if (ret)							\
>  		return ret;
>  
> +#undef __dynamic_array
> +#define __dynamic_array(type, item, len)				       \
> +	ret = trace_define_field(event_call, "__data_loc" "[" #type "]", #item,\
> +				offsetof(typeof(field), __data_loc_##item),    \
> +				 sizeof(field.__data_loc_##item), 0);
> +
>  #undef __string
> -#define __string(item, src)						       \
> -	ret = trace_define_field(event_call, "__str_loc", #item,	       \
> -				offsetof(typeof(field), __str_loc_##item),     \
> -				 sizeof(field.__str_loc_##item), 0);
> +#define __string(item, src) __dynamic_array(char, item, -1)
>  
>  #undef TRACE_EVENT
>  #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
> @@ -289,6 +303,43 @@ ftrace_define_fields_##call(void)					\
>  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>  
>  /*
> + * remember the offset of each array from the beginning of the event.
> + */
> +
> +#undef __entry
> +#define __entry entry
> +
> +#undef __field
> +#define __field(type, item)
> +
> +#undef __array
> +#define __array(type, item, len)
> +
> +#undef __dynamic_array
> +#define __dynamic_array(type, item, len)				\
> +	__data_offsets->item = __data_size +				\
> +			       offsetof(typeof(*entry), __data);	\
> +	__data_size += (len) * sizeof(type);
> +
> +#undef __string
> +#define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)       \
> +
> +#undef TRACE_EVENT
> +#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> +static inline int ftrace_get_offsets_##call(				\
> +	struct ftrace_data_offsets_##call *__data_offsets, proto)       \
> +{									\
> +	int __data_size = 0;						\
> +	struct ftrace_raw_##call __maybe_unused *entry;			\
> +									\
> +	tstruct;							\
> +									\
> +	return __data_size;						\
> +}
> +
> +#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
> +
> +/*
>   * Stage 4 of the trace events.
>   *
>   * Override the macros in <trace/trace_events.h> to include the following:
> @@ -432,15 +483,15 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
>  #undef __array
>  #define __array(type, item, len)
>  
> +#undef __dynamic_array
> +#define __dynamic_array(type, item, len)				\
> +	__entry->__data_loc_##item = __data_offsets.item;
> +
>  #undef __string
> -#define __string(item, src)						\
> -	__str_offsets.item = __str_size +				\
> -			     offsetof(typeof(*entry), __str_data);	\
> -	__str_size += strlen(src) + 1;
> +#define __string(item, src) __dynamic_array(char, item, -1)       	\
>  
>  #undef __assign_str
>  #define __assign_str(dst, src)						\
> -	__entry->__str_loc_##dst = __str_offsets.dst;			\
>  	strcpy(__get_str(dst), src);
>  
>  #undef TRACE_EVENT
> @@ -451,26 +502,29 @@ static struct ftrace_event_call event_##call;				\
>  									\
>  static void ftrace_raw_event_##call(proto)				\
>  {									\
> -	struct ftrace_str_offsets_##call __maybe_unused __str_offsets;	\
> +	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
>  	struct ftrace_event_call *event_call = &event_##call;		\
>  	struct ring_buffer_event *event;				\
>  	struct ftrace_raw_##call *entry;				\
>  	unsigned long irq_flags;					\
> -	int __str_size = 0;						\
> +	int __data_size;						\
>  	int pc;								\
>  									\
>  	local_save_flags(irq_flags);					\
>  	pc = preempt_count();						\
>  									\
> -	tstruct;							\
> +	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
>  									\
>  	event = trace_current_buffer_lock_reserve(event_##call.id,	\
> -				 sizeof(struct ftrace_raw_##call) + __str_size,\
> +				 sizeof(*entry) + __data_size,		\
>  				 irq_flags, pc);			\
>  	if (!event)							\
>  		return;							\
>  	entry	= ring_buffer_event_data(event);			\
>  									\
> +									\
> +	tstruct								\
> +									\
>  	{ assign; }							\
>  									\
>  	if (!filter_current_check_discard(event_call, entry, event))	\
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 35d10df..ffd461a 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -478,12 +478,12 @@ enum {
>  
>  static int is_string_field(const char *type)
>  {
> +	if (strstr(type, "__data_loc") && strstr(type, "char"))
> +		return FILTER_DYN_STRING;
> +
>  	if (strchr(type, '[') && strstr(type, "char"))
>  		return FILTER_STATIC_STRING;
>  
> -	if (!strcmp(type, "__str_loc"))
> -		return FILTER_DYN_STRING;
> -
>  	return 0;
>  }
>  
> -- 
> 1.5.4.rc3
> 
> 
> 
