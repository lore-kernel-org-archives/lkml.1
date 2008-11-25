Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYKYRXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYKYRXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbYKYRV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:21:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53950 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbYKYRV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:21:56 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v3 7/8] fsnotify: add in inode fsnotify markings
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org,
       a.p.zijlstra@chello.nl
Date: Tue, 25 Nov 2008 12:21:28 -0500
Message-ID: <20081125172128.17115.68117.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
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

 fs/inode.c                       |    7 +
 fs/notify/Makefile               |    2 
 fs/notify/fsnotify.c             |   26 ++++
 fs/notify/fsnotify.h             |   30 +++++
 fs/notify/group.c                |    6 +
 fs/notify/inode_mark.c           |  226 ++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h               |    6 +
 include/linux/fsnotify.h         |    8 +
 include/linux/fsnotify_backend.h |   21 ++++
 9 files changed, 331 insertions(+), 1 deletions(-)
 create mode 100644 fs/notify/inode_mark.c

diff --git a/fs/inode.c b/fs/inode.c
index 0487ddb..d17cd05 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -21,6 +21,7 @@
 #include <linux/cdev.h>
 #include <linux/bootmem.h>
 #include <linux/inotify.h>
+#include <linux/fsnotify.h>
 #include <linux/mount.h>
 
 /*
@@ -183,6 +184,11 @@ static struct inode *alloc_inode(struct super_block *sb)
 		}
 		inode->i_private = NULL;
 		inode->i_mapping = mapping;
+#ifdef CONFIG_FSNOTIFY
+		inode->i_fsnotify_mask = 0;
+		INIT_LIST_HEAD(&inode->i_fsnotify_mark_entries);
+		spin_lock_init(&inode->i_fsnotify_lock);
+#endif
 	}
 	return inode;
 }
@@ -191,6 +197,7 @@ void destroy_inode(struct inode *inode)
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
index 3c4262b..1d43bf4 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -25,18 +25,42 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
+void __fsnotify_inode_delete(struct inode *inode)
+{
+	if (likely(list_empty(&fsnotify_groups)))
+		return;
+
+	fsnotify_clear_mark_inode(inode, 0, FSNOTIFY_FORCE_CLEAR_MARK);
+}
+EXPORT_SYMBOL_GPL(__fsnotify_inode_delete);
+
 void fsnotify(struct file *file, struct dentry *dentry, struct inode *inode, unsigned long mask)
 {
 	struct fsnotify_group *group;
 	struct fsnotify_event *event = NULL;
+	struct inode *cinode;
 	int idx;
 
 	if (likely(list_empty(&fsnotify_groups)))
 		return;
 
+	if (file)
+		cinode = file->f_path.dentry->d_inode;
+	else if (dentry)
+		cinode = dentry->d_inode;
+	else if (inode)
+		cinode = inode;
+	else
+		BUG();
+
+	if (mask & FS_MODIFY)
+		fsnotify_clear_mark_inode(cinode, mask, 0);
+
 	if (!(mask & fsnotify_mask))
 		return;
 
+	if (!(mask & cinode->i_fsnotify_mask))
+		return;
 	/*
 	 * SRCU!!  the groups list is very very much read only and the path is
 	 * very hot (assuming something is using fsnotify)  Not blocking while
@@ -52,6 +76,8 @@ void fsnotify(struct file *file, struct dentry *dentry, struct inode *inode, uns
 	idx = srcu_read_lock(&fsnotify_grp_srcu_struct);
 	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
 		if (mask & group->mask) {
+			if (!group->ops->should_send_event(group, cinode, mask))
+				continue;
 			if (!event) {
 				event = fsnotify_create_event(file, dentry, inode, mask);
 				/* shit, we OOM'd and now we can't tell, lets hope something else blows up */
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 007bc28..e5e21a5 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -55,6 +55,29 @@ struct fsnotify_event {
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
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
+	unsigned long mask;		/* mask this mark entry is for */
+	struct inode *inode;		/* inode this entry is associated with */
+	void *private;			/* private data for the listener */
+	spinlock_t lock;		/* protect refcnt and killme */
+	int refcnt;			/* active things looking at this mark */
+	/* indication one of the users wants this object dead.  Kill will happen when refcnt hits 0 */
+	int killme;
+	struct list_head i_list;	/* list of mark_entries by inode->i_fsnotify_mark_entries */
+	struct list_head g_list;	/* list of mark_entries by group->i_fsnotify_mark_entries */
+};
+
 extern struct srcu_struct fsnotify_grp_srcu_struct;
 extern struct list_head fsnotify_groups;
 extern unsigned long fsnotify_mask;
@@ -66,4 +89,11 @@ extern void fsnotify_put_event(struct fsnotify_event *event);
 extern struct fsnotify_event *fsnotify_create_event(struct file *file, struct dentry *dentry, struct inode *inode, unsigned long mask);
 extern struct fsnotify_event_holder *fsnotify_alloc_event_holder(void);
 extern void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder);
+
+#define FSNOTIFY_FORCE_CLEAR_MARK	0x01
+extern void fsnotify_mark_get(struct fsnotify_mark_entry *entry);
+extern void fsnotify_mark_put(struct fsnotify_mark_entry *entry);
+extern void fsnotify_clear_mark_group(struct fsnotify_group *group);
+extern void fsnotify_kill_mark_inode(struct fsnotify_mark_entry *entry);
+extern void fsnotify_clear_mark_inode(struct inode *inode, unsigned long mask, unsigned int flags);
 #endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
index bb8d6c6..5e6f974 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -57,6 +57,9 @@ void fsnotify_kill_group(struct fsnotify_group *group)
 	/* clear the notification queue of all events */
 	fsnotify_clear_notif(group);
 
+	/* clear all inode mark entries for this group */
+	fsnotify_clear_mark_group(group);
+
 	kfree(group);
 }
 
@@ -115,6 +118,9 @@ struct fsnotify_group *fsnotify_find_group(unsigned int priority, unsigned int g
 	INIT_LIST_HEAD(&group->notification_list);
 	init_waitqueue_head(&group->notification_waitq);
 
+	mutex_init(&group->mark_mutex);
+	INIT_LIST_HEAD(&group->mark_entries);
+
 	group->ops = ops;
 
 	/* Do we need to be the first entry? */
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
new file mode 100644
index 0000000..7d95eeb
--- /dev/null
+++ b/fs/notify/inode_mark.c
@@ -0,0 +1,226 @@
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
+static void fsnotify_mark_kill(struct fsnotify_mark_entry *entry)
+{
+	entry->group = NULL;
+	entry->inode = NULL;
+	entry->mask = 0;
+	entry->private = NULL;
+	INIT_LIST_HEAD(&entry->i_list);
+	INIT_LIST_HEAD(&entry->g_list);
+	kmem_cache_free(fsnotify_mark_kmem_cache, entry);
+}
+
+static struct fsnotify_mark_entry *fsnotify_mark_alloc(void)
+{
+	struct fsnotify_mark_entry *entry;
+
+	entry = kmem_cache_alloc(fsnotify_mark_kmem_cache, GFP_KERNEL);
+
+	return entry;
+}
+
+void fsnotify_mark_get(struct fsnotify_mark_entry *entry)
+{
+	spin_lock(&entry->lock);
+	entry->refcnt++;
+	spin_unlock(&entry->lock);
+}
+
+void fsnotify_mark_put(struct fsnotify_mark_entry *entry)
+{
+	spin_lock(&entry->lock);
+	entry->refcnt--;
+	/* if (!refcnt && killme) we are off both lists and nothing else can find us. */
+	if ((!entry->refcnt) && (entry->killme)) {
+		spin_unlock(&entry->lock);
+		fsnotify_mark_kill(entry);
+		return;
+	}
+	spin_unlock(&entry->lock);
+}
+
+void fsnotify_clear_mark_group(struct fsnotify_group *group)
+{
+	struct fsnotify_mark_entry *entry;
+	struct inode *inode;
+
+	mutex_lock(&group->mark_mutex);
+	while (!list_empty(&group->mark_entries)) {
+		entry = list_first_entry(&group->mark_entries, struct fsnotify_mark_entry, g_list);
+
+		/* make sure the entry survives until it is off both lists */
+		fsnotify_mark_get(entry);
+
+		/* remove from g_list */
+		list_del_init(&entry->g_list);
+		mutex_unlock(&group->mark_mutex);
+
+		inode = entry->inode;
+
+		spin_lock(&entry->lock);
+		entry->killme = 1;
+		spin_unlock(&entry->lock);
+
+		/* remove from i_list */
+		spin_lock(&inode->i_fsnotify_lock);
+		list_del_init(&entry->i_list);
+		spin_unlock(&inode->i_fsnotify_lock);
+
+		/* off both lists, may free now */
+		fsnotify_mark_put(entry);
+
+		mutex_lock(&group->mark_mutex);
+	}
+	mutex_unlock(&group->mark_mutex);
+}
+
+/* called with entry->inode->fsnotify_mark_lock held! */
+void fsnotify_kill_mark_inode(struct fsnotify_mark_entry *entry)
+{
+	struct fsnotify_group *group = entry->group;
+	struct inode *inode = entry->inode;
+
+	/* make sure the entry survives until it is off both lists */
+	fsnotify_mark_get(entry);
+
+	list_del_init(&entry->i_list);
+	spin_unlock(&inode->i_fsnotify_lock);
+
+	spin_lock(&entry->lock);
+	entry->killme = 1;
+	spin_unlock(&entry->lock);
+
+	/* remove from g_list */
+	mutex_lock(&group->mark_mutex);
+	list_del_init(&entry->g_list);
+	mutex_unlock(&group->mark_mutex);
+
+	/* off both lists, may free now */
+	fsnotify_mark_put(entry);
+
+	spin_lock(&inode->i_fsnotify_lock);
+}
+
+void fsnotify_clear_mark_inode(struct inode *inode, unsigned long mask, unsigned int flags)
+{
+	struct fsnotify_mark_entry *entry;
+	LIST_HEAD(list);
+
+	spin_lock(&inode->i_fsnotify_lock);
+
+	/* blank the inode list and move all entries to a new list */
+	list_splice_init(&inode->i_fsnotify_mark_entries, &list);
+
+	/*
+	 * walk the new list letting each group decide how to handle it's mark.
+	 * we hold the inode->mark_lock so group unregister can't free out entries
+	 * under us.  Be careful if you drop this lock.
+	 */
+	while (!list_empty(&list)) {
+		entry = list_first_entry(&list, struct fsnotify_mark_entry, i_list);
+		entry->group->ops->mark_clear_inode(entry, inode, mask, flags);
+	}
+	spin_unlock(&inode->i_fsnotify_lock);
+}
+
+/*
+ * add (we use |=) the mark to the in core inode mark
+ *
+ * THIS FUNCTION RETURNS HOLDING THE INODE LOCK!!!
+ */
+struct fsnotify_mark_entry *fsnotify_mark_add(struct fsnotify_group *group, struct inode *inode, unsigned long mask)
+{
+	/* we initialize entry to shut up the compiler in case we just to out... */
+	struct fsnotify_mark_entry *entry = NULL, *lentry;
+
+	/* pre allocate an entry so we can hold the lock */
+	entry = fsnotify_mark_alloc();
+	if (!entry)
+		return NULL;
+
+	/*
+	 * this is the only place we hold both the group and the inode lock
+	 * we could take them in either order, but we take the mutex first
+	 * so we don't sleep holding the spinlock
+	 */
+	mutex_lock(&group->mark_mutex);
+	spin_lock(&inode->i_fsnotify_lock);
+	list_for_each_entry(lentry, &inode->i_fsnotify_mark_entries, i_list) {
+		if (lentry->group == group) {
+			lentry->mask |= mask;
+			/* we didn't use entry, kill it */
+			fsnotify_mark_kill(entry);
+			entry = lentry;
+			fsnotify_mark_get(entry);
+			goto out_unlock;
+		}
+	}
+
+	spin_lock_init(&entry->lock);
+	entry->refcnt = 1;
+	entry->group = group;
+	entry->mask = mask;
+	entry->inode = inode;
+	entry->killme = 0;
+	entry->private = NULL;
+
+	list_add(&entry->i_list, &inode->i_fsnotify_mark_entries);
+	list_add(&entry->g_list, &group->mark_entries);
+
+out_unlock:
+	mutex_unlock(&group->mark_mutex);
+	return entry;
+}
+
+void fsnotify_recalc_inode_mask(struct inode *inode)
+{
+	unsigned long new_mask = 0;
+	struct fsnotify_mark_entry *entry;
+
+	list_for_each_entry(entry, &inode->i_fsnotify_mark_entries, i_list) {
+		new_mask |= entry->mask;
+	}
+
+	inode->i_fsnotify_mask = new_mask;
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
index 0dcdd94..de1e477 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -664,6 +664,12 @@ struct inode {
 
 	__u32			i_generation;
 
+#ifdef CONFIG_FSNOTIFY
+	unsigned long		i_fsnotify_mask; /* all events this inode cares about */
+	struct list_head	i_fsnotify_mark_entries; /* fsnotify mark entries */
+	spinlock_t		i_fsnotify_lock; /* protect the entries list */
+#endif
+
 #ifdef CONFIG_DNOTIFY
 	unsigned long		i_dnotify_mask; /* Directory notify events */
 	struct dnotify_struct	*i_dnotify; /* for directory notifications */
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 6fbf455..efd1d85 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -81,6 +81,14 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 }
 
 /*
+ * fsnotify_inode_delete - and inode is being evicted from cache, clean up is needed
+ */
+static inline void fsnotify_inode_delete(struct inode *inode)
+{
+	__fsnotify_inode_delete(inode);
+}
+
+/*
  * fsnotify_inoderemove - an inode is going away
  */
 static inline void fsnotify_inoderemove(struct inode *inode)
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index e0b5528..d3fda04 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -40,9 +40,12 @@
 
 struct fsnotify_group;
 struct fsnotify_event;
+struct fsnotify_mark_entry;
 
 struct fsnotify_ops {
 	int (*event_to_notif)(struct fsnotify_group *group, struct fsnotify_event *event);
+	void (*mark_clear_inode)(struct fsnotify_mark_entry *entry, struct inode *inode, unsigned long mask, unsigned int flags);
+	int (*should_send_event)(struct fsnotify_group *group, struct inode *inode, unsigned long mask);
 };
 
 struct fsnotify_group {
@@ -58,6 +61,10 @@ struct fsnotify_group {
 	struct list_head notification_list;	/* list of event_holder this group needs to send to userspace */
 	wait_queue_head_t notification_waitq;	/* read() on the notification file blocks on this waitq */
 
+	/* stores all fastapth entries assoc with this group so they can be cleaned on unregister */
+	struct mutex mark_mutex;    /* protect mark_entries list */
+	struct list_head mark_entries; /* all inode mark entries for this group */
+
 	unsigned int priority;		/* order this group should receive msgs.  low first */
 };
 
@@ -65,16 +72,30 @@ struct fsnotify_group {
 
 /* called from the vfs to signal fs events */
 extern void fsnotify(struct file *file, struct dentry *dentry, struct inode *inode, unsigned long mask);
+extern void __fsnotify_inode_delete(struct inode *inode);
 
 /* called from fsnotify interfaces, such as fanotify or dnotify */
 extern void fsnotify_recalc_global_mask(void);
 extern void fsnotify_get_group(struct fsnotify_group *group);
 extern struct fsnotify_group *fsnotify_find_group(unsigned int priority, unsigned int group_num, unsigned long mask, struct fsnotify_ops *ops);
 extern void fsnotify_put_group(struct fsnotify_group *group);
+
+extern void fsnotify_recalc_inode_mask(struct inode *inode);
+extern void fsnotify_mark_get(struct fsnotify_mark_entry *entry);
+extern void fsnotify_mark_put(struct fsnotify_mark_entry *entry);
+extern void fsnotify_clear_mark_group(struct fsnotify_group *group);
+extern void fsnotify_kill_mark_inode(struct fsnotify_mark_entry *entry);
+extern void fsnotify_clear_mark_inode(struct inode *inode, unsigned long mask, unsigned int flags);
+extern struct fsnotify_mark_entry *fsnotify_mark_add(struct fsnotify_group *group, struct inode *inode, unsigned long mask);
+
 #else
 
 static inline void fsnotify(struct file *file, unsigned long mask)
 {}
+
+static inline void __fsnotify_inode_delete(struct inode *inode)
+{}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */

