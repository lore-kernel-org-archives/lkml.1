Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbXHBMjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbXHBMjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbXHBMiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:38:17 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:16925 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbXHBMiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:38:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=Y4PCZ83qQ/KxIdn1UFP/S99man4FAZOCZzfIftJdJ0HGvkIh5bbv9mX5Z4xmblB9jX4kT2aa1PyDNg0IpP8Q7r/SoExYk0PisOD0BVbR3b3V7IIvv6q/OvvpROMhJT2sVRT/ofnBf4Mszvs6oEH188uSvrB/V0eQhnTnI9xoB18=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 5/5] sysfs: make sysfs_addrm_finish() return void
In-Reply-To: <11860582821512-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 2 Aug 2007 21:38:03 +0900
Message-Id: <11860582832964-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous sysfs_add_one() update, there is only one user of
the return value of sysfs_addrm_finish() and the user can switch to
testing @sd easily.  Make sysfs_addrm_finish() return void for cleaner
semantics as suggested by Satyam Sharma.

This patch doesn't introduce any noticeable behavior change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 fs/sysfs/dir.c   |    7 +------
 fs/sysfs/inode.c |    7 +++++--
 fs/sysfs/sysfs.h |    2 +-
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 91934e1..3e5acc4 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -609,11 +609,8 @@ static void sysfs_drop_dentry(struct sysfs_dirent *sd)
  *
  *	LOCKING:
  *	All mutexes acquired by sysfs_addrm_start() are released.
- *
- *	RETURNS:
- *	Number of added/removed sysfs_dirents since sysfs_addrm_start().
  */
-int sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
+void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 {
 	/* release resources acquired by sysfs_addrm_start() */
 	mutex_unlock(&sysfs_mutex);
@@ -639,8 +636,6 @@ int sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 		sysfs_deactivate(sd);
 		sysfs_put(sd);
 	}
-
-	return acxt->cnt;
 }
 
 /**
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index f05cda9..e74224e 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -201,7 +201,10 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 	if (sd)
 		sysfs_remove_one(&acxt, sd);
 
-	if (sysfs_addrm_finish(&acxt))
+	sysfs_addrm_finish(&acxt);
+
+	if (sd)
 		return 0;
-	return -ENOENT;
+	else
+		return -ENOENT;
 }
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index bb3f0c9..0436754 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -66,7 +66,7 @@ extern int sysfs_add_one(struct sysfs_addrm_cxt *acxt,
 			  struct sysfs_dirent *sd);
 extern void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
 			     struct sysfs_dirent *sd);
-extern int sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
+extern void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
 
 extern struct inode * sysfs_get_inode(struct sysfs_dirent *sd);
 extern void sysfs_instantiate(struct dentry *dentry, struct inode *inode);
-- 
1.5.0.3


