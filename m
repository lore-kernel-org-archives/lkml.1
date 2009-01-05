Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZAEQGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZAEQGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZAEQGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:06:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34436 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbZAEQGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:06:39 -0500
Date: Mon, 5 Jan 2009 11:06:35 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/2] tracing/ftrace: provide the base infrastructure for
 stat tracing
In-Reply-To: <4956aff1.0405560a.0eb9.ffffd126@mx.google.com>
Message-ID: <alpine.DEB.1.10.0901051047030.27085@gandalf.stny.rr.com>
References: <4956aff1.0405560a.0eb9.ffffd126@mx.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 27 Dec 2008, Frederic Weisbecker wrote:

> Impact: enhance the tracing API to provide statistical tracing
> 
> The goal of this patch is to normalize and make more easy the implementation
> of statistical (histogram) tracing.
> 
> It implements a trace_stat file into the /debugfs/tracing directory where
> one can print a one-shot output of statistics/histogram entries.
> 
> A tracer has to provide two basic iterator callbacks:
> 
> stat_start() => the first entry
> stat_next(prev, idx) => the next one.
> 
> Note that it is adapted for arrays or hash tables or lists.... since
> it provides a pointer to the previous entry and the current index of the
> iterator.
> 
> These two callbacks are called to get a snapshot of the statistics at each opening
> of the trace_stat file because.
> The values are so updated between two "cat trace_stat". And the tracer is free to lock its
> datas during the iteration to keep consistent values.
> 
> Since it is almost always interesting to sort statisticals values to address the problems by
> priority, this infrastructure provides a "sorting" of the stat entries too if desired.
> A tracer has just to provide a stat_cmp callback to compare two entries and the stat tracing
> infrastructure will build a sorted list of the given entries.
> 
> A last callback, called stat_headers, can be implemented by a tracer to output headers on its
> trace.
> 
> If one of these callbacks is changed on runtime, it just have to signal it to the stat tracing
> API by calling the init_tracer_stat() helper.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/Makefile     |    1 +
>  kernel/trace/trace.c      |    3 +-
>  kernel/trace/trace.h      |   17 +++
>  kernel/trace/trace_stat.c |  250 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 270 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 549f93c..31cd5fb 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
>  
>  obj-$(CONFIG_TRACING) += trace.o
>  obj-$(CONFIG_TRACING) += trace_output.o
> +obj-$(CONFIG_TRACING) += trace_stat.o
>  obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
>  obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
>  obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index a087add..bf75d10 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2354,6 +2354,7 @@ static int tracing_set_tracer(char *buf)
>  		if (ret)
>  			goto out;
>  	}
> +	init_tracer_stat(t);
>  
>  	trace_branch_enable(tr);
>   out:
> @@ -3206,7 +3207,7 @@ __init static int tracer_alloc_buffers(void)
>  #else
>  	current_trace = &nop_trace;
>  #endif
> -
> +	init_tracer_stat(current_trace);
>  	/* All seems OK, enable tracing */
>  	tracing_disabled = 0;
>  
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 6bd71fa..05fa804 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -336,6 +336,21 @@ struct tracer {
>  	struct tracer		*next;
>  	int			print_max;
>  	struct tracer_flags 	*flags;
> +
> +	/*
> +	 * If you change one of the following on tracing runtime, recall
> +	 * init_tracer_stat()
> +	 */

I wonder if you should add a "reinit_trace_stat" or something with a 
different name. Perhaps in the future this might require more locking than 
the inital init or some other kind of function needing to be called. 
Having a separate function to call might be better than to have to change 
all the callers in the future. Just a thought.

> +
> +	/* Iteration over statistic entries */
> +	void			*(*stat_start)(void);
> +	void			*(*stat_next)(void *prev, int idx);
> +	/* Compare two entries for sorting (optional) for stats */
> +	int			(*stat_cmp)(void *p1, void *p2);
> +	/* Print a stat entry */
> +	int			(*stat_show)(struct seq_file *s, void *p);
> +	/* Print the headers of your stat entries */
> +	int			(*stat_headers)(struct seq_file *s);
>  };
>  
>  struct trace_seq {
> @@ -421,6 +436,8 @@ void tracing_start_sched_switch_record(void);
>  int register_tracer(struct tracer *type);
>  void unregister_tracer(struct tracer *type);
>  
> +void init_tracer_stat(struct tracer *trace);
> +
>  extern unsigned long nsecs_to_usecs(unsigned long nsecs);
>  
>  extern unsigned long tracing_max_latency;
> diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
> new file mode 100644
> index 0000000..9022e0b
> --- /dev/null
> +++ b/kernel/trace/trace_stat.c
> @@ -0,0 +1,250 @@
> +/*
> + * Infrastructure for statistic tracing (histogram output).
> + *
> + * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
> + *
> + * Based on the code from trace_branch.c which is
> + * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
> + *
> + */
> +
> +
> +
> +#include <linux/list.h>
> +#include <linux/seq_file.h>
> +#include <linux/debugfs.h>
> +#include "trace.h"
> +
> +
> +/* List of stat entries from a tracer */
> +struct trace_stat_list {
> +	struct list_head list;
> +	void *stat;
> +};
> +
> +static struct trace_stat_list stat_list;

I don't see stat_list.stat ever used. This could probably be
made into a list head instead.

  static struct list_head stat_list;

> +
> +/*
> + * This is a copy of the current tracer to avoid racy
> + * and dangerous output while the current tracer is
> + * switched.
> + */
> +static struct tracer current_tracer;
> +
> +/*
> + * Protect both the current tracer and the global
> + * stat list.
> + */
> +static DEFINE_MUTEX(stat_list_mutex);
> +
> +
> +static inline void init_stat_list(void)
> +{
> +	INIT_LIST_HEAD(&stat_list.list);
> +}
> +
> +static void free_stat_list(void)
> +{
> +	struct trace_stat_list *node;
> +	struct list_head *next;
> +
> +	if (list_empty(&stat_list.list))
> +		return;
> +
> +	node = list_entry(stat_list.list.next, struct trace_stat_list, list);
> +	next = node->list.next;
> +
> +	while (&node->list != next) {
> +		kfree(node);
> +		node = list_entry(next, struct trace_stat_list, list);
> +	}
> +	kfree(node);

The above looks very broken :-(
I do not see "next" ever being updated in that while loop. And you take
The while loop will always run just once. The first time, node is the 
first element, the next time it is the element of next. What you want is 
this:

static void free_stat_list(void)
{
	struct trace_stat_list *node, *next;

	list_for_each_entry_safe(node, next,
				&stat_list.list, list) {
		kfree(node);
	}
}

And that's it ;-)


> +}
> +
> +void init_tracer_stat(struct tracer *trace)
> +{
> +	mutex_lock(&stat_list_mutex);
> +	current_tracer = *trace;
> +	mutex_unlock(&stat_list_mutex);
> +}
> +
> +/*
> + * For tracers that don't provide a stat_cmp callback.
> + * This one will force an immediate insertion on tail of
> + * the list.
> + */
> +static int dummy_cmp(void *p1, void *p2)
> +{
> +	return 1;
> +}
> +
> +/*
> + * Initialize the stat list at each trace_stat file opening.
> + * All of these copies and sorting are required on all opening
> + * since the stats could have changed between two file sessions.
> + */
> +static int stat_seq_init(void)
> +{
> +	struct trace_stat_list *iter_entry, *new_entry;
> +	void *prev_stat;
> +	int ret = 0;
> +	int i;
> +
> +	mutex_lock(&stat_list_mutex);
> +	init_stat_list();
> +
> +	if (!current_tracer.stat_start || !current_tracer.stat_next ||
> +					!current_tracer.stat_show)
> +		goto exit;
> +
> +	if (!current_tracer.stat_cmp)
> +		current_tracer.stat_cmp = dummy_cmp;
> +
> +	/*
> +	 * The first entry. Actually this is the second, but the first
> +	 * one (the stat_list head) is pointless.
> +	 */
> +	new_entry = kmalloc(sizeof(struct trace_stat_list), GFP_KERNEL);
> +	if (!new_entry) {
> +		ret = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	INIT_LIST_HEAD(&new_entry->list);
> +	list_add(&new_entry->list, &stat_list.list);
> +	new_entry->stat = current_tracer.stat_start();
> +
> +	prev_stat = new_entry->stat;
> +
> +	/*
> +	 * Iterate over the tracer stat entries and store them in a sorted
> +	 * list.
> +	 */
> +	for (i = 1; ; i++) {
> +		new_entry = kmalloc(sizeof(struct trace_stat_list), GFP_KERNEL);
> +		if (!new_entry) {
> +			ret = -ENOMEM;
> +			goto exit_free_list;
> +		}
> +
> +		INIT_LIST_HEAD(&new_entry->list);
> +		new_entry->stat = current_tracer.stat_next(prev_stat, i);
> +
> +		/* End of insertion */
> +		if (!new_entry->stat)
> +			break;
> +
> +		list_for_each_entry(iter_entry, &stat_list.list, list) {
> +			/* Insertion with a descendent sorting */
> +			if (current_tracer.stat_cmp(new_entry->stat,
> +						iter_entry->stat) > 0) {
> +
> +				list_add_tail(&new_entry->list,
> +						&iter_entry->list);
> +				break;
> +
> +			/* The current smaller value */
> +			} else if (list_is_last(&iter_entry->list,
> +						&stat_list.list)) {
> +				list_add(&new_entry->list, &iter_entry->list);
> +				break;
> +			}

Scary, linear sort. God forbid the list was in reversed order ;-)

Besides the list free, nice work Frederic.

-- Steve


> +		}
> +
> +		prev_stat = new_entry->stat;
> +	}
> +exit:
> +	mutex_unlock(&stat_list_mutex);
> +	return ret;
> +
> +exit_free_list:
> +	free_stat_list();
> +	mutex_unlock(&stat_list_mutex);
> +	return ret;
> +}
> +
> +
> +static void *stat_seq_start(struct seq_file *s, loff_t *pos)
> +{
> +	struct trace_stat_list *l = (struct trace_stat_list *)s->private;
> +
> +	/* Prevent from tracer switch or stat_list modification */
> +	mutex_lock(&stat_list_mutex);
> +
> +	/* If we are in the beginning of the file, print the headers */
> +	if (!*pos && current_tracer.stat_headers)
> +		current_tracer.stat_headers(s);
> +
> +	return seq_list_start(&l->list, *pos);
> +}
> +
> +static void *stat_seq_next(struct seq_file *s, void *p, loff_t *pos)
> +{
> +	struct trace_stat_list *l = (struct trace_stat_list *)s->private;
> +
> +	return seq_list_next(p, &l->list, pos);
> +}
> +
> +static void stat_seq_stop(struct seq_file *m, void *p)
> +{
> +	mutex_unlock(&stat_list_mutex);
> +}
> +
> +static int stat_seq_show(struct seq_file *s, void *v)
> +{
> +	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
> +	return current_tracer.stat_show(s, l->stat);
> +}
> +
> +static const struct seq_operations trace_stat_seq_ops = {
> +	.start = stat_seq_start,
> +	.next = stat_seq_next,
> +	.stop = stat_seq_stop,
> +	.show = stat_seq_show
> +};
> +
> +static int tracing_stat_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +
> +	ret = seq_open(file, &trace_stat_seq_ops);
> +	if (!ret) {
> +		struct seq_file *m = file->private_data;
> +		m->private = &stat_list;
> +		ret = stat_seq_init();
> +	}
> +
> +	return ret;
> +}
> +
> +static int tracing_stat_release(struct inode *i, struct file *f)
> +{
> +	mutex_lock(&stat_list_mutex);
> +	free_stat_list();
> +	mutex_unlock(&stat_list_mutex);
> +	return 0;
> +}
> +
> +static const struct file_operations tracing_stat_fops = {
> +	.open		= tracing_stat_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= tracing_stat_release
> +};
> +
> +static int __init tracing_stat_init(void)
> +{
> +	struct dentry *d_tracing;
> +	struct dentry *entry;
> +
> +	d_tracing = tracing_init_dentry();
> +
> +	entry = debugfs_create_file("trace_stat", 0444, d_tracing,
> +					NULL,
> +				    &tracing_stat_fops);
> +	if (!entry)
> +		pr_warning("Could not create debugfs "
> +			   "'trace_stat' entry\n");
> +	return 0;
> +}
> +fs_initcall(tracing_stat_init);
> -- 
> 1.6.0.4
> 
> 
> 
> 
