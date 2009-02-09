Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZBIVSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZBIVSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZBIVQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:16:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36417 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbZBIVQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:16:46 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v1 05/11] dnotify: reimplement dnotify using fsnotify
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       malware-list@lists.printk.net, akpm@linux-foundation.org
Date: Mon, 09 Feb 2009 16:15:48 -0500
Message-ID: <20090209211548.8985.82168.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
References: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
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
 fs/notify/dnotify/dnotify.c      |  449 ++++++++++++++++++++++++++++++--------
 include/linux/dnotify.h          |   29 +-
 include/linux/fs.h               |    5 
 include/linux/fsnotify.h         |   70 ++----
 include/linux/fsnotify_backend.h |    3 
 7 files changed, 386 insertions(+), 173 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e8bbc45..daba68f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1413,6 +1413,8 @@ S:	Orphan
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
index b0aa2cd..004c11c 100644
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
@@ -21,24 +24,163 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/fdtable.h>
+#include <linux/fsnotify_backend.h>
 
 int dir_notify_enable __read_mostly = 1;
 
 static struct kmem_cache *dn_cache __read_mostly;
+static struct kmem_cache *dnotify_inode_mark_cache __read_mostly;
+
+struct dnotify_mark_entry {
+	struct fsnotify_mark_entry fsn_entry;
+	struct dnotify_struct *dn;
+};
 
