Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbZDQKka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbZDQKka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759247AbZDQKj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:39:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40266 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760177AbZDQKj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:39:57 -0400
Date: Fri, 17 Apr 2009 06:39:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] tracing/events: provide string with undefined
 size  support
In-Reply-To: <alpine.DEB.2.00.0904170552160.20429@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0904170613370.20429@gandalf.stny.rr.com>
References: <1239912047-6282-1-git-send-email-fweisbec@gmail.com>  <1239912812.23397.3432.camel@laptop>  <c62985530904161328g299e8a67q2012a577e8a2f1a4@mail.gmail.com>  <1239949360.23397.4065.camel@laptop>  <c62985530904170159j6f3b5477g411a028e69fd93f6@mail.gmail.com>
 <1239960548.23397.4282.camel@laptop> <alpine.DEB.2.00.0904170552160.20429@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009, Steven Rostedt wrote:
> 
> But that said, one could still do what you are suggesting. The "__ending" 
> wart still needs to be there, since it must happen at the end of the 
> struct.
> 
> 
>         TP_STRUCT__entry(
>                 __field(int, str2loc)
>                 __field(int, str3loc)
> 		__string(str1)
> 		__string(str2)
>                 __ending_string(data, str3)
>         ),
>         TP_fast_assign(
> 		__entry->str2loc = strlen(str1);
> 		__entry->str3loc = strlen(str2) + __entry->str2loc;
>                 strcpy(__entry->data, str1);
> 		strcpy(__entry->data + __entry->str2loc, str2)
> 		strcpy(__entry->data + __entry->str3loc, str3)
>         ),
>         TP_printk("str1:%s str2:%s str3:%s\n",
> 		__entry->data,
> 		__entry->data + __entry->str2loc,
> 		__entry->date + __entry->str3loc)
> 
> 
> For this to work, we need to just add a define for the __string macro for 
> the reservation:
> 
> #define __string(x)  __str_size_ += strlen(x) + 1;

Hmm, thinking about this more, we could do...


Make all structs end with:

	char __str_data__[0];


then we could just have __string(dec, param), ie.


	__string(str1, param_str1)
	__string(str2, param_str2)
	__string(srt3, param_str3)

But instead of defining string as a character, it would just be an index 
into the __str_data_.

#define __string(dec, param)	int dec;


We can break up the TRACE_EVENT macro again to create the declaration:

#undef everything and make empty macros of all we don't use

#define __string(dec, str)	int __str_loc_##dec;

#define TRACE_EVENT(...)	\
static void ftrace_raw_event_##call(proto)	\
{	\
	struct ring_buffer_event *event;	\
	struct ftrace_raw_##call *entry;	\
	unsigned long flags;			\
	int pc;					\
	int _str_size_ = 0;			\
						\
	tstruct

#include the file

#undef __string
#define __string(str, param)	__str_loc_##str = _str_size_; \
				_str_size_ += strlen(param) + 1;

#define TRACE_EVENT(...)
	tstruct

#include the file again

Then we can do the assignment for the user:

#undef everything again
#define the usual suspects

#define __string(str, param)	__entry->str = __str_loc_##str;

#define TRACE_EVENT(...)
        local_save_flags(irq_flags);                                    \
        pc = preempt_count();                                           \
                                                                        \
        event = trace_current_buffer_lock_reserve(event_##call.id,      \
                                  sizeof(struct ftrace_raw_##call),     \
                                  irq_flags, pc);                       \
        if (!event)                                                     \
                return;                                                 \
        entry   = ring_buffer_event_data(event);                        \
                                                                        \
	tstruct								\
        assign;                                                         \

#include the file again

#undef everything again,

#define __string(str, param)	strcpy(__entry->__str_data__ + 		\
				__str_loc_##str, param);

#define TRACE_EVENT(...) \
	tstruct		\
	trace_current_buffer_unlock_commit(event, irq_flags, pc);	\
}


The tstruct would do the assign for the user.

Then this is what a TRACE_EVENT would look like:

TRACE_EVENT(my_event,

	TP_PROTO(char *str1, char *str2, char *str3),

	TP_ARGS(str1, str2, str3),

	TP_STRUCT__entry(
		__string(str1, str1)
		__string(str2, str2)
		__string(str3, str3)
	),

	TP_fast_assign(
		/* empty, strings are automated */
	),

	TP_printk("str1:%s str2:%s str3:%s\n",
		__entry->__str_data__ + __entry->str1,
		__entry->__str_data__ + __entry->str2,
		__entry->__str_data__ + __entry->str3)
);


/me feels more evil than ever ;-)

-- Steve


