Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbXGaKQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbXGaKQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbXGaKPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:15:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:38952 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbXGaKPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=UJzMvX00uDDD/CpVkmNvrrEyW+dgRZaKgI7Ou+VaevzeU4v79HK7QtcE3IHPacPMRK3TZKQYmqveupuAM2jdfYJMgE1H95L8pNy0b4K/3yyJZC2zFPu8cdf0lWPwY4rPRVwo0CJ0mli0pbsSi7tI5LDBYM05Qlte6Rq823OsmSA=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 1/7] sysfs: fix locking in sysfs_lookup() and sysfs_rename_dir()
In-Reply-To: <11858769082982-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 31 Jul 2007 19:15:08 +0900
Message-Id: <1185876908509-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sd children list walking in sysfs_lookup() and sd renaming in
sysfs_rename_dir() were left out during i_mutex -> sysfs_mutex
conversion.  Fix them.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 048e605..83e76b3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -762,12 +762,15 @@ static int sysfs_count_nlink(struct sysfs_dirent *sd)
 static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 				struct nameidata *nd)
 {
+	struct dentry *ret = NULL;
 	struct sysfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
 	struct sysfs_dirent * sd;
 	struct bin_attribute *bin_attr;
 	struct inode *inode;
 	int found = 0;
 
+	mutex_lock(&sysfs_mutex);
+
 	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling) {
 		if (sysfs_type(sd) &&
 		    !strcmp(sd->s_name, dentry->d_name.name)) {
@@ -778,14 +781,14 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 
 	/* no such entry */
 	if (!found)
-		return NULL;
+		goto out_unlock;
 
 	/* attach dentry and inode */
 	inode = sysfs_get_inode(sd);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
-
-	mutex_lock(&sysfs_mutex);
+	if (!inode) {
+		ret = ERR_PTR(-ENOMEM);
+		goto out_unlock;
+	}
 
 	if (inode->i_state & I_NEW) {
 		/* initialize inode according to type */
@@ -815,9 +818,9 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	sysfs_instantiate(dentry, inode);
 	sysfs_attach_dentry(sd, dentry);
 
+ out_unlock:
 	mutex_unlock(&sysfs_mutex);
-
-	return NULL;
+	return ret;
 }
 
 const struct inode_operations sysfs_dir_inode_operations = {
@@ -942,6 +945,8 @@ int sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
 	if (error)
 		goto out_drop;
 
+	mutex_lock(&sysfs_mutex);
+
 	dup_name = sd->s_name;
 	sd->s_name = new_name;
 
@@ -949,8 +954,6 @@ int sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
 	d_add(new_dentry, NULL);
 	d_move(sd->s_dentry, new_dentry);
 
-	mutex_lock(&sysfs_mutex);
-
 	sysfs_unlink_sibling(sd);
 	sysfs_get(new_parent_sd);
 	sysfs_put(sd->s_parent);
-- 
1.5.0.3


