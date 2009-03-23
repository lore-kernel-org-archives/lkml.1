Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbZCWSYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbZCWSYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbZCWSYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:24:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758797AbZCWSYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:24:23 -0400
Date: Mon, 23 Mar 2009 14:24:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH 4/4] tracing: add per-subsystem filtering
In-Reply-To: <1237710677.7703.49.camel@charm-linux>
Message-ID: <alpine.DEB.2.00.0903231413270.3578@gandalf.stny.rr.com>
References: <1237710677.7703.49.camel@charm-linux>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 22 Mar 2009, Tom Zanussi wrote:
>  
> +struct event_subsystem {
> +	struct list_head	list;
> +	const char		*name;
> +	struct dentry		*entry;
> +	struct filter_pred	**preds;
> +};
> +
> +#define events_for_each(event)						\
> +	for (event = __start_ftrace_events;				\
> +	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
> +	     event++)
> +
>  #define MAX_FILTER_PRED 8
>  
>  struct filter_pred;
> @@ -832,6 +844,9 @@ extern int filter_add_pred(struct ftrace_event_call *call,
>  			   struct filter_pred *pred);
>  extern void filter_free_preds(struct ftrace_event_call *call);
>  extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
> +extern void filter_free_subsystem_preds(struct event_subsystem *system);
> +extern int filter_add_subsystem_pred(struct event_subsystem *system,
> +				     struct filter_pred *pred);
>  
>  void event_trace_printk(unsigned long ip, const char *fmt, ...);
>  extern struct ftrace_event_call __start_ftrace_events[];
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 97470c4..97d4daa 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -524,6 +524,71 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  	return cnt;
>  }
>  
> +static ssize_t
> +subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
> +		      loff_t *ppos)
> +{
> +	struct event_subsystem *system = filp->private_data;
> +	struct trace_seq *s;

Again, trace_seq is not used, might as well use your own buffer.

> +	int r;
> +
> +	if (*ppos)
> +		return 0;
> +
> +	s = kmalloc(sizeof(*s), GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +
> +	trace_seq_init(s);
> +
> +	r = filter_print_preds(system->preds, s->buffer);
> +	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, r);
> +
> +	kfree(s);
> +
> +	return r;
> +}
> +
> +static ssize_t
> +subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
> +		       loff_t *ppos)
> +{
> +	struct event_subsystem *system = filp->private_data;
> +	char buf[64], *pbuf = buf;
> +	struct filter_pred *pred;
> +	int err;
> +
> +	if (cnt >= sizeof(buf))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&buf, ubuf, cnt))
> +		return -EFAULT;
> +
> +	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
> +	if (!pred)
> +		return -ENOMEM;
> +
> +	err = filter_parse(&pbuf, pred);
> +	if (err < 0) {
> +		filter_free_pred(pred);
> +		return err;
> +	}
> +
> +	if (pred->clear) {
> +		filter_free_subsystem_preds(system);

is "system" correct here?

> +		return cnt;
> +	}
> +
> +	if (filter_add_subsystem_pred(system, pred)) {
> +		filter_free_pred(pred);
> +		return -EINVAL;
> +	}
> +
> +	*ppos += cnt;
> +
> +	return cnt;
> +}
> +
>  static const struct seq_operations show_event_seq_ops = {
>  	.start = t_start,
>  	.next = t_next,
> @@ -575,6 +640,12 @@ static const struct file_operations ftrace_event_filter_fops = {
>  	.write = event_filter_write,
>  };
>  
> +static const struct file_operations ftrace_subsystem_filter_fops = {
> +	.open = tracing_open_generic,
> +	.read = subsystem_filter_read,
> +	.write = subsystem_filter_write,
> +};
> +
>  static struct dentry *event_trace_events_dir(void)
>  {
>  	static struct dentry *d_tracer;
> @@ -595,18 +666,13 @@ static struct dentry *event_trace_events_dir(void)
>  	return d_events;
>  }
>  
> -struct event_subsystem {
> -	struct list_head	list;
> -	const char		*name;
> -	struct dentry		*entry;
> -};
> -
>  static LIST_HEAD(event_subsystems);
>  
>  static struct dentry *
>  event_subsystem_dir(const char *name, struct dentry *d_events)
>  {
>  	struct event_subsystem *system;
> +	struct dentry *entry;
>  
>  	/* First see if we did not already create this dir */
>  	list_for_each_entry(system, &event_subsystems, list) {
> @@ -633,6 +699,14 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
>  	system->name = name;
>  	list_add(&system->list, &event_subsystems);
>  
> +	system->preds = NULL;
> +
> +	entry = debugfs_create_file("filter", 0444, system->entry, system,
> +				    &ftrace_subsystem_filter_fops);
> +	if (!entry)
> +		pr_warning("Could not create debugfs "
> +			   "'%s/filter' entry\n", name);
> +
>  	return system->entry;
>  }
>  
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 8e8c5fa..1ab20ce 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -181,6 +181,27 @@ void filter_free_preds(struct ftrace_event_call *call)
>  	}
>  }
>  
> +void filter_free_subsystem_preds(struct event_subsystem *system)
> +{
> +	struct ftrace_event_call *call = __start_ftrace_events;
> +	int i;
> +
> +	if (system->preds) {
> +		for (i = 0; i < MAX_FILTER_PRED; i++)
> +			filter_free_pred(system->preds[i]);
> +		kfree(system->preds);
> +		system->preds = NULL;
> +	}
> +
> +	events_for_each(call) {
> +		if (!call->name || !call->regfunc)
> +			continue;
> +
> +		if (!strcmp(call->system, system->name))
> +			filter_free_preds(call);
> +	}
> +}
> +
>  static int __filter_add_pred(struct ftrace_event_call *call,
>  			     struct filter_pred *pred)
>  {
> @@ -250,6 +271,65 @@ int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
>  	return __filter_add_pred(call, pred);
>  }
>  
> +static struct filter_pred *copy_pred(struct filter_pred *pred)
> +{
> +	struct filter_pred *new_pred = kmalloc(sizeof(*pred), GFP_KERNEL);
> +	if (!new_pred)
> +		return NULL;
> +
> +	memcpy(new_pred, pred, sizeof(*pred));
> +	if (pred->str_val) {
> +		new_pred->str_val = kstrdup(pred->str_val, GFP_KERNEL);
> +		new_pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
> +		if (!new_pred->str_val) {
> +			kfree(new_pred);

Shouldn't there be a check for field_name too?

-- Steve

> +			return NULL;
> +		}
> +	}
> +
> +	return new_pred;
> +}
> +
