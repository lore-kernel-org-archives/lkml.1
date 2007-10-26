Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXJZUF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXJZUF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXJZUFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:05:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46926 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbXJZUFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:05:14 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1193414147.2431.35.camel@lov.site>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
	 <200710022205.05295.nickpiggin@yahoo.com.au>
	 <1191406506.4093.35.camel@lov.localdomain>  <1191407872.5572.7.camel@lappy>
	 <1191418525.4093.87.camel@lov.localdomain> <1193410087.6914.34.camel@twins>
	 <1193411451.2431.13.camel@lov.site>  <1193412147.27652.2.camel@twins>
	 <1193412788.2431.22.camel@lov.site>  <1193412836.27652.11.camel@twins>
	 <1193414147.2431.35.camel@lov.site>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 22:04:25 +0200
Message-Id: <1193429066.5648.35.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This crashes and burns on bootup, but I'm too tired to figure out what I
did wrong... will give it another try tomorrow..


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 block/genhd.c               |    2 
 fs/fuse/inode.c             |    2 
 fs/nfs/client.c             |    2 
 include/linux/backing-dev.h |   33 ++++++++++++
 include/linux/writeback.h   |    3 +
 mm/backing-dev.c            |  121 ++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c         |    2 
 7 files changed, 162 insertions(+), 3 deletions(-)

