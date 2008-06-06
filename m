Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbYFGI3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbYFGI3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 04:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYFGI3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 04:29:02 -0400
Received: from [78.13.70.189] ([78.13.70.189]:47942 "EHLO linux.localdomain"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753999AbYFGI2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 04:28:54 -0400
From: Andrea Righi <righi.andrea@gmail.com>
To: balbir@linux.vnet.ibm.com, menage@google.com
Cc: matt@bluehost.com, roberto@unbit.it, randy.dunlap@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] i/o bandwidth controller infrastructure
Date: Sat,  7 Jun 2008 00:27:29 +0200
Message-Id: <1212791250-32320-3-git-send-email-righi.andrea@gmail.com>
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
 block/blk-io-throttle.c         |  405 +++++++++++++++++++++++++++++++++++++++
 include/linux/blk-io-throttle.h |   12 ++
 include/linux/cgroup_subsys.h   |    6 +
 init/Kconfig                    |   10 +
 5 files changed, 435 insertions(+), 0 deletions(-)
 create mode 100644 block/blk-io-throttle.c
 create mode 100644 include/linux/blk-io-throttle.h

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
index 0000000..804df88
--- /dev/null
+++ b/block/blk-io-throttle.c
@@ -0,0 +1,405 @@
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
+#include <linux/uaccess.h>
+#include <linux/blk-io-throttle.h>
+
+#define iothrottle_for_each(n, r) \
+	for (n = rb_first(r); n; n = rb_next(n))
+
+struct iothrottle_node {
+	struct rb_node node;
+	dev_t dev;
+	unsigned long iorate;
+	unsigned long req;
+	unsigned long last_request;
+};
+
+struct iothrottle {
+	struct cgroup_subsys_state css;
+	spinlock_t lock; /* protects the accounting of the cgroup i/o stats */
+	struct rb_root tree;
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
+static inline struct iothrottle_node *iothrottle_search_node(
+					const struct iothrottle *iot,
+					dev_t dev)
+{
+	struct rb_node *node = (&iot->tree)->rb_node;
+
+	while (node) {
+		struct iothrottle_node *data = container_of(node,
+						struct iothrottle_node, node);
+		if (dev < data->dev)
+			node = node->rb_left;
+		else if (dev > data->dev)
+			node = node->rb_right;
+		else
+			return data;
+	}
+	return NULL;
+}
+
+static inline int iothrottle_insert_node(struct iothrottle *iot,
+					 struct iothrottle_node *data)
+{
+	struct rb_root *root = &iot->tree;
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+
+	while (*new) {
+		struct iothrottle_node *this = container_of(*new,
+						struct iothrottle_node, node);
+		parent = *new;
+		if (data->dev < this->dev)
+			new = &((*new)->rb_left);
+		else if (data->dev > this->dev)
+			new = &((*new)->rb_right);
+		else
+			return -EINVAL;
+	}
+	rb_link_node(&data->node, parent, new);
+	rb_insert_color(&data->node, root);
+
+	return 0;
+}
+
+static inline void iothrottle_delete_node(struct iothrottle *iot, dev_t dev)
+{
+	struct iothrottle_node *data = iothrottle_search_node(iot, dev);
+
+	if (likely(data)) {
+		rb_erase(&data->node, &iot->tree);
+		kfree(data);
+	}
+}
+
+/*
+ * Note: called from kernel/cgroup.c with cgroup_lock() held.
+ */
+static struct cgroup_subsys_state *iothrottle_create(
+			struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct iothrottle *iot;
+
+	iot = kmalloc(sizeof(*iot), GFP_KERNEL);
+	if (unlikely(!iot))
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&iot->lock);
+	iot->tree = RB_ROOT;
+
+	return &iot->css;
+}
+
+/*
+ * Note: called from kernel/cgroup.c with cgroup_lock() held.
+ */
+static void iothrottle_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct iothrottle_node *data;
+	struct rb_node *next;
+	struct iothrottle *iot = cgroup_to_iothrottle(cont);
+
+	next = rb_first(&iot->tree);
+	while (next) {
+		data = rb_entry(next, struct iothrottle_node, node);
+		next = rb_next(&data->node);
+		rb_erase(&data->node, &iot->tree);
+		kfree(data);
+	}
+	kfree(iot);
+}
+
+static ssize_t iothrottle_read(struct cgroup *cont,
+			       struct cftype *cft,
+			       struct file *file,
+			       char __user *userbuf,
+			       size_t nbytes,
+			       loff_t *ppos)
+{
+	struct iothrottle *iot;
+	char *buffer, *s;
+	struct rb_node *n;
+	ssize_t ret;
+
+	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
+	if (unlikely(!buffer))
+		return -ENOMEM;
+
+	cgroup_lock();
+	if (cgroup_is_removed(cont)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	iot = cgroup_to_iothrottle(cont);
+
+	s = buffer;
+	spin_lock_irq(&iot->lock);
+	iothrottle_for_each(n, &iot->tree) {
+		struct iothrottle_node *node =
+				rb_entry(n, struct iothrottle_node, node);
+		unsigned long delta = (long)jiffies - (long)node->last_request;
+
+		BUG_ON(!node->dev);
+		s += snprintf(s, nbytes - (s - buffer),
+				  "=== device (%u,%u) ===\n"
+				  "bandwidth-max: %lu KiB/sec\n"
+				  "    requested: %lu bytes\n"
+				  " last request: %lu jiffies\n"
+				  "        delta: %lu jiffies\n",
+				  MAJOR(node->dev), MINOR(node->dev),
+				  node->iorate, node->req,
+				  node->last_request, delta);
+	}
+	spin_unlock_irq(&iot->lock);
+	buffer[nbytes] = '\0';
+
+	ret = simple_read_from_buffer(userbuf, nbytes,
+				      ppos, buffer, (s - buffer));
+out:
+	cgroup_unlock();
+	kfree(buffer);
+	return ret;
+}
+
+static inline dev_t devname2dev_t(const char *buf)
+{
+	struct block_device *bdev;
+	dev_t ret;
+
+	bdev = lookup_bdev(buf);
+	if (IS_ERR(bdev))
+		return 0;
+
+	BUG_ON(!bdev->bd_inode);
+	ret = bdev->bd_inode->i_rdev;
+	bdput(bdev);
+
+	return ret;
+}
+
+static inline int iothrottle_parse_args(char *buf, size_t nbytes,
+					dev_t *dev, unsigned long *val)
+{
+	char *p;
+
+	p = memchr(buf, ':', nbytes);
+	if (!p)
+		return -EINVAL;
+	*p++ = '\0';
+
+	*dev = devname2dev_t(buf);
+	if (!*dev)
+		return -ENOTBLK;
+
+	return strict_strtoul(p, 10, val);
+}
+
+static ssize_t iothrottle_write(struct cgroup *cont,
+				struct cftype *cft,
+				struct file *file,
+				const char __user *userbuf,
+				size_t nbytes, loff_t *ppos)
+{
+	struct iothrottle *iot;
+	struct iothrottle_node *node, *tmpn = NULL;
+	char *buffer, *tmpp;
+	dev_t dev;
+	unsigned long val;
+	int ret;
+
+	if (unlikely(!nbytes))
+		return -EINVAL;
+
+	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
+	if (unlikely(!buffer))
+		return -ENOMEM;
+
+	if (copy_from_user(buffer, userbuf, nbytes)) {
+		ret = -EFAULT;
+		goto out1;
+	}
+
+	buffer[nbytes] = '\0';
+	tmpp = strstrip(buffer);
+
+	ret = iothrottle_parse_args(tmpp, nbytes, &dev, &val);
+	if (ret)
+		goto out1;
+
+	/*
+	 * Pre-allocate a temporary node structure outside locks to use
+	 * GFP_KERNEL, it will be kfree()ed later if unused.
+	 */
+	tmpn = kmalloc(sizeof(*tmpn), GFP_KERNEL);
+
+	cgroup_lock();
+	if (cgroup_is_removed(cont)) {
+		ret = -ENODEV;
+		goto out2;
+	}
+
+	iot = cgroup_to_iothrottle(cont);
+
+	spin_lock_irq(&iot->lock);
+	if (!val) {
+		/* Delete a block device limiting rule */
+		iothrottle_delete_node(iot, dev);
+		ret = nbytes;
+		goto out3;
+	}
+	node = iothrottle_search_node(iot, dev);
+	if (node) {
+		/* Update a block device limiting rule */
+		node->iorate = val;
+		node->req = 0;
+		node->last_request = jiffies;
+		ret = nbytes;
+		goto out3;
+	}
+	/* Add a new block device limiting rule */
+	if (unlikely(!tmpn)) {
+		ret = -ENOMEM;
+		goto out3;
+	}
+	node = tmpn;
+	tmpn = NULL;
+
+	node->iorate = val;
+	node->req = 0;
+	node->last_request = jiffies;
+	node->dev = dev;
+	ret = iothrottle_insert_node(iot, node);
+	BUG_ON(ret);
+	ret = nbytes;
+out3:
+	spin_unlock_irq(&iot->lock);
+out2:
+	cgroup_unlock();
+	if (tmpn)
+		kfree(tmpn);
+out1:
+	kfree(buffer);
+	return ret;
+}
+
+static struct cftype files[] = {
+	{
+		.name = "bandwidth",
+		.read = iothrottle_read,
+		.write = iothrottle_write,
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
+void cgroup_io_account(struct block_device *bdev, size_t bytes)
+{
+	struct iothrottle *iot;
+	struct iothrottle_node *node;
+	unsigned long delta, t;
+	long sleep;
+
+	if (unlikely(!bdev))
+		return;
+
+	BUG_ON(!bdev->bd_inode);
+
+	iot = task_to_iothrottle(current);
+	if (unlikely(!iot))
+		return;
+
+	spin_lock_irq(&iot->lock);
+
+	node = iothrottle_search_node(iot, bdev->bd_inode->i_rdev);
+	if (!node || !node->iorate)
+		goto out;
+
+	/* Account the I/O activity  */
+	node->req += bytes;
+
+	/* Evaluate if we need to throttle the current process */
+	delta = (long)jiffies - (long)node->last_request;
+	if (!delta)
+		goto out;
+
+	t = msecs_to_jiffies(node->req / node->iorate);
+	if (!t)
+		goto out;
+
+	sleep = t - delta;
+	if (unlikely(sleep > 0)) {
+		spin_unlock_irq(&iot->lock);
+		if (__cant_sleep())
+			return;
+		pr_debug("io-throttle: task %p (%s) must sleep %lu jiffies\n",
+			 current, current->comm, sleep);
+		schedule_timeout_killable(sleep);
+		return;
+	}
+
+	/* Reset I/O accounting */
+	node->req = 0;
+	node->last_request = jiffies;
+out:
+	spin_unlock_irq(&iot->lock);
+}
+EXPORT_SYMBOL(cgroup_io_account);
diff --git a/include/linux/blk-io-throttle.h b/include/linux/blk-io-throttle.h
new file mode 100644
index 0000000..cff0c13
--- /dev/null
+++ b/include/linux/blk-io-throttle.h
@@ -0,0 +1,12 @@
+#ifndef BLK_IO_THROTTLE_H
+#define BLK_IO_THROTTLE_H
+
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+extern void cgroup_io_account(struct block_device *bdev, size_t bytes);
+#else
+static inline void cgroup_io_account(struct block_device *bdev, size_t bytes)
+{
+}
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
index 6199d11..3117d99 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -306,6 +306,16 @@ config CGROUP_DEVICE
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

