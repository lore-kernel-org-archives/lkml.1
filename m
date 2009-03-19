Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbZCSSKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbZCSSKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758892AbZCSSHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:07:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46032 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758752AbZCSSHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:07:34 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 12/13] fsnotify: handle filesystem unmounts with fsnotify marks
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Thu, 19 Mar 2009 14:05:58 -0400
Message-ID: <20090319180558.17449.24493.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an fs is unmounted with an fsnotify mark entry attached to one of its
inodes we need to destroy that mark entry and we also (like inotify) send
an unmount event.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/inode.c                       |    1 +
 fs/notify/inode_mark.c           |   73 ++++++++++++++++++++++++++++++++++++++
 include/linux/fsnotify_backend.h |    4 ++
 3 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 6a9a98e..7922d0b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -406,6 +406,7 @@ int invalidate_inodes(struct super_block * sb)
 	mutex_lock(&iprune_mutex);
 	spin_lock(&inode_lock);
 	inotify_unmount_inodes(&sb->s_inodes);
+	fsnotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
 	spin_unlock(&inode_lock);
 
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 362b04c..7c07a8a 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/writeback.h> /* for inode_lock */
 
 #include <asm/atomic.h>
 
@@ -277,3 +278,75 @@ int fsnotify_add_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *
 
 	return ret;
 }
+
+/**
+ * fsnotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
+ * @list: list of inodes being unmounted (sb->s_inodes)
+ *
+ * Called with inode_lock held, protecting the unmounting super block's list
+ * of inodes, and with iprune_mutex held, keeping shrink_icache_memory() at bay.
+ * We temporarily drop inode_lock, however, and CAN block.
+ */
+void fsnotify_unmount_inodes(struct list_head *list)
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
+
+		/* In case fsnotify_inode_delete() drops a reference. */
+		if (inode != need_iput_tmp)
+			__iget(inode);
+		else
+			need_iput_tmp = NULL;
+
+		/* In case the dropping of a reference would nuke next_i. */
+		if ((&next_i->i_sb_list != list) &&
+		    atomic_read(&next_i->i_count) &&
+		    !(next_i->i_state & (I_CLEAR | I_FREEING | I_WILL_FREE))) {
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
+		/* for each watch, send FS_UNMOUNT and then remove it */
+		fsnotify(inode, FS_UNMOUNT, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+
+		fsnotify_inode_delete(inode);
+
+		iput(inode);
+
+		spin_lock(&inode_lock);
+	}
+}
+EXPORT_SYMBOL_GPL(fsnotify_unmount_inodes);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b575dd0..82d7e9c 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -264,6 +264,7 @@ extern int fsnotify_add_mark(struct fsnotify_mark_entry *entry, struct fsnotify_
 extern void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry);
 extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
 extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
+extern void fsnotify_unmount_inodes(struct list_head *list);
 
 /* put here because inotify does some weird stuff when destroying watches */
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data,
@@ -286,6 +287,9 @@ static inline u32 fsnotify_get_cookie(void)
 	return 0;
 }
 
+static inline void fsnotify_unmount_inodes(struct list_head *list)
+{}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */

