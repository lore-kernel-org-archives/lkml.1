Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYJ0Lk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYJ0Lk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYJ0LkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:40:17 -0400
Received: from mail.crca.org.au ([67.207.131.56]:60233 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYJ0LkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:40:14 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
From: Nigel Cunningham <ncunningham@crca.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200810271237.40049.rjw@sisk.pl>
References: <1224886068.6478.21.camel@nigel-laptop>
	 <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
	 <1225106427.26724.5.camel@nigel-laptop>  <200810271237.40049.rjw@sisk.pl>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Mon, 27 Oct 2008 22:40:07 +1100
Message-Id: <1225107607.26724.9.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2008-10-27 at 12:37 +0100, Rafael J. Wysocki wrote:
> On Monday, 27 of October 2008, Nigel Cunningham wrote:
> > Hi Miklos.
> > 
> > On Mon, 2008-10-27 at 12:12 +0100, Miklos Szeredi wrote:
> > > On Sun, 26 Oct 2008, Rafael J. Wysocki wrote:
> > > > On Saturday, 25 of October 2008, Nigel Cunningham wrote:
> > > > > While working on freezing fuse filesystems, I found that if a filesystem
> > > > > is frozen when we try to freeze processes, freezing can fail because
> > > > > threads are waiting in vfs_check_frozen for the filesystem to be thawed.
> > > > > We should thus not count such threads.
> > > > > 
> > > > > The check will be safe if a filesystem is thawed while we're freezing
> > > > > processes because filesystem thaws are only invoked from userspace. Any
> > > > > waiting processes will be woken and frozen prior to us completing the
> > > > > freezing of userspace (the caller invoking the filesystem thaw will be
> > > > > freezing) or - in the worst case - together with kernel threads.
> > > 
> > > The description is missing some details: why is the filesystem frozen
> > > before suspend?  AFAICS this can happen when DM calls bdev_freeze() on
> > > the device before the task freezing begins.  Is this the case?
> > 
> > It doesn't matter why a process is sitting in that wait_event call. What
> > does matter is that one can be there. In the case where I saw it, I was
> > working on fuse freezing. I don't remember the details, as it's a year
> > since I made this patch, but I don't think I wasn't using fuse or DM.
> > 
> > > Also, while the patch might solve some of the symptoms of the fuse
> > > vs. process freezer interaction, it will not fully fix that problem.
> > > As such it's just a hack to hide the problem, making it less likely to
> > > appear.
> > 
> > No, it's part of the solution. I haven't posted the full fuse freezing
> > patch because I thought this could be profitably merged without the rest
> > of the patch.
> 
> Well, I guess it's better if you post the entire thing so that we can see
> what the role of the $subject patch is in it, even if this patch finally gets
> merged separately.

Ah.. that makes me see how vfs_check_frozen was getting triggered...
(fs/namei.c, below).

Regards,

Nigel

 fs/buffer.c                 |   87 ++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/control.c           |    1 
 fs/fuse/dev.c               |    7 +++
 fs/fuse/dir.c               |   35 +++++++++++++++--
 fs/fuse/file.c              |   14 +++++++
 fs/fuse/fuse.h              |   13 ++++++
 fs/fuse/inode.c             |    4 +-
 fs/namei.c                  |    2 +
 include/linux/buffer_head.h |    5 ++
 include/linux/freezer.h     |   15 +++++++
 include/linux/fs.h          |   10 ++++-
 kernel/power/process.c      |   48 +++++++++++++++++++++---
 12 files changed, 227 insertions(+), 14 deletions(-)
diff -ruNp 700-BRANCH-fuse-freezing.patch-old/fs/buffer.c 700-BRANCH-fuse-freezing.patch-new/fs/buffer.c
--- 700-BRANCH-fuse-freezing.patch-old/fs/buffer.c	2008-10-19 04:57:22.000000000 +1100
+++ 700-BRANCH-fuse-freezing.patch-new/fs/buffer.c	2008-10-21 13:16:08.000000000 +1100
@@ -247,6 +247,93 @@ void thaw_bdev(struct block_device *bdev
 }
 EXPORT_SYMBOL(thaw_bdev);
 
+#if 0
+#define FS_PRINTK(fmt, args...) printk(fmt, ## args)
+#else
+#define FS_PRINTK(fmt, args...)
+#endif
+
+/* #define DEBUG_FS_FREEZING */
+
+/**
+ * freeze_filesystems - lock all filesystems and force them into a consistent
+ * state
+ * @which:	What combination of fuse & non-fuse to freeze. 
+ */
+void freeze_filesystems(int which)
+{
+	struct super_block *sb;
+
+	lockdep_off();
+
+	/*
+	 * Freeze in reverse order so filesystems dependant upon others are
+	 * frozen in the right order (eg. loopback on ext3).
+	 */
+	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
+		FS_PRINTK(KERN_INFO "Considering %s.%s: (root %p, bdev %x)",
+			sb->s_type->name ? sb->s_type->name : "?",
+			sb->s_subtype ? sb->s_subtype : "", sb->s_root,
+			sb->s_bdev ? sb->s_bdev->bd_dev : 0);
+
+		if (sb->s_type->fs_flags & FS_IS_FUSE &&
+		    sb->s_frozen == SB_UNFROZEN &&
+		    which & FS_FREEZER_FUSE) {
+			sb->s_frozen = SB_FREEZE_TRANS;
+			sb->s_flags |= MS_FROZEN;
+			FS_PRINTK("Fuse filesystem done.\n");
+			continue;
+		}
+
+		if (!sb->s_root || !sb->s_bdev ||
+		    (sb->s_frozen == SB_FREEZE_TRANS) ||
+		    (sb->s_flags & MS_RDONLY) ||
+		    (sb->s_flags & MS_FROZEN) ||
+		    !(which & FS_FREEZER_NORMAL)) {
+			FS_PRINTK(KERN_INFO "Nope.\n");
+			continue;
+		}
+
+		FS_PRINTK(KERN_INFO "Freezing %x... ", sb->s_bdev->bd_dev);
+		freeze_bdev(sb->s_bdev);
+		sb->s_flags |= MS_FROZEN;
+		FS_PRINTK(KERN_INFO "Done.\n");
+	}
+
+	lockdep_on();
+}
+
+/**
+ * thaw_filesystems - unlock all filesystems
+ * @which:	What combination of fuse & non-fuse to thaw. 
+ */
+void thaw_filesystems(int which)
+{
+	struct super_block *sb;
+
+	lockdep_off();
+
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (!(sb->s_flags & MS_FROZEN))
+			continue;
+
+		if (sb->s_type->fs_flags & FS_IS_FUSE) {
+			if (!(which & FS_FREEZER_FUSE))
+				continue;
+
+			sb->s_frozen = SB_UNFROZEN;
+		} else {
+			if (!(which & FS_FREEZER_NORMAL))
+				continue;
+
+			thaw_bdev(sb->s_bdev, sb);
+		}
+		sb->s_flags &= ~MS_FROZEN;
+	}
+
+	lockdep_on();
+}
+
 /*
  * Various filesystems appear to want __find_get_block to be non-blocking.
  * But it's the page lock which protects the buffers.  To get around this,
diff -ruNp 700-BRANCH-fuse-freezing.patch-old/fs/fuse/control.c 700-BRANCH-fuse-freezing.patch-new/fs/fuse/control.c
--- 700-BRANCH-fuse-freezing.patch-old/fs/fuse/control.c	2008-10-19 04:57:22.000000000 +1100
+++ 700-BRANCH-fuse-freezing.patch-new/fs/fuse/control.c	2008-10-21 13:12:40.000000000 +1100
@@ -207,6 +207,7 @@ static void fuse_ctl_kill_sb(struct supe
 static struct file_system_type fuse_ctl_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fusectl",
+	.fs_flags	= FS_IS_FUSE,
 	.get_sb		= fuse_ctl_get_sb,
 	.kill_sb	= fuse_ctl_kill_sb,
 };
diff -ruNp 700-BRANCH-fuse-freezing.patch-old/fs/fuse/dev.c 700-BRANCH-fuse-freezing.patch-new/fs/fuse/dev.c
--- 700-BRANCH-fuse-freezing.patch-old/fs/fuse/dev.c	2008-10-19 04:57:22.000000000 +1100
+++ 700-BRANCH-fuse-freezing.patch-new/fs/fuse/dev.c	2008-10-21 13:12:40.000000000 +1100
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "fuse.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -16,6 +17,7 @@
 #include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/slab.h>
+#include <linux/freezer.h>
 
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 
@@ -743,6 +745,8 @@ static ssize_t fuse_dev_read(struct kioc
 	if (!fc)
 		return -EPERM;
 
+	FUSE_MIGHT_FREEZE(file->f_mapping->host->i_sb, "fuse_dev_read");
+
  restart:
 	spin_lock(&fc->lock);
 	err = -EAGAIN;
@@ -869,6 +873,9 @@ static ssize_t fuse_dev_write(struct kio
 	if (!fc)
 		return -EPERM;
 
+	FUSE_MIGHT_FREEZE(iocb->ki_filp->f_mapping->host->i_sb,
+			"fuse_dev_write");
+
 	fuse_copy_init(&cs, fc, 0, NULL, iov, nr_segs);
 	if (nbytes < sizeof(struct fuse_out_header))
 		return -EINVAL;
diff -ruNp 700-BRANCH-fuse-freezing.patch-old/fs/fuse/dir.c 700-BRANCH-fuse-freezing.patch-new/fs/fuse/dir.c
--- 700-BRANCH-fuse-freezing.patch-old/fs/fuse/dir.c	2008-10-19 04:57:22.000000000 +1100
+++ 700-BRANCH-fuse-freezing.patch-new/fs/fuse/dir.c	2008-10-21 13:12:40.000000000 +1100
@@ -7,12 +7,14 @@
 */
 
 #include "fuse_i.h"
