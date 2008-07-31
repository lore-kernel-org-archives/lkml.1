Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbYGaWvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbYGaWvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbYGaWuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:50:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57122 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912AbYGaWuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=q280tTiAytx7CW4IboVxLbV1ucgCT1WcI6ujH2Mi9ilBXSS15DpnbR+ViYBp1ZOm7F
         CNrZw4qmFx0pyjJczkssfRZeeUGqp/oeaZNbxjmbAnJEhv+ZYH5lcB17ODIFt+votWQz
         aalgBJx52y5/09d5lkjDkGfojGnm00OlvyJ+s=
From: Andrea Righi <righi.andrea@gmail.com>
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com
Cc: Matt Heaton <matt@bluehost.com>, Mark Seger <Mark.Seger@hp.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH -mm 2/4] implement distinct block device IO accounting
Date: Fri,  1 Aug 2008 00:49:57 +0200
Message-Id: <1217544599-8935-3-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I/O statistics are stored in a rbtree (one for each thread or process), using
the device number (dev_t) as key.

Note: dev_t block devices are used without registering any usage reference; if
a block device is removed the i/o statistics of the running processes remain
valid, *but* if a new block device is plugged in and it gets the same dev_t
number, then all the previous i/o statistics for the old device will be merged
together with i/o statistics of the new device.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 include/linux/task_io_accounting.h     |   59 ++++++++---
 include/linux/task_io_accounting_ops.h |  108 ++++++++++++-------
 init/Kconfig                           |    9 ++
 kernel/Makefile                        |    1 +
 kernel/task-io-accounting.c            |  180 ++++++++++++++++++++++++++++++++
 5 files changed, 303 insertions(+), 54 deletions(-)
 create mode 100644 kernel/task-io-accounting.c

diff --git a/include/linux/task_io_accounting.h b/include/linux/task_io_accounting.h
index 5e88afc..d7eb577 100644
--- a/include/linux/task_io_accounting.h
+++ b/include/linux/task_io_accounting.h
@@ -8,31 +8,32 @@
  * Blame akpm@osdl.org for all this.
  */
 
