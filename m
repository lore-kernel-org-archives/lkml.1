Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZGVRr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZGVRr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZGVRr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:47:26 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:8230 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbZGVRrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:47:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADjtZkqrR7PE/2dsb2JhbAC7EIglkQwFhA6CJw
X-IronPort-AV: E=Sophos;i="4.43,248,1246838400"; 
   d="scan'208";a="351854548"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Squyres <jsquyres@cisco.com>
Subject: [PATCH/RFC] ummunot: Userspace support for MMU notifications
X-Message-Flag: Warning: May contain useful information
Date: Wed, 22 Jul 2009 10:47:23 -0700
Message-ID: <ada3a8oobis.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Jul 2009 17:47:24.0006 (UTC) FILETIME=[784C8860:01CA0AF4]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61925>
and follow-up messages, libraries using RDMA would like to track
precisely when application code changes memory mapping via free(),
munmap(), etc.  Current pure-userspace solutions using malloc hooks
and other tricks are not robust, and the feeling among experts is that
the issue is unfixable without kernel help.

We solve this not by implementing the full API proposed in the email
linked above but rather with a simpler and more generic interface,
which may be useful in other contexts.  Specifically, we implement a
new character device driver, ummunot, that creates a /dev/ummunot
node.  A userspace process can open this node read-only and use the fd
as follows:

 1. ioctl() to register/unregister an address range to watch in the
    kernel (cf struct ummunot_register_ioctl in <linux/ummunot.h>).

 2. read() to retrieve events generated when a mapping in a watched
    address range is invalidated (cf struct ummunot_event in
    <linux/ummunot.h>).  select()/poll()/epoll() and SIGIO are handled
    for this IO.

 3. mmap() one page at offset 0 to map a kernel page that contains a
    generation counter that is incremented each time an event is
    generated.  This allows userspace to have a fast path that checks
    that no events have occurred without a system call.

Thanks to Jason Gunthorpe <jgunthorpe@obsidianresearch.com> for
suggestions on the interface design.  Also thanks to Jeff Squyres
<jsquyres@cisco.com> for prototyping support for this in Open MPI, which
helped find several bugs during development.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
Andrew -- sending this to you since I don't really know who should merge
this sort of thing.

Solving the underlying issue here is a pretty big deal to the universe
of people that work on MPI implementations (sort of middleware for
high-performance computing).  I think everyone would be open to better
ideas on how to handle this, although I'm pretty happy with how small
and self-contained the ummunot implementation ended up being.

Anyway, review, suggestions, etc. all gratefully received.

Thanks,
  Roland


 drivers/char/Kconfig    |   12 ++
 drivers/char/Makefile   |    1 +
 drivers/char/ummunot.c  |  489 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ummunot.h |  130 +++++++++++++
 4 files changed, 632 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/ummunot.c
 create mode 100644 include/linux/ummunot.h

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 6a06913..8d3dd9d 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -1108,6 +1108,18 @@ config DEVPORT
 	depends on ISA || PCI
 	default y
 
+config UMMUNOT
+       tristate "Userspace MMU notifications"
+       select MMU_NOTIFIER
+       help
+         The ummunot (userspace MMU notification) driver creates a
+         character device that can be used by userspace libraries to
+         get notifications when an application's memory mapping
+         changed.  This is used, for example, by RDMA libraries to
+         improve the reliability of memory registration caching, since
+         the kernel's MMU notifications can be used to know precisely
+         when to shoot down a cached registration.
+
 source "drivers/s390/char/Kconfig"
 
 endmenu
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 66f779a..39ff0c3 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_NSC_GPIO)		+= nsc_gpio.o
 obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio.o
 obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
 obj-$(CONFIG_TELCLOCK)		+= tlclk.o
+obj-$(CONFIG_UMMUNOT)		+= ummunot.o
 
 obj-$(CONFIG_MWAVE)		+= mwave/
 obj-$(CONFIG_AGP)		+= agp/
diff --git a/drivers/char/ummunot.c b/drivers/char/ummunot.c
new file mode 100644
index 0000000..4a13449
--- /dev/null
+++ b/drivers/char/ummunot.c
@@ -0,0 +1,489 @@
+/*
+ * Copyright (c) 2009 Cisco Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/mm.h>
+#include <linux/mmu_notifier.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+#include <linux/rbtree.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/ummunot.h>
+
+#include <asm/cacheflush.h>
+
+MODULE_AUTHOR("Roland Dreier");
+MODULE_DESCRIPTION("Userspace MMU notifiers");
+MODULE_LICENSE("GPL v2");
+
+enum {
+	UMMUNOT_FLAG_DIRTY	= 1,
+	UMMUNOT_FLAG_HINT	= 2,
+};
+
+struct ummunot_reg {
+	u64			user_cookie;
+	unsigned long		start;
+	unsigned long		end;
+	unsigned long		hint_start;
+	unsigned long		hint_end;
+	unsigned long		flags;
+	struct rb_node		node;
+	struct list_head	list;
+};
+
+struct ummunot_file {
+	struct mmu_notifier	mmu_notifier;
+	struct mm_struct       *mm;
+	struct rb_root		reg_tree;
+	struct list_head	dirty_list;
+	u64		       *counter;
+	spinlock_t		lock;
+	wait_queue_head_t	read_wait;
+	struct fasync_struct   *async_queue;
+	int			need_empty;
+	int			used;
+};
+
+static struct ummunot_file *to_ummunot_file(struct mmu_notifier *mn)
+{
+	return container_of(mn, struct ummunot_file, mmu_notifier);
+}
+
+static void ummunot_handle_not(struct mmu_notifier *mn,
+			       unsigned long start, unsigned long end)
+{
+	struct ummunot_file *priv = to_ummunot_file(mn);
+	struct rb_node *n;
+	struct ummunot_reg *reg;
+	unsigned long flags;
+	int hit = 0;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	for (n = rb_first(&priv->reg_tree); n; n = rb_next(n)) {
+		reg = rb_entry(n, struct ummunot_reg, node);
+
+		if (reg->start >= end)
+			break;
+
+		/*
+		 * Ranges overlap if they're not disjoint; and they're
+		 * disjoint if the end of one is before the start of
+		 * the other one.
+		 */
+		if (!(reg->end <= start || end <= reg->start)) {
+			hit = 1;
+
+			if (!test_and_set_bit(UMMUNOT_FLAG_DIRTY, &reg->flags))
+				list_add_tail(&reg->list, &priv->dirty_list);
+
+			if (test_bit(UMMUNOT_FLAG_HINT, &reg->flags)) {
+				clear_bit(UMMUNOT_FLAG_HINT, &reg->flags);
+			} else {
+				set_bit(UMMUNOT_FLAG_HINT, &reg->flags);
+				reg->hint_start = start;
+				reg->hint_end   = end;
+			}
+		}
+	}
+
+	if (hit) {
+		++(*priv->counter);
+		flush_dcache_page(virt_to_page(priv->counter));
+		wake_up_interruptible(&priv->read_wait);
+		kill_fasync(&priv->async_queue, SIGIO, POLL_IN);
+	}
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+static void ummunot_inval_page(struct mmu_notifier *mn,
+			       struct mm_struct *mm,
+			       unsigned long addr)
+{
+	ummunot_handle_not(mn, addr, addr + PAGE_SIZE);
+}
+
+static void ummunot_inval_range_start(struct mmu_notifier *mn,
+				      struct mm_struct *mm,
+				      unsigned long start, unsigned long end)
+{
+	ummunot_handle_not(mn, start, end);
+}
+
+static const struct mmu_notifier_ops ummunot_mmu_notifier_ops = {
+	.invalidate_page	= ummunot_inval_page,
+	.invalidate_range_start	= ummunot_inval_range_start,
+};
+
+static int ummunot_open(struct inode *inode, struct file *filp)
+{
+	struct ummunot_file *priv;
+	int ret;
+
+	if (filp->f_mode & FMODE_WRITE)
+		return -EINVAL;
+
+	priv = kmalloc(sizeof *priv, GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->counter = (void *) get_zeroed_page(GFP_KERNEL);
+	if (!priv->counter) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	priv->reg_tree = RB_ROOT;
+	INIT_LIST_HEAD(&priv->dirty_list);
+	spin_lock_init(&priv->lock);
+	init_waitqueue_head(&priv->read_wait);
+	priv->async_queue = NULL;
+	priv->need_empty  = 0;
+	priv->used	  = 0;
+
+	priv->mmu_notifier.ops = &ummunot_mmu_notifier_ops;
+	/*
+	 * Register notifier last, since notifications can occur as
+	 * soon as we register....
+	 */
+	ret = mmu_notifier_register(&priv->mmu_notifier, current->mm);
+	if (ret)
+		goto err_page;
+
+	priv->mm = current->mm;
+	atomic_inc(&priv->mm->mm_count);
+
+	filp->private_data = priv;
+
+	return 0;
+
+err_page:
+	free_page((unsigned long) priv->counter);
+
+err:
+	kfree(priv);
+	return ret;
+}
+
+static int ummunot_close(struct inode *inode, struct file *filp)
+{
+	struct ummunot_file *priv = filp->private_data;
+	struct rb_node *n;
+	struct ummunot_reg *reg;
+
+	mmu_notifier_unregister(&priv->mmu_notifier, priv->mm);
+	mmdrop(priv->mm);
+	free_page((unsigned long) priv->counter);
+
+	for (n = rb_first(&priv->reg_tree); n; n = rb_next(n)) {
+		reg = rb_entry(n, struct ummunot_reg, node);
+		kfree(reg);
+	}
+
+	kfree(priv);
+
+	return 0;
+}
+
+static bool ummunot_readable(struct ummunot_file *priv)
+{
+	return priv->need_empty || !list_empty(&priv->dirty_list);
+}
+
+static ssize_t ummunot_read(struct file *filp, char __user *buf,
+			    size_t count, loff_t *pos)
+{
+	struct ummunot_file *priv = filp->private_data;
+	struct ummunot_reg *reg;
+	ssize_t ret;
+	struct ummunot_event *events;
+	int max;
+	int n;
+
+	priv->used = 1;
+
+	events = (void *) get_zeroed_page(GFP_KERNEL);
+	if (!events) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	spin_lock_irq(&priv->lock);
+
+	while (!ummunot_readable(priv)) {
+		spin_unlock_irq(&priv->lock);
+
+		if (filp->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
+			goto out;
+		}
+
+		if (wait_event_interruptible(priv->read_wait,
+					     ummunot_readable(priv))) {
+			ret = -ERESTARTSYS;
+			goto out;
+		}
+
+		spin_lock_irq(&priv->lock);
+	}
+
+	max = min(PAGE_SIZE, count) / sizeof *events;
+
+	for (n = 0; n < max; ++n) {
+		if (list_empty(&priv->dirty_list)) {
+			events[n].type		      = UMMUNOT_EVENT_TYPE_LAST;
+			events[n].user_cookie_counter = *priv->counter;
+			++n;
+			priv->need_empty = 0;
+			break;
+		}
+
+		reg = list_first_entry(&priv->dirty_list, struct ummunot_reg,
+				       list);
+
+		events[n].type = UMMUNOT_EVENT_TYPE_INVAL;
+		if (test_bit(UMMUNOT_FLAG_HINT, &reg->flags)) {
+			events[n].flags		= UMMUNOT_EVENT_FLAG_HINT;
+			events[n].hint_start	= max(reg->start, reg->hint_start);
+			events[n].hint_end	= min(reg->end, reg->hint_end);
+		} else {
+			events[n].hint_start	= reg->start;
+			events[n].hint_end	= reg->end;
+		}
+		events[n].user_cookie_counter = reg->user_cookie;
+
+		list_del(&reg->list);
+		reg->flags = 0;
+		priv->need_empty = 1;
+	}
+
+	spin_unlock_irq(&priv->lock);
+
+	if (copy_to_user(buf, events, n * sizeof *events))
+		ret = -EFAULT;
+	else
+		ret = n * sizeof *events;
+
+out:
+	free_page((unsigned long) events);
+	return ret;
+}
+
+static unsigned int ummunot_poll(struct file *filp, struct poll_table_struct *wait)
+{
+	struct ummunot_file *priv = filp->private_data;
+
+	poll_wait(filp, &priv->read_wait, wait);
+
+	return ummunot_readable(priv) ? (POLLIN | POLLRDNORM) : 0;
+}
+
+static long ummunot_exchange_features(struct ummunot_file *priv,
+				      __u32 __user *arg)
+{
+	u32 feature_mask;
+
+	if (priv->used)
+		return -EINVAL;
+
+	priv->used = 1;
+
+	if (get_user(feature_mask, arg))
+		return -EFAULT;
+
+	/* No extensions defined at present. */
+	feature_mask = 0;
+
+	if (put_user(feature_mask, arg))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long ummunot_register_region(struct ummunot_file *priv,
+				    struct ummunot_register_ioctl __user *arg)
+{
+	struct ummunot_register_ioctl parm;
+	struct ummunot_reg *reg, *treg;
+	struct rb_node **n = &priv->reg_tree.rb_node;
+	struct rb_node *pn;
+	int ret = 0;
+
+	if (copy_from_user(&parm, arg, sizeof parm))
+		return -EFAULT;
+
+	priv->used = 1;
+
+	reg = kmalloc(sizeof *reg, GFP_KERNEL);
+	if (!reg)
+		return -ENOMEM;
+
+	reg->user_cookie	= parm.user_cookie;
+	reg->start		= parm.start;
+	reg->end		= parm.end;
+	reg->flags		= 0;
+
+	spin_lock_irq(&priv->lock);
+
+	for (pn = rb_first(&priv->reg_tree); pn; pn = rb_next(pn)) {
+		treg = rb_entry(pn, struct ummunot_reg, node);
+
+		if (treg->user_cookie == parm.user_cookie) {
+			kfree(reg);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	pn = NULL;
+	while (*n) {
+		pn = *n;
+		treg = rb_entry(pn, struct ummunot_reg, node);
+
+		if (reg->start <= treg->start)
+			n = &pn->rb_left;
+		else
+			n = &pn->rb_right;
+	}
+
+	rb_link_node(&reg->node, pn, n);
+	rb_insert_color(&reg->node, &priv->reg_tree);
+
+out:
+	spin_unlock_irq(&priv->lock);
+
+	return ret;
+}
+
+static long ummunot_unregister_region(struct ummunot_file *priv,
+				      __u64 __user *arg)
+{
+	u64 user_cookie;
+	struct rb_node *n;
+	struct ummunot_reg *reg;
+	int ret = -EINVAL;
+
+	if (get_user(user_cookie, arg))
+		return -EFAULT;
+
+	spin_lock_irq(&priv->lock);
+
+	for (n = rb_first(&priv->reg_tree); n; n = rb_next(n)) {
+		reg = rb_entry(n, struct ummunot_reg, node);
+
+		if (reg->user_cookie == user_cookie) {
+			rb_erase(n, &priv->reg_tree);
+			if (test_bit(UMMUNOT_FLAG_DIRTY, &reg->flags))
+				list_del(&reg->list);
+			kfree(reg);
+			ret = 0;
+			break;
+		}
+	}
+
+	spin_unlock_irq(&priv->lock);
+
+	return ret;
+}
+
+static long ummunot_ioctl(struct file *filp, unsigned int cmd,
+			  unsigned long arg)
+{
+	struct ummunot_file *priv = filp->private_data;
+	void __user *argp = (void __user *) arg;
+
+	switch (cmd) {
+	case UMMUNOT_EXCHANGE_FEATURES:
+		return ummunot_exchange_features(priv, argp);
+	case UMMUNOT_REGISTER_REGION:
+		return ummunot_register_region(priv, argp);
+	case UMMUNOT_UNREGISTER_REGION:
+		return ummunot_unregister_region(priv, argp);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+static int ummunot_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct ummunot_file *priv = vma->vm_private_data;
+
+	if (vmf->pgoff != 0)
+		return VM_FAULT_SIGBUS;
+
+	vmf->page = virt_to_page(priv->counter);
+	get_page(vmf->page);
+
+	return 0;
+
+}
+
+static struct vm_operations_struct ummunot_vm_ops = {
+	.fault		= ummunot_fault,
+};
+
+static int ummunot_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct ummunot_file *priv = filp->private_data;
+
+	if (vma->vm_end - vma->vm_start != PAGE_SIZE ||
+	    vma->vm_pgoff != 0)
+		return -EINVAL;
+
+	vma->vm_ops		= &ummunot_vm_ops;
+	vma->vm_private_data	= priv;
+
+	return 0;
+}
+
+static int ummunot_fasync(int fd, struct file *filp, int on)
+{
+	struct ummunot_file *priv = filp->private_data;
+
+	return fasync_helper(fd, filp, on, &priv->async_queue);
+}
+
+static const struct file_operations ummunot_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ummunot_open,
+	.release	= ummunot_close,
+	.read		= ummunot_read,
+	.poll		= ummunot_poll,
+	.unlocked_ioctl	= ummunot_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= ummunot_ioctl,
+#endif
+	.mmap		= ummunot_mmap,
+	.fasync		= ummunot_fasync,
+};
+
+static struct miscdevice ummunot_misc = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "ummunot",
+	.fops	= &ummunot_fops,
+};
+
+static int __init ummunot_init(void)
+{
+	return misc_register(&ummunot_misc);
+}
+
+static void __exit ummunot_cleanup(void)
+{
+	misc_deregister(&ummunot_misc);
+}
+
+module_init(ummunot_init);
+module_exit(ummunot_cleanup);
diff --git a/include/linux/ummunot.h b/include/linux/ummunot.h
new file mode 100644
index 0000000..4640e36
--- /dev/null
+++ b/include/linux/ummunot.h
@@ -0,0 +1,130 @@
+/*
+ * Copyright (c) 2009 Cisco Systems.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenFabrics BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _LINUX_UMMUNOT_H
+#define _LINUX_UMMUNOT_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/*
+ * Ummunot relays MMU notifier events to userspace.  A userspace
+ * process uses it by opening /dev/ummunot, which returns a file
+ * descriptor.  Interest in address ranges is registered using ioctl()
+ * and MMU notifier events are retrieved using read(), as described in
+ * more detail below.
+ */
+
+/*
+ * struct ummunot_register_ioctl describes an address range from start
+ * to end (including start but not including end) to be monitored.
+ * user_cookie is an opaque handle that userspace assigns, and which
+ * is used to unregister.  flags and reserved are currently unused and
+ * should be set to 0 for forward compatibility.
+ */
+struct ummunot_register_ioctl {
+	__u64	start;		/* in */
+	__u64	end;		/* in */
+	__u64	user_cookie;	/* in */
+	__u32	flags;		/* in */
+	__u32	reserved;	/* in */
+};
+
+#define UMMUNOT_MAGIC			'U'
+
+/*
+ * Forward compatibility: Userspace passes in a 32-bit feature mask
+ * with feature flags set indicating which extensions it wishes to
+ * use.  The kernel will return a feature mask with the bits of
+ * userspace's mask that the kernel implements; from that point on
+ * both userspace and the kernel should behave as described by the
+ * kernel's feature mask.
+ *
+ * If userspace does not perform a UMMUNOT_EXCHANGE_FEATURES ioctl,
+ * then the kernel will use a feature mask of 0.
+ *
+ * No feature flags are currently defined, so the kernel will always
+ * return a feature mask of 0 at present.
+ */
+#define UMMUNOT_EXCHANGE_FEATURES	_IOWR(UMMUNOT_MAGIC, 1, __u32)
+
+/*
+ * Register interest in an address range; userspace should pass in a
+ * struct ummunot_register_ioctl describing the region.
+ */
+#define UMMUNOT_REGISTER_REGION		_IOW(UMMUNOT_MAGIC, 2, \
+					      struct ummunot_register_ioctl)
+/*
+ * Unregister interest in an address range; userspace should pass in
+ * the user_cookie value that was used to register the address range.
+ * No events for the address range will be reported once it is
+ * unregistered.
+ */
+#define UMMUNOT_UNREGISTER_REGION	_IOW(UMMUNOT_MAGIC, 3, __u64)
+
+/*
+ * Invalidation events are returned whenever the kernel changes the
+ * mapping for a monitored address.  These events are retrieved by
+ * read() on the ummunot file descriptor, which will fill the read()
+ * buffer with struct ummunot_event.
+ *
+ * If type field is INVAL, then user_cookie_counter holds the
+ * user_cookie for the region being reported; if the HINT flag is set
+ * then hint_start/hint_end hold the start and end of the mapping that
+ * was invalidated.  (If HINT is not set, then multiple events
+ * invalidated parts of the registered range and hint_start/hint_end
+ * and set to the start/end of the whole registered range)
+ *
+ * If type is LAST, then the read operation has emptied the list of
+ * invalidated regions, and user_cookie_counter holds the value of the
+ * kernel's generation counter when the empty list occurred.  The
+ * other fields are not filled in for this event.
+ */
+
+enum {
+	UMMUNOT_EVENT_TYPE_INVAL	= 0,
+	UMMUNOT_EVENT_TYPE_LAST		= 1,
+};
+
+enum {
+	UMMUNOT_EVENT_FLAG_HINT		= 1 << 0,
+};
+
+struct ummunot_event {
+	__u32	type;
+	__u32	flags;
+	__u64	hint_start;
+	__u64	hint_end;
+	__u64	user_cookie_counter;
+};
+
+#endif /* _LINUX_UMMUNOT_H */
-- 
1.6.3.3

