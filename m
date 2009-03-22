Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbZCVTCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbZCVTCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZCVTCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:02:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46311 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbZCVTCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=myCAzaJRhH96T7EHQTVBr/fUU6Kbv24sSahuOxPIm+d43Sk3DnF1soc2WgzcoS2Q45
         vkG9kCIpJMON4QF5S8zMq5iwSrfm/8FuOfk4RVchG3hdJJCeLzNGHgYcVwsSfBSGxqDJ
         Q6cLqwWrHEGKqeiaEeP3v4KE/Iu6z5eKPQmX8=
Date: Sun, 22 Mar 2009 20:01:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/4] tracing: add per-subsystem filtering
Message-ID: <20090322190158.GF6002@nowhere>
References: <1237710677.7703.49.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237710677.7703.49.camel@charm-linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 03:31:17AM -0500, Tom Zanussi wrote:
> This patch adds per-subsystem filtering to the event tracing subsystem.
> 
> It adds a 'filter' debugfs file to each subsystem directory.  This file
> can be written to to set filters; reading from it will display the
> current set of filters set for that subsystem.
> 
> Basically what it does is propagate the filter down to each event
> contained in the subsystem.  If a particular event doesn't have a field
> with the name specified in the filter, it simply doesn't get set for
> that event.  You can verify whether or not the filter was set for a
> particular event by looking at the filter file for that event.
> 
> As with per-event filters, compound expressions are supported, echoing
> '0' to the subsystem's filter file clears all filters in the subsystem,
> etc.
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> ---
>  kernel/trace/trace.h               |   15 ++++++
>  kernel/trace/trace_events.c        |   86 +++++++++++++++++++++++++++++++++---
>  kernel/trace/trace_events_filter.c |   80 +++++++++++++++++++++++++++++++++
>  3 files changed, 175 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index d9eb39e..f267723 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -804,6 +804,18 @@ struct ftrace_event_call {
>  #endif
>  };
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


Should be 0644.


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
> +			return NULL;
> +		}
> +	}
> +
> +	return new_pred;
> +}
> +
> +int filter_add_subsystem_pred(struct event_subsystem *system,
> +			      struct filter_pred *pred)
> +{
> +	struct ftrace_event_call *call = __start_ftrace_events;
> +	struct filter_pred *event_pred;
> +	int i;
> +
> +	if (system->preds && !pred->compound)
> +		filter_free_subsystem_preds(system);
> +
> +	if (!system->preds) {
> +		system->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
> +					GFP_KERNEL);
> +		if (!system->preds)
> +			return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < MAX_FILTER_PRED; i++) {
> +		if (!system->preds[i]) {
> +			system->preds[i] = pred;
> +			break;
> +		}
> +		if (i == MAX_FILTER_PRED - 1)
> +			return -EINVAL;


Shouldn't it be i == MAX_FILTER_PRED ?


> +	}
> +
> +	events_for_each(call) {
> +		if (!call->name || !call->regfunc)
> +			continue;
> +
> +		if (!strcmp(call->system, system->name)) {
> +			event_pred = copy_pred(pred);
> +			if (event_pred)
> +				filter_add_pred(call, event_pred);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  int filter_parse(char **pbuf, struct filter_pred *pred)
>  {
>  	char *tmp, *tok, *val_str = NULL;
> -- 
> 1.5.6.3
> 
> 
> 


Looks good too.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

