Return-Path: <linux-kernel-owner+w=401wt.eu-S934351AbZLKWen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351AbZLKWen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbZLKWds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:33:48 -0500
Received: from kroah.org ([198.145.64.141]:32800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761546AbZLKWZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:04 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/27] sysfs: Use dentry_ops instead of directly playing with the dcache
Date: Fri, 11 Dec 2009 14:24:36 -0800
Message-Id: <1260570289-6997-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Calling d_drop unconditionally when a sysfs_dirent is deleted has
the potential to leak mounts, so instead implement dentry delete
and revalidate operations that cause sysfs dentries to be removed
at the appropriate time.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   73 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 01a9a64..9ee130b 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -298,6 +298,46 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 		goto repeat;
 }
 
+static int sysfs_dentry_delete(struct dentry *dentry)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	return !!(sd->s_flags & SYSFS_FLAG_REMOVED);
+}
+
+static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	int is_dir;
+
+	mutex_lock(&sysfs_mutex);
+
+	/* The sysfs dirent has been deleted */
+	if (sd->s_flags & SYSFS_FLAG_REMOVED)
+		goto out_bad;
+
+	mutex_unlock(&sysfs_mutex);
+out_valid:
+	return 1;
+out_bad:
+	/* Remove the dentry from the dcache hashes.
+	 * If this is a deleted dentry we use d_drop instead of d_delete
+	 * so sysfs doesn't need to cope with negative dentries.
+	 */
+	is_dir = (sysfs_type(sd) == SYSFS_DIR);
+	mutex_unlock(&sysfs_mutex);
+	if (is_dir) {
+		/* If we have submounts we must allow the vfs caches
+		 * to lie about the state of the filesystem to prevent
+		 * leaks and other nasty things.
+		 */
+		if (have_submounts(dentry))
+			goto out_valid;
+		shrink_dcache_parent(dentry);
+	}
+	d_drop(dentry);
+	return 0;
+}
+
 static void sysfs_dentry_iput(struct dentry *dentry, struct inode *inode)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
@@ -307,6 +347,8 @@ static void sysfs_dentry_iput(struct dentry *dentry, struct inode *inode)
 }
 
 static const struct dentry_operations sysfs_dentry_ops = {
+	.d_revalidate	= sysfs_dentry_revalidate,
+	.d_delete	= sysfs_dentry_delete,
 	.d_iput		= sysfs_dentry_iput,
 };
 
@@ -527,44 +569,21 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 }
 
 /**
- *	sysfs_drop_dentry - drop dentry for the specified sysfs_dirent
+ *	sysfs_dec_nlink - Decrement link count for the specified sysfs_dirent
  *	@sd: target sysfs_dirent
  *
- *	Drop dentry for @sd.  @sd must have been unlinked from its
+ *	Decrement nlink for @sd.  @sd must have been unlinked from its
  *	parent on entry to this function such that it can't be looked
  *	up anymore.
  */
-static void sysfs_drop_dentry(struct sysfs_dirent *sd)
+static void sysfs_dec_nlink(struct sysfs_dirent *sd)
 {
 	struct inode *inode;
-	struct dentry *dentry;
 
 	inode = ilookup(sysfs_sb, sd->s_ino);
 	if (!inode)
 		return;
 
-	/* Drop any existing dentries associated with sd.
-	 *
-	 * For the dentry to be properly freed we need to grab a
-	 * reference to the dentry under the dcache lock,  unhash it,
-	 * and then put it.  The playing with the dentry count allows
-	 * dput to immediately free the dentry  if it is not in use.
-	 */
-repeat:
-	spin_lock(&dcache_lock);
-	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
-		if (d_unhashed(dentry))
-			continue;
-		dget_locked(dentry);
-		spin_lock(&dentry->d_lock);
-		__d_drop(dentry);
-		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
-		dput(dentry);
-		goto repeat;
-	}
-	spin_unlock(&dcache_lock);
-
 	/* adjust nlink and update timestamp */
 	mutex_lock(&inode->i_mutex);
 
@@ -611,7 +630,7 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 		acxt->removed = sd->s_sibling;
 		sd->s_sibling = NULL;
 
-		sysfs_drop_dentry(sd);
+		sysfs_dec_nlink(sd);
 		sysfs_deactivate(sd);
 		unmap_bin_file(sd);
 		sysfs_put(sd);
-- 
1.6.5.5

