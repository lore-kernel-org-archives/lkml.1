Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbZFBD6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbZFBD6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 23:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbZFBD63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 23:58:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753574AbZFBD62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 23:58:28 -0400
Date: Mon, 1 Jun 2009 20:57:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel@vger.kernel.org, jcm@redhat.com, tglx@linutronix.de,
       mingo@elte.hu, rostedt@goodmis.org
Subject: Re: [RFC PATCH 1/1] smi_detector: A System Management Interrupt
 detector
Message-Id: <20090601205720.825d3048.akpm@linux-foundation.org>
In-Reply-To: <20090531163343.771922592@jonmasters.org>
References: <20090531163117.502167374@jonmasters.org>
	<20090531163343.771922592@jonmasters.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 May 2009 12:31:18 -0400 Jon Masters <jonathan@jonmasters.org> wrote:

> This patch introduces a new SMI (System Management Interrupt) detector module
> that can be used to detect high latencies within the system. It was originally
> written for use in the RT kernel, but has wider applications.
> 

Neat-looking code.

AFACIT it can be used on any platform.  Suppose that powerpcs or ia64s
also mysteriously go to lunch like PC's do - I think the code will work
for them too?  In which case the "smi" name is excessively specific. 
Not a big deal though.

>
> ...
>
> +static int smi_kthread_fn(void *unused)
> +{
> +	int err = 0;
> +	u64 interval = 0;
> +
> +	while (!kthread_should_stop()) {
> +
> +		mutex_lock(&smi_data.lock);
> +
> +		err = stop_machine(smi_get_sample, unused, 0);
> +		if (err) {
> +			/* Houston, we have a problem */
> +			mutex_unlock(&smi_data.lock);
> +			goto err_out;
> +		}
> +
> +		interval = smi_data.sample_window - smi_data.sample_width;
> +		do_div(interval, USEC_PER_MSEC); /* modifies interval value */
> +
> +		mutex_unlock(&smi_data.lock);
> +
> +		if (msleep_interruptible(interval))
> +			goto out;
> +
> +	}

whitespace went a bit nutty there.

> +
> +		goto out;

and there.

> +err_out:
> +	printk(KERN_ERR SMI_BANNER "could not call stop_machine, disabling\n");
> +	enabled = 0;
> +out:
> +	return err;
> +
> +}
> +
> +/**
> + * smi_start_kthread - Kick off the SMI sampling/detection kernel thread
> + *
> + * This starts a kernel thread that will sit and sample the CPU timestamp
> + * counter (TSC or similar) and look for potential SMIs.
> + */
> +static int smi_start_kthread(void)
> +{
> +	smi_kthread = kthread_run(smi_kthread_fn, NULL,
> +					"smi_detector");
> +	if (!smi_kthread) {

You'll need an IS_ERR() test here.

> +		printk(KERN_ERR SMI_BANNER "could not start sampling thread\n");
> +		enabled = 0;
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * smi_stop_kthread - Inform the SMI detect/sampling kernel thread to stop
> + *
> + * This kicks the running SMI detect/sampling kernel thread and tells it to
> + * stop sampling now. Use this on unload and at system shutdown.
> + */
> +static int smi_stop_kthread(void)
> +{
> +	int ret = -ENOMEM;

Unneeded initialisation.

> +	ret = kthread_stop(smi_kthread);
> +
> +	return ret;
> +}
> +
>
> ...
>
> +/**
> + * smi_init_stats - Setup the global state and statistics for the SMI detector
> + *
> + * We use smi_data to store various statistics and global state. We also use
> + * a global ring buffer (smi_ring_buffer) to keep raw samples of detected SMIs.
> + * This function initializes these structures and allocates the ring buffer.
> + */
> +static int smi_init_stats(void)
> +{
> +	int ret = -ENOMEM;
> +
> +	mutex_init(&smi_data.lock);
> +	init_waitqueue_head(&smi_data.wq);
> +	atomic_set(&smi_data.sample_open, 0);
> +
> +	smi_ring_buffer = ring_buffer_alloc(smi_buf_size, SMI_BUF_FLAGS);
> +
> +	if (!smi_ring_buffer) {
> +		printk(KERN_ERR SMI_BANNER "failed to allocate ring buffer!\n");
> +		WARN_ON(1);
> +		goto out;
> +	}

	if (WARN(!smi_ring_buffer, KERN_ERR SMI_BANNER
				"failed to allocate ring buffer!\n")
		goto out;

neat, hm?

> +
> +	__smi_reset_stats();
> +	smi_data.threshold = SMI_DEFAULT_SMI_THRESHOLD;	    /* threshold us */
> +	smi_data.sample_window = SMI_DEFAULT_SAMPLE_WINDOW; /* window us */
> +	smi_data.sample_width = SMI_DEFAULT_SAMPLE_WIDTH;   /* width us */
> +
> +	ret = 0;
> +
> +out:
> +	return ret;
> +
> +}
> +
>
> ...
>
> +static ssize_t smi_debug_count_fread(struct file *filp, char __user *ubuf,
> +				     size_t cnt, loff_t *ppos)
> +{
> +	char buf[SMI_U64STR_SIZE];
> +	u64 val = 0;
> +	int len = 0;
> +
> +	memset(buf, 0, sizeof(buf));
> +
> +	if ((cnt < sizeof(buf)) || (*ppos))
> +		return 0;
> +
> +	mutex_lock(&smi_data.lock);
> +	val = smi_data.count;
> +	mutex_unlock(&smi_data.lock);
> +
> +	len = snprintf(buf, SMI_U64STR_SIZE, "%llu\n", val);

You'll need to cast the u64 to unsigned long long to avoid warnings on
some architectures.

> +	if (copy_to_user(ubuf, buf, len))
> +		return -EFAULT;

I thought we had an sprintf_to_user() but I can't find it.

> +	return *ppos = len;
> +}
> +
> +/**
> + * smi_debug_count_fwrite - Write function for "count" debugfs entry
> + * @filp: The active open file structure for the debugfs "file"
> + * @ubuf: The user buffer that contains the value to write
> + * @cnt: The maximum number of bytes to write to "file"
> + * @ppos: The current position in the debugfs "file"
> + */
> +static ssize_t  smi_debug_count_fwrite(struct file *filp,
> +				       const char __user *ubuf,
> +				       size_t cnt,
> +				       loff_t *ppos)
> +{
> +	char buf[SMI_U64STR_SIZE];
> +	int csize = min(cnt, sizeof(buf));
> +	u64 val = 0;
> +	int err = 0;
> +
> +	memset(buf, '\0', sizeof(buf));
> +	if (copy_from_user(buf, ubuf, csize))
> +		return -EFAULT;
> +
> +	buf[SMI_U64STR_SIZE-1] = '\0';			/* just in case */
> +	err = strict_strtoull(buf, 10, &val);
> +	if (0 != err)

	if (err != 0)

or

	if (err)

would be more typical.

> +		return -EINVAL;
> +
> +	mutex_lock(&smi_data.lock);
> +	smi_data.count = val;
> +	mutex_unlock(&smi_data.lock);
> +
> +	return csize;
> +}
> +
>
> ...
>
> +static ssize_t  smi_debug_max_fwrite(struct file *filp,
> +				     const char __user *ubuf,
> +				     size_t cnt,
> +				     loff_t *ppos)
> +{
> +	char buf[SMI_U64STR_SIZE];
> +	int csize = min(cnt, sizeof(buf));
> +	u64 val = 0;
> +	int err = 0;
> +
> +	memset(buf, '\0', sizeof(buf));
> +	if (copy_from_user(buf, ubuf, csize))
> +		return -EFAULT;
> +
> +	buf[SMI_U64STR_SIZE-1] = '\0';			/* just in case */
> +	err = strict_strtoull(buf, 10, &val);
> +	if (0 != err)
> +		return -EINVAL;
> +
> +	mutex_lock(&smi_data.lock);
> +	smi_data.max_sample = val;
> +	mutex_unlock(&smi_data.lock);
> +
> +	return csize;
> +}

There's a lot of code duplication amongst all these debugfs write()
handlers.  Can a common helper be used?

> +
> +/**
> + * smi_debug_sample_fopen - An open function for "sample" debugfs interface
> + * @inode: The in-kernel inode representation of this debugfs "file"
> + * @filp: The active open file structure for the debugfs "file"
> + *
> + * This function handles opening the "sample" file within the SMI detector
> + * debugfs directory interface. This file is used to read raw samples from
> + * the SMI ring_buffer and allows the user to see a running SMI history.
> + */
> +static int smi_debug_sample_fopen(struct inode *inode, struct file *filp)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&smi_data.lock);
> +	if (atomic_read(&smi_data.sample_open))
> +		ret = -EBUSY;
> +	else
> +		atomic_inc(&smi_data.sample_open);
> +	mutex_unlock(&smi_data.lock);
> +
> +	return ret;
> +}

It's strange to use a lock to protect an atomic_t.  A simple
atomic_add_unless() might suffice.

> +/**
> + * smi_debug_sample_fread - A read function for "sample" debugfs interface
> + * @filp: The active open file structure for the debugfs "file"
> + * @ubuf: The user buffer that will contain the samples read
> + * @cnt: The maximum bytes to read from the debugfs "file"
> + * @ppos: The current position in the debugfs "file"
> + *
> + * This function handles reading from the "sample" file within the SMI
> + * detector debugfs directory interface. This file is used to read raw samples
> + * from the SMI ring_buffer and allows the user to see a running SMI history.
> + */
> +static ssize_t smi_debug_sample_fread(struct file *filp, char __user *ubuf,
> +					size_t cnt, loff_t *ppos)
> +{
> +	int len = 0;
> +	char buf[64];
> +	struct smi_sample *sample = NULL;
> +
> +	if (!enabled)
> +		return 0;
> +
> +	sample = kzalloc(sizeof(struct smi_sample), GFP_KERNEL);
> +	if (!sample)
> +		return -EFAULT;

-ENOMEM?

> +	while (!smi_buffer_get_sample(sample)) {
> +
> +		DEFINE_WAIT(wait);
> +
> +		if (filp->f_flags & O_NONBLOCK) {
> +			len = -EAGAIN;
> +			goto out;
> +		}
> +
> +		prepare_to_wait(&smi_data.wq, &wait, TASK_INTERRUPTIBLE);
> +		schedule();
> +		finish_wait(&smi_data.wq, &wait);
> +
> +		if (signal_pending(current)) {
> +			len = -EINTR;
> +			goto out;
> +		}
> +
> +		if (!enabled) {			/* enable was toggled */
> +			len = 0;
> +			goto out;
> +		}
> +	}
> +
> +	len = snprintf(buf, sizeof(buf), "%010lu.%010lu\t%llu\n",
> +		      sample->timestamp.tv_sec,
> +		      sample->timestamp.tv_nsec,
> +		      sample->duration);
> +
> +
> +	/* handling partial reads is more trouble than it's worth */
> +	if (len > cnt)
> +		goto out;
> +
> +	if (copy_to_user(ubuf, buf, len))
> +		len = -EFAULT;
> +
> +out:
> +	kfree(sample);
> +	return len;
> +}
> +
>
> ...
>
> +static ssize_t smi_debug_threshold_fread(struct file *filp, char __user *ubuf,
> +					 size_t cnt, loff_t *ppos)
> +{
> +	char buf[SMI_U64STR_SIZE];
> +	u64 val = 0;
> +	int len = 0;
> +
> +	memset(buf, 0, sizeof(buf));
> +
> +	if ((cnt < sizeof(buf)) || (*ppos))
> +		return 0;
> +
> +	mutex_lock(&smi_data.lock);
> +	val = smi_data.threshold;
> +	mutex_unlock(&smi_data.lock);
> +
> +	len = snprintf(buf, SMI_U64STR_SIZE, "%llu\n", val);

printk warnings here.

> +	if (copy_to_user(ubuf, buf, len))
> +		return -EFAULT;
> +	return *ppos = len;
> +}

More code duplication?

>
> ...
>
> +static ssize_t smi_debug_width_fread(struct file *filp, char __user *ubuf,
> +				     size_t cnt, loff_t *ppos)
> +{
> +	char buf[SMI_U64STR_SIZE];
> +	u64 val = 0;
> +	int len = 0;
> +
> +	memset(buf, 0, sizeof(buf));
> +
> +	if ((cnt < sizeof(buf)) || (*ppos))
> +		return 0;
> +
> +	mutex_lock(&smi_data.lock);
> +	val = smi_data.sample_width;
> +	mutex_unlock(&smi_data.lock);
> +
> +	len = snprintf(buf, SMI_U64STR_SIZE, "%llu\n", val);
> +
> +	if (copy_to_user(ubuf, buf, len))
> +		return -EFAULT;
> +	return *ppos = len;
> +}

dittoes...

> +/**
> + * smi_debug_width_fwrite - Write function for "width" debugfs entry
> + * @filp: The active open file structure for the debugfs "file"
> + * @ubuf: The user buffer that contains the value to write
> + * @cnt: The maximum number of bytes to write to "file"
> + * @ppos: The current position in the debugfs "file"
> + */
> +static ssize_t  smi_debug_width_fwrite(struct file *filp,
> +				       const char __user *ubuf,
> +				       size_t cnt,
> +				       loff_t *ppos)
> +{
> +	char buf[SMI_U64STR_SIZE];
> +	int csize = min(cnt, sizeof(buf));
> +	u64 val = 0;
> +	int err = 0;
> +
> +	memset(buf, '\0', sizeof(buf));
> +	if (copy_from_user(buf, ubuf, csize))
> +		return -EFAULT;
> +
> +	buf[SMI_U64STR_SIZE-1] = '\0';			/* just in case */
> +	err = strict_strtoull(buf, 10, &val);
> +	if (0 != err)
> +		return -EINVAL;
> +
> +	mutex_lock(&smi_data.lock);
> +	if (val < smi_data.sample_window)
> +		smi_data.sample_width = val;
> +	else {
> +		mutex_unlock(&smi_data.lock);
> +		return -EINVAL;
> +	}
> +	mutex_unlock(&smi_data.lock);
> +
> +	if (enabled)
> +		wake_up_process(smi_kthread);
> +
> +	return csize;
> +}

More duplication.

>
> ...
>

