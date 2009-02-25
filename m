Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbZBYHAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbZBYHAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZBYG76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 01:59:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:35298 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbZBYG75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 01:59:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=yEwhCQf+kKGTtCYuAd/3VnfTEAYFozEtVBjOCWR7iZHpCmBLiFjvT0nPc78QX0qiWO
         0IeyVYHZZs9xpuj1QXwToPywH3xjbggOm4zVpGWNDmtspskBMi6gh0xAfF+9COP4THZp
         fGqW1LWTF8WTWM2dbAQUndHgMH9Slg/23tDN0=
Date: Wed, 25 Feb 2009 07:59:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] tracing: make event directory structure
Message-ID: <20090225065948.GA5200@nowhere>
References: <20090225025608.956691460@goodmis.org> <20090225025754.297578658@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225025754.297578658@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 09:56:12PM -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch adds the directory /debug/tracing/events/ that will contain
> all the registered trace points.
> 
>  # ls /debug/tracing/events/
> sched_kthread_stop      sched_process_fork  sched_switch
> sched_kthread_stop_ret  sched_process_free  sched_wait_task
> sched_migrate_task      sched_process_wait  sched_wakeup
> sched_process_exit      sched_signal_send   sched_wakeup_new
> 
>  # ls /debug/tracing/events/sched_switch/
> enable
> 
>  # cat /debug/tracing/events/sched_switch/enable
> 1
> 
>  # cat /debug/tracing/set_event
> sched_switch


Do you plan to add other things inside these events directory?
I mean, if you plan to only put an enable file on each of them,
it would be better to have just one file:

cat /debug/tracing/events/sched_switch
1

 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace_events.c |  137 +++++++++++++++++++++++++++++++++++++++++--
>  kernel/trace/trace_events.h |    7 ++-
>  2 files changed, 137 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 05bc80e..3bcb9df 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -12,6 +12,11 @@
>  
>  #include "trace_events.h"
>  
> +#define events_for_each(event)						\
> +	for (event = __start_ftrace_events;				\
> +	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
> +	     event++)
> +


The name for_each_events seems to me more intuitive, but it's just
a matter of taste.


Frederic.

