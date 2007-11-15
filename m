Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbXKOMqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbXKOMqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 07:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbXKOMp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 07:45:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416AbXKOMp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 07:45:57 -0500
Date: Thu, 15 Nov 2007 07:45:54 -0500
Message-Id: <200711151245.lAFCjsmX019749@dantu.usersys.redhat.com>
To: linux-cifs-client@lists.samba.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] [CIFS] fix potential data corruption when there are errors writing out dirty pages
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The idea here is separate "conscious" from "unconscious" flushes.
Conscious flushes are those due to a fsync() or close(). Unconscious
ones are flushes that occur as a side effect of some other operation or
due to memory pressure.

Currently, when an error occurs during an unconscious flush (ENOSPC or
EIO), we toss out the page and don't preserve that error to report to
the user when a conscious flush occurs. If after the unconscious flush,
there are no more dirty pages for the inode, the conscious flush will
simply return success even though there were previous errors when writing
out pages. This can lead to data corruption.

The easiest way to reproduce this is to mount up a CIFS share that's
very close to being full or where the user is very close to quota. mv
a file to the share that's slightly larger than the quota allows. The
writes will all succeed (since they go to pagecache). The mv will do a
setattr to set the new file's attributes. This calls filemap_write_and_wait,
which will return an error since all of the pages can't be written out.
Then later, when the flush and release ops occur, there are no more
dirty pages in pagecache for the file and those operations return 0. mv
then assumes that the file was written out correctly and deletes the
original.

CIFS already has a write_behind_rc variable where it stores the results
from earlier flushes, but that value is only reported in cifs_close.
Since the VFS ignores the return value from the release operation, this
isn't helpful. We should be reporting this error during the flush
operation.

This patch does the following:

1) changes cifs_flush and cifs_fsync to use filemap_write_and_wait and
to check its return code. If it returns successful, they then check the
value of write_behind_rc to see if an earlier flush had reported any
errors. If so, they return that error and clear write_behind_rc.

2) sets write_behind_rc in a few other places where pages are written
out as a side effect of other operations and the code waits on them.

3) changes cifs_setattr to only call filemap_write_and_wait for
ATTR_SIZE changes.

4) makes cifs_writepages accurately distinguish between EIO and ENOSPC
errors when writing out pages.

Some simple testing indicates that the patch works as expected and that
it fixes the reproducer for the known problem.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsfs.c |    7 +++++--
 fs/cifs/file.c   |   26 +++++++++++++++++++-------
 fs/cifs/inode.c  |   26 ++++++++++++++++++++------
 3 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 416dc9f..093beaa 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -266,6 +266,7 @@ cifs_alloc_inode(struct super_block *sb)
 	cifs_inode->cifsAttrs = 0x20;	/* default */
 	atomic_set(&cifs_inode->inUse, 0);
 	cifs_inode->time = 0;
+	cifs_inode->write_behind_rc = 0;
 	/* Until the file is open and we have gotten oplock
 	info back from the server, can not assume caching of
 	file data or metadata */
@@ -852,7 +853,7 @@ static int cifs_oplock_thread(void *dummyarg)
 	struct cifsTconInfo *pTcon;
 	struct inode *inode;
 	__u16  netfid;
-	int rc;
+	int rc, waitrc = 0;
 
 	set_freezable();
 	do {
@@ -884,9 +885,11 @@ static int cifs_oplock_thread(void *dummyarg)
 					   filemap_fdatawrite(inode->i_mapping);
 					if (CIFS_I(inode)->clientCanCacheRead
 									 == 0) {
-						filemap_fdatawait(inode->i_mapping);
+						waitrc = filemap_fdatawait(inode->i_mapping);
 						invalidate_remote_inode(inode);
 					}
+					if (rc == 0)
+						rc = waitrc;
 				} else
 					rc = 0;
 				/* mutex_unlock(&inode->i_mutex);*/
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 82326d2..a28dbbd 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -130,7 +130,9 @@ static inline int cifs_open_inode_helper(struct inode *inode, struct file *file,
 		if (file->f_path.dentry->d_inode->i_mapping) {
 		/* BB no need to lock inode until after invalidate
 		   since namei code should already have it locked? */
-			filemap_write_and_wait(file->f_path.dentry->d_inode->i_mapping);
+			rc = filemap_write_and_wait(file->f_path.dentry->d_inode->i_mapping);
+			if (rc != 0)
+				CIFS_I(file->f_path.dentry->d_inode)->write_behind_rc = rc;
 		}
 		cFYI(1, ("invalidating remote inode since open detected it "
 			 "changed"));
@@ -425,7 +427,9 @@ reopen_error_exit:
 		pCifsInode = CIFS_I(inode);
 		if (pCifsInode) {
 			if (can_flush) {
-				filemap_write_and_wait(inode->i_mapping);
+				rc = filemap_write_and_wait(inode->i_mapping);
+				if (rc != 0)
+					CIFS_I(inode)->write_behind_rc = rc;
 			/* temporarily disable caching while we
 			   go to server to get inode info */
 				pCifsInode->clientCanCacheAll = FALSE;
@@ -1367,7 +1371,10 @@ retry:
 						  rc, bytes_written));
 					/* BB what if continued retry is
 					   requested via mount flags? */
-					set_bit(AS_EIO, &mapping->flags);
+					if (rc == -ENOSPC)
+						set_bit(AS_ENOSPC, &mapping->flags);
+					else
+						set_bit(AS_EIO, &mapping->flags);
 				} else {
 					cifs_stats_bytes_written(cifs_sb->tcon,
 								 bytes_written);
@@ -1499,9 +1506,11 @@ int cifs_fsync(struct file *file, struct dentry *dentry, int datasync)
 	cFYI(1, ("Sync file - name: %s datasync: 0x%x",
 		dentry->d_name.name, datasync));
 
-	rc = filemap_fdatawrite(inode->i_mapping);
-	if (rc == 0)
+	rc = filemap_write_and_wait(inode->i_mapping);
+	if (rc == 0) {
+		rc = CIFS_I(inode)->write_behind_rc;
 		CIFS_I(inode)->write_behind_rc = 0;
+	}
 	FreeXid(xid);
 	return rc;
 }
@@ -1552,9 +1561,12 @@ int cifs_flush(struct file *file, fl_owner_t id)
 	   unlock inode for writing
 	   filemapfdatawrite appears easier for the time being */
 
-	rc = filemap_fdatawrite(inode->i_mapping);
-	if (!rc) /* reset wb rc if we were able to write out dirty pages */
+	rc = filemap_write_and_wait(inode->i_mapping);
+	/* reset wb rc if we were able to write out dirty pages */
+	if (!rc) {
+		rc = CIFS_I(inode)->write_behind_rc;
 		CIFS_I(inode)->write_behind_rc = 0;
+	}
 
 	cFYI(1, ("Flush inode %p file %p rc %d", inode, file, rc));
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 7d907e8..e915eb1 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1233,7 +1233,7 @@ cifs_rename_exit:
 int cifs_revalidate(struct dentry *direntry)
 {
 	int xid;
-	int rc = 0;
+	int rc = 0, wbrc = 0;
 	char *full_path;
 	struct cifs_sb_info *cifs_sb;
 	struct cifsInodeInfo *cifsInode;
@@ -1333,7 +1333,9 @@ int cifs_revalidate(struct dentry *direntry)
 	if (direntry->d_inode->i_mapping) {
 		/* do we need to lock inode until after invalidate completes
 		   below? */
-		filemap_fdatawrite(direntry->d_inode->i_mapping);
+		wbrc = filemap_fdatawrite(direntry->d_inode->i_mapping);
+		if (wbrc)
+			CIFS_I(direntry->d_inode)->write_behind_rc = wbrc;
 	}
 	if (invalidate_inode) {
 	/* shrink_dcache not necessary now that cifs dentry ops
@@ -1342,7 +1344,9 @@ int cifs_revalidate(struct dentry *direntry)
 			shrink_dcache_parent(direntry); */
 		if (S_ISREG(direntry->d_inode->i_mode)) {
 			if (direntry->d_inode->i_mapping)
-				filemap_fdatawait(direntry->d_inode->i_mapping);
+				wbrc = filemap_fdatawait(direntry->d_inode->i_mapping);
+				if (wbrc)
+					CIFS_I(direntry->d_inode)->write_behind_rc = wbrc;
 			/* may eventually have to do this for open files too */
 			if (list_empty(&(cifsInode->openFileList))) {
 				/* changed on server - flush read ahead pages */
@@ -1485,10 +1489,20 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 
 	/* BB check if we need to refresh inode from server now ? BB */
 
-	/* need to flush data before changing file size on server */
-	filemap_write_and_wait(direntry->d_inode->i_mapping);
-
 	if (attrs->ia_valid & ATTR_SIZE) {
+		/*
+		   Flush data before changing file size on server. If the
+		   flush returns error, store it to report later and continue.
+		   BB: This should be smarter. Why bother flushing pages that
+		   will be truncated anyway? Also, should we error out here if
+		   the flush returns error?
+		 */
+		rc = filemap_write_and_wait(direntry->d_inode->i_mapping);
+		if (rc != 0) {
+			CIFS_I(direntry->d_inode)->write_behind_rc = rc;
+			rc = 0;
+		}
+
 		/* To avoid spurious oplock breaks from server, in the case of
 		   inodes that we already have open, avoid doing path based
 		   setting of file size if we can do it by handle.
-- 
1.5.3.3

