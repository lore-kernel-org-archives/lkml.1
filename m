Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZEUAdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZEUAdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbZEUA3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:29:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46357 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbZEUA2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:28:19 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 18/20] sysfs: Pass super_block to sysfs_get_inode
Date: Wed, 20 May 2009 17:28:12 -0700
Message-Id: <1242865694-2100-18-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-17-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
 <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-2-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-5-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-6-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-7-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-8-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-9-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-10-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-11-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-12-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-13-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-14-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-15-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-16-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-17-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Currently sysfs_get_inode magically returns an inode on
sysfs_sb.  Make the super_block parameter explicit and
the code becomes clearer.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c   |    2 +-
 fs/sysfs/inode.c |    5 +++--
 fs/sysfs/mount.c |    2 +-
 fs/sysfs/sysfs.h |    2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 3ed4489..7aa8890 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -579,7 +579,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	/* attach dentry and inode */
-	inode = sysfs_get_inode(sd);
+	inode = sysfs_get_inode(dir->i_sb, sd);
 	if (!inode) {
 		ret = ERR_PTR(-ENOMEM);
 		goto out_unlock;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index a1917b5..c725aeb 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -210,6 +210,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 
 /**
  *	sysfs_get_inode - get inode for sysfs_dirent
+ *	@sb: super block
  *	@sd: sysfs_dirent to allocate inode for
  *
  *	Get inode for @sd.  If such inode doesn't exist, a new inode
@@ -222,11 +223,11 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
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
index 2db952c..cf21b06 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -130,7 +130,7 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
 /*
  * inode.c
  */
-struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
+struct inode *sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd);
 void sysfs_delete_inode(struct inode *inode);
 int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
-- 
1.6.1.2.350.g88cc

