Return-Path: <linux-kernel-owner+w=401wt.eu-S966546AbXFGWDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966546AbXFGWDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966123AbXFGV7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:59:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60355 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965622AbXFGV7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:59:10 -0400
Message-Id: <20070607215910.151944168@sgi.com>
References: <20070607215529.147027769@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Jun 2007 14:55:38 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: dgc@sgi.com
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Mel Gorman <mel@skynet.ie>
Subject: [patch 09/12] reiserfs: inode defragmentation support
Content-Disposition: inline; filename=slub_defrag_fs_reiser
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add inode defrag support

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/reiserfs/super.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: slub/fs/reiserfs/super.c
===================================================================
--- slub.orig/fs/reiserfs/super.c	2007-06-07 14:09:36.000000000 -0700
+++ slub/fs/reiserfs/super.c	2007-06-07 14:30:49.000000000 -0700
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
