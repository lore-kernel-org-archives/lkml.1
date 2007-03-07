Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXCGP37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXCGP37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbXCGP37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:29:59 -0500
Received: from verein.lst.de ([213.95.11.210]:47398 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbXCGP34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:29:56 -0500
Date: Wed, 7 Mar 2007 16:29:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: sfrench@samba.org
Cc: linux-cifs-client@lists.samba.org, samba-technical@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: remove useless cargo-cult checks
Message-ID: <20070307152912.GA15650@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

file->f_path.dentry or file->f_path.dentry.d_inode can't be NULL since at
least ten years, similar for all but very few arguments passed in from
the VFS.

Btw, it would be nice if all CIFS updates could be Cc'ed to lkml to
fix things like this or the horrible codingstyle before it hits the
tree.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.orig/fs/cifs/cifsfs.c	2007-03-06 11:14:24.000000000 +0100
+++ linux-2.6/fs/cifs/cifsfs.c	2007-03-06 11:14:53.000000000 +0100
@@ -521,8 +521,7 @@
 		/* some applications poll for the file length in this strange
 		   way so we must seek to end on non-oplocked files by
 		   setting the revalidate time to zero */
-		if(file->f_path.dentry->d_inode)		
-			CIFS_I(file->f_path.dentry->d_inode)->time = 0;
+		CIFS_I(file->f_path.dentry->d_inode)->time = 0;
 
 		retval = cifs_revalidate(file->f_path.dentry);
 		if (retval < 0)
Index: linux-2.6/fs/cifs/file.c
===================================================================
--- linux-2.6.orig/fs/cifs/file.c	2007-03-06 11:07:31.000000000 +0100
+++ linux-2.6/fs/cifs/file.c	2007-03-06 11:13:04.000000000 +0100
@@ -352,8 +352,6 @@
 	int disposition = FILE_OPEN;
 	__u16 netfid;
 
-	if (inode == NULL)
-		return -EBADF;
 	if (file->private_data) {
 		pCifsFile = (struct cifsFileInfo *)file->private_data;
 	} else
@@ -367,12 +365,6 @@
 		return 0;
 	}
 
-	if (file->f_path.dentry == NULL) {
-		up(&pCifsFile->fh_sem);
-		cFYI(1, ("failed file reopen, no valid name if dentry freed"));
-		FreeXid(xid);
-		return -EBADF;
-	}
 	cifs_sb = CIFS_SB(inode->i_sb);
 	pTcon = cifs_sb->tcon;
 /* can not grab rename sem here because various ops, including
@@ -784,6 +776,7 @@
 ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 	size_t write_size, loff_t *poffset)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int rc = 0;
 	unsigned int bytes_written = 0;
 	unsigned int total_written;
@@ -792,12 +785,7 @@
 	int xid, long_op;
 	struct cifsFileInfo *open_file;
 
-	if (file->f_path.dentry == NULL)
-		return -EBADF;
-
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	if (cifs_sb == NULL)
-		return -EBADF;
 
 	pTcon = cifs_sb->tcon;
 
@@ -807,14 +795,9 @@
 
 	if (file->private_data == NULL)
 		return -EBADF;
-	else
-		open_file = (struct cifsFileInfo *) file->private_data;
+	open_file = (struct cifsFileInfo *) file->private_data;
 	
 	xid = GetXid();
-	if (file->f_path.dentry->d_inode == NULL) {
-		FreeXid(xid);
-		return -EBADF;
-	}
 
 	if (*poffset > file->f_path.dentry->d_inode->i_size)
 		long_op = 2; /* writes past end of file can take a long time */
