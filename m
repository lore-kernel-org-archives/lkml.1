Return-Path: <linux-kernel-owner+w=401wt.eu-S966876AbXHGVoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966876AbXHGVoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965660AbXHGVTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:19:55 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42911 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989AbXHGVTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:19:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 10/25] sysfs: Rewrite sysfs_get_dentry in terms of __sysfs_get_dentry
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com>
	<m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com>
	<m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com>
	<m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com>
	<m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com>
	<m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com>
	<m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com>
	<m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 07 Aug 2007 15:18:27 -0600
In-Reply-To: <m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:17:33 -0600")
Message-ID: <m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This removes the last major user of s_dentry and makes
the locking in sysfs_get_dentry much simpler.  Hopefully
leading to more readable and maintainable code.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 59a9ce8..adb1b01 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -809,19 +809,15 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 	struct dentry *parent_dentry, *dentry;
 	int i, depth;
 
-	/* Find the first parent which has valid s_dentry and get the
-	 * dentry.
+	/* Find the first parent which has valid dentry.
 	 */
 	mutex_lock(&sysfs_mutex);
- restart0:
-	spin_lock(&sysfs_assoc_lock);
- restart1:
-	spin_lock(&dcache_lock);
+ restart:
 
 	dentry = NULL;
 	depth = 0;
 	cur = sd;
-	while (!cur->s_dentry || !cur->s_dentry->d_inode) {
+	while (!(dentry = __sysfs_get_dentry(sysfs_sb, cur))) {
 		if (cur->s_flags & SYSFS_FLAG_REMOVED) {
 			dentry = ERR_PTR(-ENOENT);
 			depth = 0;
@@ -830,11 +826,6 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 		cur = cur->s_parent;
 		depth++;
 	}
-	if (!IS_ERR(dentry))
-		dentry = dget_locked(cur->s_dentry);
-
-	spin_unlock(&dcache_lock);
-	spin_unlock(&sysfs_assoc_lock);
 
 	/* from the found dentry, look up depth times */
 	while (depth--) {
@@ -847,7 +838,7 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 		 */
 		if (i != depth) {
 			dput(dentry);
-			goto restart0;
+			goto restart;
 		}
 
 		sysfs_get(cur);
@@ -866,18 +857,16 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 		}
 
 		mutex_lock(&sysfs_mutex);
-		spin_lock(&sysfs_assoc_lock);
 
 		/* This, again, can happen if tree structure has
 		 * changed and we looked up the wrong thing.  Restart.
 		 */
-		if (cur->s_dentry != dentry) {
+		if (dentry->d_fsdata != cur) {
 			dput(dentry);
 			sysfs_put(cur);
-			goto restart1;
+			goto restart;
 		}
 
-		spin_unlock(&sysfs_assoc_lock);
 
 		sysfs_put(cur);
 	}
-- 
1.5.1.1.181.g2de0

