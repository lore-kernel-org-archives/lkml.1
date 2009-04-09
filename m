Return-Path: <linux-kernel-owner+w=401wt.eu-S936611AbZDIUSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936611AbZDIUSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936111AbZDIUSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:18:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759977AbZDIUSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:18:20 -0400
Date: Thu, 9 Apr 2009 13:12:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jon Masters <jcm@jonmasters.org>
Cc: linux-kernel@vger.kernel.org, jcm@redhat.com, williams@redhat.com,
       tglx@linutronix.de, rostedt@goodmis.org, lgoncalv@redhat.com,
       jcm@jonmasters.org
Subject: Re: [PATCH 1/2] SMI Detector: a simple module for detecting System
 Management Interrupts
Message-Id: <20090409131230.dd3f2df7.akpm@linux-foundation.org>
In-Reply-To: <1238691005-25286-2-git-send-email-jcm@jonmasters.org>
References: <1238691005-25286-1-git-send-email-jcm@jonmasters.org>
	<1238691005-25286-2-git-send-email-jcm@jonmasters.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Apr 2009 12:50:04 -0400
Jon Masters <jcm@jonmasters.org> wrote:

> System Management Interrupts (SMIs) are a feature of modern x86-compatible
> microprocessors. They allow BIOS provided management code to "borrow" the
> system CPU in order to perform certain activities - device emulation,
> thermal throttling, fan control, and similar. The CPU exposes the SMI
> functionality through a dedicated pin and special purpose logic. When an
> SMI is asserted, the CPU suspends the overlying running Operating System
> and executes special SMI management routines within a unique context.
> 
> SMI routines are usually provided by the system BIOS, and the SMI assertion
> is usually made by logic in the system's South Bridge. The Operating System
> is typically completely unaware of the presence of an SMI, much less the
> amount of time spent handling them. Therein lies the problem. Some of these
> SMI routines can take many milliseconds to complete (or even longer,
> depending upon the implementation of the routines). Although it is possible
> to disable SMIs (typically by poking at the South Bridge LPC or similar),
> that can be *EXTREMELY DANGEROUS* because it can result in a system
> overheating, or even worse. Therefore, we simply try to detect them. We do
> not attempt to disable them and discourage other efforts at doing so. We
> instead prefer to collate data and ask BIOS vendors to fix their code.
> 
> We have been increasingly concerned about the amount of time certain systems
> spend inside System Management Interrupt (SMI) routines, especially on those
> systems intended for "real time" applications. This module can be used to
> detect SMIs as they occur by periodically grabbing the CPU(s) within a
> stop_machine context, and sitting in a tight loop reading the timestamp
> counter during the monitoring phase. If we experience unexplained
> discontiguous readings in the CPU timestamps, we are able to assert the
> presence of an SMI condition (the CPU is doing nothing else at the time).
> 
> Since we steal the CPU for relatively long periods of time, this module is
> intended primarily for diagnostic use. It should not be used in a normal
> production environment unless "enable" is set to zero or the acquisition
> parameters are set sufficiently low to avoid performance impact.
> 
> There are a number of pending feature improvements to this code but we
> would like to get it out there and in use tracking down SMIs.
> 
>
> ...
>
> +config SMI_DETECTOR
> +	tristate "Test module for detecting time gaps caused by SMIs"
> +	default m
> +	---help---
> +	  A simple SMI detector. Use this module to detect large system
> +	  latencies introduced by the presence of vendor BIOS SMI
> +	  (System Management Interrupts) somehow gone awry. We do this
> +	  by hogging all of the CPU(s) for configurable time intervals,
> +	  looking to see if something stole time from us. Therefore,
> +	  obviously, you should NEVER use this module in a production
> +	  environment.
> +
> +	  If unsure, say N

Does this have enough dependencies?  I have a feeling that the driver
won't work well on mips..  CONFIG_DEBUGFS?  Others?

>
> ...
>
> +module_param(debug, int, 0);
> +module_param(enabled, int, 0);
> +module_param(threshold, int, 0);
> +
> +DEFINE_MUTEX(enable_mutex);

