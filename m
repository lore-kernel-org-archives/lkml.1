Return-Path: <linux-kernel-owner+w=401wt.eu-S933450AbXHLJX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbXHLJX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbXHLJV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:21:29 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37095 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759396AbXHLJVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:21:13 -0400
Message-ID: <386910468.27672@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070812092052.983296733@mail.ustc.edu.cn>
References: <20070812091120.189651872@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 17:11:24 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: "Cc: Ken Chen" <kenchen@google.com>, Mike Waychison <mikew@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/6] check dirty inode list
Content-Disposition: inline; filename=check_dirty_inode_list.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Andrew Morton <akpm@linux-foundation.org>

The per-superblock dirty-inode list super_block.s_dirty is supposed to be
sorted in reverse order of each inode's time-of-first-dirtying.  This is so
that the kupdate function can avoid having to walk all the dirty inodes on the
list: it terminates the search as soon as it finds an inode which was dirtied
less than 30 seconds ago (dirty_expire_centisecs).

We have a bunch of several-year-old bugs which cause that list to not be in
the correct reverse-time-order.  The result of this is that under certain
obscure circumstances, inodes get stuck and basically never get written back. 
It has been reported a couple of times, but nobody really cared much because
most people use ordered-mode journalling filesystems, which take care of the
writeback independently.  Plus we will _eventually_ get onto these inodes even
when the list is out of order, and a /bin/sync will still work OK.

However this is a pretty important data-integrity issue for filesystems such
as ext2.


As preparation for fixing these bugs, this patch adds a pile of fantastically
expensive debugging code which checks the sanity of the s_dirty list all over
the place, so we find out as soon as it goes bad.

The debugging code is controlled by /proc/sys/fs/inode_debug, which defaults
to off.  The debugging will disable itself whenever it detects a misordering,
to avoid log spew.

We can remove all this code later.

Cc: Mike Waychison <mikew@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |   77 ++++++++++++++++++++++++++++++++++++
 include/linux/writeback.h |    1 
 kernel/sysctl.c           |    8 +++
 3 files changed, 86 insertions(+)

--- linux-2.6.23-rc2-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc2-mm2/fs/fs-writeback.c
@@ -24,6 +24,75 @@
 #include <linux/buffer_head.h>
 #include "internal.h"
 
+int sysctl_inode_debug __read_mostly;
+
+static int __check(struct list_head *head, int print_stuff)
+{
+	struct list_head *cursor = head;
+	unsigned long dirtied_when = 0;
+
+	while ((cursor = cursor->prev) != head) {
+		struct inode *inode = list_entry(cursor, struct inode, i_list);
+		if (print_stuff) {
+			printk("%p:%lu\n", inode, inode->dirtied_when);
+		} else {
+			if (dirtied_when &&
+			    time_before(inode->dirtied_when, dirtied_when))
+				return 1;
+			dirtied_when = inode->dirtied_when;
+		}
+	}
+	return 0;
+}
+
+static void __check_dirty_inode_list(struct super_block *sb,
+			struct inode *inode, const char *file, int line)
+{
+	if (!sysctl_inode_debug)
+		return;
+
+	if (__check(&sb->s_dirty, 0)) {
+		sysctl_inode_debug = 0;
+		if (inode)
+			printk("%s:%d: s_dirty got screwed up.  inode=%p:%lu\n",
+					file, line, inode, inode->dirtied_when);
+		else
+			printk("%s:%d: s_dirty got screwed up\n", file, line);
+		__check(&sb->s_dirty, 1);
+	}
+	if (__check(&sb->s_io, 0)) {
+		sysctl_inode_debug = 0;
+		if (inode)
+			printk("%s:%d: s_io got screwed up.  inode=%p:%lu\n",
+					file, line, inode, inode->dirtied_when);
+		else
+			printk("%s:%d: s_io got screwed up\n", file, line);
+		__check(&sb->s_io, 1);
+	}
+	if (__check(&sb->s_more_io, 0)) {
+		sysctl_inode_debug = 0;
+		if (inode)
+			printk("%s:%d: s_more_io got screwed up.  inode=%p:%lu\n",
+					file, line, inode, inode->dirtied_when);
+		else
+			printk("%s:%d: s_more_io got screwed up\n", file, line);
+		__check(&sb->s_more_io, 1);
+	}
+}
+
+#define check_dirty_inode_list(sb)					\
+	do {								\
+		if (unlikely(sysctl_inode_debug))			\
+		__check_dirty_inode_list(sb, NULL, __FILE__, __LINE__);	\
+	} while (0)
+
+#define check_dirty_inode(inode)					\
+	do {								\
+		if (unlikely(sysctl_inode_debug))			\
+			__check_dirty_inode_list(inode->i_sb, inode,	\
+						__FILE__, __LINE__);	\
+	} while (0)
+
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -122,8 +191,10 @@ void __mark_inode_dirty(struct inode *in
 		 * reposition it (that would break s_dirty time-ordering).
 		 */
 		if (!was_dirty) {
+			check_dirty_inode(inode);
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &sb->s_dirty);
+			check_dirty_inode(inode);
 		}
 	}
 out:
@@ -152,6 +223,7 @@ static void redirty_tail(struct inode *i
 {
 	struct super_block *sb = inode->i_sb;
 
+	check_dirty_inode(inode);
 	if (!list_empty(&sb->s_dirty)) {
 		struct inode *tail_inode;
 
@@ -161,6 +233,7 @@ static void redirty_tail(struct inode *i
 			inode->dirtied_when = jiffies;
 	}
 	list_move(&inode->i_list, &sb->s_dirty);
+	check_dirty_inode(inode);
 }
 
 /*
@@ -168,7 +241,9 @@ static void redirty_tail(struct inode *i
  */
 static void requeue_io(struct inode *inode)
 {
+	check_dirty_inode(inode);
 	list_move(&inode->i_list, &inode->i_sb->s_more_io);
+	check_dirty_inode(inode);
 }
 
 static void inode_sync_complete(struct inode *inode)
@@ -463,8 +538,10 @@ int generic_sync_sb_inodes(struct super_
 		if (!ret)
 			ret = err;
 		if (wbc->sync_mode == WB_SYNC_HOLD) {
+			check_dirty_inode(inode);
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &sb->s_dirty);
+			check_dirty_inode(inode);
 		}
 		if (current_is_pdflush())
 			writeback_release(bdi);
--- linux-2.6.23-rc2-mm2.orig/include/linux/writeback.h
+++ linux-2.6.23-rc2-mm2/include/linux/writeback.h
@@ -140,5 +140,6 @@ void writeback_set_ratelimit(void);
 extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
 				   read-only. */
 
+extern int sysctl_inode_debug;
 
 #endif		/* WRITEBACK_H */
--- linux-2.6.23-rc2-mm2.orig/kernel/sysctl.c
+++ linux-2.6.23-rc2-mm2/kernel/sysctl.c
@@ -1238,6 +1238,14 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "inode_debug",
+		.data		= &sysctl_inode_debug,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{
 		.ctl_name	= CTL_UNNUMBERED,

-- 
