Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbXGaKRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbXGaKRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbXGaKPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:15:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:39291 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbXGaKPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:15:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=dfiZmDnmNihj+rjlGCZezBcrGDUh6kzzJG7ChIotDh8C/+nKvXndDnXpJHL5ALHifI1G2LmX9C0KoAR7FsLdVFnIaa3G/wrhI9eflKy0kwXq2W1TeodA20AN2SFpavwEopqNKPQ2AgEpbSJce5mY87ieTMQ7S/WkVujVWREK1CU=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 7/7] sysfs: make sysfs_addrm_finish() return void
In-Reply-To: <11858769082982-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 31 Jul 2007 19:15:09 +0900
Message-Id: <11858769093479-git-send-email-htejun@gmail.com>
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
---
 fs/sysfs/dir.c   |    7 +------
 fs/sysfs/inode.c |    7 +++++--
 fs/sysfs/sysfs.h |    2 +-
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 69e57be..f9523c8 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -608,11 +608,8 @@ static void sysfs_drop_dentry(struct sysfs_dirent *sd)
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
@@ -638,8 +635,6 @@ int sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
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


