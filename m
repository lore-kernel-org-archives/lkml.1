Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbXBIWxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbXBIWxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbXBIWxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:53:34 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:46824 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbXBIWxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:33 -0500
Subject: [PATCH 03/22] record when sb_writer_count elevated for inode
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:31 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225331.4457B8CB@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There are a number of filesystems that do iput()s without first
having messed with i_nlink.  In order to keep from accidentally
decrementing the superblock writer count for these, we record
when the count is bumped up, so that we can properly balance
it.

I first tried to do this by assuming that, for each dec_nlink() to
zero, there was exactly one call to iput_final().  But, there are
a number of cases where this isn't true, especially in error handling
code.  Even if all of the filesystems were fixed up, it would be simple
to reintroduce new bugs imbalancing the mnt writer count.  This patch
trades that possibility for the chance that we will miss a i_nlink--,
and not bump the sb writer count.

I like the idea screwing up writing out a single inode better than
screwing up a global superblock count imbalance that will affect
all inodes on the superblock.

Also, since this is the first non-trivial use of the inc/drop_nlink()
functions, add some kernel docs for them.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/inode.c         |    7 +++++
 lxc-dave/fs/libfs.c         |    1 
 lxc-dave/include/linux/fs.h |   58 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff -puN fs/inode.c~04-24-record-when-sb-writer-count-elevated-for-inode fs/inode.c
--- lxc/fs/inode.c~04-24-record-when-sb-writer-count-elevated-for-inode	2007-02-09 14:26:48.000000000 -0800
+++ lxc-dave/fs/inode.c	2007-02-09 14:26:48.000000000 -0800
@@ -1097,10 +1097,17 @@ static inline void iput_final(struct ino
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 	void (*drop)(struct inode *) = generic_drop_inode;
+	int must_drop_sb_write = (inode->i_state & I_AWAITING_FINAL_IPUT);
+	struct super_block *sb = inode->i_sb;
 
 	if (op && op->drop_inode)
 		drop = op->drop_inode;
 	drop(inode);
+	if (must_drop_sb_write) {
+		spin_lock(&sb->s_mnt_writers_lock);
+		sb->s_writers--;
+		spin_unlock(&sb->s_mnt_writers_lock);
+	}
 }
 
 /**
diff -puN fs/libfs.c~04-24-record-when-sb-writer-count-elevated-for-inode fs/libfs.c
--- lxc/fs/libfs.c~04-24-record-when-sb-writer-count-elevated-for-inode	2007-02-09 14:26:48.000000000 -0800
+++ lxc-dave/fs/libfs.c	2007-02-09 14:26:48.000000000 -0800
@@ -388,6 +388,7 @@ int simple_fill_super(struct super_block
 	 * because the root inode is 1, the files array must not contain an
 	 * entry at index 1
 	 */
+	inode->i_state |= I_AWAITING_FINAL_IPUT;
 	inode->i_ino = 1;
 	inode->i_mode = S_IFDIR | 0755;
 	inode->i_uid = inode->i_gid = 0;
diff -puN include/linux/fs.h~04-24-record-when-sb-writer-count-elevated-for-inode include/linux/fs.h
--- lxc/include/linux/fs.h~04-24-record-when-sb-writer-count-elevated-for-inode	2007-02-09 14:26:48.000000000 -0800
+++ lxc-dave/include/linux/fs.h	2007-02-09 14:26:48.000000000 -0800
@@ -1230,6 +1230,7 @@ struct super_operations {
 #define I_CLEAR			32
 #define I_NEW			64
 #define I_WILL_FREE		128
+#define I_AWAITING_FINAL_IPUT		256
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
@@ -1244,6 +1245,14 @@ static inline void mark_inode_dirty_sync
 	__mark_inode_dirty(inode, I_DIRTY_SYNC);
 }
 
+/**
+ * inc_nlink - directly increment an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  Currently,
+ * it is only here for parity with dec_nlink().
+ */
 static inline void inc_nlink(struct inode *inode)
 {
 	inode->i_nlink++;
@@ -1255,14 +1264,63 @@ static inline void inode_inc_link_count(
 	mark_inode_dirty(inode);
 }
 
+/**
+ * check_nlink - check an inode's status after direct
+ * 		 i_nlink modification.
+ * @inode: inode
+ *
+ * Some filesystems can not make simple incremental changes
+ * to i_nlink, most notably clustered ones.  They must do
+ * direct manipulation of i_nlink.  This function must be
+ * called after such modifications are complete to make
+ * sure that the VFS knows that the inode is going to go
+ * away.
+ */
+static inline void check_nlink(struct inode *inode)
+{
+	if (inode->i_nlink)
+		return;
+
+	inode->i_state |= I_AWAITING_FINAL_IPUT;
+	spin_lock(&inode->i_sb->s_mnt_writers_lock);
+	inode->i_sb->s_writers++;
+	spin_unlock(&inode->i_sb->s_mnt_writers_lock);
+}
+
+/**
+ * drop_nlink - directly drop an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  In cases
+ * where we are attempting to track writes to the
+ * filesystem, a decrement to zero means an imminent
+ * write when the file is truncated and actually unlinked
+ * on the filesystem.
+ */
 static inline void drop_nlink(struct inode *inode)
 {
 	inode->i_nlink--;
+	check_nlink(inode);
 }
 
+/**
+ * clear_nlink - directly zero an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  See
+ * drop_nlink() for why we care about i_nlink hitting zero.
+ *
+ * Note that we could do the i_state flag directly in here,
+ * but we call check_nlink() to keep the number of places
+ * where the flag is set to exactly one.  The compiler
+ * should get rid of the superfluous i_nlink check.
+ */
 static inline void clear_nlink(struct inode *inode)
 {
 	inode->i_nlink = 0;
+	check_nlink(inode);
 }
 
 static inline void inode_dec_link_count(struct inode *inode)
_
