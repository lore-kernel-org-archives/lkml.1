Return-Path: <linux-kernel-owner+w=401wt.eu-S1946149AbXBIWzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946149AbXBIWzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946220AbXBIWyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:54:25 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51881 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423368AbXBIWxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:42 -0500
Subject: [PATCH 14/22] elevate write count for do_utimes()
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:39 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225339.8CFE245E@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/utimes.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN fs/utimes.c~16-24-elevate-write-count-for-do-utimes fs/utimes.c
--- lxc/fs/utimes.c~16-24-elevate-write-count-for-do-utimes	2007-02-09 14:26:55.000000000 -0800
+++ lxc-dave/fs/utimes.c	2007-02-09 14:26:55.000000000 -0800
@@ -58,16 +58,19 @@ static long do_utimes_nsec(int dfd, char
 		goto out;
 	inode = nd.dentry->d_inode;
 
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto dput_and_out;
 	error = -EROFS;
 	if (IS_RDONLY(inode))
-		goto dput_and_out;
+		goto mnt_drop_write_and_out;
 
 	/* Don't worry, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
 		error = -EPERM;
                 if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-                        goto dput_and_out;
+			goto mnt_drop_write_and_out;
 
 		newattrs.ia_atime = times[0];
 		newattrs.ia_mtime = times[1];
@@ -75,15 +78,17 @@ static long do_utimes_nsec(int dfd, char
 	} else {
 		error = -EACCES;
                 if (IS_IMMUTABLE(inode))
-                        goto dput_and_out;
+			goto mnt_drop_write_and_out;
 
 		if (current->fsuid != inode->i_uid &&
 		    (error = vfs_permission(&nd, MAY_WRITE)) != 0)
-			goto dput_and_out;
+			goto mnt_drop_write_and_out;
 	}
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(nd.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
+mnt_drop_write_and_out:
+	mnt_drop_write(nd.mnt);
 dput_and_out:
 	path_release(&nd);
 out:
_
