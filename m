Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbXGDDhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbXGDDhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 23:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbXGDDhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 23:37:25 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:59226 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754670AbXGDDhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 23:37:24 -0400
Date: Tue, 3 Jul 2007 23:37:21 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Tom Zanussi <zanussi@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, dwilder@us.ibm.com,
       hunt@redhat.com
Subject: Re: [RFC PATCH 2/3] Generic Trace Setup and Control (GTSC) code
Message-ID: <20070704033721.GB24590@Krystal>
References: <1183173872.24291.144.camel@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1183173872.24291.144.camel@ubuntu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:27:00 up 2 days, 22:09,  4 users,  load average: 0.21, 0.33, 0.23
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please see comments below,

* Tom Zanussi (zanussi@us.ibm.com) wrote:
> The Generic Tracing and Control Interface (GTSC) code.
> 
> Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> ---
>  include/linux/gtsc.h |  104 +++++++++
>  lib/Kconfig          |   10 
>  lib/Makefile         |    2 
>  lib/gtsc.c           |  558 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 674 insertions(+)
> 
> diff --git a/include/linux/gtsc.h b/include/linux/gtsc.h
> new file mode 100644
> index 0000000..cbb2601
> --- /dev/null
> +++ b/include/linux/gtsc.h
> @@ -0,0 +1,104 @@
> +/*
> + * GTSC defines and function prototypes
> + *
> + * Copyright (C) 2006 IBM Inc.
> + *
> + *	Tom Zanussi <zanussi@us.ibm.com>
> + *	Martin Hunt <hunt@redhat.com>
> + *	David Wilder <dwilder@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + */
> +#ifndef _LINUX_GTSC_H
> +#define _LINUX_GTSC_H
> +
> +#include <linux/relay.h>
> +
> +/*
> + * GTSC channel flags
> + */
> +#define TRACE_GLOBAL_CHANNEL	0x01
> +#define TRACE_FLIGHT_CHANNEL	0x02
> +#define TRACE_DISABLE_STATE	0x04
> +
> +enum trace_state {
> +	TRACE_SETUP,
> +	TRACE_RUNNING,
> +	TRACE_STOPPED,
> +};
> +
> +#define TRACE_ROOT_NAME_SIZE	64	/* Max root dir identifier */
> +#define TRACE_NAME_SIZE		64	/* Max trace identifier */
> +
> +/*
> + * Global root user information
> + */
> +struct trace_root {
> +	struct list_head list;
> +	char name[TRACE_ROOT_NAME_SIZE];
> +	struct dentry *root;
> +	unsigned int users;
> +};
> +
> +/*
> + * Client information
> + */
> +struct trace_info {
> +	enum trace_state state;
> +	struct dentry *state_file;
> +	struct rchan *rchan;
> +	struct dentry *dir;
> +	struct dentry *dropped_file;
> +	struct dentry *reset_consumed_file;
> +	struct dentry *nr_sub_file;
> +	struct dentry *sub_size_file;
> +	atomic_t dropped;
> +	struct trace_root *root;
> +	void *private_data;
> +	unsigned int flags;
> +	unsigned int buf_size;
> +	unsigned int buf_nr;
> +};
> +
> +#ifdef CONFIG_GTSC
> +static inline int trace_running(struct trace_info *trace)
> +{
> +	return trace->state == TRACE_RUNNING;
> +}
> +struct trace_info *trace_setup(const char *root, const char *name,
> +			       u32 buf_size, u32 buf_nr, u32 flags);
> +int trace_start(struct trace_info *trace);
> +int trace_stop(struct trace_info *trace);
> +void trace_cleanup_channel(struct trace_info *gt);
> +void trace_cleanup(struct trace_info *gt);
> +unsigned long long trace_timestamp(void);
> +#else
> +static inline struct trace_info *trace_setup(const char *root,
> +					     const char *name,
> +					     u32 buf_size,
> +					     u32 buf_nr,
> +					     u32 flags)
> +{
> +	return NULL;
> +}
> +static inline int trace_running(struct trace_info *trace) { return 0; }
> +static inline int trace_start(struct trace_info *trace) { return -EINVAL; }
> +static inline int trace_stop(struct trace_info *trace) {}
> +static inline void trace_cleanup_channel(struct trace_info *trace) {}
> +static inline void trace_cleanup(struct trace_info *trace) {}
> +static inline unsigned long long trace_timestamp(void) { return 0; }
> +#endif
> +

