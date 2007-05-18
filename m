Return-Path: <linux-kernel-owner+w=401wt.eu-S1763713AbXERSNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763713AbXERSNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762222AbXERSL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:11:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58624 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756380AbXERSLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:11:21 -0400
Message-Id: <20070518181120.266687200@sgi.com>
References: <20070518181040.465335396@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 May 2007 11:10:47 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: dgc@sgi.com
Cc: Hugh Dickins <hugh@veritas.com>
Subject: [patch 07/10] procfs: inode defragmentation support
Content-Disposition: inline; filename=fs_proc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm... Do we really need this?

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/proc/inode.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: slub/fs/proc/inode.c
===================================================================
--- slub.orig/fs/proc/inode.c	2007-05-18 00:54:30.000000000 -0700
+++ slub/fs/proc/inode.c	2007-05-18 01:00:36.000000000 -0700
@@ -111,14 +111,25 @@ static void init_once(void * foo, struct
 
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
