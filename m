Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbZAWWzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbZAWWzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 17:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbZAWWzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 17:55:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46973 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563AbZAWWzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 17:55:15 -0500
Subject: [RT] [RFC] simple SMI detector
From: Jon Masters <jcm@redhat.com>
To: linux-rt-users@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Content-Type: multipart/mixed; boundary="=-z48qLBTb14qdhZnSZi2B"
Organization: Red Hat, Inc.
Date: Fri, 23 Jan 2009 17:55:12 -0500
Message-Id: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-z48qLBTb14qdhZnSZi2B
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Folks,

Here's a simple SMI detector we've been playing around with internally.
In case anyone wants to play with it, and especially help clean it up :)

SMI events are particularly unhelpful on Real Time systems because we
effectively have the CPU stolen from under us. We can't prevent this
easily without BIOS vendors/system vendor co-operation, but we can help
to diagnose and log that these are occuring...which can be very helpful
too.

Cheers,

Jon.


--=-z48qLBTb14qdhZnSZi2B
Content-Disposition: attachment; filename=add_smi_detector_module.patch
Content-Type: text/x-patch; name=add_smi_detector_module.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

This patch adds the module smi_detector under drivers/misc

Code from Jon Masters with small changes from Luis Goncalves and
documentation from Clark Williams.

---
diff -uNp a/drivers/misc/Makefile b/drivers/misc/Makefile
--- a/drivers/misc/Makefile	2009-01-09 13:25:31.000000000 -0200
+++ b/drivers/misc/Makefile	2009-01-15 10:55:58.000000000 -0200
@@ -18,3 +18,5 @@ obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop
 obj-$(CONFIG_THINKPAD_ACPI)	+= thinkpad_acpi.o
 obj-$(CONFIG_FUJITSU_LAPTOP)	+= fujitsu-laptop.o
 obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
