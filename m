Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbXFNWRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbXFNWRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbXFNWPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:15:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35391 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757796AbXFNWPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:15:46 -0400
Date: Fri, 15 Jun 2007 00:15:59 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@wohnheim.fh-wedel.de>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make fs/inode.c:wake_up_inode() static
Message-ID: <20070614221559.GZ3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

wake_up_inode() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/inode.c                |   18 +++++++++---------
 include/linux/writeback.h |    1 -
 2 files changed, 9 insertions(+), 10 deletions(-)

--- linux-2.6.22-rc4-mm2/include/linux/writeback.h.old	2007-06-14 02:00:29.000000000 +0200
+++ linux-2.6.22-rc4-mm2/include/linux/writeback.h	2007-06-14 02:00:34.000000000 +0200
@@ -69,7 +69,6 @@
  * fs/fs-writeback.c
  */	
 int writeback_inodes(struct writeback_control *wbc);
-void wake_up_inode(struct inode *inode);
 int inode_wait(void *);
 int sync_inodes_sb(struct super_block *, int wait);
 int sync_inodes(int wait);
--- linux-2.6.22-rc4-mm2/fs/inode.c.old	2007-06-14 02:00:40.000000000 +0200
+++ linux-2.6.22-rc4-mm2/fs/inode.c	2007-06-14 02:02:25.000000000 +0200
@@ -99,6 +99,15 @@
 
 static struct kmem_cache * inode_cachep __read_mostly;
 
+static void wake_up_inode(struct inode *inode)
+{
+	/*
+	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 */
+	smp_mb();
+	wake_up_bit(&inode->i_state, __I_LOCK);
+}
+
 static struct inode *alloc_inode(struct super_block *sb)
 {
 	static const struct address_space_operations empty_aops;
@@ -1296,15 +1305,6 @@
 	spin_lock(&inode_lock);
 }
 
-void wake_up_inode(struct inode *inode)
-{
-	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
-	 */
-	smp_mb();
-	wake_up_bit(&inode->i_state, __I_LOCK);
-}
-
 /*
  * We rarely want to lock two inodes that do not have a parent/child
  * relationship (such as directory, child inode) simultaneously. The

