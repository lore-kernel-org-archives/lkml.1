Return-Path: <linux-kernel-owner+w=401wt.eu-S1760591AbZCSSLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591AbZCSSLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbZCSSHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:07:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46035 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759271AbZCSSHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:07:42 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 13/13] inotify: reimplement inotify using fsnotify
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Thu, 19 Mar 2009 14:06:04 -0400
Message-ID: <20090319180604.17449.60430.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplement inotify_user using fsnotify.  This should be feature for feature
exactly the same as the original inotify_user.  This does not make any changes
to the in kernel inotify feature used by audit.  Those patches (and the eventual
removal of in kernel inotify) will come after the new inotify_user proves to be
working correctly.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 MAINTAINERS                          |    2 
 fs/notify/fsnotify.h                 |    1 
 fs/notify/inotify/Kconfig            |   20 +
 fs/notify/inotify/Makefile           |    2 
 fs/notify/inotify/inotify.h          |  107 ++++++
 fs/notify/inotify/inotify_fsnotify.c |  146 +++++++++
 fs/notify/inotify/inotify_kernel.c   |  273 ++++++++++++++++
 fs/notify/inotify/inotify_user.c     |  584 ++++++++--------------------------
 fs/notify/notification.c             |   28 +-
 include/linux/fsnotify.h             |    3 
 include/linux/fsnotify_backend.h     |   12 +
 11 files changed, 717 insertions(+), 461 deletions(-)
 create mode 100644 fs/notify/inotify/inotify.h
 create mode 100644 fs/notify/inotify/inotify_fsnotify.c
 create mode 100644 fs/notify/inotify/inotify_kernel.c

diff --git a/MAINTAINERS b/MAINTAINERS
index df74947..64ed6dc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2252,6 +2252,8 @@ P:	John McCutchan
 M:	john@johnmccutchan.com
 P:	Robert Love
 M:	rlove@rlove.org
+P:	Eric Paris
+M:	eparis@parisplace.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 06585db..2ba83e4 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -17,7 +17,6 @@ extern __u32 fsnotify_mask;
 
 extern void fsnotify_flush_notif(struct fsnotify_group *group);
 
-extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_clear_marks_by_inode(struct inode *inode);
 
 extern struct fsnotify_event_holder *fsnotify_alloc_event_holder(void);
diff --git a/fs/notify/inotify/Kconfig b/fs/notify/inotify/Kconfig
index 4467928..5356884 100644
--- a/fs/notify/inotify/Kconfig
+++ b/fs/notify/inotify/Kconfig
@@ -1,26 +1,30 @@
 config INOTIFY
 	bool "Inotify file change notification support"
-	default y
+	default n
 	---help---
-	  Say Y here to enable inotify support.  Inotify is a file change
-	  notification system and a replacement for dnotify.  Inotify fixes
-	  numerous shortcomings in dnotify and introduces several new features
-	  including multiple file events, one-shot support, and unmount
-	  notification.
+	  Say Y here to enable legacy in kernel inotify support.  Inotify is a
+	  file change notification system.  It is a replacement for dnotify.
+	  This option only provides the legacy inotify in kernel API.  There
+	  are no in tree kernel users of this interface since it is deprecated.
+	  You only need this if you are loading an out of tree kernel module
+	  that uses inotify.
 
 	  For more information, see <file:Documentation/filesystems/inotify.txt>
 
-	  If unsure, say Y.
+	  If unsure, say N.
 
 config INOTIFY_USER
 	bool "Inotify support for userspace"
-	depends on INOTIFY
+	depends on FSNOTIFY
 	default y
 	---help---
 	  Say Y here to enable inotify support for userspace, including the
 	  associated system calls.  Inotify allows monitoring of both files and
 	  directories via a single open fd.  Events are read from the file
 	  descriptor, which is also select()- and poll()-able.
+	  Inotify fixes numerous shortcomings in dnotify and introduces several
+	  new features including multiple file events, one-shot support, and
+	  unmount notification.
 
 	  For more information, see <file:Documentation/filesystems/inotify.txt>
 
diff --git a/fs/notify/inotify/Makefile b/fs/notify/inotify/Makefile
index e290f3b..aff7f68 100644
--- a/fs/notify/inotify/Makefile
+++ b/fs/notify/inotify/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_INOTIFY)		+= inotify.o
-obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
+obj-$(CONFIG_INOTIFY_USER)	+= inotify_fsnotify.o inotify_kernel.o inotify_user.o
diff --git a/fs/notify/inotify/inotify.h b/fs/notify/inotify/inotify.h
new file mode 100644
index 0000000..04922de
--- /dev/null
+++ b/fs/notify/inotify/inotify.h
@@ -0,0 +1,107 @@
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
+#include <linux/fsnotify_backend.h>
+#include <linux/limits.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/inotify.h>
+#include <linux/syscalls.h>
+#include <linux/string.h>
+#include <linux/magic.h>
+#include <linux/writeback.h>
+#include <linux/fsnotify.h>
+
+#include <asm/ioctls.h>
+
+extern struct kmem_cache *event_priv_cachep;
+extern int inotify_max_user_watches;
+
+struct inotify_event_private_data {
+	struct fsnotify_event_private_data fsnotify_event_priv_data;
+	int wd;
+};
+
+struct inotify_inode_mark_entry {
+	/* fsnotify_mark_entry MUST be the first thing */
+	struct fsnotify_mark_entry fsn_entry;
+	int wd;
+};
+
+static inline __u32 inotify_arg_to_mask(u32 arg)
+{
+	__u32 mask;
+
+	/* FS_* damn sure better equal IN_* */
+	BUILD_BUG_ON(IN_ACCESS != FS_ACCESS);
+	BUILD_BUG_ON(IN_MODIFY != FS_MODIFY);
+	BUILD_BUG_ON(IN_ATTRIB != FS_ATTRIB);
+	BUILD_BUG_ON(IN_CLOSE_WRITE != FS_CLOSE_WRITE);
+	BUILD_BUG_ON(IN_CLOSE_NOWRITE != FS_CLOSE_NOWRITE);
+	BUILD_BUG_ON(IN_OPEN != FS_OPEN);
+	BUILD_BUG_ON(IN_MOVED_FROM != FS_MOVED_FROM);
+	BUILD_BUG_ON(IN_MOVED_TO != FS_MOVED_TO);
+	BUILD_BUG_ON(IN_CREATE != FS_CREATE);
+	BUILD_BUG_ON(IN_DELETE != FS_DELETE);
+	BUILD_BUG_ON(IN_DELETE_SELF != FS_DELETE_SELF);
+	BUILD_BUG_ON(IN_MOVE_SELF != FS_MOVE_SELF);
+	BUILD_BUG_ON(IN_Q_OVERFLOW != FS_Q_OVERFLOW);
+
+	BUILD_BUG_ON(IN_UNMOUNT != FS_UNMOUNT);
+	BUILD_BUG_ON(IN_ISDIR != FS_IN_ISDIR);
+	BUILD_BUG_ON(IN_IGNORED != FS_IN_IGNORED);
+	BUILD_BUG_ON(IN_ONESHOT != FS_IN_ONESHOT);
+
+	/* everything should accept their own ignored and cares about children */
+	mask = (FS_IN_IGNORED | FS_EVENT_ON_CHILD);
+
+	/* mask off the flags used to open the fd */
+	mask |= (arg & (IN_ALL_EVENTS | IN_ONESHOT));
+
+	return mask;
+}
+
+static inline u32 inotify_mask_to_arg(__u32 mask)
+{
+	u32 arg;
+
+	arg = (mask & (IN_ALL_EVENTS | IN_ISDIR | IN_UNMOUNT | IN_IGNORED | IN_Q_OVERFLOW));
+
+	return arg;
+}
+
+
+extern int find_inode(const char __user *dirname, struct path *path, unsigned flags);
+extern void inotify_destroy_mark_entry(struct fsnotify_mark_entry *entry, struct fsnotify_group *group);
+extern int inotify_update_watch(struct fsnotify_group *group, struct inode *inode, u32 arg);
+extern struct fsnotify_group *inotify_new_group(struct user_struct *user, unsigned int max_events);
+extern void __inotify_free_event_priv(struct inotify_event_private_data *event_priv);
+
+extern const struct fsnotify_ops inotify_fsnotify_ops;
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
new file mode 100644
index 0000000..d71ee80
--- /dev/null
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -0,0 +1,146 @@
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
+ * Copyright (C) 2009 Eric Paris <Red Hat Inc>
+ * inotify was largely rewriten to make use of the fsnotify infrastructure
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
+#include <linux/limits.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/inotify.h>
+#include <linux/list.h>
+#include <linux/syscalls.h>
+#include <linux/string.h>
+#include <linux/magic.h>
+#include <linux/writeback.h>
+
+#include "inotify.h"
+
+#include <asm/ioctls.h>
+
+static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_event *event)
+{
+	struct fsnotify_mark_entry *entry;
+	struct inotify_inode_mark_entry *ientry;
+	struct inode *to_tell;
+	struct inotify_event_private_data *event_priv;
+	int wd;
+
+	to_tell = event->to_tell;
+
+	spin_lock(&to_tell->i_lock);
+	entry = fsnotify_find_mark_entry(group, to_tell);
+	spin_unlock(&to_tell->i_lock);
+	/* race with watch removal? */
+	if (!entry)
+		return 0;
+	ientry = (struct inotify_inode_mark_entry *)entry;
+
+	wd = ientry->wd;
+
+	fsnotify_put_mark(entry);
+
+	event_priv = kmem_cache_alloc(event_priv_cachep, GFP_KERNEL);
+	if (unlikely(!event_priv))
+		return -ENOMEM;
+
+	event_priv->fsnotify_event_priv_data.group = group;
+	event_priv->wd = wd;
+
+	return fsnotify_add_notif_event(group, event, (struct fsnotify_event_private_data *)event_priv);
+}
+
+static void inotify_freeing_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group)
+{
+	inotify_destroy_mark_entry(entry, group);
+}
+
+static int inotify_should_send_event(struct fsnotify_group *group, struct inode *inode, __u32 mask)
+{
+	struct fsnotify_mark_entry *entry;
+	int send;
+
+	spin_lock(&inode->i_lock);
+	entry = fsnotify_find_mark_entry(group, inode);
+	spin_unlock(&inode->i_lock);
+	if (!entry)
+		return 0;
+
+	spin_lock(&entry->lock);
+	send = !!(entry->mask & mask);
+	spin_unlock(&entry->lock);
+
+	/* find took a reference */
+	fsnotify_put_mark(entry);
+
+	return send;
+}
+
+static int idr_callback(int id, void *p, void *data)
+{
+	BUG();
+	return 0;
+}
+
+static void inotify_free_group_priv(struct fsnotify_group *group)
+{
+	/* ideally the idr is empty and we won't hit the BUG in teh callback */
+	idr_for_each(&group->inotify_data.idr, idr_callback, NULL);
+	idr_remove_all(&group->inotify_data.idr);
+	idr_destroy(&group->inotify_data.idr);
+}
+
+void __inotify_free_event_priv(struct inotify_event_private_data *event_priv)
+{
+	list_del_init(&event_priv->fsnotify_event_priv_data.event_list);
+	kmem_cache_free(event_priv_cachep, event_priv);
+}
+
+static void inotify_free_event_priv(struct fsnotify_group *group, struct fsnotify_event *event)
+{
+	struct inotify_event_private_data *event_priv;
+
+	spin_lock(&event->lock);
+
+	event_priv = (struct inotify_event_private_data *)fsnotify_get_priv_from_event(group, event);
+	BUG_ON(!event_priv);
+
+	__inotify_free_event_priv(event_priv);
+
+	spin_unlock(&event->lock);
+}
+
+const struct fsnotify_ops inotify_fsnotify_ops = {
+	.handle_event = inotify_handle_event,
+	.should_send_event = inotify_should_send_event,
+	.free_group_priv = inotify_free_group_priv,
+	.free_event_priv = inotify_free_event_priv,
+	.freeing_mark = inotify_freeing_mark,
+};
diff --git a/fs/notify/inotify/inotify_kernel.c b/fs/notify/inotify/inotify_kernel.c
new file mode 100644
index 0000000..1bd8323
--- /dev/null
+++ b/fs/notify/inotify/inotify_kernel.c
@@ -0,0 +1,273 @@
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
+ * Copyright (C) 2009 Eric Paris <Red Hat Inc>
+ * inotify was largely rewriten to make use of the fsnotify infrastructure
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
+#include <linux/limits.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/inotify.h>
+#include <linux/list.h>
+#include <linux/syscalls.h>
+#include <linux/string.h>
+#include <linux/magic.h>
+#include <linux/writeback.h>
+
+#include "inotify.h"
+
+#include <asm/ioctls.h>
+
+static struct kmem_cache *inotify_inode_mark_cachep __read_mostly;
+struct kmem_cache *event_priv_cachep __read_mostly;
+static struct fsnotify_event *inotify_ignored_event;
+
+atomic_t inotify_grp_num;
+
+/*
+ * find_inode - resolve a user-given path to a specific inode
+ */
+int find_inode(const char __user *dirname, struct path *path, unsigned flags)
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
+ * When, for whatever reason, inotify is done with a mark (or what used to be a
+ * watch) we need to remove that watch from the idr and we need to send IN_IGNORED
+ * for the given wd.
+ *
+ * There is a bit of recursion here.  The loop looks like:
+ * 	inotify_destroy_mark_entry -> fsnotify_destroy_mark_by_entry ->
+ *	inotify_freeing_mark -> inotify_destory_mark_entry -> restart
+ * But the loop is broken in 2 places.  fsnotify_destroy_mark_by_entry sets
+ * entry->group = NULL before the call to inotify_freeing_mark, so the if (egroup)
+ * test below will not call back to fsnotify again.  But even if that test wasn't
+ * there this would still be safe since fsnotify_destroy_mark_by_entry() is
+ * safe from recursion.
+ */
+void inotify_destroy_mark_entry(struct fsnotify_mark_entry *entry, struct fsnotify_group *group)
+{
+	struct inotify_inode_mark_entry *ientry;
+	struct inotify_event_private_data *event_priv;
+	struct fsnotify_group *egroup;
+	struct idr *idr;
+
+	spin_lock(&entry->lock);
+	egroup = entry->group;
+
+	/* if egroup we aren't really done and something might still send events
+	 * for this inode, on the callback we'll send the IN_IGNORED */
+	if (egroup) {
+		spin_unlock(&entry->lock);
+		fsnotify_destroy_mark_by_entry(entry);
+		return;
+	}
+	spin_unlock(&entry->lock);
+
+	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
+
+	event_priv = kmem_cache_alloc(event_priv_cachep, GFP_KERNEL);
+	if (unlikely(!event_priv))
+		goto skip_send_ignore;
+
+	event_priv->fsnotify_event_priv_data.group = group;
+	event_priv->wd = ientry->wd;
+
+	fsnotify_add_notif_event(group, inotify_ignored_event, &event_priv->fsnotify_event_priv_data);
+
+skip_send_ignore:
+
+	/* remove this entry from the idr */
+	spin_lock(&group->inotify_data.idr_lock);
+	idr = &group->inotify_data.idr;
+	idr_remove(idr, ientry->wd);
+	spin_unlock(&group->inotify_data.idr_lock);
+
+	/* removed from idr, drop that reference */
+	fsnotify_put_mark(entry);
+}
+
+/* ding dong the mark is dead */
+static void inotify_free_mark(struct fsnotify_mark_entry *entry)
+{
+	struct inotify_inode_mark_entry *ientry = (struct inotify_inode_mark_entry *)entry;
+
+	kmem_cache_free(inotify_inode_mark_cachep, ientry);
+}
+
+int inotify_update_watch(struct fsnotify_group *group, struct inode *inode, u32 arg)
+{
+	struct fsnotify_mark_entry *entry = NULL;
+	struct inotify_inode_mark_entry *ientry;
+	int ret = 0;
+	int add = (arg & IN_MASK_ADD);
+	__u32 mask;
+	__u32 old_mask, new_mask;
+
+	/* don't allow invalid bits: we don't want flags set */
+	mask = inotify_arg_to_mask(arg);
+	if (unlikely(!mask))
+		return -EINVAL;
+
+	ientry = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
+	if (unlikely(!ientry))
+		return -ENOMEM;
+	/* we set the mask at the end after attaching it */
+	fsnotify_init_mark(&ientry->fsn_entry, inotify_free_mark);
+	ientry->wd = 0;
+
+find_entry:
+	spin_lock(&inode->i_lock);
+	entry = fsnotify_find_mark_entry(group, inode);
+	spin_unlock(&inode->i_lock);
+	if (entry) {
+		kmem_cache_free(inotify_inode_mark_cachep, ientry);
+		ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
+	} else {
+		if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches) {
+			ret = -ENOSPC;
+			goto out_err;
+		}
+
+		ret = fsnotify_add_mark(&ientry->fsn_entry, group, inode);
+		if (ret == -EEXIST)
+			goto find_entry;
+		else if (ret)
+			goto out_err;
+
+		entry = &ientry->fsn_entry;
+retry:
+		ret = -ENOMEM;
+		if (unlikely(!idr_pre_get(&group->inotify_data.idr, GFP_KERNEL)))
+			goto out_err;
+
+		spin_lock(&group->inotify_data.idr_lock);
+		/* if entry is added to the idr we keep the reference obtained
+		 * through fsnotify_mark_add.  remember to drop this reference
+		 * when entry is removed from idr */
+		ret = idr_get_new_above(&group->inotify_data.idr, entry,
+					++group->inotify_data.last_wd,
+					&ientry->wd);
+		spin_unlock(&group->inotify_data.idr_lock);
+		if (ret) {
+			if (ret == -EAGAIN)
+				goto retry;
+			goto out_err;
+		}
+		atomic_inc(&group->inotify_data.user->inotify_watches);
+	}
+
+	spin_lock(&entry->lock);
+
+	old_mask = entry->mask;
+	if (add) {
+		entry->mask |= mask;
+		new_mask = entry->mask;
+	} else {
+		entry->mask = mask;
+		new_mask = entry->mask;
+	}
+
+	spin_unlock(&entry->lock);
+
+	if (old_mask != new_mask) {
+		/* more bits in old than in new? */
+		int dropped = (old_mask & ~new_mask);
+		/* more bits in this entry than the inode's mask? */
+		int do_inode = (new_mask & ~inode->i_fsnotify_mask);
+		/* more bits in this entry than the group? */
+		int do_group = (new_mask & ~group->mask);
+
+		/* update the inode with this new entry */
+		if (dropped || do_inode)
+			fsnotify_recalc_inode_mask(inode);
+
+		/* update the group mask with the new mask */
+		if (dropped || do_group)
+			fsnotify_recalc_group_mask(group);
+	}
+
+	return ientry->wd;
+
+out_err:
+	/* see this isn't supposed to happen, just kill the watch */
+	if (entry) {
+		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_put_mark(entry);
+	}
+	return ret;
+}
+
+struct fsnotify_group *inotify_new_group(struct user_struct *user, unsigned int max_events)
+{
+	struct fsnotify_group *group;
+	unsigned int grp_num;
+
+	/* fsnotify_obtain_group took a reference to group, we put this when we kill the file in the end */
+	grp_num = (INOTIFY_GROUP_NUM - atomic_inc_return(&inotify_grp_num));
+	group = fsnotify_obtain_group(grp_num, grp_num, 0, &inotify_fsnotify_ops);
+	if (IS_ERR(group))
+		return group;
+
+	group->max_events = max_events;
+
+	spin_lock_init(&group->inotify_data.idr_lock);
+	idr_init(&group->inotify_data.idr);
+	group->inotify_data.last_wd = 0;
+	group->inotify_data.user = user;
+	group->inotify_data.fa = NULL;
+
+	return group;
+}
+
+static int __init inotify_kernel_setup(void)
+{
+	inotify_inode_mark_cachep = kmem_cache_create("inotify_mark_entry",
+					sizeof(struct inotify_inode_mark_entry),
+					0, SLAB_PANIC, NULL);
+	event_priv_cachep = kmem_cache_create("inotify_event_priv_cache",
+					sizeof(struct inotify_event_private_data),
+					0, SLAB_PANIC, NULL);
+	inotify_ignored_event = fsnotify_create_event(NULL, FS_IN_IGNORED, NULL, FSNOTIFY_EVENT_INODE, NULL, 0);
+	if (!inotify_ignored_event)
+		panic("unable to allocate the inotify ignored event\n");
+	return 0;
+}
+subsys_initcall(inotify_kernel_setup);
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index bed766e..906c03f 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -8,6 +8,9 @@
  * Copyright (C) 2005 John McCutchan
  * Copyright 2006 Hewlett-Packard Development Company, L.P.
  *
+ * Copyright (C) 2009 Eric Paris <Red Hat Inc>
+ * inotify was largely rewriten to make use of the fsnotify infrastructure
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2, or (at your option) any
@@ -24,89 +27,32 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/limits.h>
+#include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/init.h>
-#include <linux/list.h>
 #include <linux/inotify.h>
+#include <linux/list.h>
 #include <linux/syscalls.h>
+#include <linux/string.h>
 #include <linux/magic.h>
+#include <linux/writeback.h>
 
-#include <asm/ioctls.h>
+#include "inotify.h"
 
-static struct kmem_cache *watch_cachep __read_mostly;
-static struct kmem_cache *event_cachep __read_mostly;
+#include <asm/ioctls.h>
 
 static struct vfsmount *inotify_mnt __read_mostly;
 
+/* this just sits here and wastes global memory.  used to just pad userspace messages with zeros */
+static struct inotify_event nul_inotify_event;
+
 /* these are configurable via /proc/sys/fs/inotify/ */
 static int inotify_max_user_instances __read_mostly;
-static int inotify_max_user_watches __read_mostly;
 static int inotify_max_queued_events __read_mostly;
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
-	struct user_struct	*user;		/* user who opened this dev */
-	struct inotify_handle	*ih;		/* inotify handle */
-	struct fasync_struct    *fa;            /* async notification */
-	atomic_t		count;		/* reference count */
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
+int inotify_max_user_watches __read_mostly;
 
 #ifdef CONFIG_SYSCTL
 
