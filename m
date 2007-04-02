Return-Path: <linux-kernel-owner+w=401wt.eu-S965745AbXDBTe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965745AbXDBTe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 15:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965747AbXDBTe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 15:34:28 -0400
Received: from ms-smtp-03.texas.rr.com ([24.93.47.42]:47609 "EHLO
	ms-smtp-03.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965745AbXDBTe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 15:34:27 -0400
Subject: Re: + cifs-remove-unneeded-checks.patch added to -mm tree
From: Steve French <smfrench@austin.rr.com>
To: linux-kernel@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org
In-Reply-To: <OFD0781213.454F562D-ON872572B1.0067861B-862572B1.00679895@us.ibm.com>
References: <OFD0781213.454F562D-ON872572B1.0067861B-862572B1.00679895@us.ibm.com>
Content-Type: multipart/mixed; boundary="=-ig4sXBHbB8VGnrksHwGL"
Date: Mon, 02 Apr 2007 15:36:01 -0500
Message-Id: <1175546161.4306.9.camel@smf-t60p.smfdom>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ig4sXBHbB8VGnrksHwGL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2007-04-02 at 13:51 -0500, Steven French wrote:
> akpm@linux-foundation.org wrote on 03/11/2007 03:57:40 AM:
> 
> > 
> > The patch titled
> >      cifs: remove unneeded checks
> > has been added to the -mm tree.  Its filename is
> >      cifs-remove-unneeded-checks.patch
> > 
> > ------------------------------------------------------
> > Subject: cifs: remove unneeded checks
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > file->f_path.dentry or file->f_path.dentry.d_inode can't be NULL since at
> > least ten years, similar for all but very few arguments passed in from the
> > VFS.

I merged most of Christoph's cifs-remove-unneeded-checks patch into the
cifs-2.6 development tree. The part I did not merge was a little harder
to verify and vaguely reminded me of the old bug report.  The part I
left out is attached (I don't mind leaving that part in mm a little
longer to make sure it is safe).



--=-ig4sXBHbB8VGnrksHwGL
Content-Disposition: attachment; filename=cifs-remove-unneeded-checks-part2.patch
Content-Type: text/x-patch; name=cifs-remove-unneeded-checks-part2.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -Nau /home/stevef/linux-2.6/fs/cifs/file.c /home/stevef/virtfs-2.6/fs/cifs/file.c
--- /home/stevef/linux-2.6/fs/cifs/file.c	2007-04-02 13:55:36.000000000 -0500
+++ /home/stevef/virtfs-2.6/fs/cifs/file.c	2007-04-02 13:48:29.000000000 -0500
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
@@ -831,11 +824,6 @@
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
@@ -868,21 +856,18 @@
 
 	cifs_stats_bytes_written(pTcon, total_written);
 
-	/* since the write may have blocked check these pointers again */
-	if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
-		struct inode *inode = file->f_path.dentry->d_inode;
 /* Do not update local mtime - server will set its actual value on write		
  *		inode->i_ctime = inode->i_mtime = 
  * 			current_fs_time(inode->i_sb);*/
-		if (total_written > 0) {
-			spin_lock(&inode->i_lock);
-			if (*poffset > file->f_path.dentry->d_inode->i_size)
-				i_size_write(file->f_path.dentry->d_inode,
-					*poffset);
-			spin_unlock(&inode->i_lock);
-		}
-		mark_inode_dirty_sync(file->f_path.dentry->d_inode);	
+	if (total_written > 0) {
+		spin_lock(&inode->i_lock);
+		if (*poffset > file->f_path.dentry->d_inode->i_size)
+			i_size_write(file->f_path.dentry->d_inode,
+				*poffset);
+		spin_unlock(&inode->i_lock);
 	}
+	mark_inode_dirty_sync(file->f_path.dentry->d_inode);
+
 	FreeXid(xid);
 	return total_written;
 }
@@ -988,19 +973,17 @@
 	cifs_stats_bytes_written(pTcon, total_written);
 
 	/* since the write may have blocked check these pointers again */
-	if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
 /*BB We could make this contingent on superblock ATIME flag too */
-/*		file->f_path.dentry->d_inode->i_ctime =
-		file->f_path.dentry->d_inode->i_mtime = CURRENT_TIME;*/
-		if (total_written > 0) {
-			spin_lock(&file->f_path.dentry->d_inode->i_lock);
-			if (*poffset > file->f_path.dentry->d_inode->i_size)
-				i_size_write(file->f_path.dentry->d_inode,
-					     *poffset);
-			spin_unlock(&file->f_path.dentry->d_inode->i_lock);
-		}
-		mark_inode_dirty_sync(file->f_path.dentry->d_inode);
+/*	file->f_path.dentry->d_inode->i_ctime =
+	file->f_path.dentry->d_inode->i_mtime = CURRENT_TIME;*/
+	if (total_written > 0) {
+		spin_lock(&file->f_path.dentry->d_inode->i_lock);
+		if (*poffset > file->f_path.dentry->d_inode->i_size)
+			i_size_write(file->f_path.dentry->d_inode,
+				     *poffset);
+		spin_unlock(&file->f_path.dentry->d_inode->i_lock);
 	}
+	mark_inode_dirty_sync(file->f_path.dentry->d_inode);
 	FreeXid(xid);
 	return total_written;
 }
Common subdirectories: /home/stevef/linux-2.6/fs/cifs/.tmp_versions and /home/stevef/virtfs-2.6/fs/cifs/.tmp_versions

--=-ig4sXBHbB8VGnrksHwGL--

