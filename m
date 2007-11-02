Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbXKBO7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbXKBO7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 10:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbXKBO7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 10:59:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33304 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbXKBO7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 10:59:34 -0400
Subject: [PATCH] mm: sysfs: expose the BDI object in sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1194013979.2440.20.camel@lov.site>
References: <1193410087.6914.34.camel@twins>
	 <1193412836.27652.11.camel@twins> <1193414147.2431.35.camel@lov.site>
	 <1193429066.5648.35.camel@lappy> <1193447889.5648.44.camel@lappy>
	 <20071027024033.GB29039@kroah.com> <1193474399.27652.15.camel@twins>
	 <20071027160203.GA5709@kroah.com> <1193519317.5776.14.camel@lov.site>
	 <1194009359.27652.377.camel@twins>
	 <3ae72650711020650l37870e45yb853f888b4807116@mail.gmail.com>
	 <1194013028.27652.387.camel@twins>  <1194013979.2440.20.camel@lov.site>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 15:59:24 +0100
Message-Id: <1194015564.27652.403.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 15:32 +0100, Kay Sievers wrote:
> On Fri, 2007-11-02 at 15:17 +0100, Peter Zijlstra wrote:
> > One more question,
> > 
> > I currently prefix the names with "bdi-", is that needed?
> 
> Not really.

Thanks.

Here is the 'pretty' patch :-)

Since it relies on the removal of the device name length limit, this
should not yet be applied.

---
Subject: mm: sysfs: expose the BDI object in sysfs

Provide a place in sysfs for the backing_dev_info object.
This allows us to see and set the various BDI specific variables.

In particular this properly exposes the read-ahead window for all
relevant users and /sys/block/<block>/queue/read_ahead_kb should be
deprecated.

With patient help from Kay Sievers and Greg KH

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 block/genhd.c               |    3 +
 fs/fuse/inode.c             |    3 -
 fs/nfs/client.c             |   24 +++++----
 fs/nfs/internal.h           |   10 ++--
 fs/nfs/super.c              |   10 ++--
 include/linux/backing-dev.h |   19 +++++++
 include/linux/writeback.h   |    3 +
 lib/percpu_counter.c        |    1 
 mm/backing-dev.c            |  109 ++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c         |    2 
 10 files changed, 163 insertions(+), 21 deletions(-)

Index: linux-2.6-2/block/genhd.c
===================================================================
--- linux-2.6-2.orig/block/genhd.c
+++ linux-2.6-2/block/genhd.c
@@ -182,6 +182,8 @@ void add_disk(struct gendisk *disk)
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
+	bdi_register(&disk->queue->backing_dev_info, NULL,
+		"%s", disk->disk_name);
 }
 
 EXPORT_SYMBOL(add_disk);
@@ -190,6 +192,7 @@ EXPORT_SYMBOL(del_gendisk);	/* in partit
 void unlink_gendisk(struct gendisk *disk)
 {
 	blk_unregister_queue(disk);
+	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
 			      disk->minors);
 }
Index: linux-2.6-2/fs/fuse/inode.c
===================================================================
--- linux-2.6-2.orig/fs/fuse/inode.c
+++ linux-2.6-2/fs/fuse/inode.c
@@ -467,7 +467,8 @@ static struct fuse_conn *new_conn(void)
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
-		err = bdi_init(&fc->bdi);
+		err = bdi_init_fmt(&fc->bdi, NULL,
+				"fuse-%llu", (unsigned long long)fc->id);
 		if (err) {
 			kfree(fc);
 			fc = NULL;
Index: linux-2.6-2/fs/nfs/client.c
===================================================================
--- linux-2.6-2.orig/fs/nfs/client.c
+++ linux-2.6-2/fs/nfs/client.c
@@ -657,7 +657,8 @@ static void nfs_server_set_fsinfo(struct
 /*
  * Probe filesystem information, including the FSID on v2/v3
  */
