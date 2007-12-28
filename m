Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbXL1Uy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbXL1Uy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbXL1Uqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:46:51 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37624 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbXL1Uqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:46:49 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Hugh Dickins <hugh@veritas.com>, Mike Halcrow <mhalcrow@us.ibm.com>,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 02/30] VFS/fs_stack: use locking around i_size_write in 32-bit systems
Date: Fri, 28 Dec 2007 15:42:36 -0500
Message-Id: <11988745852368-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>

LTP's iogen01 doio tests hang nicely on 32-bit SMP when /tmp is a unionfs
mount of a tmpfs.  See the comment on i_size_write in linux/fs.h: it needs
to be locked, otherwise i_size_read can spin forever waiting for a lost
seqcount update.

Most filesystems are already holding i_mutex for this, but unionfs calls
fsstack_copy_inode_size from many places, not necessarily holding i_mutex.
Use the low-level i_lock within fsstack_copy_inode_size when 32-bit SMP.

Checked the entire unionfs code to ensure this is the right fix for
i_size_write().

Also compared to what other file systems do when they have to handle inodes,
esp. not their own inodes (e.g., network file systems have to access the
exported file system's inodes).  Found out that most such file systems not just
don't lock around i_size_write, but they don't even use i_size_read or
i_size_write to access the inode's size.

CC: Mike Halcrow <mhalcrow@us.ibm.com>

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/stack.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/stack.c b/fs/stack.c
index 7913fe5..4336f2b 100644
--- a/fs/stack.c
+++ b/fs/stack.c
@@ -21,8 +21,14 @@
  */
 void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
 {
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	spin_lock(&dst->i_lock);
+#endif
 	i_size_write(dst, i_size_read(src));
 	dst->i_blocks = src->i_blocks;
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	spin_unlock(&dst->i_lock);
+#endif
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
 
-- 
1.5.2.2

