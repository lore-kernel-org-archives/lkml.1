Return-Path: <linux-kernel-owner+w=401wt.eu-S965529AbXDGI06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965529AbXDGI06 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965524AbXDGIYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:24:54 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:12920 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965529AbXDGIX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=iPE+0k1RjlguzNZXFyMC12p95FkPeYeRZadHzm721KIJGM1PqCo5M5tgppd29n/TWIwVjRkHFkhisFFj8h+HkicIcjkYN0qghpJWH7oTnNEkot7HvNUHpDDxXxBu0eDsKl8WPoClFylYKccrbllqQmo+5NpKhZrYRYDjtYgVHBw=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 09/14] sysfs: implement kobj_sysfs_assoc_lock
In-Reply-To: <1175934226928-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 7 Apr 2007 17:23:47 +0900
Message-Id: <11759342272795-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       htejun@gmail.com
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
index d70ead5..8372c0c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -13,6 +13,7 @@
 #include "sysfs.h"
 
 DECLARE_RWSEM(sysfs_rename_sem);
+spinlock_t kobj_sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
 struct kobject *sysfs_get_kobject(struct dentry *dentry)
 {
@@ -388,8 +389,13 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 
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
index c1965b9..9dcd0b0 100644
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


