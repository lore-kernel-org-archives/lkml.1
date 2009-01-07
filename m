Return-Path: <linux-kernel-owner+w=401wt.eu-S1763469AbZAGXQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763469AbZAGXQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932287AbZAGXNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:13:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:46736 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbZAGXN3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:13:29 -0500
Date: Wed, 7 Jan 2009 15:14:22 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: [PATCH 5/7] async: make the final inode deletion an asynchronous
 event
Message-ID: <20090107151422.6fa64ca0@infradead.org>
In-Reply-To: <20090107151151.458333c1@infradead.org>
References: <20090107151151.458333c1@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From efaee192063a54749c56b7383803e16fe553630e Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 6 Jan 2009 07:20:54 -0800
Subject: [PATCH] async: make the final inode deletion an asynchronous event

this makes "rm -rf" on a (names cached) kernel tree go from
11.6 to 8.6 seconds on an ext3 filesystem

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/inode.c         |   20 +++++++++++++-------
 fs/super.c         |   10 ++++++++++
 include/linux/fs.h |    5 +++++
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 7a6e8c2..0013ac1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -22,6 +22,7 @@
 #include <linux/bootmem.h>
 #include <linux/inotify.h>
 #include <linux/mount.h>
+#include <linux/async.h>
 
 /*
  * This is needed for the following functions:
@@ -1138,16 +1139,11 @@ EXPORT_SYMBOL(remove_inode_hash);
  * I_FREEING is set so that no-one will take a new reference to the inode while
  * it is being deleted.
  */
-void generic_delete_inode(struct inode *inode)
+static void generic_delete_inode_async(void *data, async_cookie_t cookie)
 {
+	struct inode *inode = data;
 	const struct super_operations *op = inode->i_sb->s_op;
 
-	list_del_init(&inode->i_list);
-	list_del_init(&inode->i_sb_list);
-	inode->i_state |= I_FREEING;
-	inodes_stat.nr_inodes--;
-	spin_unlock(&inode_lock);
-
 	security_inode_delete(inode);
 
 	if (op->delete_inode) {
@@ -1171,6 +1167,16 @@ void generic_delete_inode(struct inode *inode)
 	destroy_inode(inode);
 }
 
+void generic_delete_inode(struct inode *inode)
+{
+	list_del_init(&inode->i_list);
+	list_del_init(&inode->i_sb_list);
+	inode->i_state |= I_FREEING;
+	inodes_stat.nr_inodes--;
+	spin_unlock(&inode_lock);
+	async_schedule_special(generic_delete_inode_async, inode, &inode->i_sb->s_async_list);
+}
+
 EXPORT_SYMBOL(generic_delete_inode);
 
 static void generic_forget_inode(struct inode *inode)
diff --git a/fs/super.c b/fs/super.c
index ddba069..cb20744 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -38,6 +38,7 @@
 #include <linux/kobject.h>
 #include <linux/mutex.h>
 #include <linux/file.h>
+#include <linux/async.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -71,6 +72,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		INIT_HLIST_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
+		INIT_LIST_HEAD(&s->s_async_list);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
@@ -289,11 +291,18 @@ void generic_shutdown_super(struct super_block *sb)
 {
 	const struct super_operations *sop = sb->s_op;
 
+
 	if (sb->s_root) {
 		shrink_dcache_for_umount(sb);
 		fsync_super(sb);
 		lock_super(sb);
 		sb->s_flags &= ~MS_ACTIVE;
+
+		/*
+		 * wait for asynchronous fs operations to finish before going further
+		 */
+		async_synchronize_full_special(&sb->s_async_list);
+
 		/* bad name - it should be evict_inodes() */
 		invalidate_inodes(sb);
 		lock_kernel();
@@ -449,6 +458,7 @@ void sync_filesystems(int wait)
 		if (sb->s_flags & MS_RDONLY)
 			continue;
 		sb->s_need_sync_fs = 1;
+		async_synchronize_full_special(&sb->s_async_list);
 	}
 
 restart:
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d7eba77..e38a64d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1184,6 +1184,11 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char *s_options;
+
+	/*
+	 * storage for asynchronous operations
+	 */
+	struct list_head s_async_list;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
