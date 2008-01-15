Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbYAOQuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbYAOQuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYAOQt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:49:57 -0500
Received: from as1.cineca.com ([130.186.84.213]:46351 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYAOQtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:49:55 -0500
Message-ID: <478CE41F.5010401@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Valdis.Kletnieks@vt.edu,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] per-uid/gid I/O throttling (was Re: [RFC][PATCH] per-task
 I/O throttling)
References: <47869FFE.1050000@users.sourceforge.net> <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com> <47879A32.8060508@users.sourceforge.net> <3777.1200113861@turing-police.cc.vt.edu> <1200131197.7999.14.camel@lappy> <20080112105702.GC25388@balbir.in.ibm.com> <1200136245.7999.20.camel@lappy> <4789006C.2030804@users.sourceforge.net> <20080113044607.GA13633@balbir.in.ibm.com>
In-Reply-To: <20080113044607.GA13633@balbir.in.ibm.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Jan 2008 17:49:36 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to limit the I/O bandwidth for specific uid(s) or gid(s) imposing
additional delays on those processes that exceed the limits defined in a
configfs tree.

Examples:

Limit the I/O bandwidth for user www-data (UID 33) to 4MB/s:

root@linux:/config/io-throttle# mkdir uid:33
root@linux:/config/io-throttle# cd uid:33/
root@linux:/config/io-throttle/uid:33# cat io-rate
     io-rate: 0 KiB/sec
   requested: 0 KiB
last_request: 0 jiffies
       delta: 388202 jiffies
root@linux:/config/io-throttle/uid:33# echo 4096 > io-rate
root@linux:/config/io-throttle/uid:33# cat io-rate
     io-rate: 4096 KiB/sec
   requested: 0 KiB
last_request: 389271 jiffies
       delta: 91 jiffies

Limit the I/O bandwidth of group backup (GID 34) to 512KB/s:

root@linux:/config/io-throttle# mkdir gid:34
root@linux:/config/io-throttle# cd gid:34/
root@linux:/config/io-throttle/gid:34# cat io-rate
     io-rate: 0 KiB/sec
   requested: 0 KiB
last_request: 0 jiffies
       delta: 403160 jiffies
root@linux:/config/io-throttle/gid:34# echo 512 > io-rate
root@linux:/config/io-throttle/gid:34# cat io-rate
     io-rate: 512 KiB/sec
   requested: 0 KiB
last_request: 403618 jiffies
       delta: 80 jiffies

Remove the I/O limit for user www-data:

root@linux:/config/io-throttle# echo 0 > uid:33/io-rate
root@linux:/config/io-throttle# cat uid:33/io-rate
     io-rate: 0 KiB/sec
   requested: 0 KiB
last_request: 419009 jiffies
       delta: 568 jiffies

or:

root@linux:/config/io-throttle# rmdir uid:33

Future improvements:
* allow to limit also I/O operations per second (instead of KB/s only)
* extend grouping criteria (allow to define rules based on process containers,
  process command, etc.) 

Signed-off-by: Andrea Righi <a.righi@cineca.it>
---

