Return-Path: <linux-kernel-owner+w=401wt.eu-S1762899AbXE1Qhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762899AbXE1Qhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbXE1Qgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:36:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:54608 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbXE1Qgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:36:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=lCnfF3FOeR8zyoKDRPPykAXAi4W1SOWVovecIcW9G0d4bTxlz+6pyHE1DSqHRFLJ7gR0zOTBGrnhOqImlpXzuXIoook21c0b2JDBrM43HBah4CjE6X91SKcENFujDXOc0yw/CWAD75OS2aLJaOQl54SVLYpWvqazXpe0DST7niU=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/6] sysfs: implement sysfs_find_dirent() and sysfs_get_dirent()
In-Reply-To: <11803701861778-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:36:27 +0900
Message-Id: <11803701873864-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement sysfs_find_dirent() and sysfs_get_dirent().
sysfs_dirent_exist() is replaced by sysfs_find_dirent().  These will
be used to make directory entries reclamiable.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c     |   61 +++++++++++++++++++++++++++++++++++++--------------
 fs/sysfs/file.c    |    2 +-
 fs/sysfs/symlink.c |    2 +-
 fs/sysfs/sysfs.h   |    5 +++-
 4 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4a2bd8b..c05d04a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -317,28 +317,55 @@ void sysfs_attach_dirent(struct sysfs_di
 	}
 }
 
-/*
+/**
+ *	sysfs_find_dirent - find sysfs_dirent with the given name
+ *	@parent_sd: sysfs_dirent to search under
+ *	@name: name to look for
  *
- * Return -EEXIST if there is already a sysfs element with the same name for
- * the same parent.
+ *	Look for sysfs_dirent with name @name under @parent_sd.
  *
- * called with parent inode's i_mutex held
+ *	LOCKING:
+ *	mutex_lock(parent->i_mutex)
+ *
+ *	RETURNS:
+ *	Pointer to sysfs_dirent if found, NULL if not.
  */
-int sysfs_dirent_exist(struct sysfs_dirent *parent_sd,
-			  const unsigned char *new)
+struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
+				       const unsigned char *name)
 {
-	struct sysfs_dirent * sd;
+	struct sysfs_dirent *sd;
 
-	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling) {
-		if (sysfs_type(sd)) {
-			if (strcmp(sd->s_name, new))
-				continue;
-			else
-				return -EEXIST;
-		}
-	}
+	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling)
+		if (sysfs_type(sd) && !strcmp(sd->s_name, name))
+			return sd;
+	return NULL;
+}
 
-	return 0;
+/**
+ *	sysfs_get_dirent - find and get sysfs_dirent with the given name
+ *	@parent_sd: sysfs_dirent to search under
+ *	@name: name to look for
+ *
+ *	Look for sysfs_dirent with name @name under @parent_sd and get
+ *	it if found.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	Pointer to sysfs_dirent if found, NULL if not.
+ */
+struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
+				      const unsigned char *name)
+{
+	struct sysfs_dirent *sd;
+
+	mutex_lock(&parent_sd->s_dentry->d_inode->i_mutex);
+	sd = sysfs_find_dirent(parent_sd, name);
+	sysfs_get(sd);
+	mutex_unlock(&parent_sd->s_dentry->d_inode->i_mutex);
+
+	return sd;
 }
 
 static int create_dir(struct kobject *kobj, struct dentry *parent,
@@ -382,7 +409,7 @@ static int create_dir(struct kobject *ko
 
 	/* link in */
 	error = -EEXIST;
-	if (sysfs_dirent_exist(parent->d_fsdata, name))
+	if (sysfs_find_dirent(parent->d_fsdata, name))
 		goto out_iput;
 
 	sysfs_instantiate(dentry, inode);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index a84b734..e448b88 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -421,7 +421,7 @@ int sysfs_add_file(struct dentry * dir,
 
 	mutex_lock(&dir->d_inode->i_mutex);
 
-	if (sysfs_dirent_exist(parent_sd, attr->name)) {
+	if (sysfs_find_dirent(parent_sd, attr->name)) {
 		error = -EEXIST;
 		goto out_unlock;
 	}
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index ff605d3..45b62e2 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -95,7 +95,7 @@ int sysfs_create_link(struct kobject * k
 		return -ENOENT;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	if (!sysfs_dirent_exist(dentry->d_fsdata, name))
+	if (!sysfs_find_dirent(dentry->d_fsdata, name))
 		error = sysfs_add_link(parent_sd, name, target_sd);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 06b5085..f1629b4 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -59,7 +59,10 @@ extern struct inode * sysfs_get_inode(st
 extern void sysfs_instantiate(struct dentry *dentry, struct inode *inode);
 
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
-extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
+extern struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
+					      const unsigned char *name);
+extern struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
+					     const unsigned char *name);
 extern struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode,
 					     int type);
 extern void sysfs_attach_dirent(struct sysfs_dirent *sd,
-- 
1.4.3.4


