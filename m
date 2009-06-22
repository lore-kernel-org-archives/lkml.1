Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbZFVTSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbZFVTSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZFVTSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:18:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbZFVTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:18:37 -0400
Date: Mon, 22 Jun 2009 12:17:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       rostedt@goodmis.org
Subject: Re: [PATCH 1/1] hwlat_detector: A system hardware latency detector
Message-Id: <20090622121736.588ae743.akpm@linux-foundation.org>
In-Reply-To: <20090611045939.103213179@jonmasters.org>
References: <20090611045829.714510042@jonmasters.org>
	<20090611045939.103213179@jonmasters.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009 00:58:30 -0400
Jon Masters <jonathan@jonmasters.org> wrote:

> This patch introduces a new hardware latency detector module that can be used
> to detect high hardware-induced latencies within the system. It was originally
> written for use in the RT kernel, but has wider applications.
> 
>
> ...
>
> +config HWLAT_DETECTOR
> +	tristate "Testing module to detect hardware-induced latencies"
> +	depends on DEBUG_FS
> +	default m
> +	---help---
> +	  A simple hardware latency detector. Use this module to detect
> +	  large latencies introduced by the behavior of the underlying
> +	  system firmware external to Linux. We do this using periodic
> +	  use of stop_machine to grab all available CPUs and measure
> +	  for unexplainable gaps in the CPU timestamp counter(s). By
> +	  default, the module is not enabled until the "enable" file
> +	  within the "hwlat_detector" debugfs directory is toggled.
> +
> +	  This module is often used to detect SMI (System Management
> +	  Interrupts) on x86 systems, though is not x86 specific. To
> +	  this end, we default to using a sample window of 1 second,
> +	  during which we will sample for 0.5 seconds. If an SMI or
> +	  similar event occurs during that time, it is recorded
> +	  into an 8K samples global ring buffer until retreived.

"i before e except after c"!

> +	  WARNING: This software should never be enabled (it can be built
> +	  but should not be turned on after it is loaded) in a production
> +	  environment where high latencies are a concern since the
> +	  sampling mechanism actually introduces latencies for
> +	  regular tasks while the CPU(s) are being held.
> +
> +	  If unsure, say N
> +
>
> ...
>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/ring_buffer.h>
> +#include <linux/stop_machine.h>
> +#include <linux/time.h>
> +#include <linux/hrtimer.h>
> +#include <linux/kthread.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/uaccess.h>
> +#include <linux/version.h>
> +
> +#define BUF_SIZE_DEFAULT	262144UL		/* 8K*(sizeof(entry)) */

I still don't understand this.

What is an "entry"?  Seems to be a u64?  If so, the value is 4x too
large.

It would be clearer to code this as "8192 * sizeof(something)".

Later, we do this:

> +static unsigned long buf_size = BUF_SIZE_DEFAULT;

