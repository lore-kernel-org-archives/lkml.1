Return-Path: <linux-kernel-owner+w=401wt.eu-S933513AbXJLWc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbXJLWc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXJLWTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:35 -0400
Received: from ns1.suse.de ([195.135.220.2]:53247 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbXJLWTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Satyam Sharma <satyam.sharma@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/75] sysfs: make sysfs_addrm_finish() return void
Date: Fri, 12 Oct 2007 15:16:29 -0700
Message-Id: <11922275552558-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227551156-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

With the previous sysfs_add_one() update, there is only one user of
the return value of sysfs_addrm_finish() and the user can switch to
testing @sd easily.  Make sysfs_addrm_finish() return void for cleaner
semantics as suggested by Satyam Sharma.

This patch doesn't introduce any noticeable behavior change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |    7 +------
 fs/sysfs/inode.c |    7 +++++--
 fs/sysfs/sysfs.h |    2 +-
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 6206032..a0da2b0 100644
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
index efb4062..e22db6c 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -200,7 +200,10 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
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
1.5.3.4

