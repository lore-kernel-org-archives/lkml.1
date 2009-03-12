Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZCLDbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZCLDbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 23:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZCLDbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 23:31:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbZCLDbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:31:12 -0400
Date: Wed, 11 Mar 2009 20:26:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] tracing: keep ring buffer to minimum size till used
Message-Id: <20090311202637.d8c2343b.akpm@linux-foundation.org>
In-Reply-To: <20090312023936.000182747@goodmis.org>
References: <20090312023720.144716747@goodmis.org>
	<20090312023936.000182747@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 22:37:21 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

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

That comment needs help.

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

So does that one, but at least it's understandable ;)

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

This would look a bit less racy were it to happen inside the lock.

>  	mutex_lock(&trace_types_lock);
>  	for (t = trace_types; t; t = t->next) {
>  		if (strcmp(t->name, buf) == 0)

