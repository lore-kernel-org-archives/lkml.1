Return-Path: <linux-kernel-owner+w=401wt.eu-S967329AbXHGVxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967329AbXHGVxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966238AbXHGVaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:30:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50023 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966391AbXHGVaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:30:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 14/25] sysfs: Don't use lookup_one_len_kern
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
Date: Tue, 07 Aug 2007 15:23:57 -0600
In-Reply-To: <m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:22:13 -0600")
Message-ID: <m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Upon inspection it appears that there is no looking of the
inode mutex in lookup_one_len_kern and we aren't calling
it with the inode mutex and that is wrong.

So this patch rolls our own dcache insertion function that
does exactly what we need it to do.  As it turns out this
is pretty trivial to do and it makes the code easier to
audit.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index a9bdb12..1d53c2a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -765,6 +765,44 @@ static struct dentry *__sysfs_get_dentry(struct super_block *sb, struct sysfs_di
 	return dentry;
 }
 
+static struct dentry *sysfs_add_dentry(struct dentry *parent, struct sysfs_dirent *sd)
+{
+	struct qstr name;
+	struct dentry *dentry;
+	struct inode *inode;
+
+	mutex_lock(&parent->d_inode->i_mutex);
+	mutex_lock(&sysfs_mutex);
+	dentry = ERR_PTR(-EINVAL);
+	if (parent->d_fsdata != sd->s_parent)
+		goto out;
+
+	name.name = sd->s_name;
+	name.len = strlen(sd->s_name);
+	dentry = d_hash_and_lookup(parent, &name);
+	if (dentry)
+		goto out;
+
+	dentry = d_alloc(parent, &name);
+	if (!dentry) {
+		dentry = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	inode = sysfs_get_inode(sd);
+	if (!inode) {
+		dput(dentry);
+		dentry = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+	d_instantiate(dentry, inode);
+	sysfs_attach_dentry(sd, dentry);
+out:
+	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&parent->d_inode->i_mutex);
+	return dentry;
+}
+
 /**
  *	sysfs_get_dentry - get dentry for the given sysfs_dirent
  *	@sd: sysfs_dirent of interest
@@ -806,8 +844,7 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 
 		/* look it up */
 		parent_dentry = dentry;
-		dentry = lookup_one_len_kern(cur->s_name, parent_dentry,
-					     strlen(cur->s_name));
+		dentry = sysfs_add_dentry(parent_dentry, cur);
 		dput(parent_dentry);
 
 		if (IS_ERR(dentry))
-- 
1.5.1.1.181.g2de0