-static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh, struct nfs_fattr *fattr)
+static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh,
+		struct nfs_fattr *fattr, const char *dev_name)
 {
 	struct nfs_fsinfo fsinfo;
 	struct nfs_client *clp = server->nfs_client;
@@ -678,7 +679,8 @@ static int nfs_probe_fsinfo(struct nfs_s
 		goto out_error;
 
 	nfs_server_set_fsinfo(server, &fsinfo);
-	error = bdi_init(&server->backing_dev_info);
+	error = bdi_init_fmt(&server->backing_dev_info, NULL,
+			     "nfs-%s", dev_name);
 	if (error)
 		goto out_error;
 
@@ -772,7 +774,7 @@ void nfs_free_server(struct nfs_server *
  * - keyed on server and FSID
  */
 struct nfs_server *nfs_create_server(const struct nfs_parsed_mount_data *data,
-				     struct nfs_fh *mntfh)
+				     struct nfs_fh *mntfh, const char *dev_name)
 {
 	struct nfs_server *server;
 	struct nfs_fattr fattr;
@@ -792,7 +794,7 @@ struct nfs_server *nfs_create_server(con
 	BUG_ON(!server->nfs_client->rpc_ops->file_inode_ops);
 
 	/* Probe the root fh to retrieve its FSID */
-	error = nfs_probe_fsinfo(server, mntfh, &fattr);
+	error = nfs_probe_fsinfo(server, mntfh, &fattr, dev_name);
 	if (error < 0)
 		goto error;
 	if (server->nfs_client->rpc_ops->version == 3) {
@@ -949,7 +951,7 @@ static int nfs4_init_server(struct nfs_s
  * - keyed on server and FSID
  */
 struct nfs_server *nfs4_create_server(const struct nfs_parsed_mount_data *data,
-				      struct nfs_fh *mntfh)
+				      struct nfs_fh *mntfh, const char *dev_name)
 {
 	struct nfs_fattr fattr;
 	struct nfs_server *server;
@@ -991,7 +993,7 @@ struct nfs_server *nfs4_create_server(co
 		(unsigned long long) server->fsid.minor);
 	dprintk("Mount FH: %d\n", mntfh->size);
 
-	error = nfs_probe_fsinfo(server, mntfh, &fattr);
+	error = nfs_probe_fsinfo(server, mntfh, &fattr, dev_name);
 	if (error < 0)
 		goto error;
 
@@ -1021,7 +1023,8 @@ error:
  * Create an NFS4 referral server record
  */
 struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
-					       struct nfs_fh *mntfh)
+					       struct nfs_fh *mntfh,
+					       const char *dev_name)
 {
 	struct nfs_client *parent_client;
 	struct nfs_server *server, *parent_server;
@@ -1066,7 +1069,7 @@ struct nfs_server *nfs4_create_referral_
 		goto error;
 
 	/* probe the filesystem info for this server filesystem */
-	error = nfs_probe_fsinfo(server, mntfh, &fattr);
+	error = nfs_probe_fsinfo(server, mntfh, &fattr, dev_name);
 	if (error < 0)
 		goto error;
 
@@ -1100,7 +1103,8 @@ error:
  */
 struct nfs_server *nfs_clone_server(struct nfs_server *source,
 				    struct nfs_fh *fh,
-				    struct nfs_fattr *fattr)
+				    struct nfs_fattr *fattr,
+				    const char *dev_name)
 {
 	struct nfs_server *server;
 	struct nfs_fattr fattr_fsinfo;
@@ -1128,7 +1132,7 @@ struct nfs_server *nfs_clone_server(stru
 		nfs_init_server_aclclient(server);
 
 	/* probe the filesystem info for this server filesystem */
-	error = nfs_probe_fsinfo(server, fh, &fattr_fsinfo);
+	error = nfs_probe_fsinfo(server, fh, &fattr_fsinfo, dev_name);
 	if (error < 0)
 		goto out_free_server;
 
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
Index: linux-2.6-2/lib/percpu_counter.c
===================================================================
--- linux-2.6-2.orig/lib/percpu_counter.c
+++ linux-2.6-2/lib/percpu_counter.c
@@ -102,6 +102,7 @@ void percpu_counter_destroy(struct percp
 		return;
 
 	free_percpu(fbc->counters);
+	fbc->counters = NULL;
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_del(&fbc->list);
Index: linux-2.6-2/fs/nfs/internal.h
===================================================================
--- linux-2.6-2.orig/fs/nfs/internal.h
+++ linux-2.6-2/fs/nfs/internal.h
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
Index: linux-2.6-2/fs/nfs/super.c
===================================================================
--- linux-2.6-2.orig/fs/nfs/super.c
+++ linux-2.6-2/fs/nfs/super.c
@@ -1359,7 +1359,7 @@ static int nfs_get_sb(struct file_system
 		goto out;
 
 	/* Get a volume representation */
-	server = nfs_create_server(&data, &mntfh);
+	server = nfs_create_server(&data, &mntfh, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out;
@@ -1442,7 +1442,7 @@ static int nfs_xdev_get_sb(struct file_s
 	dprintk("--> nfs_xdev_get_sb()\n");
 
 	/* create a new volume representation */
-	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr);
+	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out_err_noserver;
@@ -1702,7 +1702,7 @@ static int nfs4_get_sb(struct file_syste
 		goto out;
 
 	/* Get a volume representation */
-	server = nfs4_create_server(&data, &mntfh);
+	server = nfs4_create_server(&data, &mntfh, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out;
@@ -1787,7 +1787,7 @@ static int nfs4_xdev_get_sb(struct file_
 	dprintk("--> nfs4_xdev_get_sb()\n");
 
 	/* create a new volume representation */
-	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr);
+	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out_err_noserver;
@@ -1861,7 +1861,7 @@ static int nfs4_referral_get_sb(struct f
 	dprintk("--> nfs4_referral_get_sb()\n");
 
 	/* create a new volume representation */
-	server = nfs4_create_referral_server(data, &mntfh);
+	server = nfs4_create_referral_server(data, &mntfh, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out_err_noserver;


