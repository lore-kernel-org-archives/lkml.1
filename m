Return-Path: <linux-kernel-owner+w=401wt.eu-S1759665AbYHASgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665AbYHASgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbYHASfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:35:12 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:7971 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636AbYHASfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:35:07 -0400
Message-Id: <20080801182346.724029167@lameter.com>
References: <20080801182324.572058187@lameter.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:21:13 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 12/19] Filesystem: Ext2 filesystem defrag
Content-Disposition: inline; filename=ext2-defrag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support defragmentation for ext2 filesystem inodes

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/ext2/super.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/fs/ext2/super.c
===================================================================
--- linux-2.6.orig/fs/ext2/super.c	2008-07-31 12:18:12.000000000 -0500
+++ linux-2.6/fs/ext2/super.c	2008-07-31 12:18:15.000000000 -0500
@@ -171,6 +171,12 @@
 	inode_init_once(&ei->vfs_inode);
 }
 
+static void *ext2_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct ext2_inode_info, vfs_inode));
+}
+
 static int init_inodecache(void)
 {
 	ext2_inode_cachep = kmem_cache_create("ext2_inode_cache",
@@ -180,6 +186,9 @@
 					     init_once);
 	if (ext2_inode_cachep == NULL)
 		return -ENOMEM;
+
+	kmem_cache_setup_defrag(ext2_inode_cachep,
+			ext2_get_inodes, kick_inodes);
 	return 0;
 }
 

-- 
