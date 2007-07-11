Return-Path: <linux-kernel-owner+w=401wt.eu-S935309AbXGKXrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935309AbXGKXrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935115AbXGKXfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:35:14 -0400
Received: from ns.suse.de ([195.135.220.2]:33900 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935084AbXGKXfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:35:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/61] sysfs: implement kobj_sysfs_assoc_lock
Date: Wed, 11 Jul 2007 16:31:51 -0700
Message-Id: <11841968872456-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <118419688284-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
 <11841968643630-git-send-email-gregkh@suse.de>
 <11841968683554-git-send-email-gregkh@suse.de>
 <11841968731843-git-send-email-gregkh@suse.de>
 <11841968773426-git-send-email-gregkh@suse.de>
 <118419688284-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |    8 +++++++-
 fs/sysfs/sysfs.h |    1 +
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 0791226..e9fddcc 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -15,6 +15,7 @@
 
 DECLARE_RWSEM(sysfs_rename_sem);
 spinlock_t sysfs_lock = SPIN_LOCK_UNLOCKED;
+spinlock_t kobj_sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
 static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
 static DEFINE_IDA(sysfs_ino_ida);
@@ -426,8 +427,13 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 
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
index 39ab048..718e2e1 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -62,6 +62,7 @@ extern void sysfs_drop_dentry(struct sysfs_dirent *sd, struct dentry *parent);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
 extern spinlock_t sysfs_lock;
+extern spinlock_t kobj_sysfs_assoc_lock;
 extern struct rw_semaphore sysfs_rename_sem;
 extern struct super_block * sysfs_sb;
 extern const struct file_operations sysfs_dir_operations;
-- 
1.5.2.2

