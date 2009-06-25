Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbZFYI7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbZFYI7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZFYI7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:59:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35274 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZFYI7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:59:39 -0400
Date: Thu, 25 Jun 2009 04:59:34 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, eteo@redhat.com,
       Amerigo Wang <amwang@redhat.com>, viro@zeniv.linux.org.uk,
       esandeen@redhat.com
Message-Id: <20090625090146.6616.9720.sendpatchset@localhost.localdomain>
Subject: [Patch] allow file truncations when both suid and write permissions set
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When suid is set and the non-owner user has write permission,
any writing into this file should be allowed and suid should be
removed after that.

However, current kernel only allows writing without truncations,
when we do truncations on that file, we get EPERM. This is a bug.

Steps to reproduce this bug:

% ls -l rootdir/file1
-rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
% echo h > rootdir/file1
zsh: operation not permitted: rootdir/file1
% ls -l rootdir/file1
-rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
% echo h >> rootdir/file1
% ls -l rootdir/file1
-rwxrwxrwx 1 root root 5 Jun 25 16:34 rootdir/file1

This patch fixes it.

(Need to Cc stable?)

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Eric Sandeen <esandeen@redhat.com>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>

---
diff --git a/fs/open.c b/fs/open.c
index dd98e80..ebf6d8d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -199,7 +199,7 @@ out:
 int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	struct file *filp)
 {
-	int err;
+	int ret;
 	struct iattr newattrs;
 
 	/* Not pretty: "inode->i_size" shouldn't really be signed. But it is. */
@@ -214,12 +214,15 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	}
 
 	/* Remove suid/sgid on truncate too */
-	newattrs.ia_valid |= should_remove_suid(dentry);
+	ret = should_remove_suid(dentry);
+	newattrs.ia_valid |=  ret;
+	if (ret)
+		newattrs.ia_valid |= ATTR_FORCE;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	err = notify_change(dentry, &newattrs);
+	ret = notify_change(dentry, &newattrs);
 	mutex_unlock(&dentry->d_inode->i_mutex);
-	return err;
+	return ret;
 }
 
 static long do_sys_truncate(const char __user *pathname, loff_t length)
