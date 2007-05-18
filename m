Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbXERSOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbXERSOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762892AbXERSLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:11:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34573 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756707AbXERSLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:11:21 -0400
Message-Id: <20070518181120.708884638@sgi.com>
References: <20070518181040.465335396@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 May 2007 11:10:49 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: dgc@sgi.com
Cc: Hugh Dickins <hugh@veritas.com>
Subject: [patch 09/10] sockets: inode defragmentation support
Content-Disposition: inline; filename=fs_socket
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 net/socket.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: slub/net/socket.c
===================================================================
--- slub.orig/net/socket.c	2007-05-18 00:54:30.000000000 -0700
+++ slub/net/socket.c	2007-05-18 01:03:31.000000000 -0700
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
