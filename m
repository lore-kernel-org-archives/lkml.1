Return-Path: <linux-kernel-owner+w=401wt.eu-S933174AbXAZLP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbXAZLP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933178AbXAZLP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:15:27 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:34696 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933174AbXAZLPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:15:25 -0500
Date: Fri, 26 Jan 2007 14:21:42 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: akpm@osdl.org
Cc: devel@openvz.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] lutimesat: simplify utime(2)
Message-ID: <20070126112142.GA11128@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite via do_utimes() like compat_sys_utime().

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
---

 fs/utimes.c |   50 +++++++-------------------------------------------
 1 file changed, 7 insertions(+), 43 deletions(-)

--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -22,52 +22,16 @@ #ifdef __ARCH_WANT_SYS_UTIME
  */
 asmlinkage long sys_utime(char __user * filename, struct utimbuf __user * times)
 {
-	int error;
-	struct nameidata nd;
-	struct inode * inode;
-	struct iattr newattrs;
+	struct timeval tv[2];
 
-	error = user_path_walk(filename, &nd);
-	if (error)
-		goto out;
-	inode = nd.dentry->d_inode;
-
-	error = -EROFS;
-	if (IS_RDONLY(inode))
-		goto dput_and_out;
-
-	/* Don't worry, the checks are done in inode_change_ok() */
-	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
-		error = -EPERM;
-		if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-			goto dput_and_out;
-
-		error = get_user(newattrs.ia_atime.tv_sec, &times->actime);
-		newattrs.ia_atime.tv_nsec = 0;
-		if (!error)
-			error = get_user(newattrs.ia_mtime.tv_sec, &times->modtime);
-		newattrs.ia_mtime.tv_nsec = 0;
-		if (error)
-			goto dput_and_out;
-
-		newattrs.ia_valid |= ATTR_ATIME_SET | ATTR_MTIME_SET;
-	} else {
-                error = -EACCES;
-                if (IS_IMMUTABLE(inode))
-                        goto dput_and_out;
-
-		if (current->fsuid != inode->i_uid &&
-		    (error = vfs_permission(&nd, MAY_WRITE)) != 0)
-			goto dput_and_out;
+		if (get_user(tv[0].tv_sec, &times->actime) ||
+		    get_user(tv[1].tv_sec, &times->modtime))
+			return -EFAULT;
+		tv[0].tv_usec = 0;
+		tv[1].tv_usec = 0;
 	}
-	mutex_lock(&inode->i_mutex);
-	error = notify_change(nd.dentry, &newattrs);
-	mutex_unlock(&inode->i_mutex);
-dput_and_out:
-	path_release(&nd);
-out:
-	return error;
+	return do_utimes(AT_FDCWD, filename, times ? tv : NULL);
 }
 
 #endif

