Return-Path: <linux-kernel-owner+w=401wt.eu-S934867AbYBOWxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934867AbYBOWxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760133AbYBOWiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:38:16 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49167 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136AbYBOWiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:38:05 -0500
Subject: [PATCH 30/30] r/o bind mounts: debugging for missed calls
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:38:01 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223801.E569A121@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There have been a few oopses caused by 'struct file's with NULL f_vfsmnts. 
There was also a set of potentially missed mnt_want_write()s from
dentry_open() calls.

This patch provides a very simple debugging framework to catch these kinds of
bugs.  It will WARN_ON() them, but should stop us from having any oopses or
mnt_writer count imbalances.

I'm quite convinced that this is a good thing because it found bugs in the
stuff I was working on as soon as I wrote it.

[hch: made it conditional on a debug option.
      But it's still a little bit too ugly]

[hch: merged forced remount r/o fix from Dave and akpm's fix for the fix]

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/file_table.c    |   11 ++++++-
 linux-2.6.git-dave/fs/open.c          |   12 +++++++-
 linux-2.6.git-dave/fs/super.c         |    3 ++
 linux-2.6.git-dave/include/linux/fs.h |   49 ++++++++++++++++++++++++++++++++++
 linux-2.6.git-dave/lib/Kconfig.debug  |   10 ++++++
 5 files changed, 82 insertions(+), 3 deletions(-)

diff -puN fs/file_table.c~keep-track-of-mnt_writer-state-of-struct-file fs/file_table.c
--- linux-2.6.git/fs/file_table.c~keep-track-of-mnt_writer-state-of-struct-file	2008-02-15 13:26:00.000000000 -0800
+++ linux-2.6.git-dave/fs/file_table.c	2008-02-15 13:26:00.000000000 -0800
@@ -42,6 +42,7 @@ static inline void file_free_rcu(struct 
 static inline void file_free(struct file *f)
 {
 	percpu_counter_dec(&nr_files);
+	file_check_state(f);
 	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
 }
 
@@ -207,6 +208,7 @@ int init_file(struct file *file, struct 
 	 * that we can do debugging checks at __fput()
 	 */
 	if ((mode & FMODE_WRITE) && !special_file(dentry->d_inode->i_mode)) {
+		file_take_write(file);
 		error = mnt_want_write(mnt);
 		WARN_ON(error);
 	}
@@ -237,8 +239,13 @@ void drop_file_write_access(struct file 
 	struct inode *inode = dentry->d_inode;
 
 	put_write_access(inode);
-	if (!special_file(inode->i_mode))
-		mnt_drop_write(mnt);
+
+	if (special_file(inode->i_mode))
+		return;
+	if (file_check_writeable(file) != 0)
+		return;
+	mnt_drop_write(mnt);
+	file_release_write(file);
 }
 EXPORT_SYMBOL_GPL(drop_file_write_access);
 
diff -puN fs/open.c~keep-track-of-mnt_writer-state-of-struct-file fs/open.c
--- linux-2.6.git/fs/open.c~keep-track-of-mnt_writer-state-of-struct-file	2008-02-15 13:26:00.000000000 -0800
+++ linux-2.6.git-dave/fs/open.c	2008-02-15 13:26:00.000000000 -0800
@@ -806,6 +806,8 @@ static struct file *__dentry_open(struct
 		error = __get_file_write_access(inode, mnt);
 		if (error)
 			goto cleanup_file;
+		if (!special_file(inode->i_mode))
+			file_take_write(f);
 	}
 
 	f->f_mapping = inode->i_mapping;
@@ -847,8 +849,16 @@ cleanup_all:
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
+			file_reset_write(f);
 			mnt_drop_write(mnt);
+		}
 	}
 	file_kill(f);
 	f->f_path.dentry = NULL;
diff -puN fs/super.c~keep-track-of-mnt_writer-state-of-struct-file fs/super.c
--- linux-2.6.git/fs/super.c~keep-track-of-mnt_writer-state-of-struct-file	2008-02-15 13:26:00.000000000 -0800
+++ linux-2.6.git-dave/fs/super.c	2008-02-15 13:26:00.000000000 -0800
@@ -579,6 +579,9 @@ retry:
 		if (!(f->f_mode & FMODE_WRITE))
 			continue;
 		f->f_mode &= ~FMODE_WRITE;
+		if (file_check_writeable(f) != 0)
+			continue;
+		file_release_write(f);
 		mnt = f->f_path.mnt;
 		file_list_unlock();
 		/*
diff -puN include/linux/fs.h~keep-track-of-mnt_writer-state-of-struct-file include/linux/fs.h
--- linux-2.6.git/include/linux/fs.h~keep-track-of-mnt_writer-state-of-struct-file	2008-02-15 13:26:00.000000000 -0800
+++ linux-2.6.git-dave/include/linux/fs.h	2008-02-15 13:26:00.000000000 -0800
@@ -776,6 +776,9 @@ static inline int ra_has_index(struct fi
 		index <  ra->start + ra->size);
 }
 
+#define FILE_MNT_WRITE_TAKEN	1
+#define FILE_MNT_WRITE_RELEASED	2
+
 struct file {
 	/*
 	 * fu_list becomes invalid after file_free is called and queued via
@@ -810,6 +813,9 @@ struct file {
 	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
+#ifdef CONFIG_DEBUG_WRITECOUNT
+	unsigned long f_mnt_write_state;
+#endif
 };
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);
@@ -818,6 +824,49 @@ extern spinlock_t files_lock;
 #define get_file(x)	atomic_inc(&(x)->f_count)
 #define file_count(x)	atomic_read(&(x)->f_count)
 
+#ifdef CONFIG_DEBUG_WRITECOUNT
+static inline void file_take_write(struct file *f)
+{
+	WARN_ON(f->f_mnt_write_state != 0);
+	f->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
+}
+static inline void file_release_write(struct file *f)
+{
+	f->f_mnt_write_state |= FILE_MNT_WRITE_RELEASED;
+}
+static inline void file_reset_write(struct file *f)
+{
+	f->f_mnt_write_state = 0;
+}
+static inline void file_check_state(struct file *f)
+{
+	/*
+	 * At this point, either both or neither of these bits
+	 * should be set.
+	 */
+	WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN);
+	WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_RELEASED);
+}
+static inline int file_check_writeable(struct file *f)
+{
+	if (f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN)
+		return 0;
+	printk(KERN_WARNING "writeable file with no "
+			    "mnt_want_write()\n");
+	WARN_ON(1);
+	return -EINVAL;
+}
+#else /* !CONFIG_DEBUG_WRITECOUNT */
+static inline void file_take_write(struct file *filp) {}
+static inline void file_release_write(struct file *filp) {}
+static inline void file_reset_write(struct file *filp) {}
+static inline void file_check_state(struct file *filp) {}
+static inline int file_check_writeable(struct file *filp)
+{
+	return 0;
+}
+#endif /* CONFIG_DEBUG_WRITECOUNT */
+
 #define	MAX_NON_LFS	((1UL<<31) - 1)
 
 /* Page cache limit. The filesystems should put that into their s_maxbytes 
diff -puN lib/Kconfig.debug~keep-track-of-mnt_writer-state-of-struct-file lib/Kconfig.debug
--- linux-2.6.git/lib/Kconfig.debug~keep-track-of-mnt_writer-state-of-struct-file	2008-02-15 13:26:00.000000000 -0800
+++ linux-2.6.git-dave/lib/Kconfig.debug	2008-02-15 13:26:00.000000000 -0800
@@ -434,6 +434,16 @@ config DEBUG_VM
 
 	  If unsure, say N.
 
+config DEBUG_WRITECOUNT
+	bool "Debug filesystem writers count"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to catch wrong use of the writers count in struct
+	  vfsmount.  This will increase the size of each file struct by
+	  32 bits.
+
+	  If unsure, say N.
+
 config DEBUG_LIST
 	bool "Debug linked list manipulation"
 	depends on DEBUG_KERNEL
_
