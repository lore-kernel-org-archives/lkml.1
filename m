Return-Path: <linux-kernel-owner+w=401wt.eu-S1761777AbZDBTFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777AbZDBTFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZDBTFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:05:32 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:65250 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZDBTFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:05:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bhI8CTWNwMGEUQS5NqmW7UOhUeF69hEnuQnw0wh9bFvzSwkUFWS1OlasplqPgkB2ST
         IUYpuWTQFLmBjgMnpysImsuELsuJ53WJ2cQUE38v9SNfj/GWCbt3zN7NoSl60F6XI7AE
         ISqoygQuCe/HeeaNGpU1QUWrgUUYLN5z+Fud8=
MIME-Version: 1.0
In-Reply-To: <1238691005-25286-2-git-send-email-jcm@jonmasters.org>
References: <1238691005-25286-1-git-send-email-jcm@jonmasters.org>
	 <1238691005-25286-2-git-send-email-jcm@jonmasters.org>
Date: Thu, 2 Apr 2009 21:05:26 +0200
Message-ID: <c62985530904021205t2030c81o3d6439ab6a3a5e1e@mail.gmail.com>
Subject: Re: [PATCH 1/2] SMI Detector: a simple module for detecting System 
	Management Interrupts
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Jon Masters <jcm@jonmasters.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jon Masters <jcm@redhat.com>,
       Clark Williams <williams@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


2009/4/2 Jon Masters <jcm@jonmasters.org>:
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
> Signed-off-by: Jon Masters <jcm@jonmasters.org>
> ---
>  Documentation/smi_detector.txt |   94 +++++++++++
>  drivers/misc/Kconfig           |   14 ++
>  drivers/misc/Makefile          |    1 +
>  drivers/misc/smi_detector.c    |  360 ++++++++++++++++++++++++++++++++++++++++
>  scripts/smidetect              |  282 +++++++++++++++++++++++++++++++
>  5 files changed, 751 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/smi_detector.txt
>  create mode 100644 drivers/misc/smi_detector.c
>  create mode 100644 scripts/smidetect
>
> diff --git a/Documentation/smi_detector.txt b/Documentation/smi_detector.txt
> new file mode 100644
> index 0000000..902ff36
> --- /dev/null
> +++ b/Documentation/smi_detector.txt
> @@ -0,0 +1,94 @@
> +Introduction:
> +-------------
> +
> +The module smi_detector is a special purpose kernel module that is
> +used to detect if System Management Interrupts (SMIs) are causing event
> +latencies in the Linux RT kernel.
> +
> +SMIs are usually not serviced by the Linux kernel. They are set up by
> +BIOS code and are serviced by BIOS code, usually for critical events
> +such as management of thermal sensors and fans. Sometimes though, SMIs
> +are used for other tasks and those tasks can spend an inordinate
> +amount of time in the handler (sometimes measured in milliseconds).
> +Obviously if you are trying to keep event service latencies down in the
> +microsecond range, this is a problem.
> +
> +The SMI detector works by hogging the cpu for configurable amounts of
> +time (by calling stop_machine()), polling the Time Stamp Counter (TSC)
> +register for some period, then looking for gaps in the TSC data. Any
> +gap indicates a time when the polling was interrupted and since the
> +machine is stopped and interrupts turned off the only thing that could
> +do that would be an SMI.
> +
> +Note that the SMI detector should *NEVER* be used in a production
> +environment. It is intended to be run manually to determine if the
> +hardware platform has a problem with long SMI service routines.
> +
> +Usage:
> +------
> +
> +Loading the module smi_detector passing the parameter "enabled=1" is the only
> +step required to start the smi_detector. It is possible to define a threshold
> +in microseconds (us) above which latency spikes will be taken in account
> +(parameter "threshold=").
> +
> +Example:
> +
> +       # insmod ./smi_detector.ko enabled=1 threshold=100
> +
> +After the module is loaded, it creates a directory named "smi_detector" under
> +the debugfs mountpoint, "/debugfs/smi_detector" for this text. It is necessary
> +to have debugfs mounted.
> +
> +avg_smi_interval_us    - average interval (usecs) between SMI latency spikes
> +latency_threshold_us   - minimum latency value to be considered (usecs)
> +max_sample_us          - maximum SMI latency spike observed (usecs)
> +ms_between_samples     - interval between samples (ms)
> +ms_per_sample          - sampling time (ms)
> +sample_us              - last sample (usecs). Continously updated, may be used
> +                         to plot graphs or to create histograms
> +smi_count              - how many latency spikes have been observed
> +
> +
> +       # cd /debugfs/smi_detector
> +
> +       # cat *
> +       0               (avg_smi_interval_us)
> +       100             (latency_threshold_us)
> +       0               (latency_threshold_us)
> +       5000            (ms_between_samples)
> +       1               (ms_per_sample)
> +       3               (sample_us)
> +       0               (smi_count)
> +
> +
> +The default values for ms_between_samples and ms_per_sample define that every
> +5000ms (5s) samples will be collected during 1ms. It is possible to change the
> +sampling time or the sampling interval writing to the related files. To collect
> +samples during 5ms every 50ms:
> +
> +       # echo 5 > ms_per_sample
> +       # echo 50 > ms_between_samples
> +
> +
> +       # cat ms_between_samples
> +       50
> +       # cat ms_per_sample
> +       5
> +
> +After a while, data may be verified to atest the existence of SMI induced
> +latencies:
> +
> +       # cat smi_count
> +       2
> +       # cat max_sample_us
> +       468
> +       # cat avg_smi_interval_us
> +       1356306050
> +
> +Depending on the latencies observed it is important to better adjust the
> +sampling intervals to obtain more accurate measurements. Care must be taken
> +to not create a continous sampling situation, that might be perceived by the
> +kernel as a deadlock.