+obj-m				+= smi_detector.o
+
diff -uNp a/drivers/misc/smi_detector.c b/drivers/misc/smi_detector.c
--- a/drivers/misc/smi_detector.c	1969-12-31 21:00:00.000000000 -0300
+++ b/drivers/misc/smi_detector.c	2009-01-16 09:59:14.000000000 -0200
@@ -0,0 +1,242 @@
+/*
+ * A simple SMI detector. Use this module to detect large system latencies
+ * introduced by the presence of vendor BIOS SMI (System Management Interrupts)
+ * somehow gone awry. We do this by hogging all of the CPU(s) for configurable
+ * time intervals, looking to see if something stole time from us. Therefore,
+ * obviously, you should NEVER use this module in a production environment.
+ *
+ * Copyright (C) 2008 Jon Masters, Red Hat, Inc. <jcm@redhat.com>
+ *
+ * Licensed under the GNU General Public License, version 2.0.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+
+#include <linux/stop_machine.h>
+#include <linux/time.h>
+#include <linux/hrtimer.h>
+#include <linux/kthread.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+
+#define smi_version "0.2.1"
+#define SMI_BANNER "SMI Detector: "
+#define DEFAULT_MS_PER_SAMPLE 1
+#define DEFAULT_MS_SEP_SAMPLE 5000
+#define DEFAULT_SMI_THRESHOLD 1
+
+MODULE_AUTHOR("Jon Masters <jcm@redhat.com>");
+MODULE_DESCRIPTION("A simple SMI detector");
+MODULE_LICENSE("GPL");
+
+static int debug = 0;
+static int enabled = 0;
+static int threshold = 0;
+
+module_param(debug, int, 0);
+module_param(enabled, int, 0);
+module_param(threshold, int, 0);
+
+struct task_struct *smi_kthread = NULL;
+
+struct smdata_struct {
+
+	u64	last_sample;
+	u64	max_sample;
+	u64	smi_count;
+	u64	threshold;
+	ktime_t last_spike;
+	u64	frequency;
+
+	atomic_t pending;
+	wait_queue_head_t wq;
+
+} smdata;
+
+struct dentry *smi_debug_dir = NULL;	        /* SMI debugfs directory */
+struct dentry *smi_debug_max = NULL;            /* maximum TSC delta */
+struct dentry *smi_debug_smi = NULL;            /* SMI detect count */
+struct dentry *smi_debug_sample_ms = NULL;      /* sample size ms */
+struct dentry *smi_debug_interval_ms = NULL;    /* interval size ms */
+struct dentry *smi_debug_sample = NULL;		/* raw SMI samples (us) */
+struct dentry *smi_debug_threshold = NULL;	/* latency threshold (us) */
+struct dentry *smi_debug_frequency_us = NULL;	/* avg smi spike interval (us) */
+
+u32 smi_sample_ms   = DEFAULT_MS_PER_SAMPLE;    /* sample size ms */
+u32 smi_interval_ms = DEFAULT_MS_SEP_SAMPLE;    /* interval size ms */
+
+/*
+ * smi_get_sample -	Used to repeatedly capture the CPU TSC (or similar),
+ *                      looking for potential SMIs. Called under stop_machine.
+ */
+static int smi_get_sample(void *data)
+{
+	ktime_t start, t1, t2, spike;
+	s64 diff, total = 0;
+	u64 sample = 0;
+	struct smdata_struct *smi_data = (struct smdata_struct *)data;
+
+	start = ktime_get(); /* start timestamp */
+
+	do {
+
+		t1 = ktime_get();
+		t2 = ktime_get();
+
+		total = ktime_to_us(ktime_sub(t2, start));
+
+		diff = ktime_to_us(ktime_sub(t2, t1));
+		if (diff < 0) {
+			printk(KERN_ERR SMI_BANNER "time running backwards\n");
+			return 1;
+		}
+		if (diff > sample)
+			sample = diff; /* only want highest value per sample */
+
+		if (diff > smi_data->threshold)
+			spike = t1;
+
+	} while (total <= USEC_PER_MSEC*smi_sample_ms);
+
+	smi_data->last_sample = sample;
+
+	if (sample > smi_data->threshold) {
+		u64 tmp;
+
+		smi_data->smi_count++;
+		tmp = ktime_to_us(ktime_sub(spike, smi_data->last_spike));
+
+		if (smi_data->smi_count > 2)
+			smi_data->frequency = (smi_data->frequency + tmp) / 2;
+		else 
+			if (smi_data->smi_count == 2)
+				smi_data->frequency = tmp;
+
+		smi_data->last_spike = spike;
+	}
+
+	atomic_set(&smi_data->pending,1);
+
+	if (sample > smi_data->max_sample)
+		smi_data->max_sample = sample;
+ 
+	return 0;
+}
+
+/*
+ * smi_kthread_fn - Used to periodically sample the CPU TSC via smi_get_sample.
+ *                  We use stop_machine, which intentionally introduces latency.
+ */
+
+static int smi_kthread_fn(void *data)
+{
+	int err = 0;
+	struct smdata_struct *smi_data = (struct smdata_struct *)data;
+
+	while (!kthread_should_stop()) {
+		// upstream this is stop_machine now
+		err = stop_machine_run(smi_get_sample, smi_data, 0);
+
+		wake_up(&smi_data->wq);
+
+		if (msleep_interruptible(smi_interval_ms))
+			goto out;
+	}
+
+out:
+	return 0;
+}
+
+static int smi_debug_sample_fopen(struct inode *inode, struct file *filp)
+{
+
+	filp->private_data = (void *)&smdata;
+
+	return 0;	
+}
+static ssize_t smi_debug_sample_fread(struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	int len;
+	char buf[64];
+	struct smdata_struct *smi_data = filp->private_data;
+
+	wait_event_interruptible(smi_data->wq, atomic_read(&smi_data->pending));
+	atomic_set(&smi_data->pending,0);
+	len = sprintf(buf, "%08llx\n", smi_data->last_sample);
+	copy_to_user(ubuf, buf, len);
+
+	return len;
+}
+
+static struct file_operations smi_sample_fops = {
+	.open		= smi_debug_sample_fopen,
+	.read		= smi_debug_sample_fread,
+	.owner		= THIS_MODULE,
+};
+
+int smi_detector_init(void)
+{
+
+	printk(KERN_INFO SMI_BANNER "version %s\n", smi_version);
+	if (!enabled) {
+		printk(KERN_INFO SMI_BANNER "please reload with enabled=1\n");
+		return -1;
+	}
+
+	smdata.last_sample = 0;
+	smdata.max_sample = 0;
+	smdata.smi_count = 0;
+	smdata.frequency = 0;
+
+	if (!threshold)
+		smdata.threshold = DEFAULT_SMI_THRESHOLD;
+	else
+		smdata.threshold = threshold;
+
+	init_waitqueue_head(&smdata.wq);
+	atomic_set(&smdata.pending, 0);
+
+	smi_debug_dir = debugfs_create_dir("smi_detector", NULL);
+
+	smi_debug_sample_ms = debugfs_create_u32("ms_per_sample",
+				0644, smi_debug_dir, &smi_sample_ms);
+	smi_debug_interval_ms = debugfs_create_u32("ms_between_samples",
+				0644, smi_debug_dir, &smi_interval_ms);
+	smi_debug_max = debugfs_create_u64("max_sample_us",
+				0644, smi_debug_dir, &smdata.max_sample);
+	smi_debug_smi = debugfs_create_u64("smi_count",
+				0644, smi_debug_dir, &smdata.smi_count);
+	smi_debug_sample = debugfs_create_file("sample_us",
+				0444, smi_debug_dir, &smdata, &smi_sample_fops);
+	smi_debug_frequency_us = debugfs_create_u64("avg_smi_interval_us",
+				0444, smi_debug_dir, &smdata.frequency);
+	smi_debug_threshold = debugfs_create_u64("latency_threshold_us",
+				0444, smi_debug_dir, &smdata.threshold);
+
+
+	smi_kthread = kthread_run(smi_kthread_fn, &smdata, "smi_detector");
+
+	return 0;
+
+}
+
+void smi_detector_exit(void)
+{
+	kthread_stop(smi_kthread);
+
+	debugfs_remove(smi_debug_sample_ms);
+	debugfs_remove(smi_debug_interval_ms);
+	debugfs_remove(smi_debug_max);
+	debugfs_remove(smi_debug_smi);
+	debugfs_remove(smi_debug_frequency_us);
+	debugfs_remove(smi_debug_threshold);
+	debugfs_remove(smi_debug_sample);
+	debugfs_remove(smi_debug_dir);
+}
+
+module_init(smi_detector_init);
+module_exit(smi_detector_exit);
diff -uNp a/Documentation/smi_detector.txt a/Documentation/smi_detector.txt
--- a/Documentation/smi_detector.txt	1969-12-31 21:00:00.000000000 -0300
+++ b/Documentation/smi_detector.txt	2009-01-16 16:22:21.000000000 -0200
@@ -0,0 +1,94 @@
+Introduction:
+-------------
+
+The module smi_detector is a special purpose kernel module that is
+used to detect if System Management Interrupts (SMIs) are causing event
+latencies in the Linux RT kernel.
+
+SMIs are usually not serviced by the Linux kernel. They are set up by
+BIOS code and are serviced by BIOS code, usually for critical events
+such as management of thermal sensors and fans. Sometimes though, SMIs
+are used for other tasks and those tasks can spend an inordinate
+amount of time in the handler (sometimes measured in milliseconds).
+Obviously if you are trying to keep event service latencies down in the
+microsecond range, this is a problem.
+
+The SMI detector works by hogging the cpu for configurable amounts of
+time (by calling stop_machine()), polling the Time Stamp Counter (TSC)
+register for some period, then looking for gaps in the TSC data. Any
+gap indicates a time when the polling was interrupted and since the
+machine is stopped and interrupts turned off the only thing that could
+do that would be an SMI.
+
+Note that the SMI detector should *NEVER* be used in a production
+environment. It is intended to be run manually to determine if the
+hardware platform has a problem with long SMI service routines.
+
+Usage:
+------
+
+Loading the module smi_detector passing the parameter "enabled=1" is the only
+step required to start the smi_detector. It is possible to define a threshold
+in microseconds (us) above which latency spikes will be taken in account
+(parameter "threshold=").
+
+Example:
+
+	# insmod ./smi_detector.ko enabled=1 threshold=100
+
+After the module is loaded, it creates a directory named "smi_detector" under
+the debugfs mountpoint, "/debugfs/smi_detector" for this text. It is necessary
+to have debugfs mounted.
+
+avg_smi_interval_us	- average interval (usecs) between SMI latency spikes
+latency_threshold_us	- minimum latency value to be considered (usecs)
+max_sample_us		- maximum SMI latency spike observed (usecs)
+ms_between_samples	- interval between samples (ms)
+ms_per_sample		- sampling time (ms)
+sample_us		- last sample (usecs). Continously updated, may be used
+			  to plot graphs or to create histograms
+smi_count		- how many latency spikes have been observed
+
+
+	# cd /debugfs/smi_detector
+
+	# cat *
+	0		(avg_smi_interval_us)
+	100		(latency_threshold_us)
+	0		(latency_threshold_us)
+	5000		(ms_between_samples)
+	1		(ms_per_sample)
+	3		(sample_us)
+	0		(smi_count)
+
+
+The default values for ms_between_samples and ms_per_sample define that every
+5000ms (5s) samples will be collected during 1ms. It is possible to change the
+sampling time or the sampling interval writing to the related files. To collect
+samples during 5ms every 50ms:
+
+	# echo 5 > ms_per_sample
+	# echo 50 > ms_between_samples
+
+
+	# cat ms_between_samples
+	50
+	# cat ms_per_sample
+	5
+
+After a while, data may be verified to atest the existence of SMI induced
+latencies:
+
+	# cat smi_count 
+	2
+	# cat max_sample_us 
+	468
+	# cat avg_smi_interval_us 
+	1356306050
+
+Depending on the latencies observed it is important to better adjust the
+sampling intervals to obtain more accurate measurements. Care must be taken
+to not create a continous sampling situation, that might be perceived by the
+kernel as a deadlock.
+
+

--=-z48qLBTb14qdhZnSZi2B--