static, please.

> +struct task_struct *smi_kthread;

ditto.

> +struct smdata_struct {
> +
> +	u64	last_sample;
> +	u64	max_sample;
> +	u64	smi_count;
> +	u64	threshold;
> +	ktime_t last_spike;
> +	u64	frequency;
> +
> +	atomic_t pending;
> +	wait_queue_head_t wq;
> +
> +} smdata;

Carefully documenting each of the above fields would be of assistance
to others.

> +static void smi_init_stats(void)
> +{
> +	smdata.last_sample = 0;
> +	smdata.max_sample = 0;
> +	smdata.smi_count = 0;
> +	smdata.frequency = 0;
> +	smdata.threshold = threshold ? threshold : DEFAULT_SMI_THRESHOLD;
> +}
> +
> +
> +struct dentry *smi_debug_dir;		/* SMI debugfs directory */
> +struct dentry *smi_debug_max;		/* maximum TSC delta */
> +struct dentry *smi_debug_smi;		/* SMI detect count */
> +struct dentry *smi_debug_sample_ms;	/* sample size ms */
> +struct dentry *smi_debug_interval_ms;	/* interval size ms */
> +struct dentry *smi_debug_sample;	/* raw SMI samples (us) */
> +struct dentry *smi_debug_threshold;	/* latency threshold (us) */
> +struct dentry *smi_debug_frequency_us;	/* avg smi spike interval (us) */
> +struct dentry *smi_debug_enable;	/* enable/disable smi detection */
> +
> +u32 smi_sample_ms   = DEFAULT_MS_PER_SAMPLE;    /* sample size ms */
> +u32 smi_interval_ms = DEFAULT_MS_SEP_SAMPLE;    /* interval size ms */

Did these all need to be global symbols?

