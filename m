Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYATNp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYATNp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 08:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYATNps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 08:45:48 -0500
Received: from as1.cineca.com ([130.186.84.213]:39557 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbYATNpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:45:46 -0500
Message-ID: <4793507B.6040706@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: Andrea Righi <righiandr@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Naveen Gupta <ngupta@google.com>, Paul Menage <menage@google.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
References: <2846be6b0801181439o55dcff09ted2b8f817e7ba682@mail.gmail.com> <4791DC2C.9090405@users.sourceforge.net>
In-Reply-To: <4791DC2C.9090405@users.sourceforge.net>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Sun, 20 Jan 2008 14:45:32 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> Naveen Gupta wrote:
>>> Paul Menage wrote:
>>>> On Jan 18,  2008 7:36 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com>  wrote:
>>>>> On Fri, Jan 18, 2008 at 12:41:03PM +0100, Andrea Righi  wrote:
>>>>>> Allow to limit the  block I/O bandwidth for  specific process containers
>>>>>> (cgroups) imposing additional delays  on I/O requests for those processes
>>>>>> that exceed the  limits defined in the control group filesystem.
>>>>>>
>>>>>>  Example:
>>>>>>   # mkdir /dev/cgroup
>>>>>>   # mount -t cgroup -oio-throttle io-throttle /dev/cgroup
>>>>> Just a minor nit, can't we name it as io,  keeping in mind that other
>>>>> controllers are known as cpu and  memory?
>>>> Or maybe "blockio"?
>>> Agree, blockio seems better. Not all I/O is performed on  block devices
>>> and in this case we're  considering block devices only.
>> Here we want to rate limit in block layer, I would think I/O scheduler
>> is the place where we are in much better position to do this kind of
>> limiting.
>>
>> Also we are changing the behavior of application by adding sleeps to
>> it during request submission. Moreover, we will prevent requests from
>> being merged since we won't allow them to be submitted in this case.
>>
>> Since bulk of submission for writes is done in background kernel
>> threads and we throttle based on limits on current, we will end up
>> throttling these threads and not the actual processes submitting i/o.
> 
> Yep, that's true! This works for read operations only... at the very
> least, if I've understood well, we could throttle I/O reads in the
> submit_bio() path and write operations in __set_page_dirty(). But this
> would change the applications behavior, so probably the best approcah
> could be to just get I/O statistics from TASK_IO_ACCOUNTING stuff and
> implement task delays at the I/O scheduler layer...

OK, to better figure the concept I tried to put the I/O throttling
mechanism inside the simplest scheduler: noop. But this raises a new
problem: under certain conditions (typically with write requests) a
delay imposed on a I/O request of a process could impact on all the
other I/O requests of other processes, causing the whole system to hang
until the first request is completed, so it seem that we've to deal with
a classic priority inversion problem.

Obviously the problem doesn't occur if the limited cgroup performs read
operations only.

I'm posting the modified patch below only for discussion purposes, you
could test it if you want, but you've been warned that the whole system
could hang for certain amounts of time.

---
Allow to limit the block I/O bandwidth for specific process containers
(cgroups) imposing additional delays in the I/O scheduler on the requests made
by those processes that exceed the limits defined in the control group
filesystem.

Example:
  # mkdir /dev/cgroup
  # mount -t cgroup -oblockio blockio /dev/cgroup
  # cd /dev/cgroup
  # mkdir foo
  --> the cgroup foo has been created
  # /bin/echo $$ > foo/tasks
  # /bin/echo 1024 > foo/blockio.bandwidth
  # sh
  --> the subshell 'sh' is running in cgroup "foo" and it can use a maximum I/O
      bandwidth of 1MB/s.

NOTE: this works only with noop scheduler and, anyway, it's affected by
the priority inversion problem. 

Signed-off-by: Andrea Righi <a.righi@cineca.it>
---

diff -urpN linux-2.6.24-rc8/block/io-throttle.c linux-2.6.24-rc8-cgroup-io-throttling/block/io-throttle.c
--- linux-2.6.24-rc8/block/io-throttle.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/block/io-throttle.c	2008-01-20 13:54:04.000000000 +0100
@@ -0,0 +1,226 @@
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
+	count = sprintf(page, "bandwidth-max: %lu KiB/sec\n"
+			      "    requested: %lu bytes\n"
+			      " last request: %lu jiffies\n"
+			      "        delta: %lu jiffies\n",
+			      iorate, req, last_request, delta);
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
+	iot->req = 0;
+	iot->last_request = jiffies;
+	spin_unlock_irq(&iot->lock);
+
+out:
+	cgroup_unlock();
+	return ret;
+}
+
+static struct cftype files[] = {
+	{
+		.name = "bandwidth",
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
+	.name = "blockio",
+	.create = iothrottle_create,
+	.destroy = iothrottle_destroy,
+	.populate = iothrottle_populate,
+	.subsys_id = iothrottle_subsys_id,
+};
+
+void cgroup_io_account(size_t bytes)
+{
+	struct iothrottle *iot;
+
+	if (!bytes)
+		return;
+
+	iot = task_to_iothrottle(current);
+	if (!iot)
+		return;
+
+	if (!iot->iorate)
+		return;
+
+	iot->req += bytes;
+}
+EXPORT_SYMBOL(cgroup_io_account);
+
+int io_throttle(struct task_struct *task)
+{
+	struct iothrottle *iot;
+	unsigned long delta, t;
+	long sleep;
+
+	iot = task_to_iothrottle(task);
+	if (!iot)
+		return 0;
+
+	if (!iot->iorate)
+		return 0;
+
+	delta = (long)jiffies - (long)iot->last_request;
+	t = msecs_to_jiffies(iot->req / iot->iorate);
+	if (!t)
+		return 0;
+
+	sleep = t - delta;
+	if (sleep > 0)
+		return sleep;
+
+	iot->req = 0;
+	iot->last_request = jiffies;
+
+	return 0;
+}
+EXPORT_SYMBOL(io_throttle);
diff -urpN linux-2.6.24-rc8/block/ll_rw_blk.c linux-2.6.24-rc8-cgroup-io-throttling/block/ll_rw_blk.c
--- linux-2.6.24-rc8/block/ll_rw_blk.c	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/block/ll_rw_blk.c	2008-01-20 13:54:14.000000000 +0100
@@ -31,6 +31,7 @@
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
 #include <linux/scatterlist.h>
+#include <linux/io-throttle.h>
 
 /*
  * for max sense size
@@ -3368,6 +3369,7 @@ void submit_bio(int rw, struct bio *bio)
 			count_vm_events(PGPGOUT, count);
 		} else {
 			task_io_account_read(bio->bi_size);
+			cgroup_io_account(bio->bi_size);
 			count_vm_events(PGPGIN, count);
 		}
 
diff -urpN linux-2.6.24-rc8/block/Makefile linux-2.6.24-rc8-cgroup-io-throttling/block/Makefile
--- linux-2.6.24-rc8/block/Makefile	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/block/Makefile	2008-01-20 13:57:29.000000000 +0100
@@ -12,3 +12,5 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
+
+obj-$(CONFIG_CGROUP_IO_THROTTLE)	+= io-throttle.o
diff -urpN linux-2.6.24-rc8/block/noop-iosched.c linux-2.6.24-rc8-cgroup-io-throttling/block/noop-iosched.c
--- linux-2.6.24-rc8/block/noop-iosched.c	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/block/noop-iosched.c	2008-01-20 13:55:35.000000000 +0100
@@ -6,11 +6,27 @@
 #include <linux/bio.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/io-throttle.h>
+
+#define RQ_TASK(rq)      ((struct task_struct *) (rq)->elevator_private)
 
 struct noop_data {
 	struct list_head queue;
+	struct request_queue *q;
+	struct work_struct work;
 };
 
+static void noop_work_handler(struct work_struct *work)
+{
+	struct noop_data *nd = container_of(work, struct noop_data, work);
+	struct request_queue *q = nd->q;
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_start_queueing(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
 static void noop_merged_requests(struct request_queue *q, struct request *rq,
 				 struct request *next)
 {
@@ -20,10 +36,16 @@ static void noop_merged_requests(struct 
 static int noop_dispatch(struct request_queue *q, int force)
 {
 	struct noop_data *nd = q->elevator->elevator_data;
+	struct list_head *n, *tmp;
 
-	if (!list_empty(&nd->queue)) {
+	list_for_each_safe(n, tmp, &nd->queue) {
 		struct request *rq;
-		rq = list_entry(nd->queue.next, struct request, queuelist);
+		rq = list_entry(n, struct request, queuelist);
+		if (RQ_TASK(rq))
+			if (io_throttle(RQ_TASK(rq))) {
+				kblockd_schedule_work(&nd->work);
+				continue;
+			}
 		list_del_init(&rq->queuelist);
 		elv_dispatch_sort(q, rq);
 		return 1;
@@ -35,6 +57,7 @@ static void noop_add_request(struct requ
 {
 	struct noop_data *nd = q->elevator->elevator_data;
 
+	rq->elevator_private = current;
 	list_add_tail(&rq->queuelist, &nd->queue);
 }
 
@@ -72,6 +95,8 @@ static void *noop_init_queue(struct requ
 	nd = kmalloc_node(sizeof(*nd), GFP_KERNEL, q->node);
 	if (!nd)
 		return NULL;
+	nd->q = q;
+	INIT_WORK(&nd->work, noop_work_handler);
 	INIT_LIST_HEAD(&nd->queue);
 	return nd;
 }
@@ -81,6 +106,7 @@ static void noop_exit_queue(elevator_t *
 	struct noop_data *nd = e->elevator_data;
 
 	BUG_ON(!list_empty(&nd->queue));
+	kblockd_flush_work(&nd->work);
 	kfree(nd);
 }
 
diff -urpN linux-2.6.24-rc8/fs/buffer.c linux-2.6.24-rc8-cgroup-io-throttling/fs/buffer.c
--- linux-2.6.24-rc8/fs/buffer.c	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/fs/buffer.c	2008-01-20 13:55:44.000000000 +0100
@@ -41,6 +41,7 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
+#include <linux/io-throttle.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 
@@ -713,6 +714,7 @@ static int __set_page_dirty(struct page 
 			__inc_bdi_stat(mapping->backing_dev_info,
 					BDI_RECLAIMABLE);
 			task_io_account_write(PAGE_CACHE_SIZE);
+			cgroup_io_account(PAGE_CACHE_SIZE);
 		}
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
diff -urpN linux-2.6.24-rc8/fs/direct-io.c linux-2.6.24-rc8-cgroup-io-throttling/fs/direct-io.c
--- linux-2.6.24-rc8/fs/direct-io.c	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/fs/direct-io.c	2008-01-20 13:55:55.000000000 +0100
@@ -35,6 +35,7 @@
 #include <linux/buffer_head.h>
 #include <linux/rwsem.h>
 #include <linux/uio.h>
+#include <linux/io-throttle.h>
 #include <asm/atomic.h>
 
 /*
@@ -667,6 +668,7 @@ submit_page_section(struct dio *dio, str
 		 * Read accounting is performed in submit_bio()
 		 */
 		task_io_account_write(len);
+		cgroup_io_account(len);
 	}
 
 	/*
diff -urpN linux-2.6.24-rc8/include/linux/io-throttle.h linux-2.6.24-rc8-cgroup-io-throttling/include/linux/io-throttle.h
--- linux-2.6.24-rc8/include/linux/io-throttle.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/include/linux/io-throttle.h	2008-01-20 13:59:53.000000000 +0100
@@ -0,0 +1,12 @@
+#ifndef IO_THROTTLE_H
+#define IO_THROTTLE_H
+
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+extern int io_throttle(struct task_struct *task);
+extern void cgroup_io_account(size_t bytes);
+#else
+static inline int io_throttle(struct task_struct *task) { }
+static inline void cgroup_io_account(size_t bytes) { }
+#endif /* CONFIG_CGROUP_IO_THROTTLE */
+
+#endif
diff -urpN linux-2.6.24-rc8/init/Kconfig linux-2.6.24-rc8-cgroup-io-throttling/init/Kconfig
--- linux-2.6.24-rc8/init/Kconfig	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/init/Kconfig	2008-01-20 13:57:43.000000000 +0100
@@ -313,6 +313,16 @@ config CGROUP_NS
           for instance virtual servers and checkpoint/restart
           jobs.
 
