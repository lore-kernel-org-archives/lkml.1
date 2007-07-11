Return-Path: <linux-kernel-owner+w=401wt.eu-S933871AbXGKXn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871AbXGKXn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935119AbXGKXec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:32 -0400
Received: from ns1.suse.de ([195.135.220.2]:33818 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934994AbXGKXea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:34:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/61] sysfs: allocate inode number using ida
Date: Wed, 11 Jul 2007 16:31:42 -0700
Message-Id: <11841968471598-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968431153-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

sysfs used simple incrementing allocator which is not guaranteed to be
unique.  This patch makes sysfs use ida to give each sd a unique and
packed inode number.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   45 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 2544aae..f09626c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -9,12 +9,42 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
+#include <linux/idr.h>
 #include <asm/semaphore.h>
 #include "sysfs.h"
 
 DECLARE_RWSEM(sysfs_rename_sem);
 spinlock_t sysfs_lock = SPIN_LOCK_UNLOCKED;
 
+static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_IDA(sysfs_ino_ida);
+
+int sysfs_alloc_ino(ino_t *pino)
+{
+	int ino, rc;
+
+ retry:
+	spin_lock(&sysfs_ino_lock);
+	rc = ida_get_new_above(&sysfs_ino_ida, 2, &ino);
+	spin_unlock(&sysfs_ino_lock);
+
+	if (rc == -EAGAIN) {
+		if (ida_pre_get(&sysfs_ino_ida, GFP_KERNEL))
+			goto retry;
+		rc = -ENOMEM;
+	}
+
+	*pino = ino;
+	return rc;
+}
+
+static void sysfs_free_ino(ino_t ino)
+{
+	spin_lock(&sysfs_ino_lock);
+	ida_remove(&sysfs_ino_ida, ino);
+	spin_unlock(&sysfs_ino_lock);
+}
+
 void release_sysfs_dirent(struct sysfs_dirent * sd)
 {
 	if (sd->s_type & SYSFS_KOBJ_LINK) {
@@ -24,6 +54,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 		kfree(sl);
 	}
 	kfree(sd->s_iattr);
+	sysfs_free_ino(sd->s_ino);
 	kmem_cache_free(sysfs_dir_cachep, sd);
 }
 
@@ -54,14 +85,6 @@ static struct dentry_operations sysfs_dentry_ops = {
 	.d_iput		= sysfs_d_iput,
 };
 
-static unsigned int sysfs_inode_counter;
-ino_t sysfs_get_inum(void)
-{
-	if (unlikely(sysfs_inode_counter < 3))
-		sysfs_inode_counter = 3;
-	return sysfs_inode_counter++;
-}
-
 /*
  * Allocates a new sysfs_dirent and links it to the parent sysfs_dirent
  */
@@ -73,7 +96,11 @@ static struct sysfs_dirent * __sysfs_new_dirent(void * element)
 	if (!sd)
 		return NULL;
 
-	sd->s_ino = sysfs_get_inum();
+	if (sysfs_alloc_ino(&sd->s_ino)) {
+		kmem_cache_free(sysfs_dir_cachep, sd);
+		return NULL;
+	}
+
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_event, 1);
 	INIT_LIST_HEAD(&sd->s_children);
-- 
1.5.2.2

