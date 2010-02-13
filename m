Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab0BMDXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 22:23:14 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51235 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab0BMDWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 22:22:52 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 5/6] sysfs: Pass super_block to sysfs_get_inode
Date: Fri, 12 Feb 2010 19:22:27 -0800
Message-Id: <1266031348-30068-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1mxzdstx2.fsf_-_@fess.ebiederm.org>
References: <m1mxzdstx2.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Currently sysfs_get_inode magically returns an inode on
sysfs_sb.  Make the super_block parameter explicit and
the code becomes clearer.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c   |    2 +-
 fs/sysfs/inode.c |    5 +++--
 fs/sysfs/mount.c |    2 +-
 fs/sysfs/sysfs.h |    2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 481fdec..5907178 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -645,7 +645,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	/* attach dentry and inode */
-	inode = sysfs_get_inode(sd);
+	inode = sysfs_get_inode(dir->i_sb, sd);
 	if (!inode) {
 		ret = ERR_PTR(-ENOMEM);
 		goto out_unlock;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 0d09f6c..082daae 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -283,6 +283,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 
 /**
  *	sysfs_get_inode - get inode for sysfs_dirent
+ *	@sb: super block
  *	@sd: sysfs_dirent to allocate inode for
  *
  *	Get inode for @sd.  If such inode doesn't exist, a new inode
@@ -295,11 +296,11 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
  *	RETURNS:
  *	Pointer to allocated inode on success, NULL on failure.
  */
-struct inode * sysfs_get_inode(struct sysfs_dirent *sd)
+struct inode * sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd)
 {
 	struct inode *inode;
 
-	inode = iget_locked(sysfs_sb, sd->s_ino);
+	inode = iget_locked(sb, sd->s_ino);
 	if (inode && (inode->i_state & I_NEW))
 		sysfs_init_inode(sd, inode);
 
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 4974995..89db07e 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -54,7 +54,7 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* get root inode, initialize and unlock it */
 	mutex_lock(&sysfs_mutex);
-	inode = sysfs_get_inode(&sysfs_root);
+	inode = sysfs_get_inode(sb, &sysfs_root);
 	mutex_unlock(&sysfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 5a3192a..7593d71 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -172,7 +172,7 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
 /*
  * inode.c
  */
-struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
+struct inode *sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd);
 void sysfs_delete_inode(struct inode *inode);
 int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr);
 int sysfs_permission(struct inode *inode, int mask);
-- 
1.6.5.2.143.g8cc62

