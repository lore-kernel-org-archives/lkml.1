Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbXJ0QA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbXJ0QA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbXJ0QAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:00:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40975 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbXJ0QAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:00:10 -0400
Date: Sat, 27 Oct 2007 09:02:03 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
Message-ID: <20071027160203.GA5709@kroah.com>
References: <1193410087.6914.34.camel@twins> <1193411451.2431.13.camel@lov.site> <1193412147.27652.2.camel@twins> <1193412788.2431.22.camel@lov.site> <1193412836.27652.11.camel@twins> <1193414147.2431.35.camel@lov.site> <1193429066.5648.35.camel@lappy> <1193447889.5648.44.camel@lappy> <20071027024033.GB29039@kroah.com> <1193474399.27652.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193474399.27652.15.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 10:39:59AM +0200, Peter Zijlstra wrote:
> On Fri, 2007-10-26 at 19:40 -0700, Greg KH wrote:
> > On Sat, Oct 27, 2007 at 03:18:08AM +0200, Peter Zijlstra wrote:
> > > 
> > > On Fri, 2007-10-26 at 22:04 +0200, Peter Zijlstra wrote:
> > > > This crashes and burns on bootup, but I'm too tired to figure out what I
> > > > did wrong... will give it another try tomorrow..
> > > 
> > > Ok, can't sleep.. took a look. I have several problems here.
> > > 
> > > The thing that makes it go *boom* is the __ATTR_NULL. Removing that
> > > makes it boot. Albeit it then warns me of multiple duplicate sysfs
> > > objects, all named "bdi".
> > > 
> > > For some obscure reason this device interface insists on using the
> > > bus_id as name (?!), and further reduces usability by limiting that to
> > > 20 odd characters.
> > > 
> > > This makes it quite useless. I tried fudging around that limit by using
> > > device_rename and kobject_rename, but to no avail.
> > > 
> > > Really, it should not be this hard to use, trying to expose a handfull
> > > of simple integers to userspace should not take 8h+ and still not work.
> > > 
> > > Peter, who thinks sysfs is contorted mess beyond his skill. I'll stick
> > > to VM and scheduler code, that actually makes sense.
> > 
> > Heh, that's funny :)
> > 
> > I'll look at this and see what I can come up with.  Would you just like
> > a whole new patch, or one against this one?
> 
> Sorry for the grumpy note, I get that way at 3.30 am. Maybe I ought not
> have mailed :-/
> 
> This is the code I had at that time.

Ah, I see a few problems.  Here, try this version instead.  It's
compile-tested only, and should be a lot simpler.

Note, we still are not setting the parent to the new bdi structure
properly, so the devices will show up in /sys/devices/virtual/ instead
of in their proper location.  To do this, we need the parent of the
device, which I'm not so sure what it should be (block device?  block
device controller?)

Let me know if this works better, I'm off to a kids birthday party for
the day, but will be around this evening...

thanks,

greg k-h

---
 block/genhd.c               |    2 
 fs/fuse/inode.c             |    2 
 fs/nfs/client.c             |    2 
 include/linux/backing-dev.h |   19 +++++++
 include/linux/string.h      |    4 +
 include/linux/writeback.h   |    3 +
 mm/backing-dev.c            |  110 ++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c         |    2 
 mm/util.c                   |   42 ++++++++++++++++
 9 files changed, 183 insertions(+), 3 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -182,6 +182,7 @@ void add_disk(struct gendisk *disk)
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
+	bdi_register(&disk->queue->backing_dev_info, "bdi-%s", disk->disk_name);
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
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -467,7 +467,7 @@ static struct fuse_conn *new_conn(void)
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
-		err = bdi_init(&fc->bdi);
+		err = bdi_init_fmt(&fc->bdi, "bdi-fuse-%llu", (unsigned long long)fc->id);
 		if (err) {
 			kfree(fc);
 			fc = NULL;
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -678,7 +678,7 @@ static int nfs_probe_fsinfo(struct nfs_s
 		goto out_error;
 
 	nfs_server_set_fsinfo(server, &fsinfo);
-	error = bdi_init(&server->backing_dev_info);
+	error = bdi_init_fmt(&server->backing_dev_info, "bdi-nfs-%s-%p", clp->cl_hostname, server);
 	if (error)
 		goto out_error;
 
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
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
 
+int bdi_register(struct backing_dev_info *bdi, const char *fmt, ...);
+void bdi_unregister(struct backing_dev_info *bdi);
+
+#define bdi_init_fmt(bdi, fmt...)				\
+	({							\
+	 	int ret;					\
+	 	ret = bdi_init(bdi);				\
+	 	if (!ret) {					\
+	 		ret = bdi_register(bdi, ##fmt);		\
+	 		if (ret)				\
+	 			bdi_destroy(bdi);		\
+	 	}						\
+	 	ret;						\
+	 })
+
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item, s64 amount)
 {
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -8,6 +8,7 @@
 #include <linux/compiler.h>	/* for inline */
 #include <linux/types.h>	/* for size_t */
 #include <linux/stddef.h>	/* for NULL */
+#include <stdarg.h>
 
 #ifdef __cplusplus
 extern "C" {
@@ -111,6 +112,9 @@ extern void *kmemdup(const void *src, si
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
 extern void argv_free(char **argv);
 
+char *kvprintf(const char *fmt, va_list args);
+char *kprintf(const char *fmt, ...);
+
 #ifdef __cplusplus
 }
 #endif
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -113,6 +113,9 @@ struct file;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int, struct file *,
 				      void __user *, size_t *, loff_t *);
 
+void get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
+		 struct backing_dev_info *bdi);
+
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 					unsigned long nr_pages_dirtied);
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
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
+static ssize_t readahead_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
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
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);		\
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
+};
+
+static __init int bdi_class_init(void)
+{
+	bdi_class = class_create(THIS_MODULE, "bdi");
+	return 0;
+}
+
+__initcall(bdi_class_init);
+
+int bdi_register(struct backing_dev_info *bdi, const char *fmt, ...)
+{
+	char *name;
+	va_list args;
+	int ret = -ENOMEM;
+	int i;
+
+	va_start(args, fmt);
+	name = kvprintf(fmt, args);
+	va_end(args);
+
+	if (!name)
+		return -ENOMEM;
+
+	bdi->dev = device_create(bdi_class, NULL, MKDEV(0,0), name);
+	if (IS_ERR(bdi->dev))
+		goto exit;
+
+	dev_set_drvdata(bdi->dev, bdi);
+
+	for (i = 0; i < ARRAY_SIZE(bdi_dev_attrs); i++) {
+		ret = device_create_file(bdi->dev, &bdi_dev_attrs[i]);
+		if (ret)
+			break;
+	}
+	if (ret) {
+		while (--i >= 0)
+			device_remove_file(bdi->dev, &bdi_dev_attrs[i]);
+		device_unregister(bdi->dev);
+		bdi->dev = NULL;
+	}
+
+exit:
+	kfree(name);
+
+	return ret;
+}
+
+void bdi_unregister(struct backing_dev_info *bdi)
+{
+	device_unregister(bdi->dev);
+}
+
+EXPORT_SYMBOL(bdi_register);
+EXPORT_SYMBOL(bdi_unregister);
 
 int bdi_init(struct backing_dev_info *bdi)
 {
 	int i, j;
 	int err;
 
+	memset(bdi, 0, sizeof(*bdi));
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
 
@@ -90,3 +199,4 @@ long congestion_wait(int rw, long timeou
 }
 EXPORT_SYMBOL(congestion_wait);
 
+
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -291,7 +291,7 @@ static unsigned long determine_dirtyable
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-static void
+void
 get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 		 struct backing_dev_info *bdi)
 {
--- a/mm/util.c
+++ b/mm/util.c
@@ -136,3 +136,45 @@ char *strndup_user(const char __user *s,
 	return p;
 }
 EXPORT_SYMBOL(strndup_user);
+
+char *kvprintf(const char *fmt, va_list args)
+{
+	char c;
+	char *buf;
+	int need;
+	int limit;
+	va_list args1;
+
+	va_copy(args1, args);
+	need = vsnprintf(&c, 1, fmt, args1);
+	va_end(args1);
+
+	/* Allocate the new space and copy the string in */
+	limit = need + 1;
+	buf = kmalloc(limit, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+	need = vsnprintf(buf, limit, fmt, args);
+
+	/* something wrong with the string we copied? */
+	if (need >= limit) {
+		kfree(buf);
+		return NULL;
+	}
+
+	return buf;
+}
+EXPORT_SYMBOL(kvprintf);
+
+char *kprintf(const char *fmt, ...)
+{
+	char *buf;
+	va_list args;
+
+	va_start(args, fmt);
+	buf = kvprintf(fmt, args);
+	va_end(args);
+
+	return buf;
+}
+EXPORT_SYMBOL(kprintf);
