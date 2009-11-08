Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbZKHH3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbZKHH3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 02:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZKHH3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 02:29:47 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46911 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZKHH11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 02:27:27 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 03/15] sysfs: Use dentry_ops instead of directly playing with the dcache
Date: Sat,  7 Nov 2009 23:27:01 -0800
Message-Id: <1257665233-12468-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1pr7tmqb4.fsf@fess.ebiederm.org>
References: <m1pr7tmqb4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
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
---
 fs/sysfs/dir.c |   73 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 130dfc3..b5e8499 100644
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
 static void sysfs_dentry_iput(struct dentry * dentry, struct inode * inode)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
@@ -307,6 +347,8 @@ static void sysfs_dentry_iput(struct dentry * dentry, struct inode * inode)
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
1.6.5.2.143.g8cc62

