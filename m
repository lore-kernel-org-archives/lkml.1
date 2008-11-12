Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYKLQSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYKLQSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYKLQMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:12:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45460 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbYKLQMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:12:45 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 20/21] fanotify: allow fastpath entries to survive inode
	modification
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:12:12 -0500
Message-ID: <20081112161212.25434.9289.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A listener may wish to choose to ignore inodes even if they have been
modified.  Setting a fastpath with FAN_SURVIVE_WRITE in the mask
will cause the fastpath to not be removed on inode modification.  The
only way to clear this fastpath will be to either clear all fastpaths for
the group, have the inode evicted from core, or to destroy the group and
create a new one.  This is useful for things like a DB file where the
scanner will not able or interested in hearing about events even if the
file is modified.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify.c     |    4 ++--
 fs/notify/fanotify.h     |    4 +++-
 fs/notify/fastpath.c     |   36 +++++++++++++++++++++++++++++++++++-
 include/linux/fanotify.h |    3 +++
 4 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify.c b/fs/notify/fanotify.c
index d995c14..aeb2225 100644
--- a/fs/notify/fanotify.c
+++ b/fs/notify/fanotify.c
@@ -40,7 +40,7 @@ void fanotify_inode_delete(struct inode *inode)
 	if (likely(list_empty(&fanotify_groups)))
 		return;
 
-	fanotify_fastpath_clear(inode);
+	fanotify_fastpath_clear(inode, FASTPATH_CLEAR_WRITE);
 }
 EXPORT_SYMBOL_GPL(fanotify_inode_delete);
 
@@ -62,7 +62,7 @@ int fanotify(struct file *file, unsigned int mask)
 		return 0;
 
 	if (mask & FAN_MODIFY)
-		fanotify_fastpath_clear(inode);
+		fanotify_fastpath_clear(inode, FASTPATH_SAVE_WRITE);
 	/*
 	 * SRCU!!  the groups list is very very much read only and the path is
 	 * very hot (assuming something is using fanotify)  Not blocking while
diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index b31e19a..bda16d3 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -96,10 +96,12 @@ extern void fanotify_destroy_event_holder(struct fanotify_event_holder *holder);
 extern __init int fanotify_notification_init(void);
 extern __init int fanotify_notification_uninit(void);
 
+#define FASTPATH_CLEAR_WRITE	0
+#define FASTPATH_SAVE_WRITE	1
 extern void fanotify_fastpath_get(struct fanotify_fastpath_entry *entry);
 extern void fanotify_fastpath_put(struct fanotify_fastpath_entry *entry);
 extern int fanotify_is_fastpath(struct file *file, unsigned int mask, struct fanotify_group *group);
-extern void fanotify_fastpath_clear(struct inode *inode);
+extern void fanotify_fastpath_clear(struct inode *inode, int save_write);
 extern __init int fanotify_fastpath_init(void);
 extern __init int fanotify_fastpath_uninit(void);
 
diff --git a/fs/notify/fastpath.c b/fs/notify/fastpath.c
index c4114af..840754d 100644
--- a/fs/notify/fastpath.c
+++ b/fs/notify/fastpath.c
@@ -118,15 +118,49 @@ void fanotify_fastpath_clear_group(struct fanotify_group *group)
 	mutex_unlock(&group->fastpath_mutex);
 }
 
-void fanotify_fastpath_clear(struct inode *inode)
+void fanotify_fastpath_clear(struct inode *inode, int save_write)
 {
 	struct fanotify_fastpath_entry *entry;
 	struct fanotify_group *group;
+	struct fanotify_fastpath_entry *first_moved = NULL;
 
 	write_lock(&inode->fastpath_rwlock);
 	while (!list_empty(&inode->fastpath_entries)) {
 		entry = list_first_entry(&inode->fastpath_entries, struct fanotify_fastpath_entry, i_list);
 
+		/*
+		 * Basic idea is that we move entries that need to survive
+		 * to the end of the list and stop deleting when we hit the
+		 * first entry we moved to the back.
+		 *
+		 * Be careful though because first_moved could be freed as
+		 * soon as we drop the fastpath_rwlock either because its
+		 * group is being freed or because there was a group wide
+		 * fastpath flush.  So no dereferencing first_moved!
+		 */
+		if ((entry->mask & FAN_SURVIVE_WRITE) && (save_write == FASTPATH_SAVE_WRITE)) {
+			/*
+			 * if this is the first fastpath for this inode that is
+			 * surviving we need to remember it so we know when we
+			 * walked the entire list of fastpaths
+			 */
+			if (!first_moved)
+				first_moved = entry;
+			/*
+			 * If we saved this entry previously and found it on
+			 * the list a second time that means we walked the
+			 * entire list.  So we are finished
+			 */
+			else if (first_moved == entry)
+				break;
+
+			/* We need to kick this inode to the end. */
+			list_move_tail(&entry->i_list, &inode->fastpath_entries);
+
+			/* done with this fastpath, leave the rwlock held */
+			continue;
+		}
+
 		/* make sure the entry survives until off both lists */
 		fanotify_fastpath_get(entry);
 		list_del_init(&entry->i_list);
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 7a7bef6..fdd7a79 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -22,6 +22,9 @@
 #define FAN_ACCESS_EXEC_PERM	0x00000200
 #define FAN_OPEN_PERM		0x00000400
 
+/* any fastpath with this set will not be cleared on inode modification */
+#define FAN_SURVIVE_WRITE	0x00001000
+
 /* FIXME currently Q's have no limit.... */
 #define FAN_Q_OVERFLOW		0x80000000	/* Event queued overflowed */
 

