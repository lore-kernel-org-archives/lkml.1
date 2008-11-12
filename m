Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYKLQN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYKLQN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYKLQLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:11:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45348 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbYKLQLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:11:35 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 07/21] fanotify: fastpath to ignore certain in core inodes
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:11:03 -0500
Message-ID: <20081112161103.25434.30104.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows a process to ignore certain events for the given in core inodes.
This does not preclude the need to keep a userspace or xattr based
cache if a fanotifier listener wants something with a different lifetime
than in core inode.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/inode.c               |    6 +
 fs/notify/Makefile       |    2 
 fs/notify/fanotify.c     |   19 ++++
 fs/notify/fanotify.h     |   34 +++++++
 fs/notify/fastpath.c     |  230 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/notify/group.c        |    3 +
 include/linux/fanotify.h |   17 +++
 include/linux/fs.h       |    5 +
 include/linux/fsnotify.h |    8 ++
 9 files changed, 323 insertions(+), 1 deletions(-)
 create mode 100644 fs/notify/fastpath.c

diff --git a/fs/inode.c b/fs/inode.c
index 0487ddb..cc802ae 100644
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
+#ifdef CONFIG_FANOTIFY
+		INIT_LIST_HEAD(&inode->fastpath_entries);
+		rwlock_init(&inode->fastpath_rwlock);
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
index c467c97..90cb910 100644
--- a/fs/notify/Makefile
+++ b/fs/notify/Makefile
@@ -3,4 +3,4 @@ obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 
 obj-$(CONFIG_DNOTIFY)		+= dnotify.o
 
-obj-$(CONFIG_FANOTIFY)		+= fanotify.o notification.o group.o
+obj-$(CONFIG_FANOTIFY)		+= fanotify.o notification.o group.o fastpath.o
diff --git a/fs/notify/fanotify.c b/fs/notify/fanotify.c
index e2a338e..aa12e91 100644
--- a/fs/notify/fanotify.c
+++ b/fs/notify/fanotify.c
@@ -35,6 +35,15 @@
 
 struct dentry *fanotify_fs_root;
 
+void fanotify_inode_delete(struct inode *inode)
+{
+	if (likely(list_empty(&fanotify_groups)))
+		return;
+
+	fanotify_fastpath_clear(inode);
+}
+EXPORT_SYMBOL_GPL(fanotify_inode_delete);
+
 void fanotify(struct file *file, unsigned int mask)
 {
 	struct fanotify_group *group;
@@ -52,6 +61,8 @@ void fanotify(struct file *file, unsigned int mask)
 	if (!S_ISREG(inode->i_mode))
 		return;
 
+	if (mask & FAN_MODIFY)
+		fanotify_fastpath_clear(inode);
 	/*
 	 * SRCU!!  the groups list is very very much read only and the path is
 	 * very hot (assuming something is using fanotify)  Not blocking while
@@ -67,6 +78,8 @@ void fanotify(struct file *file, unsigned int mask)
 	idx = srcu_read_lock(&fanotify_grp_srcu_struct);
 	list_for_each_entry_rcu(group, &fanotify_groups, group_list) {
 		if (mask & group->mask) {
+			if (fanotify_is_fastpath(file, mask, group))
+				continue;
 			if (!event) {
 				event = create_event(file, mask);
 				/* shit, we OOM'd and now we can't tell, lets hope something else blows up */
@@ -94,6 +107,12 @@ static __init int fanotify_init(void)
 	if (ret)
 		return ret;
 
+	ret = fanotify_fastpath_init();
+	if (ret) {
+		fanotify_notification_uninit();
+		return ret;
+	}
+
 	return init_srcu_struct(&fanotify_grp_srcu_struct);
 }
 __initcall(fanotify_init);
diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index 2cbe0ba..bcc3f4b 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -46,6 +46,31 @@ struct fanotify_event {
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 };
 
+/*
+ * a fastpath is simply an entry attached to an in core inode which allows an
+ * fanotify listener to indicate they are no longer interested in events of
+ * a type matching mask.
+ *
+ * these are flushed when an inode is evicted from core or when the inode is
+ * modified (as seen by fsnotify_access)
+ */
+struct fanotify_fastpath_entry {
+	struct fanotify_group *group;	/* group this fastpath entry is for */
+	unsigned int mask;		/* mask this fastpath entry is for */
+	struct inode *inode;		/* inode this entry is associated with */
+	/*
+	 * killcnt starts at 0 and is incremented when this entry will be killed
+	 * since multiple processes my try to kill it at the same time.
+	 * One might try to kill it from walking the i_list when an inode is being
+	 * kicked out of cache and one might try to kill it when an fanotify group
+	 * is being unregistered.  The last one to finish cleaning everything up
+	 * and decrement it to 0 will do the actual killing
+	 */
+	atomic_t killcnt;
+	struct list_head i_list;	/* list of fastpath_entries by inode->fastpath_entries */
+	struct list_head g_list;	/* list of fastpath_entries by group->fastpath_entries */
+};
+
 extern struct srcu_struct fanotify_grp_srcu_struct;
 extern struct list_head fanotify_groups;
 
@@ -60,4 +85,13 @@ extern struct fanotify_event_holder *alloc_event_holder(void);
 extern void fanotify_destroy_event_holder(struct fanotify_event_holder *holder);
 extern __init int fanotify_notification_init(void);
 extern __init int fanotify_notification_uninit(void);
+
+extern void fanotify_fastpath_get(struct fanotify_fastpath_entry *entry);
+extern void fanotify_fastpath_put(struct fanotify_fastpath_entry *entry);
+extern int fanotify_is_fastpath(struct file *file, unsigned int mask, struct fanotify_group *group);
+extern void fanotify_fastpath_clear_group(struct fanotify_group *group);
+extern void fanotify_fastpath_clear(struct inode *inode);
+extern __init int fanotify_fastpath_init(void);
+extern __init int fanotify_fastpath_uninit(void);
+
 #endif	/* _LINUX_FANOTIFY_PRIVATE_H */
diff --git a/fs/notify/fastpath.c b/fs/notify/fastpath.c
new file mode 100644
index 0000000..c4114af
--- /dev/null
+++ b/fs/notify/fastpath.c
@@ -0,0 +1,230 @@
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
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/rculist.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/security.h>
+#include <linux/uaccess.h>
+#include <linux/writeback.h>
+
+#include <linux/fanotify.h>
+#include "fanotify.h"
+
+static struct kmem_cache *fastpath_kmem_cache;
+
+static void fanotify_fastpath_kill(struct fanotify_fastpath_entry *entry)
+{
+	entry->group = NULL;
+	entry->inode = NULL;
+	entry->mask = 0;
+	entry->i_list.next = NULL;
+	entry->g_list.next = NULL;
+	kmem_cache_free(fastpath_kmem_cache, entry);
+}
+
+static struct fanotify_fastpath_entry *fanotify_fastpath_alloc(void)
+{
+	struct fanotify_fastpath_entry *entry;
+
+	entry = kmem_cache_alloc(fastpath_kmem_cache, GFP_KERNEL);
+
+	return entry;
+}
+
+void fanotify_fastpath_get(struct fanotify_fastpath_entry *entry)
+{
+	atomic_inc(&entry->killcnt);
+}
+
+void fanotify_fastpath_put(struct fanotify_fastpath_entry *entry)
+{
+	if (atomic_dec_and_test(&entry->killcnt))
+		fanotify_fastpath_kill(entry);
+}
+
+int fanotify_is_fastpath(struct file *file, unsigned int mask, struct fanotify_group *group)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct fanotify_fastpath_entry *entry;
+	int found = 0;
+
+	read_lock(&inode->fastpath_rwlock);
+	list_for_each_entry(entry, &inode->fastpath_entries, i_list) {
+		/* is the entry for this group and is the entry->mask a superset of this event mask? */
+		if ((entry->group == group) && ((entry->mask & mask) == mask)) {
+			found = 1;
+			break;
+		}
+	}
+	read_unlock(&inode->fastpath_rwlock);
+
+	return found;
+}
+
+void fanotify_fastpath_clear_group(struct fanotify_group *group)
+{
+	struct fanotify_fastpath_entry *entry;
+	struct inode *inode;
+
+	mutex_lock(&group->fastpath_mutex);
+	while (!list_empty(&group->fastpath_entries)) {
+		entry = list_first_entry(&group->fastpath_entries, struct fanotify_fastpath_entry, g_list);
+
+		/* make sure the entry survives until it is off both lists */
+		fanotify_fastpath_get(entry);
+
+		/* remove from g_list */
+		list_del_init(&entry->g_list);
+		mutex_unlock(&group->fastpath_mutex);
+
+		inode = entry->inode;
+
+		/* remove from i_list */
+		write_lock(&inode->fastpath_rwlock);
+		if (!list_empty(&entry->i_list))
+			list_del_init(&entry->i_list);
+		write_unlock(&inode->fastpath_rwlock);
+
+		/* off both lists, may free now */
+		fanotify_fastpath_put(entry);
+
+		mutex_lock(&group->fastpath_mutex);
+	}
+	mutex_unlock(&group->fastpath_mutex);
+}
+
+void fanotify_fastpath_clear(struct inode *inode)
+{
+	struct fanotify_fastpath_entry *entry;
+	struct fanotify_group *group;
+
+	write_lock(&inode->fastpath_rwlock);
+	while (!list_empty(&inode->fastpath_entries)) {
+		entry = list_first_entry(&inode->fastpath_entries, struct fanotify_fastpath_entry, i_list);
+
+		/* make sure the entry survives until off both lists */
+		fanotify_fastpath_get(entry);
+		list_del_init(&entry->i_list);
+
+		group = entry->group;
+
+		write_unlock(&inode->fastpath_rwlock);
+
+		mutex_lock(&group->fastpath_mutex);
+		if (!list_empty(&entry->g_list))
+			list_del_init(&entry->g_list);
+		mutex_unlock(&group->fastpath_mutex);
+
+		/* off both lists, may kill now */
+		fanotify_fastpath_put(entry);
+
+		write_lock(&inode->fastpath_rwlock);
+	}
+	write_unlock(&inode->fastpath_rwlock);
+}
+
+/*
+ * add the fastpath entry to the in core inode referenced by fd
+ */
+int fanotify_fastpath_add(struct fanotify_group *group, int fd, unsigned int mask)
+{
+	struct file *file;
+	int fput_needed;
+	int ret = 0;
+	/* we initialize entry to shut up the compiler in case we just to out... */
+	struct fanotify_fastpath_entry *entry = NULL, *lentry;
+	struct inode *inode;
+	bool used = true;
+
+	file = fget_light(fd, &fput_needed);
+	if (!file)
+		return -EBADF;
+
+	inode = file->f_path.dentry->d_inode;
+
+	if (!S_ISREG(inode->i_mode)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* pre allocate an entry so we can hold the writelock */
+	entry = fanotify_fastpath_alloc();
+	if (!entry) {
+		ret = -ENOMEM;
+		/* be sure that used==TRUE here so it doens't try to free */
+		goto out;
+	}
+
+	/*
+	 * this is the only place we hold both the group and the inode lock
+	 * we could take them in either order, but we take the mutex first
+	 * so we don't sleep holding the rwlock
+	 */
+	mutex_lock(&group->fastpath_mutex);
+	write_lock(&inode->fastpath_rwlock);
+	list_for_each_entry(lentry, &inode->fastpath_entries, i_list) {
+		if (lentry->group == group) {
+			lentry->mask |= mask;
+			used = false;
+			goto out_unlock;
+		}
+	}
+
+	atomic_set(&entry->killcnt, 0);
+	entry->group = group;
+	entry->mask = mask;
+	entry->inode = inode;
+
+	list_add(&entry->i_list, &inode->fastpath_entries);
+	list_add(&entry->g_list, &group->fastpath_entries);
+
+out_unlock:
+	write_unlock(&inode->fastpath_rwlock);
+	mutex_unlock(&group->fastpath_mutex);
+out:
+	fput_light(file, fput_needed);
+	if (!used)
+		fanotify_fastpath_kill(entry);
+	return ret;
+}
+
+
+__init int fanotify_fastpath_uninit(void)
+{
+	kmem_cache_destroy(fastpath_kmem_cache);
+	fastpath_kmem_cache = NULL;
+
+	return 0;
+}
+
+__init int fanotify_fastpath_init(void)
+{
+	fastpath_kmem_cache = kmem_cache_create("fanotify_fastpath_entry", sizeof(struct fanotify_fastpath_entry), 0, SLAB_PANIC, NULL);
+
+	return 0;
+}
diff --git a/fs/notify/group.c b/fs/notify/group.c
index fc3d736..ff9b5ef 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -87,6 +87,9 @@ void fanotify_kill_group(struct fanotify_group *group)
 	/* clear the notification queue of all events */
 	fanotify_notification_clear_group(group);
 
+	/* clear all fastpath entries for this group */
+	fanotify_fastpath_clear_group(group);
+
 	kfree(group);
 }
 
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 76d88fd..e0e63f2 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -71,17 +71,25 @@ struct fanotify_group {
 	struct mutex notification_mutex;/* protect the notification_list */
 	struct list_head notification_list;	/* list of event_holder this group needs to send to userspace */
 	wait_queue_head_t notification_waitq;	/* read() on the notification file blocks on this waitq */
+
+	/* stores all fastapth entries assoc with this group so they can be cleaned on unregister */
+	struct mutex fastpath_mutex;	/* protect fastpath_entries list */
+	struct list_head fastpath_entries; /* all fastpath entries for this group */
 };
 
 #ifdef CONFIG_FANOTIFY
 
 extern void fanotify(struct file *file, unsigned int mask);
+extern void fanotify_inode_delete(struct inode *inode);
 
 extern void fanotify_get_group(struct fanotify_group *group);
 extern struct fanotify_group *fanotify_find_group(unsigned int group_num, unsigned int mask);
 extern void fanotify_put_group(struct fanotify_group *group);
 
+/* things called from the socket */
 extern int fanotify_create_event_fd(struct fanotify_group *group, struct fanotify_event_metadata *data, int nonblock);
+extern int fanotify_fastpath_add(struct fanotify_group *group, int fd, unsigned int mask);
+
 #else
 
 static inline void fanotify(struct file *file, unsigned int mask)
@@ -103,6 +111,15 @@ static inline int fanotify_create_event_fd(struct fanotify_group *group, struct
 	memset(data, 0, sizeof(struct fanotify_event_metadata));
 	return 0;
 }
+
+static inline int fanotify_fastpath_add(struct fanotify_group *group, int fd, unsigned int mask)
+{
+	return 0;
+}
+
+static inline void fanotify_inode_delete(struct inode *inode)
+{}
+
 #endif	/* CONFIG_FANOTIFY */
 
 #endif	/* __KERNEL __ */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0dcdd94..0c35206 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -674,6 +674,11 @@ struct inode {
 	struct mutex		inotify_mutex;	/* protects the watches list */
 #endif
 
+#ifdef CONFIG_FANOTIFY
+	struct list_head	fastpath_entries; /* fanotify fastpath entries protected by group */
+	rwlock_t		fastpath_rwlock; /* protect the fastpath entries list */
+#endif
+
 	unsigned long		i_state;
 	unsigned long		dirtied_when;	/* jiffies of first dirtying */
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 894f573..522a2d7 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -82,6 +82,14 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 }
 
 /*
+ * fsnotify_inode_delete - and inode is being evicted from cache, clean up is needed
+ */
+static inline void fsnotify_inode_delete(struct inode *inode)
+{
+	fanotify_inode_delete(inode);
+}
+
+/*
  * fsnotify_inoderemove - an inode is going away
  */
 static inline void fsnotify_inoderemove(struct inode *inode)

