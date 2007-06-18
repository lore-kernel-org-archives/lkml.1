Return-Path: <linux-kernel-owner+w=401wt.eu-S1762693AbXFRKEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbXFRKEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760038AbXFRJ7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:59:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58653 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760114AbXFRJ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:59:18 -0400
Message-Id: <20070618095918.199800825@sgi.com>
References: <20070618095838.238615343@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 02:58:58 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: suresh.b.siddha@intel.com
Subject: [patch 20/26] Slab defragmentation: Support inode defragmentation for sockets
Content-Disposition: inline; filename=slub_defrag_fs_socket
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 net/socket.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: slub/net/socket.c
===================================================================
--- slub.orig/net/socket.c	2007-06-06 15:19:29.000000000 -0700
+++ slub/net/socket.c	2007-06-06 15:20:54.000000000 -0700
@@ -264,6 +264,17 @@ static void init_once(void *foo, struct 
 	inode_init_once(&ei->vfs_inode);
 }
 
+static void *sock_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct socket_alloc, vfs_inode));
+}
+
+static struct kmem_cache_ops sock_kmem_cache_ops = {
+	.get = sock_get_inodes,
+	.kick = kick_inodes
+};
+
 static int init_inodecache(void)
 {
 	sock_inode_cachep = kmem_cache_create("sock_inode_cache",
@@ -273,7 +284,7 @@ static int init_inodecache(void)
 					       SLAB_RECLAIM_ACCOUNT |
 					       SLAB_MEM_SPREAD),
 					      init_once,
-					      NULL);
+					      &sock_kmem_cache_ops);
 	if (sock_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;

-- 
