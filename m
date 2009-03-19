Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbZCSSHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbZCSSHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbZCSSGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:06:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45983 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468AbZCSSGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:06:43 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 04/13] fsnotify: add in inode fsnotify markings
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Thu, 19 Mar 2009 14:05:14 -0400
Message-ID: <20090319180514.17449.34794.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
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

 Documentation/filesystems/fsnotify.txt |  180 ++++++++++++++++++++++++++
 fs/inode.c                             |    9 +
 fs/notify/Makefile                     |    2 
 fs/notify/fsnotify.c                   |   10 +
 fs/notify/fsnotify.h                   |    3 
 fs/notify/group.c                      |   24 +++
 fs/notify/inode_mark.c                 |  224 ++++++++++++++++++++++++++++++++
 include/linux/fs.h                     |    5 +
 include/linux/fsnotify.h               |    9 +
 include/linux/fsnotify_backend.h       |   54 ++++++++
 10 files changed, 518 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/filesystems/fsnotify.txt
 create mode 100644 fs/notify/inode_mark.c

diff --git a/Documentation/filesystems/fsnotify.txt b/Documentation/filesystems/fsnotify.txt
new file mode 100644
index 0000000..e1c90f5
--- /dev/null
+++ b/Documentation/filesystems/fsnotify.txt
@@ -0,0 +1,180 @@
+fsnotify inode mark locking/lifetime/and refcnting
+
+struct fsnotify_mark_entry {
+        __u32 mask;                     /* mask this mark entry is for */
+        /* we hold ref for each i_list and g_list.  also one ref for each 'thing'
+         * in kernel that found and may be using this mark. */
+        atomic_t refcnt;                /* active things looking at this mark */
+        struct inode *inode;            /* inode this entry is associated with */
+        struct fsnotify_group *group;   /* group this mark entry is for */
+        struct hlist_node i_list;       /* list of mark_entries by inode->i_fsnotify_mark_entries */
+        struct list_head g_list;        /* list of mark_entries by group->i_fsnotify_mark_entries */
+        spinlock_t lock;                /* protect group, inode, and killme */
+        struct list_head free_i_list;   /* tmp list used when freeing this mark */
+        struct list_head free_g_list;   /* tmp list used when freeing this mark */
+        void (*free_mark)(struct fsnotify_mark_entry *entry); /* called on final put+free */
+};
+
+REFCNT:
+The mark->refcnt tells how many "things" in the kernel currectly are
+referencing this object.  The object typically will live inside the kernel
+with a refcnt of 2, one for each list it is on (i_list, g_list).  Any task
+which can find this object holding the appropriete locks, can take a reference
+and the object itself is guarenteed to survive until the reference is dropped.
+
+LOCKING:
+There are 3 spinlocks involved with fsnotify inode marks and they MUST
+be taking in order as follows:
+
+entry->lock
+group->mark_lock
+inode->i_lock
+
+entry->lock protects 2 things, entry->group and entry->inode.  You must hold
+that lock to dereference either of these things (they could be NULL even with
+the lock)
+
+group->mark_lock protects the mark_entries list anchored inside a given group
+and each entry is hooked via the g_list.  It also sorta protects the
+free_g_list, which when used is anchored by a private list on the stack of the
+task which held the group->mark_lock.
+
+inode->i_lock protects the i_fsnotify_mark_entries list anchored inside a
+given inode and each entry is hooked via the i_list. (and sorta the
+free_i_list)
+
+
+LIFETIME:
+Inode marks survive between when they are added to an inode and when their
+refcnt==0.
+
+The inode mark can be cleared for a number of different reasons including:
+- The inode is unlinked for the last time.  (fsnotify_inoderemove)
+- The inode is being evicted from cache. (fsnotify_inode_delete)
+- The fs the inode is on is unmounted.  (fsnotify_inode_delete/fsnotify_unmount_inodes)
+- Something explicitly requests that it be removed.  (fsnotify_destroy_mark_by_entry)
+- The fsnotify_group associated with the mark is going away and all such marks
+  need to be cleaned up. (fsnotify_clear_marks_by_group)
+
+Worst case we are given an inode and need to clean up all the marks on that
+inode.  We take i_lock and walk the i_fsnotify_mark_entries safely.  For each
+mark on the list we take a reference (so the mark can't disappear under us).
+We remove that mark form the inode's list of marks and we add this mark to a
+private list anchored on the stack using i_free_list;  At this point we no
+longer fear anything finding the mark using the inode's list of marks.
+
+We can safely and locklessly run the private list on the stack of everything
+we just unattached from the original inode.  For each mark on the private list
+we grab the mark-> and can thus dereference mark->group and mark->inode.  If
+we see the group and inode are not NULL we take those locks.  Now holding all
+3 locks we can completely remove the mark from other tasks finding it in the
+future.  Remember, 10 things might already be referencing this mark, but they
+better be holding a ref.  We drop our reference we took before we unhooked it
+from the inode.  When the ref hits 0 we can free the mark.
+
+Very similarly for freeing by group, except we use free_g_list.
+
+This has the very interesting property of being able to run concurrently with
+any (or all) other directions.  Lets walk through what happens with every
+combination trying to simultaneously mark this entry for destruction.
+
+(A) finds this event by some means and takes a reference.  (this could be any
+means including in the case of inotify through an idr, which is known to be
+safe since the idr entry itself holds a reference)
+(B) finds this event by some means and takes a reference.
+
+At this point.
+	refcnt == 4
+	i_list -> inode
+	inode -> inode
+	g_list -> group
+	group -> group
+	free_i_list -> NULL
+	free_g_list -> NULL
+
+(C) comes in and tries to free all of the fsnotify_mark attached to an inode.
+---- C  will take the i_lock and walk the i_fsnotify_mark entries list calling
+	list_del_init() on i_list, adding the entry to it's private list via
+	free_i_list, and taking a reference.  C releases the i_lock.  Start
+	walking the private list and block on the entry->lock (held by A
+	below)
+
+At this point.
+	refcnt == 5
+	i_list -> NULL
+	inode -> inode
+	g_list -> group
+	group -> group
+	free_i_list -> private list on (C) stack
+	free_g_list -> NULL
+
+(D) comes in and tries to free all of the marks attached to the same inode.
+---- D  will take the i_lock and won't find this entry on the list and does
+	nothing.  (this is the end of D)
+
+(E) comes along and wants to free all of the marks in the group.
+---- E  take the group->mark_lock walk the group->mark_entry.  grab a
+	reference to the mark, list_del_init the g_list.  Add the mark to the
+	free_g_list.  Release the group->mark_lock.  Now start walking the new
+	private list and block in entry->lock.
+
+**This is actually the point where the kernel cannot find this mark **
+
+At this point.
+	refcnt == 6
+	i_list -> NULL
+	inode -> inode
+	g_list -> NULL
+	group -> group
+	free_i_list -> private list on (C) stack
+	free_g_list -> private list on (E) stack
+
+(A) finally decides it wants to kill this entry for some reason.
+---- A  will take the entry->lock.  It will check if mark->group is non-NULL
+	and if so takes mark->group->mark_lock (it may have blocked here on D
+	above).  Check the ->inode and if set take mark->inode->i_lock (again
+	we may have been blocking on C).  We now own all the locks.  So
+	list_del_init on i_list and g_list.  set ->inode and ->group = NULL
+	drop those refs.  Unlock i_lock, mark_lock, and entry->lock.  Drop our
+	reference.   (this is the end of A)
+
+**Diff sequence of events this could be the point where the object is no
+longer able to be found**
+
+At this point.
+	refcnt == 3
+	i_list -> NUL
+	inode -> NULL
+	g_list -> NUL
+	group -> NULL
+	free_i_list -> private list on (C) stack
+	free_g_list -> private list on (E) stack
+
+(D) happens to be the one to win the entry->lock.
+---- D  sees that ->inode and ->group and NULL so it just doesn't bother to
+	grab those locks (if they are NULL we know this mark if off the
+	relevant lists).  So D doesn't do anything.  It sees that the mark is
+	off the lists so all it need to do is drop it's reference.
+
+At this point.
+	refcnt == 2
+	i_list -> NUL
+	inode -> NULL
+	g_list -> NUL
+	group -> NULL
+	free_i_list -> private list on (C) stack
+	free_g_list -> undefined
+
+(C) does the same thing as B and the mark looks like:
+
+At this point.
+	refcnt == 1
+	i_list -> NUL
+	inode -> NULL
+	g_list -> NUL
+	group -> NULL
+	free_i_list -> undefined
+	free_g_list -> undefined
+
+(B) is the only thing left with a reference when it drops that reference the
+object will get freed.
diff --git a/fs/inode.c b/fs/inode.c
index f2e0f3d..6a9a98e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -22,6 +22,7 @@
 #include <linux/cdev.h>
 #include <linux/bootmem.h>
 #include <linux/inotify.h>
+#include <linux/fsnotify.h>
 #include <linux/mount.h>
 #include <linux/async.h>
 
@@ -189,6 +190,10 @@ struct inode *inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
 
+#ifdef CONFIG_FSNOTIFY
+	inode->i_fsnotify_mask = 0;
+#endif
+
 	return inode;
 
 out_free_security:
@@ -220,6 +225,7 @@ void destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
 	security_inode_free(inode);
+	fsnotify_inode_delete(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
@@ -251,6 +257,9 @@ void inode_init_once(struct inode *inode)
 	INIT_LIST_HEAD(&inode->inotify_watches);
 	mutex_init(&inode->inotify_mutex);
 #endif
+#ifdef CONFIG_FSNOTIFY
+	INIT_HLIST_HEAD(&inode->i_fsnotify_mark_entries);
+#endif
 }
 
 EXPORT_SYMBOL(inode_init_once);
diff --git a/fs/notify/Makefile b/fs/notify/Makefile
index db5467b..0922cc8 100644
--- a/fs/notify/Makefile
+++ b/fs/notify/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o
+obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o inode_mark.o
 
 obj-y			+= dnotify/
 obj-y			+= inotify/
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 56bee0f..4cc2d46 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -25,6 +25,12 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
+void __fsnotify_inode_delete(struct inode *inode)
+{
+	fsnotify_clear_marks_by_inode(inode);
+}
+EXPORT_SYMBOL_GPL(__fsnotify_inode_delete);
+
 /*
  * This is the main call to fsnotify.  The VFS calls into hook specific functions
  * in linux/fsnotify.h.  Those functions then in turn call here.  Here will call
@@ -43,6 +49,8 @@ void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is)
 	if (!(mask & fsnotify_mask))
 		return;
 
+	if (!(mask & to_tell->i_fsnotify_mask))
+		return;
 	/*
 	 * SRCU!!  the groups list is very very much read only and the path is
 	 * very hot.  The VAST majority of events are not going to need to do
@@ -51,6 +59,8 @@ void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is)
 	idx = srcu_read_lock(&fsnotify_grp_srcu);
 	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
 		if (mask & group->mask) {
+			if (!group->ops->should_send_event(group, to_tell, mask))
+				continue;
 			if (!event) {
 				event = fsnotify_create_event(to_tell, mask, data, data_is);
 				/* shit, we OOM'd and now we can't tell, maybe
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index bf41e60..be842e2 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -14,4 +14,7 @@
 extern struct srcu_struct fsnotify_grp_srcu;
 extern struct list_head fsnotify_groups;
 extern __u32 fsnotify_mask;
+
+extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
+extern void fsnotify_clear_marks_by_inode(struct inode *inode);
 #endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
index dd1d18d..db7ddf5 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -47,6 +47,24 @@ void fsnotify_recalc_global_mask(void)
 	fsnotify_mask = mask;
 }
 
+void fsnotify_recalc_group_mask(struct fsnotify_group *group)
+{
+	__u32 mask = 0;
+	__u32 old_mask = group->mask;
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
@@ -73,6 +91,9 @@ static void fsnotify_get_group(struct fsnotify_group *group)
 
 static void fsnotify_destroy_group(struct fsnotify_group *group)
 {
+	/* clear all inode mark entries for this group */
+	fsnotify_clear_marks_by_group(group);
+
 	if (group->ops->free_group_priv)
 		group->ops->free_group_priv(group);
 
@@ -160,6 +181,9 @@ struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int
 	group->group_num = group_num;
 	group->mask = mask;
 
+	spin_lock_init(&group->mark_lock);
+	INIT_LIST_HEAD(&group->mark_entries);
+
 	group->ops = ops;
 
 	mutex_lock(&fsnotify_grp_mutex);
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
new file mode 100644
index 0000000..facd561
--- /dev/null
+++ b/fs/notify/inode_mark.c
@@ -0,0 +1,224 @@
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
+void fsnotify_get_mark(struct fsnotify_mark_entry *entry)
+{
+	atomic_inc(&entry->refcnt);
+}
+
+void fsnotify_put_mark(struct fsnotify_mark_entry *entry)
+{
+	if (atomic_dec_and_test(&entry->refcnt))
+		entry->free_mark(entry);
+}
+
+/*
+ * recalculate the mask of events relevant to a given inode locked.
+ */
+static void fsnotify_recalc_inode_mask_locked(struct inode *inode)
+{
+	struct fsnotify_mark_entry *entry;
+	struct hlist_node *pos;
+	__u32 new_mask = 0;
+
+	assert_spin_locked(&inode->i_lock);
+
+	hlist_for_each_entry(entry, pos, &inode->i_fsnotify_mark_entries, i_list) {
+		new_mask |= entry->mask;
+	}
+	inode->i_fsnotify_mask = new_mask;
+}
+
+/*
+ * recalculate the mask of events relevant to a given inode.
+ */
+void fsnotify_recalc_inode_mask(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	fsnotify_recalc_inode_mask_locked(inode);
+	spin_unlock(&inode->i_lock);
+}
+
+/*
+ * Any time a mark is getting freed we end up here.
+ * The caller had better be holding a reference to this mark so we don't actually
+ * do the final put under the entry->lock
+ */
+void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
+{
+	struct fsnotify_group *group;
+	struct inode *inode;
+
+	spin_lock(&entry->lock);
+
+	group = entry->group;
+	inode = entry->inode;
+
+	BUG_ON(group && !inode);
+	BUG_ON(!group && inode);
+
+	/* if !group something else already marked this to die */
+	if (!group) {
+		spin_unlock(&entry->lock);
+		return;
+	}
+
+	/* this just tests that the caller held a reference */
+	if (unlikely(atomic_read(&entry->refcnt) < 3))
+		BUG();
+
+	spin_lock(&group->mark_lock);
+	spin_lock(&inode->i_lock);
+
+	hlist_del_init(&entry->i_list);
+	entry->inode = NULL;
+	fsnotify_put_mark(entry); /* for i_list */
+
+	list_del_init(&entry->g_list);
+	entry->group = NULL;
+	fsnotify_put_mark(entry); /* for g_list */
+
+	fsnotify_recalc_inode_mask_locked(inode);
+
+	spin_unlock(&inode->i_lock);
+	spin_unlock(&group->mark_lock);
+	spin_unlock(&entry->lock);
+
+	group->ops->freeing_mark(entry, group);
+}
+
+void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
+{
+	struct fsnotify_mark_entry *lentry, *entry;
+	LIST_HEAD(free_list);
+
+	spin_lock(&group->mark_lock);
+	list_for_each_entry_safe(entry, lentry, &group->mark_entries, g_list) {
+		list_add(&entry->free_g_list, &free_list);
+		list_del_init(&entry->g_list);
+		fsnotify_get_mark(entry);
+	}
+	spin_unlock(&group->mark_lock);
+
+	list_for_each_entry_safe(entry, lentry, &free_list, free_g_list) {
+		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_put_mark(entry);
+	}
+}
+
+void fsnotify_clear_marks_by_inode(struct inode *inode)
+{
+	struct fsnotify_mark_entry *entry, *lentry;
+	struct hlist_node *pos, *n;
+	LIST_HEAD(free_list);
+
+	spin_lock(&inode->i_lock);
+	hlist_for_each_entry_safe(entry, pos, n, &inode->i_fsnotify_mark_entries, i_list) {
+		list_add(&entry->free_i_list, &free_list);
+		hlist_del_init(&entry->i_list);
+		fsnotify_get_mark(entry);
+	}
+	spin_unlock(&inode->i_lock);
+
+	list_for_each_entry_safe(entry, lentry, &free_list, free_i_list) {
+		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_put_mark(entry);
+	}
+}
+
+struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *group, struct inode *inode)
+{
+	struct fsnotify_mark_entry *entry;
+	struct hlist_node *pos;
+
+	assert_spin_locked(&inode->i_lock);
+
+	hlist_for_each_entry(entry, pos, &inode->i_fsnotify_mark_entries, i_list) {
+		if (entry->group == group) {
+			fsnotify_get_mark(entry);
+			return entry;
+		}
+	}
+	return NULL;
+}
+
+void fsnotify_init_mark(struct fsnotify_mark_entry *entry, void (*free_mark)(struct fsnotify_mark_entry *entry))
+
+{
+	spin_lock_init(&entry->lock);
+	atomic_set(&entry->refcnt, 1);
+	INIT_HLIST_NODE(&entry->i_list);
+	entry->group = NULL;
+	entry->mask = 0;
+	entry->inode = NULL;
+	entry->free_mark = free_mark;
+}
+
+int fsnotify_add_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group, struct inode *inode)
+{
+	struct fsnotify_mark_entry *lentry;
+	int ret = 0;
+
+	/*
+	 * LOCKING ORDER!!!!
+	 * entry->lock
+	 * group->mark_lock
+	 * inode->i_lock
+	 */
+	spin_lock(&entry->lock);
+	spin_lock(&group->mark_lock);
+	spin_lock(&inode->i_lock);
+
+	entry->group = group;
+	entry->inode = inode;
+
+	lentry = fsnotify_find_mark_entry(group, inode);
+	if (!lentry) {
+		hlist_add_head(&entry->i_list, &inode->i_fsnotify_mark_entries);
+		list_add(&entry->g_list, &group->mark_entries);
+
+		fsnotify_get_mark(entry); /* for i_list */
+		fsnotify_get_mark(entry); /* for g_list */
+
+		fsnotify_recalc_inode_mask_locked(inode);
+	}
+
+	spin_unlock(&inode->i_lock);
+	spin_unlock(&group->mark_lock);
+	spin_unlock(&entry->lock);
+
+	if (lentry) {
+		ret = -EEXIST;
+		fsnotify_put_mark(lentry);
+	}
+
+	return ret;
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b228538..d391ab4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -696,6 +696,11 @@ struct inode {
 
 	__u32			i_generation;
 
+#ifdef CONFIG_FSNOTIFY
+	__u32			i_fsnotify_mask; /* all events this inode cares about */
+	struct hlist_head	i_fsnotify_mark_entries; /* fsnotify mark entries */
+#endif
+
 #ifdef CONFIG_DNOTIFY
 	unsigned long		i_dnotify_mask; /* Directory notify events */
 	struct dnotify_struct	*i_dnotify; /* for directory notifications */
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 3d68058..4e04ab2 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -36,6 +36,14 @@ static inline void fsnotify_d_move(struct dentry *entry)
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
@@ -44,6 +52,7 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 	inotify_inode_is_dead(inode);
 
 	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE);
+	__fsnotify_inode_delete(inode);
 }
 
 /*
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index a349691..605c79e 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -13,7 +13,6 @@
 #include <linux/list.h>
 #include <linux/path.h> /* struct path */
 #include <linux/spinlock.h>
-#include <linux/wait.h>
 
 #include <asm/atomic.h>
 
@@ -50,16 +49,24 @@
 
 struct fsnotify_group;
 struct fsnotify_event;
+struct fsnotify_mark_entry;
 
 /*
  * Each group much define these ops.
  *
+ * should_send_event - given a group, inode, and mask this function determines
+ *		if the group is interested in this event.
  * handle_event - main call for a group to handle an fs event
  * free_group_priv - called when a group refcnt hits 0 to clean up the private union
+ * freeing-mark - this means that a mark has been flagged to die when everything
+ *		finishes using it.  The function is supplied with what must be a
+ *		valid group and inode to use to clean up.
  */
 struct fsnotify_ops {
+	int (*should_send_event)(struct fsnotify_group *group, struct inode *inode, __u32 mask);
 	int (*handle_event)(struct fsnotify_group *group, struct fsnotify_event *event);
 	void (*free_group_priv)(struct fsnotify_group *group);
+	void (*freeing_mark)(struct fsnotify_mark_entry *entry, struct fsnotify_group *group);
 };
 
 /*
@@ -76,6 +83,10 @@ struct fsnotify_group {
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
+	/* stores all fastapth entries assoc with this group so they can be cleaned on unregister */
+	spinlock_t mark_lock;		/* protect mark_entries list */
+	struct list_head mark_entries;	/* all inode mark entries for this group */
+
 	unsigned int priority;		/* order this group should receive msgs.  low first */
 	unsigned int evicted:1;		/* has this group been evicted? */
 
