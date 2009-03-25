Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZCYKDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZCYKDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZCYKDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:03:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53123 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbZCYKDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:03:35 -0400
Date: Wed, 25 Mar 2009 11:02:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5][RFC] tracing: add function profiler
Message-ID: <20090325100252.GH2341@elte.hu>
References: <20090325035646.662994901@goodmis.org> <20090325040832.251748832@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325040832.251748832@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(a few minor nits - all delta-fixable.)

* Steven Rostedt <rostedt@goodmis.org> wrote:

> +#ifdef CONFIG_FUNCTION_PROFILER
> +static struct hlist_head *ftrace_profile_hash;
> +static int ftrace_profile_bits;
> +static int ftrace_profile_enabled;

should be __read_mostly.

> +static DEFINE_MUTEX(ftrace_profile_lock);

should have a comment explaining its rules.

> +
> +static void *
> +function_stat_next(void *v, int idx)
> +{
> +	struct dyn_ftrace *rec = v;
> +	struct ftrace_page *pg;
> +
> +	pg = (struct ftrace_page *)((unsigned long)rec & PAGE_MASK);
> +
> + again:
> +	rec++;
> +	if ((void *)rec >= (void *)&pg->records[pg->index]) {
> +		pg = pg->next;
> +		if (!pg)
> +			return NULL;
> +		rec = &pg->records[0];
> +	}
> +
> +	if (rec->flags & FTRACE_FL_FREE ||
> +	    rec->flags & FTRACE_FL_FAILED ||
> +	    !(rec->flags & FTRACE_FL_CONVERTED) ||
> +	    /* ignore non hit functions */
> +	    !rec->counter)
> +		goto again;
> +
> +	return rec;
> +}
> +
> +static void *function_stat_start(struct tracer_stat *trace)
> +{
> +	return function_stat_next(&ftrace_pages_start->records[0], 0);
> +}
> +
> +static int function_stat_cmp(void *p1, void *p2)
> +{
> +	struct dyn_ftrace *a = p1;
> +	struct dyn_ftrace *b = p2;
> +
> +	if (a->counter < b->counter)
> +		return -1;
> +	if (a->counter > b->counter)
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static int function_stat_headers(struct seq_file *m)
> +{
> +	seq_printf(m, "  Function                               Hit\n"
> +		      "  --------                               ---\n");
> +	return 0;
> +}
> +
> +static int function_stat_show(struct seq_file *m, void *v)
> +{
> +	struct dyn_ftrace *rec = v;
> +	char str[KSYM_SYMBOL_LEN];
> +
> +	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> +
> +	seq_printf(m, "  %-30.30s  %10lu\n", str, rec->counter);
> +	return 0;
> +}
> +
> +static struct tracer_stat function_stats = {
> +	.name = "functions",
> +	.stat_start = function_stat_start,
> +	.stat_next = function_stat_next,
> +	.stat_cmp = function_stat_cmp,
> +	.stat_headers = function_stat_headers,
> +	.stat_show = function_stat_show
> +};

vertical spaces please.

> +
> +static void ftrace_profile_init(int nr_funcs)
> +{
> +	unsigned long addr;
> +	int order;
> +	int size;
> +
> +	/*
> +	 * We are profiling all functions, lets make it 1/4th of the
> +	 * number of functions that are in core kernel. So we have to
> +	 * iterate 4 times.
> +	 */
> +	order = (sizeof(struct hlist_head) * nr_funcs) / 4;
> +	order = get_order(order);
> +	size = 1 << (PAGE_SHIFT + order);
> +
> +	pr_info("Allocating %d KB for profiler hash\n", size >> 10);
> +
> +	addr = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
> +	if (!addr) {
> +		pr_warning("Could not allocate function profiler hash\n");
> +		return;
> +	}
> +
> +	ftrace_profile_hash = (void *)addr;
> +
> +	/*
> +	 * struct hlist_head should be a pointer of 4 or 8 bytes.
> +	 * And a simple bit manipulation can be done, but if for
> +	 * some reason struct hlist_head is not a mulitple of 2,
> +	 * then we play it safe, and simply count. This function
> +	 * is done once at boot up, so it is not that critical in
> +	 * performance.
> +	 */
> +
> +	size--;
> +	size /= sizeof(struct hlist_head);
> +
> +	for (; size; size >>= 1)
> +		ftrace_profile_bits++;
> +
> +	pr_info("Function profiler has %d hash buckets\n",
> +		1 << ftrace_profile_bits);
> +
> +	return;
> +}

stale return.

> +
> +static ssize_t
> +ftrace_profile_read(struct file *filp, char __user *ubuf,
> +		     size_t cnt, loff_t *ppos)
> +{
> +	char buf[64];

Magic constant.

> +	int r;
> +
> +	r = sprintf(buf, "%u\n", ftrace_profile_enabled);
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);

What guarantees that 'cnt' cannot be larger than ~44?

> +}
> +
> +static void ftrace_profile_reset(void)
> +{
> +	struct dyn_ftrace *rec;
> +	struct ftrace_page *pg;
> +
> +	do_for_each_ftrace_rec(pg, rec) {
> +		rec->counter = 0;
> +	} while_for_each_ftrace_rec();
> +}
> +
> +static struct dyn_ftrace *ftrace_find_profiled_func(unsigned long ip)
> +{
> +	struct dyn_ftrace *rec;
> +	struct hlist_head *hhd;
> +	struct hlist_node *n;
> +	unsigned long flags;
> +	unsigned long key;
> +
> +	if (!ftrace_profile_hash)
> +		return NULL;
> +
> +	key = hash_long(ip, ftrace_profile_bits);
> +	hhd = &ftrace_profile_hash[key];
> +
> +	if (hlist_empty(hhd))
> +		return NULL;
> +
> +	local_irq_save(flags);
> +	hlist_for_each_entry_rcu(rec, n, hhd, node) {
> +		if (rec->ip == ip)
> +			goto out;
> +	}
> +	rec = NULL;
> + out:
> +	local_irq_restore(flags);
> +
> +	return rec;
> +}

