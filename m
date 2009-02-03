Return-Path: <linux-kernel-owner+w=401wt.eu-S1762622AbZBEC2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762622AbZBEC2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZBEC2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:28:12 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59290 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877AbZBEC2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:28:10 -0500
Message-Id: <6.0.0.20.2.20090203165430.06ae1cd8@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Tue, 03 Feb 2009 17:04:40 +0900
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [RESEND] [PATCH] lseek: remove i_mutex
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 
I removed i_mutex from generic_file_llseek.
I think that the reason of protecting lseek with i_mutex is just
touching i_size atomically.

So I introduce i_size_read here so i_mutex is no longer needed.

Following patch removes i_mutex from generic_file_llseek, and deletes 
generic_file_llseek_nolock totally.

Currently there is i_mutex contention not only around lseek, but also fsync or write.
So,  I think we can mitigate i_mutex contention between fsync lseek and write by
removing i_mutex.

Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.29-rc3.org/fs/cifs/cifsfs.c linux-2.6.29-rc3.lseek/fs/cifs/cifsfs.c
--- linux-2.6.29-rc3.org/fs/cifs/cifsfs.c	2009-02-02 16:53:19.000000000 +0900
+++ linux-2.6.29-rc3.lseek/fs/cifs/cifsfs.c	2009-02-02 20:25:33.000000000 +0900
@@ -636,7 +636,7 @@ static loff_t cifs_llseek(struct file *f
 		if (retval < 0)
 			return (loff_t)retval;
 	}
-	return generic_file_llseek_unlocked(file, offset, origin);
+	return generic_file_llseek(file, offset, origin);
 }
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
diff -Nrup linux-2.6.29-rc3.org/fs/gfs2/ops_file.c linux-2.6.29-rc3.lseek/fs/gfs2/ops_file.c
--- linux-2.6.29-rc3.org/fs/gfs2/ops_file.c	2009-02-02 16:53:19.000000000 +0900
+++ linux-2.6.29-rc3.lseek/fs/gfs2/ops_file.c	2009-02-02 20:25:33.000000000 +0900
@@ -62,11 +62,11 @@ static loff_t gfs2_llseek(struct file *f
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
diff -Nrup linux-2.6.29-rc3.org/fs/ncpfs/file.c linux-2.6.29-rc3.lseek/fs/ncpfs/file.c
--- linux-2.6.29-rc3.org/fs/ncpfs/file.c	2008-12-25 08:26:37.000000000 +0900
+++ linux-2.6.29-rc3.lseek/fs/ncpfs/file.c	2009-02-02 20:25:33.000000000 +0900
@@ -286,7 +286,7 @@ static loff_t ncp_remote_llseek(struct f
 {
 	loff_t ret;
 	lock_kernel();
-	ret = generic_file_llseek_unlocked(file, offset, origin);
+	ret = generic_file_llseek(file, offset, origin);
 	unlock_kernel();
 	return ret;
 }
diff -Nrup linux-2.6.29-rc3.org/fs/nfs/file.c linux-2.6.29-rc3.lseek/fs/nfs/file.c
--- linux-2.6.29-rc3.org/fs/nfs/file.c	2009-02-02 16:53:19.000000000 +0900
+++ linux-2.6.29-rc3.lseek/fs/nfs/file.c	2009-02-02 20:25:33.000000000 +0900
@@ -194,10 +194,10 @@ static loff_t nfs_file_llseek(struct fil
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
 
diff -Nrup linux-2.6.29-rc3.org/fs/read_write.c linux-2.6.29-rc3.lseek/fs/read_write.c
--- linux-2.6.29-rc3.org/fs/read_write.c	2009-02-02 16:53:19.000000000 +0900
+++ linux-2.6.29-rc3.lseek/fs/read_write.c	2009-02-02 20:25:33.000000000 +0900
@@ -32,22 +32,23 @@ const struct file_operations generic_ro_
 EXPORT_SYMBOL(generic_ro_fops);
 
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
+	loff_t rval;
 	struct inode *inode = file->f_mapping->host;
 
 	switch (origin) {
 	case SEEK_END:
-		offset += inode->i_size;
+		offset += i_size_read(inode);
 		break;
 	case SEEK_CUR:
 		/*
@@ -70,28 +71,7 @@ generic_file_llseek_unlocked(struct file
 		file->f_pos = offset;
 		file->f_version = 0;
 	}
-
-	return offset;
-}
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
+	rval = offset;
 
 	return rval;
 }
diff -Nrup linux-2.6.29-rc3.org/fs/smbfs/file.c linux-2.6.29-rc3.lseek/fs/smbfs/file.c
--- linux-2.6.29-rc3.org/fs/smbfs/file.c	2009-02-02 16:53:19.000000000 +0900
+++ linux-2.6.29-rc3.lseek/fs/smbfs/file.c	2009-02-02 20:25:33.000000000 +0900
@@ -426,7 +426,7 @@ static loff_t smb_remote_llseek(struct f
 {
 	loff_t ret;
 	lock_kernel();
-	ret = generic_file_llseek_unlocked(file, offset, origin);
+	ret = generic_file_llseek(file, offset, origin);
 	unlock_kernel();
 	return ret;
 }
diff -Nrup linux-2.6.29-rc3.org/include/linux/fs.h linux-2.6.29-rc3.lseek/include/linux/fs.h
--- linux-2.6.29-rc3.org/include/linux/fs.h	2009-02-02 16:53:21.000000000 +0900
+++ linux-2.6.29-rc3.lseek/include/linux/fs.h	2009-02-02 20:25:33.000000000 +0900
@@ -1982,8 +1982,6 @@ extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
-extern loff_t generic_file_llseek_unlocked(struct file *file, loff_t offset,
-			int origin);
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 

