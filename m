Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbYLPPbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbYLPPbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbYLPPbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:31:38 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:23595 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757396AbYLPPbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:31:36 -0500
Message-ID: <4947C9D2.5080405@panasas.com>
Date: Tue, 16 Dec 2008 17:31:30 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/9] exofs: super_operations and file_system_type
References: <4947BFAA.4030208@panasas.com>
In-Reply-To: <4947BFAA.4030208@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2008 15:30:02.0855 (UTC) FILETIME=[2A232F70:01C95F93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch ties all operation vectors into a file system superblock
and registers the exofs file_system_type at module's load time.

* The file system control block (AKA on-disk superblock) resides in
  an object with a special ID (defined in common.h).
  Information included in the file system control block is used to
  fill the in-memory superblock structure at mount time. This object
  is created before the file system is used by mkexofs.c It contains
  information such as:
	- The file system's magic number
	- The next inode number to be allocated

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/Kbuild  |    2 +-
 fs/exofs/exofs.h |   30 ++++
 fs/exofs/inode.c |  195 +++++++++++++++++++++-
 fs/exofs/super.c |  502 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 727 insertions(+), 2 deletions(-)
 create mode 100644 fs/exofs/super.c

diff --git a/fs/exofs/Kbuild b/fs/exofs/Kbuild
index 27c738c..e293cb9 100644
--- a/fs/exofs/Kbuild
+++ b/fs/exofs/Kbuild
@@ -26,5 +26,5 @@ KBUILD_CPPFLAGS := -I$(OSD_INC) $(KBUILD_CPPFLAGS)
 
 endif
 
-exofs-objs := osd.o inode.o file.o symlink.o namei.o dir.o
+exofs-objs := osd.o inode.o file.o symlink.o namei.o dir.o super.o
 obj-$(CONFIG_EXOFS_FS) += exofs.o
diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index 7330b59..75c608d 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -52,6 +52,17 @@
 #define _LLU(x) (unsigned long long)(x)
 
 /*
+ * struct to hold what we get from mount options
+ */
+struct exofs_mountopt {
+	const char *dev_name;
+	uint64_t pid;
+	int timeout;
+	bool mkfs;
+	int format; /*in Mbyte*/
+};
+
+/*
  * our extension to the in-memory superblock
  */
 struct exofs_sb_info {
@@ -110,6 +121,14 @@ static inline struct exofs_i_info *EXOFS_I(struct inode *inode)
 }
 
 /*
+ * ugly struct so that we can pass two arguments to update_inode's callback
+ */
+struct updatei_args {
+	struct exofs_sb_info	*sbi;
+	struct exofs_fcb	*fcb;
+};
+
+/*
  * Maximum count of links to a file
  */
 #define EXOFS_LINK_MAX           32000
@@ -188,12 +207,20 @@ void free_osd_req(struct osd_request *req);
 /* inode.c               */
 void exofs_truncate(struct inode *inode);
 extern struct inode *exofs_iget(struct super_block *, unsigned long);
+extern int exofs_write_inode(struct inode *, int);
+extern void exofs_delete_inode(struct inode *);
 struct inode *exofs_new_inode(struct inode *, int);
 int exofs_setattr(struct dentry *, struct iattr *);
 int exofs_write_begin(struct file *file, struct address_space *mapping,
 		loff_t pos, unsigned len, unsigned flags,
 		struct page **pagep, void **fsdata);
 
+/* super.c:              */
+#ifdef EXOFS_DEBUG
+void exofs_dprint_internal(char *str, ...);
+#endif
+extern void exofs_write_super(struct super_block *);
+
 /* dir.c:                */
 int exofs_add_link(struct dentry *, struct inode *);
 ino_t exofs_inode_by_name(struct inode *, struct dentry *);
@@ -223,6 +250,9 @@ extern struct address_space_operations exofs_aops;
 extern struct inode_operations exofs_dir_inode_operations;
 extern struct inode_operations exofs_special_inode_operations;
 
+/* super.c           */
+extern struct super_operations exofs_sops;
+
 /* symlink.c         */
 extern struct inode_operations exofs_symlink_inode_operations;
 extern struct inode_operations exofs_fast_symlink_inode_operations;
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 25a562e..e24690b 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -37,6 +37,7 @@
 #include "exofs.h"
 
 static int __readpage_filler(struct page *page, bool is_async_unlock);
+static int exofs_update_inode(struct inode *inode, int do_sync);
 
 /*
  * Test whether an inode is a fast symlink.
@@ -49,6 +50,18 @@ static inline int exofs_inode_is_fast_symlink(struct inode *inode)
 }
 
 /*
+ * Callback function from exofs_delete_inode() - don't have much cleaning up to
+ * do.
+ */
+void delete_done(struct osd_request *req, void *p)
+{
+	struct exofs_sb_info *sbi;
+	free_osd_req(req);
+	sbi = (struct exofs_sb_info *)p;
+	atomic_dec(&sbi->s_curr_pending);
+}
+
+/*
  * get_block_t - Fill in a buffer_head
  * An OSD takes care of block allocation so we just fake an allocation by
  * putting in the inode's sector_t in the buffer_head.
@@ -94,6 +107,62 @@ int exofs_write_begin_export(struct file *file, struct address_space *mapping,
 }
 
 /*
+ * Called when the refcount of an inode reaches zero.  We remove the object
+ * from the OSD here.  We make sure the object was created before we try and
+ * delete it.
+ */
+void exofs_delete_inode(struct inode *inode)
+{
+	struct exofs_i_info *oi = EXOFS_I(inode);
+	struct osd_request *req = NULL;
+	struct super_block *sb = inode->i_sb;
+	struct exofs_sb_info *sbi = sb->s_fs_info;
+	int ret;
+
+	truncate_inode_pages(&inode->i_data, 0);
+
+	if (is_bad_inode(inode))
+		goto no_delete;
+	mark_inode_dirty(inode);
+	exofs_update_inode(inode, inode_needs_sync(inode));
+
+	inode->i_size = 0;
+	if (inode->i_blocks)
+		exofs_truncate(inode);
+
+	clear_inode(inode);
+
+	req = prepare_osd_remove(sbi->s_dev, sbi->s_pid,
+				 inode->i_ino + EXOFS_OBJ_OFF);
+	if (!req) {
+		printk(KERN_ERR "ERROR: prepare_osd_remove failed\n");
+		return;
+	}
+
+	/* if we are deleting an obj that hasn't been created yet, wait */
+	if (!ObjCreated(oi)) {
+		if (!Obj2BCreated(oi))
+			BUG();
+		else
+			wait_event(oi->i_wq, ObjCreated(oi));
+	}
+
+	ret = exofs_async_op(req, delete_done, sbi, oi->i_cred);
+	if (ret) {
+		printk(KERN_ERR
+		       "ERROR: @exofs_delete_inode exofs_async_op failed\n");
+		free_osd_req(req);
+		return;
+	}
+	atomic_inc(&sbi->s_curr_pending);
+
+	return;
+
+no_delete:
+	clear_inode(inode);
+}
+
+/*
  * Callback function when writepage finishes.  Check for errors, unlock, clean
  * up, etc.
  */
@@ -610,6 +679,131 @@ bad_inode:
 }
 
 /*
+ * Callback function from exofs_update_inode().
+ */
+void updatei_done(struct osd_request *req, void *p)
+{
+	struct updatei_args *args = (struct updatei_args *)p;
+
+	free_osd_req(req);
+
+	atomic_dec(&args->sbi->s_curr_pending);
+
+	kfree(args->fcb);
+	kfree(args);
+	args = NULL;
+}
+
+/*
+ * Write the inode to the OSD.  Just fill up the struct, and set the attribute
+ * synchronously or asynchronously depending on the do_sync flag.
+ */
+static int exofs_update_inode(struct inode *inode, int do_sync)
+{
+	struct exofs_i_info *oi = EXOFS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	struct exofs_sb_info *sbi = sb->s_fs_info;
+	struct osd_request *req = NULL;
+	struct exofs_fcb *fcb = NULL;
+	int ret;
+	int n;
+
+	fcb = kmalloc(sizeof(struct exofs_fcb), GFP_KERNEL);
+	if (!fcb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	fcb->i_mode = cpu_to_be16(inode->i_mode);
+	fcb->i_uid = cpu_to_be32(inode->i_uid);
+	fcb->i_gid = cpu_to_be32(inode->i_gid);
+	fcb->i_links_count = cpu_to_be16(inode->i_nlink);
+	fcb->i_ctime = cpu_to_be32(inode->i_ctime.tv_sec);
+	fcb->i_atime = cpu_to_be32(inode->i_atime.tv_sec);
+	fcb->i_mtime = cpu_to_be32(inode->i_mtime.tv_sec);
+	fcb->i_size = cpu_to_be64(oi->i_commit_size = i_size_read(inode));
+	fcb->i_generation = cpu_to_be32(inode->i_generation);
+
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+		if (old_valid_dev(inode->i_rdev)) {
+			fcb->i_data[0] = old_encode_dev(inode->i_rdev);
+			fcb->i_data[1] = 0;
+		} else {
+			fcb->i_data[0] = 0;
+			fcb->i_data[1] = new_encode_dev(inode->i_rdev);
+			fcb->i_data[2] = 0;
+		}
+	} else
+		for (n = 0; n < EXOFS_IDATA; n++)
+			fcb->i_data[n] = oi->i_data[n];
+
+	req = prepare_osd_set_attr(sbi->s_dev, sbi->s_pid,
+				 (uint64_t) (inode->i_ino + EXOFS_OBJ_OFF));
+	if (!req) {
+		printk(KERN_ERR "ERROR: prepare set_attr failed.\n");
+		kfree(fcb);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	prepare_set_attr_list_add_entry(req,
+					OSD_PAGE_NUM_IBM_UOBJ_FS_DATA,
+					OSD_ATTR_NUM_IBM_UOBJ_FS_DATA_INODE,
+					EXOFS_INO_ATTR_SIZE,
+					(unsigned char *)fcb);
+
+	if (!ObjCreated(oi)) {
+		if (!Obj2BCreated(oi))
+			BUG();
+		else
+			wait_event(oi->i_wq, ObjCreated(oi));
+	}
+
+	if (do_sync) {
+		ret = exofs_sync_op(req, sbi->s_timeout, oi->i_cred);
+		free_osd_req(req);
+		kfree(fcb);
+	} else {
+		struct updatei_args *args = NULL;
+
+		args = kmalloc(sizeof(struct updatei_args), GFP_KERNEL);
+		if (!args) {
+			kfree(fcb);
+			ret = -ENOMEM;
+			goto out;
+		}
+		args->sbi = sbi;
+		args->fcb = fcb;
+
+		ret = exofs_async_op(req, updatei_done, args, oi->i_cred);
+		if (ret) {
+			free_osd_req(req);
+			kfree(fcb);
+			kfree(args);
+			goto out;
+		}
+		atomic_inc(&sbi->s_curr_pending);
+	}
+out:
+	return ret;
+}
+
+int exofs_write_inode(struct inode *inode, int wait)
+{
+	return exofs_update_inode(inode, wait);
+}
+
+int exofs_sync_inode(struct inode *inode)
+{
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_ALL,
+		.nr_to_write = 0,	/* sys_fsync did this */
+	};
+
+	return sync_inode(inode, &wbc);
+}
+
+/*
  * Set inode attributes - just call generic functions.
  */
 int exofs_setattr(struct dentry *dentry, struct iattr *iattr)
