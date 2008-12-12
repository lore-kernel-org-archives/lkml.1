Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbYLLVyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbYLLVyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbYLLVwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:52:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55998 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbYLLVwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:52:14 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH -v4 07/14] fsnotify: add in inode fsnotify markings
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk, hch@infradead.org,
       zbr@ioremap.net, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 12 Dec 2008 16:51:51 -0500
Message-ID: <20081212215151.27112.71399.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates in inode fsnotify markings.  dnotify will make use of in
inode markings to mark which inodes it wishes to send events for.  fanotify
will use this to mark which inodes it does not wish to send events for.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/inode.c                       |    6 +
 fs/notify/Makefile               |    2 
 fs/notify/fsnotify.c             |   13 ++
 fs/notify/fsnotify.h             |   31 ++++
 fs/notify/group.c                |   24 +++
 fs/notify/inode_mark.c           |  267 ++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h               |    5 +
 include/linux/fsnotify.h         |    9 +
 include/linux/fsnotify_backend.h |   22 +++
 9 files changed, 378 insertions(+), 1 deletions(-)
 create mode 100644 fs/notify/inode_mark.c

diff --git a/fs/inode.c b/fs/inode.c
index 0487ddb..a7f6397 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -21,6 +21,7 @@
 #include <linux/cdev.h>
 #include <linux/bootmem.h>
 #include <linux/inotify.h>
+#include <linux/fsnotify.h>
 #include <linux/mount.h>
 
 /*
@@ -183,6 +184,10 @@ static struct inode *alloc_inode(struct super_block *sb)
 		}
 		inode->i_private = NULL;
 		inode->i_mapping = mapping;
+#ifdef CONFIG_FSNOTIFY
+		inode->i_fsnotify_mask = 0;
+		INIT_LIST_HEAD(&inode->i_fsnotify_mark_entries);
+#endif
 	}
 	return inode;
 }
@@ -191,6 +196,7 @@ void destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
 	security_inode_free(inode);
+	fsnotify_inode_delete(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
diff --git a/fs/notify/Makefile b/fs/notify/Makefile
index 7cb285a..47b60f3 100644
--- a/fs/notify/Makefile
+++ b/fs/notify/Makefile
@@ -1,4 +1,4 @@
 obj-y			+= dnotify/
 obj-y			+= inotify/
 
-obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o
+obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o inode_mark.o
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 93a0e8f..61157f2 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -25,6 +25,15 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
+void __fsnotify_inode_delete(struct inode *inode, int flag)
+{
+	if (likely(list_empty(&fsnotify_groups)))
+		return;
+
+	fsnotify_clear_marks_by_inode(inode, flag);
+}
+EXPORT_SYMBOL_GPL(__fsnotify_inode_delete);
+
 void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is)
 {
 	struct fsnotify_group *group;
@@ -37,6 +46,8 @@ void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is)
 	if (!(mask & fsnotify_mask))
 		return;
 
+	if (!(mask & to_tell->i_fsnotify_mask))
+		return;
 	/*
 	 * SRCU!!  the groups list is very very much read only and the path is
 	 * very hot (assuming something is using fsnotify)  Not blocking while
@@ -52,6 +63,8 @@ void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is)
 	idx = srcu_read_lock(&fsnotify_grp_srcu_struct);
 	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
 		if (mask & group->mask) {
+			if (!group->ops->should_send_event(group, to_tell, mask))
+				continue;
 			if (!event) {
 				event = fsnotify_create_event(to_tell, mask, data, data_is);
 				/* shit, we OOM'd and now we can't tell, lets hope something else blows up */
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 15bc151..e6f4f0d 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -40,6 +40,31 @@ struct fsnotify_event {
 	struct list_head private_data_list;
 };
 
