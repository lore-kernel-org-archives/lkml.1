Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYDRMsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYDRMsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYDRMsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:48:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55784 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbYDRMsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:48:12 -0400
Date: Fri, 18 Apr 2008 08:48:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH sched-devel] ftrace: trace_entries to change trace buffer
 size
In-Reply-To: <20080418032301.0f7bef7d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0804180822510.5642@gandalf.stny.rr.com>
References: <20080411163923.439680284@goodmis.org> <20080411164037.219665668@goodmis.org>
 <20080411214328.25c06a5d@daedalus.pq.iki.fi> <Pine.LNX.4.58.0804112021200.4500@gandalf.stny.rr.com>
 <20080413145604.3fb396a2@daedalus.pq.iki.fi> <20080414095645.GC3761@elte.hu>
 <20080414211433.3bfa5649@daedalus.pq.iki.fi> <Pine.LNX.4.58.0804142139240.16591@gandalf.stny.rr.com>
 <20080418032301.0f7bef7d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew, thanks for taking you time in looking through this patch.


On Fri, 18 Apr 2008, Andrew Morton wrote:

> On Mon, 14 Apr 2008 21:41:25 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > +++ linux-sched-devel.git/kernel/trace/trace.c	2008-04-14 21:09:04.000000000 -0400
> > @@ -35,6 +35,15 @@
> >  unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
> >  unsigned long __read_mostly	tracing_thresh;
> >
> > +/* dummy trace to disable tracing */
> > +static struct tracer no_tracer __read_mostly =
> > {
>
> static struct tracer no_tracer __read_mostly = {
>
> please.

Bah, I usually do that correctely. Thanks, will fix.

>
> > +	.name		= "none",
> > +};
> > +
> > +static int trace_alloc_page(void);
> > +static int trace_free_page(void);
> > +
> >  static int tracing_disabled = 1;
> >
> >  long
> > @@ -2411,6 +2420,70 @@ tracing_read_pipe(struct file *filp, cha
> >  	return read;
> >  }
> >
> > +static ssize_t
> > +tracing_entries_read(struct file *filp, char __user *ubuf,
> > +		     size_t cnt, loff_t *ppos)
> > +{
> > +	struct trace_array *tr = filp->private_data;
> > +	char buf[64];
> > +	int r;
> > +
> > +	r = sprintf(buf, "%lu\n", tr->entries);
> > +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
> > +}
> > +
> > +static ssize_t
> > +tracing_entries_write(struct file *filp, const char __user *ubuf,
> > +		      size_t cnt, loff_t *ppos)
> > +{
> > +	unsigned long val;
> > +	char buf[64];
> > +
> > +	if (cnt > 63)
> > +		cnt = 63;
>
> We should generate an error in this case, rather than just copying in a
> wrong value.

OK, sounds good. Will fix.

>
> The necessity to keep the 63 and 64 in sync is fragile.  sizeof() would
> fix that.

Will fix.

>
> > +	if (copy_from_user(&buf, ubuf, cnt))
> > +		return -EFAULT;
> > +
> > +	buf[cnt] = 0;
> > +
> > +	val = simple_strtoul(buf, NULL, 10);
>
> Please use strict_strtoul().  We don't want to accept values like 42foo.

I saw that in my checkpatch run. But the API was strange to me
(my first time I've seen strict_strtoul). I'll look more at how to use
it and incorportate it.

>
> > +	/* must have at least 1 entry */
> > +	if (!val)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&trace_types_lock);
> > +
> > +	if (current_trace != &no_tracer) {
> > +		cnt = -EBUSY;
> > +		pr_info("ftrace: set current_tracer to none"
> > +			" before modifying buffer size\n");
> > +		goto out;
> > +	}
> > +
> > +	if (val > global_trace.entries) {
> > +		while (global_trace.entries < val) {
> > +			if (trace_alloc_page()) {
> > +				cnt = -ENOMEM;
> > +				goto out;
> > +			}
> > +		}
> > +	} else {
> > +		/* include the number of entries in val (inc of page entries) */
> > +		while (global_trace.entries > val + (ENTRIES_PER_PAGE - 1))
> > +			trace_free_page();
> > +	}
> > +
> > +	filp->f_pos += cnt;
>
> I guess this really should be advanced by the number of bytes which
> strict_strtoul() consumed, but it doesn't matter.

Will add after understanding strict_strtoul.

>
> > + out:
> > +	max_tr.entries = global_trace.entries;
> > +	mutex_unlock(&trace_types_lock);
> > +
> > +	return cnt;
> > +}
> > +
> >  static struct file_operations tracing_max_lat_fops = {
> >  	.open		= tracing_open_generic,
> >  	.read		= tracing_max_lat_read,
> > @@ -2436,6 +2509,12 @@ static struct file_operations tracing_pi
> >  	.release	= tracing_release_pipe,
> >  };
> >
> > +static struct file_operations tracing_entries_fops = {
> > +	.open		= tracing_open_generic,
> > +	.read		= tracing_entries_read,
> > +	.write		= tracing_entries_write,
> > +};
> > +
> >  #ifdef CONFIG_DYNAMIC_FTRACE
> >
> >  static ssize_t
> > @@ -2547,6 +2626,12 @@ static __init void tracer_init_debugfs(v
> >  		pr_warning("Could not create debugfs "
> >  			   "'tracing_threash' entry\n");
> >
> > +	entry = debugfs_create_file("trace_entries", 0644, d_tracer,
> > +				    &global_trace, &tracing_entries_fops);
> > +	if (!entry)
> > +		pr_warning("Could not create debugfs "
> > +			   "'tracing_threash' entry\n");
> > +
>
> There should be an update the ftrace documentation for this, if it existed.

FYI, I'm currently working on a tutorial for OLS. Yes, I'm giving a
tutorial for ftrace. I'm now writing a LaTeX document of all the features.
One thing that will come out of this is a Documentation/ftrace.txt

I'll start working on that document in parallel.

>
> > +static int trace_free_page(void)
> > +{
> > +	struct trace_array_cpu *data;
> > +	struct page *page;
> > +	struct list_head *p;
> > +	int i;
> > +	int ret = 0;
> > +
> > +	/* free one page from each buffer */
> > +	for_each_possible_cpu(i) {
>
> This can be grossly inefficient.  A machine can (I believe) have 1024
> possible CPUs with only four present.

Last night, while writing the above mentioned document, I thought about
this, and said to myself "I need to make this CPU hotplug friendly and
save memory". I started this out a bit "safe" but I guess I can now address
this, and do only "online_cpus".

>
> It should size this storage by the number of online CPUs and implement the
> appropriate cpu hotplug handlers.
>
>
> > +		data = global_trace.data[i];
> > +		p = data->trace_pages.next;
> > +		if (p == &data->trace_pages) {
>
> So I stared at the data structures for a while.  They're not obvious enough
> to leave uncommented.  The best way to make code such as this
> understandable (and hence maintainable) is to *fully* document the data
> structures, and the relationship(s) between them.

Most definitely. I'll start a patch to document these too.

>
> For example, it is quite unobvious why trace_array_cpu.lock is declared as
> a raw_spinlock_t, and there is no simple or reliable way of telling what
> data that lock protects.

The tracer functions can be called from mcount. One thing that we have
been working on is to have lockdep and mcount play nicely together. Ftrace
has a setting for mcount (and dynamic ftrace does dynamic updates to the
code to make mcount calls into nops for keeping 0% overhead when not
enabled). Since the spinlocks are called from with mcount calls, when
lockdep is fully up and running, enabling ftrace function tracer (aka
mcount) brought the system to a halt. Although there is protection
against recursion of mcount, the killer to performance was the lockdep
infrastructure being called on practically every kernel function. That was
bad!

The use of raw_spin_lock was to keep mcount from calling into the lockdep
infrastructure.

>
> > +			/* should never happen */
> > +			WARN_ON(1);
> > +			tracing_disabled = 1;
> > +			ret = -1;
> > +			break;
> > +		}
> > +		page = list_entry(p, struct page, lru);
> > +		ClearPageLRU(page);
>
> scuse me?  Why is this code playing with PG_lru?

I blame Ingo ;-)

Actually this bit can probably be removed. To save from having yet another
descriptor, we use the page descriptor for keeping a link list of all
the pages allocated in the buffer. We have two buffers. One is for
recording and one is to be saved when a max latency has been reached.
In the case of hitting a new max latency, we do a swap of the two buffers
using list splice and friends. For debugging purposes I set the LRU bit
in one set of pages for a buffer, and keep it cleared for another. Then
I can make sure that we didn't screw up and get different pages in one
buffer that belonged in another buffer.

On freeing of the pages, I had to make sure the LRU bit was cleared,
otherwise bad things would happen in the page handling.

I still do like the fact that we can test the buffers for problems and
disable tracing if something were to go astray.

>
> > +		list_del(&page->lru);
> > +		__free_page(page);
> > +
> > +		tracing_reset(data);
> > +
> > +#ifdef CONFIG_TRACER_MAX_TRACE
> > +		data = max_tr.data[i];
> > +		p = data->trace_pages.next;
> > +		if (p == &data->trace_pages) {
> > +			/* should never happen */
> > +			WARN_ON(1);
> > +			tracing_disabled = 1;
> > +			ret = -1;
> > +			break;
> > +		}
> > +		page = list_entry(p, struct page, lru);
> > +		ClearPageLRU(page);
> > +		list_del(&page->lru);
> > +		__free_page(page);
> > +
> > +		tracing_reset(data);
> > +#endif
>
> hm, I wonder what this is doing.

Here we are removing the page for the link list (max tracer buffer).

>
> Shouldn't we write a function rather than this copy-n-paste job?

heh, probably. I guess I'll go and do that! This is something else I
usually do. I never like having more than three lines of duplicate code.

>
> > +	}
> > +	global_trace.entries -= ENTRIES_PER_PAGE;
> > +
> > +	return ret;
> > +}
> > +
> >  __init static int tracer_alloc_buffers(void)
> >  {
> >  	struct trace_array_cpu *data;
> > @@ -2659,6 +2785,9 @@ __init static int tracer_alloc_buffers(v
> >  		/* use the LRU flag to differentiate the two buffers */
> >  		ClearPageLRU(page);
> >
> > +		data->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
> > +		max_tr.data[i]->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
>
> eww.  This *really* needs explanatory comments.
>

Actually, that's just a way of doing spin_lock_init for raw spin locks. I
didn't see any other way.

Thanks,

-- Steve

