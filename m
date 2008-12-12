Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbYLLVyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbYLLVyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYLLVwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:52:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55990 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbYLLVwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:52:10 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH -v4 08/14] fsnotify: parent event notification
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk, hch@infradead.org,
       zbr@ioremap.net, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 12 Dec 2008 16:51:56 -0500
Message-ID: <20081212215156.27112.37786.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
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

 fs/notify/inode_mark.c           |    2 +
 include/linux/dcache.h           |    3 +
 include/linux/fsnotify.h         |  103 +++++++++++++++++++++++++++++++++++++-
 include/linux/fsnotify_backend.h |    5 ++
 4 files changed, 109 insertions(+), 4 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index c68adff..339a368 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -255,6 +255,8 @@ void fsnotify_recalc_inode_mask(struct inode *inode)
 	}
 	inode->i_fsnotify_mask = new_mask;
 	spin_unlock(&inode->i_lock);
+
+	fsnotify_update_dentry_child_flags(inode);
 }
 
 
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index a37359d..2f7f646 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -175,7 +175,8 @@ d_iput:		no		no		no       yes
 #define DCACHE_REFERENCED	0x0008  /* Recently used, don't discard. */
 #define DCACHE_UNHASHED		0x0010	
 
-#define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched */
+#define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched by inotify */
+#define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0040 /* Parent inode is watched by some fsnotify listener */
 
 extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index c2ed916..971ada9 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -16,14 +16,93 @@
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
+ * Flag should always be clear for negative dentrys.
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
+				child->d_flags &=~DCACHE_FSNOTIFY_PARENT_WATCHED;
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
 {
-	inotify_d_instantiate(entry, inode);
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
@@ -32,6 +111,14 @@ static inline void fsnotify_d_instantiate(struct dentry *entry,
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
 
@@ -96,6 +183,8 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 		isdir = IN_ISDIR;
 	dnotify_parent(dentry, DN_DELETE);
 	inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir, 0, dentry->d_name.name);
+
+	fsnotify_parent(dentry, FS_DELETE|isdir);
 }
 
 /*
@@ -186,6 +275,7 @@ static inline void fsnotify_access(struct file *file)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
 }
 
@@ -205,6 +295,7 @@ static inline void fsnotify_modify(struct file *file)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
 }
 
@@ -220,6 +311,7 @@ static inline void fsnotify_open_exec(struct file *file)
 	inotify_dentry_parent_queue_event(dentry, IN_ACCESS, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, IN_ACCESS, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, FS_ACCESS);
 	fsnotify(inode, FS_ACCESS, file, FSNOTIFY_EVENT_FILE);
 }
 
@@ -238,6 +330,7 @@ static inline void fsnotify_open(struct file *file)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
 }
 
@@ -258,6 +351,7 @@ static inline void fsnotify_close(struct file *file)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
 }
 
@@ -275,6 +369,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -325,6 +420,8 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 		inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
 		inotify_dentry_parent_queue_event(dentry, in_mask, 0,
 						  dentry->d_name.name);
+
+		fsnotify_parent(dentry, in_mask);
 		fsnotify(inode, in_mask, inode, FSNOTIFY_EVENT_INODE);
 	}
 }
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 0482a14..3e4ac24 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -65,6 +65,11 @@
 #define FS_DN_RENAME		0x1000000000000000ull	/* file renamed */
 #define FS_DN_MULTISHOT		0x2000000000000000ull	/* dnotify multishot */
 
+#define FS_EVENTS_WITH_CHILD	(FS_ACCESS | FS_MODIFY | FS_ATTRIB |\
+				 FS_CLOSE_WRITE | FS_CLOSE_NOWRITE | FS_OPEN |\
+				 FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE |\
+				 FS_DELETE)
+
 /* when calling fsnotify tell it if the data is a file, dentry, or inode */
 #define FSNOTIFY_EVENT_FILE     1
 #define FSNOTIFY_EVENT_INODE    2

