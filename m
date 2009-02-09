Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbZBIVR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbZBIVR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZBIVQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:16:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36401 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbZBIVQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:16:35 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v1 03/11] fsnotify: add in inode fsnotify markings
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       malware-list@lists.printk.net, akpm@linux-foundation.org
Date: Mon, 09 Feb 2009 16:15:37 -0500
Message-ID: <20090209211537.8985.73991.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
References: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
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

 Documentation/filesystems/fsnotify.txt |  192 ++++++++++++++++++++++++++
 fs/inode.c                             |    9 +
 fs/notify/Makefile                     |    2 
 fs/notify/fsnotify.c                   |   13 ++
 fs/notify/fsnotify.h                   |    3 
 fs/notify/group.c                      |   24 +++
 fs/notify/inode_mark.c                 |  238 ++++++++++++++++++++++++++++++++
 include/linux/fs.h                     |    5 +
 include/linux/fsnotify.h               |    9 +
 include/linux/fsnotify_backend.h       |   50 +++++++
 10 files changed, 543 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/filesystems/fsnotify.txt
 create mode 100644 fs/notify/inode_mark.c

diff --git a/Documentation/filesystems/fsnotify.txt b/Documentation/filesystems/fsnotify.txt
new file mode 100644
index 0000000..6da6cc1
--- /dev/null
+++ b/Documentation/filesystems/fsnotify.txt
@@ -0,0 +1,192 @@
+fsnotify inode mark locking/lifetime/and refcnting
+
+struct fsnotify_mark_entry {
+	__u64 mask;			/* mask this mark entry is for */
+	atomic_t refcnt;		/* active things looking at this mark */
+	int freeme;			/* free when this is set and refcnt hits 0 */
+	struct inode *inode;		/* inode this entry is associated with */
+	struct fsnotify_group *group;	/* group this mark entry is for */
+	struct list_head i_list;	/* list of mark_entries by inode->i_fsnotify_mark_entries */
+	struct list_head g_list;	/* list of mark_entries by group->i_fsnotify_mark_entries */
+	spinlock_t lock;		/* protect group, inode, and killme */
+	struct list_head free_i_list;	/* tmp list used when freeing this mark */
+	struct list_head free_g_list;	/* tmp list used when freeing this mark */
+	void (*free_private)(struct fsnotify_mark_entry *entry); /* called on final put+free */
+};
+
+REFCNT:
+The mark->refcnt tells how many "things" in the kernel currectly are
+referencing this object.  The object typically will live inside the kernel
+with a refcnt of 0.  Any task that finds the fsnotify_mark_entry and either
+already has a reference or holds the inode->i_lock or group->mark_lock can
+take a reference.  The mark will survive until the reference hits 0 and the
+object has been marked for death (freeme)
+
+LOCKING:
+There are 3 spinlocks involved with fsnotify inode marks and they MUST
+be taking in order as follows:
+
+entry->lock
+group->mark_lock
+inode->i_lock
+
+entry->lock protects 3 things, entry->group, entry->inode, and entry->freeme.
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
+refcnt==0 and freeme has been set.  fsnotify_mark_entries normally live in the
+kernel with a refcnt==0 and only have positive refcnt when "something" is
+actively referencing its contents.  freeme is set when the fsnotify_mark is no
+longer on either an inode or a group list.  If it is off both lists we
+know the mark is unreachable by anything else and when the refcnt hits 0 we
+can free.
+
+The inode mark can be cleared for a number of different reasons including:
+The inode is unlinked for the last time.  (fsnotify_inoderemove)
+The inode is being evicted from cache. (fsnotify_inode_delete)
+The fs the inode is on is unmounted.  (fsnotify_inode_delete/fsnotify_unmount_inodes)
+Something explicitly requests that it be removed.  (fsnotify_destroy_mark_by_entry)
+The fsnotify_group associated with the mark is going away and all such marks
+need to be cleaned up. (fsnotify_clear_marks_by_group)
+
+Worst case we are given an inode and need to clean up all the marks on that
+inode.  We take i_lock and walk the i_fsnotify_mark_entries safely.  While
+walking the list we list_del_init the i_list, take a reference, and using
+free_i_list hook this into a private list we anchor on the stack.  At this
+point we can safely drop the i_lock and walk the private list we anchored on
+the stack (remember we hold a reference to everything on this list.)  For each
+entry we take the entry->lock and check if the ->group and ->inode pointers
+are set.  If they are, we take their respective locks and now hold all the
+interesting locks.  We can safely list_del_init the i_list and g_list and can
+set ->inode and ->group to NULL.  Once off both lists and everything is surely
+NULL we set freeme for cleanup.
+
+Very similarly for freeing by group, except we use free_g_list.
+
+This has the very interesting property of being able to run concurrently with
+any (or all) other directions.  Lets walk through what happens with 4 things
+trying to simultaneously mark this entry for destruction.
+
+A finds this event by some means and takes a reference.  (this could be any
+means including in the case of inotify through an idr, which is known to be
+safe since the idr entry itself holds a reference)
+B finds this event by some meand and takes a reference.
+
+At this point.
+	refcnt == 2
+	i_list -> inode
+	inode -> inode
+	g_list -> group
+	group -> group
+	free_i_list -> NUL
+	free_g_list -> NUL
+	freeme = 0
+
+C comes in and tries to free all of the fsnotify_mark attached to an inode.
+---- C  will take the i_lock and walk the i_fsnotify_mark entries list calling
+	list_del_init() on i_list, adding the entry to it's private list via
+	free_i_list, and taking a reference.  C releases the i_lock.  Start
+	walking the private list and block on the entry->lock (held by A
+	below)
+
+At this point.
+	refcnt == 3
+	i_list -> NUL 
+	inode -> inode
+	g_list -> group
+	group -> group
+	free_i_list -> private list on stack
+	free_g_list -> NUL
+	freeme = 0
+
+refcnt == 3.  events is not on the i_list.
+D comes in and tries to free all of the marks attached to the same inode.
+---- D  will take the i_lock and won't find this entry on the list and does
+	nothing.  (this is the end of D)
+
+E comes along and wants to free all of the marks in the group.
+---- E  take the group->mark_lock walk the group->mark_entry.  grab a
+	reference to the mark, list_del_init the g_list.  Add the mark to the
+	free_g_list.  Release the group->mark_lock.  Now start walking the new
+	private list and block in entry->lock.
+
+At this point.
+	refcnt == 4
+	i_list -> NUL 
+	inode -> inode
+	g_list -> NUL
+	group -> group
+	free_i_list -> private list on stack
+	free_g_list -> private list on another stack
+	freeme = 0
+
+A finally decides it wants to kill this entry for some reason.
+---- A  will take the entry->lock.  It will check if mark->group is non-NULL
+	and if so takes mark->group->mark_lock (it may have blocked here on D
+	above).  Check the ->inode and if set take mark->inode->i_lock (again
+	we may have been blocking on C).  We now own all the locks.  So
+	list_del_init on i_list and g_list.  set ->inode and ->group = NULL
+	and set freeme = 1.  Unlock i_lock, mark_lock, and entry->lock.  Drop
+	reference.   (this is the end of A)
+
+At this point.
+	refcnt == 3
+	i_list -> NUL 
+	inode -> NULL
+	g_list -> NUL
+	group -> NULL
+	free_i_list -> private list on stack
+	free_g_list -> private list on another stack
+	freeme = 1
+
+D happens to be the one to win the entry->lock.
+---- D  sees that ->inode and ->group and NULL so it just doesn't bother to
+	grab those locks (if they are NULL we know this even if off the
+	relevant lists)  D now pretends it has all the locks (even through it
+	only has mark->lock.)  so it calls list_del_init on i_list and g_list.
+	it sets ->inode and ->group to NULL (they already were) and it sets
+	freeme = 1 (it already way)  D unlocks all the locks it holds and
+	drops its reference
+
+At this point.
+	refcnt == 2
+	i_list -> NUL 
+	inode -> NULL
+	g_list -> NUL
+	group -> NULL
+	free_i_list -> private list on stack
+	free_g_list -> undefined
+	freeme = 1
+
+C does the same thing as B and the mark looks like:
+
+At this point.
+	refcnt == 1
+	i_list -> NUL 
+	inode -> NULL
+	g_list -> NUL
+	group -> NULL
+	free_i_list -> undefined
+	free_g_list -> undefined
+	freeme = 1
+
+B is the only thing left with a reference and it will do something similar to
+A, only it will only be holding mark->lock (it won't get the inode or group
+lock since they are NULL in the event.)  It will also clear everything,
+setfreeme, unlock, and drop it's reference via fsnotify_put_mark.
+
+fsnotify_put_mark calls atomic_dec_and_test(mark->refcnt, mark->lock) and will
+then test if freeme is set.  It is set.  That means we are the last thing
+inside the kernel with a pointer to this fsnotify_mark_entry and it should be
+destroyed.  fsnotify_put_mark proceedes to clean up any private data and frees
+things up.  
diff --git a/fs/inode.c b/fs/inode.c
index 40e37c0..f6a51a1 100644
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
+        INIT_LIST_HEAD(&inode->i_fsnotify_mark_entries);
+#endif
 }
 
 EXPORT_SYMBOL(inode_init_once);
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
index b51f90a..e7e53f7 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -25,6 +25,15 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
+void __fsnotify_inode_delete(struct inode *inode, int flag)
+{
+	if (list_empty(&fsnotify_groups))
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
index 9c53600..bad4da9 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -16,4 +16,7 @@ extern struct list_head fsnotify_groups;
 extern __u64 fsnotify_mask;
 
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is);
+
+extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
+extern void fsnotify_clear_marks_by_inode(struct inode *inode, unsigned int flags);
 #endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
index d7cabe5..bac7d8d 100644
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
 
@@ -151,6 +172,9 @@ struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int
 	group->group_num = group_num;
 	group->mask = mask;
 
+	spin_lock_init(&group->mark_lock);
+	INIT_LIST_HEAD(&group->mark_entries);
+
 	group->ops = ops;
 
 	mutex_lock(&fsnotify_grp_mutex);
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
new file mode 100644
index 0000000..9a65fbc
--- /dev/null
+++ b/fs/notify/inode_mark.c
@@ -0,0 +1,238 @@
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
+static void fsnotify_destroy_mark(struct fsnotify_mark_entry *entry)
+{
+	entry->group = NULL;
+	entry->inode = NULL;
+	entry->mask = 0;
+	INIT_LIST_HEAD(&entry->i_list);
+	INIT_LIST_HEAD(&entry->g_list);
+	INIT_LIST_HEAD(&entry->free_i_list);
+	INIT_LIST_HEAD(&entry->free_g_list);
+	entry->free_private(entry);
+}
+
+void fsnotify_get_mark(struct fsnotify_mark_entry *entry)
+{
+	atomic_inc(&entry->refcnt);
+}
+
+void fsnotify_put_mark(struct fsnotify_mark_entry *entry)
+{
+	if (atomic_dec_and_lock(&entry->refcnt, &entry->lock)) {
+		/*
+		 * if refcnt hit 0 and freeme was set when it hit zero it's
+		 * time to clean up!
+		 */
+		if (entry->freeme) {
+			spin_unlock(&entry->lock);
+			fsnotify_destroy_mark(entry);
+			return;
+		}
+		spin_unlock(&entry->lock);
+	}
+}
+
+void fsnotify_recalc_inode_mask_locked(struct inode *inode)
+{
+	struct fsnotify_mark_entry *entry;
+	__u64 new_mask = 0;
+
+	list_for_each_entry(entry, &inode->i_fsnotify_mark_entries, i_list) {
+		new_mask |= entry->mask;
+	}
+	inode->i_fsnotify_mask = new_mask;
+}
+
+void fsnotify_recalc_inode_mask(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	fsnotify_recalc_inode_mask_locked(inode);
+	spin_unlock(&inode->i_lock);
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
+		fsnotify_get_mark(entry);
+	}
+	spin_unlock(&group->mark_lock);
+
+	list_for_each_entry_safe(entry, lentry, &free_list, free_g_list) {
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
+		fsnotify_recalc_inode_mask_locked(inode);
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
+	if (inode) {
+		fsnotify_recalc_inode_mask_locked(inode);
+		spin_unlock(&inode->i_lock);
+	}
+	if (group)
+		spin_unlock(&group->mark_lock);
+
+	spin_unlock(&entry->lock);
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
+		fsnotify_get_mark(entry);
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
+		entry->group->ops->mark_clear_inode(entry, inode, flags);
+		fsnotify_put_mark(entry);
+	}
+
+	fsnotify_recalc_inode_mask(inode);
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
+
+void fsnotify_init_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group, struct inode *inode, __u64 mask)
+{
+	spin_lock_init(&entry->lock);
+	atomic_set(&entry->refcnt, 1);
+	entry->group = group;
+	entry->mask = mask;
+	entry->inode = inode;
+	entry->freeme = 0;
+	entry->free_private = group->ops->free_mark;
+}
+
+int fsnotify_add_mark(struct fsnotify_mark_entry *entry)
+{
+	struct fsnotify_mark_entry *lentry;
+	struct fsnotify_group *group = entry->group;
+	struct inode *inode = entry->inode;
+	int ret = 0;
+
+	/*
+	 * LOCKING ORDER!!!!
+	 * entry->lock
+	 * group->mark_lock
+	 * inode->i_lock
+	 */
+	spin_lock(&group->mark_lock);
+	spin_lock(&inode->i_lock);
+
+	lentry = fsnotify_find_mark_entry(group, inode);
+	if (!lentry) {
+		list_add(&entry->i_list, &inode->i_fsnotify_mark_entries);
+		list_add(&entry->g_list, &group->mark_entries);
+		fsnotify_recalc_inode_mask_locked(inode);
+	}
+
+	spin_unlock(&inode->i_lock);
+	spin_unlock(&group->mark_lock);
+
+	if (lentry) {
+		ret = -EEXIST;
+		fsnotify_put_mark(lentry);
+	}
+
+	return ret;
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7c68aa9..c5ec88f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -690,6 +690,11 @@ struct inode {
 
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
index d1f7de2..6ae332f 100644
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
index e156df5..a9508c5 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -13,7 +13,6 @@
 #include <linux/list.h>
 #include <linux/path.h> /* struct path */
 #include <linux/spinlock.h>
-#include <linux/wait.h>
 
 #include <asm/atomic.h>
 
@@ -69,13 +68,21 @@
 #define FSNOTIFY_EVENT_INODE	2
 #define FSNOTIFY_EVENT_FILE	3
 
+/* these tell __fsnotify_inode_delete what kind of event this is */
+#define FSNOTIFY_LAST_DENTRY	1
+#define FSNOTIFY_INODE_DESTROY	2
+
 struct fsnotify_group;
 struct fsnotify_event;
+struct fsnotify_mark_entry;
 
 struct fsnotify_ops {
+	int (*should_send_event)(struct fsnotify_group *group, struct inode *inode, __u64 mask);
 	int (*handle_event)(struct fsnotify_group *group, struct fsnotify_event *event);
 	void (*free_group_priv)(struct fsnotify_group *group);
+	void (*mark_clear_inode)(struct fsnotify_mark_entry *entry, struct inode *inode, unsigned int flags);
 	void (*free_event_priv)(struct fsnotify_group *group, struct fsnotify_event *event);
+	void (*free_mark)(struct fsnotify_mark_entry *entry);
 };
 
 struct fsnotify_group {
@@ -86,6 +93,10 @@ struct fsnotify_group {
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
+	/* stores all fastapth entries assoc with this group so they can be cleaned on unregister */
+	spinlock_t mark_lock;		/* protect mark_entries list */
+	struct list_head mark_entries;	/* all inode mark entries for this group */
+
 	unsigned int priority;		/* order this group should receive msgs.  low first */
 	unsigned int evicted	:1;	/* has this group been evicted? */
 
@@ -123,13 +134,39 @@ struct fsnotify_event {
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
+	__u64 mask;			/* mask this mark entry is for */
+	atomic_t refcnt;		/* active things looking at this mark */
+	int freeme;			/* free when this is set and refcnt hits 0 */
+	struct inode *inode;		/* inode this entry is associated with */
+	struct fsnotify_group *group;	/* group this mark entry is for */
+	struct list_head i_list;	/* list of mark_entries by inode->i_fsnotify_mark_entries */
+	struct list_head g_list;	/* list of mark_entries by group->i_fsnotify_mark_entries */
+	spinlock_t lock;		/* protect group, inode, and killme */
+	struct list_head free_i_list;	/* tmp list used when freeing this mark */
+	struct list_head free_g_list;	/* tmp list used when freeing this mark */
+	void (*free_private)(struct fsnotify_mark_entry *entry); /* called on final put+free */
+};
+
 #ifdef CONFIG_FSNOTIFY
 
 /* called from the vfs to signal fs events */
 extern void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is);
+extern void __fsnotify_inode_delete(struct inode *inode, int flag);
 
 /* called from fsnotify interfaces, such as fanotify or dnotify */
 extern void fsnotify_recalc_global_mask(void);
+extern void fsnotify_recalc_group_mask(struct fsnotify_group *group);
 extern struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int group_num, __u64 mask, const struct fsnotify_ops *ops);
 extern void fsnotify_put_group(struct fsnotify_group *group);
 extern void fsnotify_get_group(struct fsnotify_group *group);
@@ -138,10 +175,21 @@ extern void fsnotify_get_event(struct fsnotify_event *event);
 extern void fsnotify_put_event(struct fsnotify_event *event);
 extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event);
 
+extern void fsnotify_recalc_inode_mask(struct inode *inode);
+extern void fsnotify_init_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group, struct inode *inode, __u64 mask);
+extern struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *group, struct inode *inode);
+extern int fsnotify_add_mark(struct fsnotify_mark_entry *entry);
+extern void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry);
+extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
+extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
 #else
 
 static inline void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is);
 {}
+
+static inline void __fsnotify_inode_delete(struct inode *inode, int flag)
+{}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */

