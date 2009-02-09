Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZBIVRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZBIVRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbZBIVQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:16:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36402 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbZBIVQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:16:35 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v1 04/11] fsnotify: parent event notification
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       malware-list@lists.printk.net, akpm@linux-foundation.org
Date: Mon, 09 Feb 2009 16:15:43 -0500
Message-ID: <20090209211543.8985.80614.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
References: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
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

 fs/notify/inode_mark.c           |    4 +
 include/linux/dcache.h           |    3 +
 include/linux/fsnotify.h         |  111 +++++++++++++++++++++++++++++++++++++-
 include/linux/fsnotify_backend.h |    5 ++
 4 files changed, 119 insertions(+), 4 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 9a65fbc..840bd91 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -78,6 +78,8 @@ void fsnotify_recalc_inode_mask(struct inode *inode)
 	spin_lock(&inode->i_lock);
 	fsnotify_recalc_inode_mask_locked(inode);
 	spin_unlock(&inode->i_lock);
+
+	fsnotify_update_dentry_child_flags(inode);
 }
 
 void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
@@ -232,6 +234,8 @@ int fsnotify_add_mark(struct fsnotify_mark_entry *entry)
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
index 6ae332f..736bb28 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -16,14 +16,102 @@
 #include <linux/fsnotify_backend.h>
 #include <linux/audit.h>
 
+static inline int fsnotify_inode_watches_children(struct inode *inode)
+{
+	if (inode->i_fsnotify_mask & (FS_EVENTS_WITH_CHILD << 32))
+		return 1;
+	return 0;
+}
+
+/*
+ * Get child dentry flag into synch with parent inode.
+ * Flag should always be clear for negative dentrys.A
+ *
+ * It's possible the flag could lie (false positive).  fsnotify only
+ * automatically updates the flag when a new mark is added.  The flag is NOT
+ * automatically updated when marks are removed because of the horrid tactics
+ * that would be needed to do this.  When we remove marks from an inode we have
+ * no idea if that inode is sticking around aside from holding the i_lock.  We
+ * clearly can't hold the i_lock across this function.  It doesn't really
+ * matter though.  The whole point is just to short cut the parent lookup for
+ * performance.  False positives hurt perf, but they aren't a bad thing.
+ */
+static inline void fsnotify_update_dentry_child_flags(struct inode *inode)
+{
+	struct dentry *alias;
+	int watched = fsnotify_inode_watches_children(inode);
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
+				child->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
+			else
+				child->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
+			spin_unlock(&child->d_lock);
+		}
+	}
+	spin_unlock(&dcache_lock);
+}
+
 /*
  * fsnotify_d_instantiate - instantiate a dentry for inode
  * Called with dcache_lock held.
  */
-static inline void fsnotify_d_instantiate(struct dentry *entry,
-						struct inode *inode)
+static inline void fsnotify_d_instantiate(struct dentry *dentry, struct inode *inode)
 {
-	inotify_d_instantiate(entry, inode);
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
+	if (p_inode && fsnotify_inode_watches_children(p_inode))
+		dentry->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
+	spin_unlock(&dentry->d_lock);
+
+	/* call the legacy inotify shit */
+	inotify_d_instantiate(dentry, inode);
+}
+
+/* Notify this dentry's parent about a child's events. */
+static inline void fsnotify_parent(struct dentry *dentry, __u64 orig_mask)
+{
+	struct dentry *parent;
+	struct inode *p_inode;
+	__u64 mask;
+
+	if (!(dentry->d_flags | DCACHE_FSNOTIFY_PARENT_WATCHED))
+		return;
+
+	/* we are notifying a parent so come up with the new mask which
+	 * specifies these are events which came from a child. */
+	mask = (orig_mask & FS_EVENTS_WITH_CHILD) << 32;
+	/* need to remember if the child was a dir */
+	mask |= (orig_mask & FS_IN_ISDIR);
+
+	spin_lock(&dentry->d_lock);
+	parent = dentry->d_parent;
+	p_inode = parent->d_inode;
+
+	if (p_inode && (p_inode->i_fsnotify_mask & mask)) {
+		dget(parent);
+		spin_unlock(&dentry->d_lock);
+		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+		dput(parent);
+	} else {
+		spin_unlock(&dentry->d_lock);
+	}
 }
 
 /*
@@ -32,6 +120,14 @@ static inline void fsnotify_d_instantiate(struct dentry *entry,
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
 
@@ -96,6 +192,8 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 		isdir = IN_ISDIR;
 	dnotify_parent(dentry, DN_DELETE);
 	inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir, 0, dentry->d_name.name);
+
+	fsnotify_parent(dentry, FS_DELETE|isdir);
 }
 
 /*
@@ -185,6 +283,7 @@ static inline void fsnotify_access(struct dentry *dentry)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -203,6 +302,7 @@ static inline void fsnotify_modify(struct dentry *dentry)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -220,6 +320,7 @@ static inline void fsnotify_open(struct dentry *dentry)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -240,6 +341,7 @@ static inline void fsnotify_close(struct file *file)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
 }
 
@@ -257,6 +359,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -307,6 +410,8 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 		inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
 		inotify_dentry_parent_queue_event(dentry, in_mask, 0,
 						  dentry->d_name.name);
+
+		fsnotify_parent(dentry, in_mask);
 		fsnotify(inode, in_mask, inode, FSNOTIFY_EVENT_INODE);
 	}
 }
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index a9508c5..ad7294f 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -63,6 +63,11 @@
 #define FS_DN_RENAME		0x1000000000000000ull	/* file renamed */
 #define FS_DN_MULTISHOT		0x2000000000000000ull	/* dnotify multishot */
 
+#define FS_EVENTS_WITH_CHILD	(FS_ACCESS | FS_MODIFY | FS_ATTRIB |\
+				 FS_CLOSE_WRITE | FS_CLOSE_NOWRITE | FS_OPEN |\
+				 FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE |\
+				 FS_DELETE)
+
 /* when calling fsnotify tell it if the data is a path or inode */
 #define FSNOTIFY_EVENT_PATH	1
 #define FSNOTIFY_EVENT_INODE	2

