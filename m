Return-Path: <linux-kernel-owner+w=401wt.eu-S1763356AbXERSLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763356AbXERSLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbXERSLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:11:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58619 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756261AbXERSLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:11:20 -0400
Message-Id: <20070518181119.997242349@sgi.com>
References: <20070518181040.465335396@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 May 2007 11:10:46 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: dgc@sgi.com
Cc: Hugh Dickins <hugh@veritas.com>
Subject: [patch 06/10] xfs: inode defragmentation support
Content-Disposition: inline; filename=fs_xfs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add slab defrag support.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/xfs/linux-2.6/kmem.h      |    5 +++--
 fs/xfs/linux-2.6/xfs_buf.c   |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |   13 ++++++++++++-
 3 files changed, 16 insertions(+), 4 deletions(-)

Index: slub/fs/xfs/linux-2.6/kmem.h
===================================================================
--- slub.orig/fs/xfs/linux-2.6/kmem.h	2007-05-18 00:54:30.000000000 -0700
+++ slub/fs/xfs/linux-2.6/kmem.h	2007-05-18 00:58:38.000000000 -0700
@@ -79,9 +79,10 @@ kmem_zone_init(int size, char *zone_name
 
 static inline kmem_zone_t *
 kmem_zone_init_flags(int size, char *zone_name, unsigned long flags,
-		     void (*construct)(void *, kmem_zone_t *, unsigned long))
+		     void (*construct)(void *, kmem_zone_t *, unsigned long),
+		     const struct kmem_cache_ops *ops)
 {
-	return kmem_cache_create(zone_name, size, 0, flags, construct, NULL);
+	return kmem_cache_create(zone_name, size, 0, flags, construct, ops);
 }
 
 static inline void
Index: slub/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- slub.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-05-18 00:54:30.000000000 -0700
+++ slub/fs/xfs/linux-2.6/xfs_buf.c	2007-05-18 00:58:38.000000000 -0700
@@ -1832,7 +1832,7 @@ xfs_buf_init(void)
 #endif
 
 	xfs_buf_zone = kmem_zone_init_flags(sizeof(xfs_buf_t), "xfs_buf",
-						KM_ZONE_HWALIGN, NULL);
+						KM_ZONE_HWALIGN, NULL, NULL);
 	if (!xfs_buf_zone)
 		goto out_free_trace_buf;
 
Index: slub/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- slub.orig/fs/xfs/linux-2.6/xfs_super.c	2007-05-18 00:54:30.000000000 -0700
+++ slub/fs/xfs/linux-2.6/xfs_super.c	2007-05-18 00:58:38.000000000 -0700
@@ -355,13 +355,24 @@ xfs_fs_inode_init_once(
 	inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
 }
 
+static void *xfs_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v, offsetof(bhv_vnode_t, v_inode));
+};
+
+static struct kmem_cache_ops xfs_kmem_cache_ops = {
+	.get = xfs_get_inodes,
+	.kick = kick_inodes
+};
+
 STATIC int
 xfs_init_zones(void)
 {
 	xfs_vnode_zone = kmem_zone_init_flags(sizeof(bhv_vnode_t), "xfs_vnode",
 					KM_ZONE_HWALIGN | KM_ZONE_RECLAIM |
 					KM_ZONE_SPREAD,
-					xfs_fs_inode_init_once);
+					xfs_fs_inode_init_once,
+					&xfs_kmem_cache_ops);
 	if (!xfs_vnode_zone)
 		goto out;
 

-- 
