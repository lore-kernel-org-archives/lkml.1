Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0BWVo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 16:44:57 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51292 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab0BWVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 16:44:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MpMS9P59jgLoCCzQA7NtooUaA1XYYDlUGnQkmlfV5ooziSt5kYsClzj1TxuWvFX59D
         q/mJWaEg/+HHnJNPENQw9+1AxhAnIETaqvL/t+RxRXHTeaQsu8k/HWQxfvaopq1YHp6+
         03uwSxeuxV8/EFy7tYMe7Wnj89J3dsgMUI37E=
Date: Tue, 23 Feb 2010 22:44:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: Re: [PATCH 08/12] perf: export some syscall metadata
Message-ID: <20100223214445.GF5357@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com> <1264580883-15324-9-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264580883-15324-9-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 02:27:59AM -0600, Tom Zanussi wrote:
> Create and export a list of syscall_nr:syscall_name pairs from the
> data in the syscalls_metadata, for use initially by perf trace.
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>



I would have much more preferred we inject a kind of "syscall_map"
event for that. Unfortunately the event injection is still
in discussion and not yet ready.


I guess we can take this temporary solution and remove that
later in profit of injected events. It means we'll need to
keep support for that file though.


Hmm...



> ---
>  kernel/trace/trace_syscalls.c |   87 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 87 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index f6b0712..e037486 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -626,5 +626,92 @@ void prof_sysexit_disable(struct ftrace_event_call *call)
>  	mutex_unlock(&syscall_trace_lock);
>  }
>  
> +struct syscall_metadata **meta_skip(struct syscall_metadata **meta,
> +				    loff_t *pos)
> +{
> +	struct syscall_metadata **end = syscalls_metadata + NR_syscalls;
> +
> +	do {
> +		meta++;
> +		(*pos)++;
> +	} while (meta < end && *meta == NULL);
> +
> +	if (meta >= end)
> +		meta = NULL;
> +
> +	return meta;
> +}
> +
> +static void *syscall_map_start(struct seq_file *s, loff_t *pos)
> +{
> +	struct syscall_metadata **end = syscalls_metadata + NR_syscalls;
> +	struct syscall_metadata **meta = syscalls_metadata + *pos;
> +
> +	if (meta >= end)
> +		return NULL;
> +
> +	if (*meta == NULL)
> +		meta = meta_skip(meta, pos);
> +
> +	return meta;
> +}
> +
> +static void *syscall_map_next(struct seq_file *s, void *v, loff_t *pos)
> +{
> +	(*pos)++;
> +
> +	return syscall_map_start(s, pos);
> +}
> +
> +static int syscall_map_show(struct seq_file *s, void *v)
> +{
> +	const struct syscall_metadata **meta = v;
> +	const struct syscall_metadata *m = *meta;
> +
> +	seq_printf(s, "%d:", m->syscall_nr);
> +	seq_printf(s, "%s\n", m->name);
> +
> +	return 0;
> +}
> +
> +static void syscall_map_stop(struct seq_file *m, void *p)
> +{
> +}
> +
> +static const struct seq_operations show_syscall_map_seq_ops = {
> +	.start = syscall_map_start,
> +	.next = syscall_map_next,
> +	.show = syscall_map_show,
> +	.stop = syscall_map_stop,
> +};
> +
> +static int syscall_map_open(struct inode *inode, struct file *file)
> +{
> +	return seq_open(file, &show_syscall_map_seq_ops);
> +}
> +
> +static const struct file_operations syscall_map_fops = {
> +	.open = syscall_map_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = seq_release,
> +};
> +
> +static __init int init_syscall_map(void)
> +{
> +	struct dentry *d_tracer;
> +
> +	d_tracer = tracing_init_dentry();
> +	if (!d_tracer)
> +		return 0;
> +
> +	trace_create_file("syscall_map", 0444, d_tracer,
> +			  NULL, &syscall_map_fops);
> +
> +	return 0;
> +}
> +
> +fs_initcall(init_syscall_map);
> +
>  #endif /* CONFIG_PERF_EVENTS */
>  
> -- 
> 1.6.4.GIT
> 

