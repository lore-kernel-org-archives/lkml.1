Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZEUA3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZEUA3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbZEUA20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:28:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46309 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbZEUA2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:28:16 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 03/20] sysfs: Remove now unnecessary error reporting suppression.
Date: Wed, 20 May 2009 17:27:57 -0700
Message-Id: <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-2-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
 <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-2-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that we use sysfs_rename_link in the places we previously
used sysfs_create_link_nowarn we can remove sysfs_create_link_nowarn
and all it's supporting infrastructure.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c     |   54 +++++++++++----------------------------------------
 fs/sysfs/symlink.c |   42 ++++++++-------------------------------
 fs/sysfs/sysfs.h   |    1 -
 3 files changed, 21 insertions(+), 76 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index d88d0fa..b95cc07 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -397,43 +397,6 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 }
 
 /**
- *	__sysfs_add_one - add sysfs_dirent to parent without warning
- *	@acxt: addrm context to use
- *	@sd: sysfs_dirent to be added
- *
- *	Get @acxt->parent_sd and set sd->s_parent to it and increment
- *	nlink of parent inode if @sd is a directory and link into the
- *	children list of the parent.
- *
- *	This function should be called between calls to
- *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
- *	passed the same @acxt as passed to sysfs_addrm_start().
- *
- *	LOCKING:
- *	Determined by sysfs_addrm_start().
- *
- *	RETURNS:
- *	0 on success, -EEXIST if entry with the given name already
- *	exists.
- */
-int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
-{
-	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
-		return -EEXIST;
-
-	sd->s_parent = sysfs_get(acxt->parent_sd);
-
-	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
-		inc_nlink(acxt->parent_inode);
-
-	acxt->cnt++;
-
-	sysfs_link_sibling(sd);
-
-	return 0;
-}
-
-/**
  *	sysfs_pathname - return full path to sysfs dirent
  *	@sd: sysfs_dirent whose path we want
  *	@path: caller allocated buffer
@@ -475,10 +438,7 @@ static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
  */
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
-	int ret;
-
-	ret = __sysfs_add_one(acxt, sd);
-	if (ret == -EEXIST) {
+	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name)) {
 		char *path = kzalloc(PATH_MAX, GFP_KERNEL);
 		WARN(1, KERN_WARNING
 		     "sysfs: cannot create duplicate filename '%s'\n",
@@ -486,9 +446,19 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 		     strcat(strcat(sysfs_pathname(acxt->parent_sd, path), "/"),
 		            sd->s_name));
 		kfree(path);
+		return -EEXIST;
 	}
 
-	return ret;
+	sd->s_parent = sysfs_get(acxt->parent_sd);
+
+	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
+		inc_nlink(acxt->parent_inode);
+
+	acxt->cnt++;
+
+	sysfs_link_sibling(sd);
+
+	return 0;
 }
 
 /**
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 11c4da5..ac13e61 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -19,8 +19,14 @@
 
 #include "sysfs.h"
 
-static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
-				const char *name, int warn)
+/**
+ *	sysfs_create_link - create symlink between two objects.
+ *	@kobj:	object whose directory we're creating the link in.
+ *	@target:	object we're pointing to.
+ *	@name:		name of the symlink.
+ */
+int sysfs_create_link(struct kobject *kobj, struct kobject *target,
+			const char *name)
 {
 	struct sysfs_dirent *parent_sd = NULL;
 	struct sysfs_dirent *target_sd = NULL;
@@ -60,10 +66,7 @@ static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
 	sysfs_addrm_start(&acxt, parent_sd);
-	if (warn)
-		error = sysfs_add_one(&acxt, sd);
-	else
-		error = __sysfs_add_one(&acxt, sd);
+	error = sysfs_add_one(&acxt, sd);
 	sysfs_addrm_finish(&acxt);
 
 	if (error)
@@ -78,33 +81,6 @@ static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 }
 
 /**
- *	sysfs_create_link - create symlink between two objects.
- *	@kobj:	object whose directory we're creating the link in.
- *	@target:	object we're pointing to.
- *	@name:		name of the symlink.
- */
-int sysfs_create_link(struct kobject *kobj, struct kobject *target,
-		      const char *name)
-{
-	return sysfs_do_create_link(kobj, target, name, 1);
-}
-
-/**
- *	sysfs_create_link_nowarn - create symlink between two objects.
- *	@kobj:	object whose directory we're creating the link in.
- *	@target:	object we're pointing to.
- *	@name:		name of the symlink.
- *
- *	This function does the same as sysf_create_link(), but it
- *	doesn't warn if the link already exists.
- */
-int sysfs_create_link_nowarn(struct kobject *kobj, struct kobject *target,
-			     const char *name)
-{
-	return sysfs_do_create_link(kobj, target, name, 0);
-}
-
-/**
  *	sysfs_remove_link - remove symlink in object's directory.
  *	@kobj:	object we're acting for.
  *	@name:	name of the symlink to remove.
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 3fa0d98..abf05f4 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -108,7 +108,6 @@ struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
 void sysfs_put_active_two(struct sysfs_dirent *sd);
 void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 		       struct sysfs_dirent *parent_sd);
-int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
-- 
1.6.1.2.350.g88cc

