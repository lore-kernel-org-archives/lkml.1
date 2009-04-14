Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbZDNU4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbZDNU4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 16:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZDNU4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 16:56:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31521 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZDNU4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 16:56:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h+4pg18sSq5SnOAn7bSuHuHjQ3WaZTKchdhpUyc08qMDmpNissU0XBSqZmDYieKlEg
         fsJeR+vwOse/R4csO5hyRG5EGQh4uX3CRhyof5DSRtSNjno+TBUM/H5SwF1c9Qt2nlLQ
         fCkLo0ckUFB4I1QSMh2EShxpEgmjllibs8POA=
Date: Tue, 14 Apr 2009 22:56:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] tracing/filters: allow on-the-fly filter switching
Message-ID: <20090414205635.GA5968@nowhere>
References: <1239610670.6660.49.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239610670.6660.49.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 03:17:50AM -0500, Tom Zanussi wrote:
> This patch allows event filters to be safely removed or switched
> on-the-fly while avoiding the use of rcu or the suspension of tracing of
> previous versions.
> 
> It does it by adding a new filter_pred_none() predicate function which
> does nothing and by never deallocating either the predicates or any of
> the filter_pred members used in matching; the predicate lists are
> allocated and initialized during ftrace_event_calls initialization. 
> 
> Whenever a filter is removed or replaced, the filter_pred_* functions
> currently in use by the affected ftrace_event_call are immediately
> switched over to to the filter_pred_none() function, while the rest of
> the filter_pred members are left intact, allowing any currently
> executing filter_pred_* functions to finish up, using the values they're
> currently using.
> 
> In the case of filter replacement, the new predicate values are copied
> into the old predicates after the above step, and the filter_pred_none()
> functions are replaced by the filter_pred_* functions for the new
> filter.  In this case, it is possible though very unlikely that a
> previous filter_pred_* is still running even after the
> filter_pred_none() switch and the switch to the new filter_pred_*.  In
> that case, however, because nothing has been deallocated in the
> filter_pred, the worst that can happen is that the old filter_pred_*
> function sees the new values and as a result produces either a false
> positive or a false negative, depending on the values it finds.
> 
> So one downside to this method is that rarely, it can produce a bad
> match during the filter switch, but it should be possible to live with
> that, IMHO.
> 
> The other downside is that at least in this patch the predicate lists
> are always pre-allocated, taking up memory from the start.  They could
> probably be allocated on first-use, and de-allocated when tracing is
> completely stopped - if this patch makes sense, I could create another
> one to do that later on.
> 
> Oh, and it also places a restriction on the size of __arrays in events,
> currently set to 128, since they can't be larger than the now embedded
> str_val arrays in the filter_pred struct.
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> ---
>  kernel/trace/trace.h                |   14 ++-
>  kernel/trace/trace_events.c         |    9 +-
>  kernel/trace/trace_events_filter.c  |  252 ++++++++++++++++++-----------------
>  kernel/trace/trace_events_stage_2.h |    1 +
>  kernel/trace/trace_events_stage_3.h |    1 +
>  kernel/trace/trace_export.c         |    1 +
>  6 files changed, 150 insertions(+), 128 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index ce6bdc4..f75af6f 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -815,6 +815,7 @@ struct ftrace_event_call {
>  	int			(*show_format)(struct trace_seq *s);
>  	int			(*define_fields)(void);
>  	struct list_head	fields;
> +	int			n_preds;
>  	struct filter_pred	**preds;
>  
>  #ifdef CONFIG_EVENT_PROFILE
> @@ -828,6 +829,7 @@ struct event_subsystem {
>  	struct list_head	list;
>  	const char		*name;
>  	struct dentry		*entry;
> +	int			n_preds;
>  	struct filter_pred	**preds;
>  };
>  
> @@ -836,7 +838,8 @@ struct event_subsystem {
>  	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
>  	     event++)
>  
> -#define MAX_FILTER_PRED 8
> +#define MAX_FILTER_PRED		8
> +#define MAX_FILTER_STR_VAL	128
>  
>  struct filter_pred;
>  
> @@ -845,7 +848,7 @@ typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event);
>  struct filter_pred {
>  	filter_pred_fn_t fn;
>  	u64 val;
> -	char *str_val;
> +	char str_val[MAX_FILTER_STR_VAL];
>  	int str_len;
>  	char *field_name;
>  	int offset;
> @@ -857,13 +860,14 @@ struct filter_pred {
>  
>  int trace_define_field(struct ftrace_event_call *call, char *type,
>  		       char *name, int offset, int size);
> +extern int init_preds(struct ftrace_event_call *call);
>  extern void filter_free_pred(struct filter_pred *pred);
> -extern void filter_print_preds(struct filter_pred **preds,
> +extern void filter_print_preds(struct filter_pred **preds, int n_preds,
>  			       struct trace_seq *s);
>  extern int filter_parse(char **pbuf, struct filter_pred *pred);
>  extern int filter_add_pred(struct ftrace_event_call *call,
>  			   struct filter_pred *pred);
> -extern void filter_free_preds(struct ftrace_event_call *call);
> +extern void filter_disable_preds(struct ftrace_event_call *call);
>  extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
>  extern void filter_free_subsystem_preds(struct event_subsystem *system);
>  extern int filter_add_subsystem_pred(struct event_subsystem *system,
> @@ -877,7 +881,7 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
>  		     struct ring_buffer *buffer,
>  		     struct ring_buffer_event *event)
>  {
> -	if (unlikely(call->preds) && !filter_match_preds(call, rec)) {
> +	if (unlikely(call->n_preds) && !filter_match_preds(call, rec)) {
>  		ring_buffer_discard_commit(buffer, event);
>  		return 1;
>  	}
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 789e14e..ead68ac 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -481,7 +481,7 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
>  
>  	trace_seq_init(s);
>  
> -	filter_print_preds(call->preds, s);
> +	filter_print_preds(call->preds, call->n_preds, s);
>  	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
>  
>  	kfree(s);
> @@ -516,7 +516,7 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  	}
>  
>  	if (pred->clear) {
> -		filter_free_preds(call);
> +		filter_disable_preds(call);
>  		filter_free_pred(pred);
>  		return cnt;
>  	}
> @@ -527,6 +527,8 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  		return err;
>  	}
>  
> +	filter_free_pred(pred);
> +
>  	*ppos += cnt;
>  
>  	return cnt;
> @@ -549,7 +551,7 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
>  
>  	trace_seq_init(s);
>  
> -	filter_print_preds(system->preds, s);
> +	filter_print_preds(system->preds, system->n_preds, s);
>  	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
>  
>  	kfree(s);
> @@ -712,6 +714,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
>  	list_add(&system->list, &event_subsystems);
>  
>  	system->preds = NULL;
> +	system->n_preds = 0;
>  
>  	entry = debugfs_create_file("filter", 0644, system->entry, system,
>  				    &ftrace_subsystem_filter_fops);
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 9f8ecca..de42dad 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -82,25 +82,27 @@ static int filter_pred_string(struct filter_pred *pred, void *event)
>  	return match;
>  }
>  
> +static int filter_pred_none(struct filter_pred *pred, void *event)
> +{
> +	return 0;
> +}
> +
>  /* return 1 if event matches, 0 otherwise (discard) */
>  int filter_match_preds(struct ftrace_event_call *call, void *rec)
>  {
>  	int i, matched, and_failed = 0;
>  	struct filter_pred *pred;
>  
> -	for (i = 0; i < MAX_FILTER_PRED; i++) {
> -		if (call->preds[i]) {
> -			pred = call->preds[i];
> -			if (and_failed && !pred->or)
> -				continue;
> -			matched = pred->fn(pred, rec);
> -			if (!matched && !pred->or) {
> -				and_failed = 1;
> -				continue;
> -			} else if (matched && pred->or)
> -				return 1;
> -		} else
> -			break;
> +	for (i = 0; i < call->n_preds; i++) {
> +		pred = call->preds[i];
> +		if (and_failed && !pred->or)
> +			continue;
> +		matched = pred->fn(pred, rec);
> +		if (!matched && !pred->or) {
> +			and_failed = 1;
> +			continue;
> +		} else if (matched && pred->or)
> +			return 1;
>  	}
>  
>  	if (and_failed)
> @@ -109,31 +111,29 @@ int filter_match_preds(struct ftrace_event_call *call, void *rec)
>  	return 1;
>  }
>  
> -void filter_print_preds(struct filter_pred **preds, struct trace_seq *s)
> +void filter_print_preds(struct filter_pred **preds, int n_preds,
> +			struct trace_seq *s)
>  {
>  	char *field_name;
>  	struct filter_pred *pred;
>  	int i;
>  
> -	if (!preds) {
> +	if (!n_preds) {
>  		trace_seq_printf(s, "none\n");
>  		return;
>  	}
>  
> -	for (i = 0; i < MAX_FILTER_PRED; i++) {
> -		if (preds[i]) {
> -			pred = preds[i];
> -			field_name = pred->field_name;
> -			if (i)
> -				trace_seq_printf(s, pred->or ? "|| " : "&& ");
> -			trace_seq_printf(s, "%s ", field_name);
> -			trace_seq_printf(s, pred->not ? "!= " : "== ");
> -			if (pred->str_val)
> -				trace_seq_printf(s, "%s\n", pred->str_val);
> -			else
> -				trace_seq_printf(s, "%llu\n", pred->val);
> -		} else
> -			break;
> +	for (i = 0; i < n_preds; i++) {
> +		pred = preds[i];
> +		field_name = pred->field_name;
> +		if (i)
> +			trace_seq_printf(s, pred->or ? "|| " : "&& ");
> +		trace_seq_printf(s, "%s ", field_name);
> +		trace_seq_printf(s, pred->not ? "!= " : "== ");
> +		if (pred->str_len)
> +			trace_seq_printf(s, "%s\n", pred->str_val);
> +		else
> +			trace_seq_printf(s, "%llu\n", pred->val);
>  	}
>  }
>  
> @@ -156,20 +156,69 @@ void filter_free_pred(struct filter_pred *pred)
>  		return;
>  
>  	kfree(pred->field_name);
> -	kfree(pred->str_val);
>  	kfree(pred);
>  }
>  
> -void filter_free_preds(struct ftrace_event_call *call)
> +static void filter_clear_pred(struct filter_pred *pred)
> +{
> +	kfree(pred->field_name);
> +	pred->field_name = NULL;
> +	pred->str_len = 0;
> +}
> +
> +static int filter_set_pred(struct filter_pred *dest,
> +			   struct filter_pred *src,
> +			   filter_pred_fn_t fn)
> +{
> +	*dest = *src;
> +	dest->field_name = kstrdup(src->field_name, GFP_KERNEL);
> +	if (!dest->field_name)
> +		return -ENOMEM;
> +	dest->fn = fn;
> +
> +	return 0;
> +}
> +
> +void filter_disable_preds(struct ftrace_event_call *call)
>  {
>  	int i;
>  
> -	if (call->preds) {
> -		for (i = 0; i < MAX_FILTER_PRED; i++)
> +	call->n_preds = 0;
> +
> +	for (i = 0; i < MAX_FILTER_PRED; i++)
> +		call->preds[i]->fn = filter_pred_none;
> +}
> +
> +int init_preds(struct ftrace_event_call *call)
> +{
> +	struct filter_pred *pred;
> +	int i;
> +
> +	call->n_preds = 0;
> +
> +	call->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred), GFP_KERNEL);
> +	if (!call->preds)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < MAX_FILTER_PRED; i++) {
> +		pred = kzalloc(sizeof(*pred), GFP_KERNEL);
> +		if (!pred)
> +			goto oom;
> +		pred->fn = filter_pred_none;
> +		call->preds[i] = pred;
> +	}
> +
> +	return 0;
> +
> +oom:
> +	for (i = 0; i < MAX_FILTER_PRED; i++) {
> +		if (call->preds[i])
>  			filter_free_pred(call->preds[i]);
> -		kfree(call->preds);
> -		call->preds = NULL;
>  	}
> +	kfree(call->preds);
> +	call->preds = NULL;
> +
> +	return -ENOMEM;
>  }
>  
>  void filter_free_subsystem_preds(struct event_subsystem *system)
> @@ -177,11 +226,12 @@ void filter_free_subsystem_preds(struct event_subsystem *system)
>  	struct ftrace_event_call *call = __start_ftrace_events;
>  	int i;
>  
> -	if (system->preds) {
> -		for (i = 0; i < MAX_FILTER_PRED; i++)
> +	if (system->n_preds) {
> +		for (i = 0; i < system->n_preds; i++)
>  			filter_free_pred(system->preds[i]);
>  		kfree(system->preds);
>  		system->preds = NULL;
> +		system->n_preds = 0;
>  	}
>  
>  	events_for_each(call) {
> @@ -189,33 +239,31 @@ void filter_free_subsystem_preds(struct event_subsystem *system)
>  			continue;
>  
>  		if (!strcmp(call->system, system->name))
> -			filter_free_preds(call);
> +			filter_disable_preds(call);
>  	}
>  }
>  
>  static int __filter_add_pred(struct ftrace_event_call *call,
> -			     struct filter_pred *pred)
> +			     struct filter_pred *pred,
> +			     filter_pred_fn_t fn)
>  {
> -	int i;
> +	int idx, err;
>  
> -	if (call->preds && !pred->compound)
> -		filter_free_preds(call);
> +	if (call->n_preds && !pred->compound)
> +		filter_disable_preds(call);
>  
> -	if (!call->preds) {
> -		call->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
> -				      GFP_KERNEL);
> -		if (!call->preds)
> -			return -ENOMEM;
> -	}
> +	if (call->n_preds == MAX_FILTER_PRED)
> +		return -ENOSPC;
>
> -	for (i = 0; i < MAX_FILTER_PRED; i++) {
> -		if (!call->preds[i]) {
> -			call->preds[i] = pred;
> -			return 0;
> -		}
> -	}
> +	idx = call->n_preds;
> +	filter_clear_pred(call->preds[idx]);



BTW, this issue might be already present before this patch.
What happens if:


	T1				T2

event_filter_read() {
  filter_print_preds() {
    for (i = 0; i < n_preds; i++) {
	pred = preds[i];
				    event_filter_write() {
					filter_disable_preds();
					filter_clear_preds() {
					  kfree(pred->field_name);
	field_name = pred->field_name;
	// CRASH!!!


You need a mutex to protect these two callbacks.
It would also protect concurrent calls to event_filter_write(),
which would result in random.



> +	err = filter_set_pred(call->preds[idx], pred, fn);
> +	if (err)
> +		return err;
> +
> +	call->n_preds++;
>  
> -	return -ENOSPC;
> +	return 0;
>  }
>  
>  static int is_string_field(const char *type)
> @@ -229,98 +277,66 @@ static int is_string_field(const char *type)
>  int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
>  {
>  	struct ftrace_event_field *field;
> +	filter_pred_fn_t fn;
>  
>  	field = find_event_field(call, pred->field_name);
>  	if (!field)
>  		return -EINVAL;
>  
> +	pred->fn = filter_pred_none;
>  	pred->offset = field->offset;
>  
>  	if (is_string_field(field->type)) {
> -		if (!pred->str_val)
> +		if (!pred->str_len)
>  			return -EINVAL;
> -		pred->fn = filter_pred_string;
> +		fn = filter_pred_string;
>  		pred->str_len = field->size;
> -		return __filter_add_pred(call, pred);
> +		return __filter_add_pred(call, pred, fn);
>  	} else {
> -		if (pred->str_val)
> +		if (pred->str_len)
>  			return -EINVAL;
>  	}
>  
>  	switch (field->size) {
>  	case 8:
> -		pred->fn = filter_pred_64;
> +		fn = filter_pred_64;
>  		break;
>  	case 4:
> -		pred->fn = filter_pred_32;
> +		fn = filter_pred_32;
>  		break;
>  	case 2:
> -		pred->fn = filter_pred_16;
> +		fn = filter_pred_16;
>  		break;
>  	case 1:
> -		pred->fn = filter_pred_8;
> +		fn = filter_pred_8;
>  		break;
>  	default:
>  		return -EINVAL;
>  	}
>  
> -	return __filter_add_pred(call, pred);
> -}
> -
> -static struct filter_pred *copy_pred(struct filter_pred *pred)
> -{
> -	struct filter_pred *new_pred = kmalloc(sizeof(*pred), GFP_KERNEL);
> -	if (!new_pred)
> -		return NULL;
> -
> -	memcpy(new_pred, pred, sizeof(*pred));
> -
> -	if (pred->field_name) {
> -		new_pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
> -		if (!new_pred->field_name) {
> -			kfree(new_pred);
> -			return NULL;
> -		}
> -	}
> -
> -	if (pred->str_val) {
> -		new_pred->str_val = kstrdup(pred->str_val, GFP_KERNEL);
> -		if (!new_pred->str_val) {
> -			filter_free_pred(new_pred);
> -			return NULL;
> -		}
> -	}
> -
> -	return new_pred;
> +	return __filter_add_pred(call, pred, fn);
>  }
>  
>  int filter_add_subsystem_pred(struct event_subsystem *system,
>  			      struct filter_pred *pred)
>  {
>  	struct ftrace_event_call *call = __start_ftrace_events;
> -	struct filter_pred *event_pred;
> -	int i;
>  
> -	if (system->preds && !pred->compound)
> +	if (system->n_preds && !pred->compound)
>  		filter_free_subsystem_preds(system);



While reading this and the below, I suspect you also need a mutex to
protect concurrent subsystem_filter_read() and
subsystem_filter_write(), and concurrent
subsystem_filter_write() as well. There are a lot of things to protect here.



>  
> -	if (!system->preds) {
> +	if (!system->n_preds) {
>  		system->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
>  					GFP_KERNEL);
>  		if (!system->preds)
>  			return -ENOMEM;
>  	}
>  
> -	for (i = 0; i < MAX_FILTER_PRED; i++) {
> -		if (!system->preds[i]) {
> -			system->preds[i] = pred;
> -			break;
> -		}
> -	}
> -
> -	if (i == MAX_FILTER_PRED)
> +	if (system->n_preds == MAX_FILTER_PRED)
>  		return -ENOSPC;
>  
> +	system->preds[system->n_preds] = pred;
> +
>  	events_for_each(call) {
>  		int err;
>  
> @@ -333,22 +349,16 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
>  		if (!find_event_field(call, pred->field_name))
>  			continue;
>  
> -		event_pred = copy_pred(pred);
> -		if (!event_pred)
> -			goto oom;
> -
> -		err = filter_add_pred(call, event_pred);
> -		if (err)
> -			filter_free_pred(event_pred);
> -		if (err == -ENOMEM)
> -			goto oom;
> +		err = filter_add_pred(call, pred);
> +		if (err == -ENOMEM) {
> +			system->preds[system->n_preds] = NULL;
> +			return err;
> +		}
>  	}
>  
> -	return 0;
> +	system->n_preds++;
>  
> -oom:
> -	system->preds[i] = NULL;
> -	return -ENOMEM;
> +	return 0;
>  }
>  
>  int filter_parse(char **pbuf, struct filter_pred *pred)
> @@ -410,7 +420,8 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
>  		}
>  	}
>  
> -	if (!val_str) {
> +	if (!val_str || !strlen(val_str)
> +	    || strlen(val_str) >= MAX_FILTER_STR_VAL) {
>  		pred->field_name = NULL;
>  		return -EINVAL;
>  	}
> @@ -419,11 +430,12 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
>  	if (!pred->field_name)
>  		return -ENOMEM;
>  
> +	pred->str_len = 0;
>  	pred->val = simple_strtoull(val_str, &tmp, 0);
>  	if (tmp == val_str) {
> -		pred->str_val = kstrdup(val_str, GFP_KERNEL);
> -		if (!pred->str_val)
> -			return -ENOMEM;
> +		strncpy(pred->str_val, val_str, MAX_FILTER_STR_VAL);
> +		pred->str_len = strlen(val_str);
> +		pred->str_val[pred->str_len] = '\0';
>  	} else if (*tmp != '\0')
>  		return -EINVAL;
>  
> diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
> index 02fb710..59cfd7d 100644
> --- a/kernel/trace/trace_events_stage_2.h
> +++ b/kernel/trace/trace_events_stage_2.h
> @@ -140,6 +140,7 @@ ftrace_format_##call(struct trace_seq *s)				\
>  
>  #undef __array
>  #define __array(type, item, len)					\
> +	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
>  	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
>  				 offsetof(typeof(field), item),		\
>  				 sizeof(field.item));			\
> diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
> index b2b2982..5bb1b7f 100644
> --- a/kernel/trace/trace_events_stage_3.h
> +++ b/kernel/trace/trace_events_stage_3.h
> @@ -255,6 +255,7 @@ static int ftrace_raw_init_event_##call(void)				\
>  		return -ENODEV;						\
>  	event_##call.id = id;						\
>  	INIT_LIST_HEAD(&event_##call.fields);				\
> +	init_preds(&event_##call);					\
>  	return 0;							\
>  }									\
>  									\
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index 77c494f..48fc02f 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -122,6 +122,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>  static int ftrace_raw_init_event_##call(void)				\
>  {									\
>  	INIT_LIST_HEAD(&event_##call.fields);				\
> +	init_preds(&event_##call);					\
>  	return 0;							\
>  }									\
>  


Ok, the whole design and concept looks nice.

But you really need to think about a locking scheme to protect
the filters from user files.

Also, is filter_add_pred() supposed to be available for in-kernel
uses by other tracers or something?
If this is planned, the locking could be even deeper than my comments.

Other than these comments:

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks!

