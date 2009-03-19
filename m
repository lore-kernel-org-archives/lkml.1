Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbZCSSI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbZCSSI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbZCSSHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:07:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46011 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095AbZCSSHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:07:06 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 05/13] fsnotify: parent event notification
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Thu, 19 Mar 2009 14:05:19 -0400
Message-ID: <20090319180519.17449.32696.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify and dnotify both use a similar parent notification mechanism.  We
add a generic parent notification mechanism to fsnotify for both of these
to use.  This new machanism also adds the dentry flag optimization which
exists for inotify to dnotify.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inode_mark.c           |   48 +++++++++++++++++++++++++++++++++
 include/linux/dcache.h           |    3 +-
 include/linux/fsnotify.h         |   56 ++++++++++++++++++++++++++++++++++++--
 include/linux/fsnotify_backend.h |   43 +++++++++++++++++++++++++++++
 4 files changed, 146 insertions(+), 4 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index facd561..144b09a 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -41,6 +41,48 @@ void fsnotify_put_mark(struct fsnotify_mark_entry *entry)
 }
 
 /*
+ * Given an inode, first check if we care what happens to out children.  Inotify
+ * and dnotify both tell their parents about events.  If we care about any event
+ * on a child we run all of our children and set a dentry flag saying that the
+ * parent cares.  Thus when an event happens on a child it can quickly tell if
+ * if there is a need to find a parent and send the event to the parent.
+ */
+static inline void fsnotify_update_dentry_child_flags(struct inode *inode)
+{
+	struct dentry *alias;
+	int watched;
+
+	if (!S_ISDIR(inode->i_mode))
+		return;
+
+	/* determine if the children should tell inode about their events */
+	watched = fsnotify_inode_watches_children(inode);
+
+	spin_lock(&dcache_lock);
+	/* run all of the dentries associated with this inode.  Since this is a
+	 * directory, there damn well better only be one item on this list */
+	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
+		struct dentry *child;
+
+		/* run all of the children of the original inode and fix their
+		 * d_flags to indicate parental interest (their parent is the
+		 * original inode) */
+		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
+			if (!child->d_inode)
+				continue;
+
+			spin_lock(&child->d_lock);
+			if (watched)
+				child->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
+			else
+				child->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
+			spin_unlock(&child->d_lock);
+		}
+	}
+	spin_unlock(&dcache_lock);
+}
+
+/*
  * recalculate the mask of events relevant to a given inode locked.
  */
 static void fsnotify_recalc_inode_mask_locked(struct inode *inode)
@@ -65,6 +107,8 @@ void fsnotify_recalc_inode_mask(struct inode *inode)
 	spin_lock(&inode->i_lock);
 	fsnotify_recalc_inode_mask_locked(inode);
 	spin_unlock(&inode->i_lock);
+
+	fsnotify_update_dentry_child_flags(inode);
 }
 
 /*
@@ -113,6 +157,8 @@ void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
 	spin_unlock(&entry->lock);
 
 	group->ops->freeing_mark(entry, group);
+
+	fsnotify_update_dentry_child_flags(inode);
 }
 
 void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
@@ -218,6 +264,8 @@ int fsnotify_add_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *
 	if (lentry) {
 		ret = -EEXIST;
 		fsnotify_put_mark(lentry);
+	} else {
+		fsnotify_update_dentry_child_flags(inode);
 	}
 
 	return ret;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index c66d224..2b935f2 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -180,7 +180,8 @@ d_iput:		no		no		no       yes
 #define DCACHE_REFERENCED	0x0008  /* Recently used, don't discard. */
 #define DCACHE_UNHASHED		0x0010	
 
-#define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched */
+#define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched by inotify */
+#define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0040 /* Parent inode is watched by some fsnotify listener */
 
 #define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 4e04ab2..7b45f29 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -20,10 +20,43 @@
  * fsnotify_d_instantiate - instantiate a dentry for inode
  * Called with dcache_lock held.
  */
-static inline void fsnotify_d_instantiate(struct dentry *entry,
-						struct inode *inode)
+static inline void fsnotify_d_instantiate(struct dentry *dentry, struct inode *inode)
 {
-	inotify_d_instantiate(entry, inode);
+	__fsnotify_d_instantiate(dentry, inode);
+
+	/* call the legacy inotify shit */
+	inotify_d_instantiate(dentry, inode);
+}
+
+/* Notify this dentry's parent about a child's events. */
+static inline void fsnotify_parent(struct dentry *dentry, __u32 mask)
+{
+	struct dentry *parent;
+	struct inode *p_inode;
+	char send = 0;
+
+	if (!(dentry->d_flags | DCACHE_FSNOTIFY_PARENT_WATCHED))
+		return;
+
+	/* we are notifying a parent so come up with the new mask which
+	 * specifies these are events which came from a child. */
+	mask |= FS_EVENT_ON_CHILD;
+
+	spin_lock(&dentry->d_lock);
+	parent = dentry->d_parent;
+	p_inode = parent->d_inode;
+
+	if (p_inode->i_fsnotify_mask & mask) {
+		dget(parent);
+		send = 1;
+	}
+
+	spin_unlock(&dentry->d_lock);
+
+	if (send) {
+		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+		dput(parent);
+	}
 }
 
 /*
@@ -32,6 +65,14 @@ static inline void fsnotify_d_instantiate(struct dentry *entry,
  */
 static inline void fsnotify_d_move(struct dentry *entry)
 {
+	struct dentry *parent;
+
+	parent = entry->d_parent;
+	if (fsnotify_inode_watches_children(parent->d_inode))
+		entry->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
+	else
+		entry->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
+
 	inotify_d_move(entry);
 }
 
@@ -113,6 +154,8 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 		isdir = FS_IN_ISDIR;
 	dnotify_parent(dentry, DN_DELETE);
 	inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir, 0, dentry->d_name.name);
+
+	fsnotify_parent(dentry, FS_DELETE|isdir);
 }
 
 /*
@@ -182,6 +225,7 @@ static inline void fsnotify_access(struct dentry *dentry)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -200,6 +244,7 @@ static inline void fsnotify_modify(struct dentry *dentry)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -217,6 +262,7 @@ static inline void fsnotify_open(struct dentry *dentry)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -237,6 +283,7 @@ static inline void fsnotify_close(struct file *file)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
 }
 
@@ -254,6 +301,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -304,6 +352,8 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 		inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
 		inotify_dentry_parent_queue_event(dentry, in_mask, 0,
 						  dentry->d_name.name);
+
+		fsnotify_parent(dentry, in_mask);
 		fsnotify(inode, in_mask, inode, FSNOTIFY_EVENT_INODE);
 	}
 }
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 605c79e..aa8a3ea 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -45,8 +45,17 @@
 #define FS_DN_RENAME		0x10000000ul	/* file renamed */
 #define FS_DN_MULTISHOT		0x20000000ul	/* dnotify multishot */
 
+/* this inode cares about things that happen to it's children.  Always set for
+ * dnotify and inotify.  never set for fanotify */
 #define FS_EVENT_ON_CHILD	0x08000000ul
 
+/* this is a list of all events that may get sent to a parernt based on fs event
+ * happening to inodes inside that directory */
+#define FS_EVENTS_POSS_ON_CHILD   (FS_ACCESS | FS_MODIFY | FS_ATTRIB |\
+				   FS_CLOSE_WRITE | FS_CLOSE_NOWRITE | FS_OPEN |\
+				   FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE |\
+				   FS_DELETE)
+
 struct fsnotify_group;
 struct fsnotify_event;
 struct fsnotify_mark_entry;
@@ -151,6 +160,37 @@ struct fsnotify_mark_entry {
 extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is);
 extern void __fsnotify_inode_delete(struct inode *inode);
 
+static inline int fsnotify_inode_watches_children(struct inode *inode)
+{
+	/* FS_EVENT_ON_CHILD is set if the inode may care */
+	if (!(inode->i_fsnotify_mask & FS_EVENT_ON_CHILD))
+		return 0;
+	/* this inode might care about child events, does it care about the
+	 * specific set of events that can happen on a child? */
+	return inode->i_fsnotify_mask & FS_EVENTS_POSS_ON_CHILD;
+}
+
+/*
+ * fsnotify_d_instantiate - instantiate a dentry for inode
+ * Called with dcache_lock held.
+ */
+static inline void __fsnotify_d_instantiate(struct dentry *dentry, struct inode *inode)
+{
+	struct dentry *parent;
+	struct inode *p_inode;
+
+	if (!inode)
+		return;
+
+	spin_lock(&dentry->d_lock);
+	parent = dentry->d_parent;
+	p_inode = parent->d_inode;
+
+	if (fsnotify_inode_watches_children(p_inode))
+		dentry->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
+	spin_unlock(&dentry->d_lock);
+}
+
 /* called from fsnotify interfaces, such as fanotify or dnotify */
 extern void fsnotify_recalc_global_mask(void);
 extern void fsnotify_recalc_group_mask(struct fsnotify_group *group);
@@ -182,6 +222,9 @@ static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int d
 static inline void __fsnotify_inode_delete(struct inode *inode)
 {}
 
+static inline void __fsnotify_d_instantiate(struct dentry *dentry, struct inode *inode)
+{}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */

