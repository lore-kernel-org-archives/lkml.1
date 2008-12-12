Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYLLV4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYLLV4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbYLLVwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:52:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44180 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbYLLVwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:52:40 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH -v4 13/14] inotify: reimplement inotify using fsnotify
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk, hch@infradead.org,
       zbr@ioremap.net, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 12 Dec 2008 16:52:23 -0500
Message-ID: <20081212215222.27112.33426.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, holy shit, I'm trying to reimplement inotify as fsnotify...

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/inode.c                           |    1 
 fs/notify/inotify/Kconfig            |   20 +
 fs/notify/inotify/Makefile           |    2 
 fs/notify/inotify/inotify.h          |  117 +++++++
 fs/notify/inotify/inotify_fsnotify.c |  183 +++++++++++
 fs/notify/inotify/inotify_kernel.c   |  293 +++++++++++++++++
 fs/notify/inotify/inotify_user.c     |  591 +++++++++-------------------------
 include/linux/fsnotify.h             |   39 +-
 include/linux/inotify.h              |    1 
 9 files changed, 783 insertions(+), 464 deletions(-)
 create mode 100644 fs/notify/inotify/inotify.h
 create mode 100644 fs/notify/inotify/inotify_fsnotify.c
 create mode 100644 fs/notify/inotify/inotify_kernel.c

diff --git a/fs/inode.c b/fs/inode.c
index a7f6397..05a12b5 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -372,6 +372,7 @@ int invalidate_inodes(struct super_block * sb)
 	mutex_lock(&iprune_mutex);
 	spin_lock(&inode_lock);
 	inotify_unmount_inodes(&sb->s_inodes);
+	fsn_inotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
 	spin_unlock(&inode_lock);
 
diff --git a/fs/notify/inotify/Kconfig b/fs/notify/inotify/Kconfig
index 4467928..b89bfab 100644
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
index 0000000..37a437c
--- /dev/null
+++ b/fs/notify/inotify/inotify.h
@@ -0,0 +1,117 @@
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
+#include <linux/limits.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/inotify.h>
+#include <linux/syscalls.h>
+#include <linux/string.h>
+#include <linux/magic.h>
+#include <linux/writeback.h>
+#include <linux/fsnotify.h>
+
+#include "../fsnotify.h"
+
+#include <asm/ioctls.h>
+
+extern struct kmem_cache *grp_priv_cachep;
+extern struct kmem_cache *mark_priv_cachep;
+extern struct kmem_cache *event_priv_cachep;
+
+struct inotify_group_private_data {
+	struct idr	idr;
+	u32		last_wd;
+	struct fasync_struct	*fa;	/* async notification */
+	struct user_struct	*user;
+};
+
+struct inotify_mark_private_data {
+	int wd;
+	struct inode *inode;
+};
+
+struct inotify_event_private_data {
+	struct fsnotify_event_private_data fsnotify_event_priv_data;
+	int wd;
+};
+
+static inline __u64 inotify_arg_to_mask(u32 arg)
+{
+	/* everything should accept their own ignored */
+	__u64 mask = FS_IN_IGNORED;
+
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
+	BUILD_BUG_ON(IN_UNMOUNT != FS_IN_UNMOUNT);
+	BUILD_BUG_ON(IN_ISDIR != FS_IN_ISDIR);
+	BUILD_BUG_ON(IN_IGNORED != FS_IN_IGNORED);
+	BUILD_BUG_ON(IN_ONESHOT != FS_IN_ONESHOT);
+
+	mask |= (arg & (IN_ALL_EVENTS | IN_ONESHOT));
+
+	mask |= ((mask & FS_EVENTS_WITH_CHILD) << 32);
+
+	return mask;
+}
+
+static inline u32 inotify_mask_to_arg(__u64 mask)
+{
+	u32 arg;
+
+	arg = (mask & (IN_ALL_EVENTS | IN_ISDIR | IN_UNMOUNT | IN_IGNORED));
+
+	arg |= ((mask >> 32) & FS_EVENTS_WITH_CHILD);
+
+	return arg;
+}
+
+
+int find_inode(const char __user *dirname, struct path *path, unsigned flags);
+void inotify_destroy_mark_entry(struct fsnotify_mark_entry *entry);
+void fsn_inotify_unmount_inodes(struct list_head *list);
+int inotify_update_watch(struct fsnotify_group *group, struct inode *inode, u32 arg);
+struct fsnotify_group *inotify_new_group(struct user_struct *user, unsigned int max_events);
+void __inotify_free_event_priv(struct inotify_event_private_data *event_priv);
+
+extern const struct fsnotify_ops inotify_fsnotify_ops;
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
new file mode 100644
index 0000000..30c0a91
--- /dev/null
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -0,0 +1,183 @@
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
+#include "../fsnotify.h"
+
+#include <asm/ioctls.h>
+
+static int inotify_event_to_notif(struct fsnotify_group *group, struct fsnotify_event *event)
+{
+	struct fsnotify_mark_entry *entry;
+	struct inode *to_tell;
+	struct inotify_event_private_data *event_priv;
+	struct inotify_mark_private_data *mark_priv;
+	int wd, ret = 0;
+
+	to_tell = event->to_tell;
+
+	spin_lock(&to_tell->i_lock);
+	entry = fsnotify_find_mark_entry(group, to_tell);
+	spin_unlock(&to_tell->i_lock);
+
+	/* race with watch removal? */
+	if (!entry)
+		return ret;
+
+	mark_priv = entry->private;
+	wd = mark_priv->wd;
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
+	ret = fsnotify_add_notif_event(group, event, (struct fsnotify_event_private_data *)event_priv);
+
+	return ret;
+}
+
+static void inotify_mark_clear_inode(struct fsnotify_mark_entry *entry, struct inode *inode, unsigned int flags)
+{
+	if (unlikely((flags != FSNOTIFY_LAST_DENTRY) && (flags != FSNOTIFY_INODE_DESTROY))) {
+		BUG();
+		return;
+	}
+
+	/*
+	 * so no matter what we need to put this entry back on the inode's list.
+	 * we need it there so fsnotify can find it to send the ignore message.
+	 *
+	 * I didn't realize how brilliant this was until I did it.  Our caller
+	 * blanked the inode->i_fsnotify_mark_entries list so we will be the
+	 * only mark on the list when fsnotify runs so only our group will get
+	 * this FS_IN_IGNORED.
+	 *
+	 * Bloody brilliant.
+	 */
+	spin_lock(&inode->i_lock);
+	list_add(&entry->i_list, &inode->i_fsnotify_mark_entries);
+	spin_unlock(&inode->i_lock);
+
+	fsnotify(inode, FS_IN_IGNORED, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+	inotify_destroy_mark_entry(entry);
+}
+
+static int inotify_should_send_event(struct fsnotify_group *group, struct inode *inode, __u64 mask)
+{
+	struct fsnotify_mark_entry *entry;
+	int send;
+
+	entry = fsnotify_find_mark_entry(group, inode);
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
+static void inotify_free_group_priv(struct fsnotify_group *group)
+{
+	struct inotify_group_private_data *grp_priv;
+
+	BUG_ON(!group->private);
+
+	grp_priv = group->private;
+	idr_destroy(&grp_priv->idr);
+
+	kmem_cache_free(grp_priv_cachep, group->private);
+	group->private = NULL;
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
+/* ding dong the mark is dead */
+static void inotify_free_mark_priv(struct fsnotify_mark_entry *entry)
+{
+	struct inotify_mark_private_data *mark_priv = entry->private;
+	struct inode *inode = mark_priv->inode;
+
+	BUG_ON(!entry->private);
+
+	mark_priv = entry->private;
+	inode = mark_priv->inode;
+
+	iput(inode);
+
+	kmem_cache_free(mark_priv_cachep, entry->private);
+	entry->private = NULL;
+}
+
+const struct fsnotify_ops inotify_fsnotify_ops = {
+	.event_to_notif = inotify_event_to_notif,
+	.mark_clear_inode = inotify_mark_clear_inode,
+	.should_send_event = inotify_should_send_event,
+	.free_group_priv = inotify_free_group_priv,
+	.free_event_priv = inotify_free_event_priv,
+	.free_mark_priv = inotify_free_mark_priv,
+};
diff --git a/fs/notify/inotify/inotify_kernel.c b/fs/notify/inotify/inotify_kernel.c
new file mode 100644
index 0000000..269fd87
--- /dev/null
+++ b/fs/notify/inotify/inotify_kernel.c
@@ -0,0 +1,293 @@
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
+#include "../fsnotify.h"
+
+#include <asm/ioctls.h>
+
+struct kmem_cache *grp_priv_cachep __read_mostly;
+struct kmem_cache *mark_priv_cachep __read_mostly;
+struct kmem_cache *event_priv_cachep __read_mostly;
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
+void inotify_destroy_mark_entry(struct fsnotify_mark_entry *entry)
+{
+	struct fsnotify_group *group;
+	struct inotify_group_private_data *grp_priv;
+	struct inotify_mark_private_data *mark_priv;
+	struct idr *idr;
+	int wd;
+
+	spin_lock(&entry->lock);
+
+	mark_priv = entry->private;
+	wd = mark_priv->wd;
+
+	group = entry->group;
+	if (!group) {
+		/* racing with group tear down, let it do it */
+		spin_unlock(&entry->lock);
+		return;
+	}
+	grp_priv = group->private;
+	idr = &grp_priv->idr;
+	spin_lock(&group->mark_lock);
+	idr_remove(idr, wd);
+	spin_unlock(&group->mark_lock);
+
+	spin_unlock(&entry->lock);
+
+	/* mark the entry to die */
+	fsnotify_destroy_mark_by_entry(entry);
+
+	/* removed from idr, need to shoot it */
+	fsnotify_put_mark(entry);
+}
+
+/**
+ * inotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
+ * @list: list of inodes being unmounted (sb->s_inodes)
+ *
+ * Called with inode_lock held, protecting the unmounting super block's list
+ * of inodes, and with iprune_mutex held, keeping shrink_icache_memory() at bay.
+ * We temporarily drop inode_lock, however, and CAN block.
+ */
+void fsn_inotify_unmount_inodes(struct list_head *list)
+{
+	struct inode *inode, *next_i, *need_iput = NULL;
+
+	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
+		struct inode *need_iput_tmp;
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
+		fsnotify(inode, FS_IN_UNMOUNT, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+
+		fsnotify_inode_delete(inode);
+
+		iput(inode);
+
+		spin_lock(&inode_lock);
+	}
+}
+EXPORT_SYMBOL_GPL(fsn_inotify_unmount_inodes);
+
+int inotify_update_watch(struct fsnotify_group *group, struct inode *inode, u32 arg)
+{
+	struct fsnotify_mark_entry *entry;
+	struct inotify_group_private_data *grp_priv = group->private;
+	struct inotify_mark_private_data *mark_priv;
+	int ret = 0;
+	int add = (arg & IN_MASK_ADD);
+	__u64 mask;
+
+	/* don't allow invalid bits: we don't want flags set */
+	mask = inotify_arg_to_mask(arg);
+	if (unlikely(!mask))
+		return -EINVAL;
+
+	mark_priv = kmem_cache_alloc(mark_priv_cachep, GFP_KERNEL);
+	if (unlikely(!mark_priv))
+		return -ENOMEM;
+
+	/* this is slick, using 0 for mask gives me the entry */
+	entry = fsnotify_mark_add(group, inode, 0);
+	if (unlikely(!entry)) {
+		kmem_cache_free(mark_priv_cachep, mark_priv);
+		return -ENOMEM;
+	}
+
+retry:  
+	if (entry->mask == 0) {
+		if (unlikely(!idr_pre_get(&grp_priv->idr, GFP_KERNEL)))
+			goto out_and_shoot;
+	}
+
+	spin_lock(&entry->lock);
+	if (entry->mask == 0) {
+		spin_lock(&group->mark_lock);
+		/* if entry is added to the idr we keep the reference obtained
+		 * through fsnotify_mark_add.  remember to drop this reference
+		 * when entry is removed from idr */
+		ret = idr_get_new_above(&grp_priv->idr, entry, grp_priv->last_wd+1, &mark_priv->wd);
+		if (ret) {
+			spin_unlock(&group->mark_lock);
+			spin_unlock(&entry->lock);
+			if (ret == -EAGAIN)
+				goto retry;
+			goto out_and_shoot;
+		}
+		spin_unlock(&group->mark_lock);
+		/* this is a new entry, pin the inode */
+		__iget(inode);
+		mark_priv->inode = inode;
+		entry->private = mark_priv;
+	} else {
+		kmem_cache_free(mark_priv_cachep, mark_priv);
+	}
+
+	if (add)
+		entry->mask |= mask;
+	else
+		entry->mask = mask;
+
+	spin_unlock(&entry->lock);
+
+	/* update the inode with this new entry */
+	fsnotify_recalc_inode_mask(inode);
+
+	/* update the group mask with the new mask */
+	fsnotify_recalc_group_mask(group);
+
+	return mark_priv->wd;
+
+out_and_shoot:
+	/* see this isn't supposed to happen, just kill the watch */
+	fsnotify_destroy_mark_by_entry(entry);
+	kmem_cache_free(mark_priv_cachep, mark_priv);
+	fsnotify_put_mark(entry);
+	return ret;
+}
+
+struct fsnotify_group *inotify_new_group(struct user_struct *user, unsigned int max_events)
+{
+	struct fsnotify_group *group;
+	struct inotify_group_private_data *grp_priv;
+	unsigned int grp_num;
+
+	/* fsnotify_obtain_group took a reference to group, we put this when we kill the file in the end */
+	grp_num = (UINT_MAX - atomic_inc_return(&inotify_grp_num));
+	group = fsnotify_obtain_group(grp_num, grp_num, 0, &inotify_fsnotify_ops);
+	if (IS_ERR(group))
+		return group;
+
+	group->max_events = max_events;
+
+	grp_priv = kmem_cache_alloc(grp_priv_cachep, GFP_KERNEL);
+	if (unlikely(!grp_priv)) {
+		fsnotify_put_group(group);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	idr_init(&grp_priv->idr);
+	grp_priv->last_wd = 0;
+	grp_priv->user = user;
+	grp_priv->fa = NULL;
+	group->private = (void *)grp_priv;
+
+	return group;
+}
+
+static int __init inotify_kernel_setup(void)
+{
+	grp_priv_cachep = kmem_cache_create("inotify_group_priv_cache",
+					sizeof(struct inotify_group_private_data),
+					0, SLAB_PANIC, NULL);
+	mark_priv_cachep = kmem_cache_create("inotify_mark_priv_cache",
+					sizeof(struct inotify_mark_private_data),
+					0, SLAB_PANIC, NULL);
+	event_priv_cachep = kmem_cache_create("inotify_event_priv_cache",
+					sizeof(struct inotify_event_private_data),
+					0, SLAB_PANIC, NULL);
+	return 0;
+}
+subsys_initcall(inotify_kernel_setup);
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index d367e9b..2df65ff 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -24,90 +24,35 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/limits.h>
+#include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
+#include <linux/idr.h>
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
+#include "../fsnotify.h"
 
-static struct kmem_cache *watch_cachep __read_mostly;
-static struct kmem_cache *event_cachep __read_mostly;
+#include <asm/ioctls.h>
 
 static struct vfsmount *inotify_mnt __read_mostly;
 
+/* this just sits here and wastes global memory.  used to just pad userspace messages with zeros */
+static struct inotify_event nul_inotify_event;
+
 /* these are configurable via /proc/sys/fs/inotify/ */
 static int inotify_max_user_instances __read_mostly;
 static int inotify_max_user_watches __read_mostly;
 static int inotify_max_queued_events __read_mostly;
 
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
 #ifdef CONFIG_SYSCTL
 
 #include <linux/sysctl.h>
@@ -149,280 +94,17 @@ ctl_table inotify_table[] = {
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
@@ -430,25 +112,26 @@ static unsigned int inotify_poll(struct file *file, poll_table *wait)
 static ssize_t inotify_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *pos)
 {
-	size_t event_size = sizeof (struct inotify_event);
-	struct inotify_device *dev;
+	struct fsnotify_group *group;
+	struct inotify_event inotify_event;
+	const size_t event_size = sizeof (struct inotify_event);
 	char __user *start;
 	int ret;
 	DEFINE_WAIT(wait);
 
 	start = buf;
-	dev = file->private_data;
+	group = file->private_data;
 
 	while (1) {
 
-		prepare_to_wait(&dev->wq, &wait, TASK_INTERRUPTIBLE);
+		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
 
-		mutex_lock(&dev->ev_mutex);
-		if (!list_empty(&dev->events)) {
+		mutex_lock(&group->notification_mutex);
+		if (fsnotify_check_notif_queue(group)) {
 			ret = 0;
 			break;
 		}
-		mutex_unlock(&dev->ev_mutex);
+		mutex_unlock(&group->notification_mutex);
 
 		if (file->f_flags & O_NONBLOCK) {
 			ret = -EAGAIN;
@@ -456,26 +139,38 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 		}
 
 		if (signal_pending(current)) {
-			ret = -EINTR;
+			ret = -ERESTARTSYS;
 			break;
 		}
 
 		schedule();
 	}
 
-	finish_wait(&dev->wq, &wait);
+	finish_wait(&group->notification_waitq, &wait);
 	if (ret)
 		return ret;
 
 	while (1) {
-		struct inotify_kernel_event *kevent;
+		struct fsnotify_event *event;
+		struct inotify_event_private_data *priv;
+		size_t name_to_send_len;
 
 		ret = buf - start;
-		if (list_empty(&dev->events))
+
+		if (!fsnotify_check_notif_queue(group))
 			break;
 
-		kevent = inotify_dev_get_event(dev);
-		if (event_size + kevent->event.len > count) {
+		event = fsnotify_peek_notif_event(group);
+
+		spin_lock(&event->lock);
+		priv = (struct inotify_event_private_data *)fsnotify_get_priv_from_event(group, event);
+		spin_unlock(&event->lock);
+		BUG_ON(!priv);
+
+		name_to_send_len = roundup(event->name_len, event_size);
+
+		/* the above is closer, since it sends filenames */
+		if (event_size + name_to_send_len > count) {
 			if (ret == 0 && count > 0) {
 				/*
 				 * could not get a single event because we
@@ -485,60 +180,94 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 			}
 			break;
 		}
-		remove_kevent(dev, kevent);
+
+		/* held the notification_mutex the whole time, so this is the
+		 * same event we peeked above */
+		fsnotify_remove_notif_event(group);
 
 		/*
 		 * Must perform the copy_to_user outside the mutex in order
 		 * to avoid a lock order reversal with mmap_sem.
 		 */
-		mutex_unlock(&dev->ev_mutex);
+		mutex_unlock(&group->notification_mutex);
+
+		memset(&inotify_event, 0, sizeof(struct inotify_event));
+
+		inotify_event.wd = priv->wd;
+		inotify_event.mask = inotify_mask_to_arg(event->mask);
+		inotify_event.cookie = event->sync_cookie;
+		inotify_event.len = name_to_send_len;
+
+		spin_lock(&event->lock);
+		__inotify_free_event_priv(priv);
+		spin_unlock(&event->lock);
 
-		if (copy_to_user(buf, &kevent->event, event_size)) {
+		if (copy_to_user(buf, &inotify_event, event_size)) {
 			ret = -EFAULT;
 			break;
 		}
 		buf += event_size;
 		count -= event_size;
 
-		if (kevent->name) {
-			if (copy_to_user(buf, kevent->name, kevent->event.len)){
+		if (name_to_send_len) {
+			unsigned int len_to_zero = name_to_send_len - event->name_len;
+			/* copy the path name */
+			if (copy_to_user(buf, event->file_name, event->name_len)) {
 				ret = -EFAULT;
 				break;
 			}
-			buf += kevent->event.len;
-			count -= kevent->event.len;
+			buf += event->name_len;
+			count -= event->name_len;
+			/* fill userspace with 0's from nul_inotify_event */
+			if (copy_to_user(buf, &nul_inotify_event, len_to_zero)) {
+				ret = -EFAULT;
+				break;
+			}
+			buf += len_to_zero;
+			count -= len_to_zero;
 		}
 
-		free_kevent(kevent);
+		fsnotify_put_event(event);
 
-		mutex_lock(&dev->ev_mutex);
+		mutex_lock(&group->notification_mutex);
 	}
-	mutex_unlock(&dev->ev_mutex);
+	mutex_unlock(&group->notification_mutex);
 
 	return ret;
 }
 
 static int inotify_fasync(int fd, struct file *file, int on)
 {
-	struct inotify_device *dev = file->private_data;
+	struct fsnotify_group *group = file->private_data;
+	struct inotify_group_private_data *priv = group->private;
 
-	return fasync_helper(fd, file, on, &dev->fa) >= 0 ? 0 : -EIO;
+	return fasync_helper(fd, file, on, &priv->fa) >= 0 ? 0 : -EIO;
 }
 
 static int inotify_release(struct inode *ignored, struct file *file)
 {
-	struct inotify_device *dev = file->private_data;
+	struct fsnotify_group *group = file->private_data;
+	struct fsnotify_mark_entry *entry;
 
-	inotify_destroy(dev->ih);
+	/* run all the entries remove them from the idr and drop that ref */
+	spin_lock(&group->mark_lock);
+	while(!list_empty(&group->mark_entries)) {
+		entry = list_first_entry(&group->mark_entries, struct fsnotify_mark_entry, g_list);
 
-	/* destroy all of the events on this device */
-	mutex_lock(&dev->ev_mutex);
-	while (!list_empty(&dev->events))
-		inotify_dev_event_dequeue(dev);
-	mutex_unlock(&dev->ev_mutex);
+		/* make sure entry can't get freed */
+		fsnotify_get_mark(entry);
+		spin_unlock(&group->mark_lock);
 
-	/* free this device: the put matching the get in inotify_init() */
-	put_inotify_dev(dev);
+		inotify_destroy_mark_entry(entry);
+
+		/* ok, free it */
+		fsnotify_put_mark(entry);
+		spin_lock(&group->mark_lock);
+	}
+	spin_unlock(&group->mark_lock);
+
+	/* free this group, matching get was inotify_init->fsnotify_obtain_group */
+	fsnotify_put_group(group);
 
 	return 0;
 }
@@ -546,16 +275,25 @@ static int inotify_release(struct inode *ignored, struct file *file)
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
 
@@ -563,23 +301,18 @@ static long inotify_ioctl(struct file *file, unsigned int cmd,
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
 asmlinkage long sys_inotify_init1(int flags)
 {
-	struct inotify_device *dev;
-	struct inotify_handle *ih;
+	struct fsnotify_group *group;
 	struct user_struct *user;
 	struct file *filp;
 	int fd, ret;
@@ -608,45 +341,27 @@ asmlinkage long sys_inotify_init1(int flags)
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
@@ -662,8 +377,8 @@ asmlinkage long sys_inotify_init(void)
 
 asmlinkage long sys_inotify_add_watch(int fd, const char __user *pathname, u32 mask)
 {
+	struct fsnotify_group *group;
 	struct inode *inode;
-	struct inotify_device *dev;
 	struct path path;
 	struct file *filp;
 	int ret, fput_needed;
@@ -685,19 +400,19 @@ asmlinkage long sys_inotify_add_watch(int fd, const char __user *pathname, u32 m
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
@@ -706,9 +421,11 @@ fput_and_out:
 
 asmlinkage long sys_inotify_rm_watch(int fd, u32 wd)
 {
+	struct fsnotify_group *group;
+	struct fsnotify_mark_entry *entry;
+	struct inotify_group_private_data *priv;
 	struct file *filp;
-	struct inotify_device *dev;
-	int ret, fput_needed;
+	int ret = 0, fput_needed;
 
 	filp = fget_light(fd, &fput_needed);
 	if (unlikely(!filp))
@@ -720,10 +437,22 @@ asmlinkage long sys_inotify_rm_watch(int fd, u32 wd)
 		goto out;
 	}
 
-	dev = filp->private_data;
+	group = filp->private_data;
+	priv = group->private;
 
+	spin_lock(&group->mark_lock);
 	/* we free our watch data when we get IN_IGNORED */
-	ret = inotify_rm_wd(dev->ih, wd);
+	entry = idr_find(&priv->idr, wd);
+	if (unlikely(!entry)) {
+		spin_unlock(&group->mark_lock);
+		ret = -EINVAL;
+		goto out;
+	}
+	fsnotify_get_mark(entry);
+	spin_unlock(&group->mark_lock);
+
+	inotify_destroy_mark_entry(entry);
+	fsnotify_put_mark(entry);
 
 out:
 	fput_light(filp, fput_needed);
@@ -739,9 +468,9 @@ inotify_get_sb(struct file_system_type *fs_type, int flags,
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
@@ -765,14 +494,6 @@ static int __init inotify_user_setup(void)
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
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index c1a7b61..3d10004 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -257,10 +257,10 @@ static inline void fsnotify_access(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	__u64 mask = IN_ACCESS;
+	__u64 mask = FS_ACCESS;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		mask |= FS_IN_ISDIR;
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
@@ -276,10 +276,10 @@ static inline void fsnotify_modify(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	__u64 mask = IN_MODIFY;
+	__u64 mask = FS_MODIFY;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		mask |= FS_IN_ISDIR;
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
@@ -310,10 +310,10 @@ static inline void fsnotify_open(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	__u64 mask = IN_OPEN;
+	__u64 mask = FS_OPEN;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		mask |= FS_IN_ISDIR;
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
@@ -329,14 +329,13 @@ static inline void fsnotify_close(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	const char *name = dentry->d_name.name;
 	fmode_t mode = file->f_mode;
-	__u64 mask = (mode & FMODE_WRITE) ? IN_CLOSE_WRITE : IN_CLOSE_NOWRITE;
+	__u64 mask = (mode & FMODE_WRITE) ? FS_CLOSE_WRITE : FS_CLOSE_NOWRITE;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		mask |= FS_IN_ISDIR;
 
-	inotify_dentry_parent_queue_event(dentry, mask, 0, name);
+	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
@@ -349,10 +348,10 @@ static inline void fsnotify_close(struct file *file)
 static inline void fsnotify_xattr(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	__u64 mask = IN_ATTRIB;
+	__u64 mask = FS_ATTRIB;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		mask |= FS_IN_ISDIR;
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
@@ -371,26 +370,26 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 	__u64 mask = 0;
 
 	if (ia_valid & ATTR_UID)
-		mask |= IN_ATTRIB;
+		mask |= FS_ATTRIB;
 	if (ia_valid & ATTR_GID)
-		mask |= IN_ATTRIB;
+		mask |= FS_ATTRIB;
 	if (ia_valid & ATTR_SIZE)
-		mask |= IN_MODIFY;
+		mask |= FS_MODIFY;
 
 	/* both times implies a utime(s) call */
 	if ((ia_valid & (ATTR_ATIME | ATTR_MTIME)) == (ATTR_ATIME | ATTR_MTIME))
-		mask |= IN_ATTRIB;
+		mask |= FS_ATTRIB;
 	else if (ia_valid & ATTR_ATIME)
-		mask |= IN_ACCESS;
+		mask |= FS_ACCESS;
 	else if (ia_valid & ATTR_MTIME)
-		mask |= IN_MODIFY;
+		mask |= FS_MODIFY;
 
 	if (ia_valid & ATTR_MODE)
-		mask |= IN_ATTRIB;
+		mask |= FS_ATTRIB;
 
 	if (mask) {
 		if (S_ISDIR(inode->i_mode))
-			mask |= IN_ISDIR;
+			mask |= FS_IN_ISDIR;
 		inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 		inotify_dentry_parent_queue_event(dentry, mask, 0,
 						  dentry->d_name.name);
diff --git a/include/linux/inotify.h b/include/linux/inotify.h
index 37ea289..084d1c1 100644
--- a/include/linux/inotify.h
+++ b/include/linux/inotify.h
@@ -112,6 +112,7 @@ extern void inotify_inode_queue_event(struct inode *, __u32, __u32,
 extern void inotify_dentry_parent_queue_event(struct dentry *, __u32, __u32,
 					      const char *);
 extern void inotify_unmount_inodes(struct list_head *);
+extern void fsn_inotify_unmount_inodes(struct list_head *);
 extern void inotify_inode_is_dead(struct inode *);
 extern u32 inotify_get_cookie(void);
 

