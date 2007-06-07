Return-Path: <linux-kernel-owner+w=401wt.eu-S966343AbXFGWDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966343AbXFGWDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965724AbXFGV7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:59:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43757 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965780AbXFGV7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:59:11 -0400
Message-Id: <20070607215909.907281916@sgi.com>
References: <20070607215529.147027769@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Jun 2007 14:55:37 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: dgc@sgi.com
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Mel Gorman <mel@skynet.ie>
Subject: [patch 08/12] procfs: inode defragmentation support
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
