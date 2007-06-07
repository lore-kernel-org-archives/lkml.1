Return-Path: <linux-kernel-owner+w=401wt.eu-S966018AbXFGWCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966018AbXFGWCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965878AbXFGV7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:59:31 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60361 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965825AbXFGV7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:59:11 -0400
Message-Id: <20070607215910.379088320@sgi.com>
References: <20070607215529.147027769@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Jun 2007 14:55:39 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: dgc@sgi.com
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Mel Gorman <mel@skynet.ie>
Subject: [patch 10/12] sockets: inode defragmentation support
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
