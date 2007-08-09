Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbXHIJ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbXHIJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938743AbXHIJ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:26:19 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:48277 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764986AbXHIJ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:26:18 -0400
Message-Id: <20070809092459.676107488@szeredi.hu>
References: <20070809092046.656183199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 11:20:49 +0200
From: miklos@szeredi.hu
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 3/9] fix execute checking in permission()
Content-Disposition: inline; filename=permission_exec_fix.patch
CC: Christoph Hellwig <hch@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

permission() checks that MAY_EXEC is only allowed on regular files if
at least one execute bit is set in the file mode.

generic_permission() already ensures this, so the extra check in
permission() is superfluous.

If the filesystem defines it's own ->permission() the check may still
be needed.  In this case move it after ->permission().  This is needed
because filesystems such as FUSE may need to refresh the inode
attributes before checking permissions.

This check should be moved inside ->permission(), but that's another
story.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/namei.c
===================================================================
--- linux.orig/fs/namei.c	2007-08-09 11:01:55.000000000 +0200
+++ linux/fs/namei.c	2007-08-09 11:04:22.000000000 +0200
@@ -227,10 +227,10 @@ int generic_permission(struct inode *ino
 
 int permission(struct inode *inode, int mask, struct nameidata *nd)
 {
-	umode_t mode = inode->i_mode;
 	int retval, submask;
 
 	if (mask & MAY_WRITE) {
+		umode_t mode = inode->i_mode;
 
 		/*
 		 * Nobody gets write access to a read-only fs.
@@ -246,22 +246,34 @@ int permission(struct inode *inode, int 
 			return -EACCES;
 	}
 
-
-	/*
-	 * MAY_EXEC on regular files requires special handling: We override
-	 * filesystem execute permissions if the mode bits aren't set or
-	 * the fs is mounted with the "noexec" flag.
-	 */
-	if ((mask & MAY_EXEC) && S_ISREG(mode) && (!(mode & S_IXUGO) ||
-			(nd && nd->mnt && (nd->mnt->mnt_flags & MNT_NOEXEC))))
-		return -EACCES;
+	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode)) {
+		/*
+		 * MAY_EXEC on regular files is denied if the fs is mounted
+		 * with the "noexec" flag.
+		 */
+		if (nd && nd->mnt && (nd->mnt->mnt_flags & MNT_NOEXEC))
+			return -EACCES;
+	}
 
 	/* Ordinary permission routines do not understand MAY_APPEND. */
 	submask = mask & ~MAY_APPEND;
-	if (inode->i_op && inode->i_op->permission)
+	if (inode->i_op && inode->i_op->permission) {
 		retval = inode->i_op->permission(inode, submask, nd);
-	else
+		if (!retval) {
+			/*
+			 * Exec permission on a regular file is denied if none
+			 * of the execute bits are set.
+			 *
+			 * This check should be done by the ->permission()
+			 * method.
+			 */
+			if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode) &&
+			    !(inode->i_mode & S_IXUGO))
+				return -EACCES;
+		}
+	} else {
 		retval = generic_permission(inode, submask, NULL);
+	}
 	if (retval)
 		return retval;
 

--
