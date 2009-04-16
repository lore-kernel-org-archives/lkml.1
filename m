Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbZDPPzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbZDPPzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbZDPPyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:54:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:44430 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734AbZDPPyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:54:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VLLJwGaWX+F2ChjBw00fOx17Os/e9ZAQfV47GlRtbt1ECZ33EFD4fwsHk+Mp3VFyIp
         4dGymeO9x8AhQUdRHYVibPsPS3lI+9kVPP6kbOfu+Mu9EzHOCXCJr8r3usT5UOFfsiq6
         P1KOpbfmBDf238G+ueqQuLYSg1TKUgL9meP1o=
Date: Thu, 16 Apr 2009 17:54:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Avadh Patel <avadh4all@gmail.com>
Subject: Re: [PATCH 5/5] tracing: add saved_cmdlines file to show cached
	task comms
Message-ID: <20090416155444.GD6004@nowhere>
References: <20090416021830.556671772@goodmis.org> <20090416021928.956953374@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416021928.956953374@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 10:18:35PM -0400, Steven Rostedt wrote:
> From: Avadh Patel <avadh4all@gmail.com>
> 
> Export the cached task comms to userspace. This allows user apps to translate
> the pids from a trace into their respective task command lines.


Hi,

I don't understand why this is needed. The pid is already resolved
to its task comm into the trace.

Or is there another reason?

Frederic.



 
> [ added error checking and use of buf pointer to index file_buf
>     - Steven Rostedt ]
> 
> Signed-off-by: Avadh Patel <avadh4all@gmail.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 53 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 2d69b26..031c46f 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2422,6 +2422,56 @@ static const struct file_operations tracing_readme_fops = {
>  };
>  
>  static ssize_t
> +tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
> +				size_t cnt, loff_t *ppos)
> +{
> +	char *buf_comm;
> +	char *file_buf;
> +	char *buf;
> +	int len = 0;
> +	int pid;
> +	int i;
> +
> +	file_buf = kmalloc(SAVED_CMDLINES*(16+TASK_COMM_LEN), GFP_KERNEL);
> +	if (!file_buf)
> +		return -ENOMEM;
> +
> +	buf_comm = kmalloc(TASK_COMM_LEN, GFP_KERNEL);
> +	if (!buf_comm) {
> +		kfree(file_buf);
> +		return -ENOMEM;
> +	}
> +
> +	buf = file_buf;
> +
> +	for (i = 0; i < SAVED_CMDLINES; i++) {
> +		int r;
> +
> +		pid = map_cmdline_to_pid[i];
> +		if (pid == -1 || pid == NO_CMDLINE_MAP)
> +			continue;
> +
> +		trace_find_cmdline(pid, buf_comm);
> +		r = sprintf(buf, "%d %s\n", pid, buf_comm);
> +		buf += r;
> +		len += r;
> +	}
> +
> +	len = simple_read_from_buffer(ubuf, cnt, ppos,
> +				      file_buf, len);
> +
> +	kfree(file_buf);
> +	kfree(buf_comm);
> +
> +	return len;
> +}
> +
> +static const struct file_operations tracing_saved_cmdlines_fops = {
> +    .open       = tracing_open_generic,
> +    .read       = tracing_saved_cmdlines_read,
> +};
> +
> +static ssize_t
>  tracing_ctrl_read(struct file *filp, char __user *ubuf,
>  		  size_t cnt, loff_t *ppos)
>  {
> @@ -3973,6 +4023,9 @@ static __init int tracer_init_debugfs(void)
>  	trace_create_file("trace_marker", 0220, d_tracer,
>  			NULL, &tracing_mark_fops);
>  
> +	trace_create_file("saved_cmdlines", 0444, d_tracer,
> +			NULL, &tracing_saved_cmdlines_fops);
> +
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
>  			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
> -- 
> 1.6.2.1
> 
> -- 

