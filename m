Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZGQUeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZGQUeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZGQUeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:34:31 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:58965 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZGQUe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SsIL8WgyyWmSIEaHuTmgYuvcEmwhLDqrsVYspTs6iSlrHWE1Wubq3gQVJiUQVmjHLV
         jpxa+YPtdWRFChvqYA2ik1IHdSbtxurS+a3YqHzfxO1YhQSfckkHKqugo3QX/eu4PqNg
         L+vs3Ka+0lchMj6Lt7OrP+gq6DnUJSXzcijRo=
Date: Fri, 17 Jul 2009 16:34:24 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: Improve subsystem filter
Message-ID: <20090717203422.GA7136@nowhere>
References: <4A5EECDC.4080500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5EECDC.4080500@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 05:03:24PM +0800, Li Zefan wrote:
> Currently a subsystem filter should be applicable to all events
> under the subsystem, and if it failed, all the event filters
> will be cleared. Those behaviors make subsys filter much less
> useful:
> 
>   # echo 'vec == 1' > irq/softirq_entry/filter
>   # echo 'irq == 5' > irq/filter
>   bash: echo: write error: Invalid argument
>   # cat irq/softirq_entry/filter
>   none
> 
> I'd expect it set the filter for irq_handler_entry/exit, and
> not touch softirq_entry/exit.
> 
> The basic idea is, try to see if the filter can be applied
> to which events, and then just apply to the those events:
> 
>   # echo 'vec == 1' > softirq_entry/filter
>   # echo 'irq == 5' > filter
>   # cat irq_handler_entry/filter
>   irq == 5
>   # cat softirq_entry/filter
>   vec == 1
> 
> Inspied-by: Steven Rostedt <srostedt@redhat.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/ftrace_event.h       |    4 +-
>  kernel/trace/trace.h               |    3 +-
>  kernel/trace/trace_events_filter.c |  123 +++++++++++++++++++++++------------
>  3 files changed, 86 insertions(+), 44 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 5c093ff..26d3673 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -101,6 +101,8 @@ void trace_current_buffer_discard_commit(struct ring_buffer_event *event);
>  
>  void tracing_record_cmdline(struct task_struct *tsk);
>  
> +struct event_filter;
> +
>  struct ftrace_event_call {
>  	struct list_head	list;
>  	char			*name;
> @@ -116,7 +118,7 @@ struct ftrace_event_call {
>  	int			(*define_fields)(void);
>  	struct list_head	fields;
>  	int			filter_active;
> -	void			*filter;
> +	struct event_filter	*filter;
>  	void			*mod;
>  
>  #ifdef CONFIG_EVENT_PROFILE
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 06886a0..3a87d46 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -768,13 +768,14 @@ struct event_filter {
>  	int			n_preds;
>  	struct filter_pred	**preds;
>  	char			*filter_string;
> +	bool			no_reset;
>  };
>  
>  struct event_subsystem {
>  	struct list_head	list;
>  	const char		*name;
>  	struct dentry		*entry;
> -	void			*filter;
> +	struct event_filter	*filter;
>  	int			nr_events;
>  };
>  
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 1c80ef7..0f510c2 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -420,7 +420,13 @@ oom:
>  }
>  EXPORT_SYMBOL_GPL(init_preds);
>  
> -static void filter_free_subsystem_preds(struct event_subsystem *system)
> +/*
> + * flag == 0: remove all events' filter
> + * flag == 1: clear filter->no_reset
> + * flag == 2: remove all preds with no_reset == false
> + */



Once an option overlap the boolean binary range, it's better
to start thinking about an enum type, for better self-explaining code.


> +static void filter_free_subsystem_preds(struct event_subsystem *system,
> +					int flag)
>  {
>  	struct ftrace_event_call *call;
>  
> @@ -428,6 +434,14 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
>  		if (!call->define_fields)
>  			continue;
>  
> +		if (flag == 1) {
> +			call->filter->no_reset = false;
> +			continue;
> +		}
> +
> +		if (flag == 2 && call->filter->no_reset == true)



Or simply if (flag == 2 && call->filter->no_reset)



> +			continue;
> +
>  		if (!strcmp(call->system, system->name)) {
>  			filter_disable_preds(call);
>  			remove_filter_string(call->filter);
> @@ -529,7 +543,8 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
>  
>  static int filter_add_pred(struct filter_parse_state *ps,
>  			   struct ftrace_event_call *call,
> -			   struct filter_pred *pred)
> +			   struct filter_pred *pred,
> +			   bool apply)


bool dry_run sounds perhaps more intuitive for what is happening there.
Because "apply" is surprising in a "add_thing" function, it's like
a field to confirm that we know what what we are doing :)

(May be I start to become a PITA with my naming worries, especially
since I'm usually not good at it in my patches :)

Otherwise, the rest looks good.

Tom, any comment?



>  {
>  	struct ftrace_event_field *field;
>  	filter_pred_fn_t fn;
> @@ -541,10 +556,12 @@ static int filter_add_pred(struct filter_parse_state *ps,
>  
>  	if (pred->op == OP_AND) {
>  		pred->pop_n = 2;
> -		return filter_add_pred_fn(ps, call, pred, filter_pred_and);
> +		fn = filter_pred_and;
> +		goto add_pred_fn;
>  	} else if (pred->op == OP_OR) {
>  		pred->pop_n = 2;
> -		return filter_add_pred_fn(ps, call, pred, filter_pred_or);
> +		fn = filter_pred_or;
> +		goto add_pred_fn;
>  	}
>  
>  	field = find_event_field(call, pred->field_name);
> @@ -567,9 +584,6 @@ static int filter_add_pred(struct filter_parse_state *ps,
>  		else
>  			fn = filter_pred_strloc;
>  		pred->str_len = field->size;
> -		if (pred->op == OP_NE)
> -			pred->not = 1;
> -		return filter_add_pred_fn(ps, call, pred, fn);
>  	} else {
>  		if (field->is_signed)
>  			ret = strict_strtoll(pred->str_val, 0, &val);
> @@ -580,27 +594,33 @@ static int filter_add_pred(struct filter_parse_state *ps,
>  			return -EINVAL;
>  		}
>  		pred->val = val;
> -	}
>  
> -	fn = select_comparison_fn(pred->op, field->size, field->is_signed);
> -	if (!fn) {
> -		parse_error(ps, FILT_ERR_INVALID_OP, 0);
> -		return -EINVAL;
> +		fn = select_comparison_fn(pred->op, field->size,
> +					  field->is_signed);
> +		if (!fn) {
> +			parse_error(ps, FILT_ERR_INVALID_OP, 0);
> +			return -EINVAL;
> +		}
>  	}
>  
>  	if (pred->op == OP_NE)
>  		pred->not = 1;
>  
> -	return filter_add_pred_fn(ps, call, pred, fn);
> +add_pred_fn:
> +	if (apply)
> +		return filter_add_pred_fn(ps, call, pred, fn);
> +	return 0;
>  }
>  
>  static int filter_add_subsystem_pred(struct filter_parse_state *ps,
>  				     struct event_subsystem *system,
>  				     struct filter_pred *pred,
> -				     char *filter_string)
> +				     char *filter_string,
> +				     bool apply)
>  {
>  	struct ftrace_event_call *call;
>  	int err = 0;
> +	bool fail = true;
>  
>  	list_for_each_entry(call, &ftrace_events, list) {
>  
> @@ -610,16 +630,24 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
>  		if (strcmp(call->system, system->name))
>  			continue;
>  
> -		err = filter_add_pred(ps, call, pred);
> -		if (err) {
> -			filter_free_subsystem_preds(system);
> -			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
> -			goto out;
> -		}
> -		replace_filter_string(call->filter, filter_string);
> +		if (call->filter->no_reset)
> +			continue;
> +
> +		err = filter_add_pred(ps, call, pred, apply);
> +		if (err)
> +			call->filter->no_reset = true;
> +		else
> +			fail = false;
> +
> +		if (apply)
> +			replace_filter_string(call->filter, filter_string);
>  	}
> -out:
> -	return err;
> +
> +	if (fail) {
> +		parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
> +		return err;
> +	}
> +	return 0;
>  }
>  
>  static void parse_init(struct filter_parse_state *ps,
> @@ -978,12 +1006,14 @@ static int check_preds(struct filter_parse_state *ps)
>  static int replace_preds(struct event_subsystem *system,
>  			 struct ftrace_event_call *call,
>  			 struct filter_parse_state *ps,
> -			 char *filter_string)
> +			 char *filter_string,
> +			 bool apply)
>  {
>  	char *operand1 = NULL, *operand2 = NULL;
>  	struct filter_pred *pred;
>  	struct postfix_elt *elt;
>  	int err;
> +	int n_preds = 0;
>  
>  	err = check_preds(ps);
>  	if (err)
> @@ -1002,19 +1032,14 @@ static int replace_preds(struct event_subsystem *system,
>  			continue;
>  		}
>  
> +		if (n_preds++ == MAX_FILTER_PRED) {
> +			parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
> +			return -ENOSPC;
> +		}
> +
>  		if (elt->op == OP_AND || elt->op == OP_OR) {
>  			pred = create_logical_pred(elt->op);
> -			if (call)
> -				err = filter_add_pred(ps, call, pred);
> -			else
> -				err = filter_add_subsystem_pred(ps, system,
> -							pred, filter_string);
> -			filter_free_pred(pred);
> -			if (err)
> -				return err;
> -
> -			operand1 = operand2 = NULL;
> -			continue;
> +			goto add_pred;
>  		}
>  
>  		if (!operand1 || !operand2) {
> @@ -1023,11 +1048,12 @@ static int replace_preds(struct event_subsystem *system,
>  		}
>  
>  		pred = create_pred(elt->op, operand1, operand2);
> +add_pred:
>  		if (call)
> -			err = filter_add_pred(ps, call, pred);
> +			err = filter_add_pred(ps, call, pred, true);
>  		else
>  			err = filter_add_subsystem_pred(ps, system, pred,
> -							filter_string);
> +						filter_string, apply);
>  		filter_free_pred(pred);
>  		if (err)
>  			return err;
> @@ -1068,7 +1094,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
>  		goto out;
>  	}
>  
> -	err = replace_preds(NULL, call, ps, filter_string);
> +	err = replace_preds(NULL, call, ps, filter_string, true);
>  	if (err)
>  		append_filter_err(ps, call->filter);
>  
> @@ -1092,7 +1118,7 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
>  	mutex_lock(&event_mutex);
>  
>  	if (!strcmp(strstrip(filter_string), "0")) {
> -		filter_free_subsystem_preds(system);
> +		filter_free_subsystem_preds(system, 0);
>  		remove_filter_string(system->filter);
>  		mutex_unlock(&event_mutex);
>  		return 0;
> @@ -1103,7 +1129,6 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
>  	if (!ps)
>  		goto out_unlock;
>  
> -	filter_free_subsystem_preds(system);
>  	replace_filter_string(system->filter, filter_string);
>  
>  	parse_init(ps, filter_ops, filter_string);
> @@ -1113,9 +1138,23 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
>  		goto out;
>  	}
>  
> -	err = replace_preds(system, NULL, ps, filter_string);
> -	if (err)
> +	filter_free_subsystem_preds(system, 1);
> +
> +	/* try to see the filter can be applied to which events */
> +	err = replace_preds(system, NULL, ps, filter_string, false);
> +	if (err) {
>  		append_filter_err(ps, system->filter);
> +		goto out;
> +	}
> +
> +	filter_free_subsystem_preds(system, 2);
> +
> +	/* really apply the filter to the events */
> +	err = replace_preds(system, NULL, ps, filter_string, true);
> +	if (err) {
> +		append_filter_err(ps, system->filter);
> +		filter_free_subsystem_preds(system, 2);
> +	}
>  
>  out:
>  	filter_opstack_clear(ps);
> -- 
> 1.6.3
> 
> 
> 
> 

