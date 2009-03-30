Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZC3STA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZC3STA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZC3SPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:15:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZC3SPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:15:19 -0400
Message-Id: <20090330181011.208415251@suse.com>
User-Agent: quilt/0.47-14.9
Date: Mon, 30 Mar 2009 14:02:30 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 15/35 xattr-rework] reiserfs: xattr reiserfs_get_page takes offset instead of index
References: <20090330180215.951354436@suse.com>
Content-Disposition: inline; filename=patches.suse/reiserfs-xattr-get-page
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch changes reiserfs_get_page to take an
 offset rather than an index since no callers calculate the index
 differently.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/xattr.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -376,14 +376,14 @@ static inline void reiserfs_put_page(str
 	page_cache_release(page);
 }
 
-static struct page *reiserfs_get_page(struct inode *dir, unsigned long n)
+static struct page *reiserfs_get_page(struct inode *dir, size_t n)
 {
 	struct address_space *mapping = dir->i_mapping;
 	struct page *page;
 	/* We can deadlock if we try to free dentries,
 	   and an unlink/rmdir has just occured - GFP_NOFS avoids this */
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
-	page = read_mapping_page(mapping, n, NULL);
+	page = read_mapping_page(mapping, n >> PAGE_CACHE_SHIFT, NULL);
 	if (!IS_ERR(page)) {
 		kmap(page);
 		if (PageError(page))
@@ -470,8 +470,7 @@ reiserfs_xattr_set(struct inode *inode,
 		else
 			chunk = buffer_size - buffer_pos;
 
-		page = reiserfs_get_page(dentry->d_inode,
-					 file_pos >> PAGE_CACHE_SHIFT);
+		page = reiserfs_get_page(dentry->d_inode, file_pos);
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
 			goto out_filp;
@@ -577,8 +576,7 @@ reiserfs_xattr_get(const struct inode *i
 		else
 			chunk = isize - file_pos;
 
-		page = reiserfs_get_page(dentry->d_inode,
-					 file_pos >> PAGE_CACHE_SHIFT);
+		page = reiserfs_get_page(dentry->d_inode, file_pos);
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
 			goto out_dput;


