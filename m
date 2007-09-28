Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbXI1SPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbXI1SPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbXI1SNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:13:55 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59673 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbXI1SNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:13:54 -0400
Subject: [RFC][PATCH 8/8] keep track of mnt_writer state of struct file
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 28 Sep 2007 11:13:41 -0700
References: <20070928181330.27B367AC@kernel>
In-Reply-To: <20070928181330.27B367AC@kernel>
Message-Id: <20070928181341.7E168306@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There have been a few oopses caused by 'struct file's with
NULL f_vfsmnts.  There was also a set of potentially missed
mnt_want_write()s from dentry_open() calls.

This patch provides a very simple debugging framework to
catch these kinds of bugs.  It will WARN_ON() them, but
should stop us from having any oopses or mnt_writer
count imbalances.


Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/file_table.c    |   21 +++++++++++++++++++--
 lxc-dave/fs/namei.c         |   15 +++++++++++++--
 lxc-dave/include/linux/fs.h |    4 ++++
 3 files changed, 36 insertions(+), 4 deletions(-)

diff -puN fs/file_table.c~keep-track-of-mnt_writer-state-of-struct-file fs/file_table.c
--- lxc/fs/file_table.c~keep-track-of-mnt_writer-state-of-struct-file	2007-09-28 11:03:50.000000000 -0700
+++ lxc-dave/fs/file_table.c	2007-09-28 11:03:50.000000000 -0700
@@ -42,6 +42,12 @@ static inline void file_free_rcu(struct 
 static inline void file_free(struct file *f)
 {
 	percpu_counter_dec(&nr_files);
+	/*
+	 * At this point, either both or neither of these bits
+	 * should be set.
+	 */
+	WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN);
+	WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_RELEASED);
 	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
 }
 
@@ -194,6 +200,7 @@ int init_file(struct file *file, struct 
 	file->f_mode = mode;
 	file->f_op = fop;
 	if (mode & FMODE_WRITE) {
+		file->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
 		error = mnt_want_write(mnt);
 		WARN_ON(error);
 	}
@@ -236,8 +243,18 @@ void fastcall __fput(struct file *file)
 	fops_put(file->f_op);
 	if (file->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
-		if (!special_file(inode->i_mode))
-			mnt_drop_write(mnt);
+		if (!special_file(inode->i_mode)) {
+			if (file->f_mnt_write_state == FILE_MNT_WRITE_TAKEN) {
+				mnt_drop_write(mnt);
+				file->f_mnt_write_state |=
+					FILE_MNT_WRITE_RELEASED;
+			} else {
+				printk(KERN_WARNING "__fput() of writeable "
+						"file with no "
+						"mnt_want_write()\n");
+				WARN_ON(1);
+			}
+		}
 	}
 	put_pid(file->f_owner.pid);
 	file_kill(file);
diff -puN fs/namei.c~keep-track-of-mnt_writer-state-of-struct-file fs/namei.c
--- lxc/fs/namei.c~keep-track-of-mnt_writer-state-of-struct-file	2007-09-28 11:03:50.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-28 11:03:50.000000000 -0700
@@ -1753,6 +1753,7 @@ static inline int sys_open_flags_to_name
 struct file *open_namei(int dfd, const char *pathname, int sys_open_flag,
 			int mode)
 {
+	struct file *file;
 	struct nameidata nd;
 	int acc_mode, error;
 	struct path path;
@@ -1821,7 +1822,14 @@ do_last:
 		error = __open_namei_create(&nd, &path, flag, mode);
 		if (error)
 			goto exit;
-		return nameidata_to_filp(&nd, sys_open_flag);
+		file = nameidata_to_filp(&nd, sys_open_flag);
+		/*
+		 * The mnt_want_write happened in
+		 * __open_namei_create(), but it
+		 * happened unconditionally, so
+		 * this is safe to assume.
+		 */
+		file->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
 	}
 
 	/*
@@ -1865,7 +1873,10 @@ ok:
 			mnt_drop_write(nd.mnt);
 		goto exit;
 	}
-	return nameidata_to_filp(&nd, sys_open_flag);
+	file = nameidata_to_filp(&nd, sys_open_flag);
+	if (write_may_occur_to_file(nd.dentry->d_inode, acc_mode))
+		file->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
+	return file;
 
 exit_mutex_unlock:
 	mutex_unlock(&dir->d_inode->i_mutex);
diff -puN include/linux/fs.h~keep-track-of-mnt_writer-state-of-struct-file include/linux/fs.h
--- lxc/include/linux/fs.h~keep-track-of-mnt_writer-state-of-struct-file	2007-09-28 11:03:50.000000000 -0700
+++ lxc-dave/include/linux/fs.h	2007-09-28 11:03:50.000000000 -0700
@@ -779,6 +779,9 @@ static inline int ra_has_index(struct fi
 		index <  ra->start + ra->size);
 }
 
+#define FILE_MNT_WRITE_TAKEN	1
+#define FILE_MNT_WRITE_RELEASED	2
+
 struct file {
 	/*
 	 * fu_list becomes invalid after file_free is called and queued via
@@ -813,6 +816,7 @@ struct file {
 	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
+	unsigned long f_mnt_write_state;
 };
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);
_
