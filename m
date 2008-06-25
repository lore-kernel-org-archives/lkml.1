Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbYFYMly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbYFYMly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbYFYMl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:41:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34464 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbYFYMl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:41:26 -0400
Message-Id: <20080625124123.124728808@szeredi.hu>
References: <20080625124038.103406301@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 25 Jun 2008 14:40:40 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, hugh@veritas.com, nickpiggin@yahoo.com.au
Subject: [patch 2/2] splice: fix generic_file_splice_read() race with page invalidation
Content-Disposition: inline; filename=splice_generic_file_splice_read_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If a page was invalidated during splicing from file to a pipe, then
generic_file_splice_read() could return a short or zero count.

This manifested itself in rare I/O errors seen on nfs exported fuse
filesystems.  This is because nfsd uses splice_direct_to_actor() to
read files, and fuse uses invalidate_inode_pages2() to invalidate
stale data on open.

Fix by redoing the page find/create if it was found to be truncated
(invalidated). 

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2008-06-25 08:18:51.000000000 +0200
+++ linux-2.6/fs/splice.c	2008-06-25 11:57:33.000000000 +0200
@@ -379,13 +379,22 @@ __generic_file_splice_read(struct file *
 				lock_page(page);
 
 			/*
-			 * page was truncated, stop here. if this isn't the
-			 * first page, we'll just complete what we already
-			 * added
+			 * Page was truncated, or invalidated by the
+			 * filesystem.  Redo the find/create, but this time the
+			 * page is kept locked, so there's no chance of another
+			 * race with truncate/invalidate.
 			 */
 			if (!page->mapping) {
 				unlock_page(page);
-				break;
+				page = find_or_create_page(mapping, index,
+						mapping_gfp_mask(mapping));
+
+				if (!page) {
+					error = -ENOMEM;
+					break;
+				}
+				page_cache_release(pages[page_nr]);
+				pages[page_nr] = page;
 			}
 			/*
 			 * page was already under io and is now done, great

--