@@ -624,7 +818,6 @@ int exofs_setattr(struct dentry *dentry, struct iattr *iattr)
 	error = inode_setattr(inode, iattr);
 	return error;
 }
-
 /*
  * Callback function from exofs_new_inode().  The important thing is that we
  * set the ObjCreated flag so that other methods know that the object exists on
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
new file mode 100644
index 0000000..8ecf700
--- /dev/null
+++ b/fs/exofs/super.c
@@ -0,0 +1,502 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ *
+ * Copyrights for code taken from ext2:
+ *     Copyright (C) 1992, 1993, 1994, 1995
+ *     Remy Card (card@masi.ibp.fr)
+ *     Laboratoire MASI - Institut Blaise Pascal
+ *     Universite Pierre et Marie Curie (Paris VI)
+ *     from
+ *     linux/fs/minix/inode.c
+ *     Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is part of exofs.
+ *
+ * exofs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for exofs is version 2.
+ *
+ * exofs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with exofs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/string.h>
+#include <linux/parser.h>
+#include <linux/vfs.h>
+#include <linux/random.h>
+
+#include "exofs.h"
+
+/******************************************************************************
+ * MOUNT OPTIONS
+ *****************************************************************************/
+
+/*
+ * exofs-specific mount-time options.
+ */
+enum { Opt_lun, Opt_tid, Opt_pid, Opt_to, Opt_mkfs, Opt_format, Opt_err };
+
+/*
+ * Our mount-time options.  These should ideally be 64-bit unsigned, but the
+ * kernel's parsing functions do not currently support that.  32-bit should be
+ * sufficient for most applications now.
+ */
+static match_table_t tokens = {
+	{Opt_pid, "pid=%u"},
+	{Opt_to, "to=%u"},
+	{Opt_err, NULL}
+};
+
+/*
+ * The main option parsing method.  Also makes sure that all of the mandatory
+ * mount options were set.
+ */
+static int parse_options(char *options, struct exofs_mountopt *opts)
+{
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+	int s_pid = 0;
+
+	EXOFS_DBGMSG("parse_options %s\n", options);
+	/* defaults */
+	memset(opts, 0, sizeof(*opts));
+	opts->timeout = BLK_DEFAULT_SG_TIMEOUT;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_pid:
+			if (match_int(&args[0], &option))
+				return -EINVAL;
+			if (option < 65536) {
+				EXOFS_ERR("Partition ID must be >= 65536");
+				return -EINVAL;
+			}
+			opts->pid = option;
+			s_pid = 1;
+			break;
+		case Opt_to:
+			if (match_int(&args[0], &option))
+				return -EINVAL;
+			if (option <= 0) {
+				EXOFS_ERR("Timout must be > 0");
+				return -EINVAL;
+			}
+			opts->timeout = option * HZ;
+			break;
+		}
+	}
+
+	if (!s_pid) {
+		EXOFS_ERR("Need to specify the following options:\n");
+		EXOFS_ERR("    -o pid=pid_no_to_use\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/******************************************************************************
+ * INODE CACHE
+ *****************************************************************************/
+
+/*
+ * Our inode cache.  Isn't it pretty?
+ */
+static struct kmem_cache *exofs_inode_cachep;
+
+/*
+ * Allocate an inode in the cache
+ */
+static struct inode *exofs_alloc_inode(struct super_block *sb)
+{
+	struct exofs_i_info *oi;
+
+	oi = kmem_cache_alloc(exofs_inode_cachep, GFP_KERNEL);
+	if (!oi)
+		return NULL;
+
+	oi->vfs_inode.i_version = 1;
+	return &oi->vfs_inode;
+}
+
+/*
+ * Remove an inode from the cache
+ */
+static void exofs_destroy_inode(struct inode *inode)
+{
+	kmem_cache_free(exofs_inode_cachep, EXOFS_I(inode));
+}
+
+/*
+ * Initialize the inode
+ */
+static void exofs_init_once(void *foo)
+{
+	struct exofs_i_info *oi = foo;
+
+	inode_init_once(&oi->vfs_inode);
+}
+
+/*
+ * Create and initialize the inode cache
+ */
+static int init_inodecache(void)
+{
+	exofs_inode_cachep = kmem_cache_create("exofs_inode_cache",
+					       sizeof(struct exofs_i_info),
+					       0, SLAB_RECLAIM_ACCOUNT,
+					       exofs_init_once);
+	if (exofs_inode_cachep == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+/*
+ * Destroy the inode cache
+ */
+static void destroy_inodecache(void)
+{
+	kmem_cache_destroy(exofs_inode_cachep);
+}
+
+/******************************************************************************
+ * SUPERBLOCK FUNCTIONS
+ *****************************************************************************/
+
+/*
+ * Write the superblock to the OSD
+ */
+void exofs_write_super(struct super_block *sb)
+{
+	struct exofs_sb_info *sbi;
+	struct exofs_fscb *fscb = NULL;
+	struct osd_request *req = NULL;
+
+	fscb = kzalloc(sizeof(struct exofs_fscb), GFP_KERNEL);
+	if (!fscb)
+		return;
+
+	lock_kernel();
+	sbi = sb->s_fs_info;
+	fscb->s_nextid = sbi->s_nextid;
+	fscb->s_magic = sb->s_magic;
+	fscb->s_numfiles = sbi->s_numfiles;
+	fscb->s_newfs = 0;
+
+	req = prepare_osd_write(sbi->s_dev, sbi->s_pid, EXOFS_SUPER_ID,
+				sizeof(struct exofs_fscb), 0, 0,
+				(unsigned char *)(fscb));
+	if (!req) {
+		EXOFS_ERR("ERROR: write super failed.\n");
+		kfree(fscb);
+		return;
+	}
+
+	exofs_sync_op(req, sbi->s_timeout, sbi->s_cred);
+	free_osd_req(req);
+	sb->s_dirt = 0;
+	unlock_kernel();
+	kfree(fscb);
+}
+
+/*
+ * This function is called when the vfs is freeing the superblock.  We just
+ * need to free our own part.
+ */
+static void exofs_put_super(struct super_block *sb)
+{
+	int num_pend;
+	struct exofs_sb_info *sbi = sb->s_fs_info;
+
+	/* make sure there are no pending commands */
+	for (num_pend = atomic_read(&sbi->s_curr_pending); num_pend > 0;
+	     num_pend = atomic_read(&sbi->s_curr_pending)) {
+		wait_queue_head_t wq;
+		init_waitqueue_head(&wq);
+		wait_event_timeout(wq,
+				  (atomic_read(&sbi->s_curr_pending) == 0),
+				  msecs_to_jiffies(100));
+	}
+
+	osduld_put_device(sbi->s_dev);
+	kfree(sb->s_fs_info);
+	sb->s_fs_info = NULL;
+}
+
+/*
+ * Read the superblock from the OSD and fill in the fields
+ */
+static int exofs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct inode *root;
+	struct exofs_mountopt *opts = data;
+	struct exofs_sb_info *sbi = NULL;    /*extended info                  */
+	struct exofs_fscb fscb;		     /*on-disk superblock info        */
+	struct osd_request *req = NULL;
+	int ret;
+
+	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
+	if (!sbi)
+		return -ENOMEM;
+	sb->s_fs_info = sbi;
+
+	/* use mount options to fill superblock */
+	sbi->s_dev = osduld_path_lookup(opts->dev_name);
+	if (IS_ERR(sbi->s_dev)) {
+		ret = PTR_ERR(sbi->s_dev);
+		sbi->s_dev = NULL;
+		goto free_sbi;
+	}
+
+	sbi->s_pid = opts->pid;
+	sbi->s_timeout = opts->timeout;
+
+	/* fill in some other data by hand */
+	memset(sb->s_id, 0, sizeof(sb->s_id));
+	strcpy(sb->s_id, "exofs");
+	sb->s_blocksize = EXOFS_BLKSIZE;
+	sb->s_blocksize_bits = EXOFS_BLKSHIFT;
+	atomic_set(&sbi->s_curr_pending, 0);
+	sb->s_bdev = NULL;
+	sb->s_dev = 0;
+
+	/* read data from on-disk superblock object */
+	make_credential(sbi->s_cred, sbi->s_pid, EXOFS_SUPER_ID);
+
+	req = prepare_osd_read(sbi->s_dev, sbi->s_pid, EXOFS_SUPER_ID,
+			       sizeof(struct exofs_fscb), 0, 0,
+			       (unsigned char *)(&fscb));
+	if (!req) {
+		if (!silent)
+			EXOFS_ERR("ERROR: could not prepare read request.\n");
+		ret = -ENOMEM;
+		goto free_sbi;
+	}
+
+	ret = exofs_sync_op(req, sbi->s_timeout, sbi->s_cred);
+	if (ret != 0) {
+		if (!silent)
+			EXOFS_ERR("ERROR: read super failed.\n");
+		ret = -EIO;
+		goto free_sbi;
+	}
+
+	sb->s_magic = fscb.s_magic;
+	sbi->s_nextid = fscb.s_nextid;
+	sbi->s_numfiles = fscb.s_numfiles;
+
+	/* make sure what we read from the object store is correct */
+	if (sb->s_magic != EXOFS_SUPER_MAGIC) {
+		if (!silent)
+			EXOFS_ERR("ERROR: Bad magic value\n");
+		ret = -EINVAL;
+		goto free_sbi;
+	}
+
+	/* start generation numbers from a random point */
+	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
+	spin_lock_init(&sbi->s_next_gen_lock);
+
+	/* set up operation vectors */
+	sb->s_op = &exofs_sops;
+	root = exofs_iget(sb, EXOFS_ROOT_ID - EXOFS_OBJ_OFF);
+	if (IS_ERR(root)) {
+		EXOFS_ERR("ERROR: exofs_iget faild\n");
+		ret = PTR_ERR(root);
+		goto free_sbi;
+	}
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		iput(root);
+		EXOFS_ERR("ERROR: get root inode failed\n");
+		ret = -ENOMEM;
+		goto free_sbi;
+	}
+
+	if (!S_ISDIR(root->i_mode)) {
+		dput(sb->s_root);
+		sb->s_root = NULL;
+		EXOFS_ERR("ERROR: corrupt root inode (mode = %hd)\n",
+		       root->i_mode);
+		ret = -EINVAL;
+		goto free_sbi;
+	}
+
+	ret = 0;
+out:
+	if (req)
+		free_osd_req(req);
+	return ret;
+
+free_sbi:
+	osduld_put_device(sbi->s_dev); /* NULL safe */
+	kfree(sbi);
+	goto out;
+}
+
+/*
+ * Set up the superblock (calls exofs_fill_super eventually)
+ */
+static int exofs_get_sb(struct file_system_type *type,
+			  int flags, const char *dev_name,
+			  void *data, struct vfsmount *mnt)
+{
+	struct exofs_mountopt opts;
+	int ret;
+
+	ret = parse_options((char *) data, &opts);
+	if (ret)
+		return ret;
+
+	opts.dev_name = dev_name;
+	return get_sb_nodev(type, flags, &opts, exofs_fill_super, mnt);
+}
+
+/*
+ * Return information about the file system state in the buffer.  This is used
+ * by the 'df' command, for example.
+ */
+static int exofs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct exofs_sb_info *sbi = sb->s_fs_info;
+	uint8_t cred_a[OSD_CAP_LEN];
+	struct osd_request *req = NULL;
+	uint32_t page;
+	uint32_t attr;
+	uint16_t expected;
+	uint64_t capacity;
+	uint64_t used;
+	uint8_t *data;
+	int ret;
+
+	/* get used/capacity attributes */
+	make_credential(cred_a, sbi->s_pid, 0);
+
+	req = prepare_osd_get_attr(sbi->s_dev, sbi->s_pid, 0);
+	if (!req) {
+		EXOFS_ERR("ERROR: prepare get_attr failed.\n");
+		return -1;
+	}
+
+	prepare_get_attr_list_add_entry(req,
+			OSD_APAGE_PARTITION_QUOTAS,
+			OSD_ATTR_PQ_CAPACITY_QUOTA,
+			8);
+
+	prepare_get_attr_list_add_entry(req,
+			OSD_APAGE_PARTITION_INFORMATION,
+			OSD_ATTR_PI_USED_CAPACITY,
+			8);
+
+	ret = exofs_sync_op(req, sbi->s_timeout, cred_a);
+	if (ret)
+		goto out;
+
+	page = OSD_APAGE_PARTITION_QUOTAS;
+	attr = OSD_ATTR_PQ_CAPACITY_QUOTA;
+	expected = 8;
+	ret = extract_next_attr_from_req(req, &page, &attr, &expected, &data);
+	if (ret) {
+		EXOFS_ERR("ERROR: extract attr from req failed\n");
+		goto out;
+	}
+	capacity = be64_to_cpu(*((uint64_t *)data));
+
+	page = OSD_APAGE_PARTITION_INFORMATION;
+	attr = OSD_ATTR_PI_USED_CAPACITY;
+	expected = 8;
+	ret = extract_next_attr_from_req(req, &page, &attr, &expected, &data);
+	if (ret) {
+		EXOFS_ERR("ERROR: extract attr from req failed\n");
+		goto out;
+	}
+	used = be64_to_cpu(*((uint64_t *)data));
+
+	/* fill in the stats buffer */
+	buf->f_type = EXOFS_SUPER_MAGIC;
+	buf->f_bsize = EXOFS_BLKSIZE;
+	buf->f_blocks = (capacity >> EXOFS_BLKSHIFT);
+	buf->f_bfree = ((capacity - used) >> EXOFS_BLKSHIFT);
+	buf->f_bavail = buf->f_bfree;
+	buf->f_files = sbi->s_numfiles;
+	buf->f_ffree = EXOFS_MAX_ID - sbi->s_numfiles;
+	buf->f_namelen = EXOFS_NAME_LEN;
+out:
+	free_osd_req(req);
+
+	return ret;
+}
+
+struct super_operations exofs_sops = {
+	.alloc_inode    = exofs_alloc_inode,
+	.destroy_inode  = exofs_destroy_inode,
+	.write_inode    = exofs_write_inode,
+	.delete_inode   = exofs_delete_inode,
+	.put_super      = exofs_put_super,
+	.write_super    = exofs_write_super,
+	.statfs         = exofs_statfs,
+};
+
+/******************************************************************************
+ * INSMOD/RMMOD
+ *****************************************************************************/
+
+/*
+ * struct that describes this file system
+ */
+static struct file_system_type exofs_type = {
+	.owner          = THIS_MODULE,
+	.name           = "exofs",
+	.get_sb         = exofs_get_sb,
+	.kill_sb        = generic_shutdown_super,
+};
+
+static int __init init_exofs(void)
+{
+	int err;
+
+	err = init_inodecache();
+	if (err)
+		goto out;
+
+	err = register_filesystem(&exofs_type);
+	if (err)
+		goto out_d;
+
+	return 0;
+out_d:
+	destroy_inodecache();
+out:
+	return err;
+}
+
+static void __exit exit_exofs(void)
+{
+	unregister_filesystem(&exofs_type);
+	destroy_inodecache();
+}
+
+MODULE_AUTHOR("Avishay Traeger <avishay@gmail.com>");
+MODULE_DESCRIPTION("exofs");
+MODULE_LICENSE("GPL");
+
+module_init(init_exofs)
+module_exit(exit_exofs)
-- 
1.6.0.1