@@ -841,11 +824,6 @@
 					return -EBADF;
 			}
 			if (open_file->invalidHandle) {
-				if ((file->f_path.dentry == NULL) ||
-				    (file->f_path.dentry->d_inode == NULL)) {
-					FreeXid(xid);
-					return total_written;
-				}
 				/* we could deadlock if we called
 				   filemap_fdatawait from here so tell
 				   reopen_file not to flush data to server
@@ -878,20 +856,15 @@
 
 	cifs_stats_bytes_written(pTcon, total_written);
 
-	/* since the write may have blocked check these pointers again */
-	if (file->f_path.dentry) {
-		if (file->f_path.dentry->d_inode) {
-			struct inode *inode = file->f_path.dentry->d_inode;
-			inode->i_ctime = inode->i_mtime =
-				current_fs_time(inode->i_sb);
-			if (total_written > 0) {
-				if (*poffset > file->f_path.dentry->d_inode->i_size)
-					i_size_write(file->f_path.dentry->d_inode,
-					*poffset);
-			}
-			mark_inode_dirty_sync(file->f_path.dentry->d_inode);
-		}
+	inode->i_ctime = inode->i_mtime =
+		current_fs_time(inode->i_sb);
+	if (total_written > 0) {
+		if (*poffset > file->f_path.dentry->d_inode->i_size)
+			i_size_write(file->f_path.dentry->d_inode,
+			*poffset);
 	}
+	mark_inode_dirty_sync(file->f_path.dentry->d_inode);
+
 	FreeXid(xid);
 	return total_written;
 }
@@ -907,12 +880,7 @@
 	int xid, long_op;
 	struct cifsFileInfo *open_file;
 
-	if (file->f_path.dentry == NULL)
-		return -EBADF;
-
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	if (cifs_sb == NULL)
-		return -EBADF;
 
 	pTcon = cifs_sb->tcon;
 
@@ -921,14 +889,9 @@
 
 	if (file->private_data == NULL)
 		return -EBADF;
-	else
-		open_file = (struct cifsFileInfo *)file->private_data;
+	open_file = (struct cifsFileInfo *)file->private_data;
 	
 	xid = GetXid();
-	if (file->f_path.dentry->d_inode == NULL) {
-		FreeXid(xid);
-		return -EBADF;
-	}
 
 	if (*poffset > file->f_path.dentry->d_inode->i_size)
 		long_op = 2; /* writes past end of file can take a long time */
@@ -956,11 +919,6 @@
 					return -EBADF;
 			}
 			if (open_file->invalidHandle) {
-				if ((file->f_path.dentry == NULL) ||
-				   (file->f_path.dentry->d_inode == NULL)) {
-					FreeXid(xid);
-					return total_written;
-				}
 				/* we could deadlock if we called
 				   filemap_fdatawait from here so tell
 				   reopen_file not to flush data to 
@@ -1011,20 +969,16 @@
 
 	cifs_stats_bytes_written(pTcon, total_written);
 
-	/* since the write may have blocked check these pointers again */
-	if (file->f_path.dentry) {
-		if (file->f_path.dentry->d_inode) {
 /*BB We could make this contingent on superblock ATIME flag too */
-/*			file->f_path.dentry->d_inode->i_ctime =
-			file->f_path.dentry->d_inode->i_mtime = CURRENT_TIME;*/
-			if (total_written > 0) {
-				if (*poffset > file->f_path.dentry->d_inode->i_size)
-					i_size_write(file->f_path.dentry->d_inode,
-						     *poffset);
-			}
-			mark_inode_dirty_sync(file->f_path.dentry->d_inode);
-		}
+/*	file->f_path.dentry->d_inode->i_ctime =
+	file->f_path.dentry->d_inode->i_mtime = CURRENT_TIME;*/
+	if (total_written > 0) {
+		if (*poffset > file->f_path.dentry->d_inode->i_size)
+			i_size_write(file->f_path.dentry->d_inode,
+				     *poffset);
 	}
+	mark_inode_dirty_sync(file->f_path.dentry->d_inode);
+
 	FreeXid(xid);
 	return total_written;
 }
Index: linux-2.6/fs/cifs/readdir.c
===================================================================
--- linux-2.6.orig/fs/cifs/readdir.c	2007-03-06 11:13:19.000000000 +0100
+++ linux-2.6/fs/cifs/readdir.c	2007-03-06 11:14:20.000000000 +0100
@@ -436,9 +436,6 @@
 	cifsFile->invalidHandle = TRUE;
 	cifsFile->srch_inf.endOfSearch = FALSE;
 
-	if(file->f_path.dentry == NULL)
-		return -ENOENT;
-
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	if(cifs_sb == NULL)
 		return -EINVAL;
@@ -610,20 +607,10 @@
    whether we can use the cached search results from the previous search */
 static int is_dir_changed(struct file * file)
 {
-	struct inode * inode;
-	struct cifsInodeInfo *cifsInfo;
-
-	if(file->f_path.dentry == NULL)
-		return 0;
-
-	inode = file->f_path.dentry->d_inode;
-
-	if(inode == NULL)
-		return 0;
-
-	cifsInfo = CIFS_I(inode);
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct cifsInodeInfo *cifsInfo = CIFS_I(inode);
 
-	if(cifsInfo->time == 0)
+	if (cifsInfo->time == 0)
 		return 1; /* directory was changed, perhaps due to unlink */
 	else
 		return 0;
@@ -843,9 +830,6 @@
 	if((scratch_buf == NULL) || (pfindEntry == NULL) || (pCifsF == NULL))
 		return -ENOENT;
 
-	if(file->f_path.dentry == NULL)
-		return -ENOENT;
-
 	rc = cifs_entry_is_dot(pfindEntry,pCifsF);
 	/* skip . and .. since we added them first */
 	if(rc != 0) 
@@ -989,11 +973,6 @@
 
 	xid = GetXid();
 
-	if(file->f_path.dentry == NULL) {
-		FreeXid(xid);
-		return -EIO;
-	}
-
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	pTcon = cifs_sb->tcon;
 	if(pTcon == NULL)
