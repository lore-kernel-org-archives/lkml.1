Return-Path: <linux-kernel-owner+w=401wt.eu-S1759071AbZEADJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbZEADJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 23:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbZEADIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 23:08:53 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:45283 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZEADIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 23:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UTsKk5bMYQYWUrmxeu7JzH7J/AccKddIUcXb2L0GEvAhwRaZWh+uw+hjAEtKJeCrDM
         yAotsohuytU+pY2JUHWaQ/HjUJSxYprqNAsrrA79S4sa0HxpF7WMa4v2bZw20XHLznMc
         D/5RxCMeAN+ZWjRBSc4BLsae3/IhtExV3i24Y=
Date: Fri, 1 May 2009 05:08:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] tracing: export stats of ring buffers to userspace
Message-ID: <20090501030848.GA19883@nowhere>
References: <20090501022210.851418183@goodmis.org> <20090501022402.302620162@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501022402.302620162@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 10:22:12PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch adds stats to the ftrace ring buffers:
> 
>  # cat /debugfs/tracing/per_cpu/cpu0/stats
>  entries: 42360
>  overrun: 30509326
>  commit overrun: 0
>  nmi dropped: 0
> 
> Where entries are the total number of data entries in the buffer.
> 
> overrun is the number of entries not consumed and were overwritten by
> the writer.
> 
> commit overrun is the number of entries dropped due to nested writers
> wrapping the buffer before the initial writer finished the commit.


I feel a bit confused with this one.
How such a thing can happen? The write page and the commit page
are not the same. So is that because we can have (ring-buffer inspires
all of us to try ascii-art):


          Write page                      Commit page (which becomes new write page) 
------------------------------------ -----------------
            |           |          | |               |
  Writer 1  | Writer 2  | Writer n | | Writer n + 1  | .....
  reserved  | reserved  | reserved | | reserved      |
-----------------------------------  ----------------
    |                                             ^
    |                                             |
    ---------------- Was supposed to commit here--|
 

I know this is silly, my picture seem to show a data copy whereas
the ring buffer deals with page pointers.
But the commit page on the ring buffer is a mistery for me.
Just because you haven't drawn in in ascii in your comments :)

Thanks.
Frederic.

> nmi dropped is the number of entries dropped due to the ring buffer
> lock being held when an nmi was going to write to the ring buffer.
> Note, this field will be meaningless and will go away when the ring
> buffer becomes lockless.
> 
> [ Impact: let userspace know what is happening in the ring buffers ]
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 42 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index f5427e0..74df029 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3595,6 +3595,45 @@ static const struct file_operations tracing_buffers_fops = {
>  	.llseek		= no_llseek,
>  };
>  
> +static ssize_t
> +tracing_stats_read(struct file *filp, char __user *ubuf,
> +		   size_t count, loff_t *ppos)
> +{
> +	unsigned long cpu = (unsigned long)filp->private_data;
> +	struct trace_array *tr = &global_trace;
> +	struct trace_seq *s;
> +	unsigned long cnt;
> +
> +	s = kmalloc(sizeof(*s), GFP_ATOMIC);
> +	if (!s)
> +		return ENOMEM;
> +
> +	trace_seq_init(s);
> +
> +	cnt = ring_buffer_entries_cpu(tr->buffer, cpu);
> +	trace_seq_printf(s, "entries: %ld\n", cnt);
> +
> +	cnt = ring_buffer_overrun_cpu(tr->buffer, cpu);
> +	trace_seq_printf(s, "overrun: %ld\n", cnt);
> +
> +	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
> +	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
> +
> +	cnt = ring_buffer_nmi_dropped_cpu(tr->buffer, cpu);
> +	trace_seq_printf(s, "nmi dropped: %ld\n", cnt);
> +
> +	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
> +
> +	kfree(s);
> +
> +	return count;
> +}
> +
> +static const struct file_operations tracing_stats_fops = {
> +	.open		= tracing_open_generic,
> +	.read		= tracing_stats_read,
> +};
> +
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  
>  int __weak ftrace_arch_read_dyn_info(char *buf, int size)
> @@ -3708,6 +3747,9 @@ static void tracing_init_debugfs_percpu(long cpu)
>  
>  	trace_create_file("trace_pipe_raw", 0444, d_cpu,
>  			(void *) cpu, &tracing_buffers_fops);
> +
> +	trace_create_file("stats", 0444, d_cpu,
> +			(void *) cpu, &tracing_stats_fops);
>  }
>  
>  #ifdef CONFIG_FTRACE_SELFTEST
> -- 
> 1.6.2.1
> 
> -- 

