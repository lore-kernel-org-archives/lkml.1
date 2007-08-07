Return-Path: <linux-kernel-owner+w=401wt.eu-S935897AbXHGVul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935897AbXHGVul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966252AbXHGV2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:28:40 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50013 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966137AbXHGV2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:28:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 13/25] sysfs: Simply sysfs_get_dentry
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
	<m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 07 Aug 2007 15:22:13 -0600
In-Reply-To: <m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:21:06 -0600")
Message-ID: <m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that we know the sysfs tree structure cannot change under us
simplfy sysfs_get_dentry.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c |   48 ++++++------------------------------------------
 1 files changed, 6 insertions(+), 42 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e0f49b7..a9bdb12 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -784,71 +784,35 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *cur;
 	struct dentry *parent_dentry, *dentry;
-	int i, depth;
 
 	/* Find the first parent which has valid dentry.
 	 */
-	mutex_lock(&sysfs_mutex);
- restart:
-
 	dentry = NULL;
-	depth = 0;
 	cur = sd;
 	while (!(dentry = __sysfs_get_dentry(sysfs_sb, cur))) {
 		if (cur->s_flags & SYSFS_FLAG_REMOVED) {
 			dentry = ERR_PTR(-ENOENT);
-			depth = 0;
 			break;
 		}
 		cur = cur->s_parent;
-		depth++;
 	}
 
 	/* from the found dentry, look up depth times */
-	while (depth--) {
-		/* find and get depth'th ancestor */
-		for (cur = sd, i = 0; cur && i < depth; i++)
+	while (dentry->d_fsdata != sd) {
+		/* Find the first ancestor I have not looked up */
+		cur = sd;
+		while (cur->s_parent != dentry->d_fsdata)
 			cur = cur->s_parent;
 
-		/* This can happen if tree structure was modified due
-		 * to move/rename.  Restart.
-		 */
-		if (i != depth) {
-			dput(dentry);
-			goto restart;
-		}
-
-		sysfs_get(cur);
-
-		mutex_unlock(&sysfs_mutex);
-
 		/* look it up */
 		parent_dentry = dentry;
 		dentry = lookup_one_len_kern(cur->s_name, parent_dentry,
 					     strlen(cur->s_name));
 		dput(parent_dentry);
 
-		if (IS_ERR(dentry)) {
-			sysfs_put(cur);
-			return dentry;
-		}
-
-		mutex_lock(&sysfs_mutex);
-
-		/* This, again, can happen if tree structure has
-		 * changed and we looked up the wrong thing.  Restart.
-		 */
-		if (dentry->d_fsdata != cur) {
-			dput(dentry);
-			sysfs_put(cur);
-			goto restart;
-		}
-
-
-		sysfs_put(cur);
+		if (IS_ERR(dentry))
+			break;
 	}
-
-	mutex_unlock(&sysfs_mutex);
 	return dentry;
 }
 
-- 
1.5.1.1.181.g2de0

