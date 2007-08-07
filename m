Return-Path: <linux-kernel-owner+w=401wt.eu-S965235AbXHGVhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965235AbXHGVhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935460AbXHGVMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:12:06 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55254 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936792AbXHGVMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:12:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 04/25] sysfs: Make sysfs_mount static
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com>
	<m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com>
	<m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 07 Aug 2007 15:11:16 -0600
In-Reply-To: <m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:10:27 -0600")
Message-ID: <m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch modifies the users of sysfs_mount to use sysfs_root
instead (which is what they are looking for).  It then
makes sysfs_mount static to keep people from using it
by accident.

The net result is slightly faster and cleaner code.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c     |    4 +---
 fs/sysfs/mount.c   |    2 +-
 fs/sysfs/symlink.c |    7 +++----
 fs/sysfs/sysfs.h   |    1 -
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 55d8299..39df3ce 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -735,10 +735,8 @@ int sysfs_create_dir(struct kobject * kobj)
 
 	if (kobj->parent)
 		parent_sd = kobj->parent->sd;
-	else if (sysfs_mount && sysfs_mount->mnt_sb)
-		parent_sd = sysfs_mount->mnt_sb->s_root->d_fsdata;
 	else
-		return -EFAULT;
+		parent_sd = &sysfs_root;
 
 	error = create_dir(kobj, parent_sd, kobject_name(kobj), &sd);
 	if (!error)
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index d1094c6..9fae7d5 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -15,7 +15,7 @@
 /* Random magic number */
 #define SYSFS_MAGIC 0x62656572
 
-struct vfsmount *sysfs_mount;
+static struct vfsmount *sysfs_mount;
 struct super_block * sysfs_sb = NULL;
 struct kmem_cache *sysfs_dir_cachep;
 
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index f77ad61..46f8fd4 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -60,10 +60,9 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 
 	BUG_ON(!name);
 
-	if (!kobj) {
-		if (sysfs_mount && sysfs_mount->mnt_sb)
-			parent_sd = sysfs_mount->mnt_sb->s_root->d_fsdata;
-	} else
+	if (!kobj)
+		parent_sd = &sysfs_root;
+	else
 		parent_sd = kobj->sd;
 
 	error = -EFAULT;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 8a0aea1..77253aa 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -51,7 +51,6 @@ struct sysfs_addrm_cxt {
 	int			cnt;
 };
 
-extern struct vfsmount * sysfs_mount;
 extern struct sysfs_dirent sysfs_root;
 extern struct kmem_cache *sysfs_dir_cachep;
 
-- 
1.5.1.1.181.g2de0