-static void redo_inode_mask(struct inode *inode)
+static struct fsnotify_ops dnotify_fsnotify_ops;
+
+/* this horribleness only works because dnotify only ever has 1 group */
+static inline struct fsnotify_mark_entry *dnotify_get_mark(struct inode *inode)
 {
-	unsigned long new_mask;
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
+/* holding the entry->lock to protect ->dn data. */
+static void dnotify_recalc_inode_mask(struct fsnotify_mark_entry *entry)
+{
+	__u64 new_mask, old_mask;
 	struct dnotify_struct *dn;
+	struct dnotify_mark_entry *dnentry  = container_of(entry, struct dnotify_mark_entry, fsn_entry);
 
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
+}
+
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
+static void dnotify_clear_mark(struct fsnotify_mark_entry *entry, struct inode *inode, unsigned int flags)
+{
+	/* if we got here when this inode just closed it's last dentry or when
+	 * the inode is being kicked out of core we screwed up since it should
+	 * have already been flushed in dnotify_flush() */
+	BUG();
+}
+
+static int dnotify_should_send_event(struct fsnotify_group *group, struct inode *inode, __u64 mask)
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
+static void dnotify_free_mark(struct fsnotify_mark_entry *entry)
+{
+	struct dnotify_mark_entry *dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
+
+	BUG_ON(dnentry->dn);
+
+	kmem_cache_free(dnotify_inode_mark_cache, dnentry);
 }
 
+static struct fsnotify_ops dnotify_fsnotify_ops = {
+	.handle_event = dnotify_handle_event,
+	.mark_clear_inode = dnotify_clear_mark,
+	.should_send_event = dnotify_should_send_event,
+	.free_group_priv = NULL,
+	.free_event_priv = NULL,
+	.free_mark = dnotify_free_mark,
+};
+
 void dnotify_flush(struct file *filp, fl_owner_t id)
 {
+	struct fsnotify_group *dnotify_group = NULL;
+	struct fsnotify_mark_entry *entry;
+	struct dnotify_mark_entry *dnentry;
 	struct dnotify_struct *dn;
 	struct dnotify_struct **prev;
 	struct inode *inode;
@@ -46,145 +188,254 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 	inode = filp->f_path.dentry->d_inode;
 	if (!S_ISDIR(inode->i_mode))
 		return;
-	spin_lock(&inode->i_lock);
-	prev = &inode->i_dnotify;
+
+	entry = dnotify_get_mark(inode);
+	if (!entry)
+		return;
+	dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
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
+	/* last dnotify watch on this inode is gone */
+	if (dnentry->dn == NULL)
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
 }
 
-int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
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
+}
+
+/* this has some really ugly tricky semantics.
+ * first, fsnotify_obtain_group took a reference to group.  If we add a new mark
+ * to this inode we keep that reference.  Otherwise we drop it.
+ *
+ * second if we return an error the caller will try to free *dnentry_p.  So on
+ * error we really need to do the cleanup outself and NULL out *dnentry_p
+ */ 
+static int find_dnotify_mark_entry(struct fsnotify_group *group, struct inode *inode,
+				   struct dnotify_mark_entry **dnentry_p)
+{
+	struct dnotify_mark_entry *dnentry = *dnentry_p;
+	struct fsnotify_mark_entry *entry = &dnentry->fsn_entry;
+	int ret = 0;
+
+retry:
+	/* look for a previous entry */
+	entry = fsnotify_find_mark_entry(group, inode);
+	if (!entry) {
+		entry = &dnentry->fsn_entry;
+		/* if none, add the new one we allocated */
+		ret = fsnotify_add_mark(entry);
+		/* if we raced and someone else added, start over */
+		if (ret == -EEXIST)
+			goto retry;
+		else if (ret) {
+			fsnotify_destroy_mark_by_entry(entry);
+			fsnotify_put_mark(entry);
+			/* we didn't ally this new entry, so put the group */
+			fsnotify_put_group(group);
+			dnentry = NULL;
+		}
+	} else {
+		/* found an existing one, kill the new one */
+		kmem_cache_free(dnotify_inode_mark_cache, dnentry);
+		dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
+		/* we found an old entry, didn't add a new one, so put group */
+		fsnotify_put_group(group);
+	}
+
+	*dnentry_p = dnentry;
+	return ret;
+}
+
+static int attach_dn(struct dnotify_struct *dn, struct dnotify_mark_entry *dnentry, fl_owner_t id,
+		     int fd, struct file *filp, __u64 mask)
 {
-	struct dnotify_struct *dn;
 	struct dnotify_struct *odn;
 	struct dnotify_struct **prev;
+
+	prev = &dnentry->dn;
+	while ((odn = *prev) != NULL) {
+		/* do we already have a dnotify struct and we are just adding more events? */
+		if ((odn->dn_owner == id) && (odn->dn_filp == filp)) {
+			odn->dn_fd = fd;
+			odn->dn_mask |= mask;
+			return -EEXIST;
+		}
+		prev = &odn->dn_next;
+	}
+
+	dn->dn_mask = mask;
+	dn->dn_fd = fd;
+	dn->dn_filp = filp;
+	dn->dn_owner = id;
+	dn->dn_next = dnentry->dn;
+	dnentry->dn = dn;
+
+	return 0;
+}
+
+int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
+{
+	struct fsnotify_group *dnotify_group = NULL;
+	struct dnotify_mark_entry *new_dnentry, *dnentry = NULL;
+	struct fsnotify_mark_entry *entry;
+	struct dnotify_struct *dn = NULL;
 	struct inode *inode;
 	fl_owner_t id = current->files;
 	struct file *f;
-	int error = 0;
+	int error = 0, destroy = 0;
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
+	/* convert the userspace DN_* "arg" to the internal FS_* defines in fsnotify */
+	mask = convert_arg(arg);
+
+	/* expect most fcntl to add new rather than augment old */
 	dn = kmem_cache_alloc(dn_cache, GFP_KERNEL);
-	if (dn == NULL)
+	if (!dn)
 		return -ENOMEM;
-	spin_lock(&inode->i_lock);
-	prev = &inode->i_dnotify;
-	while ((odn = *prev) != NULL) {
-		if ((odn->dn_owner == id) && (odn->dn_filp == filp)) {
-			odn->dn_fd = fd;
-			odn->dn_mask |= arg;
-			inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
-			goto out_free;
-		}
-		prev = &odn->dn_next;
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
+	dnotify_group = fsnotify_obtain_group(DNOTIFY_GROUP_NUM, DNOTIFY_GROUP_NUM, ALL_DNOTIFY_EVENTS, &dnotify_fsnotify_ops);
+	if (IS_ERR(dnotify_group)) {
+		error = PTR_ERR(dnotify_group);
+		goto out_err;
 	}
 
-	rcu_read_lock();
-	f = fcheck(fd);
-	rcu_read_unlock();
-	/* we'd lost the race with close(), sod off silently */
-	/* note that inode->i_lock prevents reordering problems
-	 * between accesses to descriptor table and ->i_dnotify */
-	if (f != filp)
-		goto out_free;
+	new_dnentry = dnentry = kmem_cache_alloc(dnotify_inode_mark_cache, GFP_KERNEL);
+	if (!dnentry) {
+		error = -ENOMEM;
+		goto out_err;
+	}
+	entry = &dnentry->fsn_entry;
+	fsnotify_init_mark(entry, dnotify_group, inode, mask);
+	dnentry->dn = NULL;
 
-	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
+	error = find_dnotify_mark_entry(dnotify_group, inode, &dnentry);
 	if (error)
-		goto out_free;
+		goto out_err;
+	entry = &dnentry->fsn_entry;
 
-	dn->dn_mask = arg;
-	dn->dn_fd = fd;
-	dn->dn_filp = filp;
-	dn->dn_owner = id;
-	inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
-	dn->dn_next = inode->i_dnotify;
-	inode->i_dnotify = dn;
-	spin_unlock(&inode->i_lock);
-	return 0;
-
-out_free:
-	spin_unlock(&inode->i_lock);
-	kmem_cache_free(dn_cache, dn);
-	return error;
-}
+	spin_lock(&entry->lock);
 
-void __inode_dir_notify(struct inode *inode, unsigned long event)
-{
-	struct dnotify_struct *	dn;
-	struct dnotify_struct **prev;
-	struct fown_struct *	fown;
-	int			changed = 0;
+	rcu_read_lock();
+	f = fcheck(fd);
+	rcu_read_unlock();
 
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
+	/* if (f != filp) means that we lost a race and another task/thread
+	 * actually closed the fd we are still playing with before we grabbed
+	 * the entry->lock.  Since closing the fd is the only time we clean
+	 * up the mark entries we need to get our mark off the list. */
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
-	if (changed)
-		redo_inode_mask(inode);
-	spin_unlock(&inode->i_lock);
-}
 
-EXPORT_SYMBOL(__inode_dir_notify);
+	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
+	if (error)
+		goto out;
 
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
+	error = attach_dn(dn, dnentry, id, fd, filp, mask);
+	/* !error means that we attached the dn to the dnentry, so don't free it */
+	if (!error)
+		dn = NULL;
+	/* -EEXIST means that we didn't add this new dn and used an old one.
+	 * that isn't an error (and the unused dn should be freed) */
+	else if (error == -EEXIST)
+		error = 0;
 
-	if (!dir_notify_enable)
-		return;
+	dnotify_recalc_inode_mask(entry);
+out:
+	spin_unlock(&entry->lock);
+	if (destroy)
+		fsnotify_destroy_mark_by_entry(entry);
+	fsnotify_put_mark(entry);
+	if (dn)
+		kmem_cache_free(dn_cache, dn);
+	return error;
 
-	spin_lock(&dentry->d_lock);
-	parent = dentry->d_parent;
-	if (parent->d_inode->i_dnotify_mask & event) {
-		dget(parent);
-		spin_unlock(&dentry->d_lock);
-		__inode_dir_notify(parent->d_inode, event);
-		dput(parent);
-	} else {
-		spin_unlock(&dentry->d_lock);
+out_err:
+	if (dnentry) {
+		entry = &dnentry->fsn_entry;
+		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_put_mark(entry);
 	}
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
index c5ec88f..1eed69c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -695,11 +695,6 @@ struct inode {
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
index 736bb28..f5ce85b 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -144,13 +144,7 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
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
@@ -190,7 +184,6 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 {
 	if (isdir)
 		isdir = IN_ISDIR;
-	dnotify_parent(dentry, DN_DELETE);
 	inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir, 0, dentry->d_name.name);
 
 	fsnotify_parent(dentry, FS_DELETE|isdir);
@@ -231,7 +224,6 @@ static inline void fsnotify_link_count(struct inode *inode)
  */
 static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 {
-	inode_dir_notify(inode, DN_CREATE);
 	inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
@@ -246,7 +238,6 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
  */
 static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
 {
-	inode_dir_notify(dir, DN_CREATE);
 	inotify_inode_queue_event(dir, IN_CREATE, 0, new_dentry->d_name.name,
 				  inode);
 	fsnotify_link_count(inode);
@@ -260,7 +251,6 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
  */
 static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 {
-	inode_dir_notify(inode, DN_CREATE);
 	inotify_inode_queue_event(inode, IN_CREATE | IN_ISDIR, 0, 
 				  dentry->d_name.name, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
@@ -279,7 +269,6 @@ static inline void fsnotify_access(struct dentry *dentry)
 	if (S_ISDIR(inode->i_mode))
 		mask |= IN_ISDIR;
 
-	dnotify_parent(dentry, DN_ACCESS);
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
@@ -298,7 +287,6 @@ static inline void fsnotify_modify(struct dentry *dentry)
 	if (S_ISDIR(inode->i_mode))
 		mask |= IN_ISDIR;
 
-	dnotify_parent(dentry, DN_MODIFY);
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
@@ -370,49 +358,35 @@ static inline void fsnotify_xattr(struct dentry *dentry)
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
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index ad7294f..2bada0f 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -77,6 +77,9 @@
 #define FSNOTIFY_LAST_DENTRY	1
 #define FSNOTIFY_INODE_DESTROY	2
 
+/* listeners that hard code group numbers near the top */
+#define DNOTIFY_GROUP_NUM	UINT_MAX
+
 struct fsnotify_group;
 struct fsnotify_event;
 struct fsnotify_mark_entry;

