Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbYF2AHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbYF2AHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 20:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYF2AGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 20:06:50 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:36033 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYF2AGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 20:06:48 -0400
Date: Sun, 29 Jun 2008 01:05:09 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Andrew Morton <akpm@linux-foundation.org>, mhalcrow@us.ibm.com,
       hooanon05@yahoo.co.jp, hch@infradead.org, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fsstack: fsstack_copy_inode_size locking
Message-ID: <Pine.LNX.4.64.0806290101160.20280@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTP's iogen01 doio tests used to hang nicely on 32-bit SMP when /tmp was a
unionfs mount of a tmpfs, i_size_read spinning forever, waiting for a lost
seqcount update: fixed by taking i_lock around i_size_write when 32-bit SMP.

But akpm was dissatisfied with the resulting patch: its lack of commentary,
the #ifs, the nesting around i_size_read, the lack of attention to i_blocks.
I promised to redo it with the general spin_lock_32bit() he proposed; but 
disliked the result, partly because "32bit" obscures the real constraints,
which are best commented within fsstack_copy_inode_size itself.

This version adds those comments, and uses sizeof comparisons which the
compiler can optimize out, instead of CONFIG_SMP, CONFIG_LSF. BITS_PER_LONG.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Should follow mmotm's git-unionfs-fixup.patch

 fs/stack.c               |   58 +++++++++++++++++++++++++++++++------
 include/linux/fs_stack.h |    3 -
 2 files changed, 50 insertions(+), 11 deletions(-)

--- mmotm/fs/stack.c	2008-06-27 13:39:18.000000000 +0100
+++ linux/fs/stack.c	2008-06-27 18:24:19.000000000 +0100
@@ -19,16 +19,56 @@
  * This function cannot be inlined since i_size_{read,write} is rather
  * heavy-weight on 32-bit systems
  */
-void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
+void fsstack_copy_inode_size(struct inode *dst, struct inode *src)
 {
-#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
-	spin_lock(&dst->i_lock);
-#endif
-	i_size_write(dst, i_size_read(src));
-	dst->i_blocks = src->i_blocks;
-#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
-	spin_unlock(&dst->i_lock);
-#endif
+	loff_t i_size;
+	blkcnt_t i_blocks;
+
+	/*
+	 * i_size_read() includes its own seqlocking and protection from
+	 * preemption (see include/linux/fs.h): we need nothing extra for
+	 * that here, and prefer to avoid nesting locks than attempt to
+	 * keep i_size and i_blocks in synch together.
+	 */
+	i_size = i_size_read(src);
+
+	/*
+	 * But if CONFIG_LSF (on 32-bit), we ought to make an effort to keep
+	 * the two halves of i_blocks in synch despite SMP or PREEMPT - though
+	 * stat's generic_fillattr() doesn't bother, and we won't be applying
+	 * quotas (where i_blocks does become important) at the upper level.
+	 *
+	 * We don't actually know what locking is used at the lower level; but
+	 * if it's a filesystem that supports quotas, it will be using i_lock
+	 * as in inode_add_bytes().  tmpfs uses other locking, and its 32-bit
+	 * is (just) able to exceed 2TB i_size with the aid of holes; but its
+	 * i_blocks cannot carry into the upper long without almost 2TB swap -
+	 * let's ignore that case.
+	 */
+	if (sizeof(i_blocks) > sizeof(long))
+		spin_lock(&src->i_lock);
+	i_blocks = src->i_blocks;
+	if (sizeof(i_blocks) > sizeof(long))
+		spin_unlock(&src->i_lock);
+
+	/*
+	 * If CONFIG_SMP on 32-bit, it's vital for fsstack_copy_inode_size()
+	 * to hold some lock around i_size_write(), otherwise i_size_read()
+	 * may spin forever (see include/linux/fs.h).  We don't necessarily
+	 * hold i_mutex when this is called, so take i_lock for that case.
+	 *
+	 * And if CONFIG_LSF (on 32-bit), continue our effort to keep the
+	 * two halves of i_blocks in synch despite SMP or PREEMPT: use i_lock
+	 * for that case too, and do both at once by combining the tests.
+	 *
+	 * There is none of this locking overhead in the 64-bit case.
+	 */
+	if (sizeof(i_size) > sizeof(long) || sizeof(i_blocks) > sizeof(long))
+		spin_lock(&dst->i_lock);
+	i_size_write(dst, i_size);
+	dst->i_blocks = i_blocks;
+	if (sizeof(i_size) > sizeof(long) || sizeof(i_blocks) > sizeof(long))
+		spin_unlock(&dst->i_lock);
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
 
--- mmotm/include/linux/fs_stack.h	2008-06-27 13:39:19.000000000 +0100
+++ linux/include/linux/fs_stack.h	2008-06-27 14:08:00.000000000 +0100
@@ -21,8 +21,7 @@
 
 /* externs for fs/stack.c */
 extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src);
-extern void fsstack_copy_inode_size(struct inode *dst,
-				    const struct inode *src);
+extern void fsstack_copy_inode_size(struct inode *dst, struct inode *src);
 
 /* inlines */
 static inline void fsstack_copy_attr_atime(struct inode *dest,