diff -urpN linux-2.6.24-rc7/block/io-throttle.c linux-2.6.24-rc7-io-throttle/block/io-throttle.c
--- linux-2.6.24-rc7/block/io-throttle.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-rc7-io-throttle/block/io-throttle.c	2008-01-15 17:25:06.000000000 +0100
@@ -0,0 +1,282 @@
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
+ * Copyright (C) 2008 Andrea Righi <righiandr@users.sourceforge.net>
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/configfs.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/jiffies.h>
+#include <linux/io-throttle.h>
+
+/* This should work for any reasonable size of uid_t */
+#define MAXUIDCHAR (sizeof(uid_t) * 5 / 2)
+
+/*
+ * Basic structure that identifies a single I/O throttling rule
+ */
+struct iothrottle {
+	struct config_item item;
+	unsigned long iorate;
+	unsigned long req;
+	unsigned long last_request;
+};
+
+/* Get an I/O-throttling item from a configfs item */
+static inline struct iothrottle *to_iothrottle(struct config_item *item)
+{
+	return item ? container_of(item, struct iothrottle, item) : NULL;
+}
+
+static ssize_t iothrottle_attr_show(struct config_item *item,
+				    struct configfs_attribute *attr,
+				    char *page);
+static ssize_t iothrottle_attr_store(struct config_item *item,
+				     struct configfs_attribute *attr,
+				     const char *page, size_t count);
+static struct config_item *iothrottle_make_item(struct config_group *group,
+						const char *name);
+static void iothrottle_release(struct config_item *item);
+
+/* I/O throttling item in configfs (identify a single I/O throttling rule) */
+static struct configfs_attribute iothrottle_attr_iorate = {
+	.ca_owner = THIS_MODULE,
+	.ca_name = "io-rate",
+	.ca_mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH,
+};
+
+/* I/O throttling element in configfs */
+static struct configfs_group_operations iothrottle_group_ops = {
+	.make_item	= iothrottle_make_item,
+};
+
+static struct config_item_type iothrottle_group_type = {
+	.ct_group_ops	= &iothrottle_group_ops,
+};
+
+/* Entire I/O throttling subsystem under configfs (/config/io-throttle) */
+struct configfs_subsystem iothrottle_subsys = {
+	.su_group = {
+		.cg_item = {
+			.ci_namebuf = "io-throttle",
+			.ci_type = &iothrottle_group_type,
+		},
+	},
+};
+
+/* List of configfs elements per group */
+static struct configfs_attribute *iothrottle_attrs[] = {
+	&iothrottle_attr_iorate,
+	NULL,
+};
+
+static struct configfs_item_operations iothrottle_item_ops = {
+	.release		= iothrottle_release,
+	.show_attribute		= iothrottle_attr_show,
+	.store_attribute	= iothrottle_attr_store,
+};
+
+static struct config_item_type iothrottle_type = {
+	.ct_item_ops	= &iothrottle_item_ops,
+	.ct_attrs	= iothrottle_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
+/* Print a I/O throttling rule details */
+static ssize_t iothrottle_attr_show(struct config_item *item,
+				    struct configfs_attribute *attr,
+				    char *page)
+{
+	ssize_t count;
+	unsigned long delta;
+	struct iothrottle *iot = to_iothrottle(item);
+
+	delta = (long)jiffies - (long)iot->last_request;
+	/* Print additional debugging stuff */
+	count = sprintf(page, "     io-rate: %lu KiB/sec\n"
+			      "   requested: %lu KiB\n"
+			      "last_request: %lu jiffies\n"
+			      "       delta: %lu jiffies\n",
+			iot->iorate, iot->req << 1, iot->last_request, delta);
+
+	return count;
+}
+
+/* Configure the attributes of an I/O throttling rule */
+static ssize_t iothrottle_attr_store(struct config_item *item,
+				     struct configfs_attribute *attr,
+				     const char *page, size_t count)
+{
+	struct iothrottle *iot = to_iothrottle(item);
+	unsigned long tmp;
+	char *p = (char *) page;
+
+	tmp = simple_strtoul(p, &p, 10);
+	if (!p || (*p && (*p != '\n')))
+		return -EINVAL;
+
+	iot->iorate = tmp;
+	iot->req = 0;
+	iot->last_request = jiffies;
+
+	return count;
+}
+
+/* Register a new I/O throttling rule */
+static struct config_item *iothrottle_make_item(struct config_group *group,
+						const char *name)
+{
+	struct iothrottle *iot;
+
+	iot = kzalloc(sizeof(*iot), GFP_KERNEL);
+	if (unlikely(!iot))
+		return NULL;
+
+	iot->last_request = jiffies;
+
+	config_item_init_type_name(&iot->item, name, &iothrottle_type);
+
+	return &iot->item;
+}
+
+/* Unregister an I/O throttling rule */
+static void iothrottle_release(struct config_item *item)
+{
+	kfree(to_iothrottle(item));
+}
+
+/* Get the opportune "struct iothrottle" item from configfs if present */
+static inline struct iothrottle *iothrottle_get_config(void)
+{
+	char idstr[MAXUIDCHAR + 1];
+	struct iothrottle *p = NULL;
+
+	memset(idstr, 0, sizeof(idstr));
+
+	/* UID-based rule */
+	snprintf(idstr, MAXUIDCHAR, "uid:%u", current->uid);
+	p = to_iothrottle(
+		config_group_find_item(&iothrottle_subsys.su_group, idstr));
+	if (p)
+		goto out_get_config;
+
+	/* GID-based rule */
+	snprintf(idstr, MAXUIDCHAR, "gid:%u", current->gid);
+	p = to_iothrottle(
+		config_group_find_item(&iothrottle_subsys.su_group, idstr));
+
+out_get_config:
+	return p;
+}
+
+/*
+ * Here is the main function of the I/O throttling mechanism.
+ *
+ * FIXME: potential race if the struct iothrottle *iot item is removed/modified
+ * in the middle of the io_throttle() execution.
+ */
+void io_throttle(int nr_sectors)
+{
+	struct iothrottle *iot;
+	unsigned long delta, n;
+	long sleep;
+
+	iot = iothrottle_get_config();
+	if (!iot || !iot->iorate)
+		return;
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
+	n = iot->req += nr_sectors;
+	do_div(n, iot->iorate);
+
+	/*
+	 * Unable to evaluate delta (due to a too small interval of time
+	 * between two requests) or n (due to a too small request).
+	 *
+	 * Account the requested sectors in iot->req and sum them to the
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
+		printk(KERN_DEBUG
+		       "io-throttle: process %i (%s) must sleep %lu jiffies\n",
+		       task_pid_nr(current), current->comm, sleep);
+		schedule_timeout_uninterruptible(sleep);
+	}
+
+	/* OK, we stay under the limits. Reset statistics. */
+	iot->req = 0;
+	iot->last_request = jiffies;
+}
+EXPORT_SYMBOL(io_throttle);
+
+/* Register I/O throttling subsystem */
+static int __init iothrottle_init(void)
+{
+	int ret;
+
+	config_group_init(&iothrottle_subsys.su_group);
+	mutex_init(&iothrottle_subsys.su_mutex);
+	ret = configfs_register_subsystem(&iothrottle_subsys);
+	if (ret) {
+		printk(KERN_ERR "%s: error %d while registering subsystem\n",
+		       iothrottle_subsys.su_group.cg_item.ci_namebuf,
+		       ret);
+		goto out_unregister;
+	}
+
+	return 0;
+
+out_unregister:
+	configfs_unregister_subsystem(&iothrottle_subsys);
+
+	return ret;
+}
+
+/* Unregister I/O throttling subsystem */
+static void __exit iothrottle_exit(void)
+{
+	configfs_unregister_subsystem(&iothrottle_subsys);
+	mutex_destroy(&iothrottle_subsys.su_mutex);
+}
+
+module_init(iothrottle_init);
+module_exit(iothrottle_exit);
+MODULE_LICENSE("GPL");
diff -urpN linux-2.6.24-rc7/block/Kconfig linux-2.6.24-rc7-io-throttle/block/Kconfig
--- linux-2.6.24-rc7/block/Kconfig	2008-01-06 22:45:38.000000000 +0100
+++ linux-2.6.24-rc7-io-throttle/block/Kconfig	2008-01-15 15:30:21.000000000 +0100
@@ -40,6 +40,16 @@ config BLK_DEV_IO_TRACE
 
 	  git://brick.kernel.dk/data/git/blktrace.git
 
+config IO_THROTTLE
+        tristate "Enable I/O throttling (EXPERIMENTAL)"
+        depends on EXPERIMENTAL
+        select CONFIGFS_FS
+        help
+	  This allows to limit the maximum I/O rate for specific UID(s) or
+	  GID(s).
+
+          Say N if unsure.
+
 config LSF
 	bool "Support for Large Single Files"
 	depends on !64BIT
diff -urpN linux-2.6.24-rc7/block/ll_rw_blk.c linux-2.6.24-rc7-io-throttle/block/ll_rw_blk.c
--- linux-2.6.24-rc7/block/ll_rw_blk.c	2008-01-06 22:45:38.000000000 +0100
+++ linux-2.6.24-rc7-io-throttle/block/ll_rw_blk.c	2008-01-15 13:59:21.000000000 +0100
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
diff -urpN linux-2.6.24-rc7/block/Makefile linux-2.6.24-rc7-io-throttle/block/Makefile
--- linux-2.6.24-rc7/block/Makefile	2008-01-06 22:45:38.000000000 +0100
+++ linux-2.6.24-rc7-io-throttle/block/Makefile	2008-01-15 13:59:21.000000000 +0100
@@ -12,3 +12,5 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
+
+obj-$(CONFIG_IO_THROTTLE)	+= io-throttle.o
diff -urpN linux-2.6.24-rc7/include/linux/io-throttle.h linux-2.6.24-rc7-io-throttle/include/linux/io-throttle.h
--- linux-2.6.24-rc7/include/linux/io-throttle.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-rc7-io-throttle/include/linux/io-throttle.h	2008-01-15 13:59:21.000000000 +0100
@@ -0,0 +1,10 @@
+#ifndef IO_THROTTLE_H
+#define IO_THROTTLE_H
+
+#ifdef CONFIG_IO_THROTTLE
+extern void io_throttle(int nr_sectors);
+#else
+static inline void io_throttle(int nr_sectors) { }
+#endif /* CONFIG_IO_THROTTLE */
+
+#endif
