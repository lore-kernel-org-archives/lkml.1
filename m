Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbZIJBni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbZIJBni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZIJBni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:43:38 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:53572 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZIJBnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oie8mPQImBE3Hbj7cp6wftbhdtqfOlgdNxZxFXDQmDug6tKa8hCFRidXi7CQcdcYwp
         0uERGvAvy+lEEZ26w4643J0C7KG3yJN6N3AyD23jhL8sa62h5vSTaEo4miKtEPmOsfU+
         SPyrhXGjcftknWg4UtRaP8yLzqNmcdg7a1xf8=
Date: Thu, 10 Sep 2009 03:43:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] tracing: Clean up trace.h
Message-ID: <20090910014334.GA8450@nowhere>
References: <4AA8579B.4020706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA8579B.4020706@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 09:34:19AM +0800, Li Zefan wrote:
> - remove some dead code
> - remove @stats from struct tracer
> - move DEFINE_COMPARISON_PRED() and DEFINE_EQUALITY_PRED()
>   to kernel/trace/trace_events_filter.c
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---


Nice :-)

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>



> 
> I've split hw_breakpoint code out.
> 
> ---
>  kernel/trace/trace.h               |   86 +++++-------------------------------
>  kernel/trace/trace_events_filter.c |   41 +++++++++++++++++
>  2 files changed, 52 insertions(+), 75 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index ea7e0bc..76ed0db 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -125,14 +125,6 @@ struct print_entry {
>  	char			buf[];
>  };
>  
> -#define TRACE_OLD_SIZE		88
> -
> -struct trace_field_cont {
> -	unsigned char		type;
> -	/* Temporary till we get rid of this completely */
> -	char			buf[TRACE_OLD_SIZE - 1];
> -};
> -
>  struct trace_mmiotrace_rw {
>  	struct trace_entry	ent;
>  	struct mmiotrace_rw	rw;
> @@ -182,20 +174,20 @@ enum kmemtrace_type_id {
>  
>  struct kmemtrace_alloc_entry {
>  	struct trace_entry	ent;
> -	enum kmemtrace_type_id type_id;
> -	unsigned long call_site;
> -	const void *ptr;
> -	size_t bytes_req;
> -	size_t bytes_alloc;
> -	gfp_t gfp_flags;
> -	int node;
> +	enum kmemtrace_type_id	type_id;
> +	unsigned long		call_site;
> +	const void		*ptr;
> +	size_t			bytes_req;
> +	size_t			bytes_alloc;
> +	gfp_t			gfp_flags;
> +	int			node;
>  };
>  
>  struct kmemtrace_free_entry {
>  	struct trace_entry	ent;
> -	enum kmemtrace_type_id type_id;
> -	unsigned long call_site;
> -	const void *ptr;
> +	enum kmemtrace_type_id	type_id;
> +	unsigned long		call_site;
> +	const void		*ptr;
>  };
>  
>  struct syscall_trace_enter {
> @@ -226,7 +218,7 @@ struct ksym_trace_entry {
>   * states when a trace occurs. These are:
>   *  IRQS_OFF		- interrupts were disabled
>   *  IRQS_NOSUPPORT	- arch does not support irqs_disabled_flags
> - *  NEED_RESCED		- reschedule is requested
> + *  NEED_RESCHED	- reschedule is requested
>   *  HARDIRQ		- inside an interrupt handler
>   *  SOFTIRQ		- inside a softirq handler
>   */
> @@ -406,7 +398,6 @@ struct tracer {
>  	struct tracer		*next;
>  	int			print_max;
>  	struct tracer_flags	*flags;
> -	struct tracer_stat	*stats;
>  };
>  
>  
> @@ -525,20 +516,6 @@ static inline void __trace_stack(struct trace_array *tr, unsigned long flags,
>  
>  extern cycle_t ftrace_now(int cpu);
>  
> -#ifdef CONFIG_CONTEXT_SWITCH_TRACER
> -typedef void
> -(*tracer_switch_func_t)(void *private,
> -			void *__rq,
> -			struct task_struct *prev,
> -			struct task_struct *next);
> -
> -struct tracer_switch_ops {
> -	tracer_switch_func_t		func;
> -	void				*private;
> -	struct tracer_switch_ops	*next;
> -};
> -#endif /* CONFIG_CONTEXT_SWITCH_TRACER */
> -
>  extern void trace_find_cmdline(int pid, char comm[]);
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
> @@ -841,47 +818,6 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
>  	return 0;
>  }
>  
> -#define DEFINE_COMPARISON_PRED(type)					\
> -static int filter_pred_##type(struct filter_pred *pred, void *event,	\
> -			      int val1, int val2)			\
> -{									\
> -	type *addr = (type *)(event + pred->offset);			\
> -	type val = (type)pred->val;					\
> -	int match = 0;							\
> -									\
> -	switch (pred->op) {						\
> -	case OP_LT:							\
> -		match = (*addr < val);					\
> -		break;							\
> -	case OP_LE:							\
> -		match = (*addr <= val);					\
> -		break;							\
> -	case OP_GT:							\
> -		match = (*addr > val);					\
> -		break;							\
> -	case OP_GE:							\
> -		match = (*addr >= val);					\
> -		break;							\
> -	default:							\
> -		break;							\
> -	}								\
> -									\
> -	return match;							\
> -}
> -
> -#define DEFINE_EQUALITY_PRED(size)					\
> -static int filter_pred_##size(struct filter_pred *pred, void *event,	\
> -			      int val1, int val2)			\
> -{									\
> -	u##size *addr = (u##size *)(event + pred->offset);		\
> -	u##size val = (u##size)pred->val;				\
> -	int match;							\
> -									\
> -	match = (val == *addr) ^ pred->not;				\
> -									\
> -	return match;							\
> -}
> -
>  extern struct mutex event_mutex;
>  extern struct list_head ftrace_events;
>  
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 93660fb..2324578 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -121,6 +121,47 @@ struct filter_parse_state {
>  	} operand;
>  };
>  
> +#define DEFINE_COMPARISON_PRED(type)					\
> +static int filter_pred_##type(struct filter_pred *pred, void *event,	\
> +			      int val1, int val2)			\
> +{									\
> +	type *addr = (type *)(event + pred->offset);			\
> +	type val = (type)pred->val;					\
> +	int match = 0;							\
> +									\
> +	switch (pred->op) {						\
> +	case OP_LT:							\
> +		match = (*addr < val);					\
> +		break;							\
> +	case OP_LE:							\
> +		match = (*addr <= val);					\
> +		break;							\
> +	case OP_GT:							\
> +		match = (*addr > val);					\
> +		break;							\
> +	case OP_GE:							\
> +		match = (*addr >= val);					\
> +		break;							\
> +	default:							\
> +		break;							\
> +	}								\
> +									\
> +	return match;							\
> +}
> +
> +#define DEFINE_EQUALITY_PRED(size)					\
> +static int filter_pred_##size(struct filter_pred *pred, void *event,	\
> +			      int val1, int val2)			\
> +{									\
> +	u##size *addr = (u##size *)(event + pred->offset);		\
> +	u##size val = (u##size)pred->val;				\
> +	int match;							\
> +									\
> +	match = (val == *addr) ^ pred->not;				\
> +									\
> +	return match;							\
> +}
> +
>  DEFINE_COMPARISON_PRED(s64);
>  DEFINE_COMPARISON_PRED(u64);
>  DEFINE_COMPARISON_PRED(s32);
> -- 
> 1.6.3
> 

