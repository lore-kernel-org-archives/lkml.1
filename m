Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZCSSH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZCSSH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbZCSSG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:06:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45995 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446AbZCSSGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:06:55 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 06/13] dnotify: reimplement dnotify using fsnotify
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Thu, 19 Mar 2009 14:05:25 -0400
Message-ID: <20090319180525.17449.68191.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
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

 MAINTAINERS                      |    2 
 fs/notify/dnotify/Kconfig        |    1 
 fs/notify/dnotify/dnotify.c      |  405 +++++++++++++++++++++++++++++---------
 include/linux/dnotify.h          |   29 +--
 include/linux/fs.h               |    5 
 include/linux/fsnotify.h         |   70 ++-----
 include/linux/fsnotify_backend.h |    3 
 7 files changed, 340 insertions(+), 175 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0426c26..df74947 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1424,6 +1424,8 @@ S:	Orphan
 DIRECTORY NOTIFICATION (DNOTIFY)
 P:	Stephen Rothwell
 M:	sfr@canb.auug.org.au
+P:	Eric Paris
+M:	eparis@parisplace.org
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 
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
index b0aa2cd..f69e0c4 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -3,6 +3,9 @@
  *
  * Copyright (C) 2000,2001,2002 Stephen Rothwell
  *
+ * Copyright (C) 2009 Eric Paris <Red Hat Inc>
+ * dnotify was largly rewritten to use the new fsnotify infrastructure
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2, or (at your option) any
@@ -21,24 +24,140 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/fdtable.h>
+#include <linux/fsnotify_backend.h>
 
 int dir_notify_enable __read_mostly = 1;
 
 static struct kmem_cache *dn_cache __read_mostly;
+static struct kmem_cache *dnotify_inode_mark_cache __read_mostly;
+static struct fsnotify_group *dnotify_group __read_mostly;
+static DEFINE_MUTEX(dnotify_mark_mutex);
+
+struct dnotify_mark_entry {
+	struct fsnotify_mark_entry fsn_entry;
+	struct dnotify_struct *dn;
+};
 
-static void redo_inode_mask(struct inode *inode)
+static void dnotify_recalc_inode_mask(struct fsnotify_mark_entry *entry)
 {
-	unsigned long new_mask;
+	__u32 new_mask, old_mask;
 	struct dnotify_struct *dn;
+	struct dnotify_mark_entry *dnentry  = container_of(entry, struct dnotify_mark_entry, fsn_entry);
 
+	assert_spin_locked(&entry->lock);
+
+	old_mask = entry->mask;
 	new_mask = 0;
-	for (dn = inode->i_dnotify; dn != NULL; dn = dn->dn_next)
-		new_mask |= dn->dn_mask & ~DN_MULTISHOT;
-	inode->i_dnotify_mask = new_mask;
+	dn = dnentry->dn;
+	for (; dn != NULL; dn = dn->dn_next)
+		new_mask |= (dn->dn_mask & ~FS_DN_MULTISHOT);
+	entry->mask = new_mask;
+
+	if (old_mask == new_mask)
+		return;
+
+	if (entry->inode)
+		fsnotify_recalc_inode_mask(entry->inode);
 }
 
