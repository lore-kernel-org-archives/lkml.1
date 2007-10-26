Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbXJZOs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbXJZOs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXJZOsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:48:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34873 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbXJZOsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:48:17 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1191418525.4093.87.camel@lov.localdomain>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
	 <200710022205.05295.nickpiggin@yahoo.com.au>
	 <1191406506.4093.35.camel@lov.localdomain>  <1191407872.5572.7.camel@lappy>
	 <1191418525.4093.87.camel@lov.localdomain>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 16:48:07 +0200
Message-Id: <1193410087.6914.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-03 at 15:35 +0200, Kay Sievers wrote:
> On Wed, 2007-10-03 at 12:37 +0200, Peter Zijlstra wrote:
> > On Wed, 2007-10-03 at 12:15 +0200, Kay Sievers wrote:
> > > On Tue, 2007-10-02 at 22:05 +1000, Nick Piggin wrote:
> > > > On Tuesday 02 October 2007 21:40, Peter Zijlstra wrote:
> > > > > On Tue, 2007-10-02 at 13:21 +0200, Kay Sievers wrote:
> > > > 
> > > > > > How about adding this information to the tree then, instead of
> > > > > > creating a new top-level hack, just because something that you think
> > > > > > you need doesn't exist.
> > > > >
> > > > > So you suggest adding all the various network filesystems in there
> > > > > (where?), and adding the concept of a BDI, and ensuring all are properly
> > > > > linked together - somehow. Feel free to do so.
> > > > 
> > > > Would something fit better under /sys/fs/? At least filesystems are
> > > > already an existing concept to userspace.
> > > 
> > > Sounds at least less messy than an new top-level directory.
> > > 
> > > But again, if it's "device" releated, like the name suggests, it should
> > > be reachable from the device tree.
> > > Which userspace tool is supposed to set these values, and at what time?
> > > An init-script, something at device discovery/setup? If that is is ever
> > > going to be used in a hotplug setup, you really don't want to go look
> > > for directories with magic device names in another disconnected tree.
> > 
> > Filesystems don't really map to BDIs either. One can have multiple FSs
> > per BDI.
> > 
> > 'Normally' a BDI relates to a block device, but networked (and other
> > non-block device) filesystems have to create a BDI too. So these need to
> > be represented some place as well.
> > 
> > The typical usage would indeed be init scripts. The typical example
> > would be setting the read-ahead window. Currently that cannot be done
> > for NFS mounts.
> 
> What kind of context for a non-block based fs will get the bdi controls
> added? Is there a generic place, or does every non-block based
> filesystem needs to be adapted individually to use it?

---
Subject: bdi: debugfs interface

Expose the BDI stats (and readahead window) in /debug/bdi/

I'm still thinking it should go into /sys somewhere, however I just noticed
not all block devices that have a queue have a /queue directory. Noticeably
those that use make_request_fn() as opposed to request_fn(). And then of
course there are the non-block/non-queue BDIs.

A BDI is basically the object that represents the 'thing' you dirty pages
against. For block devices that is related to the block device (and is
typically embedded in the queue object), for NFS mounts its the remote server
object of the client. For FUSE, yet again something else.

I appreciate the sysfs people their opinion that /sys/bdi/ might not be the
best from their POV, however I'm not seeing where to hook the BDI object from
so that it all makes sense, a few of the things are currently not exposed in
sysfs at all, like the NFS and FUSE things.

So, for now, I've exposed the thing in debugfs. Please suggest a better
alternative.

Miklos, Trond: could you suggest a better fmt for the bdi_init_fmt() for your
respective filesystems?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Miklos Szeredi <miklos@szeredi.hu>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>
---
 block/genhd.c               |    2 
 block/ll_rw_blk.c           |    1 
 drivers/block/loop.c        |    7 ++
 drivers/md/dm.c             |    2 
 drivers/md/md.c             |    2 
 fs/fuse/inode.c             |    2 
 fs/nfs/client.c             |    2 
 include/linux/backing-dev.h |   15 ++++
 include/linux/debugfs.h     |   11 +++
 include/linux/writeback.h   |    3 
 mm/backing-dev.c            |  153 ++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c         |    2 
 12 files changed, 199 insertions(+), 3 deletions(-)

Index: linux-2.6-2/fs/fuse/inode.c
===================================================================
--- linux-2.6-2.orig/fs/fuse/inode.c
+++ linux-2.6-2/fs/fuse/inode.c
@@ -467,7 +467,7 @@ static struct fuse_conn *new_conn(void)
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
-		err = bdi_init(&fc->bdi);
+		err = bdi_init_fmt(&fc->bdi, "fuse-%p", fc);
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
@@ -11,6 +11,7 @@
 #include <linux/percpu_counter.h>
 #include <linux/log2.h>
 #include <linux/proportions.h>
+#include <linux/kernel.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -48,11 +49,25 @@ struct backing_dev_info {
 
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
+
+#ifdef CONFIG_DEBUG_FS
+	char *name;
+
+	struct dentry *debugfs_dir;
+	struct dentry *debugfs_ra;
+	struct dentry *debugfs_stat[NR_BDI_STAT_ITEMS];
+	struct dentry *debugfs_dirty;
+	struct dentry *debugfs_bdi_dirty;
+#endif
 };
 
 int bdi_init(struct backing_dev_info *bdi);
+int bdi_init_fmt(struct backing_dev_info *bdi, const char *fmt, ...);
 void bdi_destroy(struct backing_dev_info *bdi);
 
