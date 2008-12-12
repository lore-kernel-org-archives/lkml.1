Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYLLVyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYLLVyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbYLLVwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:52:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56002 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbYLLVwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:52:16 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH -v4 09/14] dnotify: reimplement dnotify using fsnotify
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk, hch@infradead.org,
       zbr@ioremap.net, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 12 Dec 2008 16:52:02 -0500
Message-ID: <20081212215201.27112.65352.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplement dnotify using fsnotify.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/fcntl.c                  |    4 +
 fs/notify/dnotify/Kconfig   |    1 
 fs/notify/dnotify/dnotify.c |  322 ++++++++++++++++++++++++++++++++-----------
 include/linux/dnotify.h     |   29 +---
 include/linux/fs.h          |    5 -
 include/linux/fsnotify.h    |   71 +++------
 6 files changed, 271 insertions(+), 161 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 549daf8..dcc733e 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -327,6 +327,10 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		break;
 	case F_NOTIFY:
 		err = fcntl_dirnotify(fd, filp, arg);
+		if (err)
+			break;
+		if (filp->f_op && filp->f_op->dir_notify)
+			err = filp->f_op->dir_notify(filp, arg);
 		break;
 	default:
 		break;
diff --git a/fs/notify/dnotify/Kconfig b/fs/notify/dnotify/Kconfig
index 26adf5d..904ff8d 100644
--- a/fs/notify/dnotify/Kconfig
+++ b/fs/notify/dnotify/Kconfig
@@ -1,5 +1,6 @@
 config DNOTIFY
 	bool "Dnotify support"
+	depends on FSNOTIFY
 	default y
 	help
 	  Dnotify is a directory-based per-fd file change notification system
diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 676073b..dae1bd6 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -21,24 +21,147 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/fdtable.h>
+#include <linux/fsnotify_backend.h>
+
+#include "../fsnotify.h"
 
 int dir_notify_enable __read_mostly = 1;
 
 static struct kmem_cache *dn_cache __read_mostly;
 
-static void redo_inode_mask(struct inode *inode)
+static int inode_dir_notify(struct fsnotify_group *group, struct fsnotify_event *event);
+static void clear_mark_dir_notify(struct fsnotify_mark_entry *entry, struct inode *inode, unsigned int flags);
+static int should_send_event_dir_notify(struct fsnotify_group *group, struct inode *inode, __u64 mask);
+
+static struct fsnotify_ops dnotify_fsnotify_ops = {
+	.event_to_notif = inode_dir_notify,
+	.mark_clear_inode = clear_mark_dir_notify,
+	.should_send_event = should_send_event_dir_notify,
+	.free_group_priv = NULL,
+	.free_event_priv = NULL,
+	.free_mark_priv = NULL,
+};
+
+/* this horribleness only works because dnotify only ever has 1 group */
+static inline struct fsnotify_mark_entry *dnotify_get_mark(struct inode *inode)
+{
+	struct fsnotify_mark_entry *lentry;
+	struct fsnotify_mark_entry *entry = NULL;
+
+	spin_lock(&inode->i_lock);
+	list_for_each_entry(lentry, &inode->i_fsnotify_mark_entries, i_list) {
+		if (lentry->group->ops == &dnotify_fsnotify_ops) {
+			fsnotify_get_mark(lentry);
+			entry = lentry;
+			break;
+		}
+	}
+	spin_unlock(&inode->i_lock);
+	return entry;
+}
+
+/* holding the entry->lock to protect private data. */
+static void dnotify_recalc_inode_mask(struct fsnotify_mark_entry *entry)
 {
 	unsigned long new_mask;
 	struct dnotify_struct *dn;
 
 	new_mask = 0;
-	for (dn = inode->i_dnotify; dn != NULL; dn = dn->dn_next)
-		new_mask |= dn->dn_mask & ~DN_MULTISHOT;
-	inode->i_dnotify_mask = new_mask;
+	dn = (struct dnotify_struct *)entry->private;
+	for (; dn != NULL; dn = dn->dn_next)
+		new_mask |= (dn->dn_mask & ~FS_DN_MULTISHOT);
+	entry->mask = new_mask;
+
+	if (entry->inode)
+		fsnotify_recalc_inode_mask(entry->inode);
+}
+
+static int inode_dir_notify(struct fsnotify_group *group, struct fsnotify_event *event)
+{
+	struct fsnotify_mark_entry *entry = NULL;
+	struct inode *to_tell;
+	struct dnotify_struct *dn;
+	struct dnotify_struct **prev;
+	struct fown_struct *fown;
+	int changed = 0;
+
+	to_tell = event->to_tell;
+
+	spin_lock(&to_tell->i_lock);
+	entry = fsnotify_find_mark_entry(group, to_tell);
+	spin_unlock(&to_tell->i_lock);
+
+	/* unlikely since we alreay passed should_send_event_dir_notify() */
+	if (unlikely(!entry))
+		return 0;
+
+	spin_lock(&entry->lock);
+	prev = (struct dnotify_struct **)&entry->private;
+	while ((dn = *prev) != NULL) {
+		if ((dn->dn_mask & event->mask) == 0) {
+			prev = &dn->dn_next;
+			continue;
+		}
+		fown = &dn->dn_filp->f_owner;
+		send_sigio(fown, dn->dn_fd, POLL_MSG);
+		if (dn->dn_mask & FS_DN_MULTISHOT)
+			prev = &dn->dn_next;
+		else {
+			*prev = dn->dn_next;
+			changed = 1;
+			kmem_cache_free(dn_cache, dn);
+		}
+	}
+	if (changed)
+		dnotify_recalc_inode_mask(entry);
+
+	spin_unlock(&entry->lock);
+	fsnotify_put_mark(entry);
+
+	return 0;
+}
+
+static void clear_mark_dir_notify(struct fsnotify_mark_entry *entry, struct inode *inode, unsigned int flags)
+{
+	/* if we got here when this inode just closed it's last dentry or when
+	 * the inode is being kicked out of core we screwed up since it should
+	 * have already been flushed in dnotify_flush() */
+	BUG();
+}
+
+static int should_send_event_dir_notify(struct fsnotify_group *group, struct inode *inode, __u64 mask)
+{
+	struct fsnotify_mark_entry *entry;
+	int send;
+
+	/* !dir_notify_enable should never get here, don't waste time checking
+	if (!dir_notify_enable)
+		return 0; */
+
+	/* not a dir, dnotify doesn't care */
+	if (!S_ISDIR(inode->i_mode))
+		return 0;
+
+	spin_lock(&inode->i_lock);
+	entry = fsnotify_find_mark_entry(group, inode);
+	spin_unlock(&inode->i_lock);
+
+	/* no mark means no dnotify watch */
+	if (!entry)
+		return 0;
+
+	spin_lock(&entry->lock);
+	send = !!(mask & entry->mask);
+	spin_unlock(&entry->lock);
+	fsnotify_put_mark(entry);
+
+	return send;
 }
 
 void dnotify_flush(struct file *filp, fl_owner_t id)
 {
+	struct fsnotify_group *dnotify_group = NULL;
+	struct fsnotify_mark_entry *entry;
 	struct dnotify_struct *dn;
 	struct dnotify_struct **prev;
 	struct inode *inode;
@@ -46,22 +169,66 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 	inode = filp->f_path.dentry->d_inode;
 	if (!S_ISDIR(inode->i_mode))
 		return;
-	spin_lock(&inode->i_lock);
-	prev = &inode->i_dnotify;
+
+	entry = dnotify_get_mark(inode);
+	if (!entry)
+		return;
+
+	spin_lock(&entry->lock);
+	prev = (struct dnotify_struct **)&entry->private;
 	while ((dn = *prev) != NULL) {
 		if ((dn->dn_owner == id) && (dn->dn_filp == filp)) {
 			*prev = dn->dn_next;
-			redo_inode_mask(inode);
+			dnotify_recalc_inode_mask(entry);
 			kmem_cache_free(dn_cache, dn);
 			break;
 		}
 		prev = &dn->dn_next;
 	}
-	spin_unlock(&inode->i_lock);
+
+	/* last dnotify watch on this inode is gone */
+	if (entry->private == NULL) 
+		dnotify_group = entry->group;
+
+	spin_unlock(&entry->lock);
+
+	if (dnotify_group) {
+		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_put_group(dnotify_group);
+	}
+
+	fsnotify_put_mark(entry);
+}
+
+/* this conversion is done only at watch creation */
+static inline unsigned long convert_arg(unsigned long arg)
+{
+	unsigned long new_mask = 0;
+
+	if (arg & DN_MULTISHOT)
+		new_mask |= FS_DN_MULTISHOT;
+	if (arg & DN_DELETE)
+		new_mask |= (FS_DELETE | FS_MOVED_FROM);
+	if (arg & DN_MODIFY)
+		new_mask |= FS_MODIFY;
+	if (arg & DN_ACCESS)
+		new_mask |= FS_ACCESS;
+	if (arg & DN_ATTRIB)
+		new_mask |= FS_ATTRIB;
+	if (arg & DN_RENAME)
+		new_mask |= FS_DN_RENAME;
+	if (arg & DN_CREATE)
+		new_mask |= (FS_CREATE | FS_MOVED_TO);
+
+	new_mask |= (new_mask & FS_EVENTS_WITH_CHILD) << 32;
+
+	return new_mask;
 }
 
 int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 {
+	struct fsnotify_group *dnotify_group;
+	struct fsnotify_mark_entry *entry;
 	struct dnotify_struct *dn;
 	struct dnotify_struct *odn;
 	struct dnotify_struct **prev;
@@ -69,27 +236,64 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	fl_owner_t id = current->files;
 	struct file *f;
 	int error = 0;
+	__u64 mask;
+
+	if (!dir_notify_enable)
+		return -EINVAL;
 
 	if ((arg & ~DN_MULTISHOT) == 0) {
 		dnotify_flush(filp, id);
 		return 0;
 	}
-	if (!dir_notify_enable)
-		return -EINVAL;
 	inode = filp->f_path.dentry->d_inode;
 	if (!S_ISDIR(inode->i_mode))
 		return -ENOTDIR;
+
+	/* expect most fcntl to add new rather than augment old */
 	dn = kmem_cache_alloc(dn_cache, GFP_KERNEL);
 	if (dn == NULL)
 		return -ENOMEM;
-	spin_lock(&inode->i_lock);
-	prev = &inode->i_dnotify;
+
+	/* convert the userspace DN_* "arg" to the internal FS_* defines in fsnotify */
+	mask = convert_arg(arg);
+
+	/*
+	 * I really don't like using ALL_DNOTIFY_EVENTS.  We could probably do
+	 * better setting the group->mask equal to only those dnotify watches care
+	 * about, but removing events means running the entire group->mark_entries
+	 * list to recalculate the mask.  Also makes it harder to find the right
+	 * group, but this is not a fast path, so harder doesn't mean bad.
+	 * Maybe a future performance win since it could result in faster fsnotify()
+	 * processing.
+	 */
+	dnotify_group = fsnotify_obtain_group(UINT_MAX, UINT_MAX, ALL_DNOTIFY_EVENTS, &dnotify_fsnotify_ops);
+	/* screw it, i don't care */
+	if (IS_ERR(dnotify_group)) {
+		error = PTR_ERR(dnotify_group);
+		goto out_free;
+	}
+
+	entry = fsnotify_mark_add(dnotify_group, inode, mask);
+	if (!entry) {
+		error = -ENOMEM;
+		goto out_put_group;
+	}
+
+	spin_lock(&entry->lock);
+	/* entry->private == NULL means that this is a new inode mark.
+	 * take a group reference for it.  */
+	if (entry->private == NULL)
+		fsnotify_get_group(dnotify_group);
+
+	prev = (struct dnotify_struct **)&entry->private;
 	while ((odn = *prev) != NULL) {
+		/* do we already have a dnotify struct and we are just adding more events? */
 		if ((odn->dn_owner == id) && (odn->dn_filp == filp)) {
 			odn->dn_fd = fd;
-			odn->dn_mask |= arg;
-			inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
-			goto out_free;
+			odn->dn_mask |= mask;
+			/* recalculate the entry->mask and entry->inode->i_fsnotify_mask */
+			dnotify_recalc_inode_mask(entry);
+			goto out_unlock;
 		}
 		prev = &odn->dn_next;
 	}
@@ -98,92 +302,38 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	f = fcheck(fd);
 	rcu_read_unlock();
 	/* we'd lost the race with close(), sod off silently */
-	/* note that inode->i_lock prevents reordering problems
-	 * between accesses to descriptor table and ->i_dnotify */
+	/* note that entry->lock prevents reordering problems
+	 * between accesses to descriptor table and the private data in the
+	 * inode mark, aka the dnotify_flush when the fd was closed */
 	if (f != filp)
-		goto out_free;
+		goto out_unlock;
 
 	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
 	if (error)
-		goto out_free;
+		goto out_unlock;
 
-	dn->dn_mask = arg;
+	dn->dn_mask = mask;
 	dn->dn_fd = fd;
 	dn->dn_filp = filp;
 	dn->dn_owner = id;
-	inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
-	dn->dn_next = inode->i_dnotify;
-	inode->i_dnotify = dn;
-	spin_unlock(&inode->i_lock);
-
-	if (filp->f_op && filp->f_op->dir_notify)
-		return filp->f_op->dir_notify(filp, arg);
+	dn->dn_next = entry->private;
+	entry->private = dn;
+	dnotify_recalc_inode_mask(entry);
+	spin_unlock(&entry->lock);
+	fsnotify_put_mark(entry);
+	fsnotify_put_group(dnotify_group);
 	return 0;
 
+out_unlock:
+	spin_unlock(&entry->lock);
+	fsnotify_put_mark(entry);
+out_put_group:
+	fsnotify_put_group(dnotify_group);
 out_free:
-	spin_unlock(&inode->i_lock);
 	kmem_cache_free(dn_cache, dn);
 	return error;
 }
 