@@ -109,13 +120,40 @@ struct fsnotify_event {
 	__u32 mask;		/* the type of access */
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
+	__u32 mask;			/* mask this mark entry is for */
+	/* we hold ref for each i_list and g_list.  also one ref for each 'thing'
+	 * in kernel that found and may be using this mark. */
+	atomic_t refcnt;		/* active things looking at this mark */
+	struct inode *inode;		/* inode this entry is associated with */
+	struct fsnotify_group *group;	/* group this mark entry is for */
+	struct hlist_node i_list;	/* list of mark_entries by inode->i_fsnotify_mark_entries */
+	struct list_head g_list;	/* list of mark_entries by group->i_fsnotify_mark_entries */
+	spinlock_t lock;		/* protect group, inode, and killme */
+	struct list_head free_i_list;	/* tmp list used when freeing this mark */
+	struct list_head free_g_list;	/* tmp list used when freeing this mark */
+	void (*free_mark)(struct fsnotify_mark_entry *entry); /* called on final put+free */
+};
+
 #ifdef CONFIG_FSNOTIFY
 
 /* called from the vfs to signal fs events */
 extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is);
+extern void __fsnotify_inode_delete(struct inode *inode);
 
 /* called from fsnotify interfaces, such as fanotify or dnotify */
 extern void fsnotify_recalc_global_mask(void);
+extern void fsnotify_recalc_group_mask(struct fsnotify_group *group);
 extern struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int group_num,
 						    __u32 mask, const struct fsnotify_ops *ops);
 extern void fsnotify_put_group(struct fsnotify_group *group);
@@ -124,12 +162,26 @@ extern void fsnotify_get_event(struct fsnotify_event *event);
 extern void fsnotify_put_event(struct fsnotify_event *event);
 extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event);
 
+/* functions used to manipulate the marks attached to inodes */
+extern void fsnotify_recalc_inode_mask(struct inode *inode);
+extern void fsnotify_init_mark(struct fsnotify_mark_entry *entry, void (*free_mark)(struct fsnotify_mark_entry *entry));
+extern struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *group, struct inode *inode);
+extern int fsnotify_add_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group, struct inode *inode);
+extern void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry);
+extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
+extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
+
 /* put here because inotify does some weird stuff when destroying watches */
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data, int data_is);
+
 #else
 
 static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is);
 {}
+
+static inline void __fsnotify_inode_delete(struct inode *inode)
+{}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */

