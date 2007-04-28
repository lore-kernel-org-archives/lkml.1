Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbXD1Nng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbXD1Nng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbXD1Nkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:40:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:45348 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbXD1Nj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=Av3UVSR9iEcBRV1YhXMMe6PSNKgogu1iVTyY8wosIp7yuWFuv9+eK95nqez4qJJGrIi12l4PDA8Edxf3uH4Osw0j6Thx5mOq+Mip0XIaug4hUxIFnpdSC+m53+BhIoIwPX9TLEUUl/eP4oGBXLybqVv34pQIoo8cfK3FZ1KLq0Q=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 14/21] sysfs: implement kobj_sysfs_assoc_lock
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:42 +0900
Message-Id: <11777675821170-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, akpm@linux-foundation.org,
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
index 0050de9..2fddf8a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -14,6 +14,7 @@
 #include "sysfs.h"
 
 DECLARE_RWSEM(sysfs_rename_sem);
+spinlock_t kobj_sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
 static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
 static DEFINE_IDA(sysfs_ino_ida);
@@ -408,8 +409,13 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 
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
index 14ca866..e37b6e8 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -61,6 +61,7 @@ extern void sysfs_remove_subdir(struct dentry *);
 extern void sysfs_drop_dentry(struct sysfs_dirent *sd, struct dentry *parent);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
+extern spinlock_t kobj_sysfs_assoc_lock;
 extern struct rw_semaphore sysfs_rename_sem;
 extern struct super_block * sysfs_sb;
 extern const struct file_operations sysfs_dir_operations;
-- 
1.5.0.3


