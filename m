Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbYARPvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbYARPvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYARPvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:51:14 -0500
Received: from as2.cineca.com ([130.186.84.242]:59993 "EHLO as2.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYARPvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:51:12 -0500
Message-ID: <4790CAE1.5010700@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
References: <4790904F.5000101@users.sourceforge.net>
In-Reply-To: <4790904F.5000101@users.sourceforge.net>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Jan 2008 16:50:57 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:

[snip]

> +static ssize_t iothrottle_read(struct cgroup *cont, struct cftype *cft,
> +			       struct file *file, char __user *buf,
> +			       size_t nbytes, loff_t *ppos)
> +{
> +	ssize_t count, ret;
> +	unsigned long delta, iorate, req, last_request;
> +	struct iothrottle *iot;
> +	char *page;
> +
> +	page = (char *)__get_free_page(GFP_TEMPORARY);
> +	if (!page)
> +		return -ENOMEM;
> +
> +	cgroup_lock();
> +	if (cgroup_is_removed(cont)) {
> +		cgroup_unlock();
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +
> +	iot = cgroup_to_iothrottle(cont);
> +	spin_lock_irq(&iot->lock);
> +
> +	delta = (long)jiffies - (long)iot->last_request;
> +	iorate = iot->iorate;
> +	req = iot->req << 1;
> +	last_request = iot->last_request;
> +
> +	spin_unlock_irq(&iot->lock);
> +	cgroup_unlock();
> +
> +	/* print additional debugging stuff */
> +	count = sprintf(page, "     io-rate: %lu KiB/sec\n"
> +			      "   requested: %lu KiB\n"
> +			      "last_request: %lu jiffies\n"
> +			      "       delta: %lu jiffies\n",
> +			iorate, req << 1, last_request, delta);
                                ^^^^^^^^
Argh! just found a (minor) bug here... :-( the variable req is already
translated from sectors/sec in KB/sec here, so there's no need to lshift
it again (or better there's no need to shift it before).

Sorry for that. Fixed patch is below.

Signed-off-by: Andrea Righi <a.righi@cineca.it>
---

diff -urpN linux-2.6.24-rc8/block/io-throttle.c linux-2.6.24-rc8-cgroup-io-throttling/block/io-throttle.c
--- linux-2.6.24-rc8/block/io-throttle.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/block/io-throttle.c	2008-01-18 16:14:40.000000000 +0100
@@ -0,0 +1,250 @@
+/*
+ * io-throttle.c
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ *
+ * Copyright (C) 2008 Andrea Righi <a.righi@cineca.it>
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+#include <linux/gfp.h>
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/jiffies.h>
+#include <linux/spinlock.h>
+#include <linux/io-throttle.h>
+
+struct iothrottle {
+	struct cgroup_subsys_state css;
+	spinlock_t lock;
+	unsigned long iorate;
+	unsigned long req;
+	unsigned long last_request;
+};
+
+static inline struct iothrottle *cgroup_to_iothrottle(struct cgroup *cont)
+{
+	return container_of(cgroup_subsys_state(cont, iothrottle_subsys_id),
+			    struct iothrottle, css);
+}
+
+static inline struct iothrottle *task_to_iothrottle(struct task_struct *task)
+{
+	return container_of(task_subsys_state(task, iothrottle_subsys_id),
+			    struct iothrottle, css);
+}
+
+/*
+ * Rules: you can only create a cgroup if:
+ *   1. you are capable(CAP_SYS_ADMIN)
+ *   2. the target cgroup is a descendant of your own cgroup
+ *
+ * Note: called from kernel/cgroup.c with cgroup_lock() held.
+ */
+static struct cgroup_subsys_state *iothrottle_create(
+			struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct iothrottle *iot;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	if (!cgroup_is_descendant(cont))
+		return ERR_PTR(-EPERM);
+
+	iot = kzalloc(sizeof(struct iothrottle), GFP_KERNEL);
+	if (unlikely(!iot))
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&iot->lock);
+	iot->last_request = jiffies;
+
+	return &iot->css;
+}
+
+/*
+ * Note: called from kernel/cgroup.c with cgroup_lock() held.
+ */
+static void iothrottle_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	kfree(cgroup_to_iothrottle(cont));
+}
+
+static ssize_t iothrottle_read(struct cgroup *cont, struct cftype *cft,
+			       struct file *file, char __user *buf,
+			       size_t nbytes, loff_t *ppos)
+{
+	ssize_t count, ret;
+	unsigned long delta, iorate, req, last_request;
+	struct iothrottle *iot;
+	char *page;
+
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page)
+		return -ENOMEM;
+
+	cgroup_lock();
+	if (cgroup_is_removed(cont)) {
+		cgroup_unlock();
+		ret = -ENODEV;
+		goto out;
+	}
+
+	iot = cgroup_to_iothrottle(cont);
+	spin_lock_irq(&iot->lock);
+
+	delta = (long)jiffies - (long)iot->last_request;
+	iorate = iot->iorate;
+	req = iot->req;
+	last_request = iot->last_request;
+
+	spin_unlock_irq(&iot->lock);
+	cgroup_unlock();
+
+	/* print additional debugging stuff */
+	count = sprintf(page, "     io-rate: %lu KiB/sec\n"
+			      "   requested: %lu KiB\n"
+			      "last_request: %lu jiffies\n"
+			      "       delta: %lu jiffies\n",
+			iorate, req << 1, last_request, delta);
+
+	ret = simple_read_from_buffer(buf, nbytes, ppos, page, count);
+
+out:
+	free_page((unsigned long)page);
+	return ret;
+}
+
+static int iothrottle_write_uint(struct cgroup *cont, struct cftype *cft,
+				 u64 val)
+{
+	struct iothrottle *iot;
+	int ret = 0;
+
+	cgroup_lock();
+	if (cgroup_is_removed(cont)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	iot = cgroup_to_iothrottle(cont);
+
+	spin_lock_irq(&iot->lock);
+	iot->iorate = (unsigned long)val;
+	spin_unlock_irq(&iot->lock);
+
+out:
+	cgroup_unlock();
+	return ret;
+}
+
+static struct cftype files[] = {
+	{
+		.name = "io-rate",
+		.read = iothrottle_read,
+		.write_uint = iothrottle_write_uint,
+	},
+};
+
+static int iothrottle_populate(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	return cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
+}
+
+struct cgroup_subsys iothrottle_subsys = {
+	.name = "io-throttle",
+	.create = iothrottle_create,
+	.destroy = iothrottle_destroy,
+	.populate = iothrottle_populate,
+	.subsys_id = iothrottle_subsys_id,
+};
+
+void io_throttle(int nr_sectors)
+{
+	struct iothrottle *iot;
+	unsigned long delta, n;
+	long sleep;
+
+	cgroup_lock();
+	iot = task_to_iothrottle(current);
+	if (!iot)
+		goto out;
+
+	spin_lock_irq(&iot->lock);
+	if (!iot->iorate)
+		goto out2;
+
+	/*
+	 * The concept is the following: evaluate the actual I/O rate of a
+	 * process, looking at the sectors requested over the time elapsed from
+	 * the last request. If the actual I/O rate is beyond the maximum
+	 * allowed I/O rate then sleep the current task for the correct amount
+	 * of time, in order to reduce the actual I/O rate under the allowed
+	 * limit.
+	 *
+	 * The time to sleep is evaluated as:
+	 *
+	 *   sleep = (sectors_requested / allowed_iorate) - time_elapsed
+	 */
+	delta = (long)jiffies - (long)iot->last_request;
+	iot->req += nr_sectors;
+	n = iot->req / iot->iorate;
+
+	spin_unlock_irq(&iot->lock);
+	cgroup_unlock();
+
+	/*
+	 * If it's not possible to evaluate delta (due to a too small interval
+	 * of time between two requests) or n (due to a too small request),
+	 * account the requested sectors in iot->req and sum them to the
+	 * sectors of the next request.
+	 */
+	if (!delta || !n)
+		return;
+
+	/*
+	 * Convert n in jiffies (remember that iot->iorate is in KB/s and we
+	 * need to convert it in sectors/jiffies)
+	 */
+	sleep = msecs_to_jiffies(n * 1000 / 2) - delta;
+	if (sleep > 0) {
+		pr_debug("io-throttle: task %p (%s) must sleep %lu jiffies\n",
+			 current, current->comm, sleep);
+		schedule_timeout_uninterruptible(sleep);
+	}
+
+	/*
+	 * Note: iothrottle element could be changed during the sleep, so
+	 * we must refresh it before resetting statistics.
+	 */
+	cgroup_lock();
+	iot = task_to_iothrottle(current);
+	if (!iot)
+		goto out;
+
+	spin_lock_irq(&iot->lock);
+	iot->req = 0;
+	iot->last_request = jiffies;
+out2:
+	spin_unlock_irq(&iot->lock);
+out:
+	cgroup_unlock();
+}
+EXPORT_SYMBOL(io_throttle);
diff -urpN linux-2.6.24-rc8/block/ll_rw_blk.c linux-2.6.24-rc8-cgroup-io-throttling/block/ll_rw_blk.c
--- linux-2.6.24-rc8/block/ll_rw_blk.c	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/block/ll_rw_blk.c	2008-01-18 16:14:09.000000000 +0100
@@ -31,6 +31,7 @@
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
 #include <linux/scatterlist.h>
+#include <linux/io-throttle.h>
 
 /*
  * for max sense size
@@ -3221,6 +3222,8 @@ static inline void __generic_make_reques
 	if (bio_check_eod(bio, nr_sectors))
 		goto end_io;
 
+	io_throttle(nr_sectors);
+
 	/*
 	 * Resolve the mapping until finished. (drivers are
 	 * still free to implement/resolve their own stacking
diff -urpN linux-2.6.24-rc8/block/Makefile linux-2.6.24-rc8-cgroup-io-throttling/block/Makefile
--- linux-2.6.24-rc8/block/Makefile	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/block/Makefile	2008-01-18 16:14:09.000000000 +0100
@@ -12,3 +12,5 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
+
+obj-$(CONFIG_CGROUP_IO_THROTTLE)	+= io-throttle.o
diff -urpN linux-2.6.24-rc8/include/linux/cgroup_subsys.h linux-2.6.24-rc8-cgroup-io-throttling/include/linux/cgroup_subsys.h
--- linux-2.6.24-rc8/include/linux/cgroup_subsys.h	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/include/linux/cgroup_subsys.h	2008-01-18 16:14:09.000000000 +0100
@@ -37,3 +37,9 @@ SUBSYS(cpuacct)
 
 /* */
 
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+SUBSYS(iothrottle)
+#endif
+
+/* */
+
diff -urpN linux-2.6.24-rc8/include/linux/io-throttle.h linux-2.6.24-rc8-cgroup-io-throttling/include/linux/io-throttle.h
--- linux-2.6.24-rc8/include/linux/io-throttle.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/include/linux/io-throttle.h	2008-01-18 16:14:09.000000000 +0100
@@ -0,0 +1,10 @@
+#ifndef IO_THROTTLE_H
+#define IO_THROTTLE_H
+
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+extern void io_throttle(int nr_sectors);
+#else
+static inline void io_throttle(int nr_sectors) { }
+#endif /* CONFIG_CGROUP_IO_THROTTLE */
+
+#endif
diff -urpN linux-2.6.24-rc8/init/Kconfig linux-2.6.24-rc8-cgroup-io-throttling/init/Kconfig
--- linux-2.6.24-rc8/init/Kconfig	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/init/Kconfig	2008-01-18 16:14:09.000000000 +0100
@@ -313,6 +313,15 @@ config CGROUP_NS
           for instance virtual servers and checkpoint/restart
           jobs.
 
+config CGROUP_IO_THROTTLE
+        bool "Enable cgroup I/O throttling (EXPERIMENTAL)"
+        depends on EXPERIMENTAL && CGROUPS
+        help
+	  This allows to limit the maximum I/O bandwidth for specific
+	  cgroup(s).
+
+          Say N if unsure.
+
 config CPUSETS
 	bool "Cpuset support"
 	depends on SMP && CGROUPS
