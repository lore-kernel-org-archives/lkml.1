Return-Path: <linux-kernel-owner+w=401wt.eu-S1762354AbXFRKEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762354AbXFRKEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759991AbXFRJ7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:59:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47914 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758434AbXFRJ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:59:18 -0400
Message-Id: <20070618095917.727840136@sgi.com>
References: <20070618095838.238615343@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 02:58:56 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: suresh.b.siddha@intel.com
Subject: [patch 18/26] Slab defragmentation: Support procfs inode defragmentation
Content-Disposition: inline; filename=slub_defrag_fs_proc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/proc/inode.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

Index: slub/fs/proc/inode.c
===================================================================
--- slub.orig/fs/proc/inode.c	2007-06-04 20:12:56.000000000 -0700
+++ slub/fs/proc/inode.c	2007-06-04 21:35:00.000000000 -0700
@@ -112,14 +112,25 @@ static void init_once(void * foo, struct
 
 	inode_init_once(&ei->vfs_inode);
 }
- 
+
+static void *proc_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+			offsetof(struct proc_inode, vfs_inode));
+};
+
+static struct kmem_cache_ops proc_kmem_cache_ops = {
+	.get = proc_get_inodes,
+	.kick = kick_inodes
+};
+
 int __init proc_init_inodecache(void)
 {
 	proc_inode_cachep = kmem_cache_create("proc_inode_cache",
 					     sizeof(struct proc_inode),
 					     0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD),
-					     init_once, NULL);
+					     init_once, &proc_kmem_cache_ops);
 	if (proc_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;

-- 
