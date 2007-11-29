Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbXK2LKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbXK2LKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 06:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXK2LKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:10:33 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48681 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752096AbXK2LKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:10:32 -0500
To: a.p.zijlstra@chello.nl
CC: fengguang.wu@gmail.com, linux-kernel@vger.kernel.org
Subject: [patch 1/3] bdi patches
Message-Id: <E1IxhHk-00017y-Vp@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Nov 2007 12:10:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> http://programming.kicks-ass.net/kernel-patches/foo/
> 
> bdi-task-dirty.patch
> bdi-sysfs.patch
> bdi-min.patch
> bdi-max.patch
> 
> 
> Is my current rather experimental stack, I just wrote the max part after
> having slept on it. I'm not fond of the multiplication there, but I
> dno't see a way around it.
> 
> Compile tested only.

I've done some testing on these patches and did some changes. So here
they go.

Thanks,
Miklos

---------
Subject: mm: sysfs: expose the BDI object in sysfs

Provide a place in sysfs for the backing_dev_info object.
This allows us to see and set the various BDI specific variables.

In particular this properly exposes the read-ahead window for all
relevant users and /sys/block/<block>/queue/read_ahead_kb should be
deprecated.

With patient help from Kay Sievers and Greg KH

[mszeredi@suse.cz]
Fix fuse: move allocation of the connection ID before the bdi_init_fmt() call.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

Index: linux/block/genhd.c
===================================================================
--- linux.orig/block/genhd.c	2007-11-22 14:13:20.000000000 +0100
+++ linux/block/genhd.c	2007-11-26 17:24:19.000000000 +0100
@@ -183,6 +183,8 @@ void add_disk(struct gendisk *disk)
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
+	bdi_register(&disk->queue->backing_dev_info, NULL,
+		"blk-%s", disk->disk_name);
 }
 
 EXPORT_SYMBOL(add_disk);
@@ -191,6 +193,7 @@ EXPORT_SYMBOL(del_gendisk);	/* in partit
 void unlink_gendisk(struct gendisk *disk)
 {
 	blk_unregister_queue(disk);
+	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
 			      disk->minors);
 }
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-11-22 14:13:21.000000000 +0100
+++ linux/fs/fuse/inode.c	2007-11-26 17:24:19.000000000 +0100
@@ -460,6 +460,12 @@ static int fuse_show_options(struct seq_
 	return 0;
 }
 
+static u64 conn_id(void)
+{
+	static u64 ctr = 1;
+	return ctr++;
+}
+
 static struct fuse_conn *new_conn(void)
 {
 	struct fuse_conn *fc;
@@ -480,7 +486,11 @@ static struct fuse_conn *new_conn(void)
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
-		err = bdi_init(&fc->bdi);
+		mutex_lock(&fuse_mutex);
+		fc->id = conn_id();
+		mutex_unlock(&fuse_mutex);
+		err = bdi_init_fmt(&fc->bdi, NULL,
+				"fuse-%llu", (unsigned long long)fc->id);
 		if (err) {
 			kfree(fc);
 			fc = NULL;
@@ -590,12 +600,6 @@ static void fuse_send_init(struct fuse_c
 	request_send_background(fc, req);
 }
 
-static u64 conn_id(void)
-{
-	static u64 ctr = 1;
-	return ctr++;
-}
-
 static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct fuse_conn *fc;
@@ -675,7 +679,6 @@ static int fuse_fill_super(struct super_
 	if (file->private_data)
 		goto err_unlock;
 
-	fc->id = conn_id();
 	err = fuse_ctl_add_conn(fc);
 	if (err)
 		goto err_unlock;
Index: linux/fs/nfs/client.c
===================================================================
--- linux.orig/fs/nfs/client.c	2007-11-22 14:13:21.000000000 +0100
+++ linux/fs/nfs/client.c	2007-11-26 17:24:19.000000000 +0100
@@ -658,7 +658,8 @@ static void nfs_server_set_fsinfo(struct
 /*
  * Probe filesystem information, including the FSID on v2/v3
  */
-static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh, struct nfs_fattr *fattr)
+static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh,
+		struct nfs_fattr *fattr, const char *dev_name)
 {
 	struct nfs_fsinfo fsinfo;
 	struct nfs_client *clp = server->nfs_client;
@@ -679,7 +680,15 @@ static int nfs_probe_fsinfo(struct nfs_s
 		goto out_error;
 
 	nfs_server_set_fsinfo(server, &fsinfo);
+#if 0
+	/*
+	 * sysfs is broken in that it doesn't allow names > 20 chars
+	 * and this format will easily generate in excess of that.
+	 */
+	error = bdi_init_fmt(&server->backing_dev_info, NULL, "nfs-%s", dev_name);
+#else
 	error = bdi_init(&server->backing_dev_info);
+#endif
 	if (error)
 		goto out_error;
 
@@ -776,7 +785,7 @@ void nfs_free_server(struct nfs_server *
  * - keyed on server and FSID
  */
 struct nfs_server *nfs_create_server(const struct nfs_parsed_mount_data *data,
-				     struct nfs_fh *mntfh)
+				     struct nfs_fh *mntfh, const char *dev_name)
 {
 	struct nfs_server *server;
 	struct nfs_fattr fattr;
@@ -796,7 +805,7 @@ struct nfs_server *nfs_create_server(con
 	BUG_ON(!server->nfs_client->rpc_ops->file_inode_ops);
 
 	/* Probe the root fh to retrieve its FSID */
-	error = nfs_probe_fsinfo(server, mntfh, &fattr);
+	error = nfs_probe_fsinfo(server, mntfh, &fattr, dev_name);
 	if (error < 0)
 		goto error;
 	if (server->nfs_client->rpc_ops->version == 3) {
@@ -953,7 +962,7 @@ static int nfs4_init_server(struct nfs_s
  * - keyed on server and FSID
  */
 struct nfs_server *nfs4_create_server(const struct nfs_parsed_mount_data *data,
-				      struct nfs_fh *mntfh)
+				      struct nfs_fh *mntfh, const char *dev_name)
 {
 	struct nfs_fattr fattr;
 	struct nfs_server *server;
@@ -995,7 +1004,7 @@ struct nfs_server *nfs4_create_server(co
 		(unsigned long long) server->fsid.minor);
 	dprintk("Mount FH: %d\n", mntfh->size);
 
-	error = nfs_probe_fsinfo(server, mntfh, &fattr);
+	error = nfs_probe_fsinfo(server, mntfh, &fattr, dev_name);
 	if (error < 0)
 		goto error;
 
@@ -1025,7 +1034,8 @@ error:
  * Create an NFS4 referral server record
  */
 struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
-					       struct nfs_fh *mntfh)
+					       struct nfs_fh *mntfh,
+					       const char *dev_name)
 {
 	struct nfs_client *parent_client;
 	struct nfs_server *server, *parent_server;
@@ -1070,7 +1080,7 @@ struct nfs_server *nfs4_create_referral_
 		goto error;
 
 	/* probe the filesystem info for this server filesystem */
-	error = nfs_probe_fsinfo(server, mntfh, &fattr);
+	error = nfs_probe_fsinfo(server, mntfh, &fattr, dev_name);
 	if (error < 0)
 		goto error;
 
@@ -1104,7 +1114,8 @@ error:
  */
 struct nfs_server *nfs_clone_server(struct nfs_server *source,
 				    struct nfs_fh *fh,
-				    struct nfs_fattr *fattr)
+				    struct nfs_fattr *fattr,
+				    const char *dev_name)
 {
 	struct nfs_server *server;
 	struct nfs_fattr fattr_fsinfo;
@@ -1132,7 +1143,7 @@ struct nfs_server *nfs_clone_server(stru
 		nfs_init_server_aclclient(server);
 
 	/* probe the filesystem info for this server filesystem */
-	error = nfs_probe_fsinfo(server, fh, &fattr_fsinfo);
+	error = nfs_probe_fsinfo(server, fh, &fattr_fsinfo, dev_name);
 	if (error < 0)
 		goto out_free_server;
 
Index: linux/include/linux/backing-dev.h
===================================================================
--- linux.orig/include/linux/backing-dev.h	2007-11-22 14:13:03.000000000 +0100
+++ linux/include/linux/backing-dev.h	2007-11-26 17:24:19.000000000 +0100
@@ -11,6 +11,8 @@
 #include <linux/percpu_counter.h>
 #include <linux/log2.h>
 #include <linux/proportions.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -48,11 +50,28 @@ struct backing_dev_info {
 
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
+
+	struct device *dev;
 };
 
 int bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
+int bdi_register(struct backing_dev_info *bdi, struct device *parent,
+		const char *fmt, ...);
+void bdi_unregister(struct backing_dev_info *bdi);
+
+#define bdi_init_fmt(bdi, parent, fmt...)			\
+	({							\
+	 	int ret = bdi_init(bdi);			\
+	 	if (!ret) {					\
+	 		ret = bdi_register(bdi, parent, ##fmt);	\
+	 		if (ret)				\
+	 			bdi_destroy(bdi);		\
+	 	}						\
+	 	ret;						\
+	 })
+
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item, s64 amount)
 {
Index: linux/include/linux/writeback.h
===================================================================
--- linux.orig/include/linux/writeback.h	2007-11-22 14:13:21.000000000 +0100
+++ linux/include/linux/writeback.h	2007-11-26 17:24:19.000000000 +0100
@@ -113,6 +113,9 @@ struct file;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int, struct file *,
 				      void __user *, size_t *, loff_t *);
 
+void get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
+		 struct backing_dev_info *bdi);
+
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 					unsigned long nr_pages_dirtied);
Index: linux/mm/backing-dev.c
===================================================================
--- linux.orig/mm/backing-dev.c	2007-11-22 14:13:03.000000000 +0100
+++ linux/mm/backing-dev.c	2007-11-26 17:24:19.000000000 +0100
@@ -4,12 +4,119 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/writeback.h>
+#include <linux/device.h>
+
+
+static struct class *bdi_class;
+
+static ssize_t read_ahead_kb_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	char *end;
+
+	bdi->ra_pages = simple_strtoul(buf, &end, 10) >> (PAGE_SHIFT - 10);
+
+	return end - buf;
+}
+
+#define K(pages) ((pages) << (PAGE_SHIFT - 10))
+
+#define BDI_SHOW(name, expr)						\
+static ssize_t name##_show(struct device *dev,				\
+			   struct device_attribute *attr, char *page)	\
+{									\
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);		\
+									\
+	return snprintf(page, PAGE_SIZE-1, "%lld\n", (long long)expr);	\
+}
+
+BDI_SHOW(read_ahead_kb, K(bdi->ra_pages))
+
+BDI_SHOW(reclaimable_kb, K(bdi_stat(bdi, BDI_RECLAIMABLE)))
+BDI_SHOW(writeback_kb, K(bdi_stat(bdi, BDI_WRITEBACK)))
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
+BDI_SHOW(dirty_kb, K(get_dirty(bdi, 1)))
+BDI_SHOW(bdi_dirty_kb, K(get_dirty(bdi, 2)))
+
+#define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
+
+static struct device_attribute bdi_dev_attrs[] = {
+	__ATTR_RW(read_ahead_kb),
+	__ATTR_RO(reclaimable_kb),
+	__ATTR_RO(writeback_kb),
+	__ATTR_RO(dirty_kb),
+	__ATTR_RO(bdi_dirty_kb),
+	__ATTR_NULL,
+};
+
+static __init int bdi_class_init(void)
+{
+	bdi_class = class_create(THIS_MODULE, "bdi");
+	bdi_class->dev_attrs = bdi_dev_attrs;
+	return 0;
+}
+
+__initcall(bdi_class_init);
+
+int bdi_register(struct backing_dev_info *bdi, struct device *parent,
+		const char *fmt, ...)
+{
+	char *name;
+	va_list args;
+	int ret = 0;
+	struct device *dev;
+
+	va_start(args, fmt);
+	name = kvasprintf(GFP_KERNEL, fmt, args);
+	va_end(args);
+
+	if (!name)
+		return -ENOMEM;
+
+	dev = device_create(bdi_class, parent, MKDEV(0,0), name);
+	if (IS_ERR(dev)) {
+		ret = PTR_ERR(dev);
+		goto exit;
+	}
+
+	bdi->dev = dev;
+	dev_set_drvdata(bdi->dev, bdi);
+
+exit:
+	kfree(name);
+	return ret;
+}
+
+void bdi_unregister(struct backing_dev_info *bdi)
+{
+	if (bdi->dev) {
+		device_unregister(bdi->dev);
+		bdi->dev = NULL;
+	}
+}
+
+EXPORT_SYMBOL(bdi_register);
+EXPORT_SYMBOL(bdi_unregister);
 
 int bdi_init(struct backing_dev_info *bdi)
 {
 	int i, j;
 	int err;
 
+	bdi->dev = NULL;
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
 		if (err)
@@ -33,6 +140,8 @@ void bdi_destroy(struct backing_dev_info
 {
 	int i;
 
+	bdi_unregister(bdi);
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_destroy(&bdi->bdi_stat[i]);
 
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2007-11-26 17:24:04.000000000 +0100
+++ linux/mm/page-writeback.c	2007-11-26 17:24:19.000000000 +0100
@@ -295,7 +295,7 @@ static unsigned long determine_dirtyable
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-static void
+void
 get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 		 struct backing_dev_info *bdi)
 {
Index: linux/lib/percpu_counter.c
===================================================================
--- linux.orig/lib/percpu_counter.c	2007-11-22 14:13:03.000000000 +0100
+++ linux/lib/percpu_counter.c	2007-11-26 17:24:19.000000000 +0100
@@ -102,6 +102,7 @@ void percpu_counter_destroy(struct percp
 		return;
 
 	free_percpu(fbc->counters);
+	fbc->counters = NULL;
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_del(&fbc->list);
Index: linux/fs/nfs/internal.h
===================================================================
--- linux.orig/fs/nfs/internal.h	2007-11-22 14:13:21.000000000 +0100
+++ linux/fs/nfs/internal.h	2007-11-26 17:24:19.000000000 +0100
@@ -65,16 +65,18 @@ extern void nfs_put_client(struct nfs_cl
 extern struct nfs_client *nfs_find_client(const struct sockaddr_in *, int);
 extern struct nfs_server *nfs_create_server(
 					const struct nfs_parsed_mount_data *,
-					struct nfs_fh *);
+					struct nfs_fh *, const char *);
 extern struct nfs_server *nfs4_create_server(
 					const struct nfs_parsed_mount_data *,
-					struct nfs_fh *);
+					struct nfs_fh *, const char *);
 extern struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *,
-						      struct nfs_fh *);
+						      struct nfs_fh *,
+						      const char *);
 extern void nfs_free_server(struct nfs_server *server);
 extern struct nfs_server *nfs_clone_server(struct nfs_server *,
 					   struct nfs_fh *,
-					   struct nfs_fattr *);
+					   struct nfs_fattr *,
+					   const char *);
 #ifdef CONFIG_PROC_FS
 extern int __init nfs_fs_proc_init(void);
 extern void nfs_fs_proc_exit(void);
Index: linux/fs/nfs/super.c
===================================================================
--- linux.orig/fs/nfs/super.c	2007-11-22 14:13:21.000000000 +0100
+++ linux/fs/nfs/super.c	2007-11-26 17:24:19.000000000 +0100
@@ -1383,7 +1383,7 @@ static int nfs_get_sb(struct file_system
 		goto out;
 
 	/* Get a volume representation */
-	server = nfs_create_server(&data, &mntfh);
+	server = nfs_create_server(&data, &mntfh, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out;
@@ -1466,7 +1466,7 @@ static int nfs_xdev_get_sb(struct file_s
 	dprintk("--> nfs_xdev_get_sb()\n");
 
 	/* create a new volume representation */
-	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr);
+	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out_err_noserver;
@@ -1726,7 +1726,7 @@ static int nfs4_get_sb(struct file_syste
 		goto out;
 
 	/* Get a volume representation */
-	server = nfs4_create_server(&data, &mntfh);
+	server = nfs4_create_server(&data, &mntfh, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out;
@@ -1811,7 +1811,7 @@ static int nfs4_xdev_get_sb(struct file_
 	dprintk("--> nfs4_xdev_get_sb()\n");
 
 	/* create a new volume representation */
-	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr);
+	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out_err_noserver;
@@ -1885,7 +1885,7 @@ static int nfs4_referral_get_sb(struct f
 	dprintk("--> nfs4_referral_get_sb()\n");
 
 	/* create a new volume representation */
-	server = nfs4_create_referral_server(data, &mntfh);
+	server = nfs4_create_referral_server(data, &mntfh, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out_err_noserver;
Index: linux/mm/readahead.c
===================================================================
--- linux.orig/mm/readahead.c	2007-11-22 14:13:03.000000000 +0100
+++ linux/mm/readahead.c	2007-11-26 17:24:19.000000000 +0100
@@ -235,7 +235,7 @@ unsigned long max_sane_readahead(unsigne
 
 static int __init readahead_init(void)
 {
-	return bdi_init(&default_backing_dev_info);
+	return bdi_init_fmt(&default_backing_dev_info, NULL, "default");
 }
 subsys_initcall(readahead_init);
 
