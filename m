Return-Path: <linux-kernel-owner+w=401wt.eu-S965961AbXHGVwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965961AbXHGVwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759908AbXHGV3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:29:30 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50016 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966321AbXHGV32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:29:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 18/25] sysfs: Rewrite sysfs_move_dir in terms of sysfs dirents
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
	<m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8nhw8r.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pjbhw6y.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 07 Aug 2007 15:28:10 -0600
In-Reply-To: <m14pjbhw6y.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:27:33 -0600")
Message-ID: <m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch rewrites sysfs_move_dir to perform it's checks
as much as possible on the underlying sysfs_dirents instead
of the contents of the dcache, making sysfs_move_dir
more like the rest of the sysfs directory modification
code.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 3228f5a..94d705a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -932,56 +932,58 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 	BUG_ON(!sd->s_parent);
 	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
 
+	error = 0;
+	if (sd->s_parent == new_parent_sd)
+		goto out;	/* nothing to move */
+
 	/* get dentries */
 	old_dentry = sysfs_get_dentry(sd);
 	if (IS_ERR(old_dentry)) {
 		error = PTR_ERR(old_dentry);
-		goto out_dput;
+		goto out;
 	}
 	old_parent = old_dentry->d_parent;
 
 	new_parent = sysfs_get_dentry(new_parent_sd);
 	if (IS_ERR(new_parent)) {
 		error = PTR_ERR(new_parent);
-		goto out_dput;
+		goto out;
 	}
 
-	if (old_parent->d_inode == new_parent->d_inode) {
-		error = 0;
-		goto out_dput;	/* nothing to move */
-	}
 again:
 	mutex_lock(&old_parent->d_inode->i_mutex);
 	if (!mutex_trylock(&new_parent->d_inode->i_mutex)) {
 		mutex_unlock(&old_parent->d_inode->i_mutex);
 		goto again;
 	}
+	mutex_lock(&sysfs_mutex);
 
-	new_dentry = lookup_one_len(kobj->name, new_parent, strlen(kobj->name));
-	if (IS_ERR(new_dentry)) {
-		error = PTR_ERR(new_dentry);
+	error = -EEXIST;
+	if (sysfs_find_dirent(new_parent_sd, sd->s_name))
 		goto out_unlock;
-	} else
-		error = 0;
+
+	error = -ENOMEM;
+	new_dentry = d_alloc_name(new_parent, sd->s_name);
+	if (!new_dentry)
+		goto out_unlock;
+
+	error = 0;
 	d_add(new_dentry, NULL);
 	d_move(old_dentry, new_dentry);
 	dput(new_dentry);
 
 	/* Remove from old parent's list and insert into new parent's list. */
-	mutex_lock(&sysfs_mutex);
-
 	sysfs_unlink_sibling(sd);
 	sysfs_get(new_parent_sd);
 	sysfs_put(sd->s_parent);
 	sd->s_parent = new_parent_sd;
 	sysfs_link_sibling(sd);
 
-	mutex_unlock(&sysfs_mutex);
-
  out_unlock:
+	mutex_unlock(&sysfs_mutex);
 	mutex_unlock(&new_parent->d_inode->i_mutex);
 	mutex_unlock(&old_parent->d_inode->i_mutex);
- out_dput:
+ out:
 	dput(new_parent);
 	dput(old_dentry);
 	dput(new_dentry);
-- 
1.5.1.1.181.g2de0

