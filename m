Return-Path: <linux-kernel-owner+w=401wt.eu-S1762595AbXKAXS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762595AbXKAXS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760187AbXKAXJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:09:15 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38639 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbXKAXJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:09:06 -0400
Subject: [PATCH 27/27] keep track of mnt_writer state of struct file
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:09:02 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230902.F256608C@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There have been a few oopses caused by 'struct file's with
NULL f_vfsmnts.  There was also a set of potentially missed
mnt_want_write()s from dentry_open() calls.

This patch provides a very simple debugging framework to
catch these kinds of bugs.  It will WARN_ON() them, but
should stop us from having any oopses or mnt_writer
count imbalances.

I'm quite convinced that this is a good thing because it
found bugs in the stuff I was working on as soon as I
wrote it.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/file_table.c    |   21 +++++++++++++++++++--
 linux-2.6.git-dave/fs/open.c          |   14 +++++++++++++-
 linux-2.6.git-dave/include/linux/fs.h |    4 ++++
 3 files changed, 36 insertions(+), 3 deletions(-)

diff -puN fs/file_table.c~keep-track-of-mnt_writer-state-of-struct-file fs/file_table.c
--- linux-2.6.git/fs/file_table.c~keep-track-of-mnt_writer-state-of-struct-file	2007-11-01 14:46:22.000000000 -0700
+++ linux-2.6.git-dave/fs/file_table.c	2007-11-01 14:46:22.000000000 -0700
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
 
@@ -201,6 +207,7 @@ int init_file(struct file *file, struct 
 	 * that we can do debugging checks at __fput()e
 	 */
 	if ((mode & FMODE_WRITE) && !special_file(dentry->d_inode->i_mode)) {
+		file->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
 		error = mnt_want_write(mnt);
 		WARN_ON(error);
 	}
@@ -243,8 +250,18 @@ void fastcall __fput(struct file *file)
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
diff -puN fs/open.c~keep-track-of-mnt_writer-state-of-struct-file fs/open.c
--- linux-2.6.git/fs/open.c~keep-track-of-mnt_writer-state-of-struct-file	2007-11-01 14:46:22.000000000 -0700
+++ linux-2.6.git-dave/fs/open.c	2007-11-01 14:46:22.000000000 -0700
@@ -810,6 +810,10 @@ static struct file *__dentry_open(struct
 		error = __get_file_write_access(inode, mnt);
 		if (error)
 			goto cleanup_file;
+		if (!special_file(inode->i_mode)) {
+			WARN_ON(f->f_mnt_write_state != 0);
+			f->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
+		}
 	}
 
 	f->f_mapping = inode->i_mapping;
@@ -851,8 +855,16 @@ cleanup_all:
 	fops_put(f->f_op);
 	if (f->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
-		if (!special_file(inode->i_mode))
+		if (!special_file(inode->i_mode)) {
+			/*
+			 * We don't consider this a real
+			 * mnt_want/drop_write() pair
+			 * because it all happenend right
+			 * here, so just reset the state.
+			 */
+			f->f_mnt_write_state = 0;
 			mnt_drop_write(mnt);
+		}
 	}
 	file_kill(f);
 	f->f_path.dentry = NULL;
diff -puN include/linux/fs.h~keep-track-of-mnt_writer-state-of-struct-file include/linux/fs.h
--- linux-2.6.git/include/linux/fs.h~keep-track-of-mnt_writer-state-of-struct-file	2007-11-01 14:46:22.000000000 -0700
+++ linux-2.6.git-dave/include/linux/fs.h	2007-11-01 14:46:22.000000000 -0700
@@ -774,6 +774,9 @@ static inline int ra_has_index(struct fi
 		index <  ra->start + ra->size);
 }
 
+#define FILE_MNT_WRITE_TAKEN	1
+#define FILE_MNT_WRITE_RELEASED	2
+
 struct file {
 	/*
 	 * fu_list becomes invalid after file_free is called and queued via
@@ -808,6 +811,7 @@ struct file {
 	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
+	unsigned long f_mnt_write_state;
 };
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);
_