+config CGROUP_IO_THROTTLE
+        bool "Enable cgroup I/O throttling (EXPERIMENTAL)"
+        depends on EXPERIMENTAL && CGROUPS
+	select TASK_IO_ACCOUNTING
+        help
+	  This allows to limit the maximum I/O bandwidth for specific
+	  cgroup(s).
+
+          Say N if unsure.
+
 config CPUSETS
 	bool "Cpuset support"
 	depends on SMP && CGROUPS
diff -urpN linux-2.6.24-rc8/mm/page-writeback.c linux-2.6.24-rc8-cgroup-io-throttling/mm/page-writeback.c
--- linux-2.6.24-rc8/mm/page-writeback.c	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/mm/page-writeback.c	2008-01-20 13:56:13.000000000 +0100
@@ -34,6 +34,7 @@
 #include <linux/syscalls.h>
 #include <linux/buffer_head.h>
 #include <linux/pagevec.h>
+#include <linux/io-throttle.h>
 
 /*
  * The maximum number of pages to writeout in a single bdflush/kupdate
@@ -1014,6 +1015,7 @@ int __set_page_dirty_nobuffers(struct pa
 				__inc_bdi_stat(mapping->backing_dev_info,
 						BDI_RECLAIMABLE);
 				task_io_account_write(PAGE_CACHE_SIZE);
+				cgroup_io_account(PAGE_CACHE_SIZE);
 			}
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
diff -urpN linux-2.6.24-rc8/mm/readahead.c linux-2.6.24-rc8-cgroup-io-throttling/mm/readahead.c
--- linux-2.6.24-rc8/mm/readahead.c	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-io-throttling/mm/readahead.c	2008-01-20 13:56:02.000000000 +0100
@@ -16,6 +16,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/pagevec.h>
 #include <linux/pagemap.h>
+#include <linux/io-throttle.h>
 
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
@@ -76,6 +77,7 @@ int read_cache_pages(struct address_spac
 			break;
 		}
 		task_io_account_read(PAGE_CACHE_SIZE);
+		cgroup_io_account(PAGE_CACHE_SIZE);
 	}
 	return ret;
 }