Index: linux-2.6-2/fs/fuse/inode.c
===================================================================
--- linux-2.6-2.orig/fs/fuse/inode.c
+++ linux-2.6-2/fs/fuse/inode.c
@@ -467,7 +467,7 @@ static struct fuse_conn *new_conn(void)
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
-		err = bdi_init(&fc->bdi);
+		err = bdi_init_fmt(&fc->bdi, "fuse-%llu", (unsigned long long)fc->id);
 		if (err) {
 			kfree(fc);
 			fc = NULL;
Index: linux-2.6-2/fs/nfs/client.c
===================================================================
--- linux-2.6-2.orig/fs/nfs/client.c
+++ linux-2.6-2/fs/nfs/client.c
@@ -678,7 +678,7 @@ static int nfs_probe_fsinfo(struct nfs_s
 		goto out_error;
 
 	nfs_server_set_fsinfo(server, &fsinfo);
-	error = bdi_init(&server->backing_dev_info);
+	error = bdi_init_fmt(&server->backing_dev_info, "nfs-%s-%p", clp->cl_hostname, server);
 	if (error)
 		goto out_error;
 
Index: linux-2.6-2/include/linux/backing-dev.h
===================================================================
--- linux-2.6-2.orig/include/linux/backing-dev.h
+++ linux-2.6-2/include/linux/backing-dev.h
@@ -11,6 +11,8 @@
 #include <linux/percpu_counter.h>
 #include <linux/log2.h>
 #include <linux/proportions.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -48,11 +50,42 @@ struct backing_dev_info {
 
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
+
+#ifdef CONFIG_SYSFS
+	struct device kdev;
+#endif
 };
 
 int bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
+int __bdi_register(struct backing_dev_info *bdi);
+void bdi_unregister(struct backing_dev_info *bdi);
+
+#ifdef CONFIG_SYSFS
+#define bdi_init_fmt(bdi, fmt...)				\
+	({							\
+	 	int ret;					\
+		kobject_set_name(&(bdi)->kdev.kobj, ##fmt);	\
+		ret = bdi_init(bdi);				\
+		if (!ret) {					\
+			ret = __bdi_register(bdi);		\
+			if (ret)				\
+				bdi_destroy(bdi);		\
+		}						\
+		ret;						\
+	})
+
+#define bdi_register(bdi, fmt...)				\
+	({							\
+	 	kobject_set_name(&(bdi)->kdev.kobj, ##fmt);	\
+ 		__bdi_register(bdi);				\
+	})
+#else
+#define bdi_init_fmt(bdi, fmt...)	bdi_init(bdi)
+#define bdi_register(bdi, fmt...)	__bdi_register(bdi)
+#endif
+
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item, s64 amount)
 {
Index: linux-2.6-2/include/linux/writeback.h
===================================================================
--- linux-2.6-2.orig/include/linux/writeback.h
+++ linux-2.6-2/include/linux/writeback.h
@@ -113,6 +113,9 @@ struct file;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int, struct file *,
 				      void __user *, size_t *, loff_t *);
 
+void get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
+		 struct backing_dev_info *bdi);
+
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 					unsigned long nr_pages_dirtied);
Index: linux-2.6-2/mm/backing-dev.c
===================================================================
--- linux-2.6-2.orig/mm/backing-dev.c
+++ linux-2.6-2/mm/backing-dev.c
@@ -4,12 +4,130 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/writeback.h>
+#include <linux/device.h>
+
+#ifdef CONFIG_SYSFS
+
+static void bdi_release(struct device *dev)
+{
+}
+
+static int bdi_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	return 0;
+}
+
+static struct class bdi_class = {
+	.name = "bdi",
+	.dev_release = bdi_release,
+	.dev_uevent = bdi_uevent,
+};
+
+static ssize_t readahead_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi =
+		container_of(dev, struct backing_dev_info, kdev);
+	char *end;
+
+	bdi->ra_pages = simple_strtoul(buf, &end, 10);
+
+	return end - buf;
+}
+
+#define BDI_SHOW(name, expr)						\
+static ssize_t name##_show(struct device *dev,				\
+			   struct device_attribute *attr, char *page)	\
+{									\
+	struct backing_dev_info *bdi =					\
+		container_of(dev, struct backing_dev_info, kdev);	\
+									\
+	return snprintf(page, PAGE_SIZE-1, "%lld\n", (long long)expr);	\
+}
+
+BDI_SHOW(readahead, bdi->ra_pages)
+
+BDI_SHOW(reclaimable, bdi_stat(bdi, BDI_RECLAIMABLE))
+BDI_SHOW(writeback, bdi_stat(bdi, BDI_WRITEBACK))
+
+static inline unsigned long get_dirty(struct backing_dev_info *bdi, int i)
+{
+	unsigned long thresh[3];
+
+	get_dirty_limits(&thresh[0], &thresh[1], &thresh[2], bdi);
+
+	return thresh[i];
+}
+
+BDI_SHOW(dirty, get_dirty(bdi, 1))
+BDI_SHOW(bdi_dirty, get_dirty(bdi, 2))
+
+static struct device_attribute bdi_dev_attrs[] = {
+	__ATTR(readahead, 0644, readahead_show, readahead_store),
+	__ATTR_RO(reclaimable),
+	__ATTR_RO(writeback),
+	__ATTR_RO(dirty),
+	__ATTR_RO(bdi_dirty),
+	__ATTR_NULL,
+};
+
+static struct attribute *bdi_attributes[ARRAY_SIZE(bdi_dev_attrs) + 1];
+
+static struct attribute_group bdi_attribute_group = {
+	.attrs = bdi_attributes,
+};
+
+static struct attribute_group *bdi_attribute_groups[] = {
+	&bdi_attribute_group,
+	NULL,
+};
+
+static __init int bdi_class_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(bdi_dev_attrs); i++)
+		bdi_attributes[i] = &bdi_dev_attrs[i].attr;
+
+	return class_register(&bdi_class);
+}
+
+__initcall(bdi_class_init);
+
+int __bdi_register(struct backing_dev_info *bdi)
+{
+	bdi->kdev.class = &bdi_class;
+	bdi->kdev.groups = bdi_attribute_groups;
+	strcpy(bdi->kdev.bus_id, "bdi");
+	return device_register(&bdi->kdev);
+}
+
+void bdi_unregister(struct backing_dev_info *bdi)
+{
+	device_unregister(&bdi->kdev);
+}
+#else
+int __bdi_register(struct backing_dev_info *bdi)
+{
+	return 0;
+}
+
+void bdi_unregister(struct backing_dev_info *bdi)
+{
+}
+#endif
+
+EXPORT_SYMBOL(__bdi_register);
 
 int bdi_init(struct backing_dev_info *bdi)
 {
 	int i, j;
 	int err;
 
+	memset(bdi, 0, sizeof(*bdi));
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
 		if (err)
@@ -33,6 +151,8 @@ void bdi_destroy(struct backing_dev_info
 {
 	int i;
 
+	bdi_unregister(bdi);
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_destroy(&bdi->bdi_stat[i]);
 
@@ -90,3 +210,4 @@ long congestion_wait(int rw, long timeou
 }
 EXPORT_SYMBOL(congestion_wait);
 
+
Index: linux-2.6-2/mm/page-writeback.c
===================================================================
--- linux-2.6-2.orig/mm/page-writeback.c
+++ linux-2.6-2/mm/page-writeback.c
@@ -291,7 +291,7 @@ static unsigned long determine_dirtyable
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-static void
+void
 get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 		 struct backing_dev_info *bdi)
 {
Index: linux-2.6-2/block/genhd.c
===================================================================
--- linux-2.6-2.orig/block/genhd.c
+++ linux-2.6-2/block/genhd.c
@@ -182,6 +182,7 @@ void add_disk(struct gendisk *disk)
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
+	bdi_register(&disk->queue->backing_dev_info, "%s", disk->disk_name);
 }
 
 EXPORT_SYMBOL(add_disk);
@@ -190,6 +191,7 @@ EXPORT_SYMBOL(del_gendisk);	/* in partit
 void unlink_gendisk(struct gendisk *disk)
 {
 	blk_unregister_queue(disk);
+	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
 			      disk->minors);
 }


