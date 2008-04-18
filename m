Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbYDRKY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbYDRKY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 06:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYDRKYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 06:24:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484AbYDRKYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 06:24:19 -0400
Date: Fri, 18 Apr 2008 03:23:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH sched-devel] ftrace: trace_entries to change trace
 buffer size
Message-Id: <20080418032301.0f7bef7d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0804142139240.16591@gandalf.stny.rr.com>
References: <20080411163923.439680284@goodmis.org>
	<20080411164037.219665668@goodmis.org>
	<20080411214328.25c06a5d@daedalus.pq.iki.fi>
	<Pine.LNX.4.58.0804112021200.4500@gandalf.stny.rr.com>
	<20080413145604.3fb396a2@daedalus.pq.iki.fi>
	<20080414095645.GC3761@elte.hu>
	<20080414211433.3bfa5649@daedalus.pq.iki.fi>
	<Pine.LNX.4.58.0804142139240.16591@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 21:41:25 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> This patch adds /debug/tracing/trace_entries that allows users to see as
> well as modify the number of entries the buffers hold. The number of entries
> only increments in ENTRIES_PER_PAGE which is calculated by the size of an
> entry with the number of entries that can fit in a page. The user does
> not need to use an exact size, but the entries will be rounded to one of
> the increments.
> 
> Trying to set the entries to 0 will return with -EINVAL.
> 
> To avoid race conditions, the modification of the buffer size can only
> be done when tracing is completely disabled (current_tracer == none).
> A info message will be printed if a user tries to modify the buffer size
> when not set to none.
> 
> +++ linux-sched-devel.git/kernel/trace/trace.c	2008-04-14 21:09:04.000000000 -0400
> @@ -35,6 +35,15 @@
>  unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
>  unsigned long __read_mostly	tracing_thresh;
> 
> +/* dummy trace to disable tracing */
> +static struct tracer no_tracer __read_mostly =
> {

static struct tracer no_tracer __read_mostly = {

please.

> +	.name		= "none",
> +};
> +
> +static int trace_alloc_page(void);
> +static int trace_free_page(void);
> +
>  static int tracing_disabled = 1;
> 
>  long
> @@ -2411,6 +2420,70 @@ tracing_read_pipe(struct file *filp, cha
>  	return read;
>  }
> 
> +static ssize_t
> +tracing_entries_read(struct file *filp, char __user *ubuf,
> +		     size_t cnt, loff_t *ppos)
> +{
> +	struct trace_array *tr = filp->private_data;
> +	char buf[64];
> +	int r;
> +
> +	r = sprintf(buf, "%lu\n", tr->entries);
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
> +}
> +
> +static ssize_t
> +tracing_entries_write(struct file *filp, const char __user *ubuf,
> +		      size_t cnt, loff_t *ppos)
> +{
> +	unsigned long val;
> +	char buf[64];
> +
> +	if (cnt > 63)
> +		cnt = 63;

We should generate an error in this case, rather than just copying in a
wrong value.

The necessity to keep the 63 and 64 in sync is fragile.  sizeof() would
fix that.

> +	if (copy_from_user(&buf, ubuf, cnt))
> +		return -EFAULT;
> +
> +	buf[cnt] = 0;
> +
> +	val = simple_strtoul(buf, NULL, 10);

Please use strict_strtoul().  We don't want to accept values like 42foo.

> +	/* must have at least 1 entry */
> +	if (!val)
> +		return -EINVAL;
> +
> +	mutex_lock(&trace_types_lock);
> +
> +	if (current_trace != &no_tracer) {
> +		cnt = -EBUSY;
> +		pr_info("ftrace: set current_tracer to none"
> +			" before modifying buffer size\n");
> +		goto out;
> +	}
> +
> +	if (val > global_trace.entries) {
> +		while (global_trace.entries < val) {
> +			if (trace_alloc_page()) {
> +				cnt = -ENOMEM;
> +				goto out;
> +			}
> +		}
> +	} else {
> +		/* include the number of entries in val (inc of page entries) */
> +		while (global_trace.entries > val + (ENTRIES_PER_PAGE - 1))
> +			trace_free_page();
> +	}
> +
> +	filp->f_pos += cnt;

I guess this really should be advanced by the number of bytes which
strict_strtoul() consumed, but it doesn't matter.

> + out:
> +	max_tr.entries = global_trace.entries;
> +	mutex_unlock(&trace_types_lock);
> +
> +	return cnt;
> +}
> +
>  static struct file_operations tracing_max_lat_fops = {
>  	.open		= tracing_open_generic,
>  	.read		= tracing_max_lat_read,
> @@ -2436,6 +2509,12 @@ static struct file_operations tracing_pi
>  	.release	= tracing_release_pipe,
>  };
> 
> +static struct file_operations tracing_entries_fops = {
> +	.open		= tracing_open_generic,
> +	.read		= tracing_entries_read,
> +	.write		= tracing_entries_write,
> +};
> +
>  #ifdef CONFIG_DYNAMIC_FTRACE
> 
>  static ssize_t
> @@ -2547,6 +2626,12 @@ static __init void tracer_init_debugfs(v
>  		pr_warning("Could not create debugfs "
>  			   "'tracing_threash' entry\n");
> 
> +	entry = debugfs_create_file("trace_entries", 0644, d_tracer,
> +				    &global_trace, &tracing_entries_fops);
> +	if (!entry)
> +		pr_warning("Could not create debugfs "
> +			   "'tracing_threash' entry\n");
> +

There should be an update the ftrace documentation for this, if it existed.

> +static int trace_free_page(void)
> +{
> +	struct trace_array_cpu *data;
> +	struct page *page;
> +	struct list_head *p;
> +	int i;
> +	int ret = 0;
> +
> +	/* free one page from each buffer */
> +	for_each_possible_cpu(i) {

This can be grossly inefficient.  A machine can (I believe) have 1024
possible CPUs with only four present.

It should size this storage by the number of online CPUs and implement the
appropriate cpu hotplug handlers.


> +		data = global_trace.data[i];
> +		p = data->trace_pages.next;
> +		if (p == &data->trace_pages) {

So I stared at the data structures for a while.  They're not obvious enough
to leave uncommented.  The best way to make code such as this
understandable (and hence maintainable) is to *fully* document the data
structures, and the relationship(s) between them.

For example, it is quite unobvious why trace_array_cpu.lock is declared as
a raw_spinlock_t, and there is no simple or reliable way of telling what
data that lock protects.

> +			/* should never happen */
> +			WARN_ON(1);
> +			tracing_disabled = 1;
> +			ret = -1;
> +			break;
> +		}
> +		page = list_entry(p, struct page, lru);
> +		ClearPageLRU(page);

scuse me?  Why is this code playing with PG_lru?

> +		list_del(&page->lru);
> +		__free_page(page);
> +
> +		tracing_reset(data);
> +
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +		data = max_tr.data[i];
> +		p = data->trace_pages.next;
> +		if (p == &data->trace_pages) {
> +			/* should never happen */
> +			WARN_ON(1);
> +			tracing_disabled = 1;
> +			ret = -1;
> +			break;
> +		}
> +		page = list_entry(p, struct page, lru);
> +		ClearPageLRU(page);
> +		list_del(&page->lru);
> +		__free_page(page);
> +
> +		tracing_reset(data);
> +#endif

hm, I wonder what this is doing.

Shouldn't we write a function rather than this copy-n-paste job?

> +	}
> +	global_trace.entries -= ENTRIES_PER_PAGE;
> +
> +	return ret;
> +}
> +
>  __init static int tracer_alloc_buffers(void)
>  {
>  	struct trace_array_cpu *data;
> @@ -2659,6 +2785,9 @@ __init static int tracer_alloc_buffers(v
>  		/* use the LRU flag to differentiate the two buffers */
>  		ClearPageLRU(page);
> 
> +		data->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
> +		max_tr.data[i]->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;

eww.  This *really* needs explanatory comments.


