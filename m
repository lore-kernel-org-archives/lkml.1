Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab0BENvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:51:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:57112 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab0BENvx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:51:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=i8hOw+UOyUxCFLuAOEbJ9nCulfbJ78lNBKua4zzveMD4SSsZKmFAa6R8zBbIqkXvmx
         js+rBelDCx70kG7RrFEutyNhx0QAviPCv9zBAuh4F+n2T9fPa0+W8tJZZ2lTmdLdVnYT
         +5luNvtDqqcULvAnwB/VkzwSAU0RBXkAMn76Q=
MIME-Version: 1.0
In-Reply-To: <ac4b79581002050505k22084f90n983be6da8edf6958@mail.gmail.com>
References: <ac4b79581002050505k22084f90n983be6da8edf6958@mail.gmail.com>
Date: Fri, 5 Feb 2010 14:51:50 +0100
Message-ID: <ac4b79581002050551x11c4a42dx12d7fc5780211c90@mail.gmail.com>
Subject: [PATCH] inotify/fsnotify: tree-watching support
From: Joris Dolderer <vorstadtkind@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is my first software submit, so please don't spare with detailed
constructive critics and be nice to me ;-). It adds tree-watching
support to inotify, that means that you can make inotify not only
report events happening to direct children of a directory, but events
happening to anything that is a descent of this directory. You just
have to specify an IN_TREE flag when doing inotify_add_watch().

Of course, I didn't code this without some userspace in mind. The
program will allow you to instantaneously synchronise your PC and
laptop, that means that you neither have to rsync manually when you
changed a file/got connected to your computer nor have to wait 15
minutes till rsync noticed what file has actually changed. It will be
on http://developer.berlios.de/projects/syncd/ although berlios still
has to accept my project registration.

Greetings,
Joris

Signed-off-by: Joris Dolderer <vorstadtkind@googlemail.com>
diff -Naur linux-2.6/fs/debugfs/inode.c newlin/fs/debugfs/inode.c
--- linux-2.6/fs/debugfs/inode.c 2010-02-05 01:26:57.519820333 +0100
+++ newlin/fs/debugfs/inode.c 2010-02-05 01:42:30.482914887 +0100
@@ -472,6 +472,7 @@
  int error;
  struct dentry *dentry = NULL, *trap;
  const char *old_name;
+ int old_len;

  trap = lock_rename(new_dir, old_dir);
  /* Source or destination directories don't exist? */
@@ -487,6 +488,7 @@
  goto exit;

  old_name = fsnotify_oldname_init(old_dentry->d_name.name);
+ old_len = old_dentry->d_name.len;

  error = simple_rename(old_dir->d_inode, old_dentry, new_dir->d_inode,
  dentry);
@@ -495,9 +497,9 @@
  goto exit;
  }
  d_move(old_dentry, dentry);
- fsnotify_move(old_dir->d_inode, new_dir->d_inode, old_name,
- old_dentry->d_name.name, S_ISDIR(old_dentry->d_inode->i_mode),
- NULL, old_dentry);
+ fsnotify_move(old_dir->d_inode, new_dir->d_inode, old_name, old_len,
+ old_dentry->d_name.name, old_dentry->d_name.len,
+ S_ISDIR(old_dentry->d_inode->i_mode), NULL, old_dentry);
  fsnotify_oldname_free(old_name);
  unlock_rename(new_dir, old_dir);
  dput(dentry);
diff -Naur linux-2.6/fs/namei.c newlin/fs/namei.c
--- linux-2.6/fs/namei.c 2010-02-05 01:26:57.607836369 +0100
+++ newlin/fs/namei.c 2010-02-05 01:42:30.485905840 +0100
@@ -2636,6 +2636,7 @@
  int error;
  int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
  const char *old_name;
+ int old_len;

  if (old_dentry->d_inode == new_dentry->d_inode)
   return 0;
@@ -2658,6 +2659,7 @@
  vfs_dq_init(new_dir);

  old_name = fsnotify_oldname_init(old_dentry->d_name.name);
+ old_len = old_dentry->d_name.len;

  if (is_dir)
  error = vfs_rename_dir(old_dir,old_dentry,new_dir,new_dentry);
@@ -2665,7 +2667,8 @@
  error = vfs_rename_other(old_dir,old_dentry,new_dir,new_dentry);
  if (!error) {
  const char *new_name = old_dentry->d_name.name;
- fsnotify_move(old_dir, new_dir, old_name, new_name, is_dir,
+ int new_len = old_dentry->d_name.len;
+ fsnotify_move(old_dir, new_dir, old_name, old_len, new_name, new_len, is_dir,
       new_dentry->d_inode, old_dentry);
  }
  fsnotify_oldname_free(old_name);
diff -Naur linux-2.6/fs/notify/dnotify/dnotify.c
newlin/fs/notify/dnotify/dnotify.c
--- linux-2.6/fs/notify/dnotify/dnotify.c 2010-02-05 01:26:57.637070470 +0100
+++ newlin/fs/notify/dnotify/dnotify.c 2010-02-05 01:42:30.485905840 +0100
@@ -71,7 +71,7 @@
  return;

  if (entry->inode)
- fsnotify_recalc_inode_mask(entry->inode);
+ fsnotify_recalc_inode_mask(entry->inode, false);
 }

 /*
@@ -91,7 +91,12 @@
  struct dnotify_struct *dn;
  struct dnotify_struct **prev;
  struct fown_struct *fown;
- __u32 test_mask = event->mask & ~FS_EVENT_ON_CHILD;
+ __u32 test_mask;
+
+ if (event->mask & FS_EVENT_ON_DESCENT)
+ return 0;
+
+ test_mask = event->mask & ~FS_EVENT_ON_CHILD;

  to_tell = event->to_tell;

diff -Naur linux-2.6/fs/notify/fsnotify.c newlin/fs/notify/fsnotify.c
--- linux-2.6/fs/notify/fsnotify.c 2010-02-05 01:26:57.637070470 +0100
+++ newlin/fs/notify/fsnotify.c 2010-02-05 01:53:07.430905375 +0100
@@ -76,55 +76,164 @@
  spin_unlock(&dcache_lock);
 }

-/* Notify this dentry's parent about a child's events. */
-void __fsnotify_parent(struct dentry *dentry, __u32 mask)
+/*
+ * Does the work when updating descents of a dentry
+ */
+static void fsnotify_update_descents(struct dentry *dentry, bool watched)
 {
- struct dentry *parent;
- struct inode *p_inode;
- bool send = false;
- bool should_update_children = false;
+ struct dentry *child;
+
+ list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
+ if (!child->d_inode)
+ continue;
+
+ spin_lock(&child->d_lock);
+
+ if (watched)
+ child->d_flags |= DCACHE_FSNOTIFY_ANCESTOR_WATCHED;
+ else
+ child->d_flags &= ~DCACHE_FSNOTIFY_ANCESTOR_WATCHED;
+
+ if (!fsnotify_inode_watches_descents(child->d_inode)) {
+ fsnotify_update_descents(child, watched);
+ }
+
+ spin_unlock(&child->d_lock);
+ }
+}

- if (!(dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED))
+/* do something equivalent to __fsnotify_update_child_dentry_flags,
but for a tree watch */
+void __fsnotify_update_descents(struct dentry *dentry, bool lock)
+{
+ bool should_be = fsnotify_inode_watches_descents(dentry->d_inode)
+ || (dentry->d_flags & DCACHE_FSNOTIFY_ANCESTOR_WATCHED);
+ bool is;
+
+ /* any child of this dentry */
+ struct dentry *onechild = list_entry(dentry->d_subdirs.next, struct
dentry, d_u.d_child);
+
+ if (onechild != dentry)
+ is = onechild->d_flags & DCACHE_FSNOTIFY_ANCESTOR_WATCHED;
+ else
+ return; /* no child dentries here */
+
+ if (should_be == is)
  return;
+
+ if (lock)
+ spin_lock(&dentry->d_lock);
+
+ fsnotify_update_descents(dentry, should_be);

- spin_lock(&dentry->d_lock);
- parent = dentry->d_parent;
- p_inode = parent->d_inode;
+ if (lock)
+ spin_unlock(&dentry->d_lock);
+}

- if (fsnotify_inode_watches_children(p_inode)) {
- if (p_inode->i_fsnotify_mask & mask) {
+/* Notify this dentry's ancestors about a child's events. */
+void __fsnotify_ancestors(struct dentry *dentry, __u32 mask)
+{
+ if (dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED) {
+ struct dentry *parent;
+ struct inode *p_inode;
+ bool should_update_children = false;
+ bool send = false;
+
+ spin_lock(&dentry->d_lock);
+
+ parent = dentry->d_parent;
+ p_inode = parent->d_inode;
+
+ if (fsnotify_inode_watches_children(p_inode)) {
+ if (p_inode->i_fsnotify_mask & mask) {
+ dget(parent);
+ send = true;
+ }
+ } else {
+ /*
+ * The parent doesn't care about events on it's children but
+ * at least one child thought it did.  We need to run all the
+ * children and update their d_flags to let them know p_inode
+ * doesn't care about them any more.
+ */
  dget(parent);
- send = true;
+ should_update_children = true;
  }
- } else {
- /*
- * The parent doesn't care about events on it's children but
- * at least one child thought it did.  We need to run all the
- * children and update their d_flags to let them know p_inode
- * doesn't care about them any more.
- */
- dget(parent);
- should_update_children = true;
- }

- spin_unlock(&dentry->d_lock);
+ spin_unlock(&dentry->d_lock);
+
+ if (send) {
+ /* we are notifying a parent so come up with the new mask which
+ * specifies these are events which came from a child. */
+ fsnotify(p_inode, mask | FS_EVENT_ON_TREE, dentry->d_inode,
+ FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
+ dput(parent);
+ }

- if (send) {
- /* we are notifying a parent so come up with the new mask which
- * specifies these are events which came from a child. */
- mask |= FS_EVENT_ON_CHILD;
-
- fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
- dentry->d_name.name, 0);
- dput(parent);
+ if (unlikely(should_update_children)) {
+ __fsnotify_update_child_dentry_flags(p_inode);
+ dput(parent);
+ }
  }

- if (unlikely(should_update_children)) {
- __fsnotify_update_child_dentry_flags(p_inode);
- dput(parent);
+ fsnotify_far_ancestors(dentry->d_parent, dentry->d_name.name,
dentry->d_name.len, mask);
+}
+EXPORT_SYMBOL_GPL(__fsnotify_ancestors);
+
+/*
+ * notify tree-watching ancestors
+ * @dentry: The dentry the walkup should start with
+ * @file_name: The string that should be appended to this dentries' path
+ * @file_len: The length of this string
+ */
+void fsnotify_far_ancestors(struct dentry *dentry, const unsigned
char *file_name, int file_len, __u32 mask)
+{
+ if (dentry->d_flags & DCACHE_FSNOTIFY_ANCESTOR_WATCHED) {
+ char path[PATH_MAX];
+ char *pathptr = path + PATH_MAX - 1 - file_len;
+ struct dentry *test_dentry, *next_update = NULL;
+ struct inode *d_inode, *test_inode;
+
+ strcpy(pathptr, file_name);
+
+ spin_lock(&dentry->d_lock);
+ d_inode = dentry->d_inode;
+
+ test_dentry = dentry;
+ test_inode = d_inode;
+ do {
+ dget(test_dentry);
+ if (fsnotify_inode_watches_descents(test_inode)) {
+ if (test_inode->i_fsnotify_mask & mask) {
+ dget(dentry);
+ spin_unlock(&dentry->d_lock);
+ inotify_inode_queue_event(test_inode, mask, 0, pathptr,
+  d_inode);
+ fsnotify(test_inode, mask | FS_EVENT_ON_DESCENT, d_inode,
+ FSNOTIFY_EVENT_INODE, pathptr, 0);
+ spin_lock(&dentry->d_lock);
+ dput(dentry);
+ }
+ } else {
+ next_update = test_dentry;
+ }
+
+ pathptr -= test_dentry->d_name.len + 1;
+ strcpy(pathptr, test_dentry->d_name.name);
+ pathptr[test_dentry->d_name.len] = '/';
+ dput(test_dentry);
+
+ test_dentry = test_dentry->d_parent;
+ test_inode = test_dentry->d_inode;
+ } while (test_dentry->d_flags & DCACHE_FSNOTIFY_ANCESTOR_WATCHED ||
+ fsnotify_inode_watches_descents(test_inode));
+
+ spin_unlock(&dentry->d_lock);
+
+ if (next_update)
+ __fsnotify_update_descents(next_update, true);
  }
 }
-EXPORT_SYMBOL_GPL(__fsnotify_parent);
+EXPORT_SYMBOL_GPL(fsnotify_far_ancestors);

 /*
  * This is the main call to fsnotify.  The VFS calls into hook
specific functions
@@ -137,8 +246,8 @@
  struct fsnotify_group *group;
  struct fsnotify_event *event = NULL;
  int idx;
- /* global tests shouldn't care about events on child only the
specific event */
- __u32 test_mask = (mask & ~FS_EVENT_ON_CHILD);
+ /* global tests shouldn't care about events on child/descent only
the specific event */
+ __u32 test_mask = mask & ~FS_EVENT_ON_TREE;

  if (list_empty(&fsnotify_groups))
  return;
@@ -155,8 +264,11 @@
  */
  idx = srcu_read_lock(&fsnotify_grp_srcu);
  list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
- if (test_mask & group->mask) {
- if (!group->ops->should_send_event(group, to_tell, mask))
+ bool send = test_mask & group->mask;
+ send = send && (!(mask & FS_EVENT_ON_TREE) ||
+ (mask & group->mask) & FS_EVENT_ON_TREE);
+ if (send) {
+ if (!group->ops->should_send_event(group, to_tell, mask))
  continue;
  if (!event) {
  event = fsnotify_create_event(to_tell, mask, data,
diff -Naur linux-2.6/fs/notify/fsnotify.h newlin/fs/notify/fsnotify.h
--- linux-2.6/fs/notify/fsnotify.h 2010-02-05 01:26:57.637070470 +0100
+++ newlin/fs/notify/fsnotify.h 2010-02-05 01:42:30.487905359 +0100
@@ -26,6 +26,7 @@
  * about events that happen to its children.
  */
 extern void __fsnotify_update_child_dentry_flags(struct inode *inode);
+/* same here for tree watches */

 /* allocate and destroy and event holder to attach events to
notification/access queues */
 extern struct fsnotify_event_holder *fsnotify_alloc_event_holder(void);
diff -Naur linux-2.6/fs/notify/inode_mark.c newlin/fs/notify/inode_mark.c
--- linux-2.6/fs/notify/inode_mark.c 2010-02-05 01:26:57.637070470 +0100
+++ newlin/fs/notify/inode_mark.c 2010-02-05 01:42:30.488905228 +0100
@@ -124,16 +124,31 @@
 }

 /*
+ * updates the descents as needed
+ */
+static void fsnotify_update_descents_as_needed(struct inode *inode,
bool recursive)
+{
+ if (recursive) {
+ struct dentry *dentry;
+ list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+ __fsnotify_update_descents(dentry, true);
+ }
+ } else {
+ __fsnotify_update_child_dentry_flags(inode);
+ }
+}
+
+/*
  * Recalculate the inode->i_fsnotify_mask, or the mask of all FS_* event types
  * any notifier is interested in hearing for this inode.
  */
-void fsnotify_recalc_inode_mask(struct inode *inode)
+void fsnotify_recalc_inode_mask(struct inode *inode, bool recursive)
 {
  spin_lock(&inode->i_lock);
  fsnotify_recalc_inode_mask_locked(inode);
  spin_unlock(&inode->i_lock);

- __fsnotify_update_child_dentry_flags(inode);
+ fsnotify_update_descents_as_needed(inode, recursive);
 }

 /*
@@ -180,6 +195,12 @@
  * inode->i_fsnotify_mask
  */
  fsnotify_recalc_inode_mask_locked(inode);
+ if ((entry->mask & ~inode->i_fsnotify_mask) & FS_EVENT_ON_DESCENT) {
+ struct dentry *dentry;
+ list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+ __fsnotify_update_descents(dentry, true);
+ }
+ }

  spin_unlock(&inode->i_lock);
  spin_unlock(&group->mark_lock);
@@ -195,14 +216,16 @@

  /*
  * __fsnotify_update_child_dentry_flags(inode);
+ * or __fsnotify_update_descents;
  *
  * I really want to call that, but we can't, we have no idea if the inode
  * still exists the second we drop the entry->lock.
  *
  * The next time an event arrive to this inode from one of it's children
- * __fsnotify_parent will see that the inode doesn't care about it's
- * children and will update all of these flags then.  So really this
- * is just a lazy update (and could be a perf win...)
+ * __fsnotify_ancestors resp. fsnotify_far_ancestors will see that the
+ * inode doesn't care about it's children and will update all of these
+ * flags then.  So really this is just a lazy update (and could be a
+ * perf win...)
  */


@@ -336,6 +359,17 @@

  atomic_inc(&group->num_marks);

+ if (entry->mask & FS_EVENT_ON_DESCENT) {
+ struct dentry *dentry;
+
+ /*
+ * as this is supposed to be a directory, this should only loop once
+ * but it actually doesn't matter if Mr. Evil gives a file as input
+ */
+ list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+ __fsnotify_update_dcache_flags(dentry);
+ }
+ }
  fsnotify_recalc_inode_mask_locked(inode);
  }

@@ -348,7 +382,7 @@
  iput(inode);
  fsnotify_put_mark(lentry);
  } else {
- __fsnotify_update_child_dentry_flags(inode);
+ fsnotify_update_descents_as_needed(inode, entry->mask & FS_EVENT_ON_DESCENT);
  }

  return ret;
diff -Naur linux-2.6/fs/notify/inotify/inotify_fsnotify.c
newlin/fs/notify/inotify/inotify_fsnotify.c
--- linux-2.6/fs/notify/inotify/inotify_fsnotify.c 2010-02-05
01:26:57.638007489 +0100
+++ newlin/fs/notify/inotify/inotify_fsnotify.c 2010-02-05
01:42:30.488905228 +0100
@@ -89,6 +89,7 @@
 {
  struct fsnotify_mark_entry *entry;
  bool send;
+ __u32 test_mask;

  spin_lock(&inode->i_lock);
  entry = fsnotify_find_mark_entry(group, inode);
@@ -96,8 +97,9 @@
  if (!entry)
  return false;

- mask = (mask & ~FS_EVENT_ON_CHILD);
- send = (entry->mask & mask);
+ test_mask = mask & ~FS_EVENT_ON_TREE;
+ send = entry->mask & test_mask;
+ send = send && ((mask & FS_EVENT_ON_TREE) ? ((entry->mask & mask) &
FS_EVENT_ON_TREE) : true);

  /* find took a reference */
  fsnotify_put_mark(entry);
diff -Naur linux-2.6/fs/notify/inotify/inotify_user.c
newlin/fs/notify/inotify/inotify_user.c
--- linux-2.6/fs/notify/inotify/inotify_user.c 2010-02-05
01:26:57.638007489 +0100
+++ newlin/fs/notify/inotify/inotify_user.c 2010-02-05 01:42:30.489905383 +0100
@@ -11,6 +11,8 @@
  * Copyright (C) 2009 Eric Paris <Red Hat Inc>
  * inotify was largely rewriten to make use of the fsnotify infrastructure
  *
+ * Tree-watching support (C) 2010 Joris Dolderer <vorstadtkind@googlemail.com>
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2, or (at your option) any
@@ -100,12 +102,15 @@
 {
  __u32 mask;

- /* everything should accept their own ignored and cares about children */
- mask = (FS_IN_IGNORED | FS_EVENT_ON_CHILD);
+ /* everything should accept their own ignored*/
+ mask = FS_IN_IGNORED;

  /* mask off the flags used to open the fd */
  mask |= (arg & (IN_ALL_EVENTS | IN_ONESHOT));

+ /* care about children or descents */
+ mask |= (arg & IN_TREE) ? FS_EVENT_ON_DESCENT : FS_EVENT_ON_CHILD;
+
  return mask;
 }

@@ -504,8 +509,8 @@
  int do_group = (new_mask & ~group->mask);

  /* update the inode with this new entry */
- if (dropped || do_inode)
- fsnotify_recalc_inode_mask(inode);
+ if (dropped || do_inode)
+ fsnotify_recalc_inode_mask(inode, (old_mask ^ new_mask) & IN_TREE);

  /* update the group mask with the new mask */
  if (dropped || do_group)
diff -Naur linux-2.6/include/linux/dcache.h newlin/include/linux/dcache.h
--- linux-2.6/include/linux/dcache.h 2010-02-05 01:26:57.734070416 +0100
+++ newlin/include/linux/dcache.h 2010-02-05 01:42:30.490905613 +0100
@@ -184,7 +184,8 @@

 #define DCACHE_COOKIE 0x0040 /* For use by dcookie subsystem */

-#define DCACHE_FSNOTIFY_PARENT_WATCHED 0x0080 /* Parent inode is
watched by some fsnotify listener */
+#define DCACHE_FSNOTIFY_PARENT_WATCHED 0x0080 /* Parent inode is
watched by some fsnotify listener */
+#define DCACHE_FSNOTIFY_ANCESTOR_WATCHED 0x0100 /* Ancestor inode is
watched by some tree-watching fsnotify listener */

 extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
diff -Naur linux-2.6/include/linux/fsnotify_backend.h
newlin/include/linux/fsnotify_backend.h
--- linux-2.6/include/linux/fsnotify_backend.h 2010-02-05
01:26:57.742071324 +0100
+++ newlin/include/linux/fsnotify_backend.h 2010-02-05 01:52:12.637914745 +0100
@@ -48,8 +48,12 @@
 #define FS_DN_MULTISHOT 0x20000000 /* dnotify multishot */

 /* This inode cares about things that happen to its children.  Always set for
- * dnotify and inotify. */
+ * dnotify. */
 #define FS_EVENT_ON_CHILD 0x08000000
+/* This inode cares about things that happen to some of its descents. */
+#define FS_EVENT_ON_DESCENT 0x10000000
+
+#define FS_EVENT_ON_TREE (FS_EVENT_ON_CHILD|FS_EVENT_ON_DESCENT)

 /* This is a list of all events that may get sent to a parernt based
on fs event
  * happening to inodes inside that directory */
@@ -254,20 +258,32 @@
 /* main fsnotify call to send events */
 extern void fsnotify(struct inode *to_tell, __u32 mask, void *data,
int data_is,
      const char *name, u32 cookie);
-extern void __fsnotify_parent(struct dentry *dentry, __u32 mask);
+extern void __fsnotify_ancestors(struct dentry *dentry, __u32 mask);
+extern void fsnotify_far_ancestors(struct dentry *dentry, const
unsigned char *file_name, int file_len, __u32 mask);
 extern void __fsnotify_inode_delete(struct inode *inode);
+extern void __fsnotify_update_descents(struct dentry *dentry, bool lock);
 extern u32 fsnotify_get_cookie(void);

-static inline int fsnotify_inode_watches_children(struct inode *inode)
+static inline bool fsnotify_inode_watches_something(struct inode
*inode, u32 what)
 {
- /* FS_EVENT_ON_CHILD is set if the inode may care */
- if (!(inode->i_fsnotify_mask & FS_EVENT_ON_CHILD))
+ /* what is set if the inode may care */
+ if (!(inode->i_fsnotify_mask & what))
  return 0;
  /* this inode might care about child events, does it care about the
  * specific set of events that can happen on a child? */
  return inode->i_fsnotify_mask & FS_EVENTS_POSS_ON_CHILD;
 }

+static inline bool fsnotify_inode_watches_children(struct inode *inode)
+{
+ return fsnotify_inode_watches_something(inode, FS_EVENT_ON_CHILD);
+}
+
+static inline bool fsnotify_inode_watches_descents(struct inode *inode)
+{
+ return fsnotify_inode_watches_something(inode, FS_EVENT_ON_DESCENT);
+}
+
 /*
  * Update the dentry with a flag indicating the interest of its
parent to receive
  * filesystem events when those events happens to this dentry->d_inode.
@@ -275,15 +291,22 @@
 static inline void __fsnotify_update_dcache_flags(struct dentry *dentry)
 {
  struct dentry *parent;
-
- assert_spin_locked(&dcache_lock);
- assert_spin_locked(&dentry->d_lock);
+ struct inode *p_inode;

  parent = dentry->d_parent;
- if (parent->d_inode && fsnotify_inode_watches_children(parent->d_inode))
- dentry->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
- else
- dentry->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
+ p_inode = parent->d_inode;
+
+ if (p_inode) {
+ if (fsnotify_inode_watches_descents(p_inode) || (parent->d_flags &
DCACHE_FSNOTIFY_ANCESTOR_WATCHED))
+ dentry->d_flags |= DCACHE_FSNOTIFY_ANCESTOR_WATCHED;
+ else
+ dentry->d_flags &= ~DCACHE_FSNOTIFY_ANCESTOR_WATCHED;
+
+ if (fsnotify_inode_watches_children(p_inode))
+ dentry->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
+ else
+ dentry->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
+ }
 }

 /*
@@ -335,7 +358,7 @@
 /* functions used to manipulate the marks attached to inodes */

 /* run all marks associated with an inode and update inode->i_fsnotify_mask */
-extern void fsnotify_recalc_inode_mask(struct inode *inode);
+extern void fsnotify_recalc_inode_mask(struct inode *inode, bool recursive);
 extern void fsnotify_init_mark(struct fsnotify_mark_entry *entry,
void (*free_mark)(struct fsnotify_mark_entry *entry));
 /* find (and take a reference) to a mark associated with group and inode */
 extern struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct
fsnotify_group *group, struct inode *inode);
@@ -360,7 +383,7 @@
     const char *name, u32 cookie)
 {}

-static inline void __fsnotify_parent(struct dentry *dentry, __u32 mask)
+static inline void __fsnotify_ancestors(struct dentry *dentry, __u32 mask)
 {}

 static inline void __fsnotify_inode_delete(struct inode *inode)
diff -Naur linux-2.6/include/linux/fsnotify.h newlin/include/linux/fsnotify.h
--- linux-2.6/include/linux/fsnotify.h 2010-02-05 01:26:57.742071324 +0100
+++ newlin/include/linux/fsnotify.h 2010-02-05 01:42:30.492904604 +0100
@@ -16,6 +16,14 @@
 #include <linux/fsnotify_backend.h>
 #include <linux/audit.h>

+/* Wrapper for fsnotify_far_ancestors, getting the dentries' name */
+static inline void fsnotify_far_ancestors_getinfo(struct dentry
*dentry, __u32 mask)
+{
+ const char *name = dentry->d_name.name;
+ const int len = dentry->d_name.len;
+ fsnotify_far_ancestors(dentry->d_parent, name, len, mask);
+}
+
 /*
  * fsnotify_d_instantiate - instantiate a dentry for inode
  * Called with dcache_lock held.
@@ -28,10 +36,10 @@
  inotify_d_instantiate(entry, inode);
 }

-/* Notify this dentry's parent about a child's events. */
-static inline void fsnotify_parent(struct dentry *dentry, __u32 mask)
+/* Notify this dentry's ancestors about a child's events. */
+static inline void fsnotify_ancestors(struct dentry *dentry, __u32 mask)
 {
- __fsnotify_parent(dentry, mask);
+ __fsnotify_ancestors(dentry, mask);

  inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 }
@@ -46,7 +54,8 @@
  * On move we need to update entry->d_flags to indicate if the new parent
  * cares about events from this entry.
  */
- __fsnotify_update_dcache_flags(entry);
+ __fsnotify_update_dcache_flags(entry);
+ __fsnotify_update_descents(entry, false);

  inotify_d_move(entry);
 }
@@ -65,14 +74,16 @@
  * fsnotify_move - file old_name at old_dir was moved to new_name at new_dir
  */
 static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
- const char *old_name, const char *new_name,
+ const char *old_name, int old_len,
+ const char *new_name, int new_len,
  int isdir, struct inode *target, struct dentry *moved)
 {
+ struct dentry *alias;
  struct inode *source = moved->d_inode;
  u32 in_cookie = inotify_get_cookie();
  u32 fs_cookie = fsnotify_get_cookie();
- __u32 old_dir_mask = (FS_EVENT_ON_CHILD | FS_MOVED_FROM);
- __u32 new_dir_mask = (FS_EVENT_ON_CHILD | FS_MOVED_TO);
+ __u32 old_dir_mask = FS_EVENT_ON_TREE | FS_MOVED_FROM;
+ __u32 new_dir_mask = FS_EVENT_ON_TREE | FS_MOVED_TO;

  if (old_dir == new_dir)
  old_dir_mask |= FS_DN_RENAME;
@@ -88,6 +99,14 @@
  inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, in_cookie, new_name,
   source);

+ list_for_each_entry(alias, &new_dir->i_dentry, d_alias) {
+ fsnotify_far_ancestors(alias, new_name, new_len, new_dir_mask);
+ }
+
+ list_for_each_entry(alias, &old_dir->i_dentry, d_alias) {
+ fsnotify_far_ancestors(alias, old_name, old_len, old_dir_mask);
+ }
+
  fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE,
old_name, fs_cookie);
  fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE,
new_name, fs_cookie);

@@ -124,7 +143,7 @@
  if (isdir)
  mask |= FS_IN_ISDIR;

- fsnotify_parent(dentry, mask);
+ fsnotify_ancestors(dentry, mask);
 }

 /*
@@ -148,6 +167,7 @@
   dentry->d_inode);
  audit_inode_child(dentry->d_name.name, dentry, inode);

+ fsnotify_far_ancestors_getinfo(dentry, FS_CREATE);
  fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE,
dentry->d_name.name, 0);
 }

@@ -158,12 +178,13 @@
  */
 static inline void fsnotify_link(struct inode *dir, struct inode
*inode, struct dentry *new_dentry)
 {
+ fsnotify_far_ancestors_getinfo(new_dentry, IN_CREATE);
+ fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE,
new_dentry->d_name.name, 0);
+
  inotify_inode_queue_event(dir, IN_CREATE, 0, new_dentry->d_name.name,
   inode);
  fsnotify_link_count(inode);
  audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
