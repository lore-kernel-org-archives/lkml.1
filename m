Return-Path: <linux-kernel-owner+w=401wt.eu-S1764102AbZE2UXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764102AbZE2UXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763437AbZE2UU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:20:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41778 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763406AbZE2UTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:54 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Fri, 29 May 2009 13:19:18 -0700
Message-Id: <1243628376-22905-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=2 Fuz1=2 Fuz2=2 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=2 Fuz1=2 Fuz2=2]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 08/26] sysfs: Use dentry_ops instead of directly playing with the dcache
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Calling d_drop unconditionally when a sysfs_dirent is deleted has
the potential to leak mounts, so instead implement dentry delete
and revalidate operations that cause sysfs dentries to be removed
at the appropriate time.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |   73 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f9f32b8..e0bf3a5 100644
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
1.6.3.1.54.g99dd.dirty