But there is no provision for altering `buf_size', so we might as well
have just used the constant directly.

> +#define BUF_FLAGS		(RB_FL_OVERWRITE)	/* no block on full */
> +#define U64STR_SIZE		22			/* 20 digits max */
> +
> +#define VERSION			"1.0.0"
> +#define BANNER			"hwlat_detector: "
> +#define DRVNAME			"hwlat_detector"
> +#define DEFAULT_SAMPLE_WINDOW	1000000			/* 1s */
> +#define DEFAULT_SAMPLE_WIDTH	500000			/* 0.5s */
> +#define DEFAULT_LAT_THRESHOLD	10			/* 10us */
> +
> +/* Module metadata */
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Jon Masters <jcm@redhat.com>");
> +MODULE_DESCRIPTION("A simple hardware latency detector");
> +MODULE_VERSION(VERSION);
> +
> +/* Module parameters */
> +
> +static int debug;
> +static int enabled;
> +static int threshold;
> +
> +module_param(debug, int, 0);			/* enable debug */
> +module_param(enabled, int, 0);			/* enable detector */
> +module_param(threshold, int, 0);		/* latency threshold */
> +
> +/* Buffering and sampling */
> +
> +static struct ring_buffer *ring_buffer;		/* sample buffer */
> +static DEFINE_MUTEX(ring_buffer_mutex);		/* lock changes */
> +static unsigned long buf_size = BUF_SIZE_DEFAULT;
> +static struct task_struct *kthread;		/* sampling thread */
> +
> +/* DebugFS filesystem entries */
> +
> +static struct dentry *debug_dir;		/* debugfs directory */
> +static struct dentry *debug_max;		/* maximum TSC delta */
> +static struct dentry *debug_count;		/* total detect count */
> +static struct dentry *debug_sample_width;	/* sample width us */
> +static struct dentry *debug_sample_window;	/* sample window us */
> +static struct dentry *debug_sample;		/* raw samples us */
> +static struct dentry *debug_threshold;		/* threshold us */
> +static struct dentry *debug_enable;         	/* enable/disable */
> +
> +/* Individual samples and global state */
> +
> +struct sample;					/* latency sample */
> +struct data;					/* Global state */
> +
> +/* Sampling functions */
> +static int __buffer_add_sample(struct sample *sample);
> +static struct sample *buffer_get_sample(struct sample *sample);
> +static int get_sample(void *unused);
> +
> +/* Threading and state */
> +static int kthread_fn(void *unused);
> +static int start_kthread(void);
> +static int stop_kthread(void);
> +static void __reset_stats(void);
> +static int init_stats(void);

We seem to be forward-declaring functions which didn't need forward
declarations.  This adds duplication and noise - personally I think
it's better to just get the functions in the correct order and only use
forward-decls where circularities are present.

A couple of struct are needlessly forward-decalred too.  etc.

> +/* Debugfs interface */
> +static ssize_t simple_data_read(struct file *filp, char __user *ubuf,
> +				size_t cnt, loff_t *ppos, const u64 *entry);
> +static ssize_t simple_data_write(struct file *filp, const char __user *ubuf,
> +				 size_t cnt, loff_t *ppos, u64 *entry);
> +static int debug_sample_fopen(struct inode *inode, struct file *filp);
> +static ssize_t debug_sample_fread(struct file *filp, char __user *ubuf,
> +				  size_t cnt, loff_t *ppos);
> +static int debug_sample_release(struct inode *inode, struct file *filp);
> +static int debug_enable_fopen(struct inode *inode, struct file *filp);
> +static ssize_t debug_enable_fread(struct file *filp, char __user *ubuf,
> +				  size_t cnt, loff_t *ppos);
> +static ssize_t debug_enable_fwrite(struct file *file,
> +				   const char __user *user_buffer,
> +				   size_t user_size, loff_t *offset);
> +
>
> ...
>
> +static int kthread_fn(void *unused)
> +{
> +	int err = 0;
> +	u64 interval = 0;
> +
> +	while (!kthread_should_stop()) {
> +
> +		mutex_lock(&data.lock);
> +
> +		err = stop_machine(get_sample, unused, 0);
> +		if (err) {
> +			/* Houston, we have a problem */
> +			mutex_unlock(&data.lock);
> +			goto err_out;
> +		}
> +
> +		interval = data.sample_window - data.sample_width;
> +		do_div(interval, USEC_PER_MSEC); /* modifies interval value */
> +
> +		mutex_unlock(&data.lock);
> +
> +		if (msleep_interruptible(interval))
> +			goto out;
> +	}
> +		goto out;

whitespace broke.

> +err_out:
> +	printk(KERN_ERR BANNER "could not call stop_machine, disabling\n");
> +	enabled = 0;
> +out:
> +	return err;
> +
> +}
> +
> +/**
> + * start_kthread - Kick off the hardware latency sampling/detector kthread
> + *
> + * This starts a kernel thread that will sit and sample the CPU timestamp
> + * counter (TSC or similar) and look for potential hardware latencies.
> + */
> +static int start_kthread(void)
> +{
> +	kthread = kthread_run(kthread_fn, NULL,
> +					DRVNAME);

unneeded newline.

> +	if (IS_ERR(kthread)) {
> +		printk(KERN_ERR BANNER "could not start sampling thread\n");
> +		enabled = 0;
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
>
> ...
>
> +static int init_stats(void)
> +{
> +	int ret = -ENOMEM;
> +
> +	mutex_init(&data.lock);
> +	init_waitqueue_head(&data.wq);
> +	atomic_set(&data.sample_open, 0);

Some (and probably all) of these initialisations can be performed at
compile-time.

> +	ring_buffer = ring_buffer_alloc(buf_size, BUF_FLAGS);
> +
> +	if (WARN(!ring_buffer, KERN_ERR BANNER
> +			       "failed to allocate ring buffer!\n"))
> +		goto out;
> +
> +	__reset_stats();
> +	data.threshold = DEFAULT_LAT_THRESHOLD;	    /* threshold us */
> +	data.sample_window = DEFAULT_SAMPLE_WINDOW; /* window us */
> +	data.sample_width = DEFAULT_SAMPLE_WIDTH;   /* width us */

Ditto.

> +	ret = 0;
> +
> +out:
> +	return ret;
> +
> +}
> +
> +/*
> + * simple_data_read - Wrapper read function for global state debugfs entries
> + * @filp: The active open file structure for the debugfs "file"
> + * @ubuf: The userspace provided buffer to read value into
> + * @cnt: The maximum number of bytes to read
> + * @ppos: The current "file" position
> + * @entry: The entry to read from
> + *
> + * This function provides a generic read implementation for the global state
> + * "data" structure debugfs filesystem entries. It would be nice to use
> + * simple_attr_read directly, but we need to make sure that the data.lock
> + * spinlock is held during the actual read (even though we likely won't ever
> + * actually race here as the updater runs under a stop_machine context).
> + */
> +static ssize_t simple_data_read(struct file *filp, char __user *ubuf,
> +				size_t cnt, loff_t *ppos, const u64 *entry)
> +{
> +	char buf[U64STR_SIZE];
> +	u64 val = 0;
> +	int len = 0;
> +
> +	memset(buf, 0, sizeof(buf));
> +
> +	if (!entry)
> +		return -EFAULT;
> +
> +	mutex_lock(&data.lock);
> +	val = *entry;
> +	mutex_unlock(&data.lock);
> +
> +	len = snprintf(buf, sizeof(buf), "%llu\n", (unsigned long long)val);
> +
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
> +

extra newline.

> +}

Perhaps we should have a simple_read_u64_from_buffer() (etc).  It seems
to be a fairly common pattern.


> +/*
> + * simple_data_write - Wrapper write function for global state debugfs entries
> + * @filp: The active open file structure for the debugfs "file"
> + * @ubuf: The userspace provided buffer to write value from
> + * @cnt: The maximum number of bytes to write
> + * @ppos: The current "file" position
> + * @entry: The entry to write to
> + *
> + * This function provides a generic write implementation for the global state
> + * "data" structure debugfs filesystem entries. It would be nice to use
> + * simple_attr_write directly, but we need to make sure that the data.lock
> + * spinlock is held during the actual write (even though we likely won't ever
> + * actually race here as the updater runs under a stop_machine context).
> + */
> +static ssize_t simple_data_write(struct file *filp, const char __user *ubuf,
> +				 size_t cnt, loff_t *ppos, u64 *entry)
> +{
> +	char buf[U64STR_SIZE];
> +	int csize = min(cnt, sizeof(buf));
> +	u64 val = 0;
> +	int err = 0;
> +
> +	memset(buf, '\0', sizeof(buf));

This is unneeded.

> +	if (copy_from_user(buf, ubuf, csize))
> +		return -EFAULT;
> +
> +	buf[U64STR_SIZE-1] = '\0';			/* just in case */
> +	err = strict_strtoull(buf, 10, &val);
> +	if (err)
> +		return -EINVAL;

Again, all the above looks terribly generic.  Isn't there already a
helper function for this?  If not, there should be one.  (I should
know, but I'm asleep).

> +	mutex_lock(&data.lock);
> +	*entry = val;
> +	mutex_unlock(&data.lock);
> +
> +	return csize;
> +}
> +
>
> ...
>
> +static ssize_t debug_enable_fread(struct file *filp, char __user *ubuf,
> +				      size_t cnt, loff_t *ppos)
> +{
> +	char buf[4];
> +
> +	if ((cnt < sizeof(buf)) || (*ppos))
> +		return 0;
> +
> +	buf[0] = enabled ? '1' : '0';
> +	buf[1] = '\n';
> +	buf[2] = '\0';
> +	if (copy_to_user(ubuf, buf, strlen(buf)))

"3" :)

> +		return -EFAULT;
> +	return *ppos = strlen(buf);
> +}
> +
> +/**
> + * debug_enable_fwrite - Write function for "enable" debugfs interface
> + * @filp: The active open file structure for the debugfs "file"
> + * @ubuf: The user buffer that contains the value to write
> + * @cnt: The maximum number of bytes to write to "file"
> + * @ppos: The current position in the debugfs "file"
> + *
> + * This function provides a write implementation for the "enable" debugfs
> + * interface to the hardware latency detector. Can be used to enable or
> + * disable the detector, which will have the side-effect of possibly
> + * also resetting the global stats and kicking off the measuring
> + * kthread (on an enable) or the converse (upon a disable).
> + */
> +static ssize_t  debug_enable_fwrite(struct file *filp,
> +					const char __user *ubuf,
> +					size_t cnt,
> +					loff_t *ppos)
> +{
> +	char buf[4];
> +	int csize = min(cnt, sizeof(buf));
> +	long val = 0;
> +	int err = 0;
> +
> +	memset(buf, '\0', sizeof(buf));

Unneeded

> +	if (copy_from_user(buf, ubuf, csize))
> +		return -EFAULT;
> +
> +	buf[sizeof(buf)-1] = '\0';			/* just in case */
> +	err = strict_strtoul(buf, 10, &val);
> +	if (0 != err)
> +		return -EINVAL;
> +
> +	if (val) {
> +		if (enabled)
> +			goto unlock;
> +		enabled = 1;
> +		__reset_stats();
> +		if (start_kthread())
> +			return -EFAULT;

-EFAULT seems inappropriate.

(I have a feeling I've mentioned several of these things before?)

> +	} else {
> +		if (!enabled)
> +			goto unlock;
> +		enabled = 0;
> +		stop_kthread();
> +		wake_up(&data.wq);		/* reader(s) should return */
> +	}
> +unlock:
> +	return csize;
> +}
> +
>
> ...
>
> +static ssize_t  debug_width_fwrite(struct file *filp,

extra space

> +				       const char __user *ubuf,
> +				       size_t cnt,
> +				       loff_t *ppos)
> +{
> +	char buf[U64STR_SIZE];
> +	int csize = min(cnt, sizeof(buf));
> +	u64 val = 0;
> +	int err = 0;
> +
> +	memset(buf, '\0', sizeof(buf));

unneeded

> +	if (copy_from_user(buf, ubuf, csize))
> +		return -EFAULT;
> +
> +	buf[U64STR_SIZE-1] = '\0';			/* just in case */
> +	err = strict_strtoull(buf, 10, &val);
> +	if (0 != err)
> +		return -EINVAL;
> +
> +	mutex_lock(&data.lock);
> +	if (val < data.sample_window)
> +		data.sample_width = val;
> +	else {
> +		mutex_unlock(&data.lock);
> +		return -EINVAL;
> +	}
> +	mutex_unlock(&data.lock);
> +
> +	if (enabled)
> +		wake_up_process(kthread);
> +
> +	return csize;
> +}
> +
>
> ...
>
> +static ssize_t  debug_window_fwrite(struct file *filp,

more extra space

> +					const char __user *ubuf,
> +					size_t cnt,
> +					loff_t *ppos)
> +{
> +	char buf[U64STR_SIZE];
> +	int csize = min(cnt, sizeof(buf));
> +	u64 val = 0;
> +	int err = 0;
> +
> +	memset(buf, '\0', sizeof(buf));

unneeded.

Again, the amount of generic-looking code here is a bit distressing.

> +	if (copy_from_user(buf, ubuf, csize))
> +		return -EFAULT;
> +
> +	buf[U64STR_SIZE-1] = '\0';			/* just in case */
> +	err = strict_strtoull(buf, 10, &val);
> +	if (0 != err)
> +		return -EINVAL;
> +
> +	mutex_lock(&data.lock);
> +	if (data.sample_width < val)
> +		data.sample_window = val;
> +	else {
> +		mutex_unlock(&data.lock);
> +		return -EINVAL;
> +	}
> +	mutex_unlock(&data.lock);
> +
> +	return csize;
> +}
> +
>
> ...
>
> +static int init_debugfs(void)
> +{
> +	int ret = -ENOMEM;
> +
> +	debug_dir = debugfs_create_dir(DRVNAME, NULL);
> +	if (!debug_dir)
> +		goto err_debug_dir;

The debugfs functions should return an errno, not a NULL on error. 
Thwap whoever did that.

> +	debug_sample = debugfs_create_file("sample", 0444,
> +					       debug_dir, NULL,
> +					       &sample_fops);
> +	if (!debug_sample)
> +		goto err_sample;
> +
> +	debug_count = debugfs_create_file("count", 0444,
> +					      debug_dir, NULL,
> +					      &count_fops);
> +	if (!debug_count)
> +		goto err_count;
> +
> +	debug_max = debugfs_create_file("max", 0444,
> +					    debug_dir, NULL,
> +					    &max_fops);
> +	if (!debug_max)
> +		goto err_max;
> +
> +	debug_sample_window = debugfs_create_file("window", 0644,
> +						      debug_dir, NULL,
> +						      &window_fops);
> +	if (!debug_sample_window)
> +		goto err_window;
> +
> +	debug_sample_width = debugfs_create_file("width", 0644,
> +						     debug_dir, NULL,
> +						     &width_fops);
> +	if (!debug_sample_width)
> +		goto err_width;
> +
> +	debug_threshold = debugfs_create_file("threshold", 0644,
> +						  debug_dir, NULL,
> +						  &threshold_fops);
> +	if (!debug_threshold)
> +		goto err_threshold;
> +
> +	debug_enable = debugfs_create_file("enable", 0644,
> +					       debug_dir, &enabled,
> +					       &enable_fops);
> +	if (!debug_enable)
> +		goto err_enable;
> +
> +	else {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +err_enable:
> +	debugfs_remove(debug_threshold);
> +err_threshold:
> +	debugfs_remove(debug_sample_width);
> +err_width:
> +	debugfs_remove(debug_sample_window);
> +err_window:
> +	debugfs_remove(debug_max);
> +err_max:
> +	debugfs_remove(debug_count);
> +err_count:
> +	debugfs_remove(debug_sample);
> +err_sample:
> +	debugfs_remove(debug_dir);
> +err_debug_dir:
> +out:
> +	return ret;
> +}
> +
>
> ...
>
> +static int detector_init(void)
> +{
> +	int ret = -ENOMEM;
> +
> +	printk(KERN_INFO BANNER "version %s\n", VERSION);
> +
> +	ret = init_stats();
> +	if (0 != ret)

Didn't I already whine about the dyslexic comparisons?

> +		goto out;
> +
> +	ret = init_debugfs();
> +	if (0 != ret)
> +		goto err_stats;
> +
> +	if (enabled)
> +		ret = start_kthread();
> +
> +	goto out;
> +
> +err_stats:
> +	ring_buffer_free(ring_buffer);
> +out:
> +	return ret;
> +
> +}
> +
>
> ...
>

