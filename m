Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbYKLQMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbYKLQMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYKLQLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:11:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47114 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbYKLQLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:11:20 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 01/21] filesystem notification: create fs/notify to
	contain all fs notification
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:10:32 -0500
Message-ID: <20081112161031.25434.85019.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding yet another filesystem notification system it seemed like a good
idea to clean up fs/ but creating an fs/notify and putting everything
there.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/Kconfig               |   39 --
 fs/Makefile              |    5 
 fs/dnotify.c             |  194 -----------
 fs/inotify.c             |  773 ----------------------------------------------
 fs/inotify_user.c        |  778 ----------------------------------------------
 fs/notify/Kconfig        |   38 ++
 fs/notify/Makefile       |    4 
 fs/notify/dnotify.c      |  194 +++++++++++
 fs/notify/inotify.c      |  773 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/notify/inotify_user.c |  778 ++++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 1789 insertions(+), 1787 deletions(-)
 delete mode 100644 fs/dnotify.c
 delete mode 100644 fs/inotify.c
 delete mode 100644 fs/inotify_user.c
 create mode 100644 fs/notify/Kconfig
 create mode 100644 fs/notify/Makefile
 create mode 100644 fs/notify/dnotify.c
 create mode 100644 fs/notify/inotify.c
 create mode 100644 fs/notify/inotify_user.c

diff --git a/fs/Kconfig b/fs/Kconfig
index 522469a..ff0e819 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -270,44 +270,7 @@ config OCFS2_COMPAT_JBD
 
 endif # BLOCK
 
-config DNOTIFY
-	bool "Dnotify support"
-	default y
-	help
-	  Dnotify is a directory-based per-fd file change notification system
-	  that uses signals to communicate events to user-space.  There exist
-	  superior alternatives, but some applications may still rely on
-	  dnotify.
-
-	  If unsure, say Y.
-
-config INOTIFY
-	bool "Inotify file change notification support"
-	default y
-	---help---
-	  Say Y here to enable inotify support.  Inotify is a file change
-	  notification system and a replacement for dnotify.  Inotify fixes
-	  numerous shortcomings in dnotify and introduces several new features
-	  including multiple file events, one-shot support, and unmount
-	  notification.
-
-	  For more information, see <file:Documentation/filesystems/inotify.txt>
-
-	  If unsure, say Y.
-
-config INOTIFY_USER
-	bool "Inotify support for userspace"
-	depends on INOTIFY
-	default y
-	---help---
-	  Say Y here to enable inotify support for userspace, including the
-	  associated system calls.  Inotify allows monitoring of both files and
-	  directories via a single open fd.  Events are read from the file
-	  descriptor, which is also select()- and poll()-able.
-
-	  For more information, see <file:Documentation/filesystems/inotify.txt>
-
-	  If unsure, say Y.
+source "fs/notify/Kconfig"
 
 config QUOTA
 	bool "Quota support"
diff --git a/fs/Makefile b/fs/Makefile
index d9f8afe..e6f423d 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -20,8 +20,7 @@ obj-y +=	no-block.o
 endif
 
 obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o
-obj-$(CONFIG_INOTIFY)		+= inotify.o
-obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
+obj-y				+= notify/
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
 obj-$(CONFIG_ANON_INODES)	+= anon_inodes.o
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
@@ -57,8 +56,6 @@ obj-$(CONFIG_QFMT_V1)		+= quota_v1.o
 obj-$(CONFIG_QFMT_V2)		+= quota_v2.o
 obj-$(CONFIG_QUOTACTL)		+= quota.o
 
-obj-$(CONFIG_DNOTIFY)		+= dnotify.o
-
 obj-$(CONFIG_PROC_FS)		+= proc/
 obj-y				+= partitions/
 obj-$(CONFIG_SYSFS)		+= sysfs/
diff --git a/fs/dnotify.c b/fs/dnotify.c
deleted file mode 100644
index 676073b..0000000
--- a/fs/dnotify.c
+++ /dev/null
@@ -1,194 +0,0 @@
-/*
- * Directory notifications for Linux.
- *
- * Copyright (C) 2000,2001,2002 Stephen Rothwell
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-#include <linux/fs.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/dnotify.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-#include <linux/slab.h>
-#include <linux/fdtable.h>
-
-int dir_notify_enable __read_mostly = 1;
-
-static struct kmem_cache *dn_cache __read_mostly;
-
-static void redo_inode_mask(struct inode *inode)
-{
-	unsigned long new_mask;
-	struct dnotify_struct *dn;
-
-	new_mask = 0;
-	for (dn = inode->i_dnotify; dn != NULL; dn = dn->dn_next)
-		new_mask |= dn->dn_mask & ~DN_MULTISHOT;
-	inode->i_dnotify_mask = new_mask;
-}
-
-void dnotify_flush(struct file *filp, fl_owner_t id)
-{
-	struct dnotify_struct *dn;
-	struct dnotify_struct **prev;
-	struct inode *inode;
-
-	inode = filp->f_path.dentry->d_inode;
-	if (!S_ISDIR(inode->i_mode))
-		return;
-	spin_lock(&inode->i_lock);
-	prev = &inode->i_dnotify;
-	while ((dn = *prev) != NULL) {
-		if ((dn->dn_owner == id) && (dn->dn_filp == filp)) {
-			*prev = dn->dn_next;
-			redo_inode_mask(inode);
-			kmem_cache_free(dn_cache, dn);
-			break;
-		}
-		prev = &dn->dn_next;
-	}
-	spin_unlock(&inode->i_lock);
-}
-
-int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
-{
-	struct dnotify_struct *dn;
-	struct dnotify_struct *odn;
-	struct dnotify_struct **prev;
-	struct inode *inode;
-	fl_owner_t id = current->files;
-	struct file *f;
-	int error = 0;
-
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
-	while ((odn = *prev) != NULL) {
-		if ((odn->dn_owner == id) && (odn->dn_filp == filp)) {
-			odn->dn_fd = fd;
-			odn->dn_mask |= arg;
-			inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
-			goto out_free;
-		}
-		prev = &odn->dn_next;
-	}
-
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
-	dn->dn_fd = fd;
-	dn->dn_filp = filp;
-	dn->dn_owner = id;
-	inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
-	dn->dn_next = inode->i_dnotify;
-	inode->i_dnotify = dn;
-	spin_unlock(&inode->i_lock);
-
-	if (filp->f_op && filp->f_op->dir_notify)
-		return filp->f_op->dir_notify(filp, arg);
-	return 0;
-
-out_free:
-	spin_unlock(&inode->i_lock);
-	kmem_cache_free(dn_cache, dn);
-	return error;
-}
-
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
-static int __init dnotify_init(void)
-{
-	dn_cache = kmem_cache_create("dnotify_cache",
-		sizeof(struct dnotify_struct), 0, SLAB_PANIC, NULL);
-	return 0;
-}
-
-module_init(dnotify_init)
diff --git a/fs/inotify.c b/fs/inotify.c
deleted file mode 100644
index 690e725..0000000
--- a/fs/inotify.c
+++ /dev/null
@@ -1,773 +0,0 @@
-/*
- * fs/inotify.c - inode-based file event notifications
- *
- * Authors:
- *	John McCutchan	<ttb@tentacle.dhs.org>
- *	Robert Love	<rml@novell.com>
- *
- * Kernel API added by: Amy Griffis <amy.griffis@hp.com>
- *
- * Copyright (C) 2005 John McCutchan
- * Copyright 2006 Hewlett-Packard Development Company, L.P.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/spinlock.h>
-#include <linux/idr.h>
-#include <linux/slab.h>
-#include <linux/fs.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/writeback.h>
-#include <linux/inotify.h>
-
-static atomic_t inotify_cookie;
-
-/*
- * Lock ordering:
- *
- * dentry->d_lock (used to keep d_move() away from dentry->d_parent)
- * iprune_mutex (synchronize shrink_icache_memory())
- * 	inode_lock (protects the super_block->s_inodes list)
- * 	inode->inotify_mutex (protects inode->inotify_watches and watches->i_list)
- * 		inotify_handle->mutex (protects inotify_handle and watches->h_list)
- *
- * The inode->inotify_mutex and inotify_handle->mutex and held during execution
- * of a caller's event handler.  Thus, the caller must not hold any locks
- * taken in their event handler while calling any of the published inotify
- * interfaces.
- */
-
-/*
- * Lifetimes of the three main data structures--inotify_handle, inode, and
- * inotify_watch--are managed by reference count.
- *
- * inotify_handle: Lifetime is from inotify_init() to inotify_destroy().
- * Additional references can bump the count via get_inotify_handle() and drop
- * the count via put_inotify_handle().
- *
- * inotify_watch: for inotify's purposes, lifetime is from inotify_add_watch()
- * to remove_watch_no_event().  Additional references can bump the count via
- * get_inotify_watch() and drop the count via put_inotify_watch().  The caller
- * is reponsible for the final put after receiving IN_IGNORED, or when using
- * IN_ONESHOT after receiving the first event.  Inotify does the final put if
- * inotify_destroy() is called.
- *
- * inode: Pinned so long as the inode is associated with a watch, from
- * inotify_add_watch() to the final put_inotify_watch().
- */
-
-/*
- * struct inotify_handle - represents an inotify instance
- *
- * This structure is protected by the mutex 'mutex'.
- */
-struct inotify_handle {
-	struct idr		idr;		/* idr mapping wd -> watch */
-	struct mutex		mutex;		/* protects this bad boy */
-	struct list_head	watches;	/* list of watches */
-	atomic_t		count;		/* reference count */
-	u32			last_wd;	/* the last wd allocated */
-	const struct inotify_operations *in_ops; /* inotify caller operations */
-};
-
-static inline void get_inotify_handle(struct inotify_handle *ih)
-{
-	atomic_inc(&ih->count);
-}
-
-static inline void put_inotify_handle(struct inotify_handle *ih)
-{
-	if (atomic_dec_and_test(&ih->count)) {
-		idr_destroy(&ih->idr);
-		kfree(ih);
-	}
-}
-
-/**
- * get_inotify_watch - grab a reference to an inotify_watch
- * @watch: watch to grab
- */
-void get_inotify_watch(struct inotify_watch *watch)
-{
-	atomic_inc(&watch->count);
-}
-EXPORT_SYMBOL_GPL(get_inotify_watch);
-
-/**
- * put_inotify_watch - decrements the ref count on a given watch.  cleans up
- * watch references if the count reaches zero.  inotify_watch is freed by
- * inotify callers via the destroy_watch() op.
- * @watch: watch to release
- */
-void put_inotify_watch(struct inotify_watch *watch)
-{
-	if (atomic_dec_and_test(&watch->count)) {
-		struct inotify_handle *ih = watch->ih;
-
-		iput(watch->inode);
-		ih->in_ops->destroy_watch(watch);
-		put_inotify_handle(ih);
-	}
-}
-EXPORT_SYMBOL_GPL(put_inotify_watch);
-
-/*
- * inotify_handle_get_wd - returns the next WD for use by the given handle
- *
- * Callers must hold ih->mutex.  This function can sleep.
- */
-static int inotify_handle_get_wd(struct inotify_handle *ih,
-				 struct inotify_watch *watch)
-{
-	int ret;
-
-	do {
-		if (unlikely(!idr_pre_get(&ih->idr, GFP_KERNEL)))
-			return -ENOSPC;
-		ret = idr_get_new_above(&ih->idr, watch, ih->last_wd+1, &watch->wd);
-	} while (ret == -EAGAIN);
-
-	if (likely(!ret))
-		ih->last_wd = watch->wd;
-
-	return ret;
-}
-
-/*
- * inotify_inode_watched - returns nonzero if there are watches on this inode
- * and zero otherwise.  We call this lockless, we do not care if we race.
- */
-static inline int inotify_inode_watched(struct inode *inode)
-{
-	return !list_empty(&inode->inotify_watches);
-}
-
-/*
- * Get child dentry flag into synch with parent inode.
- * Flag should always be clear for negative dentrys.
- */
-static void set_dentry_child_flags(struct inode *inode, int watched)
-{
-	struct dentry *alias;
-
-	spin_lock(&dcache_lock);
-	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
-		struct dentry *child;
-
-		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
-			if (!child->d_inode)
-				continue;
-
-			spin_lock(&child->d_lock);
-			if (watched)
-				child->d_flags |= DCACHE_INOTIFY_PARENT_WATCHED;
-			else
-				child->d_flags &=~DCACHE_INOTIFY_PARENT_WATCHED;
-			spin_unlock(&child->d_lock);
-		}
-	}
-	spin_unlock(&dcache_lock);
-}
-
-/*
- * inotify_find_handle - find the watch associated with the given inode and
- * handle
- *
- * Callers must hold inode->inotify_mutex.
- */
-static struct inotify_watch *inode_find_handle(struct inode *inode,
-					       struct inotify_handle *ih)
-{
-	struct inotify_watch *watch;
-
-	list_for_each_entry(watch, &inode->inotify_watches, i_list) {
-		if (watch->ih == ih)
-			return watch;
-	}
-
-	return NULL;
-}
-
-/*
- * remove_watch_no_event - remove watch without the IN_IGNORED event.
- *
- * Callers must hold both inode->inotify_mutex and ih->mutex.
- */
-static void remove_watch_no_event(struct inotify_watch *watch,
-				  struct inotify_handle *ih)
-{
-	list_del(&watch->i_list);
-	list_del(&watch->h_list);
-
-	if (!inotify_inode_watched(watch->inode))
-		set_dentry_child_flags(watch->inode, 0);
-
-	idr_remove(&ih->idr, watch->wd);
-}
-
-/**
- * inotify_remove_watch_locked - Remove a watch from both the handle and the
- * inode.  Sends the IN_IGNORED event signifying that the inode is no longer
- * watched.  May be invoked from a caller's event handler.
- * @ih: inotify handle associated with watch
- * @watch: watch to remove
- *
- * Callers must hold both inode->inotify_mutex and ih->mutex.
- */
-void inotify_remove_watch_locked(struct inotify_handle *ih,
-				 struct inotify_watch *watch)
-{
-	remove_watch_no_event(watch, ih);
-	ih->in_ops->handle_event(watch, watch->wd, IN_IGNORED, 0, NULL, NULL);
-}
-EXPORT_SYMBOL_GPL(inotify_remove_watch_locked);
-
-/* Kernel API for producing events */
-
-/*
- * inotify_d_instantiate - instantiate dcache entry for inode
- */
-void inotify_d_instantiate(struct dentry *entry, struct inode *inode)
-{
-	struct dentry *parent;
-
-	if (!inode)
-		return;
-
-	spin_lock(&entry->d_lock);
-	parent = entry->d_parent;
-	if (parent->d_inode && inotify_inode_watched(parent->d_inode))
-		entry->d_flags |= DCACHE_INOTIFY_PARENT_WATCHED;
-	spin_unlock(&entry->d_lock);
-}
-
-/*
- * inotify_d_move - dcache entry has been moved
- */
-void inotify_d_move(struct dentry *entry)
-{
-	struct dentry *parent;
-
-	parent = entry->d_parent;
-	if (inotify_inode_watched(parent->d_inode))
-		entry->d_flags |= DCACHE_INOTIFY_PARENT_WATCHED;
-	else
-		entry->d_flags &= ~DCACHE_INOTIFY_PARENT_WATCHED;
-}
-
-/**
- * inotify_inode_queue_event - queue an event to all watches on this inode
- * @inode: inode event is originating from
- * @mask: event mask describing this event
- * @cookie: cookie for synchronization, or zero
- * @name: filename, if any
- * @n_inode: inode associated with name
- */
-void inotify_inode_queue_event(struct inode *inode, u32 mask, u32 cookie,
-			       const char *name, struct inode *n_inode)
-{
-	struct inotify_watch *watch, *next;
-
-	if (!inotify_inode_watched(inode))
-		return;
-
-	mutex_lock(&inode->inotify_mutex);
-	list_for_each_entry_safe(watch, next, &inode->inotify_watches, i_list) {
-		u32 watch_mask = watch->mask;
-		if (watch_mask & mask) {
-			struct inotify_handle *ih= watch->ih;
-			mutex_lock(&ih->mutex);
-			if (watch_mask & IN_ONESHOT)
-				remove_watch_no_event(watch, ih);
-			ih->in_ops->handle_event(watch, watch->wd, mask, cookie,
-						 name, n_inode);
-			mutex_unlock(&ih->mutex);
-		}
-	}
-	mutex_unlock(&inode->inotify_mutex);
-}
-EXPORT_SYMBOL_GPL(inotify_inode_queue_event);
-
-/**
- * inotify_dentry_parent_queue_event - queue an event to a dentry's parent
- * @dentry: the dentry in question, we queue against this dentry's parent
- * @mask: event mask describing this event
- * @cookie: cookie for synchronization, or zero
- * @name: filename, if any
- */
-void inotify_dentry_parent_queue_event(struct dentry *dentry, u32 mask,
-				       u32 cookie, const char *name)
-{
-	struct dentry *parent;
-	struct inode *inode;
-
-	if (!(dentry->d_flags & DCACHE_INOTIFY_PARENT_WATCHED))
-		return;
-
-	spin_lock(&dentry->d_lock);
-	parent = dentry->d_parent;
-	inode = parent->d_inode;
-
-	if (inotify_inode_watched(inode)) {
-		dget(parent);
-		spin_unlock(&dentry->d_lock);
-		inotify_inode_queue_event(inode, mask, cookie, name,
-					  dentry->d_inode);
-		dput(parent);
-	} else
-		spin_unlock(&dentry->d_lock);
-}
-EXPORT_SYMBOL_GPL(inotify_dentry_parent_queue_event);
-
-/**
- * inotify_get_cookie - return a unique cookie for use in synchronizing events.
- */
-u32 inotify_get_cookie(void)
-{
-	return atomic_inc_return(&inotify_cookie);
-}
-EXPORT_SYMBOL_GPL(inotify_get_cookie);
-
-/**
- * inotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
- * @list: list of inodes being unmounted (sb->s_inodes)
- *
- * Called with inode_lock held, protecting the unmounting super block's list
- * of inodes, and with iprune_mutex held, keeping shrink_icache_memory() at bay.
- * We temporarily drop inode_lock, however, and CAN block.
- */
-void inotify_unmount_inodes(struct list_head *list)
-{
-	struct inode *inode, *next_i, *need_iput = NULL;
-
-	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
-		struct inotify_watch *watch, *next_w;
-		struct inode *need_iput_tmp;
-		struct list_head *watches;
-
-		/*
-		 * If i_count is zero, the inode cannot have any watches and
-		 * doing an __iget/iput with MS_ACTIVE clear would actually
-		 * evict all inodes with zero i_count from icache which is
-		 * unnecessarily violent and may in fact be illegal to do.
-		 */
-		if (!atomic_read(&inode->i_count))
-			continue;
-
-		/*
-		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING, or
-		 * I_WILL_FREE which is fine because by that point the inode
-		 * cannot have any associated watches.
-		 */
-		if (inode->i_state & (I_CLEAR | I_FREEING | I_WILL_FREE))
-			continue;
-
-		need_iput_tmp = need_iput;
-		need_iput = NULL;
-		/* In case inotify_remove_watch_locked() drops a reference. */
-		if (inode != need_iput_tmp)
-			__iget(inode);
-		else
-			need_iput_tmp = NULL;
-		/* In case the dropping of a reference would nuke next_i. */
-		if ((&next_i->i_sb_list != list) &&
-				atomic_read(&next_i->i_count) &&
-				!(next_i->i_state & (I_CLEAR | I_FREEING |
-					I_WILL_FREE))) {
-			__iget(next_i);
-			need_iput = next_i;
-		}
-
-		/*
-		 * We can safely drop inode_lock here because we hold
-		 * references on both inode and next_i.  Also no new inodes
-		 * will be added since the umount has begun.  Finally,
-		 * iprune_mutex keeps shrink_icache_memory() away.
-		 */
-		spin_unlock(&inode_lock);
-
-		if (need_iput_tmp)
-			iput(need_iput_tmp);
-
-		/* for each watch, send IN_UNMOUNT and then remove it */
-		mutex_lock(&inode->inotify_mutex);
-		watches = &inode->inotify_watches;
-		list_for_each_entry_safe(watch, next_w, watches, i_list) {
-			struct inotify_handle *ih= watch->ih;
-			mutex_lock(&ih->mutex);
-			ih->in_ops->handle_event(watch, watch->wd, IN_UNMOUNT, 0,
-						 NULL, NULL);
-			inotify_remove_watch_locked(ih, watch);
-			mutex_unlock(&ih->mutex);
-		}
-		mutex_unlock(&inode->inotify_mutex);
-		iput(inode);		
-
-		spin_lock(&inode_lock);
-	}
-}
-EXPORT_SYMBOL_GPL(inotify_unmount_inodes);
-
-/**
- * inotify_inode_is_dead - an inode has been deleted, cleanup any watches
- * @inode: inode that is about to be removed
- */
-void inotify_inode_is_dead(struct inode *inode)
-{
-	struct inotify_watch *watch, *next;
-
-	mutex_lock(&inode->inotify_mutex);
-	list_for_each_entry_safe(watch, next, &inode->inotify_watches, i_list) {
-		struct inotify_handle *ih = watch->ih;
-		mutex_lock(&ih->mutex);
-		inotify_remove_watch_locked(ih, watch);
-		mutex_unlock(&ih->mutex);
-	}
-	mutex_unlock(&inode->inotify_mutex);
-}
-EXPORT_SYMBOL_GPL(inotify_inode_is_dead);
-
-/* Kernel Consumer API */
-
-/**
- * inotify_init - allocate and initialize an inotify instance
- * @ops: caller's inotify operations
- */
-struct inotify_handle *inotify_init(const struct inotify_operations *ops)
-{
-	struct inotify_handle *ih;
-
-	ih = kmalloc(sizeof(struct inotify_handle), GFP_KERNEL);
-	if (unlikely(!ih))
-		return ERR_PTR(-ENOMEM);
-
-	idr_init(&ih->idr);
-	INIT_LIST_HEAD(&ih->watches);
-	mutex_init(&ih->mutex);
-	ih->last_wd = 0;
-	ih->in_ops = ops;
-	atomic_set(&ih->count, 0);
-	get_inotify_handle(ih);
-
-	return ih;
-}
-EXPORT_SYMBOL_GPL(inotify_init);
-
-/**
- * inotify_init_watch - initialize an inotify watch
- * @watch: watch to initialize
- */
-void inotify_init_watch(struct inotify_watch *watch)
-{
-	INIT_LIST_HEAD(&watch->h_list);
-	INIT_LIST_HEAD(&watch->i_list);
-	atomic_set(&watch->count, 0);
-	get_inotify_watch(watch); /* initial get */
-}
-EXPORT_SYMBOL_GPL(inotify_init_watch);
-
-/**
- * inotify_destroy - clean up and destroy an inotify instance
- * @ih: inotify handle
- */
-void inotify_destroy(struct inotify_handle *ih)
-{
-	/*
-	 * Destroy all of the watches for this handle. Unfortunately, not very
-	 * pretty.  We cannot do a simple iteration over the list, because we
-	 * do not know the inode until we iterate to the watch.  But we need to
-	 * hold inode->inotify_mutex before ih->mutex.  The following works.
-	 */
-	while (1) {
-		struct inotify_watch *watch;
-		struct list_head *watches;
-		struct inode *inode;
-
-		mutex_lock(&ih->mutex);
-		watches = &ih->watches;
-		if (list_empty(watches)) {
-			mutex_unlock(&ih->mutex);
-			break;
-		}
-		watch = list_first_entry(watches, struct inotify_watch, h_list);
-		get_inotify_watch(watch);
-		mutex_unlock(&ih->mutex);
-
-		inode = watch->inode;
-		mutex_lock(&inode->inotify_mutex);
-		mutex_lock(&ih->mutex);
-
-		/* make sure we didn't race with another list removal */
-		if (likely(idr_find(&ih->idr, watch->wd))) {
-			remove_watch_no_event(watch, ih);
-			put_inotify_watch(watch);
-		}
-
-		mutex_unlock(&ih->mutex);
-		mutex_unlock(&inode->inotify_mutex);
-		put_inotify_watch(watch);
-	}
-
-	/* free this handle: the put matching the get in inotify_init() */
-	put_inotify_handle(ih);
-}
-EXPORT_SYMBOL_GPL(inotify_destroy);
-
-/**
- * inotify_find_watch - find an existing watch for an (ih,inode) pair
- * @ih: inotify handle
- * @inode: inode to watch
- * @watchp: pointer to existing inotify_watch
- *
- * Caller must pin given inode (via nameidata).
- */
-s32 inotify_find_watch(struct inotify_handle *ih, struct inode *inode,
-		       struct inotify_watch **watchp)
-{
-	struct inotify_watch *old;
-	int ret = -ENOENT;
-
-	mutex_lock(&inode->inotify_mutex);
-	mutex_lock(&ih->mutex);
-
-	old = inode_find_handle(inode, ih);
-	if (unlikely(old)) {
-		get_inotify_watch(old); /* caller must put watch */
-		*watchp = old;
-		ret = old->wd;
-	}
-
-	mutex_unlock(&ih->mutex);
-	mutex_unlock(&inode->inotify_mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(inotify_find_watch);
-
-/**
- * inotify_find_update_watch - find and update the mask of an existing watch
- * @ih: inotify handle
- * @inode: inode's watch to update
- * @mask: mask of events to watch
- *
- * Caller must pin given inode (via nameidata).
- */
-s32 inotify_find_update_watch(struct inotify_handle *ih, struct inode *inode,
-			      u32 mask)
-{
-	struct inotify_watch *old;
-	int mask_add = 0;
-	int ret;
-
-	if (mask & IN_MASK_ADD)
-		mask_add = 1;
-
-	/* don't allow invalid bits: we don't want flags set */
-	mask &= IN_ALL_EVENTS | IN_ONESHOT;
-	if (unlikely(!mask))
-		return -EINVAL;
-
-	mutex_lock(&inode->inotify_mutex);
-	mutex_lock(&ih->mutex);
-
-	/*
-	 * Handle the case of re-adding a watch on an (inode,ih) pair that we
-	 * are already watching.  We just update the mask and return its wd.
-	 */
-	old = inode_find_handle(inode, ih);
-	if (unlikely(!old)) {
-		ret = -ENOENT;
-		goto out;
-	}
-
-	if (mask_add)
-		old->mask |= mask;
-	else
-		old->mask = mask;
-	ret = old->wd;
-out:
-	mutex_unlock(&ih->mutex);
-	mutex_unlock(&inode->inotify_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(inotify_find_update_watch);
-
-/**
- * inotify_add_watch - add a watch to an inotify instance
- * @ih: inotify handle
- * @watch: caller allocated watch structure
- * @inode: inode to watch
- * @mask: mask of events to watch
- *
- * Caller must pin given inode (via nameidata).
- * Caller must ensure it only calls inotify_add_watch() once per watch.
- * Calls inotify_handle_get_wd() so may sleep.
- */
-s32 inotify_add_watch(struct inotify_handle *ih, struct inotify_watch *watch,
-		      struct inode *inode, u32 mask)
-{
-	int ret = 0;
-	int newly_watched;
-
-	/* don't allow invalid bits: we don't want flags set */
-	mask &= IN_ALL_EVENTS | IN_ONESHOT;
-	if (unlikely(!mask))
-		return -EINVAL;
-	watch->mask = mask;
-
-	mutex_lock(&inode->inotify_mutex);
-	mutex_lock(&ih->mutex);
-
-	/* Initialize a new watch */
-	ret = inotify_handle_get_wd(ih, watch);
-	if (unlikely(ret))
-		goto out;
-	ret = watch->wd;
-
-	/* save a reference to handle and bump the count to make it official */
-	get_inotify_handle(ih);
-	watch->ih = ih;
-
-	/*
-	 * Save a reference to the inode and bump the ref count to make it
-	 * official.  We hold a reference to nameidata, which makes this safe.
-	 */
-	watch->inode = igrab(inode);
-
-	/* Add the watch to the handle's and the inode's list */
-	newly_watched = !inotify_inode_watched(inode);
-	list_add(&watch->h_list, &ih->watches);
-	list_add(&watch->i_list, &inode->inotify_watches);
-	/*
-	 * Set child flags _after_ adding the watch, so there is no race
-	 * windows where newly instantiated children could miss their parent's
-	 * watched flag.
-	 */
-	if (newly_watched)
-		set_dentry_child_flags(inode, 1);
-
-out:
-	mutex_unlock(&ih->mutex);
-	mutex_unlock(&inode->inotify_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(inotify_add_watch);
-
-/**
- * inotify_clone_watch - put the watch next to existing one
- * @old: already installed watch
- * @new: new watch
- *
- * Caller must hold the inotify_mutex of inode we are dealing with;
- * it is expected to remove the old watch before unlocking the inode.
- */
-s32 inotify_clone_watch(struct inotify_watch *old, struct inotify_watch *new)
-{
-	struct inotify_handle *ih = old->ih;
-	int ret = 0;
-
-	new->mask = old->mask;
-	new->ih = ih;
-
-	mutex_lock(&ih->mutex);
-
-	/* Initialize a new watch */
-	ret = inotify_handle_get_wd(ih, new);
-	if (unlikely(ret))
-		goto out;
-	ret = new->wd;
-
-	get_inotify_handle(ih);
-
-	new->inode = igrab(old->inode);
-
-	list_add(&new->h_list, &ih->watches);
-	list_add(&new->i_list, &old->inode->inotify_watches);
-out:
-	mutex_unlock(&ih->mutex);
-	return ret;
-}
-
-void inotify_evict_watch(struct inotify_watch *watch)
-{
-	get_inotify_watch(watch);
-	mutex_lock(&watch->ih->mutex);
-	inotify_remove_watch_locked(watch->ih, watch);
-	mutex_unlock(&watch->ih->mutex);
-}
-
-/**
- * inotify_rm_wd - remove a watch from an inotify instance
- * @ih: inotify handle
- * @wd: watch descriptor to remove
- *
- * Can sleep.
- */
-int inotify_rm_wd(struct inotify_handle *ih, u32 wd)
-{
-	struct inotify_watch *watch;
-	struct inode *inode;
-
-	mutex_lock(&ih->mutex);
-	watch = idr_find(&ih->idr, wd);
-	if (unlikely(!watch)) {
-		mutex_unlock(&ih->mutex);
-		return -EINVAL;
-	}
-	get_inotify_watch(watch);
-	inode = watch->inode;
-	mutex_unlock(&ih->mutex);
-
-	mutex_lock(&inode->inotify_mutex);
-	mutex_lock(&ih->mutex);
-
-	/* make sure that we did not race */
-	if (likely(idr_find(&ih->idr, wd) == watch))
-		inotify_remove_watch_locked(ih, watch);
-
-	mutex_unlock(&ih->mutex);
-	mutex_unlock(&inode->inotify_mutex);
-	put_inotify_watch(watch);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(inotify_rm_wd);
-
-/**
- * inotify_rm_watch - remove a watch from an inotify instance
- * @ih: inotify handle
- * @watch: watch to remove
- *
- * Can sleep.
- */
-int inotify_rm_watch(struct inotify_handle *ih,
-		     struct inotify_watch *watch)
-{
-	return inotify_rm_wd(ih, watch->wd);
-}
-EXPORT_SYMBOL_GPL(inotify_rm_watch);
-
-/*
- * inotify_setup - core initialization function
- */
-static int __init inotify_setup(void)
-{
-	atomic_set(&inotify_cookie, 0);
-
-	return 0;
-}
-
-module_init(inotify_setup);
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
deleted file mode 100644
index d367e9b..0000000
--- a/fs/inotify_user.c
+++ /dev/null
@@ -1,778 +0,0 @@
-/*
- * fs/inotify_user.c - inotify support for userspace
- *
- * Authors:
- *	John McCutchan	<ttb@tentacle.dhs.org>
- *	Robert Love	<rml@novell.com>
- *
- * Copyright (C) 2005 John McCutchan
- * Copyright 2006 Hewlett-Packard Development Company, L.P.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/fs.h>
-#include <linux/file.h>
-#include <linux/mount.h>
-#include <linux/namei.h>
-#include <linux/poll.h>
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/inotify.h>
-#include <linux/syscalls.h>
-#include <linux/magic.h>
-
-#include <asm/ioctls.h>
-
-static struct kmem_cache *watch_cachep __read_mostly;
-static struct kmem_cache *event_cachep __read_mostly;
-
-static struct vfsmount *inotify_mnt __read_mostly;
-
-/* these are configurable via /proc/sys/fs/inotify/ */
-static int inotify_max_user_instances __read_mostly;
-static int inotify_max_user_watches __read_mostly;
-static int inotify_max_queued_events __read_mostly;
-
-/*
- * Lock ordering:
- *
- * inotify_dev->up_mutex (ensures we don't re-add the same watch)
- * 	inode->inotify_mutex (protects inode's watch list)
- * 		inotify_handle->mutex (protects inotify_handle's watch list)
- * 			inotify_dev->ev_mutex (protects device's event queue)
- */
-
-/*
- * Lifetimes of the main data structures:
- *
- * inotify_device: Lifetime is managed by reference count, from
- * sys_inotify_init() until release.  Additional references can bump the count
- * via get_inotify_dev() and drop the count via put_inotify_dev().
- *
- * inotify_user_watch: Lifetime is from create_watch() to the receipt of an
- * IN_IGNORED event from inotify, or when using IN_ONESHOT, to receipt of the
- * first event, or to inotify_destroy().
- */
-
-/*
- * struct inotify_device - represents an inotify instance
- *
- * This structure is protected by the mutex 'mutex'.
- */
-struct inotify_device {
-	wait_queue_head_t 	wq;		/* wait queue for i/o */
-	struct mutex		ev_mutex;	/* protects event queue */
-	struct mutex		up_mutex;	/* synchronizes watch updates */
-	struct list_head 	events;		/* list of queued events */
-	atomic_t		count;		/* reference count */
-	struct user_struct	*user;		/* user who opened this dev */
-	struct inotify_handle	*ih;		/* inotify handle */
-	struct fasync_struct    *fa;            /* async notification */
-	unsigned int		queue_size;	/* size of the queue (bytes) */
-	unsigned int		event_count;	/* number of pending events */
-	unsigned int		max_events;	/* maximum number of events */
-};
-
-/*
- * struct inotify_kernel_event - An inotify event, originating from a watch and
- * queued for user-space.  A list of these is attached to each instance of the
- * device.  In read(), this list is walked and all events that can fit in the
- * buffer are returned.
- *
- * Protected by dev->ev_mutex of the device in which we are queued.
- */
-struct inotify_kernel_event {
-	struct inotify_event	event;	/* the user-space event */
-	struct list_head        list;	/* entry in inotify_device's list */
-	char			*name;	/* filename, if any */
-};
-
-/*
- * struct inotify_user_watch - our version of an inotify_watch, we add
- * a reference to the associated inotify_device.
- */
-struct inotify_user_watch {
-	struct inotify_device	*dev;	/* associated device */
-	struct inotify_watch	wdata;	/* inotify watch data */
-};
-
-#ifdef CONFIG_SYSCTL
-
-#include <linux/sysctl.h>
-
-static int zero;
-
-ctl_table inotify_table[] = {
-	{
-		.ctl_name	= INOTIFY_MAX_USER_INSTANCES,
-		.procname	= "max_user_instances",
-		.data		= &inotify_max_user_instances,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &zero,
-	},
-	{
-		.ctl_name	= INOTIFY_MAX_USER_WATCHES,
-		.procname	= "max_user_watches",
-		.data		= &inotify_max_user_watches,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &zero,
-	},
-	{
-		.ctl_name	= INOTIFY_MAX_QUEUED_EVENTS,
-		.procname	= "max_queued_events",
-		.data		= &inotify_max_queued_events,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &zero
-	},
-	{ .ctl_name = 0 }
-};
-#endif /* CONFIG_SYSCTL */
-
-static inline void get_inotify_dev(struct inotify_device *dev)
-{
-	atomic_inc(&dev->count);
-}
-
-static inline void put_inotify_dev(struct inotify_device *dev)
-{
-	if (atomic_dec_and_test(&dev->count)) {
-		atomic_dec(&dev->user->inotify_devs);
-		free_uid(dev->user);
-		kfree(dev);
-	}
-}
-
-/*
- * free_inotify_user_watch - cleans up the watch and its references
- */
-static void free_inotify_user_watch(struct inotify_watch *w)
-{
-	struct inotify_user_watch *watch;
-	struct inotify_device *dev;
-
-	watch = container_of(w, struct inotify_user_watch, wdata);
-	dev = watch->dev;
-
-	atomic_dec(&dev->user->inotify_watches);
-	put_inotify_dev(dev);
-	kmem_cache_free(watch_cachep, watch);
-}
-
-/*
- * kernel_event - create a new kernel event with the given parameters
- *
- * This function can sleep.
- */
-static struct inotify_kernel_event * kernel_event(s32 wd, u32 mask, u32 cookie,
-						  const char *name)
-{
-	struct inotify_kernel_event *kevent;
-
-	kevent = kmem_cache_alloc(event_cachep, GFP_NOFS);
-	if (unlikely(!kevent))
-		return NULL;
-
-	/* we hand this out to user-space, so zero it just in case */
-	memset(&kevent->event, 0, sizeof(struct inotify_event));
-
-	kevent->event.wd = wd;
-	kevent->event.mask = mask;
-	kevent->event.cookie = cookie;
-
-	INIT_LIST_HEAD(&kevent->list);
-
-	if (name) {
-		size_t len, rem, event_size = sizeof(struct inotify_event);
-
-		/*
-		 * We need to pad the filename so as to properly align an
-		 * array of inotify_event structures.  Because the structure is
-		 * small and the common case is a small filename, we just round
-		 * up to the next multiple of the structure's sizeof.  This is
-		 * simple and safe for all architectures.
-		 */
-		len = strlen(name) + 1;
-		rem = event_size - len;
-		if (len > event_size) {
-			rem = event_size - (len % event_size);
-			if (len % event_size == 0)
-				rem = 0;
-		}
-
-		kevent->name = kmalloc(len + rem, GFP_KERNEL);
-		if (unlikely(!kevent->name)) {
-			kmem_cache_free(event_cachep, kevent);
-			return NULL;
-		}
-		memcpy(kevent->name, name, len);
-		if (rem)
-			memset(kevent->name + len, 0, rem);
-		kevent->event.len = len + rem;
-	} else {
-		kevent->event.len = 0;
-		kevent->name = NULL;
-	}
-
-	return kevent;
-}
-
-/*
- * inotify_dev_get_event - return the next event in the given dev's queue
- *
- * Caller must hold dev->ev_mutex.
- */
-static inline struct inotify_kernel_event *
-inotify_dev_get_event(struct inotify_device *dev)
-{
-	return list_entry(dev->events.next, struct inotify_kernel_event, list);
-}
-
-/*
- * inotify_dev_get_last_event - return the last event in the given dev's queue
- *
- * Caller must hold dev->ev_mutex.
- */
-static inline struct inotify_kernel_event *
-inotify_dev_get_last_event(struct inotify_device *dev)
-{
-	if (list_empty(&dev->events))
-		return NULL;
-	return list_entry(dev->events.prev, struct inotify_kernel_event, list);
-}
-
-/*
- * inotify_dev_queue_event - event handler registered with core inotify, adds
- * a new event to the given device
- *
- * Can sleep (calls kernel_event()).
- */
-static void inotify_dev_queue_event(struct inotify_watch *w, u32 wd, u32 mask,
-				    u32 cookie, const char *name,
-				    struct inode *ignored)
-{
-	struct inotify_user_watch *watch;
-	struct inotify_device *dev;
-	struct inotify_kernel_event *kevent, *last;
-
-	watch = container_of(w, struct inotify_user_watch, wdata);
-	dev = watch->dev;
-
-	mutex_lock(&dev->ev_mutex);
-
-	/* we can safely put the watch as we don't reference it while
-	 * generating the event
-	 */
-	if (mask & IN_IGNORED || w->mask & IN_ONESHOT)
-		put_inotify_watch(w); /* final put */
-
-	/* coalescing: drop this event if it is a dupe of the previous */
-	last = inotify_dev_get_last_event(dev);
-	if (last && last->event.mask == mask && last->event.wd == wd &&
-			last->event.cookie == cookie) {
-		const char *lastname = last->name;
-
-		if (!name && !lastname)
-			goto out;
-		if (name && lastname && !strcmp(lastname, name))
-			goto out;
-	}
-
-	/* the queue overflowed and we already sent the Q_OVERFLOW event */
-	if (unlikely(dev->event_count > dev->max_events))
-		goto out;
-
-	/* if the queue overflows, we need to notify user space */
-	if (unlikely(dev->event_count == dev->max_events))
-		kevent = kernel_event(-1, IN_Q_OVERFLOW, cookie, NULL);
-	else
-		kevent = kernel_event(wd, mask, cookie, name);
-
-	if (unlikely(!kevent))
-		goto out;
-
-	/* queue the event and wake up anyone waiting */
-	dev->event_count++;
-	dev->queue_size += sizeof(struct inotify_event) + kevent->event.len;
-	list_add_tail(&kevent->list, &dev->events);
-	wake_up_interruptible(&dev->wq);
-	kill_fasync(&dev->fa, SIGIO, POLL_IN);
-
-out:
-	mutex_unlock(&dev->ev_mutex);
-}
-
-/*
- * remove_kevent - cleans up the given kevent
- *
- * Caller must hold dev->ev_mutex.
- */
-static void remove_kevent(struct inotify_device *dev,
-			  struct inotify_kernel_event *kevent)
-{
-	list_del(&kevent->list);
-
-	dev->event_count--;
-	dev->queue_size -= sizeof(struct inotify_event) + kevent->event.len;
-}
-
-/*
- * free_kevent - frees the given kevent.
- */
-static void free_kevent(struct inotify_kernel_event *kevent)
-{
-	kfree(kevent->name);
-	kmem_cache_free(event_cachep, kevent);
-}
-
-/*
- * inotify_dev_event_dequeue - destroy an event on the given device
- *
- * Caller must hold dev->ev_mutex.
- */
-static void inotify_dev_event_dequeue(struct inotify_device *dev)
-{
-	if (!list_empty(&dev->events)) {
-		struct inotify_kernel_event *kevent;
-		kevent = inotify_dev_get_event(dev);
-		remove_kevent(dev, kevent);
-		free_kevent(kevent);
-	}
-}
-
-/*
- * find_inode - resolve a user-given path to a specific inode
- */
-static int find_inode(const char __user *dirname, struct path *path,
-		      unsigned flags)
-{
-	int error;
-
-	error = user_path_at(AT_FDCWD, dirname, flags, path);
-	if (error)
-		return error;
-	/* you can only watch an inode if you have read permissions on it */
-	error = inode_permission(path->dentry->d_inode, MAY_READ);
-	if (error)
-		path_put(path);
-	return error;
-}
-
-/*
- * create_watch - creates a watch on the given device.
- *
- * Callers must hold dev->up_mutex.
- */
-static int create_watch(struct inotify_device *dev, struct inode *inode,
-			u32 mask)
-{
-	struct inotify_user_watch *watch;
-	int ret;
-
-	if (atomic_read(&dev->user->inotify_watches) >=
-			inotify_max_user_watches)
-		return -ENOSPC;
-
-	watch = kmem_cache_alloc(watch_cachep, GFP_KERNEL);
-	if (unlikely(!watch))
-		return -ENOMEM;
-
-	/* save a reference to device and bump the count to make it official */
-	get_inotify_dev(dev);
-	watch->dev = dev;
-
-	atomic_inc(&dev->user->inotify_watches);
-
-	inotify_init_watch(&watch->wdata);
-	ret = inotify_add_watch(dev->ih, &watch->wdata, inode, mask);
-	if (ret < 0)
-		free_inotify_user_watch(&watch->wdata);
-
-	return ret;
-}
-
-/* Device Interface */
-
-static unsigned int inotify_poll(struct file *file, poll_table *wait)
-{
-	struct inotify_device *dev = file->private_data;
-	int ret = 0;
-
-	poll_wait(file, &dev->wq, wait);
-	mutex_lock(&dev->ev_mutex);
-	if (!list_empty(&dev->events))
-		ret = POLLIN | POLLRDNORM;
-	mutex_unlock(&dev->ev_mutex);
-
-	return ret;
-}
-
-static ssize_t inotify_read(struct file *file, char __user *buf,
-			    size_t count, loff_t *pos)
-{
-	size_t event_size = sizeof (struct inotify_event);
-	struct inotify_device *dev;
-	char __user *start;
-	int ret;
-	DEFINE_WAIT(wait);
-
-	start = buf;
-	dev = file->private_data;
-
-	while (1) {
-
-		prepare_to_wait(&dev->wq, &wait, TASK_INTERRUPTIBLE);
-
-		mutex_lock(&dev->ev_mutex);
-		if (!list_empty(&dev->events)) {
-			ret = 0;
-			break;
-		}
-		mutex_unlock(&dev->ev_mutex);
-
-		if (file->f_flags & O_NONBLOCK) {
-			ret = -EAGAIN;
-			break;
-		}
-
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-
-		schedule();
-	}
-
-	finish_wait(&dev->wq, &wait);
-	if (ret)
-		return ret;
-
-	while (1) {
-		struct inotify_kernel_event *kevent;
-
-		ret = buf - start;
-		if (list_empty(&dev->events))
-			break;
-
-		kevent = inotify_dev_get_event(dev);
-		if (event_size + kevent->event.len > count) {
-			if (ret == 0 && count > 0) {
-				/*
-				 * could not get a single event because we
-				 * didn't have enough buffer space.
-				 */
-				ret = -EINVAL;
-			}
-			break;
-		}
-		remove_kevent(dev, kevent);
-
-		/*
-		 * Must perform the copy_to_user outside the mutex in order
-		 * to avoid a lock order reversal with mmap_sem.
-		 */
-		mutex_unlock(&dev->ev_mutex);
-
-		if (copy_to_user(buf, &kevent->event, event_size)) {
-			ret = -EFAULT;
-			break;
-		}
-		buf += event_size;
-		count -= event_size;
-
-		if (kevent->name) {
-			if (copy_to_user(buf, kevent->name, kevent->event.len)){
-				ret = -EFAULT;
-				break;
-			}
-			buf += kevent->event.len;
-			count -= kevent->event.len;
-		}
-
-		free_kevent(kevent);
-
-		mutex_lock(&dev->ev_mutex);
-	}
-	mutex_unlock(&dev->ev_mutex);
-
-	return ret;
-}
-
-static int inotify_fasync(int fd, struct file *file, int on)
-{
-	struct inotify_device *dev = file->private_data;
-
-	return fasync_helper(fd, file, on, &dev->fa) >= 0 ? 0 : -EIO;
-}
-
-static int inotify_release(struct inode *ignored, struct file *file)
-{
-	struct inotify_device *dev = file->private_data;
-
-	inotify_destroy(dev->ih);
-
-	/* destroy all of the events on this device */
-	mutex_lock(&dev->ev_mutex);
-	while (!list_empty(&dev->events))
-		inotify_dev_event_dequeue(dev);
-	mutex_unlock(&dev->ev_mutex);
-
-	/* free this device: the put matching the get in inotify_init() */
-	put_inotify_dev(dev);
-
-	return 0;
-}
-
-static long inotify_ioctl(struct file *file, unsigned int cmd,
-			  unsigned long arg)
-{
-	struct inotify_device *dev;
-	void __user *p;
-	int ret = -ENOTTY;
-
-	dev = file->private_data;
-	p = (void __user *) arg;
-
-	switch (cmd) {
-	case FIONREAD:
-		ret = put_user(dev->queue_size, (int __user *) p);
-		break;
-	}
-
-	return ret;
-}
-
-static const struct file_operations inotify_fops = {
-	.poll           = inotify_poll,
-	.read           = inotify_read,
-	.fasync         = inotify_fasync,
-	.release        = inotify_release,
-	.unlocked_ioctl = inotify_ioctl,
-	.compat_ioctl	= inotify_ioctl,
-};
-
-static const struct inotify_operations inotify_user_ops = {
-	.handle_event	= inotify_dev_queue_event,
-	.destroy_watch	= free_inotify_user_watch,
-};
-
-asmlinkage long sys_inotify_init1(int flags)
-{
-	struct inotify_device *dev;
-	struct inotify_handle *ih;
-	struct user_struct *user;
-	struct file *filp;
-	int fd, ret;
-
-	/* Check the IN_* constants for consistency.  */
-	BUILD_BUG_ON(IN_CLOEXEC != O_CLOEXEC);
-	BUILD_BUG_ON(IN_NONBLOCK != O_NONBLOCK);
-
-	if (flags & ~(IN_CLOEXEC | IN_NONBLOCK))
-		return -EINVAL;
-
-	fd = get_unused_fd_flags(flags & O_CLOEXEC);
-	if (fd < 0)
-		return fd;
-
-	filp = get_empty_filp();
-	if (!filp) {
-		ret = -ENFILE;
-		goto out_put_fd;
-	}
-
-	user = get_uid(current->user);
-	if (unlikely(atomic_read(&user->inotify_devs) >=
-			inotify_max_user_instances)) {
-		ret = -EMFILE;
-		goto out_free_uid;
-	}
-
-	dev = kmalloc(sizeof(struct inotify_device), GFP_KERNEL);
-	if (unlikely(!dev)) {
-		ret = -ENOMEM;
-		goto out_free_uid;
-	}
-
-	ih = inotify_init(&inotify_user_ops);
-	if (IS_ERR(ih)) {
-		ret = PTR_ERR(ih);
-		goto out_free_dev;
-	}
-	dev->ih = ih;
-	dev->fa = NULL;
-
-	filp->f_op = &inotify_fops;
-	filp->f_path.mnt = mntget(inotify_mnt);
-	filp->f_path.dentry = dget(inotify_mnt->mnt_root);
-	filp->f_mapping = filp->f_path.dentry->d_inode->i_mapping;
-	filp->f_mode = FMODE_READ;
-	filp->f_flags = O_RDONLY | (flags & O_NONBLOCK);
-	filp->private_data = dev;
-
-	INIT_LIST_HEAD(&dev->events);
-	init_waitqueue_head(&dev->wq);
-	mutex_init(&dev->ev_mutex);
-	mutex_init(&dev->up_mutex);
-	dev->event_count = 0;
-	dev->queue_size = 0;
-	dev->max_events = inotify_max_queued_events;
-	dev->user = user;
-	atomic_set(&dev->count, 0);
-
-	get_inotify_dev(dev);
-	atomic_inc(&user->inotify_devs);
-	fd_install(fd, filp);
-
-	return fd;
-out_free_dev:
-	kfree(dev);
-out_free_uid:
-	free_uid(user);
-	put_filp(filp);
-out_put_fd:
-	put_unused_fd(fd);
-	return ret;
-}
-
-asmlinkage long sys_inotify_init(void)
-{
-	return sys_inotify_init1(0);
-}
-
-asmlinkage long sys_inotify_add_watch(int fd, const char __user *pathname, u32 mask)
-{
-	struct inode *inode;
-	struct inotify_device *dev;
-	struct path path;
-	struct file *filp;
-	int ret, fput_needed;
-	unsigned flags = 0;
-
-	filp = fget_light(fd, &fput_needed);
-	if (unlikely(!filp))
-		return -EBADF;
-
-	/* verify that this is indeed an inotify instance */
-	if (unlikely(filp->f_op != &inotify_fops)) {
-		ret = -EINVAL;
-		goto fput_and_out;
-	}
-
-	if (!(mask & IN_DONT_FOLLOW))
-		flags |= LOOKUP_FOLLOW;
-	if (mask & IN_ONLYDIR)
-		flags |= LOOKUP_DIRECTORY;
-
-	ret = find_inode(pathname, &path, flags);
-	if (unlikely(ret))
-		goto fput_and_out;
-
-	/* inode held in place by reference to path; dev by fget on fd */
-	inode = path.dentry->d_inode;
-	dev = filp->private_data;
-
-	mutex_lock(&dev->up_mutex);
-	ret = inotify_find_update_watch(dev->ih, inode, mask);
-	if (ret == -ENOENT)
-		ret = create_watch(dev, inode, mask);
-	mutex_unlock(&dev->up_mutex);
-
-	path_put(&path);
-fput_and_out:
-	fput_light(filp, fput_needed);
-	return ret;
-}
-
-asmlinkage long sys_inotify_rm_watch(int fd, u32 wd)
-{
-	struct file *filp;
-	struct inotify_device *dev;
-	int ret, fput_needed;
-
-	filp = fget_light(fd, &fput_needed);
-	if (unlikely(!filp))
-		return -EBADF;
-
-	/* verify that this is indeed an inotify instance */
-	if (unlikely(filp->f_op != &inotify_fops)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	dev = filp->private_data;
-
-	/* we free our watch data when we get IN_IGNORED */
-	ret = inotify_rm_wd(dev->ih, wd);
-
-out:
-	fput_light(filp, fput_needed);
-	return ret;
-}
-
-static int
-inotify_get_sb(struct file_system_type *fs_type, int flags,
-	       const char *dev_name, void *data, struct vfsmount *mnt)
-{
-	return get_sb_pseudo(fs_type, "inotify", NULL,
-			INOTIFYFS_SUPER_MAGIC, mnt);
-}
-
-static struct file_system_type inotify_fs_type = {
-    .name           = "inotifyfs",
-    .get_sb         = inotify_get_sb,
-    .kill_sb        = kill_anon_super,
-};
-
-/*
- * inotify_user_setup - Our initialization function.  Note that we cannnot return
- * error because we have compiled-in VFS hooks.  So an (unlikely) failure here
- * must result in panic().
- */
-static int __init inotify_user_setup(void)
-{
-	int ret;
-
-	ret = register_filesystem(&inotify_fs_type);
-	if (unlikely(ret))
-		panic("inotify: register_filesystem returned %d!\n", ret);
-
-	inotify_mnt = kern_mount(&inotify_fs_type);
-	if (IS_ERR(inotify_mnt))
-		panic("inotify: kern_mount ret %ld!\n", PTR_ERR(inotify_mnt));
-
-	inotify_max_queued_events = 16384;
-	inotify_max_user_instances = 128;
-	inotify_max_user_watches = 8192;
-
-	watch_cachep = kmem_cache_create("inotify_watch_cache",
-					 sizeof(struct inotify_user_watch),
-					 0, SLAB_PANIC, NULL);
-	event_cachep = kmem_cache_create("inotify_event_cache",
-					 sizeof(struct inotify_kernel_event),
-					 0, SLAB_PANIC, NULL);
-
-	return 0;
-}
-
-module_init(inotify_user_setup);
diff --git a/fs/notify/Kconfig b/fs/notify/Kconfig
new file mode 100644
index 0000000..23415de
--- /dev/null
+++ b/fs/notify/Kconfig
@@ -0,0 +1,38 @@
+config DNOTIFY
+	bool "Dnotify support"
+	default y
+	help
+	  Dnotify is a directory-based per-fd file change notification system
+	  that uses signals to communicate events to user-space.  There exist
+	  superior alternatives, but some applications may still rely on
+	  dnotify.
+
+	  If unsure, say Y.
+
+config INOTIFY
+	bool "Inotify file change notification support"
+	default y
+	---help---
+	  Say Y here to enable inotify support.  Inotify is a file change
+	  notification system and a replacement for dnotify.  Inotify fixes
+	  numerous shortcomings in dnotify and introduces several new features
+	  including multiple file events, one-shot support, and unmount
+	  notification.
+
+	  For more information, see <file:Documentation/filesystems/inotify.txt>
+
+	  If unsure, say Y.
+
+config INOTIFY_USER
+	bool "Inotify support for userspace"
+	depends on INOTIFY
+	default y
+	---help---
+	  Say Y here to enable inotify support for userspace, including the
+	  associated system calls.  Inotify allows monitoring of both files and
+	  directories via a single open fd.  Events are read from the file
+	  descriptor, which is also select()- and poll()-able.
+
+	  For more information, see <file:Documentation/filesystems/inotify.txt>
+
+	  If unsure, say Y.
diff --git a/fs/notify/Makefile b/fs/notify/Makefile
new file mode 100644
index 0000000..882ecf9
--- /dev/null
+++ b/fs/notify/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_INOTIFY)		+= inotify.o
+obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
+
+obj-$(CONFIG_DNOTIFY)		+= dnotify.o
diff --git a/fs/notify/dnotify.c b/fs/notify/dnotify.c
new file mode 100644
index 0000000..676073b
--- /dev/null
+++ b/fs/notify/dnotify.c
@@ -0,0 +1,194 @@
+/*
+ * Directory notifications for Linux.
+ *
+ * Copyright (C) 2000,2001,2002 Stephen Rothwell
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/dnotify.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/fdtable.h>
+
+int dir_notify_enable __read_mostly = 1;
+
+static struct kmem_cache *dn_cache __read_mostly;
+
+static void redo_inode_mask(struct inode *inode)
+{
+	unsigned long new_mask;
+	struct dnotify_struct *dn;
+
+	new_mask = 0;
+	for (dn = inode->i_dnotify; dn != NULL; dn = dn->dn_next)
+		new_mask |= dn->dn_mask & ~DN_MULTISHOT;
+	inode->i_dnotify_mask = new_mask;
+}
+
+void dnotify_flush(struct file *filp, fl_owner_t id)
+{
+	struct dnotify_struct *dn;
+	struct dnotify_struct **prev;
+	struct inode *inode;
+
+	inode = filp->f_path.dentry->d_inode;
+	if (!S_ISDIR(inode->i_mode))
+		return;
+	spin_lock(&inode->i_lock);
+	prev = &inode->i_dnotify;
+	while ((dn = *prev) != NULL) {
+		if ((dn->dn_owner == id) && (dn->dn_filp == filp)) {
+			*prev = dn->dn_next;
+			redo_inode_mask(inode);
+			kmem_cache_free(dn_cache, dn);
+			break;
+		}
+		prev = &dn->dn_next;
+	}
+	spin_unlock(&inode->i_lock);
+}
+
+int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
+{
+	struct dnotify_struct *dn;
+	struct dnotify_struct *odn;
+	struct dnotify_struct **prev;
+	struct inode *inode;
+	fl_owner_t id = current->files;
+	struct file *f;
+	int error = 0;
+
+	if ((arg & ~DN_MULTISHOT) == 0) {
+		dnotify_flush(filp, id);
+		return 0;
+	}
+	if (!dir_notify_enable)
+		return -EINVAL;
+	inode = filp->f_path.dentry->d_inode;
+	if (!S_ISDIR(inode->i_mode))
+		return -ENOTDIR;
+	dn = kmem_cache_alloc(dn_cache, GFP_KERNEL);
+	if (dn == NULL)
+		return -ENOMEM;
+	spin_lock(&inode->i_lock);
+	prev = &inode->i_dnotify;
+	while ((odn = *prev) != NULL) {
+		if ((odn->dn_owner == id) && (odn->dn_filp == filp)) {
+			odn->dn_fd = fd;
+			odn->dn_mask |= arg;
+			inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
+			goto out_free;
+		}
+		prev = &odn->dn_next;
+	}
+
+	rcu_read_lock();
+	f = fcheck(fd);
+	rcu_read_unlock();
+	/* we'd lost the race with close(), sod off silently */
+	/* note that inode->i_lock prevents reordering problems
+	 * between accesses to descriptor table and ->i_dnotify */
+	if (f != filp)
+		goto out_free;
+
+	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
+	if (error)
+		goto out_free;
+
+	dn->dn_mask = arg;
+	dn->dn_fd = fd;
+	dn->dn_filp = filp;
+	dn->dn_owner = id;
+	inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
+	dn->dn_next = inode->i_dnotify;
+	inode->i_dnotify = dn;
+	spin_unlock(&inode->i_lock);
+
+	if (filp->f_op && filp->f_op->dir_notify)
+		return filp->f_op->dir_notify(filp, arg);
+	return 0;
+
+out_free:
+	spin_unlock(&inode->i_lock);
+	kmem_cache_free(dn_cache, dn);
+	return error;
+}
+
+void __inode_dir_notify(struct inode *inode, unsigned long event)
+{
+	struct dnotify_struct *	dn;
+	struct dnotify_struct **prev;
+	struct fown_struct *	fown;
+	int			changed = 0;
+
+	spin_lock(&inode->i_lock);
+	prev = &inode->i_dnotify;
+	while ((dn = *prev) != NULL) {
+		if ((dn->dn_mask & event) == 0) {
+			prev = &dn->dn_next;
+			continue;
+		}
+		fown = &dn->dn_filp->f_owner;
+		send_sigio(fown, dn->dn_fd, POLL_MSG);
+		if (dn->dn_mask & DN_MULTISHOT)
+			prev = &dn->dn_next;
+		else {
+			*prev = dn->dn_next;
+			changed = 1;
+			kmem_cache_free(dn_cache, dn);
+		}
+	}
+	if (changed)
+		redo_inode_mask(inode);
+	spin_unlock(&inode->i_lock);
+}
+
+EXPORT_SYMBOL(__inode_dir_notify);
+
+/*
+ * This is hopelessly wrong, but unfixable without API changes.  At
+ * least it doesn't oops the kernel...
+ *
+ * To safely access ->d_parent we need to keep d_move away from it.  Use the
+ * dentry's d_lock for this.
+ */
+void dnotify_parent(struct dentry *dentry, unsigned long event)
+{
+	struct dentry *parent;
+
+	if (!dir_notify_enable)
+		return;
+
+	spin_lock(&dentry->d_lock);
+	parent = dentry->d_parent;
+	if (parent->d_inode->i_dnotify_mask & event) {
+		dget(parent);
+		spin_unlock(&dentry->d_lock);
+		__inode_dir_notify(parent->d_inode, event);
+		dput(parent);
+	} else {
+		spin_unlock(&dentry->d_lock);
+	}
+}
+EXPORT_SYMBOL_GPL(dnotify_parent);
+
+static int __init dnotify_init(void)
+{
+	dn_cache = kmem_cache_create("dnotify_cache",
+		sizeof(struct dnotify_struct), 0, SLAB_PANIC, NULL);
+	return 0;
+}
+
+module_init(dnotify_init)
diff --git a/fs/notify/inotify.c b/fs/notify/inotify.c
new file mode 100644
index 0000000..690e725
--- /dev/null
+++ b/fs/notify/inotify.c
@@ -0,0 +1,773 @@
+/*
+ * fs/inotify.c - inode-based file event notifications
+ *
+ * Authors:
+ *	John McCutchan	<ttb@tentacle.dhs.org>
+ *	Robert Love	<rml@novell.com>
+ *
+ * Kernel API added by: Amy Griffis <amy.griffis@hp.com>
+ *
+ * Copyright (C) 2005 John McCutchan
+ * Copyright 2006 Hewlett-Packard Development Company, L.P.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/idr.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/writeback.h>
+#include <linux/inotify.h>
+
+static atomic_t inotify_cookie;
+
+/*
+ * Lock ordering:
+ *
+ * dentry->d_lock (used to keep d_move() away from dentry->d_parent)
+ * iprune_mutex (synchronize shrink_icache_memory())
+ * 	inode_lock (protects the super_block->s_inodes list)
+ * 	inode->inotify_mutex (protects inode->inotify_watches and watches->i_list)
+ * 		inotify_handle->mutex (protects inotify_handle and watches->h_list)
+ *
+ * The inode->inotify_mutex and inotify_handle->mutex and held during execution
+ * of a caller's event handler.  Thus, the caller must not hold any locks
+ * taken in their event handler while calling any of the published inotify
+ * interfaces.
+ */
+
+/*
+ * Lifetimes of the three main data structures--inotify_handle, inode, and
+ * inotify_watch--are managed by reference count.
+ *
+ * inotify_handle: Lifetime is from inotify_init() to inotify_destroy().
+ * Additional references can bump the count via get_inotify_handle() and drop
+ * the count via put_inotify_handle().
+ *
+ * inotify_watch: for inotify's purposes, lifetime is from inotify_add_watch()
+ * to remove_watch_no_event().  Additional references can bump the count via
+ * get_inotify_watch() and drop the count via put_inotify_watch().  The caller
+ * is reponsible for the final put after receiving IN_IGNORED, or when using
+ * IN_ONESHOT after receiving the first event.  Inotify does the final put if
+ * inotify_destroy() is called.
+ *
+ * inode: Pinned so long as the inode is associated with a watch, from
+ * inotify_add_watch() to the final put_inotify_watch().
+ */
+
+/*
+ * struct inotify_handle - represents an inotify instance
+ *
+ * This structure is protected by the mutex 'mutex'.
+ */
+struct inotify_handle {
+	struct idr		idr;		/* idr mapping wd -> watch */
+	struct mutex		mutex;		/* protects this bad boy */
+	struct list_head	watches;	/* list of watches */
+	atomic_t		count;		/* reference count */
+	u32			last_wd;	/* the last wd allocated */
+	const struct inotify_operations *in_ops; /* inotify caller operations */
+};
+
+static inline void get_inotify_handle(struct inotify_handle *ih)
+{
+	atomic_inc(&ih->count);
+}
+
+static inline void put_inotify_handle(struct inotify_handle *ih)
+{
+	if (atomic_dec_and_test(&ih->count)) {
+		idr_destroy(&ih->idr);
+		kfree(ih);
+	}
+}
+
+/**
+ * get_inotify_watch - grab a reference to an inotify_watch
+ * @watch: watch to grab
+ */
+void get_inotify_watch(struct inotify_watch *watch)
+{
+	atomic_inc(&watch->count);
+}
+EXPORT_SYMBOL_GPL(get_inotify_watch);
+
+/**
+ * put_inotify_watch - decrements the ref count on a given watch.  cleans up
+ * watch references if the count reaches zero.  inotify_watch is freed by
+ * inotify callers via the destroy_watch() op.
+ * @watch: watch to release
+ */
+void put_inotify_watch(struct inotify_watch *watch)
+{
+	if (atomic_dec_and_test(&watch->count)) {
+		struct inotify_handle *ih = watch->ih;
+
+		iput(watch->inode);
+		ih->in_ops->destroy_watch(watch);
+		put_inotify_handle(ih);
+	}
+}
+EXPORT_SYMBOL_GPL(put_inotify_watch);
+
+/*
+ * inotify_handle_get_wd - returns the next WD for use by the given handle
+ *
+ * Callers must hold ih->mutex.  This function can sleep.
+ */
+static int inotify_handle_get_wd(struct inotify_handle *ih,
+				 struct inotify_watch *watch)
+{
+	int ret;
+
+	do {
+		if (unlikely(!idr_pre_get(&ih->idr, GFP_KERNEL)))
+			return -ENOSPC;
+		ret = idr_get_new_above(&ih->idr, watch, ih->last_wd+1, &watch->wd);
+	} while (ret == -EAGAIN);
+
+	if (likely(!ret))
+		ih->last_wd = watch->wd;
+
+	return ret;
+}
+
+/*
+ * inotify_inode_watched - returns nonzero if there are watches on this inode
+ * and zero otherwise.  We call this lockless, we do not care if we race.
+ */
+static inline int inotify_inode_watched(struct inode *inode)
+{
+	return !list_empty(&inode->inotify_watches);
+}
+
+/*
+ * Get child dentry flag into synch with parent inode.
+ * Flag should always be clear for negative dentrys.
+ */
+static void set_dentry_child_flags(struct inode *inode, int watched)
+{
+	struct dentry *alias;
+
+	spin_lock(&dcache_lock);
+	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
+		struct dentry *child;
+
+		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
+			if (!child->d_inode)
+				continue;
+
+			spin_lock(&child->d_lock);
+			if (watched)
+				child->d_flags |= DCACHE_INOTIFY_PARENT_WATCHED;
+			else
+				child->d_flags &=~DCACHE_INOTIFY_PARENT_WATCHED;
+			spin_unlock(&child->d_lock);
+		}
+	}
+	spin_unlock(&dcache_lock);
+}
+
+/*
+ * inotify_find_handle - find the watch associated with the given inode and
+ * handle
+ *
+ * Callers must hold inode->inotify_mutex.
+ */
+static struct inotify_watch *inode_find_handle(struct inode *inode,
+					       struct inotify_handle *ih)
+{
+	struct inotify_watch *watch;
+
+	list_for_each_entry(watch, &inode->inotify_watches, i_list) {
+		if (watch->ih == ih)
+			return watch;
+	}
+
+	return NULL;
+}
+
+/*
+ * remove_watch_no_event - remove watch without the IN_IGNORED event.
+ *
+ * Callers must hold both inode->inotify_mutex and ih->mutex.
+ */
+static void remove_watch_no_event(struct inotify_watch *watch,
+				  struct inotify_handle *ih)
+{
+	list_del(&watch->i_list);
+	list_del(&watch->h_list);
+
+	if (!inotify_inode_watched(watch->inode))
+		set_dentry_child_flags(watch->inode, 0);
+
+	idr_remove(&ih->idr, watch->wd);
+}
+
+/**
+ * inotify_remove_watch_locked - Remove a watch from both the handle and the
+ * inode.  Sends the IN_IGNORED event signifying that the inode is no longer
+ * watched.  May be invoked from a caller's event handler.
+ * @ih: inotify handle associated with watch
+ * @watch: watch to remove
+ *
+ * Callers must hold both inode->inotify_mutex and ih->mutex.
+ */
+void inotify_remove_watch_locked(struct inotify_handle *ih,
+				 struct inotify_watch *watch)
+{
+	remove_watch_no_event(watch, ih);
+	ih->in_ops->handle_event(watch, watch->wd, IN_IGNORED, 0, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(inotify_remove_watch_locked);
+
+/* Kernel API for producing events */
+
+/*
+ * inotify_d_instantiate - instantiate dcache entry for inode
+ */
+void inotify_d_instantiate(struct dentry *entry, struct inode *inode)
+{
+	struct dentry *parent;
+
+	if (!inode)
+		return;
+
+	spin_lock(&entry->d_lock);
+	parent = entry->d_parent;
+	if (parent->d_inode && inotify_inode_watched(parent->d_inode))
+		entry->d_flags |= DCACHE_INOTIFY_PARENT_WATCHED;
+	spin_unlock(&entry->d_lock);
+}
+
+/*
+ * inotify_d_move - dcache entry has been moved
+ */
+void inotify_d_move(struct dentry *entry)
+{
+	struct dentry *parent;
+
+	parent = entry->d_parent;
+	if (inotify_inode_watched(parent->d_inode))
+		entry->d_flags |= DCACHE_INOTIFY_PARENT_WATCHED;
+	else
+		entry->d_flags &= ~DCACHE_INOTIFY_PARENT_WATCHED;
+}
+
+/**
+ * inotify_inode_queue_event - queue an event to all watches on this inode
+ * @inode: inode event is originating from
+ * @mask: event mask describing this event
+ * @cookie: cookie for synchronization, or zero
+ * @name: filename, if any
+ * @n_inode: inode associated with name
+ */
+void inotify_inode_queue_event(struct inode *inode, u32 mask, u32 cookie,
+			       const char *name, struct inode *n_inode)
+{
+	struct inotify_watch *watch, *next;
+
+	if (!inotify_inode_watched(inode))
+		return;
+
+	mutex_lock(&inode->inotify_mutex);
+	list_for_each_entry_safe(watch, next, &inode->inotify_watches, i_list) {
+		u32 watch_mask = watch->mask;
+		if (watch_mask & mask) {
+			struct inotify_handle *ih= watch->ih;
+			mutex_lock(&ih->mutex);
+			if (watch_mask & IN_ONESHOT)
+				remove_watch_no_event(watch, ih);
+			ih->in_ops->handle_event(watch, watch->wd, mask, cookie,
+						 name, n_inode);
+			mutex_unlock(&ih->mutex);
+		}
+	}
+	mutex_unlock(&inode->inotify_mutex);
+}
+EXPORT_SYMBOL_GPL(inotify_inode_queue_event);
+
+/**
+ * inotify_dentry_parent_queue_event - queue an event to a dentry's parent
+ * @dentry: the dentry in question, we queue against this dentry's parent
+ * @mask: event mask describing this event
+ * @cookie: cookie for synchronization, or zero
+ * @name: filename, if any
+ */
+void inotify_dentry_parent_queue_event(struct dentry *dentry, u32 mask,
+				       u32 cookie, const char *name)
+{
+	struct dentry *parent;
+	struct inode *inode;
+
+	if (!(dentry->d_flags & DCACHE_INOTIFY_PARENT_WATCHED))
+		return;
+
+	spin_lock(&dentry->d_lock);
+	parent = dentry->d_parent;
+	inode = parent->d_inode;
+
+	if (inotify_inode_watched(inode)) {
+		dget(parent);
+		spin_unlock(&dentry->d_lock);
+		inotify_inode_queue_event(inode, mask, cookie, name,
+					  dentry->d_inode);
+		dput(parent);
+	} else
+		spin_unlock(&dentry->d_lock);
+}
+EXPORT_SYMBOL_GPL(inotify_dentry_parent_queue_event);
+
+/**
+ * inotify_get_cookie - return a unique cookie for use in synchronizing events.
+ */
+u32 inotify_get_cookie(void)
+{
+	return atomic_inc_return(&inotify_cookie);
+}
+EXPORT_SYMBOL_GPL(inotify_get_cookie);
+
+/**
+ * inotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
+ * @list: list of inodes being unmounted (sb->s_inodes)
+ *
+ * Called with inode_lock held, protecting the unmounting super block's list
+ * of inodes, and with iprune_mutex held, keeping shrink_icache_memory() at bay.
+ * We temporarily drop inode_lock, however, and CAN block.
+ */
+void inotify_unmount_inodes(struct list_head *list)
+{
+	struct inode *inode, *next_i, *need_iput = NULL;
+
+	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
+		struct inotify_watch *watch, *next_w;
+		struct inode *need_iput_tmp;
+		struct list_head *watches;
+
+		/*
+		 * If i_count is zero, the inode cannot have any watches and
+		 * doing an __iget/iput with MS_ACTIVE clear would actually
+		 * evict all inodes with zero i_count from icache which is
+		 * unnecessarily violent and may in fact be illegal to do.
+		 */
+		if (!atomic_read(&inode->i_count))
+			continue;
+
+		/*
+		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING, or
+		 * I_WILL_FREE which is fine because by that point the inode
+		 * cannot have any associated watches.
+		 */
+		if (inode->i_state & (I_CLEAR | I_FREEING | I_WILL_FREE))
+			continue;
+
+		need_iput_tmp = need_iput;
+		need_iput = NULL;
+		/* In case inotify_remove_watch_locked() drops a reference. */
+		if (inode != need_iput_tmp)
+			__iget(inode);
+		else
+			need_iput_tmp = NULL;
+		/* In case the dropping of a reference would nuke next_i. */
+		if ((&next_i->i_sb_list != list) &&
+				atomic_read(&next_i->i_count) &&
+				!(next_i->i_state & (I_CLEAR | I_FREEING |
+					I_WILL_FREE))) {
+			__iget(next_i);
+			need_iput = next_i;
+		}
+
+		/*
+		 * We can safely drop inode_lock here because we hold
+		 * references on both inode and next_i.  Also no new inodes
+		 * will be added since the umount has begun.  Finally,
+		 * iprune_mutex keeps shrink_icache_memory() away.
+		 */
+		spin_unlock(&inode_lock);
+
+		if (need_iput_tmp)
+			iput(need_iput_tmp);
+
+		/* for each watch, send IN_UNMOUNT and then remove it */
+		mutex_lock(&inode->inotify_mutex);
+		watches = &inode->inotify_watches;
+		list_for_each_entry_safe(watch, next_w, watches, i_list) {
+			struct inotify_handle *ih= watch->ih;
+			mutex_lock(&ih->mutex);
+			ih->in_ops->handle_event(watch, watch->wd, IN_UNMOUNT, 0,
+						 NULL, NULL);
+			inotify_remove_watch_locked(ih, watch);
+			mutex_unlock(&ih->mutex);
+		}
+		mutex_unlock(&inode->inotify_mutex);
+		iput(inode);		
+
+		spin_lock(&inode_lock);
+	}
+}
+EXPORT_SYMBOL_GPL(inotify_unmount_inodes);
+
+/**
+ * inotify_inode_is_dead - an inode has been deleted, cleanup any watches
+ * @inode: inode that is about to be removed
+ */
+void inotify_inode_is_dead(struct inode *inode)
+{
+	struct inotify_watch *watch, *next;
+
+	mutex_lock(&inode->inotify_mutex);
+	list_for_each_entry_safe(watch, next, &inode->inotify_watches, i_list) {
+		struct inotify_handle *ih = watch->ih;
+		mutex_lock(&ih->mutex);
+		inotify_remove_watch_locked(ih, watch);
+		mutex_unlock(&ih->mutex);
+	}
+	mutex_unlock(&inode->inotify_mutex);
+}
+EXPORT_SYMBOL_GPL(inotify_inode_is_dead);
+
+/* Kernel Consumer API */
+
+/**
+ * inotify_init - allocate and initialize an inotify instance
+ * @ops: caller's inotify operations
+ */
+struct inotify_handle *inotify_init(const struct inotify_operations *ops)
+{
+	struct inotify_handle *ih;
+
+	ih = kmalloc(sizeof(struct inotify_handle), GFP_KERNEL);
+	if (unlikely(!ih))
+		return ERR_PTR(-ENOMEM);
+
+	idr_init(&ih->idr);
+	INIT_LIST_HEAD(&ih->watches);
+	mutex_init(&ih->mutex);
+	ih->last_wd = 0;
+	ih->in_ops = ops;
+	atomic_set(&ih->count, 0);
+	get_inotify_handle(ih);
+
+	return ih;
+}
+EXPORT_SYMBOL_GPL(inotify_init);
+
+/**
+ * inotify_init_watch - initialize an inotify watch
+ * @watch: watch to initialize
+ */
+void inotify_init_watch(struct inotify_watch *watch)
+{
+	INIT_LIST_HEAD(&watch->h_list);
+	INIT_LIST_HEAD(&watch->i_list);
+	atomic_set(&watch->count, 0);
+	get_inotify_watch(watch); /* initial get */
+}
+EXPORT_SYMBOL_GPL(inotify_init_watch);
+
+/**
+ * inotify_destroy - clean up and destroy an inotify instance
+ * @ih: inotify handle
+ */
+void inotify_destroy(struct inotify_handle *ih)
+{
+	/*
+	 * Destroy all of the watches for this handle. Unfortunately, not very
+	 * pretty.  We cannot do a simple iteration over the list, because we
+	 * do not know the inode until we iterate to the watch.  But we need to
+	 * hold inode->inotify_mutex before ih->mutex.  The following works.
+	 */
+	while (1) {
+		struct inotify_watch *watch;
+		struct list_head *watches;
+		struct inode *inode;
+
+		mutex_lock(&ih->mutex);
+		watches = &ih->watches;
+		if (list_empty(watches)) {
+			mutex_unlock(&ih->mutex);
+			break;
+		}
+		watch = list_first_entry(watches, struct inotify_watch, h_list);
+		get_inotify_watch(watch);
+		mutex_unlock(&ih->mutex);
+
+		inode = watch->inode;
+		mutex_lock(&inode->inotify_mutex);
+		mutex_lock(&ih->mutex);
+
+		/* make sure we didn't race with another list removal */
+		if (likely(idr_find(&ih->idr, watch->wd))) {
+			remove_watch_no_event(watch, ih);
+			put_inotify_watch(watch);
+		}
+
+		mutex_unlock(&ih->mutex);
+		mutex_unlock(&inode->inotify_mutex);
+		put_inotify_watch(watch);
+	}
+
+	/* free this handle: the put matching the get in inotify_init() */
+	put_inotify_handle(ih);
+}
+EXPORT_SYMBOL_GPL(inotify_destroy);
+
+/**
+ * inotify_find_watch - find an existing watch for an (ih,inode) pair
+ * @ih: inotify handle
+ * @inode: inode to watch
+ * @watchp: pointer to existing inotify_watch
+ *
+ * Caller must pin given inode (via nameidata).
+ */
+s32 inotify_find_watch(struct inotify_handle *ih, struct inode *inode,
+		       struct inotify_watch **watchp)
+{
+	struct inotify_watch *old;
+	int ret = -ENOENT;
+
+	mutex_lock(&inode->inotify_mutex);
+	mutex_lock(&ih->mutex);
+
+	old = inode_find_handle(inode, ih);
+	if (unlikely(old)) {
+		get_inotify_watch(old); /* caller must put watch */
+		*watchp = old;
+		ret = old->wd;
+	}
+
+	mutex_unlock(&ih->mutex);
+	mutex_unlock(&inode->inotify_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(inotify_find_watch);
+
+/**
+ * inotify_find_update_watch - find and update the mask of an existing watch
+ * @ih: inotify handle
+ * @inode: inode's watch to update
+ * @mask: mask of events to watch
+ *
+ * Caller must pin given inode (via nameidata).
+ */
+s32 inotify_find_update_watch(struct inotify_handle *ih, struct inode *inode,
+			      u32 mask)
+{
+	struct inotify_watch *old;
+	int mask_add = 0;
+	int ret;
+
+	if (mask & IN_MASK_ADD)
+		mask_add = 1;
+
+	/* don't allow invalid bits: we don't want flags set */
+	mask &= IN_ALL_EVENTS | IN_ONESHOT;
+	if (unlikely(!mask))
+		return -EINVAL;
+
+	mutex_lock(&inode->inotify_mutex);
+	mutex_lock(&ih->mutex);
+
+	/*
+	 * Handle the case of re-adding a watch on an (inode,ih) pair that we
+	 * are already watching.  We just update the mask and return its wd.
+	 */
+	old = inode_find_handle(inode, ih);
+	if (unlikely(!old)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (mask_add)
+		old->mask |= mask;
+	else
+		old->mask = mask;
+	ret = old->wd;
+out:
+	mutex_unlock(&ih->mutex);
+	mutex_unlock(&inode->inotify_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(inotify_find_update_watch);
+
+/**
+ * inotify_add_watch - add a watch to an inotify instance
+ * @ih: inotify handle
+ * @watch: caller allocated watch structure
+ * @inode: inode to watch
+ * @mask: mask of events to watch
+ *
+ * Caller must pin given inode (via nameidata).
+ * Caller must ensure it only calls inotify_add_watch() once per watch.
+ * Calls inotify_handle_get_wd() so may sleep.
+ */
+s32 inotify_add_watch(struct inotify_handle *ih, struct inotify_watch *watch,
+		      struct inode *inode, u32 mask)
+{
+	int ret = 0;
+	int newly_watched;
+
+	/* don't allow invalid bits: we don't want flags set */
+	mask &= IN_ALL_EVENTS | IN_ONESHOT;
+	if (unlikely(!mask))
+		return -EINVAL;
+	watch->mask = mask;
+
+	mutex_lock(&inode->inotify_mutex);
+	mutex_lock(&ih->mutex);
+
+	/* Initialize a new watch */
+	ret = inotify_handle_get_wd(ih, watch);
+	if (unlikely(ret))
+		goto out;
+	ret = watch->wd;
+
+	/* save a reference to handle and bump the count to make it official */
+	get_inotify_handle(ih);
+	watch->ih = ih;
+
+	/*
+	 * Save a reference to the inode and bump the ref count to make it
+	 * official.  We hold a reference to nameidata, which makes this safe.
+	 */
+	watch->inode = igrab(inode);
+
+	/* Add the watch to the handle's and the inode's list */
+	newly_watched = !inotify_inode_watched(inode);
+	list_add(&watch->h_list, &ih->watches);
+	list_add(&watch->i_list, &inode->inotify_watches);
+	/*
+	 * Set child flags _after_ adding the watch, so there is no race
+	 * windows where newly instantiated children could miss their parent's
+	 * watched flag.
+	 */
+	if (newly_watched)
+		set_dentry_child_flags(inode, 1);
+
+out:
+	mutex_unlock(&ih->mutex);
+	mutex_unlock(&inode->inotify_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(inotify_add_watch);
+
+/**
+ * inotify_clone_watch - put the watch next to existing one
+ * @old: already installed watch
+ * @new: new watch
+ *
+ * Caller must hold the inotify_mutex of inode we are dealing with;
+ * it is expected to remove the old watch before unlocking the inode.
+ */
+s32 inotify_clone_watch(struct inotify_watch *old, struct inotify_watch *new)
+{
+	struct inotify_handle *ih = old->ih;
+	int ret = 0;
+
+	new->mask = old->mask;
+	new->ih = ih;
+
+	mutex_lock(&ih->mutex);
+
+	/* Initialize a new watch */
+	ret = inotify_handle_get_wd(ih, new);
+	if (unlikely(ret))
+		goto out;
+	ret = new->wd;
+
+	get_inotify_handle(ih);
+
+	new->inode = igrab(old->inode);
+
+	list_add(&new->h_list, &ih->watches);
+	list_add(&new->i_list, &old->inode->inotify_watches);
+out:
+	mutex_unlock(&ih->mutex);
+	return ret;
+}
+
+void inotify_evict_watch(struct inotify_watch *watch)
+{
+	get_inotify_watch(watch);
+	mutex_lock(&watch->ih->mutex);
+	inotify_remove_watch_locked(watch->ih, watch);
+	mutex_unlock(&watch->ih->mutex);
+}
+
+/**
+ * inotify_rm_wd - remove a watch from an inotify instance
+ * @ih: inotify handle
+ * @wd: watch descriptor to remove
+ *
+ * Can sleep.
+ */
+int inotify_rm_wd(struct inotify_handle *ih, u32 wd)
+{
+	struct inotify_watch *watch;
+	struct inode *inode;
+
+	mutex_lock(&ih->mutex);
+	watch = idr_find(&ih->idr, wd);
+	if (unlikely(!watch)) {
+		mutex_unlock(&ih->mutex);
+		return -EINVAL;
+	}
+	get_inotify_watch(watch);
+	inode = watch->inode;
+	mutex_unlock(&ih->mutex);
+
+	mutex_lock(&inode->inotify_mutex);
+	mutex_lock(&ih->mutex);
+
+	/* make sure that we did not race */
+	if (likely(idr_find(&ih->idr, wd) == watch))
+		inotify_remove_watch_locked(ih, watch);
+
+	mutex_unlock(&ih->mutex);
+	mutex_unlock(&inode->inotify_mutex);
+	put_inotify_watch(watch);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(inotify_rm_wd);
+
+/**
+ * inotify_rm_watch - remove a watch from an inotify instance
+ * @ih: inotify handle
+ * @watch: watch to remove
+ *
+ * Can sleep.
+ */
+int inotify_rm_watch(struct inotify_handle *ih,
+		     struct inotify_watch *watch)
+{
+	return inotify_rm_wd(ih, watch->wd);
+}
+EXPORT_SYMBOL_GPL(inotify_rm_watch);
+
+/*
+ * inotify_setup - core initialization function
+ */
+static int __init inotify_setup(void)
+{
+	atomic_set(&inotify_cookie, 0);
+
+	return 0;
+}
+
+module_init(inotify_setup);
diff --git a/fs/notify/inotify_user.c b/fs/notify/inotify_user.c
new file mode 100644
index 0000000..d367e9b
--- /dev/null
+++ b/fs/notify/inotify_user.c
@@ -0,0 +1,778 @@
+/*
+ * fs/inotify_user.c - inotify support for userspace
+ *
+ * Authors:
+ *	John McCutchan	<ttb@tentacle.dhs.org>
+ *	Robert Love	<rml@novell.com>
+ *
+ * Copyright (C) 2005 John McCutchan
+ * Copyright 2006 Hewlett-Packard Development Company, L.P.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/inotify.h>
+#include <linux/syscalls.h>
+#include <linux/magic.h>
+
+#include <asm/ioctls.h>
+
+static struct kmem_cache *watch_cachep __read_mostly;
+static struct kmem_cache *event_cachep __read_mostly;
+
+static struct vfsmount *inotify_mnt __read_mostly;
+
+/* these are configurable via /proc/sys/fs/inotify/ */
+static int inotify_max_user_instances __read_mostly;
+static int inotify_max_user_watches __read_mostly;
+static int inotify_max_queued_events __read_mostly;
+
+/*
+ * Lock ordering:
+ *
+ * inotify_dev->up_mutex (ensures we don't re-add the same watch)
+ * 	inode->inotify_mutex (protects inode's watch list)
+ * 		inotify_handle->mutex (protects inotify_handle's watch list)
+ * 			inotify_dev->ev_mutex (protects device's event queue)
+ */
+
+/*
+ * Lifetimes of the main data structures:
+ *
+ * inotify_device: Lifetime is managed by reference count, from
+ * sys_inotify_init() until release.  Additional references can bump the count
+ * via get_inotify_dev() and drop the count via put_inotify_dev().
+ *
+ * inotify_user_watch: Lifetime is from create_watch() to the receipt of an
+ * IN_IGNORED event from inotify, or when using IN_ONESHOT, to receipt of the
+ * first event, or to inotify_destroy().
+ */
+
+/*
+ * struct inotify_device - represents an inotify instance
+ *
+ * This structure is protected by the mutex 'mutex'.
+ */
+struct inotify_device {
+	wait_queue_head_t 	wq;		/* wait queue for i/o */
+	struct mutex		ev_mutex;	/* protects event queue */
+	struct mutex		up_mutex;	/* synchronizes watch updates */
+	struct list_head 	events;		/* list of queued events */
+	atomic_t		count;		/* reference count */
+	struct user_struct	*user;		/* user who opened this dev */
+	struct inotify_handle	*ih;		/* inotify handle */
+	struct fasync_struct    *fa;            /* async notification */
+	unsigned int		queue_size;	/* size of the queue (bytes) */
+	unsigned int		event_count;	/* number of pending events */
+	unsigned int		max_events;	/* maximum number of events */
+};
+
+/*
+ * struct inotify_kernel_event - An inotify event, originating from a watch and
+ * queued for user-space.  A list of these is attached to each instance of the
+ * device.  In read(), this list is walked and all events that can fit in the
+ * buffer are returned.
+ *
+ * Protected by dev->ev_mutex of the device in which we are queued.
+ */
+struct inotify_kernel_event {
+	struct inotify_event	event;	/* the user-space event */
+	struct list_head        list;	/* entry in inotify_device's list */
+	char			*name;	/* filename, if any */
+};
+
+/*
+ * struct inotify_user_watch - our version of an inotify_watch, we add
+ * a reference to the associated inotify_device.
+ */
+struct inotify_user_watch {
+	struct inotify_device	*dev;	/* associated device */
+	struct inotify_watch	wdata;	/* inotify watch data */
+};
+
+#ifdef CONFIG_SYSCTL
+
+#include <linux/sysctl.h>
+
+static int zero;
+
+ctl_table inotify_table[] = {
+	{
+		.ctl_name	= INOTIFY_MAX_USER_INSTANCES,
+		.procname	= "max_user_instances",
+		.data		= &inotify_max_user_instances,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+	{
+		.ctl_name	= INOTIFY_MAX_USER_WATCHES,
+		.procname	= "max_user_watches",
+		.data		= &inotify_max_user_watches,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+	{
+		.ctl_name	= INOTIFY_MAX_QUEUED_EVENTS,
+		.procname	= "max_queued_events",
+		.data		= &inotify_max_queued_events,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero
+	},
+	{ .ctl_name = 0 }
+};
+#endif /* CONFIG_SYSCTL */
+
+static inline void get_inotify_dev(struct inotify_device *dev)
+{
+	atomic_inc(&dev->count);
+}
+
+static inline void put_inotify_dev(struct inotify_device *dev)
+{
+	if (atomic_dec_and_test(&dev->count)) {
+		atomic_dec(&dev->user->inotify_devs);
+		free_uid(dev->user);
+		kfree(dev);
+	}
+}
+
+/*
+ * free_inotify_user_watch - cleans up the watch and its references
+ */
+static void free_inotify_user_watch(struct inotify_watch *w)
+{
+	struct inotify_user_watch *watch;
+	struct inotify_device *dev;
+
+	watch = container_of(w, struct inotify_user_watch, wdata);
+	dev = watch->dev;
+
+	atomic_dec(&dev->user->inotify_watches);
+	put_inotify_dev(dev);
+	kmem_cache_free(watch_cachep, watch);
+}
+
+/*
+ * kernel_event - create a new kernel event with the given parameters
+ *
+ * This function can sleep.
+ */
+static struct inotify_kernel_event * kernel_event(s32 wd, u32 mask, u32 cookie,
+						  const char *name)
+{
+	struct inotify_kernel_event *kevent;
+
+	kevent = kmem_cache_alloc(event_cachep, GFP_NOFS);
+	if (unlikely(!kevent))
+		return NULL;
+
+	/* we hand this out to user-space, so zero it just in case */
+	memset(&kevent->event, 0, sizeof(struct inotify_event));
+
+	kevent->event.wd = wd;
+	kevent->event.mask = mask;
+	kevent->event.cookie = cookie;
+
+	INIT_LIST_HEAD(&kevent->list);
+
+	if (name) {
+		size_t len, rem, event_size = sizeof(struct inotify_event);
+
+		/*
+		 * We need to pad the filename so as to properly align an
+		 * array of inotify_event structures.  Because the structure is
+		 * small and the common case is a small filename, we just round
+		 * up to the next multiple of the structure's sizeof.  This is
+		 * simple and safe for all architectures.
+		 */
+		len = strlen(name) + 1;
+		rem = event_size - len;
+		if (len > event_size) {
+			rem = event_size - (len % event_size);
+			if (len % event_size == 0)
+				rem = 0;
+		}
+
+		kevent->name = kmalloc(len + rem, GFP_KERNEL);
+		if (unlikely(!kevent->name)) {
+			kmem_cache_free(event_cachep, kevent);
+			return NULL;
+		}
+		memcpy(kevent->name, name, len);
+		if (rem)
+			memset(kevent->name + len, 0, rem);
+		kevent->event.len = len + rem;
+	} else {
+		kevent->event.len = 0;
+		kevent->name = NULL;
+	}
+
+	return kevent;
+}
+
+/*
+ * inotify_dev_get_event - return the next event in the given dev's queue
+ *
+ * Caller must hold dev->ev_mutex.
+ */
+static inline struct inotify_kernel_event *
+inotify_dev_get_event(struct inotify_device *dev)
+{
+	return list_entry(dev->events.next, struct inotify_kernel_event, list);
+}
+
+/*
+ * inotify_dev_get_last_event - return the last event in the given dev's queue
+ *
+ * Caller must hold dev->ev_mutex.
+ */
+static inline struct inotify_kernel_event *
+inotify_dev_get_last_event(struct inotify_device *dev)
+{
+	if (list_empty(&dev->events))
+		return NULL;
+	return list_entry(dev->events.prev, struct inotify_kernel_event, list);
+}
+
+/*
+ * inotify_dev_queue_event - event handler registered with core inotify, adds
+ * a new event to the given device
+ *
+ * Can sleep (calls kernel_event()).
+ */
+static void inotify_dev_queue_event(struct inotify_watch *w, u32 wd, u32 mask,
+				    u32 cookie, const char *name,
+				    struct inode *ignored)
+{
+	struct inotify_user_watch *watch;
+	struct inotify_device *dev;
+	struct inotify_kernel_event *kevent, *last;
+
+	watch = container_of(w, struct inotify_user_watch, wdata);
+	dev = watch->dev;
+
+	mutex_lock(&dev->ev_mutex);
+
+	/* we can safely put the watch as we don't reference it while
+	 * generating the event
+	 */
+	if (mask & IN_IGNORED || w->mask & IN_ONESHOT)
+		put_inotify_watch(w); /* final put */
+
+	/* coalescing: drop this event if it is a dupe of the previous */
+	last = inotify_dev_get_last_event(dev);
+	if (last && last->event.mask == mask && last->event.wd == wd &&
+			last->event.cookie == cookie) {
+		const char *lastname = last->name;
+
+		if (!name && !lastname)
+			goto out;
+		if (name && lastname && !strcmp(lastname, name))
+			goto out;
+	}
+
+	/* the queue overflowed and we already sent the Q_OVERFLOW event */
+	if (unlikely(dev->event_count > dev->max_events))
+		goto out;
+
+	/* if the queue overflows, we need to notify user space */
+	if (unlikely(dev->event_count == dev->max_events))
+		kevent = kernel_event(-1, IN_Q_OVERFLOW, cookie, NULL);
+	else
+		kevent = kernel_event(wd, mask, cookie, name);
+
+	if (unlikely(!kevent))
+		goto out;
+
+	/* queue the event and wake up anyone waiting */
+	dev->event_count++;
+	dev->queue_size += sizeof(struct inotify_event) + kevent->event.len;
+	list_add_tail(&kevent->list, &dev->events);
+	wake_up_interruptible(&dev->wq);
+	kill_fasync(&dev->fa, SIGIO, POLL_IN);
+
+out:
+	mutex_unlock(&dev->ev_mutex);
+}
+
+/*
+ * remove_kevent - cleans up the given kevent
+ *
+ * Caller must hold dev->ev_mutex.
+ */
+static void remove_kevent(struct inotify_device *dev,
+			  struct inotify_kernel_event *kevent)
+{
+	list_del(&kevent->list);
+
+	dev->event_count--;
+	dev->queue_size -= sizeof(struct inotify_event) + kevent->event.len;
+}
+
+/*
+ * free_kevent - frees the given kevent.
+ */
+static void free_kevent(struct inotify_kernel_event *kevent)
+{
+	kfree(kevent->name);
+	kmem_cache_free(event_cachep, kevent);
+}
+
+/*
+ * inotify_dev_event_dequeue - destroy an event on the given device
+ *
+ * Caller must hold dev->ev_mutex.
+ */
+static void inotify_dev_event_dequeue(struct inotify_device *dev)
+{
+	if (!list_empty(&dev->events)) {
+		struct inotify_kernel_event *kevent;
+		kevent = inotify_dev_get_event(dev);
+		remove_kevent(dev, kevent);
+		free_kevent(kevent);
+	}
+}
+
+/*
+ * find_inode - resolve a user-given path to a specific inode
+ */
+static int find_inode(const char __user *dirname, struct path *path,
+		      unsigned flags)
+{
+	int error;
+
+	error = user_path_at(AT_FDCWD, dirname, flags, path);
+	if (error)
+		return error;
+	/* you can only watch an inode if you have read permissions on it */
+	error = inode_permission(path->dentry->d_inode, MAY_READ);
+	if (error)
+		path_put(path);
+	return error;
+}
+
+/*
+ * create_watch - creates a watch on the given device.
+ *
+ * Callers must hold dev->up_mutex.
+ */
+static int create_watch(struct inotify_device *dev, struct inode *inode,
+			u32 mask)
+{
+	struct inotify_user_watch *watch;
+	int ret;
+
+	if (atomic_read(&dev->user->inotify_watches) >=
+			inotify_max_user_watches)
+		return -ENOSPC;
+
+	watch = kmem_cache_alloc(watch_cachep, GFP_KERNEL);
+	if (unlikely(!watch))
+		return -ENOMEM;
+
+	/* save a reference to device and bump the count to make it official */
+	get_inotify_dev(dev);
+	watch->dev = dev;
+
+	atomic_inc(&dev->user->inotify_watches);
+
+	inotify_init_watch(&watch->wdata);
+	ret = inotify_add_watch(dev->ih, &watch->wdata, inode, mask);
+	if (ret < 0)
+		free_inotify_user_watch(&watch->wdata);
+
+	return ret;
+}
+
+/* Device Interface */
+
+static unsigned int inotify_poll(struct file *file, poll_table *wait)
+{
+	struct inotify_device *dev = file->private_data;
+	int ret = 0;
+
+	poll_wait(file, &dev->wq, wait);
+	mutex_lock(&dev->ev_mutex);
+	if (!list_empty(&dev->events))
+		ret = POLLIN | POLLRDNORM;
+	mutex_unlock(&dev->ev_mutex);
+
+	return ret;
+}
+
+static ssize_t inotify_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *pos)
+{
+	size_t event_size = sizeof (struct inotify_event);
+	struct inotify_device *dev;
+	char __user *start;
+	int ret;
+	DEFINE_WAIT(wait);
+
+	start = buf;
+	dev = file->private_data;
+
+	while (1) {
+
+		prepare_to_wait(&dev->wq, &wait, TASK_INTERRUPTIBLE);
+
+		mutex_lock(&dev->ev_mutex);
+		if (!list_empty(&dev->events)) {
+			ret = 0;
+			break;
+		}
+		mutex_unlock(&dev->ev_mutex);
+
+		if (file->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
+			break;
+		}
+
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
+		schedule();
+	}
+
+	finish_wait(&dev->wq, &wait);
+	if (ret)
+		return ret;
+
+	while (1) {
+		struct inotify_kernel_event *kevent;
+
+		ret = buf - start;
+		if (list_empty(&dev->events))
+			break;
+
+		kevent = inotify_dev_get_event(dev);
+		if (event_size + kevent->event.len > count) {
+			if (ret == 0 && count > 0) {
+				/*
+				 * could not get a single event because we
+				 * didn't have enough buffer space.
+				 */
+				ret = -EINVAL;
+			}
+			break;
+		}
+		remove_kevent(dev, kevent);
+
+		/*
+		 * Must perform the copy_to_user outside the mutex in order
+		 * to avoid a lock order reversal with mmap_sem.
+		 */
+		mutex_unlock(&dev->ev_mutex);
+
+		if (copy_to_user(buf, &kevent->event, event_size)) {
+			ret = -EFAULT;
+			break;
+		}
+		buf += event_size;
+		count -= event_size;
+
+		if (kevent->name) {
+			if (copy_to_user(buf, kevent->name, kevent->event.len)){
+				ret = -EFAULT;
+				break;
+			}
+			buf += kevent->event.len;
+			count -= kevent->event.len;
+		}
+
+		free_kevent(kevent);
+
+		mutex_lock(&dev->ev_mutex);
+	}
+	mutex_unlock(&dev->ev_mutex);
+
+	return ret;
+}
+
+static int inotify_fasync(int fd, struct file *file, int on)
+{
+	struct inotify_device *dev = file->private_data;
+
+	return fasync_helper(fd, file, on, &dev->fa) >= 0 ? 0 : -EIO;
+}
+
+static int inotify_release(struct inode *ignored, struct file *file)
+{
+	struct inotify_device *dev = file->private_data;
+
+	inotify_destroy(dev->ih);
+
+	/* destroy all of the events on this device */
+	mutex_lock(&dev->ev_mutex);
+	while (!list_empty(&dev->events))
+		inotify_dev_event_dequeue(dev);
+	mutex_unlock(&dev->ev_mutex);
+
+	/* free this device: the put matching the get in inotify_init() */
+	put_inotify_dev(dev);
+
+	return 0;
+}
+
+static long inotify_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
+{
+	struct inotify_device *dev;
+	void __user *p;
+	int ret = -ENOTTY;
+
+	dev = file->private_data;
+	p = (void __user *) arg;
+
+	switch (cmd) {
+	case FIONREAD:
+		ret = put_user(dev->queue_size, (int __user *) p);
+		break;
+	}
+
+	return ret;
+}
+
+static const struct file_operations inotify_fops = {
+	.poll           = inotify_poll,
+	.read           = inotify_read,
+	.fasync         = inotify_fasync,
+	.release        = inotify_release,
+	.unlocked_ioctl = inotify_ioctl,
+	.compat_ioctl	= inotify_ioctl,
+};
+
+static const struct inotify_operations inotify_user_ops = {
+	.handle_event	= inotify_dev_queue_event,
+	.destroy_watch	= free_inotify_user_watch,
+};
+
+asmlinkage long sys_inotify_init1(int flags)
+{
+	struct inotify_device *dev;
+	struct inotify_handle *ih;
+	struct user_struct *user;
+	struct file *filp;
+	int fd, ret;
+
+	/* Check the IN_* constants for consistency.  */
+	BUILD_BUG_ON(IN_CLOEXEC != O_CLOEXEC);
+	BUILD_BUG_ON(IN_NONBLOCK != O_NONBLOCK);
+
+	if (flags & ~(IN_CLOEXEC | IN_NONBLOCK))
+		return -EINVAL;
+
+	fd = get_unused_fd_flags(flags & O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	filp = get_empty_filp();
+	if (!filp) {
+		ret = -ENFILE;
+		goto out_put_fd;
+	}
+
+	user = get_uid(current->user);
+	if (unlikely(atomic_read(&user->inotify_devs) >=
+			inotify_max_user_instances)) {
+		ret = -EMFILE;
+		goto out_free_uid;
+	}
+
+	dev = kmalloc(sizeof(struct inotify_device), GFP_KERNEL);
+	if (unlikely(!dev)) {
+		ret = -ENOMEM;
+		goto out_free_uid;
+	}
+
+	ih = inotify_init(&inotify_user_ops);
+	if (IS_ERR(ih)) {
+		ret = PTR_ERR(ih);
+		goto out_free_dev;
+	}
+	dev->ih = ih;
+	dev->fa = NULL;
+
+	filp->f_op = &inotify_fops;
+	filp->f_path.mnt = mntget(inotify_mnt);
+	filp->f_path.dentry = dget(inotify_mnt->mnt_root);
+	filp->f_mapping = filp->f_path.dentry->d_inode->i_mapping;
+	filp->f_mode = FMODE_READ;
+	filp->f_flags = O_RDONLY | (flags & O_NONBLOCK);
+	filp->private_data = dev;
+
+	INIT_LIST_HEAD(&dev->events);
+	init_waitqueue_head(&dev->wq);
+	mutex_init(&dev->ev_mutex);
+	mutex_init(&dev->up_mutex);
+	dev->event_count = 0;
+	dev->queue_size = 0;
+	dev->max_events = inotify_max_queued_events;
+	dev->user = user;
+	atomic_set(&dev->count, 0);
+
+	get_inotify_dev(dev);
+	atomic_inc(&user->inotify_devs);
+	fd_install(fd, filp);
+
+	return fd;
+out_free_dev:
+	kfree(dev);
+out_free_uid:
+	free_uid(user);
+	put_filp(filp);
+out_put_fd:
+	put_unused_fd(fd);
+	return ret;
+}
+
+asmlinkage long sys_inotify_init(void)
+{
+	return sys_inotify_init1(0);
+}
+
+asmlinkage long sys_inotify_add_watch(int fd, const char __user *pathname, u32 mask)
+{
+	struct inode *inode;
+	struct inotify_device *dev;
+	struct path path;
+	struct file *filp;
+	int ret, fput_needed;
+	unsigned flags = 0;
+
+	filp = fget_light(fd, &fput_needed);
+	if (unlikely(!filp))
+		return -EBADF;
+
+	/* verify that this is indeed an inotify instance */
+	if (unlikely(filp->f_op != &inotify_fops)) {
+		ret = -EINVAL;
+		goto fput_and_out;
+	}
+
+	if (!(mask & IN_DONT_FOLLOW))
+		flags |= LOOKUP_FOLLOW;
+	if (mask & IN_ONLYDIR)
+		flags |= LOOKUP_DIRECTORY;
+
+	ret = find_inode(pathname, &path, flags);
+	if (unlikely(ret))
+		goto fput_and_out;
+
+	/* inode held in place by reference to path; dev by fget on fd */
+	inode = path.dentry->d_inode;
+	dev = filp->private_data;
+
+	mutex_lock(&dev->up_mutex);
+	ret = inotify_find_update_watch(dev->ih, inode, mask);
+	if (ret == -ENOENT)
+		ret = create_watch(dev, inode, mask);
+	mutex_unlock(&dev->up_mutex);
+
+	path_put(&path);
+fput_and_out:
+	fput_light(filp, fput_needed);
+	return ret;
+}
+
+asmlinkage long sys_inotify_rm_watch(int fd, u32 wd)
+{
+	struct file *filp;
+	struct inotify_device *dev;
+	int ret, fput_needed;
+
+	filp = fget_light(fd, &fput_needed);
+	if (unlikely(!filp))
+		return -EBADF;
+
+	/* verify that this is indeed an inotify instance */
+	if (unlikely(filp->f_op != &inotify_fops)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	dev = filp->private_data;
+
+	/* we free our watch data when we get IN_IGNORED */
+	ret = inotify_rm_wd(dev->ih, wd);
+
+out:
+	fput_light(filp, fput_needed);
+	return ret;
+}
+
+static int
+inotify_get_sb(struct file_system_type *fs_type, int flags,
+	       const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "inotify", NULL,
+			INOTIFYFS_SUPER_MAGIC, mnt);
+}
+
+static struct file_system_type inotify_fs_type = {
+    .name           = "inotifyfs",
+    .get_sb         = inotify_get_sb,
+    .kill_sb        = kill_anon_super,
+};
+
+/*
+ * inotify_user_setup - Our initialization function.  Note that we cannnot return
+ * error because we have compiled-in VFS hooks.  So an (unlikely) failure here
+ * must result in panic().
+ */
+static int __init inotify_user_setup(void)
+{
+	int ret;
+
+	ret = register_filesystem(&inotify_fs_type);
+	if (unlikely(ret))
+		panic("inotify: register_filesystem returned %d!\n", ret);
+
+	inotify_mnt = kern_mount(&inotify_fs_type);
+	if (IS_ERR(inotify_mnt))
+		panic("inotify: kern_mount ret %ld!\n", PTR_ERR(inotify_mnt));
+
+	inotify_max_queued_events = 16384;
+	inotify_max_user_instances = 128;
+	inotify_max_user_watches = 8192;
+
+	watch_cachep = kmem_cache_create("inotify_watch_cache",
+					 sizeof(struct inotify_user_watch),
+					 0, SLAB_PANIC, NULL);
+	event_cachep = kmem_cache_create("inotify_event_cache",
+					 sizeof(struct inotify_kernel_event),
+					 0, SLAB_PANIC, NULL);
+
+	return 0;
+}
+
+module_init(inotify_user_setup);