+int bdi_register(struct backing_dev_info *bdi, char *name);
+void bdi_unregister(struct backing_dev_info *bdi);
+
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item, s64 amount)
 {
Index: linux-2.6-2/include/linux/debugfs.h
===================================================================
--- linux-2.6-2.orig/include/linux/debugfs.h
+++ linux-2.6-2/include/linux/debugfs.h
@@ -165,4 +165,15 @@ static inline struct dentry *debugfs_cre
 
 #endif
 
+static inline struct dentry *debugfs_create_long(const char *name, mode_t mode,
+						 struct dentry *parent,
+						 unsigned long *value)
+{
+#if BITS_PER_LONG == 32
+	return debugfs_create_u32(name,mode, parent, (u32*)value);
+#else
+	return debugfs_create_u64(name,mode, parent, (u64*)value);
+#endif
+}
+
 #endif
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
@@ -4,12 +4,158 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/writeback.h>
+
+#ifdef CONFIG_DEBUG_FS
+
+static struct dentry *debugfs_dir;
+
+static __init int bdifs_init(void)
+{
+	debugfs_dir = debugfs_create_dir("bdi", NULL);
+	return 0;
+}
+
+__initcall(bdifs_init);
+
+static const char *stat_name[NR_BDI_STAT_ITEMS] = {
+	"reclaimable_pages",
+	"writeback_pages",
+};
+
+static u64 stat_get(void *data)
+{
+	return percpu_counter_read_positive((struct percpu_counter *)data);
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(stat_ops, stat_get, NULL, "%llu\n");
+
+static u64 dirty_get(void *data)
+{
+	struct backing_dev_info *bdi = data;
+	long background, dirty, bdi_dirty;
+
+	get_dirty_limits(&background, &dirty, &bdi_dirty, bdi);
+
+	return dirty;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(dirty_ops, dirty_get, NULL, "%llu\n");
+
+static u64 bdi_dirty_get(void *data)
+{
+	struct backing_dev_info *bdi = data;
+	long background, dirty, bdi_dirty;
+
+	get_dirty_limits(&background, &dirty, &bdi_dirty, bdi);
+
+	return bdi_dirty;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(bdi_dirty_ops, bdi_dirty_get, NULL, "%llu\n");
+
+int bdi_register(struct backing_dev_info *bdi, char *name)
+{
+	int i;
+
+	if (bdi->debugfs_dir)
+		return -EEXIST;
+
+	bdi->name = kstrdup(name, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+
+	bdi->debugfs_dir = debugfs_create_dir(bdi->name, debugfs_dir);
+	if (bdi->debugfs_dir) {
+		bdi->debugfs_ra = debugfs_create_long("readahead_pages", 0644,
+				bdi->debugfs_dir, &bdi->ra_pages);
+
+		for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
+			bdi->debugfs_stat[i] =
+				debugfs_create_file(stat_name[i],
+						0444, bdi->debugfs_dir,
+						&bdi->bdi_stat[i], &stat_ops);
+		}
+
+		bdi->debugfs_dirty =
+			debugfs_create_file("dirty_pages",
+					0444, bdi->debugfs_dir,
+					bdi, &dirty_ops);
+
+		bdi->debugfs_bdi_dirty =
+			debugfs_create_file("bdi_dirty_pages",
+					0444, bdi->debugfs_dir,
+					bdi, &bdi_dirty_ops);
+	} else
+		return -ENOMEM;
+
+	return 0;
+}
+
+void bdi_unregister(struct backing_dev_info *bdi)
+{
+	int i;
+
+	debugfs_remove(bdi->debugfs_bdi_dirty);
+	debugfs_remove(bdi->debugfs_dirty);
+	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
+		debugfs_remove(bdi->debugfs_stat[i]);
+	debugfs_remove(bdi->debugfs_ra);
+	debugfs_remove(bdi->debugfs_dir);
+
+	kfree(bdi->name);
+
+	bdi->debugfs_dir = NULL;
+}
+
+int bdi_init_fmt(struct backing_dev_info *bdi, const char *fmt, ...)
+{
+	int ret;
+	va_list args;
+	char buf[64];
+
+	va_start(args, fmt);
+	vsnprintf(buf, sizeof(buf), fmt, args);
+	va_end(args);
+
+	ret = bdi_init(bdi);
+	if (!ret) {
+		ret = bdi_register(bdi, buf);
+		if (ret)
+			bdi_destroy(bdi);
+	}
+
+	return ret;
+}
+
+#else
+
+int bdi_register(struct backing_dev_info *bdi, char *name)
+{
+	return 0;
+}
+
+inline void bdi_unregister(struct backing_dev_info *bdi)
+{
+}
+
+int bdi_init_fmt(struct backing_dev_info *bdi, const char *fmt, ...)
+{
+	return bdi_init(bdi);
+}
+
+#endif
+
+EXPORT_SYMBOL(bdi_init_fmt);
 
 int bdi_init(struct backing_dev_info *bdi)
 {
 	int i, j;
 	int err;
 
+	memset(bdi, 0, sizeof(*bdi));
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
 		if (err)
@@ -33,6 +181,8 @@ void bdi_destroy(struct backing_dev_info
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
Index: linux-2.6-2/block/genhd.c
===================================================================
--- linux-2.6-2.orig/block/genhd.c
+++ linux-2.6-2/block/genhd.c
@@ -182,6 +182,7 @@ void add_disk(struct gendisk *disk)
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
+	bdi_register(&disk->queue->backing_dev_info, disk->disk_name);
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


