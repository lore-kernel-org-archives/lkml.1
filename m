Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZDVJLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZDVJLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZDVJKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:10:51 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:62362 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbZDVJKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:10:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AcsW+SCae3ZJsADEqusW2lStpA4MjcHfus5Ssn65+onRjMWNIG4T+cmr9KLOiPIhjX
         UU+QmlrIIGI7E+xa1k2PkGTZ/UkhpWz+B0+GWj6parWy3z6BRIZG48ROqL1FdstVhyV7
         D+1ytEcTbUzz8BPwxZotyOg/sU/ygcdEOBCvA=
Date: Wed, 22 Apr 2009 11:10:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/events: make struct trace_entry->type to be
	int type
Message-ID: <20090422091045.GA6031@nowhere>
References: <49EEDB0E.5070207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EEDB0E.5070207@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 04:53:34PM +0800, Li Zefan wrote:
> struct trace_entry->type is unsigned char, while trace event's id is
> int type, thus for a event with id >= 256, it's entry->type is cast
> to (id % 256), and then we can't see the trace output of this event.
> 
>  # insmod trace-events-sample.ko
>  # echo foo_bar > /mnt/tracing/set_event
>  # cat /debug/tracing/events/trace-events-sample/foo_bar/id
>  256
>  # cat /mnt/tracing/trace_pipe
>            <...>-3548  [001]   215.091142: Unknown type 0
>            <...>-3548  [001]   216.089207: Unknown type 0
>            <...>-3548  [001]   217.087271: Unknown type 0
>            <...>-3548  [001]   218.085332: Unknown type 0
> 
> [ Impact: fix output for trace events with id >= 256 ]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Indeed, now with the trace_events, we are approaching this possible
overflow and the type is indeed an int:

struct trace_event *ftrace_find_event(int type)

Curious: does it only happen with the trace-event-sample?
I doubt we already reached this threshold of event number.
But anyway, it's a good thing.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  include/linux/ftrace_event.h |    4 ++--
>  include/trace/ftrace.h       |    2 +-
>  kernel/trace/trace.c         |    4 ++--
>  kernel/trace/trace.h         |    2 +-
>  kernel/trace/trace_events.c  |    2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 75f3ac0..2a4a407 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -16,7 +16,7 @@ struct dentry;
>   *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
>   */
>  struct trace_entry {
> -	unsigned char		type;
> +	int			type;
>  	unsigned char		flags;
>  	unsigned char		preempt_count;
>  	int			pid;
> @@ -73,7 +73,7 @@ enum print_line_t {
>  
>  
>  struct ring_buffer_event *
> -trace_current_buffer_lock_reserve(unsigned char type, unsigned long len,
> +trace_current_buffer_lock_reserve(int type, unsigned long len,
>  				  unsigned long flags, int pc);
>  void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
>  					unsigned long flags, int pc);
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 39a3351..15ef08d 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -198,7 +198,7 @@ ftrace_define_fields_##call(void)					\
>  	struct ftrace_event_call *event_call = &event_##call;		\
>  	int ret;							\
>  									\
> -	__common_field(unsigned char, type);				\
> +	__common_field(int, type);					\
>  	__common_field(unsigned char, flags);				\
>  	__common_field(unsigned char, preempt_count);			\
>  	__common_field(int, pid);					\
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index b9a3adc..b6183bc 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -838,7 +838,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
>  }
>  
>  struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
> -						    unsigned char type,
> +						    int type,
>  						    unsigned long len,
>  						    unsigned long flags, int pc)
>  {
> @@ -881,7 +881,7 @@ void trace_buffer_unlock_commit(struct trace_array *tr,
>  }
>  
>  struct ring_buffer_event *
> -trace_current_buffer_lock_reserve(unsigned char type, unsigned long len,
> +trace_current_buffer_lock_reserve(int type, unsigned long len,
>  				  unsigned long flags, int pc)
>  {
>  	return trace_buffer_lock_reserve(&global_trace,
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 8750e83..3e5c664 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -422,7 +422,7 @@ void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
>  struct ring_buffer_event;
>  
>  struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
> -						    unsigned char type,
> +						    int type,
>  						    unsigned long len,
>  						    unsigned long flags,
>  						    int pc);
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 9631caf..86fa720 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -398,7 +398,7 @@ static int trace_write_header(struct trace_seq *s)
>  				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
>  				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
>  				"\n",
> -				FIELD(unsigned char, type),
> +				FIELD(int, type),
>  				FIELD(unsigned char, flags),
>  				FIELD(unsigned char, preempt_count),
>  				FIELD(int, pid),
> -- 
> 1.5.4.rc3
> 

