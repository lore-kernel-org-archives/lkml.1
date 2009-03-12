Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZCLPBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZCLPBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZCLPBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:01:08 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:46880 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbZCLPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:01:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nk4mRd6zSk5UEHMPO92ho4N8OhgNhSJKExI28lr4UgBCOpSOiK43/hAk+Z2htEs8eJ
         tZ02YJn9iCWyAL/wTTuQMzO05ffKoGbknxhK4LEozyxOtgbz3ZecHsNzzuXdQFD2P+rv
         RtA3bUh/nM8nl9VLXqH9FY6mKM9TYINLEPeas=
Date: Thu, 12 Mar 2009 16:01:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] tracing: keep ring buffer to minimum size till used
Message-ID: <20090312150100.GB5270@nowhere>
References: <20090312023720.144716747@goodmis.org> <20090312023936.000182747@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312023936.000182747@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 10:37:21PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: less memory impact on systems not using tracer
> 
> When the kernel boots up that has tracing configured, it allocates
> the default size of the ring buffer. This currently happens to be
> 1.4Megs per possible CPU. This is quite a bit of wasted memory if
> the system is never using the tracer.
> 
> The current solution is to keep the ring buffers to a minimum size
> until the user uses them. Once a tracer is piped into the current_tracer
> the ring buffer will be expanded to the default size. If the user
> changes the size of the ring buffer, it will take the size given
> by the user immediately.
> 
> If the user adds a "ftrace=" to the kernel command line, then the ring
> buffers will be set to the default size on initialization.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace.c |   79 +++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 59 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 4c97947..0c1dc18 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -45,6 +45,12 @@ unsigned long __read_mostly	tracing_max_latency;
>  unsigned long __read_mostly	tracing_thresh;
>  
>  /*
> + * On boot up, the ring buffer is set to the minimum size, so that
> + * we do not waste memory on systems that are not using tracing.
> + */
> +static int ring_buffer_expanded;
> +
> +/*
>   * We need to change this state when a selftest is running.
>   * A selftest will lurk into the ring-buffer to count the
>   * entries inserted during the selftest although some concurrent
> @@ -128,6 +134,8 @@ static int __init set_ftrace(char *str)
>  {
>  	strncpy(bootup_tracer_buf, str, BOOTUP_TRACER_SIZE);
>  	default_bootup_tracer = bootup_tracer_buf;
> +	/* We are using ftrace early, expand it */
> +	ring_buffer_expanded = 1;
>  	return 1;
>  }
>  __setup("ftrace=", set_ftrace);
> @@ -2315,6 +2323,40 @@ int tracer_init(struct tracer *t, struct trace_array *tr)
>  	return t->init(tr);
>  }
>  
> +static int tracing_resize_ring_buffer(unsigned long size)
> +{
> +	int ret;
> +
> +	/*
> +	 * If kernel or user changes the size of the ring buffer
> +	 * it get completed.
> +	 */

Indeed :-)

I just wonder about one thing.
Sometimes I use trace_printk to trace some events that come on bootup.
The only solution I see that could avoid me this minimum size would be
to use ftrace=nop that I sometimes use to avoid ftrace selftests.

I guess that few developers will be aware of this trick so may be
it could be worth it to explain it on the ftrace documentation and
on kernel.h (though a simple ftrace_printk as a parameter would be
more obvious, or ftrace=printk).

Anyway this patch is a very good thing, especially on embeeded systems.

Frederic.

> +	ring_buffer_expanded = 1;
> +
> +	ret = ring_buffer_resize(global_trace.buffer, size);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ring_buffer_resize(max_tr.buffer, size);
> +	if (ret < 0) {
> +		int r;
> +
> +		r = ring_buffer_resize(global_trace.buffer,
> +				       global_trace.entries);
> +		if (r < 0) {
> +			/* AARGH! We are left with different
> +			 * size max buffer!!!! */
> +			WARN_ON(1);
> +			tracing_disabled = 1;
> +		}
> +		return ret;
> +	}
> +
> +	global_trace.entries = size;
> +
> +	return ret;
> +}
> +
>  struct trace_option_dentry;
>  
>  static struct trace_option_dentry *
> @@ -2330,6 +2372,13 @@ static int tracing_set_tracer(const char *buf)
>  	struct tracer *t;
>  	int ret = 0;
>  
> +	if (!ring_buffer_expanded) {
> +		ret = tracing_resize_ring_buffer(trace_buf_size);
> +		if (ret < 0)
> +			return ret;
> +		ret = 0;
> +	}
> +
>  	mutex_lock(&trace_types_lock);
>  	for (t = trace_types; t; t = t->next) {
>  		if (strcmp(t->name, buf) == 0)
> @@ -2903,28 +2952,11 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>  	val <<= 10;
>  
>  	if (val != global_trace.entries) {
> -		ret = ring_buffer_resize(global_trace.buffer, val);
> +		ret = tracing_resize_ring_buffer(val);
>  		if (ret < 0) {
>  			cnt = ret;
>  			goto out;
>  		}
> -
> -		ret = ring_buffer_resize(max_tr.buffer, val);
> -		if (ret < 0) {
> -			int r;
> -			cnt = ret;
> -			r = ring_buffer_resize(global_trace.buffer,
> -					       global_trace.entries);
> -			if (r < 0) {
> -				/* AARGH! We are left with different
> -				 * size max buffer!!!! */
> -				WARN_ON(1);
> -				tracing_disabled = 1;
> -			}
> -			goto out;
> -		}
> -
> -		global_trace.entries = val;
>  	}
>  
>  	filp->f_pos += cnt;
> @@ -3916,6 +3948,7 @@ void ftrace_dump(void)
>  __init static int tracer_alloc_buffers(void)
>  {
>  	struct trace_array_cpu *data;
> +	int ring_buf_size;
>  	int i;
>  	int ret = -ENOMEM;
>  
> @@ -3928,12 +3961,18 @@ __init static int tracer_alloc_buffers(void)
>  	if (!alloc_cpumask_var(&tracing_reader_cpumask, GFP_KERNEL))
>  		goto out_free_tracing_cpumask;
>  
> +	/* To save memory, keep the ring buffer size to its minimum */
> +	if (ring_buffer_expanded)
> +		ring_buf_size = trace_buf_size;
> +	else
> +		ring_buf_size = 1;
> +
>  	cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
>  	cpumask_copy(tracing_cpumask, cpu_all_mask);
>  	cpumask_clear(tracing_reader_cpumask);
>  
>  	/* TODO: make the number of buffers hot pluggable with CPUS */
> -	global_trace.buffer = ring_buffer_alloc(trace_buf_size,
> +	global_trace.buffer = ring_buffer_alloc(ring_buf_size,
>  						   TRACE_BUFFER_FLAGS);
>  	if (!global_trace.buffer) {
>  		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
> @@ -3944,7 +3983,7 @@ __init static int tracer_alloc_buffers(void)
>  
>  
>  #ifdef CONFIG_TRACER_MAX_TRACE
> -	max_tr.buffer = ring_buffer_alloc(trace_buf_size,
> +	max_tr.buffer = ring_buffer_alloc(ring_buf_size,
>  					     TRACE_BUFFER_FLAGS);
>  	if (!max_tr.buffer) {
>  		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
> -- 
> 1.6.1.3
> 
> -- 