+/*
+ * a mark is simply an entry attached to an in core inode which allows an
+ * fsnotify listener to indicate they are either no longer interested in events
+ * of a type matching mask or only interested in those events.
+ *
+ * these are flushed when an inode is evicted from core and may be flushed
+ * when the inode is modified (as seen by fsnotify_access).  Some fsnotify users
+ * (such as dnotify) will flush these when the open fd is closed and not at
+ * inode eviction or modification.
+ */
+struct fsnotify_mark_entry {
+	struct fsnotify_group *group;	/* group this mark entry is for */
+	__u64 mask;		/* mask this mark entry is for */
+	struct inode *inode;		/* inode this entry is associated with */
+	void *private;			/* private data for the listener */
+	spinlock_t lock;		/* protect group, inode, and killme */
+	atomic_t refcnt;		/* active things looking at this mark */
+	int freeme;			/* free when this is set and refcnt hits 0 */
+	struct list_head i_list;	/* list of mark_entries by inode->i_fsnotify_mark_entries */
+	struct list_head g_list;	/* list of mark_entries by group->i_fsnotify_mark_entries */
+	struct list_head free_i_list;	/* tmp list used when freeing this mark */
+	struct list_head free_g_list;	/* tmp list used when freeing this mark */
+	void (*free_private)(struct fsnotify_mark_entry *entry); /* called on final put+free */
+};
+
 extern struct srcu_struct fsnotify_grp_srcu_struct;
 extern struct list_head fsnotify_groups;
 extern __u64 fsnotify_mask;
@@ -48,4 +73,10 @@ extern void fsnotify_get_event(struct fsnotify_event *event);
 extern void fsnotify_put_event(struct fsnotify_event *event);
 extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event);
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is);
+
+extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
+extern void fsnotify_clear_marks_by_inode(struct inode *inode, unsigned int flags);
+extern void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry);
+extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
+extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
 #endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
index 0dd6e82..1ed97fe 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -47,6 +47,24 @@ void fsnotify_recalc_global_mask(void)
 	fsnotify_mask = mask;
 }
 
+void fsnotify_recalc_group_mask(struct fsnotify_group *group)
+{
+	__u64 mask = 0;
+	unsigned long old_mask = group->mask;
+	struct fsnotify_mark_entry *entry;
+
+	spin_lock(&group->mark_lock);
+	list_for_each_entry(entry, &group->mark_entries, g_list) {
+		mask |= entry->mask;
+	}
+	spin_unlock(&group->mark_lock);
+
+	group->mask = mask;
+
+	if (old_mask != mask)
+		fsnotify_recalc_global_mask();
+}
+
 static void fsnotify_add_group(struct fsnotify_group *group)
 {
 	int priority = group->priority;
@@ -73,6 +91,9 @@ void fsnotify_get_group(struct fsnotify_group *group)
 
 static void fsnotify_destroy_group(struct fsnotify_group *group)
 {
+	/* clear all inode mark entries for this group */
+	fsnotify_clear_marks_by_group(group);
+
 	if (group->ops->free_group_priv)
 		group->ops->free_group_priv(group);
 
@@ -147,6 +168,9 @@ struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int
 	group->group_num = group_num;
 	group->mask = mask;
 
+	spin_lock_init(&group->mark_lock);
+	INIT_LIST_HEAD(&group->mark_entries);
+
 	group->ops = ops;
 	group->private = NULL;
 
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
new file mode 100644
index 0000000..c68adff
--- /dev/null
+++ b/fs/notify/inode_mark.c
@@ -0,0 +1,267 @@
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
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include <asm/atomic.h>
+
+#include <linux/fsnotify_backend.h>
+#include "fsnotify.h"
+
+static struct kmem_cache *fsnotify_mark_kmem_cache;
+
+static void fsnotify_destroy_mark(struct fsnotify_mark_entry *entry)
+{
+	entry->group = NULL;
+	entry->inode = NULL;
+	entry->mask = 0;
+	if (entry->free_private) {
+		entry->free_private(entry);
+	}
+	entry->private = NULL;
+	INIT_LIST_HEAD(&entry->i_list);
+	INIT_LIST_HEAD(&entry->g_list);
+	INIT_LIST_HEAD(&entry->free_i_list);
+	INIT_LIST_HEAD(&entry->free_g_list);
+	kmem_cache_free(fsnotify_mark_kmem_cache, entry);
+}
+
+static struct fsnotify_mark_entry *fsnotify_alloc_mark(void)
+{
+	struct fsnotify_mark_entry *entry;
+
+	entry = kmem_cache_alloc(fsnotify_mark_kmem_cache, GFP_KERNEL);
+
+	return entry;
+}
+
+void fsnotify_get_mark(struct fsnotify_mark_entry *entry)
+{
+	atomic_inc(&entry->refcnt);
+}
+
+void fsnotify_put_mark(struct fsnotify_mark_entry *entry)
+{
+	if (atomic_dec_and_test(&entry->refcnt)) {
+		spin_lock(&entry->lock);
+		/* entries can only be found by the kernel by searching the
+		 * inode->i_fsnotify_entries or the group->mark_entries lists.
+		 * if freeme is set that means this entry is off both lists.
+		 * if refcnt is 0 that means we are the last thing still
+		 * looking at this entry, so its time to free.
+		 */
+		if (!atomic_read(&entry->refcnt) && entry->freeme) {
+			spin_unlock(&entry->lock);
+			fsnotify_destroy_mark(entry);
+			return;
+		}
+		spin_unlock(&entry->lock);
+	}
+}
+
+void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
+{
+	struct fsnotify_mark_entry *lentry, *entry;
+	struct inode *inode;
+	LIST_HEAD(free_list);
+
+	spin_lock(&group->mark_lock);
+	list_for_each_entry_safe(entry, lentry, &group->mark_entries, g_list) {
+		list_del_init(&entry->g_list);
+		list_add(&entry->free_g_list, &free_list);
+	}
+	spin_unlock(&group->mark_lock);
+
+	list_for_each_entry_safe(entry, lentry, &free_list, free_g_list) {
+		fsnotify_get_mark(entry);
+		spin_lock(&entry->lock);
+		inode = entry->inode;
+		if (!inode) {
+			entry->group = NULL;
+			spin_unlock(&entry->lock);
+			fsnotify_put_mark(entry);
+			continue;
+		}
+		spin_lock(&inode->i_lock);
+
+		list_del_init(&entry->i_list);
+		entry->inode = NULL;
+		list_del_init(&entry->g_list);
+		entry->group = NULL;
+		entry->freeme = 1;
+
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&entry->lock);
+
+		fsnotify_put_mark(entry);
+	}
+}
+
+void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
+{
+	struct fsnotify_group *group;
+	struct inode *inode;
+
+	fsnotify_get_mark(entry);
+
+	spin_lock(&entry->lock);
+
+	group = entry->group;
+	if (group)
+		spin_lock(&group->mark_lock);
+
+	inode = entry->inode;
+	if (inode)
+		spin_lock(&inode->i_lock);
+
+	list_del_init(&entry->i_list);
+	entry->inode = NULL;
+	list_del_init(&entry->g_list);
+	entry->group = NULL;
+	entry->freeme = 1;
+
+	if (inode)
+		spin_unlock(&inode->i_lock);
+	if (group)
+		spin_unlock(&group->mark_lock);
+
+	spin_unlock(&entry->lock);
+
+	fsnotify_put_mark(entry);
+}
+
+void fsnotify_clear_marks_by_inode(struct inode *inode, unsigned int flags)
+{
+	struct fsnotify_mark_entry *lentry, *entry;
+	LIST_HEAD(free_list);
+
+	spin_lock(&inode->i_lock);
+	list_for_each_entry_safe(entry, lentry, &inode->i_fsnotify_mark_entries, i_list) {
+		list_del_init(&entry->i_list);
+		list_add(&entry->free_i_list, &free_list);
+	}
+	spin_unlock(&inode->i_lock);
+
+	/*
+	 * at this point destroy_by_* might race.
+	 *
+	 * we used list_del_init() so it can be list_del_init'd again, no harm.
+	 * we were called from an inode function so we know that other user can
+	 * try to grab entry->inode->i_lock without a problem.
+	 */
+	list_for_each_entry_safe(entry, lentry, &free_list, free_i_list) {
+		fsnotify_get_mark(entry);
+		entry->group->ops->mark_clear_inode(entry, inode, flags);
+		fsnotify_put_mark(entry);
+	}
+}
+
+/* caller must hold inode->i_lock */
+struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *group, struct inode *inode)
+{
+	struct fsnotify_mark_entry *entry;
+
+	list_for_each_entry(entry, &inode->i_fsnotify_mark_entries, i_list) {
+		if (entry->group == group) {
+			fsnotify_get_mark(entry);
+			return entry;
+		}
+	}
+	return NULL;
+}
+/*
+ * This is a low use function called when userspace is changing what is being
+ * watched.  I don't mind doing the allocation since I'm assuming we will have
+ * more new events than we have adding to old events...
+ *
+ * add (we use |=) the mark to the in core inode mark, if you need to change
+ * rather than | some new bits you needs to fsnotify_destroy_mark_by_inode()
+ * then call this with all the right bits in the mask.
+ */
+struct fsnotify_mark_entry *fsnotify_mark_add(struct fsnotify_group *group, struct inode *inode, __u64 mask)
+{
+	/* we initialize entry to shut up the compiler in case we just to out... */
+	struct fsnotify_mark_entry *entry = NULL, *lentry;
+
+	/* pre allocate an entry so we can hold the lock */
+	entry = fsnotify_alloc_mark();
+	if (!entry)
+		return NULL;
+
+	/*
+	 * LOCKING ORDER!!!!
+	 * entry->lock
+	 * group->mark_lock
+	 * inode->i_lock
+	 */
+	spin_lock(&group->mark_lock);
+	spin_lock(&inode->i_lock);
+	lentry = fsnotify_find_mark_entry(group, inode);
+	if (lentry) {
+		/* we didn't use the new entry, kill it */
+		fsnotify_destroy_mark(entry);
+		entry = lentry;
+		entry->mask |= mask;
+		goto out_unlock;
+	}
+
+	spin_lock_init(&entry->lock);
+	atomic_set(&entry->refcnt, 1);
+	entry->group = group;
+	entry->mask = mask;
+	entry->inode = inode;
+	entry->freeme = 0;
+	entry->private = NULL;
+	entry->free_private = group->ops->free_mark_priv;
+
+	list_add(&entry->i_list, &inode->i_fsnotify_mark_entries);
+	list_add(&entry->g_list, &group->mark_entries);
+
+out_unlock:
+	spin_unlock(&inode->i_lock);
+	spin_unlock(&group->mark_lock);
+	return entry;
+}
+
+void fsnotify_recalc_inode_mask(struct inode *inode)
+{
+	unsigned long new_mask = 0;
+	struct fsnotify_mark_entry *entry;
+
+	spin_lock(&inode->i_lock);
+	list_for_each_entry(entry, &inode->i_fsnotify_mark_entries, i_list) {
+		new_mask |= entry->mask;
+	}
+	inode->i_fsnotify_mask = new_mask;
+	spin_unlock(&inode->i_lock);
+}
+
+
+__init int fsnotify_mark_init(void)
+{
+	fsnotify_mark_kmem_cache = kmem_cache_create("fsnotify_mark_entry", sizeof(struct fsnotify_mark_entry), 0, SLAB_PANIC, NULL);
+
+	return 0;
+}
+subsys_initcall(fsnotify_mark_init);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4a853ef..b5a7bce 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -665,6 +665,11 @@ struct inode {
 
 	__u32			i_generation;
 
+#ifdef CONFIG_FSNOTIFY
+	__u64			i_fsnotify_mask; /* all events this inode cares about */
+	struct list_head	i_fsnotify_mark_entries; /* fsnotify mark entries */
+#endif
+
 #ifdef CONFIG_DNOTIFY
 	unsigned long		i_dnotify_mask; /* Directory notify events */
 	struct dnotify_struct	*i_dnotify; /* for directory notifications */
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index b084b98..c2ed916 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -99,6 +99,14 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 }
 
 /*
+ * fsnotify_inode_delete - and inode is being evicted from cache, clean up is needed
+ */
+static inline void fsnotify_inode_delete(struct inode *inode)
+{
+	__fsnotify_inode_delete(inode, FSNOTIFY_INODE_DESTROY);
+}
+
+/*
  * fsnotify_inoderemove - an inode is going away
  */
 static inline void fsnotify_inoderemove(struct inode *inode)
