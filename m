Return-Path: <linux-kernel-owner+w=401wt.eu-S1761025AbYG3CxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761025AbYG3CxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbYG3Cwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:52:54 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47770 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbYG3Cwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:52:53 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Hugh Dickins <hugh@veritas.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       Michael Halcrow <mhalcrow@us.ibm.com>, <hooanon05@yahoo.co.jp>,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/19] LTP's iogen01 doio tests used to hang nicely on 32-bit SMP when /tmp was a
Date: Tue, 29 Jul 2008 22:43:31 -0400
Message-Id: <12173858301951-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>

But akpm was dissatisfied with the resulting patch: its lack of
commentary, the #ifs, the nesting around i_size_read, the lack of
attention to i_blocks.  I promised to redo it with the general
spin_lock_32bit() he proposed; but disliked the result, partly because
"32bit" obscures the real constraints, which are best commented within
fsstack_copy_inode_size itself.

This version adds those comments, and uses sizeof comparisons which the
compiler can optimize out, instead of CONFIG_SMP, CONFIG_LSF.
BITS_PER_LONG.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: <hooanon05@yahoo.co.jp>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/stack.c               |   58 ++++++++++++++++++++++++++++++++++++++-------
 include/linux/fs_stack.h |    3 +-
 2 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/fs/stack.c b/fs/stack.c
index 4336f2b..a66ff6c 100644
--- a/fs/stack.c
+++ b/fs/stack.c
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
 
diff --git a/include/linux/fs_stack.h b/include/linux/fs_stack.h
index 6b52faf..6615a52 100644
--- a/include/linux/fs_stack.h
+++ b/include/linux/fs_stack.h
@@ -21,8 +21,7 @@
 
 /* externs for fs/stack.c */
 extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src);
-extern void fsstack_copy_inode_size(struct inode *dst,
-				    const struct inode *src);
+extern void fsstack_copy_inode_size(struct inode *dst, struct inode *src);
 
 /* inlines */
 static inline void fsstack_copy_attr_atime(struct inode *dest,
-- 
1.5.2.2

