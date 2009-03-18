Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbZCRSLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbZCRSLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbZCRSLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:11:08 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:22322 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752516AbZCRSLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:11:03 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 6/8] exofs: super_operations and file_system_type
Date: Wed, 18 Mar 2009 20:09:51 +0200
Message-Id: <1237399791-29502-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <49C1331D.1080805@panasas.com>
References: <49C1331D.1080805@panasas.com>
X-OriginalArrivalTime: 18 Mar 2009 18:11:00.0367 (UTC) FILETIME=[E47791F0:01C9A7F4]
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
 fs/exofs/exofs.h |   22 +++
 fs/exofs/inode.c |  188 ++++++++++++++++++++
 fs/exofs/super.c |  520 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 731 insertions(+), 1 deletions(-)
 create mode 100644 fs/exofs/super.c

diff --git a/fs/exofs/Kbuild b/fs/exofs/Kbuild
index d5c8c54..592f40d 100644
--- a/fs/exofs/Kbuild
+++ b/fs/exofs/Kbuild
@@ -26,5 +26,5 @@ KBUILD_CPPFLAGS := -I$(OSD_INC) $(KBUILD_CPPFLAGS)
 
 endif
 
-exofs-y := osd.o inode.o file.o symlink.o namei.o dir.o
+exofs-y := osd.o inode.o file.o symlink.o namei.o dir.o super.o
 obj-$(CONFIG_EXOFS_FS) += exofs.o
diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index abf66b2..76155d7 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -54,6 +54,15 @@
 #define _LLU(x) (unsigned long long)(x)
 
 /*
+ * struct to hold what we get from mount options
+ */
+struct exofs_mountopt {
+	const char *dev_name;
+	uint64_t pid;
+	int timeout;
+};
+
+/*
  * our extension to the in-memory superblock
  */
 struct exofs_sb_info {
@@ -125,6 +134,14 @@ static inline struct exofs_i_info *exofs_i(struct inode *inode)
 }
 
 /*
+ * ugly struct so that we can pass two arguments to update_inode's callback
+ */
+struct updatei_args {
+	struct exofs_sb_info	*sbi;
+	struct exofs_fcb	fcb;
+};
+
+/*
  * Maximum count of links to a file
  */
 #define EXOFS_LINK_MAX           32000
@@ -140,6 +157,8 @@ int exofs_write_begin(struct file *file, struct address_space *mapping,
 		struct page **pagep, void **fsdata);
 extern struct inode *exofs_iget(struct super_block *, unsigned long);
 struct inode *exofs_new_inode(struct inode *, int);
+extern int exofs_write_inode(struct inode *, int);
+extern void exofs_delete_inode(struct inode *);
 
 /* dir.c:                */
 int exofs_add_link(struct dentry *, struct inode *);
@@ -170,6 +189,9 @@ extern const struct address_space_operations exofs_aops;
 extern const struct inode_operations exofs_dir_inode_operations;
 extern const struct inode_operations exofs_special_inode_operations;
 
+/* super.c           */
+extern const struct super_operations exofs_sops;
+
 /* symlink.c         */
 extern const struct inode_operations exofs_symlink_inode_operations;
 extern const struct inode_operations exofs_fast_symlink_inode_operations;
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 7b0c696..0f52e76 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1108,3 +1108,191 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
 
 	return inode;
 }
+
+/*
+ * Callback function from exofs_update_inode().
+ */
+static void updatei_done(struct osd_request *or, void *p)
+{
+	struct updatei_args *args = p;
+
+	osd_end_request(or);
+
+	atomic_dec(&args->sbi->s_curr_pending);
+
+	kfree(args);
+}
+
+/*
+ * Write the inode to the OSD.  Just fill up the struct, and set the attribute
+ * synchronously or asynchronously depending on the do_sync flag.
+ */
+static int exofs_update_inode(struct inode *inode, int do_sync)
+{
+	struct exofs_i_info *oi = exofs_i(inode);
+	struct super_block *sb = inode->i_sb;
+	struct exofs_sb_info *sbi = sb->s_fs_info;
+	struct osd_obj_id obj = {sbi->s_pid, inode->i_ino + EXOFS_OBJ_OFF};
+	struct osd_request *or;
+	struct osd_attr attr;
+	struct exofs_fcb *fcb;
+	struct updatei_args *args;
+	int ret;
+
+	args = kzalloc(sizeof(*args), GFP_KERNEL);
+	if (!args)
+		return -ENOMEM;
+
+	fcb = &args->fcb;
+
+	fcb->i_mode = cpu_to_le16(inode->i_mode);
+	fcb->i_uid = cpu_to_le32(inode->i_uid);
+	fcb->i_gid = cpu_to_le32(inode->i_gid);
+	fcb->i_links_count = cpu_to_le16(inode->i_nlink);
+	fcb->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
+	fcb->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
+	fcb->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
+	oi->i_commit_size = i_size_read(inode);
+	fcb->i_size = cpu_to_le64(oi->i_commit_size);
+	fcb->i_generation = cpu_to_le32(inode->i_generation);
+
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+		if (old_valid_dev(inode->i_rdev)) {
+			fcb->i_data[0] =
+				cpu_to_le32(old_encode_dev(inode->i_rdev));
+			fcb->i_data[1] = 0;
+		} else {
+			fcb->i_data[0] = 0;
+			fcb->i_data[1] =
+				cpu_to_le32(new_encode_dev(inode->i_rdev));
+			fcb->i_data[2] = 0;
+		}
+	} else
+		memcpy(fcb->i_data, oi->i_data, sizeof(fcb->i_data));
+
+	or = osd_start_request(sbi->s_dev, GFP_KERNEL);
+	if (unlikely(!or)) {
+		EXOFS_ERR("exofs_update_inode: osd_start_request failed.\n");
+		ret = -ENOMEM;
+		goto free_args;
+	}
+
+	osd_req_set_attributes(or, &obj);
+
+	attr = g_attr_inode_data;
+	attr.val_ptr = fcb;
+	osd_req_add_set_attr_list(or, &attr, 1);
+
+	if (!obj_created(oi)) {
+		EXOFS_DBGMSG("!obj_created\n");
+		BUG_ON(!obj_2bcreated(oi));
+		wait_event(oi->i_wq, obj_created(oi));
+		EXOFS_DBGMSG("wait_event done\n");
+	}
+
+	if (do_sync) {
+		ret = exofs_sync_op(or, sbi->s_timeout, oi->i_cred);
+		osd_end_request(or);
+		goto free_args;
+	} else {
+		args->sbi = sbi;
+
+		ret = exofs_async_op(or, updatei_done, args, oi->i_cred);
+		if (ret) {
+			osd_end_request(or);
+			goto free_args;
+		}
+		atomic_inc(&sbi->s_curr_pending);
+		goto out; /* deallocation in updatei_done */
+	}
+
+free_args:
+	kfree(args);
+out:
+	EXOFS_DBGMSG("ret=>%d\n", ret);
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
+ * Callback function from exofs_delete_inode() - don't have much cleaning up to
+ * do.
+ */
+static void delete_done(struct osd_request *or, void *p)
+{
+	struct exofs_sb_info *sbi;
+	osd_end_request(or);
+	sbi = p;
+	atomic_dec(&sbi->s_curr_pending);
+}
+
+/*
+ * Called when the refcount of an inode reaches zero.  We remove the object
+ * from the OSD here.  We make sure the object was created before we try and
+ * delete it.
+ */
+void exofs_delete_inode(struct inode *inode)
+{
+	struct exofs_i_info *oi = exofs_i(inode);
+	struct super_block *sb = inode->i_sb;
+	struct exofs_sb_info *sbi = sb->s_fs_info;
+	struct osd_obj_id obj = {sbi->s_pid, inode->i_ino + EXOFS_OBJ_OFF};
+	struct osd_request *or;
+	int ret;
+
+	truncate_inode_pages(&inode->i_data, 0);
+
+	if (is_bad_inode(inode))
+		goto no_delete;
+
+	mark_inode_dirty(inode);
+	exofs_update_inode(inode, inode_needs_sync(inode));
+
+	inode->i_size = 0;
+	if (inode->i_blocks)
+		exofs_truncate(inode);
+
+	clear_inode(inode);
+
+	or = osd_start_request(sbi->s_dev, GFP_KERNEL);
+	if (unlikely(!or)) {
+		EXOFS_ERR("exofs_delete_inode: osd_start_request failed\n");
+		return;
+	}
+
+	osd_req_remove_object(or, &obj);
+
+	/* if we are deleting an obj that hasn't been created yet, wait */
+	if (!obj_created(oi)) {
+		BUG_ON(!obj_2bcreated(oi));
+		wait_event(oi->i_wq, obj_created(oi));
+	}
+
+	ret = exofs_async_op(or, delete_done, sbi, oi->i_cred);
+	if (ret) {
+		EXOFS_ERR(
+		       "ERROR: @exofs_delete_inode exofs_async_op failed\n");
+		osd_end_request(or);
+		return;
+	}
+	atomic_inc(&sbi->s_curr_pending);
+
+	return;
+
+no_delete:
+	clear_inode(inode);
+}
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
new file mode 100644
index 0000000..9153db2
--- /dev/null
+++ b/fs/exofs/super.c
@@ -0,0 +1,520 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ * Copyright (C) 2008, 2009
+ * Boaz Harrosh <bharrosh@panasas.com>
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
+enum { Opt_pid, Opt_to, Opt_mkfs, Opt_format, Opt_err };
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
+	bool s_pid = false;
+
+	EXOFS_DBGMSG("parse_options %s\n", options);
+	/* defaults */
+	memset(opts, 0, sizeof(*opts));
+	opts->timeout = BLK_DEFAULT_SG_TIMEOUT;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		char str[32];
+
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_pid:
+			if (0 == match_strlcpy(str, &args[0], sizeof(str)))
+				return -EINVAL;
+			opts->pid = simple_strtoull(str, NULL, 0);
+			if (opts->pid < EXOFS_MIN_PID) {
+				EXOFS_ERR("Partition ID must be >= %u",
+					  EXOFS_MIN_PID);
+				return -EINVAL;
+			}
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
+	kmem_cache_free(exofs_inode_cachep, exofs_i(inode));
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
+				sizeof(struct exofs_i_info), 0,
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+				exofs_init_once);
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
+static void exofs_write_super(struct super_block *sb)
+{
+	struct exofs_sb_info *sbi;
+	struct exofs_fscb *fscb;
+	struct osd_request *or;
+	struct osd_obj_id obj;
+	int ret;
+
+	fscb = kzalloc(sizeof(struct exofs_fscb), GFP_KERNEL);
+	if (!fscb) {
+		EXOFS_ERR("exofs_write_super: memory allocation failed.\n");
+		return;
+	}
+
+	lock_kernel();
+	sbi = sb->s_fs_info;
+	fscb->s_nextid = cpu_to_le64(sbi->s_nextid);
+	fscb->s_numfiles = cpu_to_le32(sbi->s_numfiles);
+	fscb->s_magic = cpu_to_le16(sb->s_magic);
+	fscb->s_newfs = 0;
+
+	or = osd_start_request(sbi->s_dev, GFP_KERNEL);
+	if (unlikely(!or)) {
+		EXOFS_ERR("exofs_write_super: osd_start_request failed.\n");
+		goto out;
+	}
+
+	obj.partition = sbi->s_pid;
+	obj.id = EXOFS_SUPER_ID;
+	ret = osd_req_write_kern(or, &obj, 0, fscb, sizeof(*fscb));
+	if (unlikely(ret)) {
+		EXOFS_ERR("exofs_write_super: osd_req_write_kern failed.\n");
+		goto out;
+	}
+
+	ret = exofs_sync_op(or, sbi->s_timeout, sbi->s_cred);
+	if (unlikely(ret)) {
+		EXOFS_ERR("exofs_write_super: exofs_sync_op failed.\n");
+		goto out;
+	}
+	sb->s_dirt = 0;
+
+out:
+	if (or)
+		osd_end_request(or);
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
+	struct exofs_sb_info *sbi;	/*extended info                  */
+	struct exofs_fscb fscb;		/*on-disk superblock info        */
+	struct osd_request *or = NULL;
+	struct osd_obj_id obj;
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
+	obj.partition = sbi->s_pid;
+	obj.id = EXOFS_SUPER_ID;
+	exofs_make_credential(sbi->s_cred, &obj);
+
+	or = osd_start_request(sbi->s_dev, GFP_KERNEL);
+	if (unlikely(!or)) {
+		if (!silent)
+			EXOFS_ERR(
+			       "exofs_fill_super: osd_start_request failed.\n");
+		ret = -ENOMEM;
+		goto free_sbi;
+	}
+	ret = osd_req_read_kern(or, &obj, 0, &fscb, sizeof(fscb));
+	if (unlikely(ret)) {
+		if (!silent)
+			EXOFS_ERR(
+			       "exofs_fill_super: osd_req_read_kern failed.\n");
+		ret = -ENOMEM;
+		goto free_sbi;
+	}
+
+	ret = exofs_sync_op(or, sbi->s_timeout, sbi->s_cred);
+	if (unlikely(ret)) {
+		if (!silent)
+			EXOFS_ERR("exofs_fill_super: exofs_sync_op failed.\n");
+		ret = -EIO;
+		goto free_sbi;
+	}
+
+	sb->s_magic = le16_to_cpu(fscb.s_magic);
+	sbi->s_nextid = le64_to_cpu(fscb.s_nextid);
+	sbi->s_numfiles = le32_to_cpu(fscb.s_numfiles);
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
+		EXOFS_ERR("ERROR: exofs_iget failed\n");
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
+	if (or)
+		osd_end_request(or);
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
+	ret = parse_options(data, &opts);
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
+	struct osd_obj_id obj = {sbi->s_pid, 0};
+	struct osd_attr attrs[] = {
+		ATTR_DEF(OSD_APAGE_PARTITION_QUOTAS,
+			OSD_ATTR_PQ_CAPACITY_QUOTA, sizeof(__be64)),
+		ATTR_DEF(OSD_APAGE_PARTITION_INFORMATION,
+			OSD_ATTR_PI_USED_CAPACITY, sizeof(__be64)),
+	};
+	uint64_t capacity = ~0;
+	uint64_t used = ~0;
+	struct osd_request *or;
+	uint8_t cred_a[OSD_CAP_LEN];
+	int ret;
+
+	/* get used/capacity attributes */
+	exofs_make_credential(cred_a, &obj);
+
+	or = osd_start_request(sbi->s_dev, GFP_KERNEL);
+	if (unlikely(!or)) {
+		EXOFS_DBGMSG("exofs_statfs: osd_start_request failed.\n");
+		return -ENOMEM;
+	}
+
+	osd_req_get_attributes(or, &obj);
+	osd_req_add_get_attr_list(or, attrs, ARRAY_SIZE(attrs));
+	ret = exofs_sync_op(or, sbi->s_timeout, cred_a);
+	if (unlikely(ret))
+		goto out;
+
+	ret = extract_attr_from_req(or, &attrs[0]);
+	if (likely(!ret))
+		capacity = get_unaligned_be64(attrs[0].val_ptr);
+	else
+		EXOFS_DBGMSG("exofs_statfs: get capacity failed.\n");
+
+	ret = extract_attr_from_req(or, &attrs[1]);
+	if (likely(!ret))
+		used = get_unaligned_be64(attrs[1].val_ptr);
+	else
+		EXOFS_DBGMSG("exofs_statfs: get used-space failed.\n");
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
+
+out:
+	osd_end_request(or);
+	return ret;
+}
+
+const struct super_operations exofs_sops = {
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
1.6.2.1

