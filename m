Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbXDIEWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbXDIEWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 00:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXDIEVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 00:21:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:60306 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbXDIES6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 00:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=r+xCuNQlFonINtntsZcfkichNtiFzzTIFJlZw8149GyKrxyS2yujs75fObyZeNJeun3CXo4X0pLT76wE/eg+O7qoK/5b5MOsCnASyFMI8+Th5nm6KbX5+bAM5EFAofCIy9kgpBaJ63B7QnqV6Ppt/Fq+5xNxbCS91G6cxUoBwYU=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 09/14] sysfs: implement kobj_sysfs_assoc_lock
In-Reply-To: <11760923261269-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Mon, 9 Apr 2007 13:18:48 +0900
Message-Id: <11760923283858-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kobj->dentry can go away anytime unless the user controls when the
associated sysfs node is deleted.  This patch implements
kobj_sysfs_assoc_lock which protects kobj->dentry.  This will be used
to maintain kobj based API when converting sysfs to use sysfs_dirent
tree instead of dentry/kobject.

Note that this lock belongs to kobject/driver-model not sysfs.  Once
sysfs is converted to not use kobject in its interface, this can be
removed from sysfs.

This is in preparation of object reference simplification.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |    8 +++++++-
 fs/sysfs/sysfs.h |    1 +
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4070dc4..707eba9 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -13,6 +13,7 @@
 #include "sysfs.h"
 
 DECLARE_RWSEM(sysfs_rename_sem);
+spinlock_t kobj_sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
 void release_sysfs_dirent(struct sysfs_dirent * sd)
 {
@@ -371,8 +372,13 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 
 void sysfs_remove_dir(struct kobject * kobj)
 {
-	__sysfs_remove_dir(kobj->dentry);
+	struct dentry *d = kobj->dentry;
+
+	spin_lock(&kobj_sysfs_assoc_lock);
 	kobj->dentry = NULL;
+	spin_unlock(&kobj_sysfs_assoc_lock);
+
+	__sysfs_remove_dir(d);
 }
 
 int sysfs_rename_dir(struct kobject * kobj, struct dentry *new_parent,
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index b1a8a7e..5c41fc5 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -60,6 +60,7 @@ extern void sysfs_remove_subdir(struct dentry *);
 extern void sysfs_drop_dentry(struct sysfs_dirent *sd, struct dentry *parent);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
+extern spinlock_t kobj_sysfs_assoc_lock;
 extern struct rw_semaphore sysfs_rename_sem;
 extern struct super_block * sysfs_sb;
 extern const struct file_operations sysfs_dir_operations;
-- 
1.5.0.3


