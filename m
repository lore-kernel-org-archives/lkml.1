Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbXJJQgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbXJJQgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbXJJQfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:35:11 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57478 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbXJJQfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:35:08 -0400
Subject: [RFC][PATCH 7/7] keep track of mnt_writer state of struct file
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 10 Oct 2007 09:34:46 -0700
References: <20071010163439.0F8089F7@kernel>
In-Reply-To: <20071010163439.0F8089F7@kernel>
Message-Id: <20071010163446.2C8F86AC@kernel>
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
 lxc-dave/fs/open.c          |    2 ++
 lxc-dave/include/linux/fs.h |    4 ++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff -puN fs/file_table.c~keep-track-of-mnt_writer-state-of-struct-file fs/file_table.c
--- lxc/fs/file_table.c~keep-track-of-mnt_writer-state-of-struct-file	2007-10-03 14:40:14.000000000 -0700
+++ lxc-dave/fs/file_table.c	2007-10-03 14:40:14.000000000 -0700
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
diff -puN include/linux/fs.h~keep-track-of-mnt_writer-state-of-struct-file include/linux/fs.h
--- lxc/include/linux/fs.h~keep-track-of-mnt_writer-state-of-struct-file	2007-10-03 14:40:14.000000000 -0700
+++ lxc-dave/include/linux/fs.h	2007-10-03 14:40:14.000000000 -0700
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
diff -puN fs/open.c~keep-track-of-mnt_writer-state-of-struct-file fs/open.c
--- lxc/fs/open.c~keep-track-of-mnt_writer-state-of-struct-file	2007-10-03 14:40:14.000000000 -0700
+++ lxc-dave/fs/open.c	2007-10-03 14:42:01.000000000 -0700
@@ -790,6 +790,8 @@ static struct file *__dentry_open(struct
 			mnt_drop_write(mnt);
 			goto cleanup_file;
 		}
+		WARN_ON(f->f_mnt_write_state != 0);
+		f->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
 	}
 
 	f->f_mapping = inode->i_mapping;
_
