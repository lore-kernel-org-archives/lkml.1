Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbZBYDsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbZBYDsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 22:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZBYDry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 22:47:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412AbZBYDrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 22:47:52 -0500
Date: Tue, 24 Feb 2009 19:45:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-Id: <20090224194548.3effb746.akpm@linux-foundation.org>
In-Reply-To: <20090225025753.798204550@goodmis.org>
References: <20090225025608.956691460@goodmis.org>
	<20090225025753.798204550@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 21:56:10 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch creates the event tracing infrastructure of ftrace.
> It will create the files:
> 
>  /debug/tracing/available_events
>  /debug/tracing/set_event
> 
> The available_events will list the trace points that have been
> registered with the event tracer.
> 
> set_events will allow the user to enable or disable an event hook.
> 
> example:
> 
>  # echo sched_wakeup > /debug/tracing/set_event
> 
> Will enable the sched_wakeup event (if it is registered).
> 
>  # echo "!sched_wakeup" >> /debug/tracing/set_event
> 
> Will disable the sched_wakeup event (and only that event).

Why not

echo sched_wakeup > /debug/tracing/set_event
echo sched_wakeup > /debug/tracing/clear_event

?

>  # echo > /debug/tracing/set_event
> 
> Will disable all events (notice the '>')

echo 1 > /debug/tracing/clear_all_events

?

>  # cat /debug/tracing/available_events > /debug/tracing/set_event
> 
> Will enable all registered event hooks.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/asm-generic/vmlinux.lds.h |   11 ++-
>  kernel/trace/Kconfig              |    9 ++
>  kernel/trace/Makefile             |    1 +
>  kernel/trace/trace_events.c       |  280 +++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_events.h       |   52 +++++++
>  5 files changed, 352 insertions(+), 1 deletions(-)
>  create mode 100644 kernel/trace/trace_events.c
>  create mode 100644 kernel/trace/trace_events.h
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index c61fab1..0add6b2 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -61,6 +61,14 @@
>  #define BRANCH_PROFILE()
>  #endif
>  
> +#ifdef CONFIG_EVENT_TRACER
> +#define FTRACE_EVENTS()	VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
> +			*(_ftrace_events)				\
> +			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
> +#else
> +#define FTRACE_EVENTS()
> +#endif
> +
>  /* .data section */
>  #define DATA_DATA							\
>  	*(.data)							\
> @@ -81,7 +89,8 @@
>  	*(__tracepoints)						\
>  	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
>  	LIKELY_PROFILE()		       				\
> -	BRANCH_PROFILE()
> +	BRANCH_PROFILE()						\
> +	FTRACE_EVENTS()
>  
>  #define RO_DATA(align)							\
>  	. = ALIGN((align));						\
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 07877f4..999c6a2 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -159,6 +159,15 @@ config CONTEXT_SWITCH_TRACER
>  	  This tracer gets called from the context switch and records
>  	  all switching of tasks.
>  
> +config EVENT_TRACER
> +	bool "Trace various events in the kernel"
> +	depends on DEBUG_KERNEL
> +	select TRACING
> +	help
> +	  This tracer hooks to various trace points in the kernel
> +	  allowing the user to pick and choose which trace point they
> +	  want to trace.
> +
>  config BOOT_TRACER
>  	bool "Trace boot initcalls"
>  	depends on DEBUG_KERNEL
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 627090b..c736356 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -38,5 +38,6 @@ obj-$(CONFIG_POWER_TRACER) += trace_power.o
>  obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
>  obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
>  obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
> +obj-$(CONFIG_EVENT_TRACER) += trace_events.o
>  
>  libftrace-y := ftrace.o
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> new file mode 100644
> index 0000000..05bc80e
> --- /dev/null
> +++ b/kernel/trace/trace_events.c
> @@ -0,0 +1,280 @@
> +/*
> + * event tracer
> + *
> + * Copyright (C) 2008 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + *
> + */
> +
> +#include <linux/debugfs.h>
> +#include <linux/uaccess.h>
> +#include <linux/module.h>
> +#include <linux/ctype.h>
> +
> +#include "trace_events.h"
> +
> +void event_trace_printk(unsigned long ip, const char *fmt, ...)
> +{
> +	va_list ap;
> +
> +	va_start(ap, fmt);
> +	tracing_record_cmdline(current);
> +	trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
> +	va_end(ap);
> +}
> +
> +static void ftrace_clear_events(void)
> +{
> +	struct ftrace_event_call *call = (void *)__start_ftrace_events;

__start_ftrace_events has type `unsigned long'.  It is instantiated by
the linker.  There's a very old unix convention tha tthese things have
type `int'.  Doesn't matter.

It's a bit strange to do the double-cast like this - one explicit, one
implicit.  Doesn't matter much.

> +
> +

The patch adds various random \n\n's

> +	while ((unsigned long)call < (unsigned long)__stop_ftrace_events) {
> +

and various random \n's

> +		if (call->enabled) {
> +			call->enabled = 0;
> +			call->unregfunc();
> +		}
> +		call++;
> +	}
> +}
> +
> +static int ftrace_set_clr_event(char *buf, int set)
> +{
> +	struct ftrace_event_call *call = (void *)__start_ftrace_events;
> +
> +
> +	while ((unsigned long)call < (unsigned long)__stop_ftrace_events) {
> +
> +		if (strcmp(buf, call->name) != 0) {
> +			call++;
> +			continue;
> +		}
> +
> +		if (set) {
> +			/* Already set? */
> +			if (call->enabled)
> +				return 0;
> +			call->enabled = 1;
> +			call->regfunc();
> +		} else {
> +			/* Already cleared? */
> +			if (!call->enabled)
> +				return 0;
> +			call->enabled = 0;
> +			call->unregfunc();
> +		}
> +		return 0;
> +	}
> +	return -EINVAL;
> +}

