Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbZDPBNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbZDPBNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZDPBMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:12:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65086 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbZDPBMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:12:38 -0400
Message-ID: <49E68635.8050404@cn.fujitsu.com>
Date: Thu, 16 Apr 2009 09:13:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 1/2] tracing/events: provide string with undefined
 size support
References: <1239838050-8567-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1239838050-8567-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Impact: less memory usage for tracing
> 
> This patch provides the support for dynamic size strings on
> event tracing.
> 

blktrace TRACE_EVENTs need this too. :)

> The key concept is to use a structure with an ending char array field of
> undefined size and use such ability to allocate the minimal size on the ring
> buffer to make the entry fit inside as opposite to a fixed length strings with
> upper bound.
> 
> This patch provides two new macros:
> 
> -__ending_string(name)
> 
> This one declares the string to the structure inside TP_STRUCT__entry.
> Only the name is needed.
> Two constraints: only one __ending_string() per TRACE_EVENT can be added and
> it must be the last field to be declared. Hence the __ending prefix.
> 
> - open_string_assign(call, dst, src)
> 
> This one does the copy inside TP__fast_assign() of the source
> string to the destination. The name of the tracepoint (call) must be provided
> for now. Hopefully I will find a solution to avoid it later.
> 
> Two constraint: can be used only once and always on the beginning because
> it needs to manage the ring buffer reservation by itself. Hence the open prefix.
> 
> How does it works?
> 

I'll let you know if I meet any problem when using this in blktrace
TRACE_EVENTs.

> A new has_ending_string field has been added to struct ftrace_event_call and is
> false by default.
> Once a TRACE_EVENT uses an __ending_string field, it is set to 1.
> 
> Until now, the ring buffer reservation was done in ftrace_raw_event_##call().
> It is still the case if we don't have an __ending_string() field. If we have one,
> open_string_assign() will manage it itself to allocate the appropriate size,
> depending of the size of the string to be copied for each trace.
> 
> The choice between the usual static allocation and the new dynamic one depends
> on the "has_ending_string" value.
> 
> It also support filtering because these strings behave essentially
> like usual fixed length string.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/linux/ftrace_event.h |    1 +
>  include/trace/ftrace.h       |   62 ++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 55 insertions(+), 8 deletions(-)

...

> +/*
> + * If we have and ending undefined string size, then the size of
> + * the entry is dynamic. In such case we override the ring buffer
> + * reservation to manage it ourselves with our dynamic string size.
> + */
> +#undef open_string_assign
> +#define open_string_assign(call, dst, src)				       \
> +	event = trace_current_buffer_lock_reserve(			       \
> +			event_##call.id,				       \
> +			sizeof(struct ftrace_raw_##call) + strlen(src) + 1,    \
> +			irq_flags, pc);					       \
> +	if (!event)							       \
> +		return;							       \
> +	entry	= ring_buffer_event_data(event);			       \

small nits, below is better since we have only one assignment:

	entry = ring_buffer_event_data(event);

> +	strcpy(entry->dst, src);
> +
>  #undef TRACE_EVENT
>  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
>  _TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
> @@ -418,20 +461,23 @@ static struct ftrace_event_call event_##call;				\
>  static void ftrace_raw_event_##call(proto)				\
>  {									\
>  	struct ftrace_event_call *call = &event_##call;			\
> -	struct ring_buffer_event *event;				\
> -	struct ftrace_raw_##call *entry;				\
> +	struct ring_buffer_event *event = NULL;				\
> +	struct ftrace_raw_##call *entry = NULL;				\
>  	unsigned long irq_flags;					\
>  	int pc;								\
>  									\
>  	local_save_flags(irq_flags);					\
>  	pc = preempt_count();						\
>  									\
> -	event = trace_current_buffer_lock_reserve(event_##call.id,	\
> -				  sizeof(struct ftrace_raw_##call),	\
> -				  irq_flags, pc);			\
> -	if (!event)							\
> -		return;							\
> -	entry	= ring_buffer_event_data(event);			\
> +	if (!call->has_ending_string) {					\
> +		event = trace_current_buffer_lock_reserve(		\
> +				event_##call.id,			\
> +				sizeof(struct ftrace_raw_##call),	\
> +				irq_flags, pc);				\
> +		if (!event)						\
> +			return;						\
> +		entry	= ring_buffer_event_data(event);		\

ditoo

> +	}								\
>  									\
>  	assign;								\
>  									\

