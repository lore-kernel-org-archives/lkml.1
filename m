Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbXHKGO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbXHKGO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 02:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXHKGOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 02:14:16 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44418 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751380AbXHKGOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 02:14:12 -0400
Message-ID: <386812847.08725@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 11 Aug 2007 14:14:07 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Ken Chen <kenchen@google.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] writeback dirty inodes fixes
Message-ID: <20070811061406.GA32051@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	Ken Chen <kenchen@google.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20070811060202.690651223@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20070811060202.690651223@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 11, 2007 at 02:02:02PM +0800, Fengguang Wu wrote:
> Andrew,
> 
> Now the patches are simplified and rebased to 2.6.23-rc2-mm2.
> 
> The following two patches should be put immediately after
> writeback-fix-periodic-superblock-dirty-inode-flushing.patch:
> 
>  writeback: fix time ordering of the per superblock inode lists 8   
>  writeback: fix ntfs with sb_has_dirty_inodes()                     

The following tree patches should be updated to resolve merge conflicts:

        sync_sb_inodes-propagate-errors.patch 
        reiser4-sb_sync_inodes.patch
        check_dirty_inode_list.patch (extended to check s_io/s_more_io)

They are attached in this mail.

--/04w6evG8XlLl3ft
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="sync_sb_inodes-propagate-errors.patch"

From: Andrew Morton <akpm@osdl.org>

Guillame points out that sync_sb_inodes() is failing to propagate error codes
back.  Fix that, and make several other void-returning functions not drop
reportable error codes.

Cc: Guillaume Chazarain <guichaz@yahoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |   56 +++++++++++++++++++++++++++---------
 include/linux/writeback.h |    6 +--
 2 files changed, 45 insertions(+), 17 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc2-mm2/fs/fs-writeback.c