-
- fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE,
new_dentry->d_name.name, 0);
 }

 /*
@@ -177,6 +198,7 @@
  inotify_inode_queue_event(inode, mask, 0, dentry->d_name.name, d_inode);
  audit_inode_child(dentry->d_name.name, dentry, inode);

+ fsnotify_far_ancestors_getinfo(dentry, mask);
  fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }

@@ -193,10 +215,10 @@

  inotify_inode_queue_event(inode, mask, 0, NULL, NULL);

- fsnotify_parent(dentry, mask);
+ fsnotify_ancestors(dentry, mask);
  fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 /*
  * fsnotify_modify - file was modified
  */
@@ -210,7 +232,7 @@

  inotify_inode_queue_event(inode, mask, 0, NULL, NULL);

- fsnotify_parent(dentry, mask);
+ fsnotify_ancestors(dentry, mask);
  fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }

@@ -227,7 +249,7 @@

  inotify_inode_queue_event(inode, mask, 0, NULL, NULL);

- fsnotify_parent(dentry, mask);
+ fsnotify_ancestors(dentry, mask);
  fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }

@@ -246,7 +268,7 @@

  inotify_inode_queue_event(inode, mask, 0, NULL, NULL);

- fsnotify_parent(dentry, mask);
+ fsnotify_ancestors(dentry, mask);
  fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }

@@ -263,7 +285,7 @@

  inotify_inode_queue_event(inode, mask, 0, NULL, NULL);

- fsnotify_parent(dentry, mask);
+ fsnotify_ancestors(dentry, mask);
  fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }

@@ -299,7 +321,7 @@
  mask |= FS_IN_ISDIR;
  inotify_inode_queue_event(inode, mask, 0, NULL, NULL);

- fsnotify_parent(dentry, mask);
+ fsnotify_ancestors(dentry, mask);
  fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
  }
 }
diff -Naur linux-2.6/include/linux/inotify.h newlin/include/linux/inotify.h
--- linux-2.6/include/linux/inotify.h 2010-02-05 01:26:57.750070268 +0100
+++ newlin/include/linux/inotify.h 2010-02-05 01:42:30.493905562 +0100
@@ -49,12 +49,12 @@
 #define IN_MOVE (IN_MOVED_FROM | IN_MOVED_TO) /* moves */

 /* special flags */
+#define IN_TREE 0x00800000 /* watch the whole directory tree */
 #define IN_ONLYDIR 0x01000000 /* only watch the path if it is a directory */
 #define IN_DONT_FOLLOW 0x02000000 /* don't follow a sym link */
 #define IN_MASK_ADD 0x20000000 /* add to the mask of an already
existing watch */
 #define IN_ISDIR 0x40000000 /* event occurred against dir */
 #define IN_ONESHOT 0x80000000 /* only send event once */
-
 /*
  * All of the events - we build the list by hand so that we can add flags in
  * the future and not break backward compatibility.  Apps will get only the