>  void event_trace_printk(unsigned long ip, const char *fmt, ...)
>  {
>  	va_list ap;
> @@ -39,15 +44,16 @@ static void ftrace_clear_events(void)
>  
>  static int ftrace_set_clr_event(char *buf, int set)
>  {
> -	struct ftrace_event_call *call = (void *)__start_ftrace_events;
> +	struct ftrace_event_call *call = __start_ftrace_events;
>  
>  
> -	while ((unsigned long)call < (unsigned long)__stop_ftrace_events) {
> +	events_for_each(call) {
>  
> -		if (strcmp(buf, call->name) != 0) {
> -			call++;
> +		if (!call->name)
> +			continue;
> +
> +		if (strcmp(buf, call->name) != 0)
>  			continue;
> -		}
>  
>  		if (set) {
>  			/* Already set? */
> @@ -223,6 +229,67 @@ ftrace_event_seq_open(struct inode *inode, struct file *file)
>  	return ret;
>  }
>  
> +static ssize_t
> +event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
> +		  loff_t *ppos)
> +{
> +	struct ftrace_event_call *call = filp->private_data;
> +	char *buf;
> +
> +	if (call->enabled)
> +		buf = "1\n";
> +	else
> +		buf = "0\n";
> +
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
> +}
> +
> +static ssize_t
> +event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
> +		   loff_t *ppos)
> +{
> +	struct ftrace_event_call *call = filp->private_data;
> +	char buf[64];
> +	unsigned long val;
> +	int ret;
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
> +	switch (val) {
> +	case 0:
> +		if (!call->enabled)
> +			break;
> +
> +		call->enabled = 0;
> +		call->unregfunc();
> +		break;
> +	case 1:
> +		if (call->enabled)
> +			break;
> +
> +		call->enabled = 1;
> +		call->regfunc();
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	*ppos += cnt;
> +
> +	return cnt;
> +}
> +
>  static const struct seq_operations show_event_seq_ops = {
>  	.start = t_start,
>  	.next = t_next,
> @@ -252,10 +319,59 @@ static const struct file_operations ftrace_set_event_fops = {
>  	.release = seq_release,
>  };
>  
> +static const struct file_operations ftrace_enable_fops = {
> +	.open = tracing_open_generic,
> +	.read = event_enable_read,
> +	.write = event_enable_write,
> +};
> +
> +static struct dentry *event_trace_events_dir(void)
> +{
> +	static struct dentry *d_tracer;
> +	static struct dentry *d_events;
> +
> +	if (d_events)
> +		return d_events;
> +
> +	d_tracer = tracing_init_dentry();
> +	if (!d_tracer)
> +		return NULL;
> +
> +	d_events = debugfs_create_dir("events", d_tracer);
> +	if (!d_events)
> +		pr_warning("Could not create debugfs "
> +			   "'events' directory\n");
> +
> +	return d_events;
> +}
> +
> +static int
> +event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
> +{
> +	struct dentry *entry;
> +
> +	call->dir = debugfs_create_dir(call->name, d_events);
> +	if (!call->dir) {
> +		pr_warning("Could not create debugfs "
> +			   "'%s' directory\n", call->name);
> +		return -1;
> +	}
> +
> +	entry = debugfs_create_file("enable", 0644, call->dir, call,
> +				    &ftrace_enable_fops);
> +	if (!entry)
> +		pr_warning("Could not create debugfs "
> +			   "'%s/enable' entry\n", call->name);
> +
> +	return 0;
> +}
> +
>  static __init int event_trace_init(void)
>  {
> +	struct ftrace_event_call *call = __start_ftrace_events;
>  	struct dentry *d_tracer;
>  	struct dentry *entry;
> +	struct dentry *d_events;
>  
>  	d_tracer = tracing_init_dentry();
>  	if (!d_tracer)
> @@ -275,6 +391,17 @@ static __init int event_trace_init(void)
>  		pr_warning("Could not create debugfs "
>  			   "'set_event' entry\n");
>  
> +	d_events = event_trace_events_dir();
> +	if (!d_events)
> +		return 0;
> +
> +	events_for_each(call) {
> +		/* The linker may leave blanks */
> +		if (!call->name)
> +			continue;
> +		event_create_dir(call, d_events);
> +	}
> +
>  	return 0;
>  }
>  fs_initcall(event_trace_init);
> diff --git a/kernel/trace/trace_events.h b/kernel/trace/trace_events.h
> index 39342f8..cb8455b 100644
> --- a/kernel/trace/trace_events.h
> +++ b/kernel/trace/trace_events.h
> @@ -1,11 +1,13 @@
>  #ifndef _LINUX_KERNEL_TRACE_EVENTS_H
>  #define _LINUX_KERNEL_TRACE_EVENTS_H
>  
> +#include <linux/debugfs.h>
>  #include <linux/ftrace.h>
>  #include "trace.h"
>  
>  struct ftrace_event_call {
>  	char		*name;
> +	struct dentry	*dir;
>  	int		enabled;
>  	int		(*regfunc)(void);
>  	void		(*unregfunc)(void);
> @@ -39,6 +41,7 @@ static void ftrace_unreg_event_##call(void)				\
>  }									\
>  									\
>  static struct ftrace_event_call __used					\
> +__attribute__((__aligned__(4)))						\
>  __attribute__((section("_ftrace_events"))) event_##call = {		\
>  	.name 			= #call,				\
>  	.regfunc		= ftrace_reg_event_##call,		\
> @@ -46,7 +49,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>  }
>  
>  void event_trace_printk(unsigned long ip, const char *fmt, ...);
> -extern unsigned long __start_ftrace_events[];
> -extern unsigned long __stop_ftrace_events[];
> +extern struct ftrace_event_call __start_ftrace_events[];
> +extern struct ftrace_event_call __stop_ftrace_events[];
>  
>  #endif /* _LINUX_KERNEL_TRACE_EVENTS_H */
> -- 
> 1.5.6.5
> 
> -- 