I spose if I looked at this and surrounding code enough, I could work
out what it's for.

> +/* 128 should be much more than enough */
> +#define EVENT_BUF_SIZE		127
> +
> +static ssize_t
> +ftrace_event_write(struct file *file, const char __user *ubuf,
> +		   size_t cnt, loff_t *ppos)
> +{
> +	size_t read = 0;
> +	int i, set = 1;
> +	ssize_t ret;
> +	char *buf;
> +	char ch;
> +
> +	if (!cnt || cnt < 0)
> +		return 0;

cnt is unsigned, and I don't think the VFS lets through either zero or
-ve counts (I always forget).

> +	ret = get_user(ch, ubuf++);
> +	if (ret)
> +		return ret;
> +	read++;
> +	cnt--;
> +
> +	/* skip white space */
> +	while (cnt && isspace(ch)) {
> +		ret = get_user(ch, ubuf++);
> +		if (ret)
> +			return ret;
> +		read++;
> +		cnt--;
> +	}
> +
> +	/* Only white space found? */
> +	if (isspace(ch)) {
> +		file->f_pos += read;
> +		ret = read;
> +		return ret;
> +	}
> +
> +	buf = kmalloc(EVENT_BUF_SIZE+1, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	if (cnt > EVENT_BUF_SIZE)
> +		cnt = EVENT_BUF_SIZE;
> +
> +	i = 0;
> +	while (cnt && !isspace(ch)) {
> +		if (!i && ch == '!')
> +			set = 0;
> +		else
> +			buf[i++] = ch;
> +
> +		ret = get_user(ch, ubuf++);
> +		if (ret)
> +			goto out_free;
> +		read++;
> +		cnt--;
> +	}
> +	buf[i] = 0;

Gad, what a lot of stuff.

Use strncpy_from_user()?

Use strstrip()?

Why do we care about leading and trailing whitespace - user error!

Then we can use sysfs_streq().

If we really really need to do all this, how's about positioning it as
a general copy_string_from_userspace_then_trim_the_ends() for other
callsites to use?

> +	file->f_pos += read;
> +
> +	ret = ftrace_set_clr_event(buf, set);
> +	if (ret)
> +		goto out_free;
> +
> +	ret = read;
> +
> + out_free:
> +	kfree(buf);
> +
> +	return ret;
> +}
>
> ..
>
>
> +static int
> +ftrace_event_seq_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +	const struct seq_operations *seq_ops;
> +
> +	if ((file->f_mode & FMODE_WRITE) &&
> +	    !(file->f_flags & O_APPEND))
> +		ftrace_clear_events();
> +
> +	seq_ops = inode->i_private;
> +	ret = seq_open(file, seq_ops);
> +	if (!ret) {
> +		struct seq_file *m = file->private_data;
> +
> +		m->private = __start_ftrace_events;
> +	}
> +	return ret;
> +}

It would be nice if the code were to somewhere document the userspace
interface which it is attempting to implement.  It's a bit hard to
follow if the reader doesn't already know this.