Btw, you should perhaps add a check to ensure the user hasn't set a
dangerous pair value in ms_per_sample/ms_between_sample

The simple case of ms_per_sample == ms_between_sample will
hang the box. Just a check like:

if (ms_between_sample - ms_per_sample < 100)
      // not good

So that your ensure the system keeps at least 100 ms to run outside
the smi detector.


> +
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 1c48408..573ae2e 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -76,6 +76,20 @@ config IBM_ASM
>          information on the specific driver level and support statement
>          for your IBM server.
>
> +config SMI_DETECTOR
> +       tristate "Test module for detecting time gaps caused by SMIs"
> +       default m
> +       ---help---
> +         A simple SMI detector. Use this module to detect large system
> +         latencies introduced by the presence of vendor BIOS SMI
> +         (System Management Interrupts) somehow gone awry. We do this
> +         by hogging all of the CPU(s) for configurable time intervals,
> +         looking to see if something stole time from us. Therefore,
> +         obviously, you should NEVER use this module in a production
> +         environment.
> +
> +         If unsure, say N
> +
>  config PHANTOM
>        tristate "Sensable PHANToM (PCI)"
>        depends on PCI
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index bc11998..7f23e02 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -20,3 +20,4 @@ obj-$(CONFIG_SGI_GRU)         += sgi-gru/
>  obj-$(CONFIG_HP_ILO)           += hpilo.o
>  obj-$(CONFIG_C2PORT)           += c2port/
>  obj-y                          += eeprom/
> +obj-$(CONFIG_SMI_DETECTOR)     += smi_detector.o
> diff --git a/drivers/misc/smi_detector.c b/drivers/misc/smi_detector.c
> new file mode 100644
> index 0000000..40913fc
> --- /dev/null
> +++ b/drivers/misc/smi_detector.c
> @@ -0,0 +1,360 @@
> +/*
> + * A simple SMI detector. Use this module to detect large system latencies
> + * introduced by the presence of vendor BIOS SMI (System Management Interrupts)
> + * somehow gone awry. We do this by hogging all of the CPU(s) for configurable
> + * time intervals, looking to see if something stole time from us. Therefore,
> + * obviously, you should NEVER use this module in a production environment.
> + *
> + * Copyright (C) 2008 Jon Masters, Red Hat, Inc. <jcm@redhat.com>
> + *
> + * Miscelleaneous tweaks:  Clark Williams <williams@redhat.com>
> + *
> + * Licensed under the GNU General Public License, version 2.0.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +
> +#include <linux/stop_machine.h>
> +#include <linux/time.h>
> +#include <linux/hrtimer.h>
> +#include <linux/kthread.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/uaccess.h>
> +#include <linux/version.h>
> +
> +/*
> + * The below version code is the code of the git commit where
> + * stop_machine replaced stop_machine_run
> + */
> +/*#if LINUX_VERSION_CODE < 132637*/
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 28)
> +#define stop_machine  stop_machine_run
> +#endif
> +
> +#define smi_version "0.3.0"
> +#define SMI_BANNER "SMI Detector: "
> +#define DEFAULT_MS_PER_SAMPLE 1    /* milliseconds */
> +#define DEFAULT_MS_SEP_SAMPLE 50   /* milliseconds */
> +#define DEFAULT_SMI_THRESHOLD 10   /* microseconds */
> +
> +MODULE_AUTHOR("Jon Masters <jcm@redhat.com>");
> +MODULE_DESCRIPTION("A simple SMI detector");
> +MODULE_LICENSE("GPL");
> +
> +static int debug;
> +static int enabled;
> +static int threshold;
> +
> +module_param(debug, int, 0);
> +module_param(enabled, int, 0);
> +module_param(threshold, int, 0);
> +
> +DEFINE_MUTEX(enable_mutex);
> +
> +struct task_struct *smi_kthread;
> +
> +struct smdata_struct {
> +
> +       u64     last_sample;
> +       u64     max_sample;
> +       u64     smi_count;
> +       u64     threshold;
> +       ktime_t last_spike;
> +       u64     frequency;
> +
> +       atomic_t pending;
> +       wait_queue_head_t wq;
> +
> +} smdata;
> +
> +static void smi_init_stats(void)
> +{
> +       smdata.last_sample = 0;
> +       smdata.max_sample = 0;
> +       smdata.smi_count = 0;
> +       smdata.frequency = 0;
> +       smdata.threshold = threshold ? threshold : DEFAULT_SMI_THRESHOLD;
> +}
> +
> +
> +struct dentry *smi_debug_dir;          /* SMI debugfs directory */
> +struct dentry *smi_debug_max;          /* maximum TSC delta */
> +struct dentry *smi_debug_smi;          /* SMI detect count */
> +struct dentry *smi_debug_sample_ms;    /* sample size ms */
> +struct dentry *smi_debug_interval_ms;  /* interval size ms */
> +struct dentry *smi_debug_sample;       /* raw SMI samples (us) */
> +struct dentry *smi_debug_threshold;    /* latency threshold (us) */
> +struct dentry *smi_debug_frequency_us; /* avg smi spike interval (us) */
> +struct dentry *smi_debug_enable;       /* enable/disable smi detection */
> +
> +u32 smi_sample_ms   = DEFAULT_MS_PER_SAMPLE;    /* sample size ms */
> +u32 smi_interval_ms = DEFAULT_MS_SEP_SAMPLE;    /* interval size ms */
> +
> +/*
> + * smi_get_sample -    Used to repeatedly capture the CPU TSC (or similar),
> + *                      looking for potential SMIs. Called under stop_machine.
> + */
> +static int smi_get_sample(void *data)
> +{
> +       ktime_t start, t1, t2, spike;
> +       s64 diff, total = 0;
> +       u64 sample = 0;
> +       struct smdata_struct *smi_data = (struct smdata_struct *)data;
> +
> +       start = ktime_get(); /* start timestamp */
> +
> +       do {
> +
> +               t1 = ktime_get();



So this is the window of SMI's detection.
It is rather tiny but I guess that's the only solution.

But if t2 is far enough from t1, it could also mean that
the tsc is unstable, right?

Also, does ktime_get() always take the tsc as its clocksource?



> +               t2 = ktime_get();
> +
> +               total = ktime_to_us(ktime_sub(t2, start));
> +
> +               diff = ktime_to_us(ktime_sub(t2, t1));
> +               if (diff < 0) {
> +                       printk(KERN_ERR SMI_BANNER "time running backwards\n");
> +                       return 1;
> +               }
> +               if (diff > sample)
> +                       sample = diff; /* only want highest value per sample */
> +
> +               if (diff > smi_data->threshold)
> +                       spike = t1;
> +
> +       } while (total <= USEC_PER_MSEC*smi_sample_ms);
> +
> +       smi_data->last_sample = sample;
> +
> +       if (sample > smi_data->threshold) {
> +               u64 tmp;
> +
> +               smi_data->smi_count++;
> +               tmp = ktime_to_us(ktime_sub(spike, smi_data->last_spike));
> +
> +               if (smi_data->smi_count > 2)
> +                       smi_data->frequency = (smi_data->frequency + tmp) / 2;
> +               else
> +                       if (smi_data->smi_count == 2)
> +                               smi_data->frequency = tmp;
> +
> +               smi_data->last_spike = spike;
> +       }
> +
> +       atomic_set(&smi_data->pending, 1);
> +
> +       if (sample > smi_data->max_sample)
> +               smi_data->max_sample = sample;
> +
> +       return 0;
> +}
> +
> +/*
> + * smi_kthread_fn - Used to periodically sample the CPU TSC via smi_get_sample.
> + *                  We use stop_machine, which intentionally introduces latency.
> + */
> +
> +static int smi_kthread_fn(void *data)
> +{
> +       int err = 0;
> +       struct smdata_struct *smi_data = (struct smdata_struct *)data;
> +
> +       while (!kthread_should_stop()) {
> +               err = stop_machine(smi_get_sample, smi_data, 0);
> +
> +               wake_up(&smi_data->wq);
> +
> +               if (msleep_interruptible(smi_interval_ms))
> +                       goto out;
> +       }
> +
> +out:
> +       return 0;
> +}
> +
> +struct task_struct *start_smi_thread(void)
> +{
> +       return smi_kthread = kthread_run(smi_kthread_fn, &smdata,
> +                                        "smi_detector");
> +}
> +
> +void stop_smi_thread(void)
> +{
> +       if (smi_kthread)
> +               kthread_stop(smi_kthread);
> +}
> +
> +static int smi_debug_sample_fopen(struct inode *inode, struct file *filp)
> +{
> +
> +       filp->private_data = (void *)&smdata;
> +
> +       return 0;
> +}
> +static ssize_t smi_debug_sample_fread(struct file *filp, char __user *ubuf,
> +                                       size_t cnt, loff_t *ppos)
> +{
> +       int len;
> +       char buf[64];
> +       struct smdata_struct *smi_data = filp->private_data;
> +
> +       if (!enabled)
> +               return 0;
> +
> +       wait_event_interruptible(smi_data->wq, atomic_read(&smi_data->pending));
> +       atomic_set(&smi_data->pending, 0);
> +       len = sprintf(buf, "%lld\n", smi_data->last_sample);
> +       if (copy_to_user(ubuf, buf, len))
> +               return -EFAULT;
> +
> +       return len;
> +}
> +
> +static const struct file_operations smi_sample_fops = {
> +       .open           = smi_debug_sample_fopen,
> +       .read           = smi_debug_sample_fread,
> +       .owner          = THIS_MODULE,
> +};
> +
> +static int smi_debug_enable_fopen(struct inode *inode, struct file *filp)
> +{
> +       return 0;
> +}
> +
>


Debugs already provides such stub callbacks if you don't give any.



> +static ssize_t smi_debug_enable_fread(struct file *filp, char __user *ubuf,
> +                                     size_t cnt, loff_t *ppos)
> +{
> +       char buffer[4];
> +
> +       if (!cnt || *ppos)
> +               return 0;
> +
> +       buffer[0] = enabled ? '1' : '0';
> +       buffer[1] = '\n';
> +       buffer[2] = '\0';
> +       if (copy_to_user(ubuf, buffer, 2))
> +               return -EFAULT;
> +       return *ppos = 2;
> +}
> +
> +static ssize_t  smi_debug_enable_fwrite(struct file *file,
> +                                       const char __user *user_buffer,
> +                                       size_t user_size,
> +                                       loff_t *offset)
> +{
> +       char buffer[4];
> +       int copy_size = min(user_size, sizeof(buffer));
> +       long val;
> +
> +       if (copy_from_user(buffer, user_buffer, copy_size))
> +               return -EFAULT;
> +#if 1
> +       val = simple_strtol(buffer, NULL, 10);
> +#else
> +       if (strict_strtol(buffer, 10, &val))
> +               return -EINVAL;
> +#endif



So I guess the #else statement can disappear? :-)



> +       mutex_lock(&enable_mutex);
> +       if (val) {
> +               if (enabled)
> +                       goto unlock;
> +               smi_init_stats();
> +               enabled = 1;
> +               start_smi_thread();
> +       } else {
> +               if (!enabled)
> +                       goto unlock;
> +               enabled = 0;
> +               stop_smi_thread();
> +       }
> +unlock:
> +       mutex_unlock(&enable_mutex);
> +       printk(SMI_BANNER "smi_detector thread %s\n",
> +               enabled ? "started" : "stopped");
> +       return user_size;
> +}
> +
> +static const struct file_operations smi_enable_fops = {
> +       .open           = smi_debug_enable_fopen,
> +       .read           = smi_debug_enable_fread,
> +       .write          = smi_debug_enable_fwrite,
> +       .owner          = THIS_MODULE,
> +};
> +
> +/* debugfs_create_bool */
> +int smi_detector_init(void)
> +{
> +
> +       printk(KERN_INFO SMI_BANNER "version %s\n", smi_version);
> +
> +       smi_init_stats();
> +
> +       init_waitqueue_head(&smdata.wq);
> +       atomic_set(&smdata.pending, 0);
> +
> +       smi_debug_dir = debugfs_create_dir("smi_detector", NULL);
> +
> +       if (smi_debug_dir == NULL) {
> +               printk(KERN_INFO SMI_BANNER "debugfs not mounted!\n");
> +               return -1;
> +       }
> +
> +       smi_debug_sample_ms = debugfs_create_u32("ms_per_sample",
> +                               0644, smi_debug_dir, &smi_sample_ms);
> +       smi_debug_interval_ms = debugfs_create_u32("ms_between_samples",
> +                               0644, smi_debug_dir, &smi_interval_ms);
> +       smi_debug_max = debugfs_create_u64("max_sample_us",
> +                               0644, smi_debug_dir, &smdata.max_sample);
> +       smi_debug_smi = debugfs_create_u64("smi_count",
> +                               0644, smi_debug_dir, &smdata.smi_count);
> +       smi_debug_sample = debugfs_create_file("sample_us",
> +                               0444, smi_debug_dir, &smdata, &smi_sample_fops);
> +       smi_debug_frequency_us = debugfs_create_u64("avg_smi_interval_us",
> +                               0444, smi_debug_dir, &smdata.frequency);
> +       smi_debug_threshold = debugfs_create_u64("latency_threshold_us",
> +                               0444, smi_debug_dir, &smdata.threshold);
> +
> +       smi_debug_enable = debugfs_create_file("enable",
> +                               0644, smi_debug_dir,
> +                               &enabled, &smi_enable_fops);
> +
> +
> +       if (enabled)
> +               start_smi_thread();
> +
> +       return 0;
> +}
> +
> +void smi_detector_exit(void)
> +{
> +       if (enabled) {
> +               mutex_lock(&enable_mutex);
> +               enabled = 0;
> +               stop_smi_thread();
> +               mutex_unlock(&enable_mutex);
> +       }
> +       if (smi_debug_sample_ms)
> +               debugfs_remove(smi_debug_sample_ms);
> +       if (smi_debug_interval_ms)
> +               debugfs_remove(smi_debug_interval_ms);
> +       if (smi_debug_max)
> +               debugfs_remove(smi_debug_max);
> +       if (smi_debug_smi)
> +               debugfs_remove(smi_debug_smi);
> +       if (smi_debug_frequency_us)
> +               debugfs_remove(smi_debug_frequency_us);
> +       if (smi_debug_threshold)
> +               debugfs_remove(smi_debug_threshold);
> +       if (smi_debug_sample)
> +               debugfs_remove(smi_debug_sample);
> +       if (smi_debug_enable)
> +               debugfs_remove(smi_debug_enable);
> +       if (smi_debug_dir)
> +               debugfs_remove(smi_debug_dir);



You can also use debugfs_remove_recursive()



> +}
> +
> +module_init(smi_detector_init);
> +module_exit(smi_detector_exit);
> diff --git a/scripts/smidetect b/scripts/smidetect
> new file mode 100644
> index 0000000..81593a1
> --- /dev/null
> +++ b/scripts/smidetect


The script should be in a separate patch, no?

Thanks,
Frederic.
