Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbZEUAaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbZEUAaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZEUA2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:28:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46321 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbZEUA2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:28:17 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 06/20] sysfs: Use dentry_ops instead of directly playing with the dcache
Date: Wed, 20 May 2009 17:28:00 -0700
Message-Id: <1242865694-2100-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-5-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
 <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-2-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-5-git-send-email-ebiederm@xmission.com>
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

Calling d_drop unconditionally when a sysfs_dirent is deleted has
the potential to leak mounts, so instead implement dentry delete
and revalidate operations that cause sysfs dentries to be removed
at the appropriate time.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |   73 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 01b1e40..8dd2abf 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -294,6 +294,46 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
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
@@ -303,6 +343,8 @@ static void sysfs_dentry_iput(struct dentry * dentry, struct inode * inode)
 }
 
 static const struct dentry_operations sysfs_dentry_ops = {
+	.d_revalidate	= sysfs_dentry_revalidate,
+	.d_delete	= sysfs_dentry_delete,
 	.d_iput		= sysfs_dentry_iput,
 };
 
@@ -493,44 +535,21 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
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
 
@@ -577,7 +596,7 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 		acxt->removed = sd->s_sibling;
 		sd->s_sibling = NULL;
 
-		sysfs_drop_dentry(sd);
+		sysfs_dec_nlink(sd);
 		sysfs_deactivate(sd);
 		unmap_bin_file(sd);
 		sysfs_put(sd);
-- 
1.6.1.2.350.g88cc

