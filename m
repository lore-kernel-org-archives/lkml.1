Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZC3SRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZC3SRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbZC3SPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:15:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbZC3SPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:15:16 -0400
Message-Id: <20090330181011.335919655@suse.com>
User-Agent: quilt/0.47-14.9
Date: Mon, 30 Mar 2009 14:02:31 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 16/35 xattr-rework] reiserfs: remove link detection code
References: <20090330180215.951354436@suse.com>
Content-Disposition: inline; filename=patches.suse/reiserfs-remove-link-detection.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Early in the reiserfs xattr development, there was a plan to use hardlinks
 to save disk space for identical xattrs. That code never materialized and
 isn't going to, so this patch removes the detection code.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---
 fs/reiserfs/xattr.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -432,7 +432,6 @@ reiserfs_xattr_set(struct inode *inode,
 	if (buffer && buffer_size)
 		xahash = xattr_hash(buffer, buffer_size);
 
-      open_file:
 	dentry = get_xa_file_dentry(inode, name, flags);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
@@ -441,18 +440,6 @@ reiserfs_xattr_set(struct inode *inode,
 
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
-	/* we need to copy it off.. */
-	if (dentry->d_inode->i_nlink > 1) {
-		dput(dentry);
-		err = reiserfs_xattr_del(inode, name);
-		if (err < 0)
-			goto out;
-		/* We just killed the old one, we're not replacing anymore */
-		if (flags & XATTR_REPLACE)
-			flags &= ~XATTR_REPLACE;
-		goto open_file;
-	}
-
 	/* Resize it so we're ok to write there */
 	newattrs.ia_size = buffer_size;
 	newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;