-void __inode_dir_notify(struct inode *inode, unsigned long event)
-{
-	struct dnotify_struct *	dn;
-	struct dnotify_struct **prev;
-	struct fown_struct *	fown;
-	int			changed = 0;
-
-	spin_lock(&inode->i_lock);
-	prev = &inode->i_dnotify;
-	while ((dn = *prev) != NULL) {
-		if ((dn->dn_mask & event) == 0) {
-			prev = &dn->dn_next;
-			continue;
-		}
-		fown = &dn->dn_filp->f_owner;
-		send_sigio(fown, dn->dn_fd, POLL_MSG);
-		if (dn->dn_mask & DN_MULTISHOT)
-			prev = &dn->dn_next;
-		else {
-			*prev = dn->dn_next;
-			changed = 1;
-			kmem_cache_free(dn_cache, dn);
-		}
-	}
-	if (changed)
-		redo_inode_mask(inode);
-	spin_unlock(&inode->i_lock);
-}
-
-EXPORT_SYMBOL(__inode_dir_notify);
-
-/*
- * This is hopelessly wrong, but unfixable without API changes.  At
- * least it doesn't oops the kernel...
- *
- * To safely access ->d_parent we need to keep d_move away from it.  Use the
- * dentry's d_lock for this.
- */
-void dnotify_parent(struct dentry *dentry, unsigned long event)
-{
-	struct dentry *parent;
-
-	if (!dir_notify_enable)
-		return;
-
-	spin_lock(&dentry->d_lock);
-	parent = dentry->d_parent;
-	if (parent->d_inode->i_dnotify_mask & event) {
-		dget(parent);
-		spin_unlock(&dentry->d_lock);
-		__inode_dir_notify(parent->d_inode, event);
-		dput(parent);
-	} else {
-		spin_unlock(&dentry->d_lock);
-	}
-}
-EXPORT_SYMBOL_GPL(dnotify_parent);
-
 static int __init dnotify_init(void)
 {
 	dn_cache = kmem_cache_create("dnotify_cache",
diff --git a/include/linux/dnotify.h b/include/linux/dnotify.h
index 102a902..e8c4256 100644
--- a/include/linux/dnotify.h
+++ b/include/linux/dnotify.h
@@ -10,7 +10,7 @@
 
 struct dnotify_struct {
 	struct dnotify_struct *	dn_next;
-	unsigned long		dn_mask;
+	__u64			dn_mask;
 	int			dn_fd;
 	struct file *		dn_filp;
 	fl_owner_t		dn_owner;
@@ -21,23 +21,18 @@ struct dnotify_struct {
 
 #ifdef CONFIG_DNOTIFY
 
-extern void __inode_dir_notify(struct inode *, unsigned long);
+#define ALL_DNOTIFY_EVENTS (FS_DELETE | FS_DELETE_CHILD |\
+			    FS_MODIFY | FS_MODIFY_CHILD |\
+			    FS_ACCESS | FS_ACCESS_CHILD |\
+			    FS_ATTRIB | FS_ATTRIB_CHILD |\
+			    FS_CREATE | FS_DN_RENAME |\
+			    FS_MOVED_FROM | FS_MOVED_TO)
+
 extern void dnotify_flush(struct file *, fl_owner_t);
 extern int fcntl_dirnotify(int, struct file *, unsigned long);
-extern void dnotify_parent(struct dentry *, unsigned long);
-
-static inline void inode_dir_notify(struct inode *inode, unsigned long event)
-{
-	if (inode->i_dnotify_mask & (event))
-		__inode_dir_notify(inode, event);
-}
 
 #else
 
-static inline void __inode_dir_notify(struct inode *inode, unsigned long event)
-{
-}
-
 static inline void dnotify_flush(struct file *filp, fl_owner_t id)
 {
 }
@@ -47,14 +42,6 @@ static inline int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	return -EINVAL;
 }
 
-static inline void dnotify_parent(struct dentry *dentry, unsigned long event)
-{
-}
-
-static inline void inode_dir_notify(struct inode *inode, unsigned long event)
-{
-}
-
 #endif /* CONFIG_DNOTIFY */
 
 #endif /* __KERNEL __ */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5a7bce..f945763 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -670,11 +670,6 @@ struct inode {
 	struct list_head	i_fsnotify_mark_entries; /* fsnotify mark entries */
 #endif
 
-#ifdef CONFIG_DNOTIFY
-	unsigned long		i_dnotify_mask; /* Directory notify events */
-	struct dnotify_struct	*i_dnotify; /* for directory notifications */
-#endif
-
 #ifdef CONFIG_INOTIFY
 	struct list_head	inotify_watches; /* watches on this inode */
 	struct mutex		inotify_mutex;	/* protects the watches list */
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 971ada9..791d288 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -135,13 +135,7 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 	__u64 new_dir_mask = 0;
 
 	if (old_dir == new_dir) {
-		inode_dir_notify(old_dir, DN_RENAME);
 		old_dir_mask = FS_DN_RENAME;
-	} else {
-		inode_dir_notify(old_dir, DN_DELETE);
-		old_dir_mask = FS_DELETE;
-		inode_dir_notify(new_dir, DN_CREATE);
-		new_dir_mask = FS_CREATE;
 	}
 
 	if (isdir) {
@@ -181,7 +175,6 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 {
 	if (isdir)
 		isdir = IN_ISDIR;
-	dnotify_parent(dentry, DN_DELETE);
 	inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir, 0, dentry->d_name.name);
 
 	fsnotify_parent(dentry, FS_DELETE|isdir);
@@ -222,7 +215,6 @@ static inline void fsnotify_link_count(struct inode *inode)
  */
 static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 {
-	inode_dir_notify(inode, DN_CREATE);
 	inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
@@ -237,7 +229,6 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
  */
 static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
 {
-	inode_dir_notify(dir, DN_CREATE);
 	inotify_inode_queue_event(dir, IN_CREATE, 0, new_dentry->d_name.name,
 				  inode);
 	fsnotify_link_count(inode);
@@ -251,7 +242,6 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
  */
 static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 {
-	inode_dir_notify(inode, DN_CREATE);
 	inotify_inode_queue_event(inode, IN_CREATE | IN_ISDIR, 0, 
 				  dentry->d_name.name, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
@@ -271,7 +261,6 @@ static inline void fsnotify_access(struct file *file)
 	if (S_ISDIR(inode->i_mode))
 		mask |= IN_ISDIR;
 
-	dnotify_parent(dentry, DN_ACCESS);
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
@@ -291,7 +280,6 @@ static inline void fsnotify_modify(struct file *file)
 	if (S_ISDIR(inode->i_mode))
 		mask |= IN_ISDIR;
 
-	dnotify_parent(dentry, DN_MODIFY);
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
@@ -307,7 +295,6 @@ static inline void fsnotify_open_exec(struct file *file)
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 
-	dnotify_parent(dentry, DN_ACCESS);
 	inotify_dentry_parent_queue_event(dentry, IN_ACCESS, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, IN_ACCESS, 0, NULL, NULL);
 
@@ -380,49 +367,35 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 {
 	struct inode *inode = dentry->d_inode;
-	int dn_mask = 0;
-	u32 in_mask = 0;
+	__u64 mask = 0;
+
+	if (ia_valid & ATTR_UID)
+		mask |= IN_ATTRIB;
+	if (ia_valid & ATTR_GID)
+		mask |= IN_ATTRIB;
+	if (ia_valid & ATTR_SIZE)
+		mask |= IN_MODIFY;
 
-	if (ia_valid & ATTR_UID) {
-		in_mask |= IN_ATTRIB;
-		dn_mask |= DN_ATTRIB;
-	}
-	if (ia_valid & ATTR_GID) {
-		in_mask |= IN_ATTRIB;
-		dn_mask |= DN_ATTRIB;
-	}
-	if (ia_valid & ATTR_SIZE) {
-		in_mask |= IN_MODIFY;
-		dn_mask |= DN_MODIFY;
-	}
 	/* both times implies a utime(s) call */
 	if ((ia_valid & (ATTR_ATIME | ATTR_MTIME)) == (ATTR_ATIME | ATTR_MTIME))
-	{
-		in_mask |= IN_ATTRIB;
-		dn_mask |= DN_ATTRIB;
-	} else if (ia_valid & ATTR_ATIME) {
-		in_mask |= IN_ACCESS;
-		dn_mask |= DN_ACCESS;
-	} else if (ia_valid & ATTR_MTIME) {
-		in_mask |= IN_MODIFY;
-		dn_mask |= DN_MODIFY;
-	}
-	if (ia_valid & ATTR_MODE) {
-		in_mask |= IN_ATTRIB;
-		dn_mask |= DN_ATTRIB;
-	}
+		mask |= IN_ATTRIB;
+	else if (ia_valid & ATTR_ATIME)
+		mask |= IN_ACCESS;
+	else if (ia_valid & ATTR_MTIME)
+		mask |= IN_MODIFY;
+
+	if (ia_valid & ATTR_MODE)
+		mask |= IN_ATTRIB;
 
-	if (dn_mask)
-		dnotify_parent(dentry, dn_mask);
-	if (in_mask) {
+	if (mask) {
 		if (S_ISDIR(inode->i_mode))
-			in_mask |= IN_ISDIR;
-		inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
-		inotify_dentry_parent_queue_event(dentry, in_mask, 0,
+			mask |= IN_ISDIR;
+		inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+		inotify_dentry_parent_queue_event(dentry, mask, 0,
 						  dentry->d_name.name);
 
-		fsnotify_parent(dentry, in_mask);
-		fsnotify(inode, in_mask, inode, FSNOTIFY_EVENT_INODE);
+		fsnotify_parent(dentry, mask);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 	}
 }
 

