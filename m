Return-Path: <linux-kernel-owner+w=401wt.eu-S937761AbXHGVkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937761AbXHGVkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937105AbXHGVRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:17:36 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42716 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937098AbXHGVRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:17:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 08/25] sysfs: Implement __sysfs_get_dentry
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com>
	<m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com>
	<m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com>
	<m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com>
	<m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com>
	<m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 07 Aug 2007 15:16:19 -0600
In-Reply-To: <m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:14:56 -0600")
Message-ID: <m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This function is similar but much simpler to sysfs_get_dentry
returns a sysfs dentry if one currently exists.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 6ca4382..2caa5e0 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -848,6 +848,44 @@ void sysfs_remove_dir(struct kobject * kobj)
 	__sysfs_remove_dir(sd);
 }
 
+/**
+ *	__sysfs_get_dentry - get dentry for the given sysfs_dirent
+ *	@sb: superblock of the dentry to return
+ *	@sd: sysfs_dirent of interest
+ *
+ *	Get dentry for @sd.  Only return a dentry if one currently
+ *	exists.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	Pointer to found dentry on success, NULL on failure.
+ */
+static struct dentry *__sysfs_get_dentry(struct super_block *sb, struct sysfs_dirent *sd)
+{
+	struct inode *inode;
+	struct dentry *dentry = NULL;
+
+	inode = ilookup5_nowait(sysfs_sb, sd->s_ino, sysfs_ilookup_test, sd);
+	if (inode && !(inode->i_state & I_NEW)) {
+		struct dentry *alias;
+		spin_lock(&dcache_lock);
+		list_for_each_entry(alias, &inode->i_dentry, d_alias) {
+			if (!IS_ROOT(alias) && d_unhashed(alias))
+				continue;
+			if (alias->d_sb != sb)
+				continue;
+			dentry = alias;
+			dget_locked(dentry);
+			break;
+		}
+		spin_unlock(&dcache_lock);
+	}
+	iput(inode);
+	return dentry;
+}
+
 int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 {
 	struct sysfs_dirent *sd;
-- 
1.5.1.1.181.g2de0

