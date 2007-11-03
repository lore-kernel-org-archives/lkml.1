Return-Path: <linux-kernel-owner+w=401wt.eu-S1761597AbXKCXHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597AbXKCXHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758918AbXKCXGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:06:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758443AbXKCXGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:06:33 -0400
Date: Sat, 3 Nov 2007 18:55:37 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: [RFC PATCH 4/10] debug page_file_cache
Message-ID: <20071103185537.20c42f7a@bree.surriel.com>
In-Reply-To: <20071103184229.3f20e2f0@bree.surriel.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Debug whether we end up classifying the wrong pages as
filesystem backed.  This has not triggered in stress
tests on my system, but who knows...

Signed-off-by: Rik van Riel <riel@redhat.com>

Index: linux-2.6.23-mm1/include/linux/mm_inline.h
===================================================================
--- linux-2.6.23-mm1.orig/include/linux/mm_inline.h
+++ linux-2.6.23-mm1/include/linux/mm_inline.h
@@ -1,6 +1,8 @@
 #ifndef LINUX_MM_INLINE_H
 #define LINUX_MM_INLINE_H
 
+#include <linux/fs.h>  /* for struct address_space */
+
 /**
  * page_file_cache(@page)
  * Returns !0 if @page is page cache page backed by a regular file,
@@ -9,11 +11,19 @@
  * We would like to get this info without a page flag, but the state
  * needs to propagate to whereever the page is last deleted from the LRU.
  */
+extern const struct address_space_operations shmem_aops;
 static inline int page_file_cache(struct page *page)
 {
+	struct address_space * mapping = page_mapping(page);
+
 	if (PageSwapBacked(page))
 		return 0;
 
+	/* These pages should all be marked PG_swapbacked */
+	WARN_ON(PageAnon(page));
+	WARN_ON(PageSwapCache(page));
+	WARN_ON(mapping && mapping->a_ops && mapping->a_ops == &shmem_aops);
+
 	/* The page is page cache backed by a normal filesystem. */
 	return 2;
 }
Index: linux-2.6.23-mm1/mm/shmem.c
===================================================================
--- linux-2.6.23-mm1.orig/mm/shmem.c
+++ linux-2.6.23-mm1/mm/shmem.c
@@ -180,7 +180,7 @@ static inline void shmem_unacct_blocks(u
 }
 
 static const struct super_operations shmem_ops;
-static const struct address_space_operations shmem_aops;
+const struct address_space_operations shmem_aops;
 static const struct file_operations shmem_file_operations;
 static const struct inode_operations shmem_inode_operations;
 static const struct inode_operations shmem_dir_inode_operations;
@@ -2344,7 +2344,7 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(shmem_inode_cachep);
 }
 
-static const struct address_space_operations shmem_aops = {
+const struct address_space_operations shmem_aops = {
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
 #ifdef CONFIG_TMPFS
