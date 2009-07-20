Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbZGTQI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbZGTQI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZGTQIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:08:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbZGTQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:08:54 -0400
Date: Mon, 20 Jul 2009 12:08:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/filters: Improve subsystem filter
In-Reply-To: <4A63D485.7030703@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907201207390.7595@gandalf.stny.rr.com>
References: <4A63D485.7030703@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Jul 2009, Li Zefan wrote:

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
> Changelog for v2:
> - do some cleanups to address Frederic's comments.
> 
> Inspied-by: Steven Rostedt <srostedt@redhat.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Nice work Li!

I'll pull it in and give it some tests. I believe Frederic is traveling 
today, but if it works well I'll get it ready to push. Unless Tom has any 
rejections to it.

Thanks!

-- Steve


> ---
>  include/linux/ftrace_event.h       |    4 +-
>  kernel/trace/trace.h               |    3 +-
>  kernel/trace/trace_events_filter.c |  124 ++++++++++++++++++++++++------------
>  3 files changed, 87 insertions(+), 44 deletions(-)
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
> index b9aae72..c7ed427 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -418,7 +418,14 @@ oom:
>  }
>  EXPORT_SYMBOL_GPL(init_preds);
>  
> -static void filter_free_subsystem_preds(struct event_subsystem *system)
> +enum {
> +	FILTER_DISABLE_ALL,
> +	FILTER_INIT_NO_RESET,
> +	FILTER_SKIP_NO_RESET,
> +};
> +
> +static void filter_free_subsystem_preds(struct event_subsystem *system,
> +					int flag)
>  {
>  	struct ftrace_event_call *call;
>  
> @@ -426,6 +433,14 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
>  		if (!call->define_fields)
>  			continue;
>  
> +		if (flag == FILTER_INIT_NO_RESET) {
> +			call->filter->no_reset = false;
> +			continue;
> +		}
> +
> +		if (flag == FILTER_SKIP_NO_RESET && call->filter->no_reset)
> +			continue;
> +
>  		if (!strcmp(call->system, system->name)) {
>  			filter_disable_preds(call);
>  			remove_filter_string(call->filter);
> @@ -527,7 +542,8 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
>  
>  static int filter_add_pred(struct filter_parse_state *ps,
>  			   struct ftrace_event_call *call,
> -			   struct filter_pred *pred)
> +			   struct filter_pred *pred,
> +			   bool dry_run)
>  {
>  	struct ftrace_event_field *field;
>  	filter_pred_fn_t fn;
> @@ -539,10 +555,12 @@ static int filter_add_pred(struct filter_parse_state *ps,
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
> @@ -565,9 +583,6 @@ static int filter_add_pred(struct filter_parse_state *ps,
>  		else
>  			fn = filter_pred_strloc;
>  		pred->str_len = field->size;
> -		if (pred->op == OP_NE)
> -			pred->not = 1;
> -		return filter_add_pred_fn(ps, call, pred, fn);
>  	} else {
>  		if (field->is_signed)
>  			ret = strict_strtoll(pred->str_val, 0, &val);
> @@ -578,27 +593,33 @@ static int filter_add_pred(struct filter_parse_state *ps,
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
> +	if (!dry_run)
> +		return filter_add_pred_fn(ps, call, pred, fn);
> +	return 0;
>  }
>  
>  static int filter_add_subsystem_pred(struct filter_parse_state *ps,
>  				     struct event_subsystem *system,
>  				     struct filter_pred *pred,
> -				     char *filter_string)
> +				     char *filter_string,
> +				     bool dry_run)
>  {
>  	struct ftrace_event_call *call;
>  	int err = 0;
> +	bool fail = true;
>  
>  	list_for_each_entry(call, &ftrace_events, list) {
>  
> @@ -608,16 +629,24 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
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
> +		err = filter_add_pred(ps, call, pred, dry_run);
> +		if (err)
> +			call->filter->no_reset = true;
> +		else
> +			fail = false;
> +
> +		if (!dry_run)
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
> @@ -976,12 +1005,14 @@ static int check_preds(struct filter_parse_state *ps)
>  static int replace_preds(struct event_subsystem *system,
>  			 struct ftrace_event_call *call,
>  			 struct filter_parse_state *ps,
> -			 char *filter_string)
> +			 char *filter_string,
> +			 bool dry_run)
>  {
>  	char *operand1 = NULL, *operand2 = NULL;
>  	struct filter_pred *pred;
>  	struct postfix_elt *elt;
>  	int err;
> +	int n_preds = 0;
>  
>  	err = check_preds(ps);
>  	if (err)
> @@ -1000,19 +1031,14 @@ static int replace_preds(struct event_subsystem *system,
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
> @@ -1021,11 +1047,12 @@ static int replace_preds(struct event_subsystem *system,
>  		}
>  
>  		pred = create_pred(elt->op, operand1, operand2);
> +add_pred:
>  		if (call)
> -			err = filter_add_pred(ps, call, pred);
> +			err = filter_add_pred(ps, call, pred, false);
>  		else
>  			err = filter_add_subsystem_pred(ps, system, pred,
> -							filter_string);
> +						filter_string, dry_run);
>  		filter_free_pred(pred);
>  		if (err)
>  			return err;
> @@ -1066,7 +1093,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
>  		goto out;
>  	}
>  
> -	err = replace_preds(NULL, call, ps, filter_string);
> +	err = replace_preds(NULL, call, ps, filter_string, false);
>  	if (err)
>  		append_filter_err(ps, call->filter);
>  
> @@ -1090,7 +1117,7 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
>  	mutex_lock(&event_mutex);
>  
>  	if (!strcmp(strstrip(filter_string), "0")) {
> -		filter_free_subsystem_preds(system);
> +		filter_free_subsystem_preds(system, FILTER_DISABLE_ALL);
>  		remove_filter_string(system->filter);
>  		mutex_unlock(&event_mutex);
>  		return 0;
> @@ -1101,7 +1128,6 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
>  	if (!ps)
>  		goto out_unlock;
>  
> -	filter_free_subsystem_preds(system);
>  	replace_filter_string(system->filter, filter_string);
>  
>  	parse_init(ps, filter_ops, filter_string);
> @@ -1111,9 +1137,23 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
>  		goto out;
>  	}
>  
> -	err = replace_preds(system, NULL, ps, filter_string);
> -	if (err)
> +	filter_free_subsystem_preds(system, FILTER_INIT_NO_RESET);
> +
> +	/* try to see the filter can be applied to which events */
> +	err = replace_preds(system, NULL, ps, filter_string, true);
> +	if (err) {
> +		append_filter_err(ps, system->filter);
> +		goto out;
> +	}
> +
> +	filter_free_subsystem_preds(system, FILTER_SKIP_NO_RESET);
> +
> +	/* really apply the filter to the events */
> +	err = replace_preds(system, NULL, ps, filter_string, false);
> +	if (err) {
>  		append_filter_err(ps, system->filter);
> +		filter_free_subsystem_preds(system, 2);
> +	}
>  
>  out:
>  	filter_opstack_clear(ps);
> -- 
> 1.6.3
> 