> +/*
> + * smi_get_sample -	Used to repeatedly capture the CPU TSC (or similar),
> + *                      looking for potential SMIs. Called under stop_machine.
> + */
> +static int smi_get_sample(void *data)
> +{
> +	ktime_t start, t1, t2, spike;
> +	s64 diff, total = 0;
> +	u64 sample = 0;
> +	struct smdata_struct *smi_data = (struct smdata_struct *)data;

Unneeded and undesirable cast of void*.

> +	start = ktime_get(); /* start timestamp */
> +
> +	do {
> +
> +		t1 = ktime_get();
> +		t2 = ktime_get();

I'd have expected to see a local_irq_disable() around these two samplings.

> +		total = ktime_to_us(ktime_sub(t2, start));
> +
> +		diff = ktime_to_us(ktime_sub(t2, t1));
> +		if (diff < 0) {
> +			printk(KERN_ERR SMI_BANNER "time running backwards\n");
> +			return 1;
> +		}
> +		if (diff > sample)
> +			sample = diff; /* only want highest value per sample */
> +
> +		if (diff > smi_data->threshold)
> +			spike = t1;
> +
> +	} while (total <= USEC_PER_MSEC*smi_sample_ms);

Naive question: should we be using nanoseconds here rather than rather
coarse microseconds?


> +	smi_data->last_sample = sample;
> +
> +	if (sample > smi_data->threshold) {
> +		u64 tmp;

eek.  `tmp' is a wicked identifier.  Can we choose something more meaningful?

> +		smi_data->smi_count++;
> +		tmp = ktime_to_us(ktime_sub(spike, smi_data->last_spike));
> +
> +		if (smi_data->smi_count > 2)
> +			smi_data->frequency = (smi_data->frequency + tmp) / 2;
> +		else
> +			if (smi_data->smi_count == 2)
> +				smi_data->frequency = tmp;
> +
> +		smi_data->last_spike = spike;
> +	}
> +
> +	atomic_set(&smi_data->pending, 1);

See, this code would be more easy to review if you'd told us what
`pending' does.

> +	if (sample > smi_data->max_sample)
> +		smi_data->max_sample = sample;
> +
> +	return 0;
> +}
> +
> +/*
> + * smi_kthread_fn - Used to periodically sample the CPU TSC via smi_get_sample.
> + *                  We use stop_machine, which intentionally introduces latency.
> + */
> +
> +static int smi_kthread_fn(void *data)
> +{
> +	int err = 0;
> +	struct smdata_struct *smi_data = (struct smdata_struct *)data;

Unneeded cast of void*.

> +	while (!kthread_should_stop()) {
> +		err = stop_machine(smi_get_sample, smi_data, 0);
> +
> +		wake_up(&smi_data->wq);
> +
> +		if (msleep_interruptible(smi_interval_ms))
> +			goto out;

hm, how can this happen?  Can root kill the kernel thread?  I think
that gets ignored..

> +	}
> +
> +out:
> +	return 0;
> +}
> +
> +struct task_struct *start_smi_thread(void)
> +{
> +	return smi_kthread = kthread_run(smi_kthread_fn, &smdata,
> +					 "smi_detector");
> +}

All callers of this function ignore its return value.


> +void stop_smi_thread(void)
> +{
> +	if (smi_kthread)
> +		kthread_stop(smi_kthread);
> +}

This seems to assume that kthread_run() returns NULL on failure.  But
it returns an ERR_PTR.

> +static int smi_debug_sample_fopen(struct inode *inode, struct file *filp)
> +{
> +
> +	filp->private_data = (void *)&smdata;

unneeded cast.

> +	return 0;
> +}

missing newline.

> +static ssize_t smi_debug_sample_fread(struct file *filp, char __user *ubuf,
> +					size_t cnt, loff_t *ppos)
> +{
> +	int len;
> +	char buf[64];
> +	struct smdata_struct *smi_data = filp->private_data;
> +
> +	if (!enabled)
> +		return 0;
> +
> +	wait_event_interruptible(smi_data->wq, atomic_read(&smi_data->pending));
> +	atomic_set(&smi_data->pending, 0);

Is this code racy?  (I couldn't be bothered working it out, but it
smells racy ;))

> +	len = sprintf(buf, "%lld\n", smi_data->last_sample);

%llu would be more accurate.

> +	if (copy_to_user(ubuf, buf, len))
> +		return -EFAULT;

Perhaps the kernel should have an snprintf_to_user() utility.  Maybe it
already has and I forgot.

> +	return len;
> +}
> +
> +static const struct file_operations smi_sample_fops = {
> +	.open		= smi_debug_sample_fopen,
> +	.read		= smi_debug_sample_fread,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int smi_debug_enable_fopen(struct inode *inode, struct file *filp)
> +{
> +	return 0;
> +}
> +
> +
> +static ssize_t smi_debug_enable_fread(struct file *filp, char __user *ubuf,
> +				      size_t cnt, loff_t *ppos)
> +{
> +	char buffer[4];
> +
> +	if (!cnt || *ppos)
> +		return 0;
> +
> +	buffer[0] = enabled ? '1' : '0';
> +	buffer[1] = '\n';
> +	buffer[2] = '\0';

This is unneeded.

> +	if (copy_to_user(ubuf, buffer, 2))
> +		return -EFAULT;

another snprintf_to_user() user!

> +	return *ppos = 2;
> +}
> +
> +static ssize_t  smi_debug_enable_fwrite(struct file *file,
> +					const char __user *user_buffer,
> +					size_t user_size,
> +					loff_t *offset)
> +{
> +	char buffer[4];
> +	int copy_size = min(user_size, sizeof(buffer));
> +	long val;
> +
> +	if (copy_from_user(buffer, user_buffer, copy_size))
> +		return -EFAULT;
> +#if 1
> +	val = simple_strtol(buffer, NULL, 10);
> +#else
> +	if (strict_strtol(buffer, 10, &val))
> +		return -EINVAL;
> +#endif

strict_strtoul() is preferred.

> +	mutex_lock(&enable_mutex);
> +	if (val) {
> +		if (enabled)
> +			goto unlock;
> +		smi_init_stats();
> +		enabled = 1;
> +		start_smi_thread();
> +	} else {
> +		if (!enabled)
> +			goto unlock;
> +		enabled = 0;
> +		stop_smi_thread();
> +	}
> +unlock:
> +	mutex_unlock(&enable_mutex);
> +	printk(SMI_BANNER "smi_detector thread %s\n",
> +		enabled ? "started" : "stopped");
> +	return user_size;
> +}
> +
> +static const struct file_operations smi_enable_fops = {
> +	.open		= smi_debug_enable_fopen,
> +	.read		= smi_debug_enable_fread,
> +	.write		= smi_debug_enable_fwrite,
> +	.owner		= THIS_MODULE,
> +};
> +
> +/* debugfs_create_bool */
> +int smi_detector_init(void)
> +{
> +
> +	printk(KERN_INFO SMI_BANNER "version %s\n", smi_version);
> +
> +	smi_init_stats();
> +
> +	init_waitqueue_head(&smdata.wq);
> +	atomic_set(&smdata.pending, 0);

These could have been done at compile time.

> +	smi_debug_dir = debugfs_create_dir("smi_detector", NULL);
> +
> +	if (smi_debug_dir == NULL) {
> +		printk(KERN_INFO SMI_BANNER "debugfs not mounted!\n");
> +		return -1;
> +	}
> +
> +	smi_debug_sample_ms = debugfs_create_u32("ms_per_sample",
> +				0644, smi_debug_dir, &smi_sample_ms);
> +	smi_debug_interval_ms = debugfs_create_u32("ms_between_samples",
> +				0644, smi_debug_dir, &smi_interval_ms);
> +	smi_debug_max = debugfs_create_u64("max_sample_us",
> +				0644, smi_debug_dir, &smdata.max_sample);
> +	smi_debug_smi = debugfs_create_u64("smi_count",
> +				0644, smi_debug_dir, &smdata.smi_count);
> +	smi_debug_sample = debugfs_create_file("sample_us",
> +				0444, smi_debug_dir, &smdata, &smi_sample_fops);
> +	smi_debug_frequency_us = debugfs_create_u64("avg_smi_interval_us",
> +				0444, smi_debug_dir, &smdata.frequency);
> +	smi_debug_threshold = debugfs_create_u64("latency_threshold_us",
> +				0444, smi_debug_dir, &smdata.threshold);
> +
> +	smi_debug_enable = debugfs_create_file("enable",
> +				0644, smi_debug_dir,
> +				&enabled, &smi_enable_fops);
> +
> +
> +	if (enabled)
> +		start_smi_thread();
> +
> +	return 0;
> +}
> +
> +void smi_detector_exit(void)
> +{
> +	if (enabled) {
> +		mutex_lock(&enable_mutex);
> +		enabled = 0;
> +		stop_smi_thread();
> +		mutex_unlock(&enable_mutex);
> +	}
> +	if (smi_debug_sample_ms)
> +		debugfs_remove(smi_debug_sample_ms);
> +	if (smi_debug_interval_ms)
> +		debugfs_remove(smi_debug_interval_ms);
> +	if (smi_debug_max)
> +		debugfs_remove(smi_debug_max);
> +	if (smi_debug_smi)
> +		debugfs_remove(smi_debug_smi);
> +	if (smi_debug_frequency_us)
> +		debugfs_remove(smi_debug_frequency_us);
> +	if (smi_debug_threshold)
> +		debugfs_remove(smi_debug_threshold);
> +	if (smi_debug_sample)
> +		debugfs_remove(smi_debug_sample);
> +	if (smi_debug_enable)
> +		debugfs_remove(smi_debug_enable);
> +	if (smi_debug_dir)
> +		debugfs_remove(smi_debug_dir);

debugfs_remove(NULL) is legal, so all the if()s can be removed.

> +}
> +
> +module_init(smi_detector_init);
> +module_exit(smi_detector_exit);
> diff --git a/scripts/smidetect b/scripts/smidetect
> new file mode 100644
> index 0000000..81593a1
> --- /dev/null
> +++ b/scripts/smidetect
> @@ -0,0 +1,282 @@
> +#!/usr/bin/python

Some documentation here would be nice.  An overview of what it does,
command line options, pointer to the .txt file.


