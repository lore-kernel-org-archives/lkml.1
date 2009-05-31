Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbZEaUaC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbZEaUaC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 16:30:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZEaU3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 16:29:44 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:43592 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbZEaU3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 16:29:41 -0400
Message-Id: <20090531163343.771922592@jonmasters.org>
User-Agent: quilt/0.47-1
Date: Sun, 31 May 2009 12:31:18 -0400
From: Jon Masters <jonathan@jonmasters.org>
To: linux-kernel@vger.kernel.org
Cc: jonathan@jonmasters.org, jcm@redhat.com, tglx@linutronix.de, mingo@elte.hu,
       rostedt@goodmis.org
Subject: [RFC PATCH 1/1] smi_detector: A System Management Interrupt detector
References: <20090531163117.502167374@jonmasters.org>
Content-Disposition: inline; filename=smi-detector.patch
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jcm@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new SMI (System Management Interrupt) detector module
that can be used to detect high latencies within the system. It was originally
written for use in the RT kernel, but has wider applications.

Signed-off-by: Jon Masters <jcm@jonmasters.org>

Index: jcm_26_quilt/Documentation/smi_detector.txt
===================================================================
--- /dev/null
+++ jcm_26_quilt/Documentation/smi_detector.txt
@@ -0,0 +1,57 @@
+Introduction:
+-------------
+
+The module smi_detector is a special purpose kernel module that is used to
+detect if System Management Interrupts (SMIs) are causing excessive event
+latencies within the Linux kernel. It was originally written for use by
+the 'RT' patch since the Real Time kernel is highly latency sensitive.
+
+SMIs are usually not serviced by the Linux kernel, which typically does not
+even know that they are occuring. SMIs are instead are set up by BIOS code
+and are serviced by BIOS code, usually for 'critical' events such as
+management of thermal sensors and fans. Sometimes though, SMIs are used for
+other tasks and those tasks can spend an inordinate amount of time in the
+handler (sometimes measured in milliseconds). Obviously this is a problem if
+you are trying to keep event service latencies down in the microsecond range.
+
+The SMI detector works by hogging all of the cpus for configurable amounts of
+time (by calling stop_machine()), polling the CPU Time Stamp Counter (TSC)
+for some period, then looking for gaps in the TSC data. Any gap indicates a
+time when the polling was interrupted and since the machine is stopped and
+interrupts turned off the only thing that could do that would be an SMI.
+
+Note that the SMI detector should *NEVER* be used in a production environment.
+It is intended to be run manually to determine if the hardware platform has a
+problem with long SMI service routines.
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
+	# modprobe smi_detector enabled=1 threshold=100
+
+After the module is loaded, it creates a directory named "smi_detector" under
+the debugfs mountpoint, "/debug/smi_detector" for this text. It is necessary
+to have debugfs mounted, which might be on /sys/debug on your system.
+
+The /debug interface contains the following files:
+
+count			- number of SMIs observed since last reset
+enable			- a global enable/disable toggle (0/1), resets count.
+max			- maximum SMI latecy actually observed (usecs)
+sample			- a pipe from which to read current SMI data
+			  in the format <timestamp> <smi observed usecs>
+threshold		- minimum latency value to be considered an SMI (usecs)
+width			- time period to sample with CPUs held (usecs)
+			  must be less than the total window size (enforced)
+window			- total period of sampling, width being inside (usecs)
+
+By default we will set width to 1000 and window to 50000, meaning that we will
+sample every 50,000 usecs for 1,000 usecs. If we observe any latencies that
+exceed the threshold (initially 100 usecs) then we write to the sample pipe.
Index: jcm_26_quilt/drivers/misc/Kconfig
===================================================================
--- jcm_26_quilt.orig/drivers/misc/Kconfig
+++ jcm_26_quilt/drivers/misc/Kconfig
@@ -76,6 +76,21 @@ config IBM_ASM
 	  information on the specific driver level and support statement
 	  for your IBM server.
 
+config SMI_DETECTOR
+	tristate "Test module for detecting time gaps caused by SMIs"
+	depends on DEBUG_FS
+	default m
+	---help---
+	  A simple SMI detector. Use this module to detect large system
+	  latencies introduced by the presence of vendor BIOS SMI
+	  (System Management Interrupts) somehow gone awry. We do this
+	  by hogging all of the CPU(s) for configurable time intervals,
+	  looking to see if something stole time from us. Therefore,
+	  obviously, you should NEVER use this module in a production
+	  environment.
+
+	  If unsure, say N
+
 config PHANTOM
 	tristate "Sensable PHANToM (PCI)"
 	depends on PCI
Index: jcm_26_quilt/drivers/misc/Makefile
===================================================================
--- jcm_26_quilt.orig/drivers/misc/Makefile
+++ jcm_26_quilt/drivers/misc/Makefile
@@ -21,3 +21,4 @@ obj-$(CONFIG_HP_ILO)		+= hpilo.o
 obj-$(CONFIG_ISL29003)		+= isl29003.o
 obj-$(CONFIG_C2PORT)		+= c2port/
 obj-y				+= eeprom/
+obj-$(CONFIG_SMI_DETECTOR)	+= smi_detector.o
Index: jcm_26_quilt/drivers/misc/smi_detector.c
===================================================================
--- /dev/null
+++ jcm_26_quilt/drivers/misc/smi_detector.c
@@ -0,0 +1,1173 @@
+/*
+ * smi_detector.c - A simple SMI detector.
+ *
+ * Use this module to detect large system latencies introduced by the presence
+ * of vendor BIOS SMI (System Management Interrupts) somehow gone awry. We do
+ * this by hogging all of the CPU(s) for configurable time intervals, looking
+ * to see if something stole time from us. Therefore, obviously, you should
+ * NEVER use this module in a production environment.
+ *
+ * Copyright (C) 2008-2009 Jon Masters, Red Hat, Inc. <jcm@redhat.com>
+ *
+ * Includes useful feedback from Clark Williams <clark@redhat.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/ring_buffer.h>
+#include <linux/stop_machine.h>
+#include <linux/time.h>
+#include <linux/hrtimer.h>
+#include <linux/kthread.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/version.h>
+
+#define SMI_BUF_SIZE_DEFAULT	  262144UL		/* 8K*(sizeof(entry)) */
+#define SMI_BUF_FLAGS		  (RB_FL_OVERWRITE)	/* no block on full */
+#define SMI_U64STR_SIZE		  22			/* 20 digits max */
+
+#define SMI_VERSION		  "2.0.0"
+#define SMI_BANNER		  "smi_detector: "
+#define SMI_DEFAULT_SAMPLE_WINDOW 50000			/* 50ms */
+#define SMI_DEFAULT_SAMPLE_WIDTH  1000			/* 1ms */
+#define SMI_DEFAULT_SMI_THRESHOLD 10			/* 10us */
+
+/* Module metadata */
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jon Masters <jcm@redhat.com>");
+MODULE_DESCRIPTION("A simple SMI detector");
+MODULE_VERSION(SMI_VERSION);
+
+/* Module parameters */
+
+static int debug;
+static int enabled;
+static int threshold;
+
+module_param(debug, int, 0);				/* enable debug */
+module_param(enabled, int, 0);				/* enable detector */
+module_param(threshold, int, 0);			/* SMI threshold */
+
+/* Buffering and sampling */
+
+static struct ring_buffer *smi_ring_buffer;		/* sample buffer */
+static DEFINE_MUTEX(smi_ring_buffer_mutex);		/* lock changes */
+static unsigned long smi_buf_size = SMI_BUF_SIZE_DEFAULT;
+static struct task_struct *smi_kthread;			/* sampling thread */
+
+/* DebugFS filesystem entries */
+
+static struct dentry *smi_debug_dir;            /* SMI debugfs directory */
+static struct dentry *smi_debug_max;            /* maximum TSC delta */
+static struct dentry *smi_debug_count;          /* SMI detect count */
+static struct dentry *smi_debug_sample_width;   /* sample width us */
+static struct dentry *smi_debug_sample_window;  /* sample window us */
+static struct dentry *smi_debug_sample;         /* raw SMI samples us */
+static struct dentry *smi_debug_threshold;      /* latency threshold us */
+static struct dentry *smi_debug_enable;         /* enable/disable */
+
+/* Individual samples and global state */
+
+struct smi_sample;				/* SMI sample */
+struct smi_data;				/* Global state */
+
+/* Sampling functions */
+static int __smi_buffer_add_sample(struct smi_sample *sample);
+static struct smi_sample *smi_buffer_get_sample(struct smi_sample *sample);
+static int smi_get_sample(void *unused);
+
+/* Threading and state */
+static int smi_kthread_fn(void *unused);
+static int smi_start_kthread(void);
+static int smi_stop_kthread(void);
+static void __smi_reset_stats(void);
+static int smi_init_stats(void);
+
+/* Debugfs interface */
+static int smi_debug_sample_fopen(struct inode *inode, struct file *filp);
+static ssize_t smi_debug_sample_fread(struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos);
+static int smi_debug_sample_release(struct inode *inode, struct file *filp);
+static int smi_debug_enable_fopen(struct inode *inode, struct file *filp);
+static ssize_t smi_debug_enable_fread(struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos);
+static ssize_t  smi_debug_enable_fwrite(struct file *file,
+					const char __user *user_buffer,
+					size_t user_size,
+					loff_t *offset);
+
+/* Initialization functions */
+static int smi_init_debugfs(void);
+static void smi_free_debugfs(void);
+static int smi_detector_init(void);
+static void smi_detector_exit(void);
+
+/* Individual SMI samples are stored here when detected and packed into
+ * the smi_ring_buffer circular buffer, where they are overwritten when
+ * more than smi_buf_size/sizeof(smi_sample) samples are received. */
+struct smi_sample {
+	u64		seqnum;		/* unique sequence */
+	u64		duration;	/* ktime delta */
+	struct timespec	timestamp;	/* wall time */
+};
+
+/* keep the global state somewhere. Mostly used under stop_machine. */
+static struct smi_data {
+
+	struct mutex lock;		/* protect changes */
+
+	u64	count;			/* total since reset */
+	u64	max_sample;		/* max SMI observed */
+	u64	threshold;		/* sample threshold level */
+
+	u64	sample_window;		/* total sampling window (on+off) */
+	u64	sample_width;		/* portion of window to sample */
+
+	atomic_t sample_open;		/* whether the sample file is open */
+
+	wait_queue_head_t wq;		/* waitqeue for new sample values */
+
+} smi_data;
+
+/**
+ * __smi_buffer_add_sample - add a new SMI sample recording to the ring buffer
+ * @sample: The new SMI sample value
+ *
+ * This receives a new SMI sample and records it in a global circular buffer.
+ * No additional locking is used in this case - suited for stop_machine use.
+ */
+static int __smi_buffer_add_sample(struct smi_sample *sample)
+{
+	return ring_buffer_write(smi_ring_buffer,
+				 sizeof(struct smi_sample), sample);
+}
+
+/**
+ * smi_buffer_get_sample - remove an SMI sample from the ring buffer
+ * @sample: Pre-allocated storage for the sample
+ *
+ * This retrieves an SMI sample from the global circular buffer
+ */
+static struct smi_sample *smi_buffer_get_sample(struct smi_sample *sample)
+{
+	struct ring_buffer_event *e = NULL;
+	struct smi_sample *s = NULL;
+	unsigned int cpu = 0;
+
+	if (!sample)
+		return NULL;
+
+	/* ring_buffers are per-cpu but we just want any value */
+	/* so we'll start with this cpu and try others if not */
+	/* Steven is planning to add a generic mechanism */
+	mutex_lock(&smi_ring_buffer_mutex);
+	e = ring_buffer_consume(smi_ring_buffer, smp_processor_id(), NULL);
+	if (!e) {
+		for_each_online_cpu(cpu) {
+			e = ring_buffer_consume(smi_ring_buffer, cpu, NULL);
+			if (e)
+				break;
+		}
+	}
+
+	if (e) {
+		s = ring_buffer_event_data(e);
+		memcpy(sample, s, sizeof(struct smi_sample));
+	} else
+		sample = NULL;
+	mutex_unlock(&smi_ring_buffer_mutex);
+
+	return sample;
+}
+
+/**
+ * smi_get_sample - sample the CPU TSC (or similar) and look for likely SMIs
+ * @unused: This is not used but is a part of the stop_machine API
+ *
+ * Used to repeatedly capture the CPU TSC (or similar), looking for potential
+ * SMIs. Called under stop_machine, with smi_data.lock held.
+ */
+static int smi_get_sample(void *unused)
+{
+	ktime_t start, t1, t2;
+	s64 diff, total = 0;
+	u64 sample = 0;
+	int ret = 1;
+
+	start = ktime_get(); /* start timestamp */
+
+	do {
+
+		t1 = ktime_get();	/* we'll look for a discontinuity */
+		t2 = ktime_get();
+
+		total = ktime_to_us(ktime_sub(t2, start)); /* sample width */
+		diff = ktime_to_us(ktime_sub(t2, t1));     /* current diff */
+
+		/* This shouldn't happen */
+		if (diff < 0) {
+			printk(KERN_ERR SMI_BANNER "time running backwards\n");
+			goto out;
+		}
+
+		if (diff > sample)
+			sample = diff; /* only want highest value */
+
+	} while (total <= smi_data.sample_width);
+
+	/* If we exceed the SMI threshold value, we have found an SMI */
+	if (sample > smi_data.threshold) {
+		struct smi_sample s;
+
+		smi_data.count++;
+		s.seqnum = smi_data.count;
+		s.duration = sample;
+		s.timestamp = CURRENT_TIME;
+		__smi_buffer_add_sample(&s);
+
+		/* Keep a running maximum ever recorded SMI */
+		if (sample > smi_data.max_sample)
+			smi_data.max_sample = sample;
+
+		wake_up(&smi_data.wq); /* wake up reader(s) */
+	}
+
+	ret = 0;
+out:
+	return ret;
+}
+
+/*
+ * smi_kthread_fn - The CPU time sampling/SMI detection kernel thread
+ * @unused: A required part of the kthread API.
+ *
+ * Used to periodically sample the CPU TSC via a call to smi_get_sample. We
+ * use stop_machine, whith does (intentionally) introduce latency since we
+ * need to ensure nothing else might be running (and thus pre-empting).
+ * Obviously this should never be used in production environments.
+ *
+ * stop_machine will schedule us typically only on CPU0 which is fine for
+ * almost every SMI situation - but we might generalize this later if we
+ * find there are any actualy systems with alternate SMI delivery.
+ */
+static int smi_kthread_fn(void *unused)
+{
+	int err = 0;
+	u64 interval = 0;
+
+	while (!kthread_should_stop()) {
+
+		mutex_lock(&smi_data.lock);
+
+		err = stop_machine(smi_get_sample, unused, 0);
+		if (err) {
+			/* Houston, we have a problem */
+			mutex_unlock(&smi_data.lock);
+			goto err_out;
+		}
+
+		interval = smi_data.sample_window - smi_data.sample_width;
+		do_div(interval, USEC_PER_MSEC); /* modifies interval value */
+
+		mutex_unlock(&smi_data.lock);
+
+		if (msleep_interruptible(interval))
+			goto out;
+
+	}
+
+		goto out;
+err_out:
+	printk(KERN_ERR SMI_BANNER "could not call stop_machine, disabling\n");
+	enabled = 0;
+out:
+	return err;
+
+}
+
+/**
+ * smi_start_kthread - Kick off the SMI sampling/detection kernel thread
+ *
+ * This starts a kernel thread that will sit and sample the CPU timestamp
+ * counter (TSC or similar) and look for potential SMIs.
+ */
+static int smi_start_kthread(void)
+{
+	smi_kthread = kthread_run(smi_kthread_fn, NULL,
+					"smi_detector");
+	if (!smi_kthread) {
+		printk(KERN_ERR SMI_BANNER "could not start sampling thread\n");
+		enabled = 0;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/**
+ * smi_stop_kthread - Inform the SMI detect/sampling kernel thread to stop
+ *
+ * This kicks the running SMI detect/sampling kernel thread and tells it to
+ * stop sampling now. Use this on unload and at system shutdown.
+ */
+static int smi_stop_kthread(void)
+{
+	int ret = -ENOMEM;
+
+	ret = kthread_stop(smi_kthread);
+
+	return ret;
+}
+
+/**
+ * __smi_reset_stats - Reset statistics for the SMI detector
+ *
+ * We use smi_data to store various statistics and global state. We call this
+ * function in order to reset those when "enable" is toggled on or off, and
+ * also at initialization. Should be called with smi_data.lock held.
+ */
+static void __smi_reset_stats(void)
+{
+	smi_data.count = 0;
+	smi_data.max_sample = 0;
+	ring_buffer_reset(smi_ring_buffer); /* flush out old sample entries */
+}
+
+/**
+ * smi_init_stats - Setup the global state and statistics for the SMI detector
+ *
+ * We use smi_data to store various statistics and global state. We also use
+ * a global ring buffer (smi_ring_buffer) to keep raw samples of detected SMIs.
+ * This function initializes these structures and allocates the ring buffer.
+ */
+static int smi_init_stats(void)
+{
+	int ret = -ENOMEM;
+
+	mutex_init(&smi_data.lock);
+	init_waitqueue_head(&smi_data.wq);
+	atomic_set(&smi_data.sample_open, 0);
+
+	smi_ring_buffer = ring_buffer_alloc(smi_buf_size, SMI_BUF_FLAGS);
+
+	if (!smi_ring_buffer) {
+		printk(KERN_ERR SMI_BANNER "failed to allocate ring buffer!\n");
+		WARN_ON(1);
+		goto out;
+	}
+
+	__smi_reset_stats();
+	smi_data.threshold = SMI_DEFAULT_SMI_THRESHOLD;	    /* threshold us */
+	smi_data.sample_window = SMI_DEFAULT_SAMPLE_WINDOW; /* window us */
+	smi_data.sample_width = SMI_DEFAULT_SAMPLE_WIDTH;   /* width us */
+
+	ret = 0;
+
+out:
+	return ret;
+
+}
+
+/**
+ * smi_debug_count_fopen - Open function for "count" debugfs entry
+ * @inode: The in-kernel inode representation of the debugfs "file"
+ * @filp: The active open file structure for the debugfs "file"
+ *
+ * This function provides an open implementation for the "count" debugfs
+ * interface to the SMI detector.
+ */
+static int smi_debug_count_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+/**
+ * smi_debug_count_fread - Read function for "count" debugfs entry
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The userspace provided buffer to read value into
+ * @cnt: The maximum number of bytes to read
+ * @ppos: The current "file" position
+ */
+static ssize_t smi_debug_count_fread(struct file *filp, char __user *ubuf,
+				     size_t cnt, loff_t *ppos)
+{
+	char buf[SMI_U64STR_SIZE];
+	u64 val = 0;
+	int len = 0;
+
+	memset(buf, 0, sizeof(buf));
+
+	if ((cnt < sizeof(buf)) || (*ppos))
+		return 0;
+
+	mutex_lock(&smi_data.lock);
+	val = smi_data.count;
+	mutex_unlock(&smi_data.lock);
+
+	len = snprintf(buf, SMI_U64STR_SIZE, "%llu\n", val);
+
+	if (copy_to_user(ubuf, buf, len))
+		return -EFAULT;
+	return *ppos = len;
+}
+
+/**
+ * smi_debug_count_fwrite - Write function for "count" debugfs entry
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The user buffer that contains the value to write
+ * @cnt: The maximum number of bytes to write to "file"
+ * @ppos: The current position in the debugfs "file"
+ */
+static ssize_t  smi_debug_count_fwrite(struct file *filp,
+				       const char __user *ubuf,
+				       size_t cnt,
+				       loff_t *ppos)
+{
+	char buf[SMI_U64STR_SIZE];
+	int csize = min(cnt, sizeof(buf));
+	u64 val = 0;
+	int err = 0;
+
+	memset(buf, '\0', sizeof(buf));
+	if (copy_from_user(buf, ubuf, csize))
+		return -EFAULT;
+
+	buf[SMI_U64STR_SIZE-1] = '\0';			/* just in case */
+	err = strict_strtoull(buf, 10, &val);
+	if (0 != err)
+		return -EINVAL;
+
+	mutex_lock(&smi_data.lock);
+	smi_data.count = val;
+	mutex_unlock(&smi_data.lock);
+
+	return csize;
+}
+
+/**
+ * smi_debug_enable_fopen - Dummy open function for "enable" debugfs interface
+ * @inode: The in-kernel inode representation of the debugfs "file"
+ * @filp: The active open file structure for the debugfs "file"
+ *
+ * This function provides an "open implementation for the "enable" debugfs
+ * interface to the SMI detector.
+ */
+static int smi_debug_enable_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+/**
+ * smi_debug_enable_fread - Read function for "enable" debugfs interface
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The userspace provided buffer to read value into
+ * @cnt: The maximum number of bytes to read
+ * @ppos: The current "file" position
+ */
+static ssize_t smi_debug_enable_fread(struct file *filp, char __user *ubuf,
+				      size_t cnt, loff_t *ppos)
+{
+	char buf[4];
+
+	if ((cnt < sizeof(buf)) || (*ppos))
+		return 0;
+
+	buf[0] = enabled ? '1' : '0';
+	buf[1] = '\n';
+	buf[2] = '\0';
+	if (copy_to_user(ubuf, buf, strlen(buf)))
+		return -EFAULT;
+	return *ppos = strlen(buf);
+}
+
+/**
+ * smi_debug_enable_fwrite - Write function for "enable" debugfs interface
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The user buffer that contains the value to write
+ * @cnt: The maximum number of bytes to write to "file"
+ * @ppos: The current position in the debugfs "file"
+ */
+static ssize_t  smi_debug_enable_fwrite(struct file *filp,
+					const char __user *ubuf,
+					size_t cnt,
+					loff_t *ppos)
+{
+	char buf[4];
+	int csize = min(cnt, sizeof(buf));
+	long val = 0;
+	int err = 0;
+
+	memset(buf, '\0', sizeof(buf));
+	if (copy_from_user(buf, ubuf, csize))
+		return -EFAULT;
+
+	buf[sizeof(buf)-1] = '\0';			/* just in case */
+	err = strict_strtoul(buf, 10, &val);
+	if (0 != err)
+		return -EINVAL;
+
+	if (val) {
+		if (enabled)
+			goto unlock;
+		enabled = 1;
+		__smi_reset_stats();
+		if (smi_start_kthread())
+			return -EFAULT;
+	} else {
+		if (!enabled)
+			goto unlock;
+		enabled = 0;
+		smi_stop_kthread();
+		wake_up(&smi_data.wq);		/* reader(s) should return */
+	}
+unlock:
+	return csize;
+}
+
+/**
+ * smi_debug_max_fopen - Open function for "max" debugfs entry
+ * @inode: The in-kernel inode representation of the debugfs "file"
+ * @filp: The active open file structure for the debugfs "file"
+ *
+ * This function provides an open implementation for the "max" debugfs
+ * interface to the SMI detector.
+ */
+static int smi_debug_max_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+/**
+ * smi_debug_max_fread - Read function for "max" debugfs entry
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The userspace provided buffer to read value into
+ * @cnt: The maximum number of bytes to read
+ * @ppos: The current "file" position
+ */
+static ssize_t smi_debug_max_fread(struct file *filp, char __user *ubuf,
+				   size_t cnt, loff_t *ppos)
+{
+	char buf[SMI_U64STR_SIZE];
+	u64 val = 0;
+	int len = 0;
+
+	memset(buf, 0, sizeof(buf));
+
+	if ((cnt < sizeof(buf)) || (*ppos))
+		return 0;
+
+	mutex_lock(&smi_data.lock);
+	val = smi_data.max_sample;
+	mutex_unlock(&smi_data.lock);
+
+	len = snprintf(buf, SMI_U64STR_SIZE, "%llu\n", val);
+
+	if (copy_to_user(ubuf, buf, len))
+		return -EFAULT;
+	return *ppos = len;
+}
+
+/**
+ * smi_debug_max_fwrite - Write function for "max" debugfs entry
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The user buffer that contains the value to write
+ * @cnt: The maximum number of bytes to write to "file"
+ * @ppos: The current position in the debugfs "file"
+ */
+static ssize_t  smi_debug_max_fwrite(struct file *filp,
+				     const char __user *ubuf,
+				     size_t cnt,
+				     loff_t *ppos)
+{
+	char buf[SMI_U64STR_SIZE];
+	int csize = min(cnt, sizeof(buf));
+	u64 val = 0;
+	int err = 0;
+
+	memset(buf, '\0', sizeof(buf));
+	if (copy_from_user(buf, ubuf, csize))
+		return -EFAULT;
+
+	buf[SMI_U64STR_SIZE-1] = '\0';			/* just in case */
+	err = strict_strtoull(buf, 10, &val);
+	if (0 != err)
+		return -EINVAL;
+
+	mutex_lock(&smi_data.lock);
+	smi_data.max_sample = val;
+	mutex_unlock(&smi_data.lock);
+
+	return csize;
+}
+
+
+/**
+ * smi_debug_sample_fopen - An open function for "sample" debugfs interface
+ * @inode: The in-kernel inode representation of this debugfs "file"
+ * @filp: The active open file structure for the debugfs "file"
+ *
+ * This function handles opening the "sample" file within the SMI detector
+ * debugfs directory interface. This file is used to read raw samples from
+ * the SMI ring_buffer and allows the user to see a running SMI history.
+ */
+static int smi_debug_sample_fopen(struct inode *inode, struct file *filp)
+{
+	int ret = 0;
+
+	mutex_lock(&smi_data.lock);
+	if (atomic_read(&smi_data.sample_open))
+		ret = -EBUSY;
+	else
+		atomic_inc(&smi_data.sample_open);
+	mutex_unlock(&smi_data.lock);
+
+	return ret;
+}
+
+/**
+ * smi_debug_sample_fread - A read function for "sample" debugfs interface
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The user buffer that will contain the samples read
+ * @cnt: The maximum bytes to read from the debugfs "file"
+ * @ppos: The current position in the debugfs "file"
+ *
+ * This function handles reading from the "sample" file within the SMI
+ * detector debugfs directory interface. This file is used to read raw samples
+ * from the SMI ring_buffer and allows the user to see a running SMI history.
+ */
+static ssize_t smi_debug_sample_fread(struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	int len = 0;
+	char buf[64];
+	struct smi_sample *sample = NULL;
+
+	if (!enabled)
+		return 0;
+
+	sample = kzalloc(sizeof(struct smi_sample), GFP_KERNEL);
+	if (!sample)
+		return -EFAULT;
+
+	while (!smi_buffer_get_sample(sample)) {
+
+		DEFINE_WAIT(wait);
+
+		if (filp->f_flags & O_NONBLOCK) {
+			len = -EAGAIN;
+			goto out;
+		}
+
+		prepare_to_wait(&smi_data.wq, &wait, TASK_INTERRUPTIBLE);
+		schedule();
+		finish_wait(&smi_data.wq, &wait);
+
+		if (signal_pending(current)) {
+			len = -EINTR;
+			goto out;
+		}
+
+		if (!enabled) {			/* enable was toggled */
+			len = 0;
+			goto out;
+		}
+	}
+
+	len = snprintf(buf, sizeof(buf), "%010lu.%010lu\t%llu\n",
+		      sample->timestamp.tv_sec,
+		      sample->timestamp.tv_nsec,
+		      sample->duration);
+
+
+	/* handling partial reads is more trouble than it's worth */
+	if (len > cnt)
+		goto out;
+
+	if (copy_to_user(ubuf, buf, len))
+		len = -EFAULT;
+
+out:
+	kfree(sample);
+	return len;
+}
+
+/**
+ * smi_debug_sample_release - Release function for "sample" debugfs interface
+ * @inode: The in-kernel inode represenation of the debugfs "file"
+ * @filp: The active open file structure for the debugfs "file"
+ *
+ * This function completes the close of the debugfs interface "sample" file.
+ */
+static int smi_debug_sample_release(struct inode *inode, struct file *filp)
+{
+	mutex_lock(&smi_data.lock);
+	atomic_dec(&smi_data.sample_open);
+	mutex_unlock(&smi_data.lock);
+
+	return 0;
+}
+
+/**
+ * smi_debug_threshold_fopen - Open function for "threshold" debugfs entry
+ * @inode: The in-kernel inode representation of the debugfs "file"
+ * @filp: The active open file structure for the debugfs "file"
+ *
+ * This function provides an open implementation for the "threshold" debugfs
+ * interface to the SMI detector.
+ */
+static int smi_debug_threshold_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+/**
+ * smi_debug_threshold_fread - Read function for "threshold" debugfs entry
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The userspace provided buffer to read value into
+ * @cnt: The maximum number of bytes to read
+ * @ppos: The current "file" position
+ */
+static ssize_t smi_debug_threshold_fread(struct file *filp, char __user *ubuf,
+					 size_t cnt, loff_t *ppos)
+{
+	char buf[SMI_U64STR_SIZE];
+	u64 val = 0;
+	int len = 0;
+
+	memset(buf, 0, sizeof(buf));
+
+	if ((cnt < sizeof(buf)) || (*ppos))
+		return 0;
+
+	mutex_lock(&smi_data.lock);
+	val = smi_data.threshold;
+	mutex_unlock(&smi_data.lock);
+
+	len = snprintf(buf, SMI_U64STR_SIZE, "%llu\n", val);
+
+	if (copy_to_user(ubuf, buf, len))
+		return -EFAULT;
+	return *ppos = len;
+}
+
+/**
+ * smi_debug_threshold_fwrite - Write function for "threshold" debugfs entry
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The user buffer that contains the value to write
+ * @cnt: The maximum number of bytes to write to "file"
+ * @ppos: The current position in the debugfs "file"
+ */
+static ssize_t  smi_debug_threshold_fwrite(struct file *filp,
+					const char __user *ubuf,
+					size_t cnt,
+					loff_t *ppos)
+{
+	char buf[SMI_U64STR_SIZE];
+	int csize = min(cnt, sizeof(buf));
+	u64 val = 0;
+	int err = 0;
+
+	memset(buf, '\0', sizeof(buf));
+	if (copy_from_user(buf, ubuf, csize))
+		return -EFAULT;
+
+	buf[SMI_U64STR_SIZE-1] = '\0';			/* just in case */
+	err = strict_strtoull(buf, 10, &val);
+	if (0 != err)
+		return -EINVAL;
+
+	mutex_lock(&smi_data.lock);
+	smi_data.threshold = val;
+	mutex_unlock(&smi_data.lock);
+
+	if (enabled)
+		wake_up_process(smi_kthread);
+
+	return csize;
+}
+
+/**
+ * smi_debug_width_fopen - Open function for "width" debugfs entry
+ * @inode: The in-kernel inode representation of the debugfs "file"
+ * @filp: The active open file structure for the debugfs "file"
+ *
+ * This function provides an open implementation for the "width" debugfs
+ * interface to the SMI detector.
+ */
+static int smi_debug_width_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+/**
+ * smi_debug_width_fread - Read function for "width" debugfs entry
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The userspace provided buffer to read value into
+ * @cnt: The maximum number of bytes to read
+ * @ppos: The current "file" position
+ */
+static ssize_t smi_debug_width_fread(struct file *filp, char __user *ubuf,
+				     size_t cnt, loff_t *ppos)
+{
+	char buf[SMI_U64STR_SIZE];
+	u64 val = 0;
+	int len = 0;
+
+	memset(buf, 0, sizeof(buf));
+
+	if ((cnt < sizeof(buf)) || (*ppos))
+		return 0;
+
+	mutex_lock(&smi_data.lock);
+	val = smi_data.sample_width;
+	mutex_unlock(&smi_data.lock);
+
+	len = snprintf(buf, SMI_U64STR_SIZE, "%llu\n", val);
+
+	if (copy_to_user(ubuf, buf, len))
+		return -EFAULT;
+	return *ppos = len;
+}
+
+/**
+ * smi_debug_width_fwrite - Write function for "width" debugfs entry
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The user buffer that contains the value to write
+ * @cnt: The maximum number of bytes to write to "file"
+ * @ppos: The current position in the debugfs "file"
+ */
+static ssize_t  smi_debug_width_fwrite(struct file *filp,
+				       const char __user *ubuf,
+				       size_t cnt,
+				       loff_t *ppos)
+{
+	char buf[SMI_U64STR_SIZE];
+	int csize = min(cnt, sizeof(buf));
+	u64 val = 0;
+	int err = 0;
+
+	memset(buf, '\0', sizeof(buf));
+	if (copy_from_user(buf, ubuf, csize))
+		return -EFAULT;
+
+	buf[SMI_U64STR_SIZE-1] = '\0';			/* just in case */
+	err = strict_strtoull(buf, 10, &val);
+	if (0 != err)
+		return -EINVAL;
+
+	mutex_lock(&smi_data.lock);
+	if (val < smi_data.sample_window)
+		smi_data.sample_width = val;
+	else {
+		mutex_unlock(&smi_data.lock);
+		return -EINVAL;
+	}
+	mutex_unlock(&smi_data.lock);
+
+	if (enabled)
+		wake_up_process(smi_kthread);
+
+	return csize;
+}
+
+/**
+ * smi_debug_window_fopen - Open function for "window" debugfs entry
+ * @inode: The in-kernel inode representation of the debugfs "file"
+ * @filp: The active open file structure for the debugfs "file"
+ *
+ * This function provides an open implementation for the "window" debugfs
+ * interface to the SMI detector.
+ */
+static int smi_debug_window_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+/**
+ * smi_debug_window_fread - Read function for "window" debugfs entry
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The userspace provided buffer to read value into
+ * @cnt: The maximum number of bytes to read
+ * @ppos: The current "file" position
+ */
+static ssize_t smi_debug_window_fread(struct file *filp, char __user *ubuf,
+				      size_t cnt, loff_t *ppos)
+{
+	char buf[SMI_U64STR_SIZE];
+	u64 val = 0;
+	int len = 0;
+
+	memset(buf, 0, sizeof(buf));
+
+	if ((cnt < sizeof(buf)) || (*ppos))
+		return 0;
+
+	mutex_lock(&smi_data.lock);
+	val = smi_data.sample_window;
+	mutex_unlock(&smi_data.lock);
+
+	len = snprintf(buf, SMI_U64STR_SIZE, "%llu\n", val);
+
+	if (copy_to_user(ubuf, buf, len))
+		return -EFAULT;
+	return *ppos = len;
+}
+
+/**
+ * smi_debug_window_fwrite - Write function for "window" debugfs entry
+ * @filp: The active open file structure for the debugfs "file"
+ * @ubuf: The user buffer that contains the value to write
+ * @cnt: The maximum number of bytes to write to "file"
+ * @ppos: The current position in the debugfs "file"
+ */
+static ssize_t  smi_debug_window_fwrite(struct file *filp,
+					const char __user *ubuf,
+					size_t cnt,
+					loff_t *ppos)
+{
+	char buf[SMI_U64STR_SIZE];
+	int csize = min(cnt, sizeof(buf));
+	u64 val = 0;
+	int err = 0;
+
+	memset(buf, '\0', sizeof(buf));
+	if (copy_from_user(buf, ubuf, csize))
+		return -EFAULT;
+
+	buf[SMI_U64STR_SIZE-1] = '\0';			/* just in case */
+	err = strict_strtoull(buf, 10, &val);
+	if (0 != err)
+		return -EINVAL;
+
+	mutex_lock(&smi_data.lock);
+	if (smi_data.sample_width < val)
+		smi_data.sample_window = val;
+	else {
+		mutex_unlock(&smi_data.lock);
+		return -EINVAL;
+	}
+	mutex_unlock(&smi_data.lock);
+
+	return csize;
+}
+
+/*
+ * Function pointers for the "count" debugfs file operations
+ */
+static const struct file_operations smi_count_fops = {
+	.open		= smi_debug_count_fopen,
+	.read		= smi_debug_count_fread,
+	.write		= smi_debug_count_fwrite,
+	.owner		= THIS_MODULE,
+};
+
+/*
+ * Function pointers for the "enable" debugfs file operations
+ */
+static const struct file_operations smi_enable_fops = {
+	.open		= smi_debug_enable_fopen,
+	.read		= smi_debug_enable_fread,
+	.write		= smi_debug_enable_fwrite,
+	.owner		= THIS_MODULE,
+};
+
+/*
+ * Function pointers for the "max" debugfs file operations
+ */
+static const struct file_operations smi_max_fops = {
+	.open		= smi_debug_max_fopen,
+	.read		= smi_debug_max_fread,
+	.write		= smi_debug_max_fwrite,
+	.owner		= THIS_MODULE,
+};
+
+/*
+ * Function pointers for the "sample" debugfs file operations
+ */
+static const struct file_operations smi_sample_fops = {
+	.open 		= smi_debug_sample_fopen,
+	.read		= smi_debug_sample_fread,
+	.release	= smi_debug_sample_release,
+	.owner		= THIS_MODULE,
+};
+
+/*
+ * Function pointers for the "threshold" debugfs file operations
+ */
+static const struct file_operations smi_threshold_fops = {
+	.open		= smi_debug_threshold_fopen,
+	.read		= smi_debug_threshold_fread,
+	.write		= smi_debug_threshold_fwrite,
+	.owner		= THIS_MODULE,
+};
+
+/*
+ * Function pointers for the "width" debugfs file operations
+ */
+static const struct file_operations smi_width_fops = {
+	.open		= smi_debug_width_fopen,
+	.read		= smi_debug_width_fread,
+	.write		= smi_debug_width_fwrite,
+	.owner		= THIS_MODULE,
+};
+
+/*
+ * Function pointers for the "window" debugfs file operations
+ */
+static const struct file_operations smi_window_fops = {
+	.open		= smi_debug_window_fopen,
+	.read		= smi_debug_window_fread,
+	.write		= smi_debug_window_fwrite,
+	.owner		= THIS_MODULE,
+};
+
+/**
+ * smi_init_debugfs - A function to initialize the debugfs interface files
+ *
+ * This function creates entries in debugfs for "smi_detector", including
+ * files to read values from the smi_dectector, current samples, and the
+ * maximum sample that has been captured since the SMI dectector started.
+ */
+static int smi_init_debugfs(void)
+{
+	int ret = -ENOMEM;
+
+	smi_debug_dir = debugfs_create_dir("smi_detector", NULL);
+	if (!smi_debug_dir)
+		goto err_debug_dir;
+
+	smi_debug_sample = debugfs_create_file("sample", 0444,
+					       smi_debug_dir, NULL,
+					       &smi_sample_fops);
+	if (!smi_debug_sample)
+		goto err_sample;
+
+	smi_debug_count = debugfs_create_file("count", 0444,
+					      smi_debug_dir, NULL,
+					      &smi_count_fops);
+	if (!smi_debug_count)
+		goto err_count;
+
+	smi_debug_max = debugfs_create_file("max", 0444,
+					    smi_debug_dir, NULL,
+					    &smi_max_fops);
+	if (!smi_debug_max)
+		goto err_max;
+
+	smi_debug_sample_window = debugfs_create_file("window", 0644,
+						      smi_debug_dir, NULL,
+						      &smi_window_fops);
+	if (!smi_debug_sample_window)
+		goto err_window;
+
+	smi_debug_sample_width = debugfs_create_file("width", 0644,
+						     smi_debug_dir, NULL,
+						     &smi_width_fops);
+	if (!smi_debug_sample_width)
+		goto err_width;
+
+	smi_debug_threshold = debugfs_create_file("threshold", 0644,
+						  smi_debug_dir, NULL,
+						  &smi_threshold_fops);
+	if (!smi_debug_threshold)
+		goto err_threshold;
+
+	smi_debug_enable = debugfs_create_file("enable", 0644,
+					       smi_debug_dir, &enabled,
+					       &smi_enable_fops);
+	if (!smi_debug_enable)
+		goto err_enable;
+
+	else {
+		ret = 0;
+		goto out;
+	}
+
+err_enable:
+	debugfs_remove(smi_debug_threshold);
+err_threshold:
+	debugfs_remove(smi_debug_sample_width);
+err_width:
+	debugfs_remove(smi_debug_sample_window);
+err_window:
+	debugfs_remove(smi_debug_max);
+err_max:
+	debugfs_remove(smi_debug_count);
+err_count:
+	debugfs_remove(smi_debug_sample);
+err_sample:
+	debugfs_remove(smi_debug_dir);
+err_debug_dir:
+out:
+	return ret;
+}
+
+/**
+ * smi_free_debugfs - A function to cleanup the debugfs file interface
+ */
+static void smi_free_debugfs(void)
+{
+	/* could also use a debugfs_remove_recursive */
+	debugfs_remove(smi_debug_enable);
+	debugfs_remove(smi_debug_threshold);
+	debugfs_remove(smi_debug_sample_width);
+	debugfs_remove(smi_debug_sample_window);
+	debugfs_remove(smi_debug_max);
+	debugfs_remove(smi_debug_count);
+	debugfs_remove(smi_debug_sample);
+	debugfs_remove(smi_debug_dir);
+}
+
+/**
+ * smi_detector_init - Standard module initialization code
+ */
+static int smi_detector_init(void)
+{
+	int ret = -ENOMEM;
+
+	printk(KERN_INFO SMI_BANNER "version %s\n", SMI_VERSION);
+
+	ret = smi_init_stats();
+	if (0 != ret)
+		goto out;
+
+	ret = smi_init_debugfs();
+	if (0 != ret)
+		goto err_stats;
+
+	if (enabled)
+		ret = smi_start_kthread();
+
+	goto out;
+
+err_stats:
+	ring_buffer_free(smi_ring_buffer);
+out:
+	return ret;
+
+}
+
+/**
+ * smi_detector_exit - Standard module cleanup code
+ */
+static void smi_detector_exit(void)
+{
+	if (enabled) {
+		enabled = 0;
+		smi_stop_kthread();
+	}
+
+	smi_free_debugfs();
+	ring_buffer_free(smi_ring_buffer);	/* free up the ring buffer */
+
+}
+
+module_init(smi_detector_init);
+module_exit(smi_detector_exit);

