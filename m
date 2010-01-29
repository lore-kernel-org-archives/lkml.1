Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114Ab0A2UjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab0A2UjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000Ab0A2UjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:39:08 -0500
Received: from www.tglx.de ([62.245.132.106]:44735 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab0A2UjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:39:07 -0500
Message-Id: <20100129203613.517376824@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 29 Jan 2010 20:38:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 04/10] hfs: Convert tree_lock to mutex
References: <20100129203549.526478432@linutronix.de>
Content-Disposition: inline; filename=hfs-convert-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tree_lock semaphore is used as mutex. Convert it to a real mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/hfs/bfind.c |    4 ++--
 fs/hfs/btree.c |    2 +-
 fs/hfs/btree.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/fs/hfs/bfind.c
===================================================================
--- linux-2.6-tip.orig/fs/hfs/bfind.c
+++ linux-2.6-tip/fs/hfs/bfind.c
@@ -23,7 +23,7 @@ int hfs_find_init(struct hfs_btree *tree
 	fd->search_key = ptr;
 	fd->key = ptr + tree->max_key_len + 2;
 	dprint(DBG_BNODE_REFS, "find_init: %d (%p)\n", tree->cnid, __builtin_return_address(0));
-	down(&tree->tree_lock);
+	mutex_lock(&tree->tree_lock);
 	return 0;
 }
 
@@ -32,7 +32,7 @@ void hfs_find_exit(struct hfs_find_data 
 	hfs_bnode_put(fd->bnode);
 	kfree(fd->search_key);
 	dprint(DBG_BNODE_REFS, "find_exit: %d (%p)\n", fd->tree->cnid, __builtin_return_address(0));
-	up(&fd->tree->tree_lock);
+	mutex_unlock(&fd->tree->tree_lock);
 	fd->tree = NULL;
 }
 
Index: linux-2.6-tip/fs/hfs/btree.c
===================================================================
--- linux-2.6-tip.orig/fs/hfs/btree.c
+++ linux-2.6-tip/fs/hfs/btree.c
@@ -26,7 +26,7 @@ struct hfs_btree *hfs_btree_open(struct 
 	if (!tree)
 		return NULL;
 
-	init_MUTEX(&tree->tree_lock);
+	mutex_init(&tree->tree_lock);
 	spin_lock_init(&tree->hash_lock);
 	/* Set the correct compare function */
 	tree->sb = sb;
Index: linux-2.6-tip/fs/hfs/btree.h
===================================================================
--- linux-2.6-tip.orig/fs/hfs/btree.h
+++ linux-2.6-tip/fs/hfs/btree.h
@@ -33,7 +33,7 @@ struct hfs_btree {
 	unsigned int depth;
 
 	//unsigned int map1_size, map_size;
-	struct semaphore tree_lock;
+	struct mutex tree_lock;
 
 	unsigned int pages_per_bnode;
 	spinlock_t hash_lock;


