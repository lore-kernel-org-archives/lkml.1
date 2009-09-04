Return-Path: <linux-kernel-owner+w=401wt.eu-S933782AbZIDRIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbZIDRIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933563AbZIDRIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:08:50 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39338 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871AbZIDRIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:08:49 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Ciprian Docan <docan@eden.rutgers.edu>,
       "J.R. Okajima" <hooanon05@yahoo.co.jp>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] IMA: update ima_counts_put
Date: Fri,  4 Sep 2009 13:08:46 -0400
Message-Id: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- As ima_counts_put() may be called after the inode has been freed,
verify that the inode is not NULL, before dereferencing it.

- Maintain the IMA file counters in may_open() properly, decrementing
any counter increments on subsequent errors.

Reported-by: Ciprian Docan <docan@eden.rutgers.edu>
Reported-by: J.R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 fs/namei.c                        |   22 +++++++++++++++-------
 security/integrity/ima/ima_main.c |    6 +++++-
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ee01308..fcfc553 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1544,28 +1544,31 @@ int may_open(struct path *path, int acc_mode, int flag)
 	 * An append-only file must be opened in append mode for writing.
 	 */
 	if (IS_APPEND(inode)) {
+		error = -EPERM;
 		if  ((flag & FMODE_WRITE) && !(flag & O_APPEND))
-			return -EPERM;
+			goto err_out;
 		if (flag & O_TRUNC)
-			return -EPERM;
+			goto err_out;
 	}
 
 	/* O_NOATIME can only be set by the owner or superuser */
 	if (flag & O_NOATIME)
-		if (!is_owner_or_cap(inode))
-			return -EPERM;
+		if (!is_owner_or_cap(inode)) {
+			error = -EPERM;
+			goto err_out;
+		}
 
 	/*
 	 * Ensure there are no outstanding leases on the file.
 	 */
 	error = break_lease(inode, flag);
 	if (error)
-		return error;
+		goto err_out;
 
 	if (flag & O_TRUNC) {
 		error = get_write_access(inode);
 		if (error)
-			return error;
+			goto err_out;
 
 		/*
 		 * Refuse to truncate files with mandatory locks held on them.
@@ -1583,12 +1586,17 @@ int may_open(struct path *path, int acc_mode, int flag)
 		}
 		put_write_access(inode);
 		if (error)
-			return error;
+			goto err_out;
 	} else
 		if (flag & FMODE_WRITE)
 			vfs_dq_init(inode);
 
 	return 0;
+err_out:
+	ima_counts_put(path, acc_mode ?
+		       acc_mode & (MAY_READ | MAY_WRITE | MAY_EXEC) :
+		       ACC_MODE(flag) & (MAY_READ | MAY_WRITE));
+	return error;
 }
 
 /*
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 101c512..f0c9634 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -249,7 +249,11 @@ void ima_counts_put(struct path *path, int mask)
 	struct inode *inode = path->dentry->d_inode;
 	struct ima_iint_cache *iint;
 
-	if (!ima_initialized || !S_ISREG(inode->i_mode))
+ 	/* The inode may already have been freed, freeing the iint
+	 * with it. Verify the inode is not NULL before dereferencing
+	 * it.
+	 */
+	if (!ima_initialized || !inode || !S_ISREG(inode->i_mode))
 		return;
 	iint = ima_iint_find_insert_get(inode);
 	if (!iint)
-- 
1.6.0.6