@@ -392,13 +392,17 @@ __writeback_single_inode(struct inode *i
  * on the writer throttling path, and we get decent balancing between many
  * throttled threads: we don't want them all piling up on inode_sync_wait.
  */
-static void
+static int
 sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 {
+	int ret = 0;
+
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
 		queue_io(sb, wbc->older_than_this);
 
 	while (!list_empty(&sb->s_io)) {
+		int err;
+
 		struct inode *inode = list_entry(sb->s_io.prev,
 						struct inode, i_list);
 		struct address_space *mapping = inode->i_mapping;
@@ -444,7 +448,9 @@ sync_sb_inodes(struct super_block *sb, s
 		BUG_ON(inode->i_state & I_FREEING);
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
-		__writeback_single_inode(inode, wbc);
+		err = __writeback_single_inode(inode, wbc);
+		if (!ret)
+			ret = err;
 		if (wbc->sync_mode == WB_SYNC_HOLD) {
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &sb->s_dirty);
@@ -469,7 +475,7 @@ sync_sb_inodes(struct super_block *sb, s
 	if (list_empty(&sb->s_io))
 		list_splice_init(&sb->s_more_io, &sb->s_io);
 
-	return;		/* Leave any unwritten inodes on s_io */
+	return ret;		/* Leave any unwritten inodes on s_io */
 }
 
 /*
@@ -491,10 +497,10 @@ sync_sb_inodes(struct super_block *sb, s
  * sync_sb_inodes will seekout the blockdev which matches `bdi'.  Maybe not
  * super-efficient but we're about to do a ton of I/O...
  */
-void
-writeback_inodes(struct writeback_control *wbc)
+int writeback_inodes(struct writeback_control *wbc)
 {
 	struct super_block *sb;
+	int ret = 0;
 
 	might_sleep();
 	spin_lock(&sb_lock);
@@ -512,9 +518,13 @@ restart:
 			 */
 			if (down_read_trylock(&sb->s_umount)) {
 				if (sb->s_root) {
+					int err;
+
 					spin_lock(&inode_lock);
-					sync_sb_inodes(sb, wbc);
+					err = sync_sb_inodes(sb, wbc);
 					spin_unlock(&inode_lock);
+					if (!ret)
+						ret = err;
 				}
 				up_read(&sb->s_umount);
 			}
@@ -526,6 +536,7 @@ restart:
 			break;
 	}
 	spin_unlock(&sb_lock);
+	return ret;
 }
 
 /*
@@ -539,7 +550,7 @@ restart:
  * We add in the number of potentially dirty inodes, because each inode write
  * can dirty pagecache in the underlying blockdev.
  */
-void sync_inodes_sb(struct super_block *sb, int wait)
+int sync_inodes_sb(struct super_block *sb, int wait)
 {
 	struct writeback_control wbc = {
 		.sync_mode	= wait ? WB_SYNC_ALL : WB_SYNC_HOLD,
@@ -548,14 +559,16 @@ void sync_inodes_sb(struct super_block *
 	};
 	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
 	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
+	int ret;
 
 	wbc.nr_to_write = nr_dirty + nr_unstable +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused) +
 			nr_dirty + nr_unstable;
 	wbc.nr_to_write += wbc.nr_to_write / 2;		/* Bit more for luck */
 	spin_lock(&inode_lock);
-	sync_sb_inodes(sb, &wbc);
+	ret = sync_sb_inodes(sb, &wbc);
 	spin_unlock(&inode_lock);
+	return ret;
 }
 
 /*
@@ -591,13 +604,16 @@ static void set_sb_syncing(int val)
  * outstanding dirty inodes, the writeback goes block-at-a-time within the
  * filesystem's write_inode().  This is extremely slow.
  */
-static void __sync_inodes(int wait)
+static int __sync_inodes(int wait)
 {
 	struct super_block *sb;
+	int ret = 0;
 
 	spin_lock(&sb_lock);
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
+		int err;
+
 		if (sb->s_syncing)
 			continue;
 		sb->s_syncing = 1;
@@ -605,8 +621,12 @@ restart:
 		spin_unlock(&sb_lock);
 		down_read(&sb->s_umount);
 		if (sb->s_root) {
-			sync_inodes_sb(sb, wait);
-			sync_blockdev(sb->s_bdev);
+			err = sync_inodes_sb(sb, wait);
+			if (!ret)
+				ret = err;
+			err = sync_blockdev(sb->s_bdev);
+			if (!ret)
+				ret = err;
 		}
 		up_read(&sb->s_umount);
 		spin_lock(&sb_lock);
@@ -614,17 +634,25 @@ restart:
 			goto restart;
 	}
 	spin_unlock(&sb_lock);
+	return ret;
 }
 
-void sync_inodes(int wait)
+int sync_inodes(int wait)
 {
+	int ret;
+
 	set_sb_syncing(0);
-	__sync_inodes(0);
+	ret = __sync_inodes(0);
 
 	if (wait) {
+		int err;
+
 		set_sb_syncing(0);
-		__sync_inodes(1);
+		err = __sync_inodes(1);
+		if (!ret)
+			ret = err;
 	}
+	return ret;
 }
 
 /**
--- linux-2.6.23-rc2-mm2.orig/include/linux/writeback.h
+++ linux-2.6.23-rc2-mm2/include/linux/writeback.h
@@ -68,10 +68,10 @@ struct writeback_control {
 /*
  * fs/fs-writeback.c
  */	
-void writeback_inodes(struct writeback_control *wbc);
+int writeback_inodes(struct writeback_control *wbc);
 int inode_wait(void *);
-void sync_inodes_sb(struct super_block *, int wait);
-void sync_inodes(int wait);
+int sync_inodes_sb(struct super_block *, int wait);
+int sync_inodes(int wait);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)

--/04w6evG8XlLl3ft
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="reiser4-sb_sync_inodes.patch"

From: Hans Reiser <reiser@namesys.com>

This patch adds new operation to struct super_operations - sync_inodes,
generic implementaion and changes fs-writeback.c:sync_sb_inodes() to call
filesystem's sync_inodes if it is defined or generic implementaion otherwise. 
This new operation allows filesystem to decide itself what to flush.

Reiser4 flushes dirty pages on basic of atoms, not of inodes.  sync_sb_inodes
used to call address space flushing method (writepages) for every dirty inode.
 For reiser4 it caused having to commit atoms unnecessarily often.  This
turned into substantial slowdown.  Having this method helped to fix that
problem.

Also, make generic_sync_sb_inodes spin lock itself.  It helps reiser4 to
get rid of some oddities.

sync_sb_inodes is always called like:
	spin_lock(&inode_lock);
	sync_sb_inodes(sb, wbc);
	spin_unlock(&inode_lock);
This patch moves spin_lock/spin_unlock down to sync_sb_inodes.

[deweerdt@free.fr: lockdep: unbalance at generic_sync_sb_inodes]

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c  |   31 ++++++++++++++++---------------
 include/linux/fs.h |    3 +++
 2 files changed, 19 insertions(+), 15 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc2-mm2/fs/fs-writeback.c
@@ -375,8 +375,6 @@ __writeback_single_inode(struct inode *i
  * WB_SYNC_HOLD is a hack for sys_sync(): reattach the inode to sb->s_dirty so
  * that it can be located for waiting on in __writeback_single_inode().
  *
- * Called under inode_lock.
- *
  * If `bdi' is non-zero then we're being asked to writeback a specific queue.
  * This function assumes that the blockdev superblock's inodes are backed by
  * a variety of queues, so all inodes are searched.  For other superblocks,
@@ -392,11 +390,13 @@ __writeback_single_inode(struct inode *i
  * on the writer throttling path, and we get decent balancing between many
  * throttled threads: we don't want them all piling up on inode_sync_wait.
  */
-static int
-sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
+int generic_sync_sb_inodes(struct super_block *sb,
+			struct writeback_control *wbc)
 {
 	int ret = 0;
 
+	spin_lock(&inode_lock);
+
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
 		queue_io(sb, wbc->older_than_this);
 
@@ -474,9 +474,18 @@ sync_sb_inodes(struct super_block *sb, s
 
 	if (list_empty(&sb->s_io))
 		list_splice_init(&sb->s_more_io, &sb->s_io);
-
+	spin_unlock(&inode_lock);
 	return ret;		/* Leave any unwritten inodes on s_io */
 }
+EXPORT_SYMBOL(generic_sync_sb_inodes);
+
+static int sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
+{
+	if (sb->s_op->sync_inodes)
+		return sb->s_op->sync_inodes(sb, wbc);
+	else
+		return generic_sync_sb_inodes(sb, wbc);
+}
 
 /*
  * Start writeback of dirty pagecache data against all unlocked inodes.
@@ -518,11 +527,7 @@ restart:
 			 */
 			if (down_read_trylock(&sb->s_umount)) {
 				if (sb->s_root) {
-					int err;
-
-					spin_lock(&inode_lock);
-					err = sync_sb_inodes(sb, wbc);
-					spin_unlock(&inode_lock);
+					int err = sync_sb_inodes(sb, wbc);
 					if (!ret)
 						ret = err;
 				}
@@ -559,16 +564,12 @@ int sync_inodes_sb(struct super_block *s
 	};
 	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
 	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
-	int ret;
 
 	wbc.nr_to_write = nr_dirty + nr_unstable +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused) +
 			nr_dirty + nr_unstable;
 	wbc.nr_to_write += wbc.nr_to_write / 2;		/* Bit more for luck */
-	spin_lock(&inode_lock);
-	ret = sync_sb_inodes(sb, &wbc);
-	spin_unlock(&inode_lock);
-	return ret;
+	return sync_sb_inodes(sb, &wbc);
 }
 
 /*
--- linux-2.6.23-rc2-mm2.orig/include/linux/fs.h
+++ linux-2.6.23-rc2-mm2/include/linux/fs.h
@@ -1260,6 +1260,8 @@ struct super_operations {
 	void (*clear_inode) (struct inode *);
 	void (*umount_begin) (struct vfsmount *, int);
 
+	int (*sync_inodes) (struct super_block *sb,
+				struct writeback_control *wbc);
 	int (*show_options)(struct seq_file *, struct vfsmount *);
 	int (*show_stats)(struct seq_file *, struct vfsmount *);
 #ifdef CONFIG_QUOTA
@@ -1654,6 +1656,7 @@ extern int invalidate_inode_pages2(struc
 extern int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
 extern int write_inode_now(struct inode *, int);
+extern int generic_sync_sb_inodes(struct super_block *, struct writeback_control *);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
 extern int filemap_fdatawait(struct address_space *);

--/04w6evG8XlLl3ft
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="check_dirty_inode_list.patch"

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

 fs/fs-writeback.c         |   79 +++++++++++++++++++++++++++++++++++-
 include/linux/writeback.h |    1 
 kernel/sysctl.c           |    8 +++
 3 files changed, 86 insertions(+), 2 deletions(-)

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
@@ -452,8 +525,10 @@ int generic_sync_sb_inodes(struct super_
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

--/04w6evG8XlLl3ft--

