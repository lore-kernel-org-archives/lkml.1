Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbZCSU0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbZCSU0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZCSU0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:26:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:31780 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbZCSU0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CfMfQXDjX6SoBlE1dePL+rzU1Owuebc3A/tZRQK5hR6yCb2HpKjMXM8AYrqRiyBeWd
         XGlamb+d+ygOAmnBOtB5+8RCv23WZwePlTV3bTwcV6uq3MiwH2odDbAnnPVYurF4F9tH
         OYTqeygOY4vJiWeIAFGr7d12wkVQksUqY1a2M=
Date: Thu, 19 Mar 2009 21:26:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/7] tracing: give easy way to clear trace buffer
Message-ID: <20090319202631.GA5935@nowhere>
References: <20090319200122.512803803@goodmis.org> <20090319200159.932486704@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319200159.932486704@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 04:01:23PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> There is currently no easy way to clear the trace buffer. Currently
> the only way is to change the current tracer.
> 
> This patch lets the user clear the trace buffer by simply writing
> into the trace files.
> 
>  echo > /debug/tracing/trace
> 
> or to clear a single cpu (i.e. for CPU 1):
> 
>  echo > /debug/tracing/per_cpu/cpu1/trace
> 
> Requested-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace.c |   41 +++++++++++++++++++++++++++++++++--------
>  1 files changed, 33 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index a2d13e8..8d981ab 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1941,9 +1941,14 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
>  static int tracing_release(struct inode *inode, struct file *file)
>  {
>  	struct seq_file *m = (struct seq_file *)file->private_data;
> -	struct trace_iterator *iter = m->private;
> +	struct trace_iterator *iter;
>  	int cpu;
>  
> +	if (!(file->f_mode & FMODE_READ))
> +		return 0;
> +
> +	iter = m->private;
> +
>  	mutex_lock(&trace_types_lock);
>  	for_each_tracing_cpu(cpu) {
>  		if (iter->buffer_iter[cpu])
> @@ -1969,12 +1974,24 @@ static int tracing_open(struct inode *inode, struct file *file)
>  	struct trace_iterator *iter;
>  	int ret = 0;
>  
> -	iter = __tracing_open(inode, file);
> -	if (IS_ERR(iter))
> -		ret = PTR_ERR(iter);
> -	else if (trace_flags & TRACE_ITER_LATENCY_FMT)
> -		iter->iter_flags |= TRACE_FILE_LAT_FMT;
> +	/* If this file was open for write, then erase contents */
> +	if ((file->f_mode & FMODE_WRITE) &&
> +	    !(file->f_flags & O_APPEND)) {
> +		long cpu = (long) inode->i_private;
> +
> +		if (cpu == TRACE_PIPE_ALL_CPU)
> +			tracing_reset_online_cpus(&global_trace);
> +		else
> +			tracing_reset(&global_trace, cpu);
> +	}
>  
> +	if (file->f_mode & FMODE_READ) {
> +		iter = __tracing_open(inode, file);
> +		if (IS_ERR(iter))
> +			ret = PTR_ERR(iter);
> +		else if (trace_flags & TRACE_ITER_LATENCY_FMT)
> +			iter->iter_flags |= TRACE_FILE_LAT_FMT;
> +	}
>  	return ret;
>  }
>  
> @@ -2049,9 +2066,17 @@ static int show_traces_open(struct inode *inode, struct file *file)
>  	return ret;
>  }
>  
> +static ssize_t
> +tracing_write_stub(struct file *filp, const char __user *ubuf,
> +		   size_t count, loff_t *ppos)
> +{
> +	return count;
> +}


Is this one necessary?
I guess debugfs or vfs layers already provide a stub for write. No?

Anyway, that's a small detail for this good patch idea.

Frederic.


>  static const struct file_operations tracing_fops = {
>  	.open		= tracing_open,
>  	.read		= seq_read,
> +	.write		= tracing_write_stub,
>  	.llseek		= seq_lseek,
>  	.release	= tracing_release,
>  };
> @@ -3576,7 +3601,7 @@ static void tracing_init_debugfs_percpu(long cpu)
>  		pr_warning("Could not create debugfs 'trace_pipe' entry\n");
>  
>  	/* per cpu trace */
> -	entry = debugfs_create_file("trace", 0444, d_cpu,
> +	entry = debugfs_create_file("trace", 0644, d_cpu,
>  				(void *) cpu, &tracing_fops);
>  	if (!entry)
>  		pr_warning("Could not create debugfs 'trace' entry\n");
> @@ -3890,7 +3915,7 @@ static __init int tracer_init_debugfs(void)
>  	if (!entry)
>  		pr_warning("Could not create debugfs 'tracing_cpumask' entry\n");
>  
> -	entry = debugfs_create_file("trace", 0444, d_tracer,
> +	entry = debugfs_create_file("trace", 0644, d_tracer,
>  				 (void *) TRACE_PIPE_ALL_CPU, &tracing_fops);
>  	if (!entry)
>  		pr_warning("Could not create debugfs 'trace' entry\n");
> -- 
> 1.6.2
> 
> -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

