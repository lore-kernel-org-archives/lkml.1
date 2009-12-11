Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZLKF3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZLKF3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZLKF3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:29:48 -0500
Received: from kroah.org ([198.145.64.141]:53450 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbZLKF3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:29:42 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:43 2009
Message-Id: <20091211052542.664737460@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [05/34] ext4: fix potential buffer head leak when add_dirent_to_buf() returns ENOSPC
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0001-ext4-fix-potential-buffer-head-leak-when-add_dirent_.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit 2de770a406b06dfc619faabbf5d85c835ed3f2e1)

Previously add_dirent_to_buf() did not free its passed-in buffer head
in the case of ENOSPC, since in some cases the caller still needed it.
However, this led to potential buffer head leaks since not all callers
dealt with this correctly.  Fix this by making simplifying the freeing
convention; now add_dirent_to_buf() *never* frees the passed-in buffer
head, and leaves that to the responsibility of its caller.  This makes
things cleaner and easier to prove that the code is neither leaking
buffer heads or calling brelse() one time too many.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/namei.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1292,9 +1292,6 @@ errout:
  * add_dirent_to_buf will attempt search the directory block for
  * space.  It will return -ENOSPC if no space is available, and -EIO
  * and -EEXIST if directory entry already exists.
- *
- * NOTE!  bh is NOT released in the case where ENOSPC is returned.  In
- * all other cases bh is released.
  */
 static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 			     struct inode *inode, struct ext4_dir_entry_2 *de,
@@ -1315,14 +1312,10 @@ static int add_dirent_to_buf(handle_t *h
 		top = bh->b_data + blocksize - reclen;
 		while ((char *) de <= top) {
 			if (!ext4_check_dir_entry("ext4_add_entry", dir, de,
-						  bh, offset)) {
-				brelse(bh);
+						  bh, offset))
 				return -EIO;
-			}
-			if (ext4_match(namelen, name, de)) {
-				brelse(bh);
+			if (ext4_match(namelen, name, de))
 				return -EEXIST;
-			}
 			nlen = EXT4_DIR_REC_LEN(de->name_len);
 			rlen = ext4_rec_len_from_disk(de->rec_len, blocksize);
 			if ((de->inode? rlen - nlen: rlen) >= reclen)
@@ -1337,7 +1330,6 @@ static int add_dirent_to_buf(handle_t *h
 	err = ext4_journal_get_write_access(handle, bh);
 	if (err) {
 		ext4_std_error(dir->i_sb, err);
-		brelse(bh);
 		return err;
 	}
 
@@ -1377,7 +1369,6 @@ static int add_dirent_to_buf(handle_t *h
 	err = ext4_handle_dirty_metadata(handle, dir, bh);
 	if (err)
 		ext4_std_error(dir->i_sb, err);
-	brelse(bh);
 	return 0;
 }
 
@@ -1471,7 +1462,9 @@ static int make_indexed_dir(handle_t *ha
 	if (!(de))
 		return retval;
 
-	return add_dirent_to_buf(handle, dentry, inode, de, bh);
+	retval = add_dirent_to_buf(handle, dentry, inode, de, bh);
+	brelse(bh);
+	return retval;
 }
 
 /*
@@ -1514,8 +1507,10 @@ static int ext4_add_entry(handle_t *hand
 		if(!bh)
 			return retval;
 		retval = add_dirent_to_buf(handle, dentry, inode, NULL, bh);
-		if (retval != -ENOSPC)
+		if (retval != -ENOSPC) {
+			brelse(bh);
 			return retval;
+		}
 
 		if (blocks == 1 && !dx_fallback &&
 		    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX))
@@ -1528,7 +1523,9 @@ static int ext4_add_entry(handle_t *hand
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
 	de->inode = 0;
 	de->rec_len = ext4_rec_len_to_disk(blocksize, blocksize);
-	return add_dirent_to_buf(handle, dentry, inode, de, bh);
+	retval = add_dirent_to_buf(handle, dentry, inode, de, bh);
+	brelse(bh);
+	return retval;
 }
 
 /*
@@ -1561,10 +1558,8 @@ static int ext4_dx_add_entry(handle_t *h
 		goto journal_error;
 
 	err = add_dirent_to_buf(handle, dentry, inode, NULL, bh);
-	if (err != -ENOSPC) {
-		bh = NULL;
+	if (err != -ENOSPC)
 		goto cleanup;
-	}
 
 	/* Block full, should compress but for now just split */
 	dxtrace(printk(KERN_DEBUG "using %u of %u node entries\n",
@@ -1657,7 +1652,6 @@ static int ext4_dx_add_entry(handle_t *h
 	if (!de)
 		goto cleanup;
 	err = add_dirent_to_buf(handle, dentry, inode, de, bh);
-	bh = NULL;
 	goto cleanup;
 
 journal_error:


