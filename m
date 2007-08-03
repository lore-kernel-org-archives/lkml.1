Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbXHCRwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbXHCRwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764654AbXHCRuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:50:15 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:50671 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764699AbXHCRuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:50:13 -0400
Message-Id: <20070803174927.988595338@szeredi.hu>
References: <20070803174425.998083527@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 19:44:31 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 05/11] fuse: fix page invalidation
Content-Disposition: inline; filename=fuse_invalidate_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Other than truncate, there are two cases, when fuse tries to get rid
of cached pages:

 a) in open, if KEEP_CACHE flag is not set
 b) in getattr, if file size changed spontaneously

Until now invalidate_mapping_pages() were used, which didn't get rid
of mapped pages.  This is wrong, and becomes more wrong as dirty pages
are introduced.  So instead properly invalidate all pages with
invalidate_inode_pages2().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-08-03 18:36:05.000000000 +0200
+++ linux/fs/fuse/file.c	2007-08-03 18:36:13.000000000 +0200
@@ -87,7 +87,7 @@ void fuse_finish_open(struct inode *inod
 	if (outarg->open_flags & FOPEN_DIRECT_IO)
 		file->f_op = &fuse_direct_io_file_operations;
 	if (!(outarg->open_flags & FOPEN_KEEP_CACHE))
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+		invalidate_inode_pages2(inode->i_mapping);
 	ff->fh = outarg->fh;
 	file->private_data = fuse_file_get(ff);
 }
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-08-03 18:36:05.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-08-03 18:36:13.000000000 +0200
@@ -143,7 +143,7 @@ void fuse_change_attributes(struct inode
 	if (S_ISREG(inode->i_mode) && oldsize != attr->size) {
 		if (attr->size < oldsize)
 			fuse_truncate(inode->i_mapping, attr->size);
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+		invalidate_inode_pages2(inode->i_mapping);
 	}
 }
 

--