I don't see any correct case where functions such as trace_start or
trace_stop should be declared empty. Correct dependencies on CONFIG_GTSC
should probably be used.

> +#endif
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 2e7ae6b..b3931f3 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -124,4 +124,14 @@ config HAS_DMA
>  	depends on !NO_DMA
>  	default y
>  
> +config GTSC
> +	bool "Generic Trace Setup and Control"
> +	select RELAY
> +	select DEBUG_FS
> +	help
> +	  This option provides support for the setup, teardown and control
> +	  of tracing channels from kernel code.  It also provides trace
> +	  information and control to userspace via a set of debugfs control
> +	  files.  If unsure, say N.
> +
>  endmenu
> diff --git a/lib/Makefile b/lib/Makefile
> index c8c8e20..d9e68fa 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -62,6 +62,8 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
>  
>  lib-$(CONFIG_GENERIC_BUG) += bug.o
>  
> +obj-$(CONFIG_GTSC) += gtsc.o
> +
>  hostprogs-y	:= gen_crc32table
>  clean-files	:= crc32table.h
>  
> diff --git a/lib/gtsc.c b/lib/gtsc.c
> new file mode 100644
> index 0000000..ecd0ddf
> --- /dev/null
> +++ b/lib/gtsc.c
> @@ -0,0 +1,558 @@
> +/*
> + * Based on blktrace code, Copyright (C) 2006 Jens Axboe <axboe@suse.de>
> + * Moved to utt.c by Tom Zanussi <zanussi@us.ibm.com>, 2006
> + * Additional contributions by:
> + * Martin Hunt <hunt@redhat.com>, 2007
> + * David Wilder <dwilder@us.ibm.com>, 2007
> + * Renamed to gtsc <dwilder.ibm.com>, 2007
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/mutex.h>
> +#include <linux/debugfs.h>
> +#include <linux/gtsc.h>
> +
> +static LIST_HEAD(trace_roots);
> +static DEFINE_MUTEX(trace_mutex);
> +
> +static int state_open(struct inode *inode, struct file *filp)
> +{
> +	filp->private_data = inode->i_private;
> +
> +	return 0;
> +}
> +
> +static ssize_t state_read(struct file *filp, char __user *buffer,
> +			  size_t count, loff_t *ppos)
> +{
> +	struct trace_info *trace = filp->private_data;
> +	char *buf = "trace not started\n";
> +
> +	if (trace->state == TRACE_STOPPED)
> +		buf = "stopped\n";
> +	else if (trace->state == TRACE_RUNNING)
> +		buf = "running\n";
> +	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
> +}
> +
> +
> +static ssize_t state_write(struct file *filp, const char __user *buffer,
> +			   size_t count, loff_t *ppos)
> +{
> +	struct trace_info *trace = filp->private_data;
> +	char buf[16] = { '\0' };
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
> +
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
> +
> +
> +static struct trace_root *lookup_root(const char *root)
> +{
> +	struct list_head *pos;
> +	struct trace_root *r;
> +
> +	list_for_each(pos, &trace_roots) {
> +		r = list_entry(pos, struct trace_root, list);
> +		if (!strcmp(r->name, root))
> +			return r;
> +	}
> +
> +	r = kzalloc(sizeof(struct trace_root), GFP_KERNEL);
> +	if (!r)
> +		return NULL;
> +
> +	strlcpy(r->name, root, sizeof(r->name));
> +
> +	r->root = debugfs_create_dir(root, NULL);
> +	if (r->root)
> +		list_add(&r->list, &trace_roots);
> +
> +	return r;
> +}
> +
> +
> +static struct dentry *create_tree(struct trace_info *trace,
> +				  const char *root,
> +				  const char *name)
> +{
> +	struct dentry *dir = NULL;
> +
> +	if (root == NULL || name == NULL)
> +		return NULL;
> +	
> +	mutex_lock(&trace_mutex);
> +
> +	trace->root = lookup_root(root);
> +	if (!trace->root)
> +		goto err;
> +
> +	dir = debugfs_create_dir(name, trace->root->root);
> +	if (dir)
> +		trace->root->users++;
> +	else
> +		remove_root(trace);
> +
> +err:
> +	mutex_unlock(&trace_mutex);
> +
> +	return dir;
> +}
> +
> +
> +static int dropped_open(struct inode *inode, struct file *filp)
> +{
> +	filp->private_data = inode->i_private;
> +
> +	return 0;
> +}
> +
> +
> +static ssize_t dropped_read(struct file *filp, char __user *buffer,
> +			    size_t count, loff_t *ppos)
> +{
> +	struct trace_info *trace = filp->private_data;
> +	char buf[16];
> +
> +	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&trace->dropped));
> +
> +	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
> +}
> +
> +
> +static struct file_operations dropped_fops = {
> +	.owner	= THIS_MODULE,
> +	.open	= dropped_open,
> +	.read	= dropped_read,
> +};
> +
> +static int reset_consumed_open(struct inode *inode, struct file *filp)
> +{
> +	filp->private_data = inode->i_private;
> +
> +	return 0;
> +}
> +
> +static ssize_t reset_consumed_write(struct file *filp,
> +				    const char __user *buffer,
> +				    size_t count,
> +				    loff_t *ppos)
> +{
> +	struct trace_info *trace = filp->private_data;
> +
> +	relay_reset_consumed(trace->rchan);
> +
> +	return count;
> +}
> +
> +struct file_operations reset_consumed_fops = {
> +	.owner	= THIS_MODULE,
> +	.open	= reset_consumed_open,
> +	.write	= reset_consumed_write
> +};
> +
> +static int sub_size_open(struct inode *inode, struct file *filp)
> +{
> +	filp->private_data = inode->i_private;
> +
> +	return 0;
> +}
> +
> +static ssize_t sub_size_read(struct file *filp, char __user *buffer,
> +			     size_t count, loff_t *ppos)
> +{
> +	struct trace_info *trace = filp->private_data;
> +	char buf[32];
> +
> +	snprintf(buf, sizeof(buf), "%u\n",
> +		 (unsigned int)trace->rchan->subbuf_size);
> +
> +	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
> +}
> +
> +struct file_operations sub_size_fops = {
> +	.owner	= THIS_MODULE,
> +	.open	= sub_size_open,
> +	.read	= sub_size_read,
> +};
> +
> +static int nr_sub_open(struct inode *inode, struct file *filp)
> +{
> +	filp->private_data = inode->i_private;
> +	return 0;
> +}
> +
> +static ssize_t nr_sub_read(struct file *filp, char __user *buffer,
> +			   size_t count, loff_t *ppos)
> +{
> +	struct trace_info *trace = filp->private_data;
> +	char buf[32];
> +
> +	snprintf(buf, sizeof(buf), "%u\n",
> +		 (unsigned int)trace->rchan->n_subbufs);
> +
> +	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
> +}
> +
> +struct file_operations nr_sub_fops = {
> +	.owner	= THIS_MODULE,
> +	.open	= nr_sub_open,
> +	.read	= nr_sub_read,
> +};
> +
> +/*
> + * Keep track of how many times we encountered a full subbuffer, to aid
> + * the user space app in telling how many lost events there were.
> + */
> +static int subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
> +				 void *prev_subbuf, size_t prev_padding)
> +{
> +	struct trace_info *trace = buf->chan->private_data;
> +	
> +	if (trace->flags & TRACE_FLIGHT_CHANNEL)
> +		return 1;
> +	
> +	if (!relay_buf_full(buf))
> +		return 1;
> +
> +	atomic_inc(&trace->dropped);
> +
> +	return 0;
> +}
> +
> +
> +static int remove_buf_file_callback(struct dentry *dentry)
> +{
> +	debugfs_remove(dentry);
> +
> +	return 0;
> +}
> +
> +
> +static struct dentry *create_buf_file_callback(const char *filename,
> +					       struct dentry *parent,
> +					       int mode,
> +					       struct rchan_buf *buf,
> +					       int *is_global)
> +{
> +	return debugfs_create_file(filename, mode, parent, buf,
> +				   &relay_file_operations);
> +}
> +
> +
> +static struct dentry *create_global_buf_file_callback(const char *filename,
> +						      struct dentry *parent,
> +						      int mode,
> +						      struct rchan_buf *buf,
> +						      int *is_global)
> +{
> +	*is_global = 1;
> +
> +	return debugfs_create_file(filename, mode, parent, buf,
> +				   &relay_file_operations);
> +}
> +
> +
> +static struct rchan_callbacks relay_callbacks = {
> +	.subbuf_start		= subbuf_start_callback,
> +	.create_buf_file	= create_buf_file_callback,
> +	.remove_buf_file	= remove_buf_file_callback,
> +};
> +static struct rchan_callbacks relay_callbacks_global = {
> +	.subbuf_start		= subbuf_start_callback,
> +	.create_buf_file	= create_global_buf_file_callback,
> +	.remove_buf_file	= remove_buf_file_callback,
> +};
> +
> +
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
> +	if (trace->dir)
> +		remove_tree(trace);
> +}
> +
> +/*
> + * Setup controls for tracing.
> + */
> +static struct trace_info *setup_controls(const char *root,
> +					 const char *name, u32 flags)
> +{
> +	struct trace_info *trace = NULL;
> +
> +	trace = kzalloc(sizeof(*trace), GFP_KERNEL);
> +	if (!trace)
> +		goto err;
> +
> +	trace->dir = create_tree(trace, root, name);
> +	if (!trace->dir)
> +		goto err;
> +
> +	trace->state_file = debugfs_create_file("state", 0444, trace->dir,
> +						trace, &state_fops);
> +	if (!trace->state_file)
> +		goto err;
> +
> +	if (!flags & TRACE_FLIGHT_CHANNEL) {
> +		trace->dropped_file = debugfs_create_file("dropped", 0444,
> +							  trace->dir,
> +							  trace,
> +							  &dropped_fops);
> +		if (!trace->dropped_file)
> +			goto err;
> +	}
> +
> +	if (flags & TRACE_FLIGHT_CHANNEL) {
> +		trace->reset_consumed_file = debugfs_create_file("rewind",
> +								 0444,
> +								 trace->dir,
> +								 trace,
> +								 &reset_consumed_fops);
> +		if (!trace->reset_consumed_file)
> +			goto err;
> +	}
> +
> +	trace->nr_sub_file = debugfs_create_file("nr_sub", 0444,
> +						 trace->dir, trace,
> +						 &nr_sub_fops);
> +	if (!trace->nr_sub_file)
> +		goto err;
> +
> +	trace->sub_size_file = debugfs_create_file("sub_size", 0444,
> +						   trace->dir, trace,
> +						   &sub_size_fops);
> +	if (!trace->sub_size_file)
> +		goto err;
> +
> +	return trace;
> +err:
> +	if (trace) {
> +		remove_controls(trace);
> +		kfree(trace);
> +	}
> +
> +	return NULL;
> +}
> +
> +
> +int trace_setup_channel(struct trace_info *trace, u32 buf_size, u32 buf_nr,
> +			u32 flags)
> +{
> +	if (!buf_size || !buf_nr)
> +		return -EINVAL;
> +
> +	if (flags & TRACE_GLOBAL_CHANNEL)
> +		trace->rchan = relay_open("trace", trace->dir, buf_size,
> +					  buf_nr, &relay_callbacks_global,
> +					  trace);
> +	else
> +		trace->rchan = relay_open("trace", trace->dir, buf_size,
> +					  buf_nr, &relay_callbacks, trace);
> +	
> +	if (!trace->rchan)
> +		return -ENOMEM;
> +
> +	trace->flags = flags;
> +	trace->state = TRACE_SETUP;
> +
> +	return 0;
> +}
> +
> +
> +/**
> + *	trace_setup: create a new gtsc trace handle
> + *
> + *	@root: The root directory name in the root of the debugfs
> + *	       to place trace directories. Created as needed.
> + *	@name: Trace directory name, created in @root
> + *	@buf_size: size of the relay sub-buffers
> + *	@buf_nr: number of relay sub-buffers
> + *	@flags: Option selection (see GTSC channel flags definitions)
> + *		default values when flags=0 are: use per-CPU buffering,
> + *		use non-overwrite mode. See Documentation/gtsc.txt for details.
> + *
> + *	returns a gtsc_trace handle or NULL, if setup failed.
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
> +	trace->state = TRACE_SETUP;
> +
> +	return trace;
> +}
> +EXPORT_SYMBOL_GPL(trace_setup);
> +
> +
> +/**
> + *	trace_start: start tracing
> + *
> + *	@trace: gtsc trace handle to start or stop.
> + *
> + *	returns 0 if successful.
> + */
> +int trace_start(struct trace_info *trace)
> +{
> +	/*
> +	 * For starting a trace, we can transition from a setup or stopped
> +	 * trace.
> +	 */
> +	if (trace->state == TRACE_RUNNING)
> +		return -EINVAL;
> +
> +	if (trace->state == TRACE_SETUP) {
> +		int ret;
> +
> +		ret = trace_setup_channel(trace, trace->buf_size,
> +					  trace->buf_nr, trace->flags);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	trace->state = TRACE_RUNNING;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(trace_start);
> +
> +/**
> + *	trace_stop: stop tracing
> + *
> + *	@trace: gtsc trace handle to start or stop.
> + */
> +int trace_stop(struct trace_info *trace)
> +{
> +	int ret = -EINVAL;
> +	
> +	/*
> +	 * For stopping a trace, the state must be running
> +	 */
> +	if (trace->state == TRACE_RUNNING) {
> +		trace->state = TRACE_STOPPED;
> +		relay_flush(trace->rchan);
> +		ret = 0;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(trace_stop);
> +

I am curious: how do you make sure that every users of the relay channel
will be stopped and not in the reserve code anymore when the
trace_cleanup is called ?

> +
> +/**
> + *	trace_cleanup_channel: destroys the gtsc channel only
> + *
> + *	@trace: gtsc trace handle to cleanup
> + */
> +void trace_cleanup_channel(struct trace_info *trace)
> +{
> +	if (trace->rchan)
> +		relay_close(trace->rchan);
> +	trace->rchan = NULL;
> +}
> +EXPORT_SYMBOL_GPL(trace_cleanup_channel);
> +
> +
> +/**
> + *	trace_cleanup: destroys the gtsc channel, control files and dir
> + *
> + *	@trace: gtsc trace handle to cleanup
> + */
> +void trace_cleanup(struct trace_info *trace)
> +{
> +	trace_cleanup_channel(trace);
> +	remove_controls(trace);
> +	kfree(trace);
> +}
> +EXPORT_SYMBOL_GPL(trace_cleanup);
> +
> +
> +unsigned long long trace_timestamp(void)
> +{
> +	return sched_clock();

Can be non monotonic on multiple CPUs.

> +}
> +EXPORT_SYMBOL_GPL(trace_timestamp);
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
