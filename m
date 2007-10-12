Return-Path: <linux-kernel-owner+w=401wt.eu-S933422AbXJLWsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422AbXJLWsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932757AbXJLWVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:21:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614AbXJLWVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:21:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <htejun@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 50/75] sysfs: Rewrite sysfs_move_dir in terms of sysfs dirents
Date: Fri, 12 Oct 2007 15:16:54 -0700
Message-Id: <11922276763650-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227671143-git-send-email-gregkh@suse.de>
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
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
 <11922276672660-git-send-email-gregkh@suse.de>
 <1192227671143-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This patch rewrites sysfs_move_dir to perform it's checks
as much as possible on the underlying sysfs_dirents instead
of the contents of the dcache, making sysfs_move_dir
more like the rest of the sysfs directory modification
code.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 463c5e3..da4bb66 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -845,56 +845,58 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 	BUG_ON(!sd->s_parent);
 	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
 
+	error = 0;
+	if (sd->s_parent == new_parent_sd)
+		goto out;	/* nothing to move */
+
 	/* get dentries */
 	old_dentry = sysfs_get_dentry(sd);
 	if (IS_ERR(old_dentry)) {
 		error = PTR_ERR(old_dentry);
-		goto out_dput;
+		goto out;
 	}
 	old_parent = old_dentry->d_parent;
 
 	new_parent = sysfs_get_dentry(new_parent_sd);
 	if (IS_ERR(new_parent)) {
 		error = PTR_ERR(new_parent);
-		goto out_dput;
+		goto out;
 	}
 
-	if (old_parent->d_inode == new_parent->d_inode) {
-		error = 0;
-		goto out_dput;	/* nothing to move */
-	}
 again:
 	mutex_lock(&old_parent->d_inode->i_mutex);
 	if (!mutex_trylock(&new_parent->d_inode->i_mutex)) {
 		mutex_unlock(&old_parent->d_inode->i_mutex);
 		goto again;
 	}
+	mutex_lock(&sysfs_mutex);
 
-	new_dentry = lookup_one_len(kobject_name(kobj), new_parent, strlen(kobject_name(kobj)));
-	if (IS_ERR(new_dentry)) {
-		error = PTR_ERR(new_dentry);
+	error = -EEXIST;
+	if (sysfs_find_dirent(new_parent_sd, sd->s_name))
 		goto out_unlock;
-	} else
-		error = 0;
+
+	error = -ENOMEM;
+	new_dentry = d_alloc_name(new_parent, sd->s_name);
+	if (!new_dentry)
+		goto out_unlock;
+
+	error = 0;
 	d_add(new_dentry, NULL);
 	d_move(old_dentry, new_dentry);
 	dput(new_dentry);
 
 	/* Remove from old parent's list and insert into new parent's list. */
-	mutex_lock(&sysfs_mutex);
-
 	sysfs_unlink_sibling(sd);
 	sysfs_get(new_parent_sd);
 	sysfs_put(sd->s_parent);
 	sd->s_parent = new_parent_sd;
 	sysfs_link_sibling(sd);
 
-	mutex_unlock(&sysfs_mutex);
-
  out_unlock:
+	mutex_unlock(&sysfs_mutex);
 	mutex_unlock(&new_parent->d_inode->i_mutex);
 	mutex_unlock(&old_parent->d_inode->i_mutex);
- out_dput:
+ out:
 	dput(new_parent);
 	dput(old_dentry);
 	dput(new_dentry);
-- 
1.5.3.4