+#include "fuse.h"
 
 #include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/gfp.h>
 #include <linux/sched.h>
 #include <linux/namei.h>
+#include <linux/freezer.h>
 
 #if BITS_PER_LONG >= 64
 static inline void fuse_dentry_settime(struct dentry *entry, u64 time)
@@ -174,6 +176,9 @@ static int fuse_dentry_revalidate(struct
 			return 0;
 
 		fc = get_fuse_conn(inode);
+
+		FUSE_MIGHT_FREEZE(inode->i_sb, "fuse_dentry_revalidate");
+
 		req = fuse_get_req(fc);
 		if (IS_ERR(req))
 			return 0;
@@ -273,6 +278,8 @@ int fuse_lookup_name(struct super_block 
 	if (IS_ERR(req))
 		goto out;
 
+	FUSE_MIGHT_FREEZE(sb, "fuse_lookup");
+
 	forget_req = fuse_get_req(fc);
 	err = PTR_ERR(forget_req);
 	if (IS_ERR(forget_req)) {
@@ -402,6 +409,8 @@ static int fuse_create_open(struct inode
 	if (IS_ERR(forget_req))
 		return PTR_ERR(forget_req);
 
+	FUSE_MIGHT_FREEZE(dir->i_sb, "fuse_create_open");
+
 	req = fuse_get_req(fc);
 	err = PTR_ERR(req);
 	if (IS_ERR(req))
@@ -488,6 +497,8 @@ static int create_new_entry(struct fuse_
 	int err;
 	struct fuse_req *forget_req;
 
+	FUSE_MIGHT_FREEZE(dir->i_sb, "create_new_entry");
+
 	forget_req = fuse_get_req(fc);
 	if (IS_ERR(forget_req)) {
 		fuse_put_request(fc, req);
@@ -585,7 +596,11 @@ static int fuse_mkdir(struct inode *dir,
 {
 	struct fuse_mkdir_in inarg;
 	struct fuse_conn *fc = get_fuse_conn(dir);
-	struct fuse_req *req = fuse_get_req(fc);
+	struct fuse_req *req;
+
+	FUSE_MIGHT_FREEZE(dir->i_sb, "fuse_mkdir");
+
+	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -605,7 +620,11 @@ static int fuse_symlink(struct inode *di
 {
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	unsigned len = strlen(link) + 1;
-	struct fuse_req *req = fuse_get_req(fc);
+	struct fuse_req *req;
+
+	FUSE_MIGHT_FREEZE(dir->i_sb, "fuse_symlink");
+
+	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -622,7 +641,11 @@ static int fuse_unlink(struct inode *dir
 {
 	int err;
 	struct fuse_conn *fc = get_fuse_conn(dir);
-	struct fuse_req *req = fuse_get_req(fc);
+	struct fuse_req *req;
+
+	FUSE_MIGHT_FREEZE(dir->i_sb, "fuse_unlink");
+
+	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -653,7 +676,11 @@ static int fuse_rmdir(struct inode *dir,
 {
 	int err;
 	struct fuse_conn *fc = get_fuse_conn(dir);
-	struct fuse_req *req = fuse_get_req(fc);
+	struct fuse_req *req;
+
+	FUSE_MIGHT_FREEZE(dir->i_sb, "fuse_rmdir");
+
+	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
diff -ruNp 700-BRANCH-fuse-freezing.patch-old/fs/fuse/file.c 700-BRANCH-fuse-freezing.patch-new/fs/fuse/file.c
--- 700-BRANCH-fuse-freezing.patch-old/fs/fuse/file.c	2008-10-19 04:57:22.000000000 +1100
+++ 700-BRANCH-fuse-freezing.patch-new/fs/fuse/file.c	2008-10-21 13:12:40.000000000 +1100
@@ -7,11 +7,13 @@
 */
 
 #include "fuse_i.h"
+#include "fuse.h"
 
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/freezer.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -23,6 +25,8 @@ static int fuse_send_open(struct inode *
 	struct fuse_req *req;
 	int err;
 
+	FUSE_MIGHT_FREEZE(inode->i_sb, "fuse_send_open");
+
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -674,6 +678,8 @@ static int fuse_buffered_write(struct fi
 	if (is_bad_inode(inode))
 		return -EIO;
 
+	FUSE_MIGHT_FREEZE(inode->i_sb, "fuse_commit_write");
+
 	/*
 	 * Make sure writepages on the same page are not mixed up with
 	 * plain writes.
@@ -962,6 +968,8 @@ static ssize_t fuse_direct_io(struct fil
 	if (is_bad_inode(inode))
 		return -EIO;
 
+	FUSE_MIGHT_FREEZE(file->f_mapping->host->i_sb, "fuse_direct_io");
+
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -1315,6 +1323,8 @@ static int fuse_getlk(struct file *file,
 	struct fuse_lk_out outarg;
 	int err;
 
+	FUSE_MIGHT_FREEZE(file->f_mapping->host->i_sb, "fuse_getlk");
+
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -1350,6 +1360,8 @@ static int fuse_setlk(struct file *file,
 	if (fl->fl_flags & FL_CLOSE)
 		return 0;
 
+	FUSE_MIGHT_FREEZE(file->f_mapping->host->i_sb, "fuse_setlk");
+
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -1416,6 +1428,8 @@ static sector_t fuse_bmap(struct address
 	if (!inode->i_sb->s_bdev || fc->no_bmap)
 		return 0;
 
+	FUSE_MIGHT_FREEZE(inode->i_sb, "fuse_bmap");
+
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return 0;
diff -ruNp 700-BRANCH-fuse-freezing.patch-old/fs/fuse/fuse.h 700-BRANCH-fuse-freezing.patch-new/fs/fuse/fuse.h
--- 700-BRANCH-fuse-freezing.patch-old/fs/fuse/fuse.h	1970-01-01 10:00:00.000000000 +1000
+++ 700-BRANCH-fuse-freezing.patch-new/fs/fuse/fuse.h	2008-10-21 13:12:40.000000000 +1100
@@ -0,0 +1,13 @@
+#define FUSE_MIGHT_FREEZE(superblock, desc) \
+do { \
+	int printed = 0; \
+	while (superblock->s_frozen != SB_UNFROZEN) { \
+		if (!printed) { \
+			printk(KERN_INFO "%d frozen in " desc ".\n", \
+						current->pid); \
+			printed = 1; \
+		} \
+		try_to_freeze(); \
+		yield(); \
+	} \
+} while (0)
diff -ruNp 700-BRANCH-fuse-freezing.patch-old/fs/fuse/inode.c 700-BRANCH-fuse-freezing.patch-new/fs/fuse/inode.c
--- 700-BRANCH-fuse-freezing.patch-old/fs/fuse/inode.c	2008-10-19 04:57:22.000000000 +1100
+++ 700-BRANCH-fuse-freezing.patch-new/fs/fuse/inode.c	2008-10-21 13:12:40.000000000 +1100
@@ -914,7 +914,7 @@ static int fuse_get_sb(struct file_syste
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
-	.fs_flags	= FS_HAS_SUBTYPE,
+	.fs_flags	= FS_HAS_SUBTYPE | FS_IS_FUSE,
 	.get_sb		= fuse_get_sb,
 	.kill_sb	= kill_anon_super,
 };
@@ -933,7 +933,7 @@ static struct file_system_type fuseblk_f
 	.name		= "fuseblk",
 	.get_sb		= fuse_get_sb_blk,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
+	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE | FS_IS_FUSE,
 };
 
 static inline int register_fuseblk(void)
diff -ruNp 700-BRANCH-fuse-freezing.patch-old/fs/namei.c 700-BRANCH-fuse-freezing.patch-new/fs/namei.c
--- 700-BRANCH-fuse-freezing.patch-old/fs/namei.c	2008-10-19 04:57:22.000000000 +1100
+++ 700-BRANCH-fuse-freezing.patch-new/fs/namei.c	2008-10-21 13:12:40.000000000 +1100
@@ -2223,6 +2223,8 @@ int vfs_unlink(struct inode *dir, struct
 	if (!dir->i_op || !dir->i_op->unlink)
 		return -EPERM;
 
+	vfs_check_frozen(dir->i_sb, SB_FREEZE_WRITE);
+
 	DQUOT_INIT(dir);
 
 	mutex_lock(&dentry->d_inode->i_mutex);
diff -ruNp 700-BRANCH-fuse-freezing.patch-old/include/linux/buffer_head.h 700-BRANCH-fuse-freezing.patch-new/include/linux/buffer_head.h
--- 700-BRANCH-fuse-freezing.patch-old/include/linux/buffer_head.h	2008-10-19 04:57:22.000000000 +1100
+++ 700-BRANCH-fuse-freezing.patch-new/include/linux/buffer_head.h	2008-10-21 13:12:40.000000000 +1100
@@ -171,6 +171,11 @@ wait_queue_head_t *bh_waitq_head(struct 
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
 void thaw_bdev(struct block_device *, struct super_block *);
+#define FS_FREEZER_FUSE 1
+#define FS_FREEZER_NORMAL 2
+#define FS_FREEZER_ALL (FS_FREEZER_FUSE | FS_FREEZER_NORMAL)
+void freeze_filesystems(int which);
+void thaw_filesystems(int which);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
diff -ruNp 700-BRANCH-fuse-freezing.patch-old/include/linux/freezer.h 700-BRANCH-fuse-freezing.patch-new/include/linux/freezer.h
--- 700-BRANCH-fuse-freezing.patch-old/include/linux/freezer.h	2008-10-19 04:57:22.000000000 +1100
+++ 700-BRANCH-fuse-freezing.patch-new/include/linux/freezer.h	2008-10-21 13:16:08.000000000 +1100
@@ -136,6 +136,19 @@ static inline void set_freezable_with_si
 	current->flags &= ~(PF_NOFREEZE | PF_FREEZER_NOSIG);
 }
 
+extern int freezer_state;
+#define FREEZER_OFF 0
+#define FREEZER_FILESYSTEMS_FROZEN 1
+#define FREEZER_USERSPACE_FROZEN 2
+#define FREEZER_FULLY_ON 3
+
+static inline int freezer_is_on(void)
+{
+	return freezer_state == FREEZER_FULLY_ON;
+}
+
+extern void thaw_kernel_threads(void);
+
 /*
  * Freezer-friendly wrappers around wait_event_interruptible() and
  * wait_event_interruptible_timeout(), originally defined in <linux/wait.h>
@@ -178,6 +191,8 @@ static inline int freeze_processes(void)
 static inline void thaw_processes(void) {}
 
 static inline int try_to_freeze(void) { return 0; }
+static inline int freezer_is_on(void) { return 0; }
+static inline void thaw_kernel_threads(void) { }
 
 static inline void freezer_do_not_count(void) {}
 static inline void freezer_count(void) {}
diff -ruNp 700-BRANCH-fuse-freezing.patch-old/include/linux/fs.h 700-BRANCH-fuse-freezing.patch-new/include/linux/fs.h
--- 700-BRANCH-fuse-freezing.patch-old/include/linux/fs.h	2008-10-19 04:57:22.000000000 +1100
+++ 700-BRANCH-fuse-freezing.patch-new/include/linux/fs.h	2008-10-21 13:12:40.000000000 +1100
@@ -8,6 +8,7 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <linux/freezer.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -96,6 +97,7 @@ extern int dir_notify_enable;
 #define FS_REQUIRES_DEV 1 
 #define FS_BINARY_MOUNTDATA 2
 #define FS_HAS_SUBTYPE 4
+#define FS_IS_FUSE	8	/* Fuse filesystem - bdev freeze these too */
 #define FS_REVAL_DOT	16384	/* Check the paths ".", ".." for staleness */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
@@ -128,6 +130,7 @@ extern int dir_notify_enable;
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
+#define MS_FROZEN	(1<<24)	/* Frozen by freeze_filesystems() */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
@@ -1141,8 +1144,11 @@ enum {
 	SB_FREEZE_TRANS = 2,
 };
 
-#define vfs_check_frozen(sb, level) \
-	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
+#define vfs_check_frozen(sb, level) do { \
+	freezer_do_not_count(); \
+	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level))); \
+	freezer_count(); \
+} while (0)
 
 #define get_fs_excl() atomic_inc(&current->fs_excl)
 #define put_fs_excl() atomic_dec(&current->fs_excl)
diff -ruNp 700-BRANCH-fuse-freezing.patch-old/kernel/power/process.c 700-BRANCH-fuse-freezing.patch-new/kernel/power/process.c
--- 700-BRANCH-fuse-freezing.patch-old/kernel/power/process.c	2008-10-19 04:57:22.000000000 +1100
+++ 700-BRANCH-fuse-freezing.patch-new/kernel/power/process.c	2008-10-21 13:16:08.000000000 +1100
@@ -13,6 +13,9 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/freezer.h>
+#include <linux/buffer_head.h>
+
+int freezer_state;
 
 /* 
  * Timeout for stopping processes
@@ -201,7 +204,8 @@ static int try_to_freeze_tasks(bool sig_
 		do_each_thread(g, p) {
 			task_lock(p);
 			if (freezing(p) && !freezer_should_skip(p))
-				printk(KERN_ERR " %s\n", p->comm);
+				printk(KERN_ERR " %s (%d) failed to freeze.\n",
+						p->comm, p->pid);
 			cancel_freezing(p);
 			task_unlock(p);
 		} while_each_thread(g, p);
@@ -221,17 +225,25 @@ int freeze_processes(void)
 {
 	int error;
 
-	printk("Freezing user space processes ... ");
+	printk(KERN_INFO "Stopping fuse filesystems.\n");
+	freeze_filesystems(FS_FREEZER_FUSE);
+	freezer_state = FREEZER_FILESYSTEMS_FROZEN;
+	printk(KERN_INFO "Freezing user space processes ... ");
 	error = try_to_freeze_tasks(true);
 	if (error)
 		goto Exit;
-	printk("done.\n");
+	printk(KERN_INFO "done.\n");
 
-	printk("Freezing remaining freezable tasks ... ");
+	sys_sync();
+	printk(KERN_INFO "Stopping normal filesystems.\n");
+	freeze_filesystems(FS_FREEZER_NORMAL);
+	freezer_state = FREEZER_USERSPACE_FROZEN;
+	printk(KERN_INFO "Freezing remaining freezable tasks ... ");
 	error = try_to_freeze_tasks(false);
 	if (error)
 		goto Exit;
 	printk("done.");
+	freezer_state = FREEZER_FULLY_ON;
  Exit:
 	BUG_ON(in_atomic());
 	printk("\n");
@@ -257,11 +269,35 @@ static void thaw_tasks(bool nosig_only)
 
 void thaw_processes(void)
 {
-	printk("Restarting tasks ... ");
-	thaw_tasks(true);
+	int old_state = freezer_state;
+
+	if (old_state == FREEZER_OFF)
+		return;
+
+	/*
+	 * Change state beforehand because thawed tasks might submit I/O
+	 * immediately.
+	 */
+	freezer_state = FREEZER_OFF;
+
+	printk(KERN_INFO "Restarting all filesystems ...\n");
+	thaw_filesystems(FS_FREEZER_ALL);
+
+	printk(KERN_INFO "Restarting tasks ... ");
+
+	if (old_state == FREEZER_FULLY_ON)
+		thaw_tasks(true);
 	thaw_tasks(false);
 	schedule();
 	printk("done.\n");
 }
 
 EXPORT_SYMBOL(refrigerator);
+
+void thaw_kernel_threads(void)
+{
+	freezer_state = FREEZER_USERSPACE_FROZEN;
+	printk(KERN_INFO "Restarting normal filesystems.\n");
+	thaw_filesystems(FS_FREEZER_NORMAL);
+	thaw_tasks(true);
+}


