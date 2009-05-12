Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbZELLAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbZELLAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758856AbZELLAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:00:13 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:36874 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758937AbZELLAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:00:11 -0400
Message-Id: <6.0.0.20.2.20090512195535.071800c8@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Tue, 12 May 2009 19:55:53 +0900
To: Andrew Morton <akpm@linux-foundation.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [RESEND][PATCH] lseek: remove i_mutex
Cc: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

Following patch removes i_mutex from generic_file_llseek.
I think the reason of protecting lseek with i_mutex is just
touching i_size (and f_pos) atomically.
So i_mutex is no longer needed here by introducing i_size_read 
to read i_size.
I also made f_pos access atomic here without i_mutex regarding
former i_mutex holders by introducing file_pos_read/file_pos_write
that use seqlock to preserve atomicity.

Following patch removes i_mutex from generic_file_llseek, and deletes 
generic_file_llseek_nolock totally.

Currently there is i_mutex contention not only around lseek, but also fsync or write.
So,  I think we can mitigate i_mutex contention between fsync lseek and write by
removing i_mutex.

Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.30-rc5.org/fs/cifs/cifsfs.c linux-2.6.30-rc5.lseek/fs/cifs/cifsfs.c
--- linux-2.6.30-rc5.org/fs/cifs/cifsfs.c	2009-05-11 10:07:14.000000000 +0900
+++ linux-2.6.30-rc5.lseek/fs/cifs/cifsfs.c	2009-05-11 10:10:36.000000000 +0900
@@ -635,7 +635,7 @@ static loff_t cifs_llseek(struct file *f
 		if (retval < 0)
 			return (loff_t)retval;
 	}
-	return generic_file_llseek_unlocked(file, offset, origin);
+	return generic_file_llseek(file, offset, origin);
 }
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
diff -Nrup linux-2.6.30-rc5.org/fs/file_table.c linux-2.6.30-rc5.lseek/fs/file_table.c
--- linux-2.6.30-rc5.org/fs/file_table.c	2009-05-11 10:07:14.000000000 +0900
+++ linux-2.6.30-rc5.lseek/fs/file_table.c	2009-05-11 10:10:36.000000000 +0900
@@ -126,6 +126,7 @@ struct file *get_empty_filp(void)
 
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_long_set(&f->f_count, 1);
+	f_pos_ordered_init(f);
 	rwlock_init(&f->f_owner.lock);
 	f->f_cred = get_cred(cred);
 	spin_lock_init(&f->f_lock);
diff -Nrup linux-2.6.30-rc5.org/fs/gfs2/ops_file.c linux-2.6.30-rc5.lseek/fs/gfs2/ops_file.c
--- linux-2.6.30-rc5.org/fs/gfs2/ops_file.c	2009-05-11 10:07:15.000000000 +0900
+++ linux-2.6.30-rc5.lseek/fs/gfs2/ops_file.c	2009-05-11 10:10:36.000000000 +0900
@@ -63,11 +63,11 @@ static loff_t gfs2_llseek(struct file *f
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
 					   &i_gh);
 		if (!error) {
-			error = generic_file_llseek_unlocked(file, offset, origin);
+			error = generic_file_llseek(file, offset, origin);
 			gfs2_glock_dq_uninit(&i_gh);
 		}
 	} else
-		error = generic_file_llseek_unlocked(file, offset, origin);
+		error = generic_file_llseek(file, offset, origin);
 
 	return error;
 }
diff -Nrup linux-2.6.30-rc5.org/fs/ncpfs/file.c linux-2.6.30-rc5.lseek/fs/ncpfs/file.c
--- linux-2.6.30-rc5.org/fs/ncpfs/file.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.30-rc5.lseek/fs/ncpfs/file.c	2009-05-11 10:10:36.000000000 +0900
@@ -286,7 +286,7 @@ static loff_t ncp_remote_llseek(struct f
 {
 	loff_t ret;
 	lock_kernel();
-	ret = generic_file_llseek_unlocked(file, offset, origin);
+	ret = generic_file_llseek(file, offset, origin);
 	unlock_kernel();
 	return ret;
 }
diff -Nrup linux-2.6.30-rc5.org/fs/nfs/file.c linux-2.6.30-rc5.lseek/fs/nfs/file.c
--- linux-2.6.30-rc5.org/fs/nfs/file.c	2009-05-11 10:07:15.000000000 +0900
+++ linux-2.6.30-rc5.lseek/fs/nfs/file.c	2009-05-11 10:10:36.000000000 +0900
@@ -188,10 +188,10 @@ static loff_t nfs_file_llseek(struct fil
 			return (loff_t)retval;
 
 		spin_lock(&inode->i_lock);
-		loff = generic_file_llseek_unlocked(filp, offset, origin);
+		loff = generic_file_llseek(filp, offset, origin);
 		spin_unlock(&inode->i_lock);
 	} else
-		loff = generic_file_llseek_unlocked(filp, offset, origin);
+		loff = generic_file_llseek(filp, offset, origin);
 	return loff;
 }
 
diff -Nrup linux-2.6.30-rc5.org/fs/read_write.c linux-2.6.30-rc5.lseek/fs/read_write.c
--- linux-2.6.30-rc5.org/fs/read_write.c	2009-05-11 10:07:15.000000000 +0900
+++ linux-2.6.30-rc5.lseek/fs/read_write.c	2009-05-11 10:10:36.000000000 +0900
@@ -31,23 +31,61 @@ const struct file_operations generic_ro_
 
 EXPORT_SYMBOL(generic_ro_fops);
 
