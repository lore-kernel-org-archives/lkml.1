Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbZLMKjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbZLMKjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 05:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZLMKjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 05:39:46 -0500
Received: from www84.your-server.de ([213.133.104.84]:54195 "HELO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752206AbZLMKjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 05:39:45 -0500
Subject: Re: [PATCH 1/1] RFC: new kqueue API
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Shargorodsky Atal <ext-atal.shargorodsky@nokia.com>
In-Reply-To: <1260700633.17424.18.camel@wall-e>
References: <1260700633.17424.18.camel@wall-e>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 13 Dec 2009 11:39:25 +0100
Message-ID: <1260700765.17424.21.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New kqueue API for queues with fixed size entries.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 include/linux/kqueue.h |  407 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/Makefile        |    2 
 kernel/kqueue.c        |  200 ++++++++++++++++++++++++
 3 files changed, 608 insertions(+), 1 deletion(-)

diff -u -N -r orig/include/linux/kqueue.h new/include/linux/kqueue.h
--- orig/include/linux/kqueue.h	1970-01-01 01:00:00.000000000 +0100
+++ new/include/linux/kqueue.h	2009-12-13 10:36:10.103881867 +0100
@@ -0,0 +1,407 @@
+/*
+ * A generic kernel queue implementation for fixed size elements.
+ *
+ * Copyright (C) 2009 Stefani Seibold <stefani@seibold.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef _LINUX_KQUEUE_H
+#define _LINUX_KQUEUE_H
+
+#ifdef __KERNEL__
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/stddef.h>
+#include <linux/scatterlist.h>
+#endif
+
+#define STRUCT_KQUEUE(type, size) \
+struct { \
+	unsigned int	in; \
+	unsigned int	out; \
+	unsigned int	mask; \
+	type		data[size ? ((size & (size - 1)) ? -1 : size) : 1]; \
+}
+
+/**
+ * DECLARE_KQUEUE - macro to declare a kqueue object
+ * @queue: name of the declared kqueue
+ * @type: type of the queue elements
+ * @size: the number of elements in the queue, this must be a power of 2.
+ */
+#define DECLARE_KQUEUE(queue, type, size) \
+	STRUCT_KQUEUE(type, size) queue
+
+/*
+ * Macros for declaration and initialization of the kqueue datatype
+ */
+
+/* helper macro */
+#define __kqueue_initializer(queue) \
+	(typeof(queue)) { \
+		.in	= 0, \
+		.out	= 0, \
+		.mask	= ARRAY_SIZE(queue.data) - 1, \
+	}
+
+/**
+ * INIT_KQUEUE - Initialize a kqueue declared by DECLARED_KQUEUE
+ * @queue: name of the declared kqueue datatype
+ */
+#define INIT_KQUEUE(queue) \
+	queue = __kqueue_initializer(queue)
+
+/**
+ * DEFINE_KQUEUE - macro to define and initialize a kqueue
+ * @queue: name of the declared kqueue datatype
+ * @type: type of the queue elements
+ * @size: the number of elements in the queue, this must be a power of 2.
+ *
+ * Note: the macro can be used for global and local kqueue data type variables
+ */
+#define DEFINE_KQUEUE(queue, type, size) \
+	DECLARE_KQUEUE(queue, type, size) = __kqueue_initializer(queue)
+
+/**
+ * kqueue_size - returns the size of the queue in elements
+ * @queue: the queue to be used.
+ */
+#define kqueue_size(queue)	((queue)->mask + 1)
+
+/**
+ * kqueue_reset - removes the entire queue content
+ * @queue: the queue to be used.
+ */
+#define kqueue_reset(queue) \
+(void)({ \
+	typeof(queue) __tmp = queue; \
+	__tmp->in = __tmp->out = 0; \
+})
+
+/**
+ * kqueue_reset_out - skip queue content
+ * @queue: the queue to be used.
+ */
+#define kqueue_reset_out(queue)	\
+(void)({ \
+	typeof(queue) __tmp = queue; \
+	__tmp->out = __tmp->in; \
+})
+
+/**
+ * kqueue_len - returns the number of used elements in the queue
+ * @queue: the queue to be used.
+ */
+#define kqueue_len(queue) \
+({ \
+	typeof(queue) __tmp = queue; \
+	register unsigned int	__out; \
+	__out = __tmp->out; \
+	smp_rmb(); \
+	__tmp->in - __out; \
+})
+
+/**
+ * kqueue_is_empty - returns true if the queue is empty
+ * @queue: the queue to be used.
+ */
+#define	kqueue_is_empty(queue) \
+({ \
+	typeof(queue) __tmp = queue; \
+	__tmp->in == __tmp->out; \
+})
+
+/**
+ * kqueue_is_full - returns true if the queue is full
+ * @queue: the queue to be used.
+ */
+#define	kqueue_is_full(queue) \
+({ \
+	typeof(queue) __tmpq = queue; \
+	kqueue_size(__tmpq) == kqueue_len(__tmpq); \
+})
+
+/**
+ * kqueue_avail - returns the number of elements available in the queue
+ * @queue: the queue to be used.
+ */
+#define	kqueue_avail(queue) \
+({ \
+	typeof(queue) __tmpq = queue; \
+	kqueue_size(__tmpq) - kqueue_len(__tmpq); \
+})
+
+/**
+ * kqueue_skip - skip output data
+ * @queue: the queue to be used.
+ */
+#define	kqueue_skip(queue)	((queue)->out++)
+
+/**
+ * kqueue_in - puts some data into the queue
+ * @queue: the queue to be used.
+ * @val: the data to be added.
+ *
+ * This macro opies the given value into the queue.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define	kqueue_in(queue, val) \
+({ \
+	typeof(queue) __tmp = queue; \
+	typeof(val) __val = val; \
+	smp_mb(); \
+	__tmp->data[__tmp->in & __tmp->mask] = __val; \
+	barrier(); \
+	__tmp->in++; \
+	__val; \
+})
+
+/**
+ * kqueue_in_locked - put data into the queue using a spinlock for locking
+ * @queue: the queue to be used.
+ * @val: the data to be added.
+ * @lock: pointer to the spinlock to use for locking.
+ *
+ * This macro copies the given value into the queue.
+ */
+#define	kqueue_in_locked(queue, val, lock) \
+({ \
+	typeof(val) __val = val; \
+	unsigned long __flags; \
+	unsigned int __ret; \
+	spin_lock_irqsave(lock, __flags); \
+	kqueue_in(queue, __val); \
+	spin_unlock_irqrestore(lock, __flags); \
+	__val; \
+})
+
+/**
+ * kqueue_out - get data from the queue
+ * @queue: the queue to be used.
+ *
+ * This macro returns the data from the queue
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define	kqueue_out(queue) \
+({ \
+	typeof(queue) __tmp = queue; \
+	typeof(__tmp->data[0]) __ret; \
+	smp_rmb(); \
+	__ret = __tmp->data[__tmp->out & __tmp->mask]; \
+	barrier(); \
+	__tmp->out++; \
+	__ret; \
+})
+
+/**
+ * kqueue_out_locked - get data from the queue using a spinlock for locking
+ * @queue: the queue to be used.
+ * @lock: pointer to the spinlock to use for locking.
+ *
+ * This macro returns the data from the queue
+ */
+#define	kqueue_out_locked(queue, lock) \
+({ \
+	typeof(queue) __tmpq = queue; \
+	typeof(__tmp->data[0]) __ret; \
+	unsigned long __flags; \
+	unsigned int __ret; \
+	spin_lock_irqsave(lock, __flags); \
+	__ret = kqueue_out(__tmpq); \
+	spin_unlock_irqrestore(lock, __flags); \
+	__ret; \
+})
+
+extern unsigned int __kqueue_from_user(void *data, unsigned int size,
+		unsigned int in, unsigned int out, size_t esize,
+		const void __user *from, unsigned int len);
+
+/**
+ * kqueue_from_user - puts some data from user space into the queue
+ * @queue: the queue to be used.
+ * @from: pointer to the data to be added.
+ * @len: the length of the data to be added.
+ *
+ * This macro copies at most @len bytes from the @from into the
+ * queue, depending of the available space and returns the number
+ * of copied bytes.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define	kqueue_from_user(queue, from, len) \
+({ \
+	typeof(queue) __tmp = queue; \
+	unsigned int __len = len; \
+	unsigned int __ret; \
+	size_t __esize = sizeof(__tmp->data[0]); \
+	smp_mb(); \
+	__ret = __kqueue_from_user(__tmp->data, kqueue_size(__tmp), __tmp->in, \
+					__tmp->out, __esize, from, __len); \
+	__tmp->in += __ret; \
+	__len - __ret * __esize; \
+})
+
+extern unsigned int __kqueue_to_user(void *data, unsigned int size,
+		unsigned int in, unsigned int out, size_t esize,
+		void __user *to, unsigned int len);
+
+/**
+ * kqueue_to_user - gets data from the queue and write it to user space
+ * @queue: the queue to be used.
+ * @to: where the data must be copied.
+ * @len: the size of the destination buffer.
+ *
+ * This macro copies at most @len bytes from the queue into the
+ * @to buffer and returns the number of copied bytes.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define	kqueue_to_user(queue, to, len) \
+({ \
+	typeof(queue) __tmp = queue; \
+	unsigned int __len = len; \
+	unsigned int __ret; \
+	size_t __esize = sizeof(__tmp->data[0]); \
+	smp_rmb(); \
+	__ret = __kqueue_to_user(__tmp->data, kqueue_size(__tmp), __tmp->in, \
+					__tmp->out, __esize, to, __len); \
+	__tmp->out += __ret; \
+	__len - __ret * __esize; \
+})
+
+extern int __kqueue_alloc(void **queue, unsigned int size,
+		size_t off, size_t esize, gfp_t gfp_mask);
+
+/**
+ * kqueue_alloc - allocates a new queue
+ * @queue: pointer to a pointer to the queue
+ * @size: the number of elements in the queue, this must be a power of 2.
+ * @gfp_mask: get_free_pages mask, passed to kmalloc()
+ *
+ * This macro dynamically allocates a new queue.
+ *
+ * The size will be rounded-up to a power of 2.
+ * The queue will be release with kqueue_free().
+ * Return 0 if no error, otherwise an error code
+ */
+#define kqueue_alloc(queue, size, gfp_mask) \
+({ \
+	typeof(queue) __tmp = queue; \
+	__kqueue_alloc((void **)__tmp, size, offsetof(typeof(**__tmp), data), \
+		sizeof((*__tmp)->data[0]), gfp_mask); \
+})
+
+/**
+ * kqueue_free - frees the queue
+ * @queue: the queue to be freed.
+ */
+#define kqueue_free(queue)	kfree(queue)
+
+extern unsigned int __kqueue_dma_in_prepare(void *data, unsigned int size,
+		unsigned int in, unsigned int out, size_t esize,
+		struct scatterlist *sgl, int nents);
+
+/**
+ * kqueue_dma_in_prepare - setup a scatterlist for DMA input
+ * @queue: the queue to be used.
+ * @sgl: pointer to the scatterlist array.
+ * @nents: number of entries in the scatterlist array (should be 1 or 2).
+ *
+ * This function fills a scatterlist for DMA input.
+ * It returns the number of bytes which are available for the transfer.
+ * A return value of 0 means that no scatterlist was written.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+#define	kqueue_dma_in_prepare(queue, sgl, nents) \
+({ \
+	typeof(queue) __tmp = queue; \
+	smp_mb(); \
+	__kqueue_dma_in_prepare(__tmp->data, kqueue_size(__tmp), __tmp->in, \
+			__tmp->out, sizeof(__tmp->data[0]), sgl, nents); \
+})
+
+/**
+ * kqueue_dma_in_finish - finish a DMA IN operation
+ * @queue: the queue to be used.
+ * @len: number number of bytes to received.
+ *
+ * This function finish a DMA IN operation. The in counter will be updated by
+ * the len parameter. No error checking will be done.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+#define kqueue_dma_in_finish(queue, len) \
+(void)({ \
+	typeof(queue) __tmp = queue; \
+	__tmp->in += len / sizeof(__tmp->data[0]); \
+})
+
+extern unsigned int __kqueue_dma_out_prepare(void *data, unsigned int size,
+		unsigned int in, unsigned int out, size_t esize,
+		struct scatterlist *sgl, int nents, unsigned int len);
+
+/**
+ * kqueue_dma_out_prepare - setup a scatterlist for DMA output
+ * @queue: the queue to be used.
+ * @sgl: pointer to the scatterlist array.
+ * @nents: number of entries in the scatterlist array (should be 1 or 2).
+ * @len: number number of bytes to transfer.
+ *
+ * This function fills a scatterlist for DMA output which at most @len bytes
+ * to transfer.
+ * It returns the number of bytes which are available for the transfer.
+ * A return value of 0 means that no scatterlist was written.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+#define	kqueue_dma_out_prepare(queue, sgl, nents, len) \
+({ \
+	typeof(queue) __tmp = queue; \
+	smp_rmb(); \
+	__kqueue_dma_out_prepare(__tmp->data, kqueue_size(__tmp), __tmp->in, \
+			__tmp->out, sizeof(__tmp->data[0]), sgl, nents, len); \
+})
+
+/**
+ * kqueue_dma_out_finish - finish a DMA OUT operation
+ * @queue: the queue to be used.
+ * @len: number number of bytes transferd.
+ *
+ * This function finish a DMA OUT operation. The out counter will be updated by
+ * the len parameter. No error checking will be done.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+#define kqueue_dma_out_finish(queue, len) \
+(void)({ \
+	typeof(queue) __tmp = queue; \
+	__tmp->out += len / sizeof(__tmp->data[0]); \
+})
+
+#endif
+
diff -u -N -r orig/kernel/kqueue.c new/kernel/kqueue.c
--- orig/kernel/kqueue.c	1970-01-01 01:00:00.000000000 +0100
+++ new/kernel/kqueue.c	2009-12-13 10:37:44.382185403 +0100
@@ -0,0 +1,200 @@
+/*
+ * A generic kernel queue implementation for fixed size elements.
+ *
+ * Copyright (C) 2009 Stefani Seibold <stefani@seibold.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifdef __KERNEL__
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/kqueue.h>
+#include <linux/log2.h>
+#include <linux/uaccess.h>
+#endif
+
+#define	roundup_diff(val, size)	(((val) + (size - 1)) / size)
+
+int __kqueue_alloc(void **queue, unsigned int size,
+		size_t off, size_t esize, gfp_t gfp_mask)
+{
+	DECLARE_KQUEUE(*proxy, char, 0);
+
+	/*
+	 * round up to the next power of 2, since our 'let the indices
+	 * wrap' technique works only in this case.
+	 */
+	if (!is_power_of_2(size)) {
+		BUG_ON(size > 0x80000000);
+		size = roundup_pow_of_two(size);
+	}
+
+	*queue = kmalloc(size * esize + off, gfp_mask);
+
+	proxy = (typeof(proxy))(*queue);
+
+	if (!proxy)
+		return -ENOMEM;
+
+	proxy->in = proxy->out = 0;
+	proxy->mask = size - 1;
+
+	return 0;
+}
+
+unsigned int __kqueue_from_user(void *data, unsigned int size, unsigned int in,
+		unsigned int out, size_t esize,
+		const void __user *from, unsigned int len)
+{
+	unsigned int l;
+	int ret;
+	unsigned int off;
+
+	len /= esize;
+	l = size - (in - out);
+	if (len > l)
+		len = l;
+
+	off = in & (size - 1);
+
+	/* first put the data starting from in to queue end */
+	l = min(len, size - off);
+	ret = copy_from_user(data + off * esize, from, l);
+
+	if (unlikely(ret))
+		return l - roundup_diff(ret, esize);
+
+	if (l == len)
+		return len;
+
+	/* then put the rest (if any) at the beginning of the queue */
+	ret = copy_from_user(data, from + l * esize, (len - l) * esize);
+
+	if (unlikely(ret))
+		return len - roundup_diff(ret, esize);
+
+	return len;
+}
+
+unsigned int __kqueue_to_user(void *data, unsigned int size, unsigned int in,
+		unsigned int out, size_t esize,
+		void __user *to, unsigned int len)
+{
+	unsigned int l;
+	int ret;
+	unsigned int off;
+
+	len /= esize;
+	l = in - out;
+	if (len > l)
+		len = l;
+
+	off = out & (size - 1);
+
+	/* first get the data from out until the end of the queue */
+	l = min(len, size - off);
+	ret = copy_to_user(to, data + off * esize, l * esize);
+
+	if (unlikely(ret))
+		return l - roundup_diff(ret, esize);
+
+	if (l == len)
+		return len;
+
+	/* then get the rest (if any) from the beginning of the queue */
+	ret = copy_to_user(to + l * esize, data, (len - l) * esize);
+
+	if (unlikely(ret))
+		return len - roundup_diff(ret, esize);
+
+	return len;
+}
+
+extern unsigned int __kqueue_dma_in_prepare(void *data, unsigned int size,
+		unsigned int in, unsigned int out, size_t esize,
+		struct scatterlist *sgl, int nents)
+{
+	unsigned int	len;
+	unsigned int	l;
+	unsigned int	off;
+
+	if (!nents)
+		BUG();
+
+	len = size - (in - out);
+
+	if (!len)
+		return 0;
+
+	off = in & (size - 1);
+
+	l = min(len, size - off);
+	if (l != len) {
+		if (nents > 1) {
+			sg_set_buf(sgl, data + off * esize, l * esize);
+			sgl++;
+
+			off = 0;
+			l = len - l;
+		} else
+			len = l;
+	}
+	sg_set_buf(sgl, data + off * esize, l * esize);
+	sg_mark_end(sgl);
+
+	return len * esize;
+}
+
+unsigned int __kqueue_dma_out_prepare(void *data, unsigned int size,
+		unsigned int in, unsigned int out, size_t esize,
+		struct scatterlist *sgl, int nents, unsigned int len)
+{
+	unsigned int	l;
+	unsigned int	off;
+
+	if (!nents)
+		BUG();
+
+	l = in - out;
+	if (!len || len > l)
+		len = l;
+
+	if (!len)
+		return 0;
+
+	off = out & (size - 1);
+
+	l = min(len, size - off);
+	if (l != len) {
+		if (nents > 1) {
+			sg_set_buf(sgl, data + off * esize, l * esize);
+			sgl++;
+
+			off = 0;
+			l = len - l;
+		} else
+			len = l;
+	}
+
+	sg_set_buf(sgl, data + off * esize, l * esize);
+	sg_mark_end(sgl);
+
+	return len * esize;
+}
+
diff -u -N -r orig/kernel/Makefile new/kernel/Makefile
--- orig/kernel/Makefile	2009-12-13 10:30:08.458935516 +0100
+++ new/kernel/Makefile	2009-12-13 10:32:01.131857662 +0100
@@ -6,7 +6,7 @@
 	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
-	    rcupdate.o extable.o params.o posix-timers.o \
+	    rcupdate.o extable.o params.o posix-timers.o kqueue.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \


