Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab0BLVKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:10:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:7787 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab0BLVKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:10:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=NNBibIZbxhjtZF+YIJ3lBhKRixZ/K3F8AN4hs+2WrS0CtAHo+9R70J6/JLAuHGxrFQ
         7cNLlaGlM+roaevhbHpoy6wPD0hnQVMwT3yEHrGW+GSatgIJeOn55CqS95BKpczGo/zF
         oymACffv64600NyFr8LqsvsIwruFOlLf0gtc8=
Date: Fri, 12 Feb 2010 22:10:22 +0100
From: Joris Dolderer <vorstadtkind@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: eparis@redhat.com
Subject: [PATCH 1/3] fsnotify: tree-watching support
Message-ID: <20100212221022.1b9b8544@icecube>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tree-watching support to fsnotify.
Signed-off-by: Joris Dolderer <vorstadtkind@googlemail.com>
---
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 274ac86..cc70ecd 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -472,6 +472,7 @@ struct dentry *debugfs_rename(struct dentry
*old_dir, struct dentry *old_dentry, int error;
 	struct dentry *dentry = NULL, *trap;
 	const char *old_name;
+	int old_len;
 
 	trap = lock_rename(new_dir, old_dir);
 	/* Source or destination directories don't exist? */
@@ -487,6 +488,7 @@ struct dentry *debugfs_rename(struct dentry
*old_dir, struct dentry *old_dentry, goto exit;
 
 	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
+	old_len = old_dentry->d_name.len;
 
 	error = simple_rename(old_dir->d_inode, old_dentry,
new_dir->d_inode, dentry);
@@ -495,9 +497,9 @@ struct dentry *debugfs_rename(struct dentry
*old_dir, struct dentry *old_dentry, goto exit;
 	}
 	d_move(old_dentry, dentry);
-	fsnotify_move(old_dir->d_inode, new_dir->d_inode, old_name,
-		old_dentry->d_name.name,
S_ISDIR(old_dentry->d_inode->i_mode),
-		NULL, old_dentry);
+	fsnotify_move(old_dir->d_inode, old_name, old_len,
+		new_dir->d_inode, old_dentry->d_name.name,
old_dentry->d_name.len,
+		S_ISDIR(old_dentry->d_inode->i_mode), NULL,
old_dentry); fsnotify_oldname_free(old_name);
 	unlock_rename(new_dir, old_dir);
 	dput(dentry);
diff --git a/fs/namei.c b/fs/namei.c
index d62fdc8..f220441 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2634,6 +2634,7 @@ int vfs_rename(struct inode *old_dir, struct
dentry *old_dentry, int error;
 	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
 	const char *old_name;
+	int old_len;
 
 	if (old_dentry->d_inode == new_dentry->d_inode)
  		return 0;
@@ -2656,6 +2657,7 @@ int vfs_rename(struct inode *old_dir, struct
dentry *old_dentry, vfs_dq_init(new_dir);
 
 	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
+	old_len = old_dentry->d_name.len;
 
 	if (is_dir)
 		error =
vfs_rename_dir(old_dir,old_dentry,new_dir,new_dentry); @@ -2663,8
+2665,10 @@ int vfs_rename(struct inode *old_dir, struct dentry
*old_dentry, error =
vfs_rename_other(old_dir,old_dentry,new_dir,new_dentry); if (!error)
{ const char *new_name = old_dentry->d_name.name;
-		fsnotify_move(old_dir, new_dir, old_name, new_name,
is_dir,
-			      new_dentry->d_inode, old_dentry);
+		int new_len = old_dentry->d_name.len;
+		fsnotify_move(old_dir, old_name, old_len,
+			      new_dir, new_name, new_len,
+			      is_dir, new_dentry->d_inode, old_dentry);
 	}
 	fsnotify_oldname_free(old_name);
 
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 037e878..17cd902 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -76,55 +76,164 @@ void __fsnotify_update_child_dentry_flags(struct
inode *inode) spin_unlock(&dcache_lock);
 }
 
-/* Notify this dentry's parent about a child's events. */
-void __fsnotify_parent(struct dentry *dentry, __u32 mask)
+/*
+ * Does the work when updating descents of a dentry
+ */
+static void fsnotify_update_descents(struct dentry *dentry, bool
watched) {
-	struct dentry *parent;
-	struct inode *p_inode;
-	bool send = false;
-	bool should_update_children = false;
+	struct dentry *child;
+
+	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
+		if (!child->d_inode)
+			continue;
+
+		spin_lock(&child->d_lock);
+
+		if (watched)
+			child->d_flags |=
DCACHE_FSNOTIFY_ANCESTOR_WATCHED;
+		else
+			child->d_flags &=
~DCACHE_FSNOTIFY_ANCESTOR_WATCHED; +
+		if (!fsnotify_inode_watches_descents(child->d_inode)) {
+			fsnotify_update_descents(child, watched);
+		}
+
+		spin_unlock(&child->d_lock);
+	}
+}
 
-	if (!(dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED))
+/* do something equivalent to __fsnotify_update_child_dentry_flags,
but for a tree watch */ +void __fsnotify_update_descents(struct dentry
*dentry, bool lock) +{
+	bool should_be =
fsnotify_inode_watches_descents(dentry->d_inode)
+			 || (dentry->d_flags &
DCACHE_FSNOTIFY_ANCESTOR_WATCHED);
+	bool is;
+
+	/* any child of this dentry */
+	struct dentry *onechild = list_entry(dentry->d_subdirs.next,
struct dentry, d_u.d_child); +
+	if (onechild != dentry)
+		is = onechild->d_flags &
DCACHE_FSNOTIFY_ANCESTOR_WATCHED;
+	else
+		return; /* no child dentries here */
+
+	if (should_be == is)
 		return;
 
-	spin_lock(&dentry->d_lock);
-	parent = dentry->d_parent;
-	p_inode = parent->d_inode;
+	if (lock)
+		spin_lock(&dentry->d_lock);
+
+	fsnotify_update_descents(dentry, should_be);
+
+	if (lock)
+		spin_unlock(&dentry->d_lock);
+}
+
+/* Notify this dentry's ancestors about a child's events. */
+void __fsnotify_ancestors(struct dentry *dentry, __u32 mask)
+{
+	if (dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED) {
+		struct dentry *parent;
+		struct inode *p_inode;
+		bool should_update_children = false;
+		bool send = false;
+
+		spin_lock(&dentry->d_lock);
+
+		parent = dentry->d_parent;
+		p_inode = parent->d_inode;
 
-	if (fsnotify_inode_watches_children(p_inode)) {
-		if (p_inode->i_fsnotify_mask & mask) {
+		if (fsnotify_inode_watches_children(p_inode)) {
+			if (p_inode->i_fsnotify_mask & mask) {
+				dget(parent);
+				send = true;
+			}
+		} else {
+			/*
+			 * The parent doesn't care about events on
it's children but
+			 * at least one child thought it did.  We need
to run all the
+			 * children and update their d_flags to let
them know p_inode
+			 * doesn't care about them any more.
+			 */
 			dget(parent);
-			send = true;
+			should_update_children = true;
 		}
-	} else {
-		/*
-		 * The parent doesn't care about events on it's
children but
-		 * at least one child thought it did.  We need to run
all the
-		 * children and update their d_flags to let them know
p_inode
-		 * doesn't care about them any more.
-		 */
-		dget(parent);
-		should_update_children = true;
-	}
 
-	spin_unlock(&dentry->d_lock);
+		spin_unlock(&dentry->d_lock);
 
-	if (send) {
-		/* we are notifying a parent so come up with the new
mask which
-		 * specifies these are events which came from a child.
*/
-		mask |= FS_EVENT_ON_CHILD;
+		if (send) {
+			/* we are notifying a parent so come up with
the new mask which
+			 * specifies these are events which came from
a child. */
+			fsnotify(p_inode, mask | FS_EVENT_ON_TREE,
dentry->d_inode,
+				 FSNOTIFY_EVENT_INODE,
dentry->d_name.name, 0);
+			dput(parent);
+		}
 
-		fsnotify(p_inode, mask, dentry->d_inode,
FSNOTIFY_EVENT_INODE,
-			 dentry->d_name.name, 0);
-		dput(parent);
+		if (unlikely(should_update_children)) {
+			__fsnotify_update_child_dentry_flags(p_inode);
+			dput(parent);
+		}
 	}
 
-	if (unlikely(should_update_children)) {
-		__fsnotify_update_child_dentry_flags(p_inode);
-		dput(parent);
+	fsnotify_far_ancestors(dentry->d_parent, dentry->d_name.name,
dentry->d_name.len, mask); +}
+EXPORT_SYMBOL_GPL(__fsnotify_ancestors);
+
+/*
+ * notify tree-watching ancestors
+ * @dentry: The dentry the walkup should start with
+ * @file_name: The string that should be appended to this dentries'
path
+ * @file_len: The length of this string
+ */
+void fsnotify_far_ancestors(struct dentry *dentry, const unsigned char
*file_name, int file_len, __u32 mask) +{
+	if (dentry->d_flags & DCACHE_FSNOTIFY_ANCESTOR_WATCHED) {
+		char path[PATH_MAX];
+		char *pathptr = path + PATH_MAX - 1 - file_len;
+		struct dentry *test_dentry, *next_update = NULL;
+		struct inode *d_inode, *test_inode;
+
+		strcpy(pathptr, file_name);
+
+		spin_lock(&dentry->d_lock);
+		d_inode = dentry->d_inode;
+
+		test_dentry = dentry;
+		test_inode = d_inode;
+		do {
+			dget(test_dentry);
+			if
(fsnotify_inode_watches_descents(test_inode)) {
+				if (test_inode->i_fsnotify_mask &
mask) {
+					dget(dentry);
+					spin_unlock(&dentry->d_lock);
+
inotify_inode_queue_event(test_inode, mask, 0, pathptr,
+
d_inode);
+					fsnotify(test_inode, mask |
FS_EVENT_ON_DESCENT, d_inode,
+						 FSNOTIFY_EVENT_INODE,
pathptr, 0);
+					spin_lock(&dentry->d_lock);
+					dput(dentry);
+				}
+			} else {
+				next_update = test_dentry;
+			}
+
+			pathptr -= test_dentry->d_name.len + 1;
+			strcpy(pathptr, test_dentry->d_name.name);
+			pathptr[test_dentry->d_name.len] = '/';
+			dput(test_dentry);
+
+			test_dentry = test_dentry->d_parent;
+			test_inode = test_dentry->d_inode;
+		} while (test_dentry->d_flags &
DCACHE_FSNOTIFY_ANCESTOR_WATCHED ||
+			 fsnotify_inode_watches_descents(test_inode));
+
+		spin_unlock(&dentry->d_lock);
+
+		if (next_update)
+			__fsnotify_update_descents(next_update, true);
 	}
 }
-EXPORT_SYMBOL_GPL(__fsnotify_parent);
+EXPORT_SYMBOL_GPL(fsnotify_far_ancestors);
 
 /*
  * This is the main call to fsnotify.  The VFS calls into hook
specific functions @@ -137,8 +246,8 @@ void fsnotify(struct inode
*to_tell, __u32 mask, void *data, int data_is, const struct
fsnotify_group *group; struct fsnotify_event *event = NULL;
 	int idx;
-	/* global tests shouldn't care about events on child only the
specific event */
-	__u32 test_mask = (mask & ~FS_EVENT_ON_CHILD);
+	/* global tests shouldn't care about events on child/descent
only the specific event */
+	__u32 test_mask = mask & ~FS_EVENT_ON_TREE;
 
 	if (list_empty(&fsnotify_groups))
 		return;
@@ -155,7 +264,10 @@ void fsnotify(struct inode *to_tell, __u32 mask,
void *data, int data_is, const */
 	idx = srcu_read_lock(&fsnotify_grp_srcu);
 	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
-		if (test_mask & group->mask) {
+		bool send = test_mask & group->mask;
+		send = send && (!(mask & FS_EVENT_ON_TREE) ||
+				(mask & group->mask) &
FS_EVENT_ON_TREE);
+		if (send) {
 			if (!group->ops->should_send_event(group,
to_tell, mask)) continue;
 			if (!event) {
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 4dc2408..7a587a8 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -26,6 +26,7 @@ extern void fsnotify_clear_marks_by_inode(struct
inode *inode);
  * about events that happen to its children.
  */
 extern void __fsnotify_update_child_dentry_flags(struct inode *inode);
+/* same here for tree watches */
 
 /* allocate and destroy and event holder to attach events to
notification/access queues */ extern struct fsnotify_event_holder
*fsnotify_alloc_event_holder(void); diff --git a/fs/notify/inode_mark.c
b/fs/notify/inode_mark.c index 3165d85..67ad9cb 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -124,16 +124,31 @@ static void
fsnotify_recalc_inode_mask_locked(struct inode *inode) }
 
 /*
+ * updates the descents as needed
+ */
+static void fsnotify_update_descents_as_needed(struct inode *inode,
bool tree) +{
+	if (tree) {
+		struct dentry *dentry;
+		list_for_each_entry(dentry, &inode->i_dentry, d_alias)
{
+			__fsnotify_update_descents(dentry, true);
+		}
+	} else {
+		__fsnotify_update_child_dentry_flags(inode);
+	}
+}
+
+/*
  * Recalculate the inode->i_fsnotify_mask, or the mask of all FS_*
event types
  * any notifier is interested in hearing for this inode.
  */
-void fsnotify_recalc_inode_mask(struct inode *inode)
+void fsnotify_recalc_inode_mask(struct inode *inode, bool tree)
 {
 	spin_lock(&inode->i_lock);
 	fsnotify_recalc_inode_mask_locked(inode);
 	spin_unlock(&inode->i_lock);
 
-	__fsnotify_update_child_dentry_flags(inode);
+	fsnotify_update_descents_as_needed(inode, tree);
 }
 
 /*
@@ -180,6 +195,12 @@ void fsnotify_destroy_mark_by_entry(struct
fsnotify_mark_entry *entry)
 	 * inode->i_fsnotify_mask
 	 */
 	fsnotify_recalc_inode_mask_locked(inode);
+	if ((entry->mask & ~inode->i_fsnotify_mask) &
FS_EVENT_ON_DESCENT) {
+		struct dentry *dentry;
+		list_for_each_entry(dentry, &inode->i_dentry, d_alias)
{
+			__fsnotify_update_descents(dentry, true);
+		}
+	}
 
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&group->mark_lock);
@@ -195,14 +216,16 @@ void fsnotify_destroy_mark_by_entry(struct
fsnotify_mark_entry *entry) 
 	/*
 	 * __fsnotify_update_child_dentry_flags(inode);
+	 * or __fsnotify_update_descents;
 	 *
 	 * I really want to call that, but we can't, we have no idea
if the inode
 	 * still exists the second we drop the entry->lock.
 	 *
 	 * The next time an event arrive to this inode from one of
it's children
-	 * __fsnotify_parent will see that the inode doesn't care
about it's
-	 * children and will update all of these flags then.  So
really this
-	 * is just a lazy update (and could be a perf win...)
+	 * __fsnotify_ancestors resp. fsnotify_far_ancestors will see
that the
+	 * inode doesn't care about it's children and will update all
of these
+	 * flags then.  So really this is just a lazy update (and
could be a
+	 * perf win...)
 	 */
 
 
@@ -336,6 +359,17 @@ int fsnotify_add_mark(struct fsnotify_mark_entry
*entry, 
 		atomic_inc(&group->num_marks);
 
+		if (entry->mask & FS_EVENT_ON_DESCENT) {
+			struct dentry *dentry;
+
+			/*
+			 * as this is supposed to be a directory, this
should only loop once
+			 * but it actually doesn't matter if Mr. Evil
gives a file as input
+			 */
+			list_for_each_entry(dentry, &inode->i_dentry,
d_alias) {
+				__fsnotify_update_dcache_flags(dentry);
+			}
+		}
 		fsnotify_recalc_inode_mask_locked(inode);
 	}
 
@@ -348,7 +382,7 @@ int fsnotify_add_mark(struct fsnotify_mark_entry
*entry, iput(inode);
 		fsnotify_put_mark(lentry);
 	} else {
-		__fsnotify_update_child_dentry_flags(inode);
+		fsnotify_update_descents_as_needed(inode, entry->mask
& FS_EVENT_ON_DESCENT); }
 
 	return ret;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 30b93b2..131b8f9 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -184,7 +184,8 @@ d_iput:		no
no		no       yes 
 #define DCACHE_COOKIE		0x0040	/* For use by
dcookie subsystem */ 
-#define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0080 /* Parent inode
is watched by some fsnotify listener */ +#define
DCACHE_FSNOTIFY_PARENT_WATCHED		0x0080 /* Parent inode is
watched by some fsnotify listener */ +#define
DCACHE_FSNOTIFY_ANCESTOR_WATCHED	0x0100 /* Ancestor inode is
watched by some tree-watching fsnotify listener */ extern spinlock_t
dcache_lock; extern seqlock_t rename_lock; diff --git
a/include/linux/fsnotify.h b/include/linux/fsnotify.h index
936f9aa..4946243 100644 --- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -16,6 +16,14 @@
 #include <linux/fsnotify_backend.h>
 #include <linux/audit.h>
 
+/* Wrapper for fsnotify_far_ancestors, getting the dentries' name */
+static inline void fsnotify_far_ancestors_getinfo(struct dentry
*dentry, __u32 mask) +{
+	const char *name = dentry->d_name.name;
+	const int len = dentry->d_name.len;
+	fsnotify_far_ancestors(dentry->d_parent, name, len, mask);
+}
+
 /*
  * fsnotify_d_instantiate - instantiate a dentry for inode
  * Called with dcache_lock held.
@@ -28,10 +36,10 @@ static inline void fsnotify_d_instantiate(struct
dentry *entry, inotify_d_instantiate(entry, inode);
 }
 
-/* Notify this dentry's parent about a child's events. */
-static inline void fsnotify_parent(struct dentry *dentry, __u32 mask)
+/* Notify this dentry's ancestors about a child's events. */
+static inline void fsnotify_ancestors(struct dentry *dentry, __u32
mask) {
-	__fsnotify_parent(dentry, mask);
+	__fsnotify_ancestors(dentry, mask);
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0,
dentry->d_name.name); }
@@ -46,7 +54,8 @@ static inline void fsnotify_d_move(struct dentry
*entry)
 	 * On move we need to update entry->d_flags to indicate if the
new parent
 	 * cares about events from this entry.
 	 */
-	__fsnotify_update_dcache_flags(entry);
+	 __fsnotify_update_dcache_flags(entry);
+	 __fsnotify_update_descents(entry, false);
 
 	inotify_d_move(entry);
 }
@@ -64,15 +73,16 @@ static inline void fsnotify_link_count(struct inode
*inode) /*
  * fsnotify_move - file old_name at old_dir was moved to new_name at
new_dir */
-static inline void fsnotify_move(struct inode *old_dir, struct inode
*new_dir,
-				 const char *old_name, const char
*new_name, +static inline void fsnotify_move(struct inode *old_dir,
const char *old_name, int old_len,
+				 struct inode *new_dir, const char
*new_name, int new_len, int isdir, struct inode *target, struct dentry
*moved) {
+	struct dentry *alias;
 	struct inode *source = moved->d_inode;
 	u32 in_cookie = inotify_get_cookie();
 	u32 fs_cookie = fsnotify_get_cookie();
-	__u32 old_dir_mask = (FS_EVENT_ON_CHILD | FS_MOVED_FROM);
-	__u32 new_dir_mask = (FS_EVENT_ON_CHILD | FS_MOVED_TO);
+	__u32 old_dir_mask = FS_EVENT_ON_TREE | FS_MOVED_FROM;
+	__u32 new_dir_mask = FS_EVENT_ON_TREE | FS_MOVED_TO;
 
 	if (old_dir == new_dir)
 		old_dir_mask |= FS_DN_RENAME;
@@ -88,6 +98,14 @@ static inline void fsnotify_move(struct inode
*old_dir, struct inode *new_dir, inotify_inode_queue_event(new_dir,
IN_MOVED_TO|isdir, in_cookie, new_name, source);
 
+	list_for_each_entry(alias, &new_dir->i_dentry, d_alias) {
+		fsnotify_far_ancestors(alias, new_name, new_len,
new_dir_mask);
+	}
+
+	list_for_each_entry(alias, &old_dir->i_dentry, d_alias) {
+		fsnotify_far_ancestors(alias, old_name, old_len,
old_dir_mask);
+	}
+
 	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE,
old_name, fs_cookie); fsnotify(new_dir, new_dir_mask, new_dir,
FSNOTIFY_EVENT_INODE, new_name, fs_cookie); 
@@ -124,7 +142,7 @@ static inline void fsnotify_nameremove(struct
dentry *dentry, int isdir) if (isdir)
 		mask |= FS_IN_ISDIR;
 
-	fsnotify_parent(dentry, mask);
+	fsnotify_ancestors(dentry, mask);
 }
 
 /*
@@ -148,6 +166,7 @@ static inline void fsnotify_create(struct inode
*inode, struct dentry *dentry) dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
+	fsnotify_far_ancestors_getinfo(dentry, FS_CREATE);
 	fsnotify(inode, FS_CREATE, dentry->d_inode,
FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0); }
 
@@ -158,12 +177,13 @@ static inline void fsnotify_create(struct inode
*inode, struct dentry *dentry) */
 static inline void fsnotify_link(struct inode *dir, struct inode
*inode, struct dentry *new_dentry) {
+	fsnotify_far_ancestors_getinfo(new_dentry, IN_CREATE);
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE,
new_dentry->d_name.name, 0); +
 	inotify_inode_queue_event(dir, IN_CREATE, 0,
new_dentry->d_name.name, inode);
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
-
-	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE,
new_dentry->d_name.name, 0); }
 
 /*
@@ -177,6 +197,7 @@ static inline void fsnotify_mkdir(struct inode
*inode, struct dentry *dentry) inotify_inode_queue_event(inode, mask,
0, dentry->d_name.name, d_inode);
audit_inode_child(dentry->d_name.name, dentry, inode); 
+	fsnotify_far_ancestors_getinfo(dentry, mask);
 	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE,
dentry->d_name.name, 0); }
 
@@ -193,7 +214,7 @@ static inline void fsnotify_access(struct dentry
*dentry) 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(dentry, mask);
+	fsnotify_ancestors(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
@@ -210,7 +231,7 @@ static inline void fsnotify_modify(struct dentry
*dentry) 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(dentry, mask);
+	fsnotify_ancestors(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
@@ -227,7 +248,7 @@ static inline void fsnotify_open(struct dentry
*dentry) 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(dentry, mask);
+	fsnotify_ancestors(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
@@ -246,7 +267,7 @@ static inline void fsnotify_close(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(dentry, mask);
+	fsnotify_ancestors(dentry, mask);
 	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
@@ -263,7 +284,7 @@ static inline void fsnotify_xattr(struct dentry
*dentry) 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(dentry, mask);
+	fsnotify_ancestors(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
@@ -299,7 +320,7 @@ static inline void fsnotify_change(struct dentry
*dentry, unsigned int ia_valid) mask |= FS_IN_ISDIR;
 		inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-		fsnotify_parent(dentry, mask);
+		fsnotify_ancestors(dentry, mask);
 		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE,
NULL, 0); }
 }
diff --git a/include/linux/fsnotify_backend.h
b/include/linux/fsnotify_backend.h index 4d6f47b..1bea473 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -48,8 +48,12 @@
 #define FS_DN_MULTISHOT		0x20000000	/* dnotify
multishot */ 
 /* This inode cares about things that happen to its children.  Always
set for
- * dnotify and inotify. */
+ * dnotify. */
 #define FS_EVENT_ON_CHILD	0x08000000
+/* This inode cares about things that happen to some of its descents.
*/ +#define FS_EVENT_ON_DESCENT	0x10000000
+
+#define FS_EVENT_ON_TREE	(FS_EVENT_ON_CHILD|FS_EVENT_ON_DESCENT)
 
 /* This is a list of all events that may get sent to a parernt based
on fs event
  * happening to inodes inside that directory */
@@ -254,20 +258,32 @@ struct fsnotify_mark_entry {
 /* main fsnotify call to send events */
 extern void fsnotify(struct inode *to_tell, __u32 mask, void *data,
int data_is, const char *name, u32 cookie);
-extern void __fsnotify_parent(struct dentry *dentry, __u32 mask);
+extern void __fsnotify_ancestors(struct dentry *dentry, __u32 mask);
+extern void fsnotify_far_ancestors(struct dentry *dentry, const
unsigned char *file_name, int file_len, __u32 mask); extern void
__fsnotify_inode_delete(struct inode *inode); +extern void
__fsnotify_update_descents(struct dentry *dentry, bool lock); extern
u32 fsnotify_get_cookie(void); 
-static inline int fsnotify_inode_watches_children(struct inode *inode)
+static inline bool fsnotify_inode_watches_something(struct inode
*inode, u32 what) {
-	/* FS_EVENT_ON_CHILD is set if the inode may care */
-	if (!(inode->i_fsnotify_mask & FS_EVENT_ON_CHILD))
+	/* what is set if the inode may care */
+	if (!(inode->i_fsnotify_mask & what))
 		return 0;
 	/* this inode might care about child events, does it care
about the
 	 * specific set of events that can happen on a child? */
 	return inode->i_fsnotify_mask & FS_EVENTS_POSS_ON_CHILD;
 }
 
+static inline bool fsnotify_inode_watches_children(struct inode *inode)
+{
+	return fsnotify_inode_watches_something(inode,
FS_EVENT_ON_CHILD); +}
+
+static inline bool fsnotify_inode_watches_descents(struct inode *inode)
+{
+	return fsnotify_inode_watches_something(inode,
FS_EVENT_ON_DESCENT); +}
+
 /*
  * Update the dentry with a flag indicating the interest of its parent
to receive
  * filesystem events when those events happens to this dentry->d_inode.
@@ -275,15 +291,22 @@ static inline int
fsnotify_inode_watches_children(struct inode *inode) static inline void
__fsnotify_update_dcache_flags(struct dentry *dentry) {
 	struct dentry *parent;
-
-	assert_spin_locked(&dcache_lock);
-	assert_spin_locked(&dentry->d_lock);
+	struct inode *p_inode;
 
 	parent = dentry->d_parent;
-	if (parent->d_inode &&
fsnotify_inode_watches_children(parent->d_inode))
-		dentry->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
-	else
-		dentry->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
+	p_inode = parent->d_inode;
+
+	if (p_inode) {
+		if (fsnotify_inode_watches_descents(p_inode) ||
(parent->d_flags & DCACHE_FSNOTIFY_ANCESTOR_WATCHED))
+			dentry->d_flags |=
DCACHE_FSNOTIFY_ANCESTOR_WATCHED;
+		else
+			dentry->d_flags &=
~DCACHE_FSNOTIFY_ANCESTOR_WATCHED; +
+		if (fsnotify_inode_watches_children(p_inode))
+			dentry->d_flags |=
DCACHE_FSNOTIFY_PARENT_WATCHED;
+		else
+			dentry->d_flags &=
~DCACHE_FSNOTIFY_PARENT_WATCHED;
+	}
 }
 
 /*
@@ -335,7 +358,7 @@ extern struct fsnotify_event
*fsnotify_remove_notify_event(struct fsnotify_group /* functions used
to manipulate the marks attached to inodes */ 
 /* run all marks associated with an inode and update
inode->i_fsnotify_mask */ -extern void
fsnotify_recalc_inode_mask(struct inode *inode); +extern void
fsnotify_recalc_inode_mask(struct inode *inode, bool tree); extern void
fsnotify_init_mark(struct fsnotify_mark_entry *entry, void
(*free_mark)(struct fsnotify_mark_entry *entry)); /* find (and take a
reference) to a mark associated with group and inode */ extern struct
fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group
*group, struct inode *inode); @@ -360,7 +383,7 @@ static inline void
fsnotify(struct inode *to_tell, __u32 mask, void *data, int d const
char *name, u32 cookie) {} -static inline void __fsnotify_parent(struct
dentry *dentry, __u32 mask) +static inline void
__fsnotify_ancestors(struct dentry *dentry, __u32 mask) {}
 
 static inline void __fsnotify_inode_delete(struct inode *inode)
