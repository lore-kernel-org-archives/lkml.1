Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbYEXRMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbYEXRMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757420AbYEXRMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:12:14 -0400
Received: from host135-133-dynamic.55-82-r.retail.telecomitalia.it ([82.55.133.135]:29434
	"EHLO linux.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755626AbYEXRMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:12:13 -0400
From: Andrea Righi <righi.andrea@gmail.com>
To: balbir@linux.vnet.ibm.com, menage@google.com
Cc: matt@bluehost.com, roberto@unbit.it, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] io-throttle controller infrastructure
Date: Sat, 24 May 2008 18:56:56 +0200
Message-Id: <1211648217-13361-3-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the core io-throttle kernel infrastructure. It creates the basic
interfaces to cgroups and implements the I/O measurement and throttling
functions.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 block/Makefile                  |    2 +
 block/blk-io-throttle.c         |  219 +++++++++++++++++++++++++++++++++++++++
 include/linux/blk-io-throttle.h |   10 ++
 include/linux/cgroup_subsys.h   |    6 +
 init/Kconfig                    |   10 ++
 5 files changed, 247 insertions(+), 0 deletions(-)

diff --git a/block/Makefile b/block/Makefile
index 5a43c7d..8dec69b 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -14,3 +14,5 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
+
+obj-$(CONFIG_CGROUP_IO_THROTTLE)	+= blk-io-throttle.o
diff --git a/block/blk-io-throttle.c b/block/blk-io-throttle.c
new file mode 100644
index 0000000..cc2d10f
--- /dev/null
+++ b/block/blk-io-throttle.c
@@ -0,0 +1,219 @@
+/*
+ * blk-io-throttle.c
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
+ * Copyright (C) 2008 Andrea Righi <righi.andrea@gmail.com>
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
+#include <linux/hardirq.h>
+#include <linux/spinlock.h>
+#include <linux/blk-io-throttle.h>
+
+struct iothrottle {
+	struct cgroup_subsys_state css;
+	spinlock_t lock; /* protects the accounting of the cgroup i/o stats */
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
+ * Note: called from kernel/cgroup.c with cgroup_lock() held.
+ */
+static struct cgroup_subsys_state *iothrottle_create(
+			struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct iothrottle *iot = kzalloc(sizeof(*iot), GFP_KERNEL);
+
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
+	/* print also additional debugging stuff */
+	count = sprintf(page, "bandwidth-max: %lu KiB/sec\n"
+			      "    requested: %lu bytes\n"
+			      " last request: %lu jiffies\n"
+			      "        delta: %lu jiffies\n",
+			      iorate, req, last_request, delta);
+
+	ret = simple_read_from_buffer(buf, nbytes, ppos, page, count);
+out:
+	free_page((unsigned long)page);
+	return ret;
+}
+
+static int iothrottle_write_u64(struct cgroup *cont, struct cftype *cft,
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
+	iot->req = 0;
+	iot->last_request = jiffies;
+	spin_unlock_irq(&iot->lock);
+out:
+	cgroup_unlock();
+	return ret;
+}
+
+static struct cftype files[] = {
+	{
+		.name = "bandwidth",
+		.read = iothrottle_read,
+		.write_u64 = iothrottle_write_u64,
+	},
+};
+
+static int iothrottle_populate(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	return cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
+}
+
+struct cgroup_subsys iothrottle_subsys = {
+	.name = "blockio",
+	.create = iothrottle_create,
+	.destroy = iothrottle_destroy,
+	.populate = iothrottle_populate,
+	.subsys_id = iothrottle_subsys_id,
+};
+
+static inline int __cant_sleep(void)
+{
+	return in_atomic() || in_interrupt() || irqs_disabled();
+}
+
+void cgroup_io_account(size_t bytes)
+{
+	struct iothrottle *iot;
+	unsigned long delta, t;
+	long sleep;
+	int cant_sleep = __cant_sleep();
+
+	iot = task_to_iothrottle(current);
+	if (!iot)
+		return;
+
+	spin_lock_irq(&iot->lock);
+	if (!iot->iorate)
+		goto out;
+
+	/* Account the I/O activity  */
+	iot->req += bytes;
+
+	/* Evaluate if we need to throttle the current process */
+	if (cant_sleep)
+		goto out;
+
+	delta = (long)jiffies - (long)iot->last_request;
+	if (!delta)
+		goto out;
+
+	t = msecs_to_jiffies(iot->req / iot->iorate);
+	if (!t)
+		goto out;
+
+	sleep = t - delta;
+	if (sleep > 0) {
+		spin_unlock_irq(&iot->lock);
+		pr_debug("io-throttle: task %p (%s) must sleep %lu jiffies\n",
+			 current, current->comm, sleep);
+		schedule_timeout_killable(sleep);
+		return;
+	}
+
+	/* Reset I/O accounting */
+	iot->req = 0;
+	iot->last_request = jiffies;
+out:
+	spin_unlock_irq(&iot->lock);
+}
+EXPORT_SYMBOL(cgroup_io_account);
diff --git a/include/linux/blk-io-throttle.h b/include/linux/blk-io-throttle.h
new file mode 100644
index 0000000..950eb03
--- /dev/null
+++ b/include/linux/blk-io-throttle.h
@@ -0,0 +1,10 @@
+#ifndef BLK_IO_THROTTLE_H
+#define BLK_IO_THROTTLE_H
+
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+extern void cgroup_io_account(size_t bytes);
+#else
+static inline void cgroup_io_account(size_t bytes) { }
+#endif /* CONFIG_CGROUP_IO_THROTTLE */
+
+#endif /* BLK_IO_THROTTLE_H */
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index e287745..0caf3c2 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -48,3 +48,9 @@ SUBSYS(devices)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+SUBSYS(iothrottle)
+#endif
+
+/* */
diff --git a/init/Kconfig b/init/Kconfig
index 6135d07..6840f64 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -305,6 +305,16 @@ config CGROUP_DEVICE
 	  Provides a cgroup implementing whitelists for devices which
 	  a process in the cgroup can mknod or open.
 
+config CGROUP_IO_THROTTLE
+	bool "Enable cgroup I/O throttling (EXPERIMENTAL)"
+	depends on CGROUPS && EXPERIMENTAL
+	help
+	  This allows to limit the maximum I/O bandwidth for specific
+	  cgroup(s).
+	  See Documentation/controllers/io-throttle.txt for more information.
+
+	  If unsure, say N.
+
 config CPUSETS
 	bool "Cpuset support"
 	depends on SMP && CGROUPS
-- 
1.5.4.3

