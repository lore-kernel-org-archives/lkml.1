Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZCYTMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZCYTMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbZCYTL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:11:57 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:52067 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZCYTLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mBnD5S14iXkYUSnMNvSitg6PPoAAR+UpLuqlwCJWhq7PrX2bThb89jsG8Ir10kU6s/
         oV7V8gZbTfCl1R+RaKXFPnTAgQljuygxUetq8nochQsHedPKsYPV0N7uZtHfoWZskewx
         Grk/t183Yp2414lhO2MyVdbAOWqdSoT+9il1s=
Date: Wed, 25 Mar 2009 20:11:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5][RFC] tracing: add function profiler
Message-ID: <20090325191147.GF5932@nowhere>
References: <20090325035646.662994901@goodmis.org> <20090325040832.251748832@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325040832.251748832@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:56:47PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: new profiling feature
> 
> This patch adds a function profiler. In debugfs/tracing/ two new
> files are created.
> 
>   function_profile_enabled  - to enable or disable profiling
> 
>   trace_stat/functions   - the profiled functions.
> 
> For example:
> 
>   echo 1 > /debugfs/tracing/function_profile_enabled
>   ./hackbench 50
>   echo 0 > /debugfs/tracing/function_profile_enabled
> 
> yields:
> 
>   cat /debugfs/tracing/trace_stat/functions
> 
>   Function                               Hit
>   --------                               ---
>   _spin_lock                        10106442
>   _spin_unlock                      10097492
>   kfree                              6013704
>   _spin_unlock_irqrestore            4423941
>   _spin_lock_irqsave                 4406825
>   __phys_addr                        4181686
>   __slab_free                        4038222
>   dput                               4030130
>   path_put                           4023387
>   unroll_tree_refs                   4019532
> [...]
> 
> The most hit functions are listed first. Functions that are not
> hit are not listed.
> 
> This feature depends on and uses dynamic function tracing. When the
> function profiling is disabled, no overhead occurs. But it still
> takes up around 300KB to hold the data, thus it is not recomended
> to keep it enabled for systems low on memory.
> 
> When a '1' is echoed into the function_profile_enabled file, the
> counters for is function is reset back to zero. Thus you can see what
> functions are hit most by different programs.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/ftrace.h |    4 +
>  kernel/trace/Kconfig   |   19 +++
>  kernel/trace/ftrace.c  |  313 +++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 334 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 015a3d2..0456c3a 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -153,6 +153,10 @@ struct dyn_ftrace {
>  		unsigned long		flags;
>  		struct dyn_ftrace	*newlist;
>  	};
> +#ifdef CONFIG_FUNCTION_PROFILER
> +	unsigned long			counter;
> +	struct hlist_node		node;
> +#endif
>  	struct dyn_arch_ftrace		arch;
>  };
>  
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 8a4d729..95e9ad5 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -105,6 +105,7 @@ config FUNCTION_GRAPH_TRACER
>  	  This is done by setting the current return address on the current
>  	  task structure into a stack of calls.
>  
> +
>  config IRQSOFF_TRACER
>  	bool "Interrupts-off Latency Tracer"
>  	default n
> @@ -376,6 +377,24 @@ config DYNAMIC_FTRACE
>  	 were made. If so, it runs stop_machine (stops all CPUS)
>  	 and modifies the code to jump over the call to ftrace.
>  
> +config FUNCTION_PROFILER
> +	bool "Kernel function profiler"
> +	depends on DYNAMIC_FTRACE
> +	default n
> +	help
> +	 This option enables the kernel function profiler. When the dynamic
> +	 function tracing is enabled, a counter is added into the function
> +	 records used by the dynamic function tracer. A file is created in
> +	 debugfs called function_profile_enabled which defaults to zero.
> +	 When a 1 is echoed into this file profiling begins, and when a
> +	 zero is entered, profiling stops. A file in the trace_stats
> +	 directory called functions, that show the list of functions that
> +	 have been hit and their counters.
> +
> +	 This takes up around 320K more memory.
> +
> +	 If in doubt, say N
> +
>  config FTRACE_MCOUNT_RECORD
>  	def_bool y
>  	depends on DYNAMIC_FTRACE
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 7b8722b..11f364c 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -34,6 +34,7 @@
>  #include <asm/ftrace.h>
>  
>  #include "trace.h"
> +#include "trace_stat.h"
>  
>  #define FTRACE_WARN_ON(cond)			\
>  	do {					\
> @@ -261,7 +262,6 @@ struct ftrace_func_probe {
>  	struct rcu_head		rcu;
>  };
>  
> -
>  enum {
>  	FTRACE_ENABLE_CALLS		= (1 << 0),
>  	FTRACE_DISABLE_CALLS		= (1 << 1),
> @@ -309,6 +309,307 @@ static struct dyn_ftrace *ftrace_free_records;
>  		}				\
>  	}
>  
> +#ifdef CONFIG_FUNCTION_PROFILER
> +static struct hlist_head *ftrace_profile_hash;
> +static int ftrace_profile_bits;
> +static int ftrace_profile_enabled;
> +static DEFINE_MUTEX(ftrace_profile_lock);
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
> +
> +static ssize_t
> +ftrace_profile_read(struct file *filp, char __user *ubuf,
> +		     size_t cnt, loff_t *ppos)
> +{
> +	char buf[64];
> +	int r;
> +
> +	r = sprintf(buf, "%u\n", ftrace_profile_enabled);
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
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
> +}
> +
> +static const struct file_operations ftrace_profile_fops = {
> +	.open		= tracing_open_generic,
> +	.read		= ftrace_profile_read,
> +	.write		= ftrace_profile_write,
> +};


I should really provide such helper per stat tracer.

Say, something like:

/debug/tracing/trace_stat/name/enable

Thanks,
Frederic.


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
> -- 
> 1.6.2
> 
> -- 