-struct task_io_accounting {
-#ifdef CONFIG_TASK_XACCT
-	/* bytes read */
-	u64 rchar;
-	/*  bytes written */
-	u64 wchar;
-	/* # of read syscalls */
-	u64 syscr;
-	/* # of write syscalls */
-	u64 syscw;
-#endif /* CONFIG_TASK_XACCT */
+#include <linux/rbtree.h>
+#include <linux/fs.h>
 
-#ifdef CONFIG_TASK_IO_ACCOUNTING
+#ifndef _LINUX_TASK_IO_ACCOUNTING_H
+#define _LINUX_TASK_IO_ACCOUNTING_H
+
+enum io_acct_ops {
+	TASK_IO_ACCT_READ,
+	TASK_IO_ACCT_WRITE,
+	TASK_IO_ACCT_CANCELLED_WRITE,
+};
+
+struct task_io_acct_node {
+#ifdef CONFIG_TASK_IO_ACCOUNTING_BDEV
+	struct rb_node node;
+	dev_t dev;
 	/*
 	 * The number of bytes which this task has caused to be read from
 	 * storage.
 	 */
 	u64 read_bytes;
-
 	/*
 	 * The number of bytes which this task has caused, or shall cause to be
 	 * written to disk.
 	 */
 	u64 write_bytes;
-
 	/*
 	 * A task can cause "negative" IO too.  If this task truncates some
 	 * dirty pagecache, some IO which another task has been accounted for
@@ -41,5 +42,35 @@ struct task_io_accounting {
 	 * information loss in doing that.
 	 */
 	u64 cancelled_write_bytes;
+#endif /* CONFIG_TASK_IO_ACCOUNTING_BDEV */
+};
+
+struct task_io_accounting {
+#ifdef CONFIG_TASK_XACCT
+	/* bytes read */
+	u64 rchar;
+	/*  bytes written */
+	u64 wchar;
+	/* # of read syscalls */
+	u64 syscr;
+	/* # of write syscalls */
+	u64 syscw;
+#endif /* CONFIG_TASK_XACCT */
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	u64 read_bytes;
+	u64 write_bytes;
+	u64 cancelled_write_bytes;
 #endif /* CONFIG_TASK_IO_ACCOUNTING */
+#ifdef CONFIG_TASK_IO_ACCOUNTING_BDEV
+	/*
+	 * Red-Black tree to store each block device accounting informations.
+	 */
+	struct rb_root tree;
+	/*
+	 * Spinlock to manage red-black tree concurrent accesses.
+	 */
+	spinlock_t lock;
+#endif
 };
+
+#endif /* _LINUX_TASK_IO_ACCOUNTING_H */
diff --git a/include/linux/task_io_accounting_ops.h b/include/linux/task_io_accounting_ops.h
index 4d090f9..5e27d06 100644
--- a/include/linux/task_io_accounting_ops.h
+++ b/include/linux/task_io_accounting_ops.h
@@ -4,92 +4,120 @@
 #ifndef __TASK_IO_ACCOUNTING_OPS_INCLUDED
 #define __TASK_IO_ACCOUNTING_OPS_INCLUDED
 
+#include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/rbtree.h>
+#include <linux/spinlock.h>
+
+#ifdef CONFIG_TASK_IO_ACCOUNTING_BDEV
+extern void block_device_acct(struct block_device *bdev, size_t bytes,
+				enum io_acct_ops iop);
+extern void task_io_account_cleanup(struct task_io_accounting *ioac);
+extern void task_io_account_merge_stat(struct task_io_accounting *dst,
+					struct task_io_accounting *src);
+static inline void task_io_account_init(struct task_io_accounting *ioac)
+{
+	memset(ioac, 0, sizeof(*ioac));
+	spin_lock_init(&ioac->lock);
+	ioac->tree = RB_ROOT;
+}
+#else /* CONFIG_TASK_IO_ACCOUNTING_BDEV */
+static inline void block_device_acct(struct block_device *bdev, size_t bytes,
+					enum io_acct_ops iop)
+{
+}
+static inline void task_io_account_merge_stat(struct task_io_accounting *dst,
+					struct task_io_accounting *src)
+{
+}
+static inline void task_io_account_init(struct task_io_accounting *ioac)
+{
+	memset(ioac, 0, sizeof(*ioac));
+}
+#define task_io_account_cleanup(__x)	task_io_account_init(__x)
+#endif /* CONFIG_TASK_IO_ACCOUNTING_BDEV */
 
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-static inline void task_io_account_read(size_t bytes)
+static inline void
+task_io_account_read(struct block_device *bdev, size_t bytes)
 {
 	current->ioac.read_bytes += bytes;
+	block_device_acct(bdev, bytes, TASK_IO_ACCT_READ);
 }
 
-/*
- * We approximate number of blocks, because we account bytes only.
- * A 'block' is 512 bytes
- */
-static inline unsigned long task_io_get_inblock(const struct task_struct *p)
+static inline void
+task_io_account_write(struct block_device *bdev, size_t bytes)
 {
-	return p->ioac.read_bytes >> 9;
+	current->ioac.write_bytes += bytes;
+	block_device_acct(bdev, bytes, TASK_IO_ACCT_WRITE);
 }
 
-static inline void task_io_account_write(size_t bytes)
+static inline void
+task_io_account_cancelled_write(struct block_device *bdev, size_t bytes)
 {
-	current->ioac.write_bytes += bytes;
+	current->ioac.cancelled_write_bytes += bytes;
+	block_device_acct(bdev, bytes, TASK_IO_ACCT_CANCELLED_WRITE);
 }
 
 /*
  * We approximate number of blocks, because we account bytes only.
  * A 'block' is 512 bytes
  */
-static inline unsigned long task_io_get_oublock(const struct task_struct *p)
-{
-	return p->ioac.write_bytes >> 9;
-}
-
-static inline void task_io_account_cancelled_write(size_t bytes)
+static inline unsigned long task_io_get_inblock(const struct task_struct *p)
 {
-	current->ioac.cancelled_write_bytes += bytes;
+	return p->ioac.read_bytes >> 9;
 }
 
-static inline void task_io_accounting_init(struct task_io_accounting *ioac)
+/*
+ *  * We approximate number of blocks, because we account bytes only.
+ *   * A 'block' is 512 bytes
+ *    */
+static inline unsigned long task_io_get_oublock(const struct task_struct *p)
 {
-	memset(ioac, 0, sizeof(*ioac));
+	return p->ioac.write_bytes >> 9;
 }
 
-static inline void task_blk_io_accounting_add(struct task_io_accounting *dst,
+static inline void task_blk_io_account_add(struct task_io_accounting *dst,
 						struct task_io_accounting *src)
 {
 	dst->read_bytes += src->read_bytes;
 	dst->write_bytes += src->write_bytes;
 	dst->cancelled_write_bytes += src->cancelled_write_bytes;
 }
-
-#else
-
-static inline void task_io_account_read(size_t bytes)
+#else  /* CONFIG_TASK_IO_ACCOUNTING */
+static inline void task_io_account_read(struct block_device *bdev, size_t bytes)
 {
 }
 
-static inline unsigned long task_io_get_inblock(const struct task_struct *p)
+static inline void
+task_io_account_write(struct block_device *bdev, size_t bytes)
 {
-	return 0;
 }
 
-static inline void task_io_account_write(size_t bytes)
+static inline void
+task_io_account_cancelled_write(struct block_device *bdev, size_t bytes)
 {
 }
 
-static inline unsigned long task_io_get_oublock(const struct task_struct *p)
+static inline unsigned long task_io_get_inblock(const struct task_struct *p)
 {
 	return 0;
 }
 
-static inline void task_io_account_cancelled_write(size_t bytes)
-{
-}
-
-static inline void task_io_accounting_init(struct task_io_accounting *ioac)
+static inline unsigned long task_io_get_oublock(const struct task_struct *p)
 {
+	return 0;
 }
 
-static inline void task_blk_io_accounting_add(struct task_io_accounting *dst,
+static inline void task_blk_io_account_add(struct task_io_accounting *dst,
 						struct task_io_accounting *src)
 {
 }
-
 #endif /* CONFIG_TASK_IO_ACCOUNTING */
 
 #ifdef CONFIG_TASK_XACCT
-static inline void task_chr_io_accounting_add(struct task_io_accounting *dst,
+static inline void task_chr_io_account_add(struct task_io_accounting *dst,
 						struct task_io_accounting *src)
 {
 	dst->rchar += src->rchar;
@@ -97,17 +125,17 @@ static inline void task_chr_io_accounting_add(struct task_io_accounting *dst,
 	dst->syscr += src->syscr;
 	dst->syscw += src->syscw;
 }
-#else
-static inline void task_chr_io_accounting_add(struct task_io_accounting *dst,
+#else /* CONFIG_TASK_XACCT */
+static inline void task_chr_io_account_add(struct task_io_accounting *dst,
 						struct task_io_accounting *src)
 {
 }
 #endif /* CONFIG_TASK_XACCT */
 
-static inline void task_io_accounting_add(struct task_io_accounting *dst,
+static inline void task_io_account_add(struct task_io_accounting *dst,
 						struct task_io_accounting *src)
 {
-	task_chr_io_accounting_add(dst, src);
-	task_blk_io_accounting_add(dst, src);
+	task_chr_io_account_add(dst, src);
+	task_blk_io_account_add(dst, src);
 }
 #endif /* __TASK_IO_ACCOUNTING_OPS_INCLUDED */
diff --git a/init/Kconfig b/init/Kconfig
index a451916..4e66bdf 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -215,6 +215,15 @@ config TASK_IO_ACCOUNTING
 
 	  Say N if unsure.
 
+config TASK_IO_ACCOUNTING_BDEV
+	bool "Enable distinct block device I/O accounting (EXPERIMENTAL)"
+	depends on TASK_IO_ACCOUNTING
+	help
+	  Collect informations on the number of bytes of real storage I/O which
+	  each task has caused for each block device.
+
+	  Say N if unsure.
+
 config AUDIT
 	bool "Auditing support"
 	depends on NET
diff --git a/kernel/Makefile b/kernel/Makefile
index dd58bdc..ef7cd1b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-$(CONFIG_TASK_IO_ACCOUNTING_BDEV) += task-io-accounting.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
diff --git a/kernel/task-io-accounting.c b/kernel/task-io-accounting.c
new file mode 100644
index 0000000..ad4f427
--- /dev/null
+++ b/kernel/task-io-accounting.c
@@ -0,0 +1,180 @@
+/*
+ * Task I/O accounting operations
+ *
+ * 2008 July, rework by Andrea Righi <righi.andrea@gmail.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/rbtree.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/task_io_accounting.h>
+#include <linux/task_io_accounting_ops.h>
+
+static struct task_io_acct_node *
+ioac_search(const struct task_io_accounting *ioac, const dev_t dev)
+{
+	struct rb_node *node = (&ioac->tree)->rb_node;
+
+	while (node) {
+		struct task_io_acct_node *data = container_of(node,
+					struct task_io_acct_node, node);
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
+static int
+ioac_insert(struct task_io_accounting *ioac, struct task_io_acct_node *data)
+{
+	struct rb_root *root = &ioac->tree;
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+
+	while (*new) {
+		struct task_io_acct_node *this = container_of(*new,
+					struct task_io_acct_node, node);
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
+	return 0;
+}
+
+void task_io_account_merge_stat(struct task_io_accounting *dst,
+				struct task_io_accounting *src)
+{
+	struct task_io_acct_node *io_src, *io_dst;
+	struct rb_node *next;
+
+	if (unlikely(src == dst)) {
+		WARN_ON(1);
+		return;
+	}
+	next = rb_first(&src->tree);
+	while (next) {
+		io_src = rb_entry(next, struct task_io_acct_node, node);
+		next = rb_next(&io_src->node);
+		rb_erase(&io_src->node, &src->tree);
+
+		spin_lock(&dst->lock);
+		io_dst = ioac_search(dst, io_src->dev);
+		if (io_dst) {
+			io_dst->read_bytes += io_src->read_bytes;
+			io_dst->write_bytes += io_src->write_bytes;
+			io_dst->cancelled_write_bytes +=
+					io_src->cancelled_write_bytes;
+			kfree(io_src);
+		} else {
+			if (unlikely(ioac_insert(dst, io_src) < 0))
+				WARN_ON(1);
+		}
+		spin_unlock(&dst->lock);
+	}
+}
+
+void task_io_account_cleanup(struct task_io_accounting *ioac)
+{
+	struct task_io_acct_node *data;
+	struct rb_node *next;
+
+	ioac->read_bytes = 0;
+	ioac->write_bytes = 0;
+	ioac->cancelled_write_bytes = 0;
+
+	next = rb_first(&ioac->tree);
+	while (next) {
+		data = rb_entry(next, struct task_io_acct_node, node);
+		next = rb_next(&data->node);
+		rb_erase(&data->node, &ioac->tree);
+		kfree(data);
+	}
+}
+
+static inline u64 *
+task_io_acct_node_member(struct task_io_acct_node *io, enum io_acct_ops iop)
+{
+	switch (iop) {
+	case TASK_IO_ACCT_READ:
+		return &io->read_bytes;
+	case TASK_IO_ACCT_WRITE:
+		return &io->write_bytes;
+	case TASK_IO_ACCT_CANCELLED_WRITE:
+		return &io->cancelled_write_bytes;
+	}
+	BUG();
+	return NULL;
+}
+
+static int block_device_acct_dev(dev_t dev, size_t bytes, enum io_acct_ops iop)
+{
+	struct task_io_acct_node *io;
+
+	io = ioac_search(&current->ioac, dev);
+	if (likely(io))	{
+		u64 *val = task_io_acct_node_member(io, iop);
+		*val += bytes;
+		return 0;
+	}
+	return -ENOENT;
+}
+
+void block_device_acct(struct block_device *bdev, size_t bytes,
+				enum io_acct_ops iop)
+{
+	struct task_io_acct_node *io;
+	dev_t dev;
+
+	if (!bdev)
+		return;
+
+	BUG_ON(!bdev->bd_inode || !bdev->bd_disk);
+	dev = bdev->bd_inode->i_rdev;
+
+	spin_lock_irq(&current->ioac.lock);
+	if (likely(!block_device_acct_dev(dev, bytes, iop))) {
+		spin_unlock_irq(&current->ioac.lock);
+		return;
+	}
+	spin_unlock_irq(&current->ioac.lock);
+	/*
+	 * Accessing a new block device for the first time: initialize a new
+	 * element to store i/o statistics.
+	 */
+	io = kzalloc(sizeof(*io), GFP_KERNEL);
+	if (unlikely(!io) && printk_ratelimit()) {
+		printk(KERN_WARNING
+			"not enough memory to account i/o stats on %d,%d\n",
+			MAJOR(dev), MINOR(dev));
+		return;
+	}
+	RB_CLEAR_NODE(&io->node);
+	io->dev = dev;
+	spin_lock_irq(&current->ioac.lock);
+	if (likely(!ioac_insert(&current->ioac, io))) {
+		u64 *val = task_io_acct_node_member(io, iop);
+		*val = bytes;
+		spin_unlock_irq(&current->ioac.lock);
+		return;
+	}
+	/*
+	 * It seems the new element has been alredy added by another cpu in the
+	 * while: just update pending statistics.
+	 */
+	if (unlikely(block_device_acct_dev(dev, bytes, iop) < 0))
+		WARN_ON(1);
+	spin_unlock_irq(&current->ioac.lock);
+	kfree(io);
+}
-- 
1.5.4.3