+static int dnotify_handle_event(struct fsnotify_group *group, struct fsnotify_event *event)
+{
+	struct fsnotify_mark_entry *entry = NULL;
+	struct dnotify_mark_entry *dnentry;
+	struct inode *to_tell;
+	struct dnotify_struct *dn;
+	struct dnotify_struct **prev;
+	struct fown_struct *fown;
+
+	to_tell = event->to_tell;
+
+	spin_lock(&to_tell->i_lock);
+	entry = fsnotify_find_mark_entry(group, to_tell);
+	spin_unlock(&to_tell->i_lock);
+
+	/* unlikely since we alreay passed dnotify_should_send_event() */
+	if (unlikely(!entry))
+		return 0;
+	dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
+
+	spin_lock(&entry->lock);
+	prev = &dnentry->dn;
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
+			kmem_cache_free(dn_cache, dn);
+			dnotify_recalc_inode_mask(entry);
+		}
+	}
+
+	spin_unlock(&entry->lock);
+	fsnotify_put_mark(entry);
+
+	return 0;
+}
+
+static int dnotify_should_send_event(struct fsnotify_group *group, struct inode *inode, __u32 mask)
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
+}
+
+static void dnotify_freeing_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group)
+{
+	/* dnotify doesn't care than an inode is on the way out */
+}
+
+static void dnotify_free_mark(struct fsnotify_mark_entry *entry)
+{
+	struct dnotify_mark_entry *dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
+
+	BUG_ON(dnentry->dn);
+
+	kmem_cache_free(dnotify_inode_mark_cache, dnentry);
+}
+
+static struct fsnotify_ops dnotify_fsnotify_ops = {
+	.handle_event = dnotify_handle_event,
+	.should_send_event = dnotify_should_send_event,
+	.free_group_priv = NULL,
+	.freeing_mark = dnotify_freeing_mark,
+};
+
 void dnotify_flush(struct file *filp, fl_owner_t id)
 {
+	struct fsnotify_mark_entry *entry;
+	struct dnotify_mark_entry *dnentry;
 	struct dnotify_struct *dn;
 	struct dnotify_struct **prev;
 	struct inode *inode;
@@ -46,145 +165,229 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 	inode = filp->f_path.dentry->d_inode;
 	if (!S_ISDIR(inode->i_mode))
 		return;
+
 	spin_lock(&inode->i_lock);
-	prev = &inode->i_dnotify;
+	entry = fsnotify_find_mark_entry(dnotify_group, inode);
+	spin_unlock(&inode->i_lock);
+	if (!entry)
+		return;
+	dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
+
+	mutex_lock(&dnotify_mark_mutex);
+
+	spin_lock(&entry->lock);
+	prev = &dnentry->dn;
 	while ((dn = *prev) != NULL) {
 		if ((dn->dn_owner == id) && (dn->dn_filp == filp)) {
 			*prev = dn->dn_next;
-			redo_inode_mask(inode);
 			kmem_cache_free(dn_cache, dn);
+			dnotify_recalc_inode_mask(entry);
 			break;
 		}
 		prev = &dn->dn_next;
 	}
-	spin_unlock(&inode->i_lock);
+
+	spin_unlock(&entry->lock);
+
+	/* nothing else could have found us thanks to the dnotify_mark_mutex */
+	if (dnentry->dn == NULL)
+		fsnotify_destroy_mark_by_entry(entry);
+
+	fsnotify_recalc_group_mask(dnotify_group);
+
+	mutex_unlock(&dnotify_mark_mutex);
+
+	fsnotify_put_mark(entry);
 }
 
-int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
+/* this conversion is done only at watch creation */
+static inline __u32  convert_arg(unsigned long arg)
+{
+	__u32 new_mask = FS_EVENT_ON_CHILD;
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
+	return new_mask;
+}
+
+static int attach_dn(struct dnotify_struct *dn, struct dnotify_mark_entry *dnentry, fl_owner_t id,
+		     int fd, struct file *filp, __u32 mask)
 {
-	struct dnotify_struct *dn;
 	struct dnotify_struct *odn;
 	struct dnotify_struct **prev;
-	struct inode *inode;
-	fl_owner_t id = current->files;
-	struct file *f;
-	int error = 0;
 
-	if ((arg & ~DN_MULTISHOT) == 0) {
-		dnotify_flush(filp, id);
-		return 0;
-	}
-	if (!dir_notify_enable)
-		return -EINVAL;
-	inode = filp->f_path.dentry->d_inode;
-	if (!S_ISDIR(inode->i_mode))
-		return -ENOTDIR;
-	dn = kmem_cache_alloc(dn_cache, GFP_KERNEL);
-	if (dn == NULL)
-		return -ENOMEM;
-	spin_lock(&inode->i_lock);
-	prev = &inode->i_dnotify;
+	prev = &dnentry->dn;
 	while ((odn = *prev) != NULL) {
+		/* do we already have a dnotify struct and we are just adding more events? */
 		if ((odn->dn_owner == id) && (odn->dn_filp == filp)) {
 			odn->dn_fd = fd;
-			odn->dn_mask |= arg;
-			inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
-			goto out_free;
+			odn->dn_mask |= mask;
+			return -EEXIST;
 		}
 		prev = &odn->dn_next;
 	}
 
-	rcu_read_lock();
-	f = fcheck(fd);
-	rcu_read_unlock();
-	/* we'd lost the race with close(), sod off silently */
-	/* note that inode->i_lock prevents reordering problems
-	 * between accesses to descriptor table and ->i_dnotify */
-	if (f != filp)
-		goto out_free;
-
-	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
-	if (error)
-		goto out_free;
-
-	dn->dn_mask = arg;
+	dn->dn_mask = mask;
 	dn->dn_fd = fd;
 	dn->dn_filp = filp;
 	dn->dn_owner = id;
-	inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
-	dn->dn_next = inode->i_dnotify;
-	inode->i_dnotify = dn;
-	spin_unlock(&inode->i_lock);
-	return 0;
+	dn->dn_next = dnentry->dn;
+	dnentry->dn = dn;
 
-out_free:
-	spin_unlock(&inode->i_lock);
-	kmem_cache_free(dn_cache, dn);
-	return error;
+	return 0;
 }
 
-void __inode_dir_notify(struct inode *inode, unsigned long event)
+int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 {
-	struct dnotify_struct *	dn;
-	struct dnotify_struct **prev;
-	struct fown_struct *	fown;
-	int			changed = 0;
+	struct dnotify_mark_entry *new_dnentry, *dnentry;
+	struct fsnotify_mark_entry *new_entry, *entry;
+	struct dnotify_struct *dn;
+	struct inode *inode;
+	fl_owner_t id = current->files;
+	struct file *f;
+	int destroy = 0, error = 0;
+	__u32 mask;
 
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
+	/* we use these to tell if we need to kfree */
+	new_entry = NULL;
+	dn = NULL;
+
+	if (!dir_notify_enable) {
+		error = -EINVAL;
+		goto out_err;
 	}
-	if (changed)
-		redo_inode_mask(inode);
-	spin_unlock(&inode->i_lock);
-}
 
-EXPORT_SYMBOL(__inode_dir_notify);
+	if ((arg & ~DN_MULTISHOT) == 0) {
+		dnotify_flush(filp, id);
+		error = 0;
+		goto out_err;
+	}
 
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
+	inode = filp->f_path.dentry->d_inode;
+	if (!S_ISDIR(inode->i_mode)) {
+		error = -ENOTDIR;
+		goto out_err;
+	}
 
-	if (!dir_notify_enable)
-		return;
+	/* expect most fcntl to add new rather than augment old */
+	dn = kmem_cache_alloc(dn_cache, GFP_KERNEL);
+	if (!dn) {
+		error = -ENOMEM;
+		goto out_err;
+	}
+
+	new_dnentry = kmem_cache_alloc(dnotify_inode_mark_cache, GFP_KERNEL);
+	if (!new_dnentry) {
+		error = -ENOMEM;
+		goto out_err;
+	}
+
+	/* convert the userspace DN_* "arg" to the internal FS_* defines in fsnotify */
+	mask = convert_arg(arg);
 
-	spin_lock(&dentry->d_lock);
-	parent = dentry->d_parent;
-	if (parent->d_inode->i_dnotify_mask & event) {
-		dget(parent);
-		spin_unlock(&dentry->d_lock);
-		__inode_dir_notify(parent->d_inode, event);
-		dput(parent);
+	/* set up the new_entry and new_dnentry */
+	new_entry = &new_dnentry->fsn_entry;
+	fsnotify_init_mark(new_entry, dnotify_free_mark);
+	new_entry->mask = mask;
+	new_dnentry->dn = NULL;
+
+	mutex_lock(&dnotify_mark_mutex);
+
+	/* add the new_entry or find an old one. */
+	spin_lock(&inode->i_lock);
+	entry = fsnotify_find_mark_entry(dnotify_group, inode);
+	spin_unlock(&inode->i_lock);
+	if (entry) {
+		dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
+		spin_lock(&entry->lock);
 	} else {
-		spin_unlock(&dentry->d_lock);
+		fsnotify_add_mark(new_entry, dnotify_group, inode);
+		spin_lock(&new_entry->lock);
+		entry = new_entry;
+		dnentry = new_dnentry;
+		/* we used new_entry, so don't free it */
+		new_entry = NULL;
+	}
+
+	rcu_read_lock();
+	f = fcheck(fd);
+	rcu_read_unlock();
+
+	/* if (f != filp) means that we lost a race and another task/thread
+	 * actually closed the fd we are still playing with before we grabbed
+	 * the dnotify_mark_mutex and entry->lock.  Since closing the fd is the
+	 * only time we clean up the mark entries we need to get our mark off
+	 * the list. */
+	if (f != filp) {
+		/* if we added ourselves, shoot ourselves, it's possible that
+		 * the flush actually did shoot this entry.  That's fine too
+		 * since multiple calls to destroy_mark is perfectly safe */
+		if (dnentry == new_dnentry)
+			destroy = 1;
+		/* if we just found a dnentry already there, just sod off
+		 * silently as the flush at close time dealt with it */
+		goto out;
 	}
+
+	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
+	if (error) {
+		/* if we added, we must shoot */
+		if (dnentry == new_dnentry)
+			destroy = 1;
+		goto out;
+	}
+
+	error = attach_dn(dn, dnentry, id, fd, filp, mask);
+	/* !error means that we attached the dn to the dnentry, so don't free it */
+	if (!error)
+		dn = NULL;
+	/* -EEXIST means that we didn't add this new dn and used an old one.
+	 * that isn't an error (and the unused dn should be freed) */
+	else if (error == -EEXIST)
+		error = 0;
+
+	dnotify_recalc_inode_mask(entry);
+out:
+	spin_unlock(&entry->lock);
+
+	if (destroy)
+		fsnotify_destroy_mark_by_entry(entry);
+
+	fsnotify_recalc_group_mask(dnotify_group);
+
+	mutex_unlock(&dnotify_mark_mutex);
+	fsnotify_put_mark(entry);
+out_err:
+	if (new_entry)
+		fsnotify_put_mark(new_entry);
+	if (dn)
+		kmem_cache_free(dn_cache, dn);
+	return error;
 }
-EXPORT_SYMBOL_GPL(dnotify_parent);
 
 static int __init dnotify_init(void)
 {
 	dn_cache = kmem_cache_create("dnotify_cache",
 		sizeof(struct dnotify_struct), 0, SLAB_PANIC, NULL);
+	dnotify_inode_mark_cache = kmem_cache_create("dnotify_inode_mark",
+		sizeof(struct dnotify_mark_entry), 0, SLAB_PANIC, NULL);
+	dnotify_group = fsnotify_obtain_group(DNOTIFY_GROUP_NUM, DNOTIFY_GROUP_NUM,
+					      0, &dnotify_fsnotify_ops);
+	if (IS_ERR(dnotify_group))
+		panic("unable to allocate fsnotify group for dnotify\n");
 	return 0;
 }
 
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
index d391ab4..9e5f3a9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -701,11 +701,6 @@ struct inode {
 	struct hlist_head	i_fsnotify_mark_entries; /* fsnotify mark entries */
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
index 7b45f29..8b9539c 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -109,13 +109,7 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 	__u32 new_dir_mask = 0;
 
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
@@ -152,7 +146,6 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 {
 	if (isdir)
 		isdir = FS_IN_ISDIR;
-	dnotify_parent(dentry, DN_DELETE);
 	inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir, 0, dentry->d_name.name);
 
 	fsnotify_parent(dentry, FS_DELETE|isdir);
@@ -173,7 +166,6 @@ static inline void fsnotify_link_count(struct inode *inode)
  */
 static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 {
-	inode_dir_notify(inode, DN_CREATE);
 	inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
@@ -188,7 +180,6 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
  */
 static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
 {
-	inode_dir_notify(dir, DN_CREATE);
 	inotify_inode_queue_event(dir, IN_CREATE, 0, new_dentry->d_name.name,
 				  inode);
 	fsnotify_link_count(inode);
@@ -202,7 +193,6 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
  */
 static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 {
-	inode_dir_notify(inode, DN_CREATE);
 	inotify_inode_queue_event(inode, IN_CREATE | IN_ISDIR, 0, 
 				  dentry->d_name.name, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
@@ -221,7 +211,6 @@ static inline void fsnotify_access(struct dentry *dentry)
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_IN_ISDIR;
 
-	dnotify_parent(dentry, DN_ACCESS);
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
@@ -240,7 +229,6 @@ static inline void fsnotify_modify(struct dentry *dentry)
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_IN_ISDIR;
 
-	dnotify_parent(dentry, DN_MODIFY);
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
@@ -312,49 +300,35 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 {
 	struct inode *inode = dentry->d_inode;
-	int dn_mask = 0;
-	u32 in_mask = 0;
+	__u32 mask = 0;
+
+	if (ia_valid & ATTR_UID)
+		mask |= FS_ATTRIB;
+	if (ia_valid & ATTR_GID)
+		mask |= FS_ATTRIB;
+	if (ia_valid & ATTR_SIZE)
+		mask |= FS_MODIFY;
 
-	if (ia_valid & ATTR_UID) {
-		in_mask |= FS_ATTRIB;
-		dn_mask |= DN_ATTRIB;
-	}
-	if (ia_valid & ATTR_GID) {
-		in_mask |= FS_ATTRIB;
-		dn_mask |= DN_ATTRIB;
-	}
-	if (ia_valid & ATTR_SIZE) {
-		in_mask |= FS_MODIFY;
-		dn_mask |= DN_MODIFY;
-	}
 	/* both times implies a utime(s) call */
 	if ((ia_valid & (ATTR_ATIME | ATTR_MTIME)) == (ATTR_ATIME | ATTR_MTIME))
-	{
-		in_mask |= FS_ATTRIB;
-		dn_mask |= DN_ATTRIB;
-	} else if (ia_valid & ATTR_ATIME) {
-		in_mask |= FS_ACCESS;
-		dn_mask |= DN_ACCESS;
-	} else if (ia_valid & ATTR_MTIME) {
-		in_mask |= FS_MODIFY;
-		dn_mask |= DN_MODIFY;
-	}
-	if (ia_valid & ATTR_MODE) {
-		in_mask |= FS_ATTRIB;
-		dn_mask |= DN_ATTRIB;
-	}
+		mask |= FS_ATTRIB;
+	else if (ia_valid & ATTR_ATIME)
+		mask |= FS_ACCESS;
+	else if (ia_valid & ATTR_MTIME)
+		mask |= FS_MODIFY;
+
+	if (ia_valid & ATTR_MODE)
+		mask |= FS_ATTRIB;
 
-	if (dn_mask)
-		dnotify_parent(dentry, dn_mask);
-	if (in_mask) {
+	if (mask) {
 		if (S_ISDIR(inode->i_mode))
-			in_mask |= FS_IN_ISDIR;
-		inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
-		inotify_dentry_parent_queue_event(dentry, in_mask, 0,
+			mask |= FS_IN_ISDIR;
+		inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+		inotify_dentry_parent_queue_event(dentry, mask, 0,
 						  dentry->d_name.name);
 
-		fsnotify_parent(dentry, in_mask);
-		fsnotify(inode, in_mask, inode, FSNOTIFY_EVENT_INODE);
+		fsnotify_parent(dentry, mask);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 	}
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index aa8a3ea..5c815b4 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -56,6 +56,9 @@
 				   FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE |\
 				   FS_DELETE)
 
+/* listeners that hard code group numbers near the top */
+#define DNOTIFY_GROUP_NUM	UINT_MAX
+
 struct fsnotify_group;
 struct fsnotify_event;
 struct fsnotify_mark_entry;

