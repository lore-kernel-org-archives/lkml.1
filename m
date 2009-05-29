Return-Path: <linux-kernel-owner+w=401wt.eu-S1763514AbZE2UUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763514AbZE2UUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763120AbZE2UTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:19:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45177 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761128AbZE2UTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:53 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Fri, 29 May 2009 13:19:13 -0700
Message-Id: <1243628376-22905-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=2 Fuz1=2 Fuz2=2 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0205]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=2 Fuz1=2 Fuz2=2]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 03/26] sysfs: Remove now unnecessary error reporting suppression.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that we use sysfs_rename_link in the places we previously
used sysfs_create_link_nowarn we can remove sysfs_create_link_nowarn
and all it's supporting infrastructure as it has no callers.

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
1.6.3.1.54.g99dd.dirty

