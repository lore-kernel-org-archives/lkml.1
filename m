Return-Path: <linux-kernel-owner+w=401wt.eu-S1763432AbXERSMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763432AbXERSMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbXERSLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:11:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34562 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756342AbXERSLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:11:20 -0400
Message-Id: <20070518181119.764521535@sgi.com>
References: <20070518181040.465335396@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 May 2007 11:10:45 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: dgc@sgi.com
Cc: Hugh Dickins <hugh@veritas.com>
Subject: [patch 05/10] reiserfs: inode defragmentation support
Content-Disposition: inline; filename=fs_reiser
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add inode defrag support

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/reiserfs/super.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: slub/fs/reiserfs/super.c
===================================================================
--- slub.orig/fs/reiserfs/super.c	2007-05-18 00:54:30.000000000 -0700
+++ slub/fs/reiserfs/super.c	2007-05-18 00:57:12.000000000 -0700
@@ -520,6 +520,17 @@ static void init_once(void *foo, struct 
 #endif
 }
 
+static void *reiserfs_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+			offsetof(struct reiserfs_inode_info, vfs_inode));
+}
+
+struct kmem_cache_ops reiserfs_kmem_cache_ops = {
+	.get = reiserfs_get_inodes,
+	.kick = kick_inodes
+};
+
 static int init_inodecache(void)
 {
 	reiserfs_inode_cachep = kmem_cache_create("reiser_inode_cache",
@@ -527,7 +538,8 @@ static int init_inodecache(void)
 							 reiserfs_inode_info),
 						  0, (SLAB_RECLAIM_ACCOUNT|
 							SLAB_MEM_SPREAD),
-						  init_once, NULL);
+						  init_once,
+						  &reiserfs_kmem_cache_ops);
 	if (reiserfs_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;

-- 