+static inline loff_t file_pos_read(struct file *file)
+{
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	loff_t pos;
+	unsigned int seq;
+
+	do {
+		seq = read_seqbegin(&file->f_pos_seqlock);
+		pos = file->f_pos;
+	} while (read_seqretry(&file->f_pos_seqlock, seq));
+	return pos;
+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
+	loff_t pos;
+
+	preempt_disable();
+	pos = file->f_pos;
+	preempt_enable();
+	return pos;
+#else
+	return file->f_pos;
+#endif
+}
+
+static inline void file_pos_write(struct file *file, loff_t pos)
+{
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	write_seqlock(&file->f_pos_seqlock);
+	file->f_pos = pos;
+	write_sequnlock(&file->f_pos_seqlock);
+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
+	preempt_disable();
+	file->f_pos = pos;
+	preempt_enable();
+#else
+	file->f_pos = pos;
+#endif
+}
+
 /**
- * generic_file_llseek_unlocked - lockless generic llseek implementation
+ * generic_file_llseek - generic llseek implementation for regular files
  * @file:	file structure to seek on
  * @offset:	file offset to seek to
  * @origin:	type of seek
  *
- * Updates the file offset to the value specified by @offset and @origin.
- * Locking must be provided by the caller.
+ * This is a generic implemenation of ->llseek useable for all normal local
+ * filesystems.  It just updates the file offset to the value specified by
+ * @offset and @origin.
  */
-loff_t
-generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
+loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
 {
 	struct inode *inode = file->f_mapping->host;
 
 	switch (origin) {
 	case SEEK_END:
-		offset += inode->i_size;
+		offset += i_size_read(inode);
 		break;
 	case SEEK_CUR:
 		/*
@@ -57,8 +95,8 @@ generic_file_llseek_unlocked(struct file
 		* write() or lseek() might have altered it
 		*/
 		if (offset == 0)
-			return file->f_pos;
-		offset += file->f_pos;
+			return file_pos_read(file);
+		offset += file_pos_read(file);
 		break;
 	}
 
@@ -66,35 +104,13 @@ generic_file_llseek_unlocked(struct file
 		return -EINVAL;
 
 	/* Special lock needed here? */
-	if (offset != file->f_pos) {
-		file->f_pos = offset;
+	if (offset != file_pos_read(file)) {
+		file_pos_write(file, offset);
 		file->f_version = 0;
 	}
 
 	return offset;
 }
-EXPORT_SYMBOL(generic_file_llseek_unlocked);
-
-/**
- * generic_file_llseek - generic llseek implementation for regular files
- * @file:	file structure to seek on
- * @offset:	file offset to seek to
- * @origin:	type of seek
- *
- * This is a generic implemenation of ->llseek useable for all normal local
- * filesystems.  It just updates the file offset to the value specified by
- * @offset and @origin under i_mutex.
- */
-loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
-{
-	loff_t rval;
-
-	mutex_lock(&file->f_dentry->d_inode->i_mutex);
-	rval = generic_file_llseek_unlocked(file, offset, origin);
-	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
-
-	return rval;
-}
 EXPORT_SYMBOL(generic_file_llseek);
 
 loff_t no_llseek(struct file *file, loff_t offset, int origin)
@@ -359,16 +375,6 @@ ssize_t vfs_write(struct file *file, con
 
 EXPORT_SYMBOL(vfs_write);
 
-static inline loff_t file_pos_read(struct file *file)
-{
-	return file->f_pos;
-}
-
-static inline void file_pos_write(struct file *file, loff_t pos)
-{
-	file->f_pos = pos;
-}
-
 SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
 {
 	struct file *file;
diff -Nrup linux-2.6.30-rc5.org/fs/smbfs/file.c linux-2.6.30-rc5.lseek/fs/smbfs/file.c
--- linux-2.6.30-rc5.org/fs/smbfs/file.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.30-rc5.lseek/fs/smbfs/file.c	2009-05-11 10:10:36.000000000 +0900
@@ -426,7 +426,7 @@ static loff_t smb_remote_llseek(struct f
 {
 	loff_t ret;
 	lock_kernel();
-	ret = generic_file_llseek_unlocked(file, offset, origin);
+	ret = generic_file_llseek(file, offset, origin);
 	unlock_kernel();
 	return ret;
 }
diff -Nrup linux-2.6.30-rc5.org/include/linux/fs.h linux-2.6.30-rc5.lseek/include/linux/fs.h
--- linux-2.6.30-rc5.org/include/linux/fs.h	2009-05-11 10:07:17.000000000 +0900
+++ linux-2.6.30-rc5.lseek/include/linux/fs.h	2009-05-11 10:10:36.000000000 +0900
@@ -896,6 +896,16 @@ static inline int ra_has_index(struct fi
 #define FILE_MNT_WRITE_TAKEN	1
 #define FILE_MNT_WRITE_RELEASED	2
 
+/*
+ * Use sequence lock to get consistent f_pos on 32-bit processors.
+ */
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+#define __NEED_F_POS_ORDERED
+#define f_pos_ordered_init(file) seqlock_init(&file->f_pos_seqlock)
+#else
+#define f_pos_ordered_init(file) do { } while (0)
+#endif
+
 struct file {
 	/*
 	* fu_list becomes invalid after file_free is called and queued via
@@ -914,6 +924,9 @@ struct file {
 	unsigned int 		f_flags;
 	fmode_t			f_mode;
 	loff_t			f_pos;
+#ifdef __NEED_F_POS_ORDERED
+	seqlock_t               f_pos_seqlock;
+#endif
 	struct fown_struct	f_owner;
 	const struct cred	*f_cred;
 	struct file_ra_state	f_ra;
@@ -2215,8 +2228,6 @@ extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
-extern loff_t generic_file_llseek_unlocked(struct file *file, loff_t offset,
-			int origin);
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 

