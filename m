Return-Path: <linux-kernel-owner+w=401wt.eu-S1752417AbZLCFxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbZLCFxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 00:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZLCFx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 00:53:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbZLCFx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 00:53:26 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/5] fsnotify: vfsmount marks generic functions
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Thu, 03 Dec 2009 00:53:22 -0500
Message-ID: <20091203055322.21918.72975.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com>
References: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Much like inode-mark.c has all of the code dealing with marks on inodes
this patch adds a vfsmount-mark.c which has similar code but is intended
for marks on vfsmounts.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/Makefile               |    2 
 fs/notify/fsnotify.h             |    6 +
 fs/notify/mark.c                 |   20 ++--
 fs/notify/vfsmount_mark.c        |  171 ++++++++++++++++++++++++++++++++++++++
 include/linux/fsnotify_backend.h |    2 
 5 files changed, 191 insertions(+), 10 deletions(-)
 create mode 100644 fs/notify/vfsmount_mark.c

diff --git a/fs/notify/Makefile b/fs/notify/Makefile
index 8f7f3b0..ae5f33a 100644
--- a/fs/notify/Makefile
+++ b/fs/notify/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o inode_mark.o \
-				   mark.o
+				   mark.o vfsmount_mark.o
 
 obj-y			+= dnotify/
 obj-y			+= inotify/
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 7c7a904..38f3fb5 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -24,6 +24,10 @@ extern void fsnotify_flush_notify(struct fsnotify_group *group);
 extern int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
 				   struct fsnotify_group *group, struct inode *inode,
 				   int allow_dups);
+/* add a mark to a vfsmount */
+extern int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
+				      struct fsnotify_group *group, struct vfsmount *mnt,
+				      int allow_dups);
 
 /* add a group to the inode group list */
 extern void fsnotify_add_inode_group(struct fsnotify_group *group);
@@ -32,6 +36,8 @@ extern void fsnotify_add_vfsmount_group(struct fsnotify_group *group);
 /* final kfree of a group */
 extern void fsnotify_final_destroy_group(struct fsnotify_group *group);
 
+/* vfsmount specific destruction of a mark */
+extern void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark);
 /* inode specific destruction of a mark */
 extern void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark);
 /* run the list of all marks associated with inode and flag them to be freed */
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 57bb1d7..d296ec9 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -115,15 +115,11 @@ void fsnotify_put_mark(struct fsnotify_mark *mark)
 void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 {
 	struct fsnotify_group *group;
-	struct inode *inode;
+	struct inode *inode = NULL;
 
 	spin_lock(&mark->lock);
 
 	group = mark->group;
-	inode = mark->i.inode;
-
-	BUG_ON(group && !inode);
-	BUG_ON(!group && inode);
 
 	/* if !group something else already marked this to die */
 	if (!group) {
@@ -136,8 +132,11 @@ void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 
 	spin_lock(&group->mark_lock);
 
-	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE)
+	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
 		fsnotify_destroy_inode_mark(mark);
+		inode = mark->i.inode;
+	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT)
+		fsnotify_destroy_vfsmount_mark(mark);
 	else
 		BUG();
 
@@ -169,8 +168,8 @@ void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 	 * is just a lazy update (and could be a perf win...)
 	 */
 
-
-	iput(inode);
+	if (inode)
+		iput(inode);
 
 	/*
 	 * it's possible that this group tried to destroy itself, but this
@@ -192,7 +191,6 @@ int fsnotify_add_mark(struct fsnotify_mark *mark,
 {
 	int ret = 0;
 
-	BUG_ON(mnt);
 	BUG_ON(inode && mnt);
 	BUG_ON(!inode && !mnt);
 
@@ -223,6 +221,10 @@ int fsnotify_add_mark(struct fsnotify_mark *mark,
 		ret = fsnotify_add_inode_mark(mark, group, inode, allow_dups);
 		if (ret)
 			goto err;
+	} else if (mnt) {
+		ret = fsnotify_add_vfsmount_mark(mark, group, mnt, allow_dups);
+		if (ret)
+			goto err;
 	} else {
 		BUG();
 	}
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
new file mode 100644
index 0000000..1b61d0a
--- /dev/null
+++ b/fs/notify/vfsmount_mark.c
@@ -0,0 +1,171 @@
+/*
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/writeback.h> /* for inode_lock */
+
+#include <asm/atomic.h>
+
+#include <linux/fsnotify_backend.h>
+#include "fsnotify.h"
+
+void fsnotify_clear_marks_by_mount(struct vfsmount *mnt)
+{
+	struct fsnotify_mark *mark, *lmark;
+	struct hlist_node *pos, *n;
+	LIST_HEAD(free_list);
+
+	spin_lock(&mnt->mnt_root->d_lock);
+	hlist_for_each_entry_safe(mark, pos, n, &mnt->mnt_fsnotify_marks, m.m_list) {
+		list_add(&mark->m.free_m_list, &free_list);
+		hlist_del_init(&mark->m.m_list);
+		fsnotify_get_mark(mark);
+	}
+	spin_unlock(&mnt->mnt_root->d_lock);
+
+	list_for_each_entry_safe(mark, lmark, &free_list, m.free_m_list) {
+		fsnotify_destroy_mark(mark);
+		fsnotify_put_mark(mark);
+	}
+}
+
+/*
+ * Recalculate the mask of events relevant to a given vfsmount locked.
+ */
+static void fsnotify_recalc_vfsmount_mask_locked(struct vfsmount *mnt)
+{
+	struct fsnotify_mark *mark;
+	struct hlist_node *pos;
+	__u32 new_mask = 0;
+
+	assert_spin_locked(&mnt->mnt_root->d_lock);
+
+	hlist_for_each_entry(mark, pos, &mnt->mnt_fsnotify_marks, m.m_list)
+		new_mask |= mark->mask;
+	mnt->mnt_fsnotify_mask = new_mask;
+}
+
+/*
+ * Recalculate the mnt->mnt_fsnotify_mask, or the mask of all FS_* event types
+ * any notifier is interested in hearing for this mount point
+ */
+void fsnotify_recalc_vfsmount_mask(struct vfsmount *mnt)
+{
+	spin_lock(&mnt->mnt_root->d_lock);
+	fsnotify_recalc_vfsmount_mask_locked(mnt);
+	spin_unlock(&mnt->mnt_root->d_lock);
+}
+
+void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark)
+{
+	struct vfsmount *mnt = mark->m.mnt;
+
+	assert_spin_locked(&mark->lock);
+	assert_spin_locked(&mark->group->mark_lock);
+
+	spin_lock(&mnt->mnt_root->d_lock);
+
+	hlist_del_init(&mark->m.m_list);
+	mark->m.mnt = NULL;
+
+	fsnotify_recalc_vfsmount_mask_locked(mnt);
+
+	spin_unlock(&mnt->mnt_root->d_lock);
+}
+
+static struct fsnotify_mark *fsnotify_find_vfsmount_mark_locked(struct fsnotify_group *group,
+								struct vfsmount *mnt)
+{
+	struct fsnotify_mark *mark;
+	struct hlist_node *pos;
+
+	assert_spin_locked(&mnt->mnt_root->d_lock);
+
+	hlist_for_each_entry(mark, pos, &mnt->mnt_fsnotify_marks, m.m_list) {
+		if (mark->group == group) {
+			fsnotify_get_mark(mark);
+			return mark;
+		}
+	}
+	return NULL;
+}
+
+/*
+ * given a group and vfsmount, find the mark associated with that combination.
+ * if found take a reference to that mark and return it, else return NULL
+ */
+struct fsnotify_mark *fsnotify_find_vfsmount_mark(struct fsnotify_group *group,
+						  struct vfsmount *mnt)
+{
+	struct fsnotify_mark *mark;
+
+	spin_lock(&mnt->mnt_root->d_lock);
+	mark = fsnotify_find_vfsmount_mark_locked(group, mnt);
+	spin_unlock(&mnt->mnt_root->d_lock);
+
+	return mark;
+}
+
+/*
+ * Attach an initialized mark to a given group and vfsmount.
+ * These marks may be used for the fsnotify backend to determine which
+ * event types should be delivered to which groups.
+ */
+int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
+			       struct fsnotify_group *group, struct vfsmount *mnt,
+			       int allow_dups)
+{
+	struct fsnotify_mark *lmark = NULL;
+	int ret = 0;
+
+	mark->flags = FSNOTIFY_MARK_FLAG_VFSMOUNT;
+
+	/*
+	 * LOCKING ORDER!!!!
+	 * mark->lock
+	 * group->mark_lock
+	 * mnt->mnt_root->d_lock
+	 */
+	assert_spin_locked(&mark->lock);
+	assert_spin_locked(&group->mark_lock);
+
+	spin_lock(&mnt->mnt_root->d_lock);
+
+	if (!allow_dups)
+		lmark = fsnotify_find_vfsmount_mark_locked(group, mnt);
+	if (!lmark) {
+		mark->m.mnt = mnt;
+
+		hlist_add_head(&mark->m.m_list, &mnt->mnt_fsnotify_marks);
+
+		fsnotify_recalc_vfsmount_mask_locked(mnt);
+	} else {
+		ret = -EEXIST;
+	}
+
+	spin_unlock(&mnt->mnt_root->d_lock);
+
+	return ret;
+}
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 27cccbe..f21ff1b 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -360,6 +360,8 @@ extern struct fsnotify_event *fsnotify_remove_notify_event(struct fsnotify_group
 
 /* functions used to manipulate the marks attached to inodes */
 
+/* run all marks associated with a vfsmount and update mnt->mnt_fsnotify_mask */
+extern void fsnotify_recalc_vfsmount_mask(struct vfsmount *mnt);
 /* run all marks associated with an inode and update inode->i_fsnotify_mask */
 extern void fsnotify_recalc_inode_mask(struct inode *inode);
 extern void fsnotify_init_mark(struct fsnotify_mark *mark, void (*free_mark)(struct fsnotify_mark *mark));

