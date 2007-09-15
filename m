Return-Path: <linux-kernel-owner+w=401wt.eu-S932722AbXIOBJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbXIOBJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 21:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932131AbXIOBI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 21:08:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932126AbXIOBI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 21:08:58 -0400
Date: Fri, 14 Sep 2007 18:08:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Wilder <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, SystemTAP <systemtap@sources.redhat.com>
Subject: Re: [PATCH 1/2] Trace code and documentation
Message-Id: <20070914180840.579627ab.akpm@linux-foundation.org>
In-Reply-To: <46E9CB14.7060000@us.ibm.com>
References: <46E9CB14.7060000@us.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Trace - Provides tracing primitives
> 
> ...
>
> +config TRACE
> +	bool "Trace setup and control"
> +	select RELAY
> +	select DEBUG_FS
> +	help
> +	  This option provides support for the setup, teardown and control
> +	  of tracing channels from kernel code.  It also provides trace
> +	  information and control to userspace via a set of debugfs control
> +	  files.  If unsure, say N.
> +

select is evil - you really want to avoid using it.

The problem is where you select a symbol whose dependencies aren't met. 
Kconfig resolves this incompatibility by just not selecting the thing you
wanted, iirc.  So your CONFIG_SYSFS=n, CONFIG_TRACE=y kernel won't build.

> +/*
> + * Based on blktrace code, Copyright (C) 2006 Jens Axboe <axboe@suse.de>

So can we migrate blktrace to using this?

> +static ssize_t state_write(struct file *filp, const char __user *buffer,
> +			   size_t count, loff_t *ppos)
> +{
> +	struct trace_info *trace = filp->private_data;
> +	char buf[16] = { '\0' };

this initialisation isn't needed and will waste cycles.

> +	int ret;
> +
> +	if (trace->flags & TRACE_DISABLE_STATE)
> +		return -EINVAL;
> +	
> +	if (count > sizeof(buf) - 1)
> +		return -EINVAL;
> +
> +	if (copy_from_user(buf, buffer, count))
> +		return -EFAULT;
> +
> +	buf[count] = '\0';
> +	
> +	if (strncmp(buf, "start", strlen("start")) == 0 ) {
> +		ret = trace_start(trace);
> +		if (ret)
> +			return ret;
> +	} else if (strncmp(buffer, "stop", strlen("stop")) == 0)
> +		trace_stop(trace);
> +	else
> +		return -EINVAL;

What's the above code doing?  Trying to cope with trailing chars after
"start" or "stop"?  Is that actually needed?   It's the \n, I assume?

> +	return count;
> +}
> +
> +
> +static struct file_operations state_fops = {
> +	.owner	= THIS_MODULE,
> +	.open	= state_open,
> +	.read	= state_read,
> +	.write	= state_write,
> +};
> +
> +
> +static void remove_root(struct trace_info *trace)
> +{
> +	if (trace->root->root && simple_empty(trace->root->root)) {
> +		debugfs_remove(trace->root->root);
> +		list_del(&trace->root->list);
> +		kfree(trace->root);
> +		trace->root = NULL;
> +	}
> +}
> +
> +
> +static void remove_tree(struct trace_info *trace)
> +{
> +	mutex_lock(&trace_mutex);
> +
> +	debugfs_remove(trace->dir);
> +
> +	if (--trace->root->users == 0)
> +		remove_root(trace);
> +
> +	mutex_unlock(&trace_mutex);
> +}

We usually only put a single blank line between functions.  Two is just a
waste of screen space.

> +
> +
> +/*
> + * Creates the trace_root if it's not found.
> + */
>
> ...
>
> +static ssize_t sub_size_read(struct file *filp, char __user *buffer,
> +			     size_t count, loff_t *ppos)
> +{
> +	struct trace_info *trace = filp->private_data;
> +	char buf[32];
> +
> +	snprintf(buf, sizeof(buf), "%u\n",
> +		 (unsigned int)trace->rchan->subbuf_size);

Use %tu to print a size_t, rather than the typecast.

> +	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
> +}
> +
>
> ...
>
> +static ssize_t nr_sub_read(struct file *filp, char __user *buffer,
> +			   size_t count, loff_t *ppos)
> +{
> +	struct trace_info *trace = filp->private_data;
> +	char buf[32];
> +
> +	snprintf(buf, sizeof(buf), "%u\n",
> +		 (unsigned int)trace->rchan->n_subbufs);

Ditto.  (It's unobvious why n_subbufs is a size_t)

> +	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
> +}
> +
>
> ...
>
> +static void remove_controls(struct trace_info *trace)
> +{
> +	if (trace->state_file)
> +		debugfs_remove(trace->state_file);
> +	if (trace->dropped_file)
> +		debugfs_remove(trace->dropped_file);
> +	if (trace->reset_consumed_file)
> +		debugfs_remove(trace->reset_consumed_file);
> +	if (trace->nr_sub_file)
> +		debugfs_remove(trace->nr_sub_file);
> +	if (trace->sub_size_file)
> +		debugfs_remove(trace->sub_size_file);

debugfs_remove(NULL) is legal: all the above tests can be removed.

> +	if (trace->dir)
> +		remove_tree(trace);
> +}
> +
>
> ...
>
> + *	trace_setup: create a new trace trace handle
> + *
> + *	@root: The root directory name in the root of the debugfs
> + *	       to place trace directories. Created as needed.
> + *	@name: Trace directory name, created in @root
> + *	@buf_size: size of the relay sub-buffers
> + *	@buf_nr: number of relay sub-buffers
> + *	@flags: Option selection (see GTSC channel flags definitions)
> + *		default values when flags=0 are: use per-CPU buffering,
> + *		use non-overwrite mode. See Documentation/trace.txt for details.
> + *
> + *	returns a trace_info handle or NULL, if setup failed.
> + */
> +struct trace_info *trace_setup(const char *root, const char *name,
> +			       u32 buf_size, u32 buf_nr, u32 flags)
> +{
> +	struct trace_info *trace = NULL;
> +
> +	trace = setup_controls(root, name, flags);
> +	if (!trace)
> +		return NULL;
> +
> +	trace->buf_size = buf_size;
> +	trace->buf_nr = buf_nr;
> +	trace->flags = flags;
> +	mutex_init(&trace->state_mutex);
> +	trace->state = TRACE_SETUP;
> +
> +	return trace;
> +}
> +EXPORT_SYMBOL_GPL(trace_setup);

It's better for a pointer-returning function to return an ERR_PTR on error,
rather than NULL.  That way the caller doesn't have to make guesses about
why the callee failed when propagating back an error.  (See how your
init_module gives up and returns -1?)

> ...
>
> +
> +/**
> + *	trace_cleanup_channel: destroys the trace channel only
> + *
> + *	@trace: trace handle to cleanup
> + */
> +static void trace_cleanup_channel(struct trace_info *trace)
> +{
> +	trace_stop(trace);
> +	if (trace->rchan)
> +		relay_close(trace->rchan);

relay_close(NULL) is legal.  Please check the whole patch for this.

> +	trace->rchan = NULL;
> +}
> +
> +/**
> + *	trace_cleanup: destroys the trace channel, control files and dir
> + *
> + *	@trace: trace handle to cleanup
> + */
> +void trace_cleanup(struct trace_info *trace)
> +{
> +	trace_cleanup_channel(trace);
> +	remove_controls(trace);
> +	kfree(trace);
> +}
> +EXPORT_SYMBOL_GPL(trace_cleanup);
> 
> 
> 
