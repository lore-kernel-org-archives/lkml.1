Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbZAFUnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbZAFUnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbZAFUnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:43:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZAFUnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:43:12 -0500
Date: Tue, 6 Jan 2009 15:43:09 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] tracing/ftrace: fix a memory leak in stat tracing
In-Reply-To: <20090106203329.GA5922@nowhere>
Message-ID: <alpine.DEB.1.10.0901061542170.28185@gandalf.stny.rr.com>
References: <20090106203329.GA5922@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Frederic!

I'll just add an Impact line to this and push it off to Ingo.

The impact line will simply be:

	Impact: fix memory leak

-- Steve

On Tue, 6 Jan 2009, Frederic Weisbecker wrote:

> This patch fixes a memory leak inside reset_stat_list(). The freeing
> loop iterated only once.
> 
> Also turn the stat_list into a simple struct list_head, which
> simplify the code and avoid an unused static pointer.
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
> index 6f194a3..4cb4ff2 100644
> --- a/kernel/trace/trace_stat.c
> +++ b/kernel/trace/trace_stat.c
> @@ -21,7 +21,7 @@ struct trace_stat_list {
>  	void *stat;
>  };
>  
> -static struct trace_stat_list stat_list;
> +static LIST_HEAD(stat_list);
>  
>  /*
>   * This is a copy of the current tracer to avoid racy
> @@ -39,22 +39,12 @@ static DEFINE_MUTEX(stat_list_mutex);
>  
>  static void reset_stat_list(void)
>  {
> -	struct trace_stat_list *node;
> -	struct list_head *next;
> +	struct trace_stat_list *node, *next;
>  
> -	if (list_empty(&stat_list.list))
> -		return;
> -
> -	node = list_entry(stat_list.list.next, struct trace_stat_list, list);
> -	next = node->list.next;
> -
> -	while (&node->list != next) {
> +	list_for_each_entry_safe(node, next, &stat_list, list)
>  		kfree(node);
> -		node = list_entry(next, struct trace_stat_list, list);
> -	}
> -	kfree(node);
>  
> -	INIT_LIST_HEAD(&stat_list.list);
> +	INIT_LIST_HEAD(&stat_list);
>  }
>  
>  void init_tracer_stat(struct tracer *trace)
> @@ -107,7 +97,7 @@ static int stat_seq_init(void)
>  	}
>  
>  	INIT_LIST_HEAD(&new_entry->list);
> -	list_add(&new_entry->list, &stat_list.list);
> +	list_add(&new_entry->list, &stat_list);
>  	new_entry->stat = current_tracer.stat_start();
>  
>  	prev_stat = new_entry->stat;
> @@ -130,7 +120,7 @@ static int stat_seq_init(void)
>  		if (!new_entry->stat)
>  			break;
>  
> -		list_for_each_entry(iter_entry, &stat_list.list, list) {
> +		list_for_each_entry(iter_entry, &stat_list, list) {
>  			/* Insertion with a descendent sorting */
>  			if (current_tracer.stat_cmp(new_entry->stat,
>  						iter_entry->stat) > 0) {
> @@ -141,7 +131,7 @@ static int stat_seq_init(void)
>  
>  			/* The current smaller value */
>  			} else if (list_is_last(&iter_entry->list,
> -						&stat_list.list)) {
> +						&stat_list)) {
>  				list_add(&new_entry->list, &iter_entry->list);
>  				break;
>  			}
> @@ -162,7 +152,7 @@ exit_free_list:
>  
>  static void *stat_seq_start(struct seq_file *s, loff_t *pos)
>  {
> -	struct trace_stat_list *l = (struct trace_stat_list *)s->private;
> +	struct list_head *l = (struct list_head *)s->private;
>  
>  	/* Prevent from tracer switch or stat_list modification */
>  	mutex_lock(&stat_list_mutex);
> @@ -171,14 +161,14 @@ static void *stat_seq_start(struct seq_file *s, loff_t *pos)
>  	if (!*pos && current_tracer.stat_headers)
>  		current_tracer.stat_headers(s);
>  
> -	return seq_list_start(&l->list, *pos);
> +	return seq_list_start(l, *pos);
>  }
>  
>  static void *stat_seq_next(struct seq_file *s, void *p, loff_t *pos)
>  {
> -	struct trace_stat_list *l = (struct trace_stat_list *)s->private;
> +	struct list_head *l = (struct list_head *)s->private;
>  
> -	return seq_list_next(p, &l->list, pos);
> +	return seq_list_next(p, l, pos);
>  }
>  
>  static void stat_seq_stop(struct seq_file *m, void *p)
> @@ -188,8 +178,10 @@ static void stat_seq_stop(struct seq_file *m, void *p)
>  
>  static int stat_seq_show(struct seq_file *s, void *v)
>  {
> -	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
> -	return current_tracer.stat_show(s, l->stat);
> +	struct trace_stat_list *entry =
> +		list_entry(v, struct trace_stat_list, list);
> +
> +	return current_tracer.stat_show(s, entry->stat);
>  }
>  
>  static const struct seq_operations trace_stat_seq_ops = {
> @@ -237,7 +229,6 @@ static int __init tracing_stat_init(void)
>  	struct dentry *d_tracing;
>  	struct dentry *entry;
>  
> -	INIT_LIST_HEAD(&stat_list.list);
>  	d_tracing = tracing_init_dentry();
>  
>  	entry = debugfs_create_file("trace_stat", 0444, d_tracing,
> -- 
> 1.6.0.4
> 
> 
> 
> 