@@ -149,280 +95,17 @@ ctl_table inotify_table[] = {
 };
 #endif /* CONFIG_SYSCTL */
 
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
+/* intofiy userspace file descriptor functions */
 static unsigned int inotify_poll(struct file *file, poll_table *wait)
 {
-	struct inotify_device *dev = file->private_data;
+	struct fsnotify_group *group = file->private_data;
 	int ret = 0;
 
-	poll_wait(file, &dev->wq, wait);
-	mutex_lock(&dev->ev_mutex);
-	if (!list_empty(&dev->events))
+	poll_wait(file, &group->notification_waitq, wait);
+	mutex_lock(&group->notification_mutex);
+	if (fsnotify_check_notif_queue(group))
 		ret = POLLIN | POLLRDNORM;
-	mutex_unlock(&dev->ev_mutex);
+	mutex_unlock(&group->notification_mutex);
 
 	return ret;
 }
@@ -432,26 +115,29 @@ static unsigned int inotify_poll(struct file *file, poll_table *wait)
  * enough to fit in "count". Return an error pointer if
  * not large enough.
  *
- * Called with the device ev_mutex held.
+ * Called with the group->notification_mutex held.
  */
-static struct inotify_kernel_event *get_one_event(struct inotify_device *dev,
-						  size_t count)
+static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
+					    size_t count)
 {
 	size_t event_size = sizeof(struct inotify_event);
-	struct inotify_kernel_event *kevent;
+	struct fsnotify_event *event;
 
-	if (list_empty(&dev->events))
+	if (!fsnotify_check_notif_queue(group))
 		return NULL;
 
-	kevent = inotify_dev_get_event(dev);
-	if (kevent->name)
-		event_size += kevent->event.len;
+	event = fsnotify_peek_notif_event(group);
+
+	event_size += roundup(event->name_len, event_size);
 
 	if (event_size > count)
 		return ERR_PTR(-EINVAL);
 
-	remove_kevent(dev, kevent);
-	return kevent;
+	/* held the notification_mutex the whole time, so this is the
+	 * same event we peeked above */
+	fsnotify_remove_notif_event(group);
+
+	return event;
 }
 
 /*
@@ -460,51 +146,82 @@ static struct inotify_kernel_event *get_one_event(struct inotify_device *dev,
  * We already checked that the event size is smaller than the
  * buffer we had in "get_one_event()" above.
  */
-static ssize_t copy_event_to_user(struct inotify_kernel_event *kevent,
+static ssize_t copy_event_to_user(struct fsnotify_group *group,
+				  struct fsnotify_event *event,
 				  char __user *buf)
 {
+	struct inotify_event inotify_event;
+	struct inotify_event_private_data *priv;
 	size_t event_size = sizeof(struct inotify_event);
+	size_t name_len;
+
+	/* we get the inotify watch descriptor from the event private data */
+	spin_lock(&event->lock);
+	priv = (struct inotify_event_private_data *)fsnotify_get_priv_from_event(group, event);
+	inotify_event.wd = priv->wd;
+	__inotify_free_event_priv(priv);
+	spin_unlock(&event->lock);
+
+	/* round up event->name_len so it is a multiple of event_size */
+	name_len = roundup(event->name_len, event_size);
+	inotify_event.len = name_len;
 
-	if (copy_to_user(buf, &kevent->event, event_size))
+	inotify_event.mask = inotify_mask_to_arg(event->mask);
+	inotify_event.cookie = event->sync_cookie;
+
+	/* send the main event */
+	if (copy_to_user(buf, &inotify_event, event_size))
 		return -EFAULT;
 
-	if (kevent->name) {
-		buf += event_size;
+	buf += event_size;
 
-		if (copy_to_user(buf, kevent->name, kevent->event.len))
+	/*
+	 * fsnotify only stores the pathname, so here we have to send the pathname
+	 * and then pad that pathname out to a multiple of sizeof(inotify_event)
+	 * with zeros.  I get my zeros from the nul_inotify_event.
+	 */
+	if (name_len) {
+		unsigned int len_to_zero = name_len - event->name_len;
+		/* copy the path name */
+		if (copy_to_user(buf, event->file_name, event->name_len))
 			return -EFAULT;
+		buf += event->name_len;
 
-		event_size += kevent->event.len;
+		/* fill userspace with 0's from nul_inotify_event */
+		if (copy_to_user(buf, &nul_inotify_event, len_to_zero))
+			return -EFAULT;
+		buf += len_to_zero;
+		event_size += name_len;
 	}
+
 	return event_size;
 }
 
 static ssize_t inotify_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *pos)
 {
-	struct inotify_device *dev;
+	struct fsnotify_group *group;
+	struct fsnotify_event *kevent;
 	char __user *start;
 	int ret;
 	DEFINE_WAIT(wait);
 
 	start = buf;
-	dev = file->private_data;
+	group = file->private_data;
 
 	while (1) {
-		struct inotify_kernel_event *kevent;
+		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
 
-		prepare_to_wait(&dev->wq, &wait, TASK_INTERRUPTIBLE);
-
-		mutex_lock(&dev->ev_mutex);
-		kevent = get_one_event(dev, count);
-		mutex_unlock(&dev->ev_mutex);
+		mutex_lock(&group->notification_mutex);
+		kevent = get_one_event(group, count);
+		mutex_unlock(&group->notification_mutex);
 
 		if (kevent) {
 			ret = PTR_ERR(kevent);
 			if (IS_ERR(kevent))
 				break;
-			ret = copy_event_to_user(kevent, buf);
-			free_kevent(kevent);
+			ret = copy_event_to_user(group, kevent, buf);
+			fsnotify_put_event(kevent);
 			if (ret < 0)
 				break;
 			buf += ret;
@@ -525,7 +242,7 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 		schedule();
 	}
 
-	finish_wait(&dev->wq, &wait);
+	finish_wait(&group->notification_waitq, &wait);
 	if (start != buf && ret != -EFAULT)
 		ret = buf - start;
 	return ret;
@@ -533,25 +250,19 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 
 static int inotify_fasync(int fd, struct file *file, int on)
 {
-	struct inotify_device *dev = file->private_data;
+	struct fsnotify_group *group = file->private_data;
 
-	return fasync_helper(fd, file, on, &dev->fa) >= 0 ? 0 : -EIO;
+	return fasync_helper(fd, file, on, &group->inotify_data.fa) >= 0 ? 0 : -EIO;
 }
 
 static int inotify_release(struct inode *ignored, struct file *file)
 {
-	struct inotify_device *dev = file->private_data;
-
-	inotify_destroy(dev->ih);
+	struct fsnotify_group *group = file->private_data;
 
-	/* destroy all of the events on this device */
-	mutex_lock(&dev->ev_mutex);
-	while (!list_empty(&dev->events))
-		inotify_dev_event_dequeue(dev);
-	mutex_unlock(&dev->ev_mutex);
+	fsnotify_clear_marks_by_group(group);
 
-	/* free this device: the put matching the get in inotify_init() */
-	put_inotify_dev(dev);
+	/* free this group, matching get was inotify_init->fsnotify_obtain_group */
+	fsnotify_put_group(group);
 
 	return 0;
 }
@@ -559,16 +270,25 @@ static int inotify_release(struct inode *ignored, struct file *file)
 static long inotify_ioctl(struct file *file, unsigned int cmd,
 			  unsigned long arg)
 {
-	struct inotify_device *dev;
+	struct fsnotify_group *group;
+	struct fsnotify_event_holder *holder;
+	struct fsnotify_event *event;
 	void __user *p;
 	int ret = -ENOTTY;
+	size_t send_len = 0;
 
-	dev = file->private_data;
+	group = file->private_data;
 	p = (void __user *) arg;
 
 	switch (cmd) {
 	case FIONREAD:
-		ret = put_user(dev->queue_size, (int __user *) p);
+		mutex_lock(&group->notification_mutex);
+		list_for_each_entry(holder, &group->notification_list, event_list) {
+			event = holder->event;
+			send_len += sizeof(struct inotify_event) + event->name_len;
+		}
+		mutex_unlock(&group->notification_mutex);
+		ret = put_user(send_len, (int __user *) p);
 		break;
 	}
 
@@ -576,23 +296,18 @@ static long inotify_ioctl(struct file *file, unsigned int cmd,
 }
 
 static const struct file_operations inotify_fops = {
-	.poll           = inotify_poll,
-	.read           = inotify_read,
-	.fasync         = inotify_fasync,
-	.release        = inotify_release,
-	.unlocked_ioctl = inotify_ioctl,
+	.poll		= inotify_poll,
+	.read		= inotify_read,
+	.fasync		= inotify_fasync,
+	.release	= inotify_release,
+	.unlocked_ioctl	= inotify_ioctl,
 	.compat_ioctl	= inotify_ioctl,
 };
 
-static const struct inotify_operations inotify_user_ops = {
-	.handle_event	= inotify_dev_queue_event,
-	.destroy_watch	= free_inotify_user_watch,
-};
-
+/* inotify syscalls */
 SYSCALL_DEFINE1(inotify_init1, int, flags)
 {
-	struct inotify_device *dev;
-	struct inotify_handle *ih;
+	struct fsnotify_group *group;
 	struct user_struct *user;
 	struct file *filp;
 	int fd, ret;
@@ -621,45 +336,27 @@ SYSCALL_DEFINE1(inotify_init1, int, flags)
 		goto out_free_uid;
 	}
 
-	dev = kmalloc(sizeof(struct inotify_device), GFP_KERNEL);
-	if (unlikely(!dev)) {
-		ret = -ENOMEM;
+	/* fsnotify_obtain_group took a reference to group, we put this when we kill the file in the end */
+	group = inotify_new_group(user, inotify_max_queued_events);
+	if (IS_ERR(group)) {
+		ret = PTR_ERR(group);
 		goto out_free_uid;
 	}
 
-	ih = inotify_init(&inotify_user_ops);
-	if (IS_ERR(ih)) {
-		ret = PTR_ERR(ih);
-		goto out_free_dev;
-	}
-	dev->ih = ih;
-	dev->fa = NULL;
-
 	filp->f_op = &inotify_fops;
 	filp->f_path.mnt = mntget(inotify_mnt);
 	filp->f_path.dentry = dget(inotify_mnt->mnt_root);
 	filp->f_mapping = filp->f_path.dentry->d_inode->i_mapping;
 	filp->f_mode = FMODE_READ;
 	filp->f_flags = O_RDONLY | (flags & O_NONBLOCK);
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
+	filp->private_data = group;
+
 	atomic_inc(&user->inotify_devs);
+
 	fd_install(fd, filp);
 
 	return fd;
-out_free_dev:
-	kfree(dev);
+
 out_free_uid:
 	free_uid(user);
 	put_filp(filp);
@@ -676,8 +373,8 @@ SYSCALL_DEFINE0(inotify_init)
 SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
 		u32, mask)
 {
+	struct fsnotify_group *group;
 	struct inode *inode;
-	struct inotify_device *dev;
 	struct path path;
 	struct file *filp;
 	int ret, fput_needed;
@@ -699,19 +396,19 @@ SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
 		flags |= LOOKUP_DIRECTORY;
 
 	ret = find_inode(pathname, &path, flags);
-	if (unlikely(ret))
+	if (ret)
 		goto fput_and_out;
 
-	/* inode held in place by reference to path; dev by fget on fd */
+	/* inode held in place by reference to path; group by fget on fd */
 	inode = path.dentry->d_inode;
-	dev = filp->private_data;
+	group = filp->private_data;
 
-	mutex_lock(&dev->up_mutex);
-	ret = inotify_find_update_watch(dev->ih, inode, mask);
-	if (ret == -ENOENT)
-		ret = create_watch(dev, inode, mask);
-	mutex_unlock(&dev->up_mutex);
+	/* create/update an inode mark */
+	ret = inotify_update_watch(group, inode, mask);
+	if (unlikely(ret))
+		goto path_put_and_out;
 
+path_put_and_out:
 	path_put(&path);
 fput_and_out:
 	fput_light(filp, fput_needed);
@@ -720,9 +417,10 @@ fput_and_out:
 
 SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 {
+	struct fsnotify_group *group;
+	struct fsnotify_mark_entry *entry;
 	struct file *filp;
-	struct inotify_device *dev;
-	int ret, fput_needed;
+	int ret = 0, fput_needed;
 
 	filp = fget_light(fd, &fput_needed);
 	if (unlikely(!filp))
@@ -734,10 +432,20 @@ SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 		goto out;
 	}
 
-	dev = filp->private_data;
+	group = filp->private_data;
 
-	/* we free our watch data when we get IN_IGNORED */
-	ret = inotify_rm_wd(dev->ih, wd);
+	spin_lock(&group->inotify_data.idr_lock);
+	entry = idr_find(&group->inotify_data.idr, wd);
+	if (unlikely(!entry)) {
+		spin_unlock(&group->inotify_data.idr_lock);
+		ret = -EINVAL;
+		goto out;
+	}
+	fsnotify_get_mark(entry);
+	spin_unlock(&group->inotify_data.idr_lock);
+
+	inotify_destroy_mark_entry(entry, group);
+	fsnotify_put_mark(entry);
 
 out:
 	fput_light(filp, fput_needed);
@@ -753,9 +461,9 @@ inotify_get_sb(struct file_system_type *fs_type, int flags,
 }
 
 static struct file_system_type inotify_fs_type = {
-    .name           = "inotifyfs",
-    .get_sb         = inotify_get_sb,
-    .kill_sb        = kill_anon_super,
+    .name	= "inotifyfs",
+    .get_sb	= inotify_get_sb,
+    .kill_sb	= kill_anon_super,
 };
 
 /*
@@ -779,14 +487,6 @@ static int __init inotify_user_setup(void)
 	inotify_max_user_instances = 128;
 	inotify_max_user_watches = 8192;
 
-	watch_cachep = kmem_cache_create("inotify_watch_cache",
-					 sizeof(struct inotify_user_watch),
-					 0, SLAB_PANIC, NULL);
-	event_cachep = kmem_cache_create("inotify_event_cache",
-					 sizeof(struct inotify_kernel_event),
-					 0, SLAB_PANIC, NULL);
-
 	return 0;
 }
-
 module_init(inotify_user_setup);
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index d71fc9b..4952b2b 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -133,7 +133,7 @@ static inline int event_compare(struct fsnotify_event *old, struct fsnotify_even
  */
 int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event, struct fsnotify_event_private_data *priv)
 {
-	struct fsnotify_event_holder *holder;
+	struct fsnotify_event_holder *holder = NULL;
 	struct list_head *list = &group->notification_list;
 	struct fsnotify_event_holder *last_holder;
 	struct fsnotify_event *last_event;
@@ -151,13 +151,11 @@ int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event
 	 * the event->lock.  If we see it empty we know that once we
 	 * get that lock the embedded holder will be ok for us to (re)use
 	 */
-	if (list_empty(&event->holder.event_list))
-		holder = (struct fsnotify_event_holder *)event;
-	else
+	if (!list_empty(&event->holder.event_list)) {
 		holder = alloc_event_holder();
-
-	if (!holder)
-		return -ENOMEM;
+		if (!holder)
+			return -ENOMEM;
+	}
 
 	mutex_lock(&group->notification_mutex);
 
@@ -166,6 +164,22 @@ int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event
 
 	spin_lock(&event->lock);
 
+	if (list_empty(&event->holder.event_list)) {
+		if (unlikely(holder))
+			fsnotify_destroy_event_holder(holder);
+		holder = &event->holder;
+	} else if (unlikely(!holder)) {
+		/* this only happens if we had room in the original event holder
+		 * but we switched to the overflow event and that in event holder
+		 * was in use */
+		holder = alloc_event_holder();
+		if (!holder) {
+			spin_unlock(&event->lock);
+			mutex_unlock(&group->notification_mutex);
+			return -ENOMEM;
+		}
+	}
+
 	if (!list_empty(list)) {
 		last_holder = list_entry(list->prev, struct fsnotify_event_holder, event_list);
 		last_event = last_holder->event;
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 7f4efee..e23da59 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -262,14 +262,13 @@ static inline void fsnotify_close(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	const char *name = dentry->d_name.name;
 	fmode_t mode = file->f_mode;
 	__u32 mask = (mode & FMODE_WRITE) ? FS_CLOSE_WRITE : FS_CLOSE_NOWRITE;
 
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_IN_ISDIR;
 
-	inotify_dentry_parent_queue_event(dentry, mask, 0, name);
+	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 82d7e9c..8a95e6c 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -9,6 +9,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/idr.h> /* inotify uses this */
 #include <linux/fs.h> /* struct inode */
 #include <linux/list.h>
 #include <linux/path.h> /* struct path */
@@ -58,6 +59,7 @@
 
 /* listeners that hard code group numbers near the top */
 #define DNOTIFY_GROUP_NUM	UINT_MAX
+#define INOTIFY_GROUP_NUM	(DNOTIFY_GROUP_NUM-1)
 
 struct fsnotify_group;
 struct fsnotify_event;
@@ -112,6 +114,15 @@ struct fsnotify_group {
 
 	/* groups can define private fields here */
 	union {
+#ifdef CONFIG_INOTIFY_USER
+		struct inotify_group_private_data {
+			spinlock_t	idr_lock;
+			struct idr      idr;
+			u32             last_wd;
+			struct fasync_struct    *fa;    /* async notification */
+			struct user_struct      *user;
+		} inotify_data;
+#endif
 	};
 };
 
@@ -262,6 +273,7 @@ extern void fsnotify_init_mark(struct fsnotify_mark_entry *entry, void (*free_ma
 extern struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *group, struct inode *inode);
 extern int fsnotify_add_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group, struct inode *inode);
 extern void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry);
+extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
 extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
 extern void fsnotify_unmount_inodes(struct list_head *list);