actually, this hash is a per function attribute, in disguise, 
indexed by addressed. Dont we have such a hash already: 
ftrace_func_hash?

Wouldnt it be better to refactor all this into a clean per function 
attribute hash thing. The profile counter can be allocated via 
percpu_alloc(), to keep it scalable.

> +
> +static void
> +function_profile_call(unsigned long ip, unsigned long parent_ip)
> +{
> +	struct dyn_ftrace *rec;
> +	unsigned long flags;
> +
> +	if (!ftrace_profile_enabled)
> +		return;
> +
> +	local_irq_save(flags);
> +	rec = ftrace_find_profiled_func(ip);
> +	if (!rec)
> +		goto out;
> +
> +	rec->counter++;
> + out:
> +	local_irq_restore(flags);
> +}
> +
> +static struct ftrace_ops ftrace_profile_ops __read_mostly =
> +{
> +	.func = function_profile_call,

(use vertical space consistent with other places in this file 
please.)

> +};
> +
> +static ssize_t
> +ftrace_profile_write(struct file *filp, const char __user *ubuf,
> +		     size_t cnt, loff_t *ppos)
> +{
> +	unsigned long val;
> +	char buf[64];
> +	int ret;
> +
> +	if (!ftrace_profile_hash) {
> +		pr_info("Can not enable hash due to earlier problems\n");
> +		return -ENODEV;
> +	}
> +
> +	if (cnt >= sizeof(buf))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&buf, ubuf, cnt))
> +		return -EFAULT;

cnt is always <= 64 ?

> +
> +	buf[cnt] = 0;
> +
> +	ret = strict_strtoul(buf, 10, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	val = !!val;
> +
> +	mutex_lock(&ftrace_profile_lock);
> +	if (ftrace_profile_enabled ^ val) {
> +		if (val) {
> +			ftrace_profile_reset();
> +			register_ftrace_function(&ftrace_profile_ops);
> +			ftrace_profile_enabled = 1;
> +		} else {
> +			ftrace_profile_enabled = 0;
> +			unregister_ftrace_function(&ftrace_profile_ops);
> +		}
> +	}
> +	mutex_unlock(&ftrace_profile_lock);
> +
> +	filp->f_pos += cnt;
> +
> +	return cnt;

these patterns of code are familar too. We do a lot of 
integer-option twiddlig. Helper-function potential?

> +}
> +
> +static const struct file_operations ftrace_profile_fops = {
> +	.open		= tracing_open_generic,
> +	.read		= ftrace_profile_read,
> +	.write		= ftrace_profile_write,
> +};
> +
> +static void ftrace_profile_debugfs(struct dentry *d_tracer)
> +{
> +	struct dentry *entry;
> +	int ret;
> +
> +	ret = register_stat_tracer(&function_stats);
> +	if (ret) {
> +		pr_warning("Warning: could not register "
> +			   "function stats\n");
> +		return;
> +	}
> +
> +	entry = debugfs_create_file("function_profile_enabled", 0644,
> +				    d_tracer, NULL, &ftrace_profile_fops);
> +	if (!entry)
> +		pr_warning("Could not create debugfs "
> +			   "'function_profile_enabled' entry\n");

this is a reoccuring pattern. Add tracing_create_file() perhaps, 
with an implicit pr_warning()? Would clean up quite a lot of code.

> +}
> +
> +static void ftrace_add_profile(struct dyn_ftrace *rec)
> +{
> +	unsigned long key;
> +
> +	if (!ftrace_profile_hash)
> +		return;
> +
> +	key = hash_long(rec->ip, ftrace_profile_bits);
> +	hlist_add_head_rcu(&rec->node, &ftrace_profile_hash[key]);
> +}
> +
> +static void ftrace_profile_release(struct dyn_ftrace *rec)
> +{
> +	mutex_lock(&ftrace_profile_lock);
> +	hlist_del(&rec->node);
> +	mutex_unlock(&ftrace_profile_lock);
> +}
> +
> +#else /* CONFIG_FUNCTION_PROFILER */
> +static void ftrace_profile_init(int nr_funcs)
> +{
> +}
> +static void ftrace_add_profile(struct dyn_ftrace *rec)
> +{
> +}
> +static void ftrace_profile_debugfs(struct dentry *d_tracer)
> +{
> +}
> +static void ftrace_profile_release(struct dyn_ftrace *rec)
> +{
> +}
> +#endif /* CONFIG_FUNCTION_PROFILER */
> +
>  #ifdef CONFIG_KPROBES
>  
>  static int frozen_record_count;
> @@ -359,8 +660,10 @@ void ftrace_release(void *start, unsigned long size)
>  	mutex_lock(&ftrace_lock);
>  	do_for_each_ftrace_rec(pg, rec) {
>  		if ((rec->ip >= s) && (rec->ip < e) &&
> -		    !(rec->flags & FTRACE_FL_FREE))
> +		    !(rec->flags & FTRACE_FL_FREE)) {
>  			ftrace_free_rec(rec);
> +			ftrace_profile_release(rec);
> +		}
>  	} while_for_each_ftrace_rec();
>  	mutex_unlock(&ftrace_lock);
>  }
> @@ -414,6 +717,8 @@ ftrace_record_ip(unsigned long ip)
>  	rec->newlist = ftrace_new_addrs;
>  	ftrace_new_addrs = rec;
>  
> +	ftrace_add_profile(rec);
> +
>  	return rec;
>  }
>  
> @@ -2157,6 +2462,8 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
>  			   "'set_graph_function' entry\n");
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>  
> +	ftrace_profile_debugfs(d_tracer);
> +
>  	return 0;
>  }
>  
> @@ -2225,6 +2532,8 @@ void __init ftrace_init(void)
>  	if (ret)
>  		goto failed;
>  
> +	ftrace_profile_init(count);
> +
>  	last_ftrace_enabled = ftrace_enabled = 1;
>  
>  	ret = ftrace_convert_nops(NULL,

Neat stuff ...

	Ingo
