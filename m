Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbXIZBem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbXIZBem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 21:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbXIZBee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 21:34:34 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33746 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbXIZBec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 21:34:32 -0400
Subject: [RFC] detect missed mnt_want_write() calls
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20070921011706.88e9bcdd.akpm@linux-foundation.org>
References: <20070920195249.852667D5@kernel>
	 <20070920195257.0E38EED5@kernel>
	 <20070921011706.88e9bcdd.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 18:34:24 -0700
Message-Id: <1190770464.26982.337.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 01:17 -0700, Andrew Morton wrote:
> On Thu, 20 Sep 2007 12:52:57 -0700 Dave Hansen <haveblue@us.ibm.com> wrote:
> > +		ret = mnt_want_write(filp->f_vfsmnt);
> 
> It still creeps me out that we have this sprinkled *all over* the tree and
> people will forget to do it and there's no runtime or compile-time checking
> that they remembered to do it and when they forget to do it nobody will
> notice that it broke until ages and ages later.
> 
> IOW: it is a sheer horror for maintainability.
> 
> 
> Please have a think about what we can do about this.  For example, if you'd
> thought about this up-front, (and I think it's a big problem), we could
> have done something grotty like, in mnt_want_write():
> 
> 	current->vfsmnt_im_allowed_to_write_to = inode;
> 
> and then check that current->vfsmnt_im_allowed_to_write_to is the correct
> inode in __mark_inode_dirty() and various other strategic places.  That
> sort of thing.
> 
> 
> We need to do *something*, I think.  This code just doesn't look feasibly
> maintainable to me.

We definitely can't use 'current'-based counts for everything.  For
example, we might take a write on a mnt at a time when a loopback device
is created.  We'll release that write when the device is destroyed, and
these certainly won't always be the same task, or even process.

However, there are preciously few places in the code that actually have
to deal with these long-lived, persistent mount writer counts.  Those
are basically where we're creating a 'struct file' and keeping it around
for a while.

The rest of the calls (95% or so) are much more atomic.  They are much
more like a simple lock/unlock pair, and their references will never
persist beyond a single system call.  These are also very rarely nested
and certainly never deeply nested.

For the "atomic" write counts, I keep track of the mnts on which a
particular task may write.  This is a simple array in the task_struct.
I currently check this array on all task_struct free()s to make sure it
is empty.  We could also do this at all system call exits, but this is
probably unnecessary because that would almost certainly be a
mnt_want_write() leak.

For the persistent users, we actually change the API to be
mnt_want_persistent_write(mnt, inode) to track the mnt and the inode
pair, and we hang the list of these off the superblock.  We could
probably do this universally, but the number of persistent users is
quite small, which reduces the code churn required.  This part of the
patch is not very scalable, so we'd have to rethink this if we want this
functionality for more than debugging.

Did you have this in mind as being a debugging option that we turn on
when we see problems like LOCKDEP, or were you thinking of something
that stays on all the time?  This turned out to be more code than I had
hoped, so I'm very open to suggestions for other approaches.

We also need a thorough review to look for things like
ext3_mark_inode_dirty() since they never actually call down to the
generic vfs mark_inode_dirty().

This is strictly a RFC for now.

---

 lxc-dave/fs/buffer.c                 |   10 ++
 lxc-dave/fs/ext2/super.c             |    2 
 lxc-dave/fs/ext3/balloc.c            |    6 +
 lxc-dave/fs/ext3/inode.c             |    2 
 lxc-dave/fs/ext3/super.c             |    9 ++
 lxc-dave/fs/ext4/inode.c             |    1 
 lxc-dave/fs/file_table.c             |    4 -
 lxc-dave/fs/fs-writeback.c           |   27 ++++++
 lxc-dave/fs/inode.c                  |   17 +++-
 lxc-dave/fs/jbd/journal.c            |    2 
 lxc-dave/fs/jbd/recovery.c           |    2 
 lxc-dave/fs/jbd/transaction.c        |    2 
 lxc-dave/fs/namei.c                  |   11 ++
 lxc-dave/fs/namespace.c              |  136 ++++++++++++++++++++++++++++++++++-
 lxc-dave/fs/ocfs2/inode.c            |    1 
 lxc-dave/fs/super.c                  |    2 
 lxc-dave/include/linux/buffer_head.h |    1 
 lxc-dave/include/linux/file.h        |    1 
 lxc-dave/include/linux/fs.h          |    2 
 lxc-dave/include/linux/mount.h       |   17 ++++
 lxc-dave/include/linux/sched.h       |    2 
 lxc-dave/kernel/fork.c               |   31 +++++++
 22 files changed, 274 insertions(+), 14 deletions(-)

diff -puN fs/buffer.c~debug-missed-mnt_want_writes fs/buffer.c
--- lxc/fs/buffer.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/buffer.c	2007-09-25 15:27:43.000000000 -0700
@@ -1172,6 +1172,16 @@ __getblk_slow(struct block_device *bdev,
  * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
  * mapping->tree_lock and the global inode_lock.
  */
+void fastcall mark_buffer_dirty_nocheck(struct buffer_head *bh)
+{
+	struct i_mnt_pair pair;
+	pair.inode = bh->b_page->mapping->host;
+	pair.mnt = NULL;
+	allow_writes_via_mnt_to(&pair);
+	mark_buffer_dirty(bh);
+	disallow_writes_via_mnt_to(pair.mnt, pair.inode, pair.inode->i_sb);
+}
+
 void fastcall mark_buffer_dirty(struct buffer_head *bh)
 {
 	WARN_ON_ONCE(!buffer_uptodate(bh));
diff -puN fs/ext2/super.c~debug-missed-mnt_want_writes fs/ext2/super.c
--- lxc/fs/ext2/super.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/ext2/super.c	2007-09-25 15:27:43.000000000 -0700
@@ -1372,7 +1372,7 @@ out:
 
 #endif
 
-static struct file_system_type ext2_fs_type = {
+struct file_system_type ext2_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ext2",
 	.get_sb		= ext2_get_sb,
diff -puN fs/ext3/balloc.c~debug-missed-mnt_want_writes fs/ext3/balloc.c
--- lxc/fs/ext3/balloc.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/ext3/balloc.c	2007-09-25 15:27:43.000000000 -0700
@@ -466,6 +466,12 @@ void ext3_free_blocks_sb(handle_t *handl
 	int err = 0, ret;
 	ext3_grpblk_t group_freed;
 
+	/*
+	 * this is a workaround for warnings for now
+	 * to do this properly, we need to take a
+	 * mnt_want_write() when i_nlink goes to 0
+	 * and drop it after iput_final();
+	 */
 	*pdquot_freed_blocks = 0;
 	sbi = EXT3_SB(sb);
 	es = sbi->s_es;
diff -puN fs/ext3/inode.c~debug-missed-mnt_want_writes fs/ext3/inode.c
--- lxc/fs/ext3/inode.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/ext3/inode.c	2007-09-25 15:55:56.000000000 -0700
@@ -1228,7 +1228,6 @@ static int ext3_generic_write_end(struct
 				struct page *page, void *fsdata)
 {
 	struct inode *inode = file->f_mapping->host;
-
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
 
 	if (pos+copied > inode->i_size) {
@@ -3173,6 +3172,7 @@ int ext3_mark_inode_dirty(handle_t *hand
 	int err;
 
 	might_sleep();
+	check_write_ability_to_inode(inode);
 	err = ext3_reserve_inode_write(handle, inode, &iloc);
 	if (!err)
 		err = ext3_mark_iloc_dirty(handle, inode, &iloc);
diff -puN fs/ext3/super.c~debug-missed-mnt_want_writes fs/ext3/super.c
--- lxc/fs/ext3/super.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/ext3/super.c	2007-09-25 15:27:43.000000000 -0700
@@ -1803,7 +1803,9 @@ static int ext3_fill_super (struct super
 	 */
 	if (!test_opt(sb, NOLOAD) &&
 	    EXT3_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
-		if (ext3_load_journal(sb, es, journal_devnum))
+		int jlret;
+		jlret = ext3_load_journal(sb, es, journal_devnum);
+		if (jlret)
 			goto failed_mount3;
 	} else if (journal_inum) {
 		if (ext3_create_journal(sb, es, journal_inum))
@@ -2218,6 +2220,11 @@ static void ext3_commit_super (struct su
 	es->s_free_blocks_count = cpu_to_le32(ext3_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext3_count_free_inodes(sb));
 	BUFFER_TRACE(sbh, "marking dirty");
+	/*
+	 * during a mount operation, it should be OK to be writing
+	 * to the superblock for things like dirty mount bits, even
+	 * if no one else has permissions to write to it.
+	 */
 	mark_buffer_dirty(sbh);
 	if (sync)
 		sync_dirty_buffer(sbh);
diff -puN fs/file_table.c~debug-missed-mnt_want_writes fs/file_table.c
--- lxc/fs/file_table.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/file_table.c	2007-09-25 15:27:43.000000000 -0700
@@ -194,7 +194,7 @@ int init_file(struct file *file, struct 
 	file->f_mode = mode;
 	file->f_op = fop;
 	if (mode & FMODE_WRITE) {
-		error = mnt_want_write(mnt);
+		error = mnt_want_persistent_write(mnt, dentry->d_inode);
 		WARN_ON(error);
 	}
 	return error;
@@ -237,7 +237,7 @@ void fastcall __fput(struct file *file)
 	if (file->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
 		if (!special_file(inode->i_mode))
-			mnt_drop_write(mnt);
+			mnt_drop_persistent_write(mnt, inode);
 	}
 	put_pid(file->f_owner.pid);
 	file_kill(file);
diff -puN fs/fs-writeback.c~debug-missed-mnt_want_writes fs/fs-writeback.c
--- lxc/fs/fs-writeback.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/fs-writeback.c	2007-09-25 16:05:17.000000000 -0700
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/sched.h>
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/writeback.h>
@@ -76,6 +77,31 @@ static void __check_dirty_inode_list(str
 						__FILE__, __LINE__);	\
 	} while (0)
 
+void check_write_ability_to_inode(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	int i;
+	/*
+	 * You do not have to have write access to a mnt to write
+	 * to a device file or something like a named pipe.
+	 */
+	if (special_file(inode->i_mode))
+		return;
+	for (i=0; i < CAN_WRITE_VIA_LEN; i++) {
+		struct vfsmount *mnt = current->can_write_via_mnt[i];
+		if (!mnt)
+			continue;
+		if (sb == mnt->mnt_sb)
+			break;
+	}
+	/*
+	 * found a matching mount in can_write_via_mnt[]
+	 */
+	if (i < CAN_WRITE_VIA_LEN)
+		return;
+	check_sb_for_writable_inode(sb, inode);
+}
+
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -106,6 +132,7 @@ static void __check_dirty_inode_list(str
 void __mark_inode_dirty(struct inode *inode, int flags)
 {
 	struct super_block *sb = inode->i_sb;
+	check_write_ability_to_inode(inode);
 
 	/*
 	 * Don't do this for I_DIRTY_PAGES - that doesn't actually
diff -puN fs/inode.c~debug-missed-mnt_want_writes fs/inode.c
--- lxc/fs/inode.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/inode.c	2007-09-25 15:27:43.000000000 -0700
@@ -1137,15 +1137,28 @@ static inline void iput_final(struct ino
 void iput(struct inode *inode)
 {
 	if (inode) {
-		const struct super_operations *op = inode->i_sb->s_op;
+		struct super_block *sb = inode->i_sb;
+		const struct super_operations *op = sb->s_op;
 
 		BUG_ON(inode->i_state == I_CLEAR);
 
 		if (op && op->put_inode)
 			op->put_inode(inode);
 
-		if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
+		if (atomic_dec_and_lock(&inode->i_count, &inode_lock)) {
+			/*
+			 * this is a workaround for warnings for now
+			 * to do this properly, we need to take a
+			 * mnt_want_write() when i_nlink goes to 0
+			 * and drop it here, after iput_final().
+			 */
+		        struct i_mnt_pair pair; 
+		        pair.inode = inode;
+		        pair.mnt = NULL;
+		        allow_writes_via_mnt_to(&pair);
 			iput_final(inode);
+		        disallow_writes_via_mnt_to(NULL, inode, sb);
+		}
 	}
 }
 
diff -puN fs/jbd/journal.c~debug-missed-mnt_want_writes fs/jbd/journal.c
--- lxc/fs/jbd/journal.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/jbd/journal.c	2007-09-25 15:27:43.000000000 -0700
@@ -957,7 +957,7 @@ void journal_update_superblock(journal_t
 	spin_unlock(&journal->j_state_lock);
 
 	BUFFER_TRACE(bh, "marking dirty");
-	mark_buffer_dirty(bh);
+	mark_buffer_dirty_nocheck(bh);
 	if (wait)
 		sync_dirty_buffer(bh);
 	else
diff -puN fs/jbd/recovery.c~debug-missed-mnt_want_writes fs/jbd/recovery.c
--- lxc/fs/jbd/recovery.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/jbd/recovery.c	2007-09-25 15:27:43.000000000 -0700
@@ -484,7 +484,7 @@ static int do_one_pass(journal_t *journa
 
 					BUFFER_TRACE(nbh, "marking dirty");
 					set_buffer_uptodate(nbh);
-					mark_buffer_dirty(nbh);
+					mark_buffer_dirty_nocheck(nbh);
 					BUFFER_TRACE(nbh, "marking uptodate");
 					++info->nr_replays;
 					/* ll_rw_block(WRITE, 1, &nbh); */
diff -puN fs/jbd/transaction.c~debug-missed-mnt_want_writes fs/jbd/transaction.c
--- lxc/fs/jbd/transaction.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/jbd/transaction.c	2007-09-25 15:27:43.000000000 -0700
@@ -1548,7 +1548,7 @@ static void __journal_temp_unlink_buffer
 	__blist_del_buffer(list, jh);
 	jh->b_jlist = BJ_None;
 	if (test_clear_buffer_jbddirty(bh))
-		mark_buffer_dirty(bh);	/* Expose it to the VM */
+		mark_buffer_dirty_nocheck(bh);	/* Expose it to the VM */
 }
 
 void __journal_unfile_buffer(struct journal_head *jh)
diff -puN fs/namei.c~debug-missed-mnt_want_writes fs/namei.c
--- lxc/fs/namei.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-25 16:24:44.000000000 -0700
@@ -1626,7 +1626,7 @@ int may_open(struct nameidata *nd, int a
 		 * effectively: !special_file()
 		 * balanced by __fput()
 		 */
-		error = mnt_want_write(nd->mnt);
+		error = mnt_want_persistent_write(nd->mnt, inode);
 		if (error)
 			return error;
 	}
@@ -1667,8 +1667,15 @@ int may_open(struct nameidata *nd, int a
 		error = locks_verify_locked(inode);
 		if (!error) {
 			DQUOT_INIT(inode);
-			
+			/* 
+			 * we should have already acquired a persistent write, but
+			 * this acquires an atomic one for us (because the fd
+			 * hasn't been installed yet
+			 */
+			error = mnt_want_write(nd->mnt);		
+			WARN_ON(error);
 			error = do_truncate(dentry, 0, ATTR_MTIME|ATTR_CTIME, NULL);
+			mnt_drop_write(nd->mnt);		
 		}
 		put_write_access(inode);
 		if (error)
diff -puN fs/namespace.c~debug-missed-mnt_want_writes fs/namespace.c
--- lxc/fs/namespace.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/namespace.c	2007-09-25 15:45:06.000000000 -0700
@@ -18,6 +18,7 @@
 #include <linux/acct.h>
 #include <linux/capability.h>
 #include <linux/cpumask.h>
+#include <linux/file.h>
 #include <linux/module.h>
 #include <linux/sysfs.h>
 #include <linux/seq_file.h>
@@ -168,6 +169,8 @@ static inline void use_cpu_writer_for_mo
 	cpu_writer->mnt = mnt;
 }
 
+#define MNT_WRITE_PERSISTENT 1
+#define MNT_WRITE_ATOMIC     2
 /*
  * Most r/o checks on a fs are for operations that take
  * discrete amounts of time, like a write() or unlink().
@@ -186,10 +189,64 @@ static inline void use_cpu_writer_for_mo
  * the write operation is finished, mnt_drop_write()
  * must be called.  This is effectively a refcount.
  */
-int mnt_want_write(struct vfsmount *mnt)
+void check_sb_for_writable_inode(struct super_block *sb, struct inode *inode)
+{
+	int found = 0;
+	struct list_head *p;
+	spin_lock(&sb->s_writable_inodes_lock);
+	list_for_each(p, &sb->s_writable_inodes) {
+		struct i_mnt_pair *pair = 
+			list_entry(p, struct i_mnt_pair, list);
+		if (pair->inode != inode)
+			continue;
+		found = 1;
+	}
+	spin_unlock(&sb->s_writable_inodes_lock);
+	WARN_ON(!found);
+}
+void allow_writes_via_mnt_to(struct i_mnt_pair *pair)
+{
+	struct super_block *sb = pair->inode->i_sb;
+	spin_lock(&sb->s_writable_inodes_lock);
+	list_add(&pair->list, &sb->s_writable_inodes);
+	spin_unlock(&sb->s_writable_inodes_lock);
+}
+/*
+ * unfortunately, we need to pass the sb in here as well.
+ * One of the places we need to do this is near iput_final(),
+ * which means that 'inode' may be freed.  We can view the
+ * pointer to it, but not dereference to get i_sb.
+ */
+struct i_mnt_pair *disallow_writes_via_mnt_to(struct vfsmount *mnt,
+		struct inode *inode, struct super_block *sb)
+{
+	int found = 0;
+	struct list_head *p;
+	struct i_mnt_pair *pair = NULL;
+
+	spin_lock(&sb->s_writable_inodes_lock);
+	list_for_each(p, &sb->s_writable_inodes) {
+		pair = list_entry(p, struct i_mnt_pair, list);
+		if (pair->mnt != mnt || pair->inode != inode)
+			continue;
+		found = 1;
+		list_del(&pair->list);
+		break;
+	}
+	spin_unlock(&sb->s_writable_inodes_lock);
+	if (!found) {
+		WARN_ON(1);
+		return NULL;
+	}
+	return pair;
+}
+int __mnt_want_write(struct vfsmount *mnt, int atomic_or_peristent, struct inode *inode)
 {
 	int ret = 0;
 	struct mnt_writer *cpu_writer;
+	struct i_mnt_pair *pair = kmalloc(sizeof(*pair), GFP_KERNEL);
+	if (!pair)
+		return -ENOMEM;
 
 	cpu_writer = &get_cpu_var(mnt_writers);
 	spin_lock(&cpu_writer->lock);
@@ -199,12 +256,51 @@ int mnt_want_write(struct vfsmount *mnt)
 	}
 	use_cpu_writer_for_mount(cpu_writer, mnt);
 	cpu_writer->count++;
+	if (atomic_or_peristent == MNT_WRITE_ATOMIC) {
+		int i;
+		for (i=0; i < CAN_WRITE_VIA_LEN; i++) {
+			if (i >= 1 && printk_ratelimit()) {
+				printk("%s() saw can_write_via_mnt[%d]: %p\n", __func__, i,
+						current->can_write_via_mnt[i]);
+				dump_stack();
+			}
+			if (current->can_write_via_mnt[i])
+				continue;
+			current->can_write_via_mnt[i] = mnt;
+			break;
+		}
+		WARN_ON(i == CAN_WRITE_VIA_LEN);
+	} else if (atomic_or_peristent == MNT_WRITE_PERSISTENT) {
+		struct super_block *sb = inode->i_sb;
+		pair->mnt = mnt;
+		pair->inode = inode;
+		spin_lock(&sb->s_writable_inodes_lock);
+		list_add(&pair->list, &sb->s_writable_inodes);
+		spin_unlock(&sb->s_writable_inodes_lock);
+		pair = NULL;
+	}
 out:
+	if (pair)
+		kfree(pair);
 	spin_unlock(&cpu_writer->lock);
 	put_cpu_var(mnt_writers);
 	return ret;
 }
+int mnt_want_write(struct vfsmount *mnt)
+{
+	int ret;
+	ret = __mnt_want_write(mnt, MNT_WRITE_ATOMIC, NULL);
+	if (ret)
+		return ret;
+	return ret;
+}
 EXPORT_SYMBOL_GPL(mnt_want_write);
+int mnt_want_persistent_write(struct vfsmount *mnt, struct inode *inode)
+{
+	//printk("%s() mnt: %p '%s' %d\n", __func__, mnt, current->comm, current->pid);
+	return __mnt_want_write(mnt, MNT_WRITE_PERSISTENT, inode);
+}
+EXPORT_SYMBOL_GPL(mnt_want_persistent_write);
 
 static void lock_and_coalesce_cpu_mnt_writer_counts(void)
 {
@@ -248,7 +344,8 @@ static void handle_write_count_underflow
  * performing writes to it.  Must be matched with
  * mnt_want_write() call above.
  */
-void mnt_drop_write(struct vfsmount *mnt)
+void __mnt_drop_write(struct vfsmount *mnt, int atomic_or_peristent,
+		      struct inode *inode)
 {
 	int must_check_underflow = 0;
 	struct mnt_writer *cpu_writer;
@@ -263,6 +360,30 @@ void mnt_drop_write(struct vfsmount *mnt
 		must_check_underflow = 1;
 		atomic_dec(&mnt->__mnt_writers);
 	}
+	if (atomic_or_peristent == MNT_WRITE_ATOMIC) {
+		int i;
+		for (i=0; i < CAN_WRITE_VIA_LEN; i++) {
+			if (current->can_write_via_mnt[i] != mnt)
+				continue;
+			current->can_write_via_mnt[i] = NULL;
+			break;
+		}
+		if (i >= CAN_WRITE_VIA_LEN) {
+			printk("i: %d len: %d mnt: %p\n", i, CAN_WRITE_VIA_LEN, mnt);
+			for (i=0; i < CAN_WRITE_VIA_LEN; i++) {
+				if (!current->can_write_via_mnt[i])
+					continue;
+				printk("current->can_write_via_mnt[%d]: %p\n", i,
+						current->can_write_via_mnt[i]);
+			}
+			WARN_ON(1);
+		}
+	} else if (atomic_or_peristent == MNT_WRITE_PERSISTENT) {
+		struct i_mnt_pair *pair = disallow_writes_via_mnt_to(mnt,
+							inode, inode->i_sb);
+		if (pair)
+			kfree(pair);
+	}
 
 	spin_unlock(&cpu_writer->lock);
 	/*
@@ -282,7 +403,18 @@ void mnt_drop_write(struct vfsmount *mnt
 	 */
 	put_cpu_var(mnt_writers);
 }
+void mnt_drop_write(struct vfsmount *mnt)
+{
+	//printk("%s() mnt: %p '%s' %d\n", __func__, mnt, current->comm, current->pid);
+	__mnt_drop_write(mnt, MNT_WRITE_ATOMIC, NULL);
+}
 EXPORT_SYMBOL_GPL(mnt_drop_write);
+void mnt_drop_persistent_write(struct vfsmount *mnt, struct inode *inode)
+{
+	//printk("%s() mnt: %p '%s' %d\n", __func__, mnt, current->comm, current->pid);
+	__mnt_drop_write(mnt, MNT_WRITE_PERSISTENT, inode);
+}
+EXPORT_SYMBOL_GPL(mnt_drop_persistent_write);
 
 static int mnt_make_readonly(struct vfsmount *mnt)
 {
diff -puN fs/super.c~debug-missed-mnt_want_writes fs/super.c
--- lxc/fs/super.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/fs/super.c	2007-09-25 15:27:43.000000000 -0700
@@ -67,6 +67,8 @@ static struct super_block *alloc_super(s
 		INIT_LIST_HEAD(&s->s_files);
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
+		INIT_LIST_HEAD(&s->s_writable_inodes);
+		spin_lock_init(&s->s_writable_inodes_lock);
 		INIT_LIST_HEAD(&s->s_inodes);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
diff -puN include/linux/buffer_head.h~debug-missed-mnt_want_writes include/linux/buffer_head.h
--- lxc/include/linux/buffer_head.h~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/include/linux/buffer_head.h	2007-09-25 15:27:43.000000000 -0700
@@ -145,6 +145,7 @@ BUFFER_FNS(Unwritten, unwritten)
  */
 
 void FASTCALL(mark_buffer_dirty(struct buffer_head *bh));
+void FASTCALL(mark_buffer_dirty_nocheck(struct buffer_head *bh));
 void init_buffer(struct buffer_head *, bh_end_io_t *, void *);
 void set_bh_page(struct buffer_head *bh,
 		struct page *page, unsigned long offset);
diff -puN include/linux/file.h~debug-missed-mnt_want_writes include/linux/file.h
--- lxc/include/linux/file.h~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/include/linux/file.h	2007-09-25 15:27:43.000000000 -0700
@@ -53,6 +53,7 @@ struct files_struct {
 	struct embedded_fd_set close_on_exec_init;
 	struct embedded_fd_set open_fds_init;
 	struct file * fd_array[NR_OPEN_DEFAULT];
+	atomic_t persistent_mnt_writers;
 };
 
 #define files_fdtable(files) (rcu_dereference((files)->fdt))
diff -puN include/linux/fs.h~debug-missed-mnt_want_writes include/linux/fs.h
--- lxc/include/linux/fs.h~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/include/linux/fs.h	2007-09-25 15:27:43.000000000 -0700
@@ -1041,6 +1041,8 @@ struct super_block {
 	 * in /proc/mounts will be "type.subtype"
 	 */
 	char *s_subtype;
+	struct list_head s_writable_inodes;
+	spinlock_t s_writable_inodes_lock;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
diff -puN include/linux/mount.h~debug-missed-mnt_want_writes include/linux/mount.h
--- lxc/include/linux/mount.h~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/include/linux/mount.h	2007-09-25 15:57:45.000000000 -0700
@@ -83,12 +83,29 @@ static inline struct vfsmount *mntget(st
 	return mnt;
 }
 
+struct inode;
 extern int mnt_want_write(struct vfsmount *mnt);
 extern void mnt_drop_write(struct vfsmount *mnt);
+extern int mnt_want_persistent_write(struct vfsmount *mnt, struct inode *inode);
+extern void mnt_drop_persistent_write(struct vfsmount *mnt, struct inode *inode);
 extern void mntput_no_expire(struct vfsmount *mnt);
 extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
+extern void check_write_ability_to_inode(struct inode *inode);
+extern void check_sb_for_writable_inode(struct super_block *sb,
+					 struct inode *inode);
+
+
+struct i_mnt_pair {
+	struct list_head list;
+	struct inode *inode;
+	struct vfsmount *mnt;
+};
+extern void allow_writes_via_mnt_to(struct i_mnt_pair *pair);
+extern struct i_mnt_pair *disallow_writes_via_mnt_to(struct vfsmount *mnt,
+						     struct inode *inode,
+						     struct super_block *sb);
 
 static inline void mntput(struct vfsmount *mnt)
 {
diff -puN include/linux/sched.h~debug-missed-mnt_want_writes include/linux/sched.h
--- lxc/include/linux/sched.h~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/include/linux/sched.h	2007-09-25 15:27:43.000000000 -0700
@@ -1123,6 +1123,8 @@ struct task_struct {
 	int make_it_fail;
 #endif
 	struct prop_local_single dirties;
+#define CAN_WRITE_VIA_LEN 5
+	struct vfsmount *can_write_via_mnt[CAN_WRITE_VIA_LEN];
 };
 
 /*
diff -puN kernel/fork.c~debug-missed-mnt_want_writes kernel/fork.c
--- lxc/kernel/fork.c~debug-missed-mnt_want_writes	2007-09-25 15:27:43.000000000 -0700
+++ lxc-dave/kernel/fork.c	2007-09-25 15:27:43.000000000 -0700
@@ -112,6 +112,20 @@ void free_task(struct task_struct *tsk)
 	prop_local_destroy_single(&tsk->dirties);
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
+	{
+		int i;
+		int bad = 0;
+		for (i=0; i < CAN_WRITE_VIA_LEN; i++) {
+			struct vfsmount *mnt = tsk->can_write_via_mnt[i];
+			if (!mnt)
+				continue;
+			printk("task '%s' exited with mnt[%d]:%p present\n",
+					tsk->comm, i, mnt);
+			bad = 1;
+		}
+		if (bad)
+			panic("bad can write stuff");
+	}
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -181,6 +195,12 @@ static struct task_struct *dup_task_stru
 	}
 
 	*tsk = *orig;
+	{
+		int i;
+		for (i=0; i < CAN_WRITE_VIA_LEN; i++) {
+			tsk->can_write_via_mnt[i] = NULL;
+		}
+	}
 	tsk->stack = ti;
 
 	err = prop_local_init_single(&tsk->dirties);
@@ -203,6 +223,16 @@ static struct task_struct *dup_task_stru
 	tsk->btrace_seq = 0;
 #endif
 	tsk->splice_pipe = NULL;
+	{
+		int i;
+		for (i=0; i < CAN_WRITE_VIA_LEN; i++) {
+			struct vfsmount *mnt = tsk->can_write_via_mnt[i];
+			if (!mnt)
+				continue;
+			printk("task later %d mnt[%d]:%p present\n",
+				tsk->pid, i, mnt);
+		}
+	}
 	return tsk;
 }
 
@@ -657,6 +687,7 @@ static struct files_struct *alloc_files(
 		goto out;
 
 	atomic_set(&newf->count, 1);
+	atomic_set(&newf->persistent_mnt_writers, 0);
 
 	spin_lock_init(&newf->file_lock);
 	newf->next_fd = 0;
diff -puN arch/i386/kernel/entry.S~debug-missed-mnt_want_writes arch/i386/kernel/entry.S
diff -puN arch/i386/kernel/irq.c~debug-missed-mnt_want_writes arch/i386/kernel/irq.c
diff -puN include/asm-i386/paravirt.h~debug-missed-mnt_want_writes include/asm-i386/paravirt.h
diff -puN include/asm-i386/irqflags.h~debug-missed-mnt_want_writes include/asm-i386/irqflags.h
diff -puN fs/ext4/inode.c~debug-missed-mnt_want_writes fs/ext4/inode.c
--- lxc/fs/ext4/inode.c~debug-missed-mnt_want_writes	2007-09-25 15:55:59.000000000 -0700
+++ lxc-dave/fs/ext4/inode.c	2007-09-25 15:56:03.000000000 -0700
@@ -3260,6 +3260,7 @@ int ext4_mark_inode_dirty(handle_t *hand
 	int err, ret;
 
 	might_sleep();
+	check_write_ability_to_inode(inode);
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
 	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
 	    !(EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND)) {
diff -puN fs/ocfs2/inode.c~debug-missed-mnt_want_writes fs/ocfs2/inode.c
--- lxc/fs/ocfs2/inode.c~debug-missed-mnt_want_writes	2007-09-25 15:56:06.000000000 -0700
+++ lxc-dave/fs/ocfs2/inode.c	2007-09-25 15:56:10.000000000 -0700
@@ -1211,6 +1211,7 @@ int ocfs2_mark_inode_dirty(handle_t *han
 	int status;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) bh->b_data;
 
+	check_write_ability_to_inode(inode);
 	mlog_entry("(inode %llu)\n",
 		   (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
diff -puN arch/i386/kernel/syscall_table.S~debug-missed-mnt_want_writes arch/i386/kernel/syscall_table.S
diff -puN fs/nfsctl.c~debug-missed-mnt_want_writes fs/nfsctl.c
_


-- Dave

