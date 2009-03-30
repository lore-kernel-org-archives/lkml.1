Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbZC3S2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbZC3S2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbZC3SQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:16:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbZC3SPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:15:16 -0400
Message-Id: <20090330181011.080528326@suse.com>
User-Agent: quilt/0.47-14.9
Date: Mon, 30 Mar 2009 14:02:29 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 14/35 xattr-rework] reiserfs: small variable cleanup
References: <20090330180215.951354436@suse.com>
Content-Disposition: inline; filename=patches.suse/reiserfs-remove-xinode
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch removes the xinode and mapping variables from
 reiserfs_xattr_{get,set}.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/xattr.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -420,10 +420,8 @@ reiserfs_xattr_set(struct inode *inode,
 	struct dentry *dentry;
 	struct page *page;
 	char *data;
-	struct address_space *mapping;
 	size_t file_pos = 0;
 	size_t buffer_pos = 0;
-	struct inode *xinode;
 	struct iattr newattrs;
 	__u32 xahash = 0;
 
@@ -441,11 +439,10 @@ reiserfs_xattr_set(struct inode *inode,
 		goto out;
 	}
 
-	xinode = dentry->d_inode;
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
 	/* we need to copy it off.. */
-	if (xinode->i_nlink > 1) {
+	if (dentry->d_inode->i_nlink > 1) {
 		dput(dentry);
 		err = reiserfs_xattr_del(inode, name);
 		if (err < 0)
@@ -459,12 +456,11 @@ reiserfs_xattr_set(struct inode *inode,
 	/* Resize it so we're ok to write there */
 	newattrs.ia_size = buffer_size;
 	newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
-	mutex_lock_nested(&xinode->i_mutex, I_MUTEX_XATTR);
+	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_XATTR);
 	err = notify_change(dentry, &newattrs);
 	if (err)
 		goto out_filp;
 
-	mapping = xinode->i_mapping;
 	while (buffer_pos < buffer_size || buffer_pos == 0) {
 		size_t chunk;
 		size_t skip = 0;
@@ -474,7 +470,8 @@ reiserfs_xattr_set(struct inode *inode,
 		else
 			chunk = buffer_size - buffer_pos;
 
-		page = reiserfs_get_page(xinode, file_pos >> PAGE_CACHE_SHIFT);
+		page = reiserfs_get_page(dentry->d_inode,
+					 file_pos >> PAGE_CACHE_SHIFT);
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
 			goto out_filp;
@@ -521,7 +518,7 @@ reiserfs_xattr_set(struct inode *inode,
 	}
 
       out_filp:
-	mutex_unlock(&xinode->i_mutex);
+	mutex_unlock(&dentry->d_inode->i_mutex);
 	dput(dentry);
 
       out:
@@ -541,7 +538,6 @@ reiserfs_xattr_get(const struct inode *i
 	size_t file_pos = 0;
 	size_t buffer_pos = 0;
 	struct page *page;
-	struct inode *xinode;
 	__u32 hash = 0;
 
 	if (name == NULL)
@@ -558,8 +554,7 @@ reiserfs_xattr_get(const struct inode *i
 		goto out;
 	}
 
-	xinode = dentry->d_inode;
-	isize = xinode->i_size;
+	isize = i_size_read(dentry->d_inode);
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
 	/* Just return the size needed */
@@ -582,7 +577,8 @@ reiserfs_xattr_get(const struct inode *i
 		else
 			chunk = isize - file_pos;
 
-		page = reiserfs_get_page(xinode, file_pos >> PAGE_CACHE_SHIFT);
+		page = reiserfs_get_page(dentry->d_inode,
+					 file_pos >> PAGE_CACHE_SHIFT);
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
 			goto out_dput;


