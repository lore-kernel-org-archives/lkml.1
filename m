Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbZLCFxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbZLCFxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 00:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZLCFxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 00:53:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZLCFxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 00:53:19 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/5] fsnotify/vfsmount: add fsnotify fields to struct vfsmount
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Thu, 03 Dec 2009 00:53:15 -0500
Message-ID: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

This patch adds the list and mask fields needed to support vfsmount marks.
These are the same fields fsnotify needs on an inode.  They are not used,
just declared and we note where the cleanup hook should be (the function is
not yet defined)

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/namespace.c        |    4 ++++
 fs/notify/fsnotify.c  |    4 +---
 include/linux/mount.h |    6 +++++-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7d70d63..2bff3b1 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -29,6 +29,7 @@
 #include <linux/log2.h>
 #include <linux/idr.h>
 #include <linux/fs_struct.h>
+#include <linux/fsnotify.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -150,6 +151,9 @@ struct vfsmount *alloc_vfsmnt(const char *name)
 		INIT_LIST_HEAD(&mnt->mnt_share);
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
+#ifdef CONFIG_FSNOTIFY
+		INIT_HLIST_HEAD(&mnt->mnt_fsnotify_marks);
+#endif
 #ifdef CONFIG_SMP
 		mnt->mnt_writers = alloc_percpu(int);
 		if (!mnt->mnt_writers)
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index b076b06..8ed9fb5 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -162,9 +162,7 @@ static bool needed_by_vfsmount(__u32 test_mask, struct vfsmount *mnt)
 	if (!mnt)
 		return false;
 
-	/* hook in this when mnt->mnt_fsnotify_mask is defined */
-	/* return (test_mask & path->mnt->mnt_fsnotify_mask); */
-	return false;
+	return (test_mask & mnt->mnt_fsnotify_mask);
 }
 /*
  * This is the main call to fsnotify.  The VFS calls into hook specific functions
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 5d52753..9d542fc 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -45,7 +45,11 @@ struct vfsmount {
 	struct list_head mnt_mounts;	/* list of children, anchored here */
 	struct list_head mnt_child;	/* and going through their mnt_child */
 	int mnt_flags;
-	/* 4 bytes hole on 64bits arches */
+	/* 4 bytes hole on 64bits arches without fsnotify */
+#ifdef CONFIG_FSNOTIFY
+	__u32 mnt_fsnotify_mask;
+	struct hlist_head mnt_fsnotify_marks;
+#endif
 	const char *mnt_devname;	/* Name of device e.g. /dev/dsk/hda1 */
 	struct list_head mnt_list;
 	struct list_head mnt_expire;	/* link in fs-specific expiry list */

