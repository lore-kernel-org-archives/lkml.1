Return-Path: <linux-kernel-owner+w=401wt.eu-S1763608AbXERSNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763608AbXERSNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762831AbXERSL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:11:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34570 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756424AbXERSLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:11:21 -0400
Message-Id: <20070518181120.477184338@sgi.com>
References: <20070518181040.465335396@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 May 2007 11:10:48 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: dgc@sgi.com
Cc: Hugh Dickins <hugh@veritas.com>
Subject: [patch 08/10] shmem: inode defragmentation support
Content-Disposition: inline; filename=fs_shmem
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/shmem.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: slub/mm/shmem.c
===================================================================
--- slub.orig/mm/shmem.c	2007-05-18 00:54:30.000000000 -0700
+++ slub/mm/shmem.c	2007-05-18 01:02:26.000000000 -0700
@@ -2337,11 +2337,22 @@ static void init_once(void *foo, struct 
 #endif
 }
 
+static void *shmem_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+			offsetof(struct shmem_inode_info, vfs_inode));
+}
+
+static struct kmem_cache_ops shmem_kmem_cache_ops = {
+	.get = shmem_get_inodes,
+	.kick = kick_inodes
+};
+
 static int init_inodecache(void)
 {
 	shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
 				sizeof(struct shmem_inode_info),
-				0, 0, init_once, NULL);
+				0, 0, init_once, &shmem_kmem_cache_ops);
 	if (shmem_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;

-- 
