Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbXFMT2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbXFMT2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbXFMT1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:27:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:18034 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbXFMT13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:27:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=jGeSLzV6MXsE6PDQG/KSHTZd676M97DawjGn5Lc/qJX/fdfl7SMUh0sEibGPbJKe2ZbNH3Sym1Kca/Xc5SzXuxzn1i7b3McO5t6PzGxzJlxrtNfXtku/wXbjQHy+pjSGQ0U3hBNyjL7u+Dyqp31cU82VU9LNuQjTv7f7Te0DKjc=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 03/11] sysfs: implement SYSFS_FLAG_REMOVED flag
In-Reply-To: <1181762840495-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 14 Jun 2007 04:27:22 +0900
Message-Id: <11817628421257-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: greg@kroah.com, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement SYSFS_FLAG_REMOVED flag which currently is used only to
improve sanity check in sysfs_deactivate().  The flag will be used to
make directory entries reclamiable.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c        |    4 +++-
 fs/sysfs/inode.c      |    1 +
 include/linux/sysfs.h |    1 +
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index eb9bc0a..f2ea006 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -171,7 +171,7 @@ void sysfs_deactivate(struct sysfs_dirent *sd)
 	DECLARE_COMPLETION_ONSTACK(wait);
 	int v;
 
-	BUG_ON(sd->s_sibling);
+	BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
 	sd->s_sibling = (void *)&wait;
 
 	/* atomic_add_return() is a mb(), put_active() will always see
@@ -506,6 +506,7 @@ static void remove_dir(struct dentry * d)
 	mutex_lock(&parent->d_inode->i_mutex);
 
 	sysfs_unlink_sibling(sd);
+	sd->s_flags |= SYSFS_FLAG_REMOVED;
 
 	pr_debug(" o %s removing done (%d)\n",d->d_name.name,
 		 atomic_read(&d->d_count));
@@ -540,6 +541,7 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 		struct sysfs_dirent *sd = *pos;
 
 		if (sysfs_type(sd) && (sysfs_type(sd) & SYSFS_NOT_PINNED)) {
+			sd->s_flags |= SYSFS_FLAG_REMOVED;
 			*pos = sd->s_sibling;
 			sd->s_sibling = removed;
 			removed = sd;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index ee3a5d9..e2f6ef1 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -296,6 +296,7 @@ int sysfs_hash_and_remove(struct dentry * dir, const char * name)
 		if (!sysfs_type(sd))
 			continue;
 		if (!strcmp(sd->s_name, name)) {
+			sd->s_flags |= SYSFS_FLAG_REMOVED;
 			*pos = sd->s_sibling;
 			sd->s_sibling = NULL;
 			found = 1;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 5813550..2a6df64 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -84,6 +84,7 @@ struct sysfs_ops {
 #define SYSFS_COPY_NAME		(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
 #define SYSFS_FLAG_MASK		~SYSFS_TYPE_MASK
+#define SYSFS_FLAG_REMOVED	0x0100
 
 #ifdef CONFIG_SYSFS
 
-- 
1.5.0.3