@@ -107,6 +115,7 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 	inotify_inode_is_dead(inode);
 
 	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE);
+	__fsnotify_inode_delete(inode, FSNOTIFY_LAST_DENTRY);
 }
 
 /*
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 924902e..0482a14 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/spinlock.h>
 #include <linux/wait.h>
 
 #include <asm/atomic.h>
@@ -68,13 +69,21 @@
 #define FSNOTIFY_EVENT_FILE     1
 #define FSNOTIFY_EVENT_INODE    2
 
+/* these tell __fsnotify_inode_delete what kind of event this is */
+#define FSNOTIFY_LAST_DENTRY	1
+#define FSNOTIFY_INODE_DESTROY	2
+
 struct fsnotify_group;
 struct fsnotify_event;
+struct fsnotify_mark_entry;
 
 struct fsnotify_ops {
 	int (*event_to_notif)(struct fsnotify_group *group, struct fsnotify_event *event);
+	void (*mark_clear_inode)(struct fsnotify_mark_entry *entry, struct inode *inode, unsigned int flags);
+	int (*should_send_event)(struct fsnotify_group *group, struct inode *inode, __u64 mask);
 	void (*free_group_priv)(struct fsnotify_group *group);
 	void (*free_event_priv)(struct fsnotify_group *group, struct fsnotify_event *event);
+	void (*free_mark_priv)(struct fsnotify_mark_entry *entry);
 };
 
 struct fsnotify_group {
@@ -85,6 +94,10 @@ struct fsnotify_group {
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
+	/* stores all fastapth entries assoc with this group so they can be cleaned on unregister */
+	spinlock_t mark_lock;    /* protect mark_entries list */
+	struct list_head mark_entries; /* all inode mark entries for this group */
+
 	unsigned int priority;		/* order this group should receive msgs.  low first */
 
 	void *private;			/* private data for implementers (dnotify, inotify, fanotify) */
@@ -94,17 +107,26 @@ struct fsnotify_group {
 
 /* called from the vfs to signal fs events */
 extern void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is);
+extern void __fsnotify_inode_delete(struct inode *inode, int flag);
 
 /* called from fsnotify interfaces, such as fanotify or dnotify */
 extern void fsnotify_recalc_global_mask(void);
+extern void fsnotify_recalc_group_mask(struct fsnotify_group *group);
 extern struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int group_num, __u64 mask, const struct fsnotify_ops *ops);
 extern void fsnotify_put_group(struct fsnotify_group *group);
 extern void fsnotify_get_group(struct fsnotify_group *group);
 
+extern void fsnotify_recalc_inode_mask(struct inode *inode);
+extern struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *group, struct inode *inode);
+extern struct fsnotify_mark_entry *fsnotify_mark_add(struct fsnotify_group *group, struct inode *inode, __u64 mask);
 #else
 
 static inline void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is);
 {}
+
+static inline void __fsnotify_inode_delete(struct inode *inode, int flag)
+{}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */

