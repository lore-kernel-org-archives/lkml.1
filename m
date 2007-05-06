Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbXEFXtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbXEFXtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 19:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbXEFXtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 19:49:19 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1669 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbXEFXtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 19:49:17 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Date: Sun, 06 May 2007 16:49:15 -0700
Subject: [patch 2/4] KMON - kmon core implementation ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.27461.1178495356.2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the core implementation of the kmon interface.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.21.scdev/include/linux/kmon.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21.scdev/include/linux/kmon.h	2007-05-06 14:10:51.000000000 -0700
@@ -0,0 +1,77 @@
+/*
+ *  include/linux/kmon.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_KMON_H
+#define _LINUX_KMON_H
+
+#define KMON_START	_IO('K', 1)
+#define KMON_STOP	_IO('K', 2)
+#define KMON_BUFFSIZE	_IOR('K', 3, long)
+
+
+#ifdef __KERNEL__
+
+struct kmon_ring {
+	unsigned long head, tail;
+	unsigned long size;
+	void *data;
+};
+
+struct kmon_buffer {
+	void *data;
+	unsigned long size;
+};
+
+struct kmon_notifier {
+	struct list_head lnk;
+	void (*write)(struct kmon_notifier *, const struct kmon_buffer *, int);
+};
+
+int kmon_ring_write(struct kmon_ring *rng, const struct kmon_buffer *kbuf, int n);
+unsigned long kmon_ring_read(struct kmon_ring *rng, struct kmon_buffer *kbuf);
+void kmon_ring_commit_read(struct kmon_ring *rng, unsigned long size);
+int kmon_add_data(const void *data, unsigned long size);
+void kmon_notify_add(struct kmon_notifier *knfy);
+void kmon_notify_remove(struct kmon_notifier *knfy);
+int kmon_setup(void);
+void kmon_cleanup(void);
+
+unsigned long kmon_ring_avail(const struct kmon_ring *rng)
+{
+	return (rng->head - rng->tail) & (rng->size - 1);
+}
+
+static inline void kmon_put16(unsigned char *buf, u16 v)
+{
+	*buf++ = (unsigned char) v;
+	*buf = (unsigned char) (v >> 8);
+}
+
+static inline void kmon_put32(unsigned char *buf, u32 v)
+{
+	*buf++ = (unsigned char) v;
+	*buf++ = (unsigned char) (v >> 8);
+	*buf++ = (unsigned char) (v >> 16);
+	*buf = (unsigned char) (v >> 24);
+}
+
+static inline void kmon_put64(unsigned char *buf, u64 v)
+{
+	*buf++ = (unsigned char) v;
+	*buf++ = (unsigned char) (v >> 8);
+	*buf++ = (unsigned char) (v >> 16);
+	*buf++ = (unsigned char) (v >> 24);
+	*buf++ = (unsigned char) (v >> 32);
+	*buf++ = (unsigned char) (v >> 40);
+	*buf++ = (unsigned char) (v >> 48);
+	*buf = (unsigned char) (v >> 56);
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_KMON_H */
+
Index: linux-2.6.21.scdev/drivers/char/kmon-dev.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21.scdev/drivers/char/kmon-dev.c	2007-05-06 14:10:51.000000000 -0700
@@ -0,0 +1,268 @@
+/*
+ *  drivers/char/kmon-dev.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/miscdevice.h>
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/fcntl.h>
+#include <linux/sched.h>
+#include <linux/mutex.h>
+#include <linux/log2.h>
+#include <linux/kmon.h>
+
+#include <asm/io.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+
+#define KMON_BUFSIZE_DEFAULT	(1024 * 1024)
+#define KMON			"kmon v0.17"
+
+#define KMON_FL_OVERFLOW	(1 << 0)
+
+struct kmon_ctx {
+	struct kmon_notifier knfy;
+	struct mutex mtx;
+	wait_queue_head_t wqh;
+	struct kmon_ring rng;
+	unsigned long flags;
+};
+
+static int kmon_alloc_ring(struct kmon_ring *rng, unsigned long size)
+{
+	size = roundup_pow_of_two(size);
+	rng->data = vmalloc(size);
+	if (rng->data == NULL)
+		return -ENOMEM;
+	rng->head = rng->tail = 0;
+	rng->size = size;
+
+	return 0;
+}
+
+static void kmon_nfy_write(struct kmon_notifier *knfy, const struct kmon_buffer *kbuf,
+			   int n)
+{
+	struct kmon_ctx *ctx = container_of(knfy, struct kmon_ctx, knfy);
+	int error;
+
+	mutex_lock(&ctx->mtx);
+	if (likely((ctx->flags & KMON_FL_OVERFLOW) == 0)) {
+		error = kmon_ring_write(&ctx->rng, kbuf, n);
+		if (unlikely(error))
+			ctx->flags |= KMON_FL_OVERFLOW;
+	}
+	if (waitqueue_active(&ctx->wqh))
+		wake_up_locked(&ctx->wqh);
+	mutex_unlock(&ctx->mtx);
+}
+
+static int kmon_open(struct inode *inode, struct file *file)
+{
+	int error;
+	struct kmon_ctx *ctx;
+
+	ctx = (struct kmon_ctx *) kzalloc(sizeof(struct kmon_ctx), GFP_KERNEL);
+	if (ctx == NULL)
+		return -ENOMEM;
+	error = kmon_alloc_ring(&ctx->rng, KMON_BUFSIZE_DEFAULT);
+	if (error) {
+		kfree(ctx);
+		return error;
+	}
+	init_waitqueue_head(&ctx->wqh);
+	mutex_init(&ctx->mtx);
+
+	file->private_data = ctx;
+
+	return 0;
+}
+
+static int kmon_release(struct inode *inode, struct file *file)
+{
+	struct kmon_ctx *ctx = file->private_data;
+
+	if (ctx->knfy.write != NULL)
+		kmon_notify_remove(&ctx->knfy);
+	vfree(ctx->rng.data);
+	mutex_destroy(&ctx->mtx);
+	kfree(ctx);
+
+	return 0;
+}
+
+static unsigned int kmon_poll(struct file *file, poll_table *wait)
+{
+	struct kmon_ctx *ctx = file->private_data;
+	unsigned int events = 0;
+
+	poll_wait(file, &ctx->wqh, wait);
+
+	mutex_lock(&ctx->mtx);
+	if (ctx->flags & KMON_FL_OVERFLOW)
+		events |= POLLERR;
+	if (ctx->rng.head != ctx->rng.tail)
+		events |= POLLIN;
+	mutex_unlock(&ctx->mtx);
+
+	return events;
+}
+
+static ssize_t kmon_read(struct file *file, char __user *buf, size_t count,
+			 loff_t *ppos)
+{
+	struct kmon_ctx *ctx = file->private_data;
+	ssize_t res, i;
+	unsigned long size, bcnt;
+	DECLARE_WAITQUEUE(wait, current);
+	struct kmon_buffer kbuf[2];
+
+	mutex_lock(&ctx->mtx);
+	res = -EAGAIN;
+	size = kmon_ring_read(&ctx->rng, kbuf);
+	if (size == 0 && !(file->f_flags & O_NONBLOCK)) {
+		__add_wait_queue(&ctx->wqh, &wait);
+		for (res = 0;;) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			size = kmon_ring_read(&ctx->rng, kbuf);
+			if (size != 0) {
+				res = 0;
+				break;
+			}
+			if (signal_pending(current)) {
+				res = -ERESTARTSYS;
+				break;
+			}
+			mutex_unlock(&ctx->mtx);
+			schedule();
+			mutex_lock(&ctx->mtx);
+		}
+		__remove_wait_queue(&ctx->wqh, &wait);
+		__set_current_state(TASK_RUNNING);
+	}
+	if (size != 0) {
+		res = -EFAULT;
+		for (i = 0, size = 0; size < (unsigned long) count &&
+		     i < 2; i++) {
+			bcnt = min(kbuf[i].size, (unsigned long) count - size);
+			if (bcnt != 0 &&
+			    copy_to_user(buf + size, kbuf[i].data, bcnt))
+				goto out_unlock;
+			size += bcnt;
+		}
+		kmon_ring_commit_read(&ctx->rng, size);
+		res = (ssize_t) size;
+	}
+out_unlock:
+	mutex_unlock(&ctx->mtx);
+
+	return res;
+}
+
+static int kmon_ioctl(struct inode *inode, struct file *file,
+		      unsigned int cmd, unsigned long arg)
+{
+	struct kmon_ctx *ctx = file->private_data;
+	int error = -EINVAL;
+	unsigned long size;
+
+	switch (cmd) {
+	case KMON_START:
+		mutex_lock(&ctx->mtx);
+		error = -ENOBUFS;
+		if (ctx->rng.data != NULL) {
+			if (ctx->knfy.write == NULL) {
+				ctx->rng.head = ctx->rng.tail = 0;
+				ctx->flags &= ~KMON_FL_OVERFLOW;
+				ctx->knfy.write = kmon_nfy_write;
+				kmon_notify_add(&ctx->knfy);
+				error = 0;
+			} else
+				error = -EALREADY;
+		}
+		mutex_unlock(&ctx->mtx);
+		break;
+
+	case KMON_STOP:
+		mutex_lock(&ctx->mtx);
+		if (ctx->knfy.write != NULL) {
+			kmon_notify_remove(&ctx->knfy);
+			ctx->knfy.write = NULL;
+			error = 0;
+		} else
+			error = -EALREADY;
+		mutex_unlock(&ctx->mtx);
+		break;
+
+	case KMON_BUFFSIZE:
+		if (copy_from_user(&size, (void __user *) arg, sizeof(size)))
+			return -EFAULT;
+		mutex_lock(&ctx->mtx);
+		if (ctx->knfy.write == NULL) {
+			vfree(ctx->rng.data);
+			ctx->rng.data = NULL;
+			error = kmon_alloc_ring(&ctx->rng, size);
+		} else
+			error = -EBUSY;
+		mutex_unlock(&ctx->mtx);
+		break;
+	}
+
+	return error;
+}
+
+static const struct file_operations kmon_fops = {
+	.poll = kmon_poll,
+	.read = kmon_read,
+	.ioctl = kmon_ioctl,
+	.open = kmon_open,
+	.release = kmon_release,
+};
+
+static struct miscdevice kmon_dev = {
+	MISC_DYNAMIC_MINOR,
+	"kmon",
+	&kmon_fops
+};
+
+static int __init kmon_init(void)
+{
+	int error;
+
+	error = kmon_setup();
+	if (error)
+		return error;
+
+	error = misc_register(&kmon_dev);
+	if (error) {
+		printk(KERN_ERR KMON " - unable to register misc device.\n");
+		goto out_kmon_cleanup;
+	}
+
+	return 0;
+
+out_kmon_cleanup:
+	kmon_cleanup();
+	return error;
+}
+module_init(kmon_init);
+
+static void __exit kmon_exit(void)
+{
+	misc_deregister(&kmon_dev);
+	kmon_cleanup();
+}
+module_exit(kmon_exit);
+
+MODULE_AUTHOR("Davide Libenzi");
+MODULE_LICENSE("GPL");
+
Index: linux-2.6.21.scdev/kernel/kmon.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21.scdev/kernel/kmon.c	2007-05-06 14:10:51.000000000 -0700
@@ -0,0 +1,310 @@
+/*
+ *  kernel/kmon.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/fcntl.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+#include <linux/workqueue.h>
+#include <linux/log2.h>
+#include <linux/cpu.h>
+#include <linux/ktime.h>
+#include <linux/kmon.h>
+
+#include <asm/io.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+
+#define DEF_CPUBUF_SIZE		(1024 * 16)
+#define DEF_SYNCBUF_FREQ	(HZ / 20)
+#define CPUBUF_CPU(p)		((int) ((p) - cpubuf))
+
+struct kmon_cpubuf {
+	struct delayed_work work;
+	struct kmon_ring rng;
+	u64 base_time;
+};
+
+static unsigned long cpubuf_size = DEF_CPUBUF_SIZE;
+static unsigned long flush_freq = DEF_SYNCBUF_FREQ;
+static struct kmon_cpubuf cpubuf[NR_CPUS] __cacheline_aligned;
+static struct list_head kmon_nfylist = LIST_HEAD_INIT(kmon_nfylist);
+static struct mutex kmon_mtx;
+static struct mutex setup_mtx;
+static long usecnt;
+
+int kmon_ring_write(struct kmon_ring *rng, const struct kmon_buffer *kbuf, int n)
+{
+	int i;
+	unsigned long head, rspace, dwrt;
+
+	head = rng->head;
+	rspace = (rng->size - 1) - ((head - rng->tail) & (rng->size - 1));
+	for (i = 0; i < n; i++, kbuf++) {
+		if (rspace < kbuf->size)
+			return -EAGAIN;
+		dwrt = min(kbuf->size, rng->size - head);
+		if (likely(dwrt))
+			memcpy(rng->data + head, kbuf->data, dwrt);
+		if (kbuf->size > dwrt)
+			memcpy(rng->data, kbuf->data + dwrt, kbuf->size - dwrt);
+		rspace -= kbuf->size;
+		head = (head + kbuf->size) & (rng->size - 1);
+	}
+	smp_wmb();
+	rng->head = head;
+
+	return 0;
+}
+EXPORT_SYMBOL(kmon_ring_write);
+
+unsigned long kmon_ring_read(struct kmon_ring *rng, struct kmon_buffer *kbuf)
+{
+	unsigned long size;
+
+	size = kmon_ring_avail(rng);
+	kbuf[0].size = min(size, rng->size - rng->tail);
+	kbuf[0].data = rng->data + rng->tail;
+	kbuf[1].size = size - kbuf[0].size;
+	kbuf[1].data = rng->data;
+
+	return size;
+}
+EXPORT_SYMBOL(kmon_ring_read);
+
+void kmon_ring_commit_read(struct kmon_ring *rng, unsigned long size)
+{
+	rng->tail = (rng->tail + size) & (rng->size - 1);
+}
+EXPORT_SYMBOL(kmon_ring_commit_read);
+
+static unsigned int kmon_prepare_buf(unsigned char *buf, int cpu, u64 time,
+				     unsigned long size)
+{
+	buf[0] = (unsigned char) cpu;
+	kmon_put64(buf + 1, time);
+	kmon_put16(buf + 9, (u16) size);
+	return 11;
+}
+
+int kmon_add_data(const void *data, unsigned long size)
+{
+	int cpu, error = -EAGAIN;
+	u64 ctime;
+	struct kmon_cpubuf *cpub;
+	unsigned char buf[16];
+	struct kmon_buffer kbuf[2];
+
+	rcu_read_lock();
+	cpu = smp_processor_id();
+	cpub = &cpubuf[cpu];
+	if (cpub->rng.data != NULL) {
+		ctime = ktime_to_ns(ktime_get());
+		kbuf[0].data = buf;
+		kbuf[0].size = kmon_prepare_buf(buf, cpu, ctime, size);
+		kbuf[1].data = (void *) data;
+		kbuf[1].size = size;
+		error = kmon_ring_write(&cpub->rng, kbuf, 2);
+	}
+	rcu_read_unlock();
+
+	return error;
+}
+EXPORT_SYMBOL(kmon_add_data);
+
+void kmon_notify_add(struct kmon_notifier *knfy)
+{
+	mutex_lock(&kmon_mtx);
+	list_add_tail(&knfy->lnk, &kmon_nfylist);
+	mutex_unlock(&kmon_mtx);
+}
+EXPORT_SYMBOL(kmon_notify_add);
+
+void kmon_notify_remove(struct kmon_notifier *knfy)
+{
+	mutex_lock(&kmon_mtx);
+	list_del_init(&knfy->lnk);
+	mutex_unlock(&kmon_mtx);
+}
+EXPORT_SYMBOL(kmon_notify_remove);
+
+static void kmon_sync_buffer(struct work_struct *work)
+{
+	unsigned long size;
+	struct kmon_cpubuf *cpub;
+	struct kmon_notifier *knfy;
+	struct kmon_buffer kbuf[2];
+
+	cpub = container_of(work, struct kmon_cpubuf, work.work);
+	mutex_lock(&kmon_mtx);
+	if (likely(cpub->rng.data != NULL)) {
+		size = kmon_ring_read(&cpub->rng, kbuf);
+		if (likely(size)) {
+			list_for_each_entry(knfy, &kmon_nfylist, lnk) {
+				(*knfy->write)(knfy, kbuf, 2);
+			}
+			kmon_ring_commit_read(&cpub->rng, size);
+		}
+		schedule_delayed_work(&cpub->work, flush_freq);
+	}
+	mutex_unlock(&kmon_mtx);
+}
+
+static int kmon_cpu_prepare(int cpu)
+{
+	unsigned long size;
+	void *data;
+	struct kmon_cpubuf *cpub;
+
+	size = roundup_pow_of_two(cpubuf_size);
+	cpub = &cpubuf[cpu];
+	mutex_lock(&kmon_mtx);
+	if (cpub->rng.data == NULL) {
+		data = vmalloc_node(size, cpu_to_node(cpu));
+		if (data == NULL) {
+			mutex_unlock(&kmon_mtx);
+			return -ENOMEM;
+		}
+		cpub->rng.head = cpub->rng.tail = 0;
+		cpub->rng.size = size;
+		rcu_assign_pointer(cpub->rng.data, data);
+		INIT_DELAYED_WORK(&cpub->work, kmon_sync_buffer);
+		schedule_delayed_work_on(cpu, &cpub->work, flush_freq + cpu);
+	}
+	mutex_unlock(&kmon_mtx);
+
+	return 0;
+}
+
+static void kmon_cpu_cleanup(int cpu)
+{
+	void *data = NULL;
+	struct kmon_cpubuf *cpub;
+
+	cpub = &cpubuf[cpu];
+	mutex_lock(&kmon_mtx);
+	if (cpub->rng.data != NULL) {
+		data = cpub->rng.data;
+		cpub->rng.data = NULL;
+	}
+	mutex_unlock(&kmon_mtx);
+
+	if (data != NULL) {
+		cancel_delayed_work(&cpub->work);
+		synchronize_rcu();
+		vfree(data);
+	}
+}
+
+static int kmon_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
+			    void *v)
+{
+	int cpu = (long) v;
+
+	switch (val) {
+	case CPU_UP_PREPARE:
+		kmon_cpu_prepare(cpu);
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_DEAD:
+		kmon_cpu_cleanup(cpu);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kmon_cpu_notifier = {
+	.notifier_call = kmon_cpu_hotplug,
+};
+
+static void kmon_free_cpubufs(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		kmon_cpu_cleanup(cpu);
+}
+
+static int kmon_alloc_cpubufs(void)
+{
+	int cpu, error;
+
+	for_each_online_cpu(cpu) {
+		error = kmon_cpu_prepare(cpu);
+		if (error) {
+			kmon_free_cpubufs();
+			return error;
+		}
+	}
+
+	return 0;
+}
+
+int kmon_setup(void)
+{
+	int error;
+
+	mutex_lock(&setup_mtx);
+	if (usecnt > 0)
+		goto setup_done;
+
+	error = register_cpu_notifier(&kmon_cpu_notifier);
+	if (error)
+		goto out_unlock;
+
+	error = kmon_alloc_cpubufs();
+	if (error)
+		goto out_unreg_cpuntfy;
+
+setup_done:
+	usecnt++;
+	mutex_unlock(&setup_mtx);
+
+	return 0;
+
+out_unreg_cpuntfy:
+	unregister_cpu_notifier(&kmon_cpu_notifier);
+	kmon_free_cpubufs();
+out_unlock:
+	mutex_unlock(&setup_mtx);
+	return error;
+}
+EXPORT_SYMBOL(kmon_setup);
+
+void kmon_cleanup(void)
+{
+	mutex_lock(&setup_mtx);
+	usecnt--;
+	if (usecnt == 0) {
+		unregister_cpu_notifier(&kmon_cpu_notifier);
+		kmon_free_cpubufs();
+	}
+	mutex_unlock(&setup_mtx);
+}
+EXPORT_SYMBOL(kmon_cleanup);
+
+static int __init kmon_init(void)
+{
+	mutex_init(&kmon_mtx);
+	mutex_init(&setup_mtx);
+
+	return 0;
+}
+fs_initcall(kmon_init);
+
Index: linux-2.6.21.scdev/kernel/kmon-stats.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21.scdev/kernel/kmon-stats.c	2007-05-06 14:10:51.000000000 -0700
@@ -0,0 +1,62 @@
+/*
+ *  kernel/kmon-stats.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/fcntl.h>
+#include <linux/sched.h>
+#include <linux/kmon.h>
+#include <linux/kmon-stats.h>
+
+#include <asm/io.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+
+void kmon_st_task_enqueue(struct task_struct *tsk)
+{
+	unsigned char buf[8];
+
+	buf[0] = KMON_DT_TSKQUEUE;
+	kmon_put16(buf + 1, (u16) tsk->pid);
+	kmon_add_data(buf, 3);
+}
+
+void kmon_st_task_dequeue(struct task_struct *tsk)
+{
+	unsigned char buf[8];
+
+	buf[0] = KMON_DT_TSKDEQUEUE;
+	kmon_put16(buf + 1, (u16) tsk->pid);
+	kmon_add_data(buf, 3);
+}
+
+void kmon_st_task_switch(struct task_struct *prev, struct task_struct *next)
+{
+	unsigned char buf[8];
+
+	buf[0] = KMON_DT_TSKSWITCH;
+	kmon_put16(buf + 1, (u16) prev->pid);
+	kmon_put16(buf + 3, (u16) next->pid);
+	kmon_add_data(buf, 5);
+}
+
+void kmon_st_task_wakeup(struct task_struct *from, struct task_struct *to)
+{
+	unsigned char buf[8];
+
+	buf[0] = KMON_DT_TSKWAKEUP;
+	kmon_put16(buf + 1, from ? (u16) from->pid: 0);
+	kmon_put16(buf + 3, (u16) to->pid);
+	kmon_add_data(buf, 5);
+}
+
Index: linux-2.6.21.scdev/include/linux/kmon-stats.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21.scdev/include/linux/kmon-stats.h	2007-05-06 14:10:51.000000000 -0700
@@ -0,0 +1,37 @@
+/*
+ *  include/linux/kmon-stats.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_KMON_STATS_H
+#define _LINUX_KMON_STATS_H
+
+#define KMON_DT_TSKQUEUE	1
+#define KMON_DT_TSKDEQUEUE	2
+#define KMON_DT_TSKSWITCH	3
+#define KMON_DT_TSKWAKEUP	4
+
+#ifdef __KERNEL__
+
+#ifdef CONFIG_KMON
+
+void kmon_st_task_enqueue(struct task_struct *tsk);
+void kmon_st_task_dequeue(struct task_struct *tsk);
+void kmon_st_task_switch(struct task_struct *prev, struct task_struct *next);
+void kmon_st_task_wakeup(struct task_struct *from, struct task_struct *to);
+
+#else /* CONFIG_KMON */
+
+#define kmon_st_task_enqueue(p)		do { } while (0)
+#define kmon_st_task_dequeue(p)		do { } while (0)
+#define kmon_st_task_switch(p, n)	do { } while (0)
+#define kmon_st_task_wakeup(f, t)	do { } while (0)
+
+#endif /* CONFIG_KMON */
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_KMON_STATS_H */
+

