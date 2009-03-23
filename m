Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbZCWSIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbZCWSIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759991AbZCWSGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:06:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59721 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759977AbZCWSGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:06:53 -0400
Date: Mon, 23 Mar 2009 14:06:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH 3/4] tracing: add per-event filtering
In-Reply-To: <1237710665.7703.48.camel@charm-linux>
Message-ID: <alpine.DEB.2.00.0903231358320.3578@gandalf.stny.rr.com>
References: <1237710665.7703.48.camel@charm-linux>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 22 Mar 2009, Tom Zanussi wrote:
>  
> +static ssize_t
> +event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
> +		  loff_t *ppos)
> +{
> +	struct ftrace_event_call *call = filp->private_data;
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
> +	r = filter_print_preds(call->preds, s->buffer);

You're not using any of the features of the trace_seq structure.
Might as well just allocate your own buffer.

> +	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, r);
> +
> +	kfree(s);
> +
> +	return r;
> +}
> +
> +static ssize_t
> +event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
> +		   loff_t *ppos)
> +{
> +	struct ftrace_event_call *call = filp->private_data;
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
> +		filter_free_preds(call);

The above is very confusing. Why are we passing in "call"?

> +		return cnt;
> +	}
> +
> +	if (filter_add_pred(call, pred)) {
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
> @@ -504,6 +569,12 @@ static const struct file_operations ftrace_event_id_fops = {
>  	.read = event_id_read,
>  };
>  
> +static const struct file_operations ftrace_event_filter_fops = {
> +	.open = tracing_open_generic,
> +	.read = event_filter_read,
> +	.write = event_filter_write,
> +};
> +
>  static struct dentry *event_trace_events_dir(void)
>  {
>  	static struct dentry *d_tracer;
> @@ -619,6 +690,12 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
>  		}
>  	}
>  
> +	entry = debugfs_create_file("filter", 0444, call->dir, call,
> +				    &ftrace_event_filter_fops);
> +	if (!entry)
> +		pr_warning("Could not create debugfs "
> +			   "'%s/filter' entry\n", call->name);
> +
>  	/* A trace may not want to export its format */
>  	if (!call->show_format)
>  		return 0;

[...]

> +
> diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
> index 468938f..ebf215e 100644
> --- a/kernel/trace/trace_events_stage_3.h
> +++ b/kernel/trace/trace_events_stage_3.h
> @@ -204,6 +204,7 @@ static struct ftrace_event_call event_##call;				\
>  									\
>  static void ftrace_raw_event_##call(proto)				\
>  {									\
> +	struct ftrace_event_call *call = &event_##call;			\
>  	struct ring_buffer_event *event;				\
>  	struct ftrace_raw_##call *entry;				\
>  	unsigned long irq_flags;					\
> @@ -222,6 +223,9 @@ static void ftrace_raw_event_##call(proto)				\
>  	assign;								\
>  									\
>  	trace_current_buffer_unlock_commit(event, irq_flags, pc);	\
> +									\
> +	if (call->preds && !filter_match_preds(call, entry))		\
> +		ring_buffer_event_discard(event);			\
>  }									\

Again, this would need to be within the commit.

-- Steve

>  									\
>  static int ftrace_raw_reg_event_##call(void)				\
> -- 
> 1.5.6.3
> 
> 
> 
> 
> 
