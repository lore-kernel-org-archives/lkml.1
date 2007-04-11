Return-Path: <linux-kernel-owner+w=401wt.eu-S1030765AbXDKDlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030765AbXDKDlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030770AbXDKDjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:39:19 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15870 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030358AbXDKDjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=Ylfc3M2RR8AoUu1DclQbUH0ADztsoKgvJNWKPUupMxGsLClBJnU5aRl9F7r8Z02WmguPMER8zC9TpiSWzUj9RuZ2wHeaH7BElPvS9jtDJhrlEJlsMz0M1H+qC+c0pVf/d4kosayCFqStpJCMheFX+kUk59WUHhsquQLGZRNcVK8=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.94743.patchbomb.py@localhost>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 11/13] reiserfs: use zero_user_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use zero_user_page() instead of open-coding it. 

Signed-off-by: Nate Diller <nate.diller@gmail.com>

--- 

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiserfs/file.c linux-2.6.21-rc6-mm1-test/fs/reiserfs/file.c
--- linux-2.6.21-rc6-mm1/fs/reiserfs/file.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiserfs/file.c	2007-04-09 18:18:23.000000000 -0700
@@ -1059,20 +1059,12 @@ static int reiserfs_prepare_file_region_
 	   maping blocks, since there is none, so we just zero out remaining
 	   parts of first and last pages in write area (if needed) */
 	if ((pos & ~((loff_t) PAGE_CACHE_SIZE - 1)) > inode->i_size) {
-		if (from != 0) {	/* First page needs to be partially zeroed */
-			char *kaddr = kmap_atomic(prepared_pages[0], KM_USER0);
-			memset(kaddr, 0, from);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(prepared_pages[0]);
-		}
-		if (to != PAGE_CACHE_SIZE) {	/* Last page needs to be partially zeroed */
-			char *kaddr =
-			    kmap_atomic(prepared_pages[num_pages - 1],
-					KM_USER0);
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(prepared_pages[num_pages - 1]);
-		}
+		if (from != 0)		/* First page needs to be partially zeroed */
+			zero_user_page(prepared_pages[0], 0, from);
+
+		if (to != PAGE_CACHE_SIZE)	/* Last page needs to be partially zeroed */
+			zero_user_page(prepared_pages[num_pages-1], to,
+					PAGE_CACHE_SIZE - to);
 
 		/* Since all blocks are new - use already calculated value */
 		return blocks;
@@ -1199,13 +1191,9 @@ static int reiserfs_prepare_file_region_
 					ll_rw_block(READ, 1, &bh);
 					*wait_bh++ = bh;
 				} else {	/* Not mapped, zero it */
-					char *kaddr =
-					    kmap_atomic(prepared_pages[0],
-							KM_USER0);
-					memset(kaddr + block_start, 0,
-					       from - block_start);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(prepared_pages[0]);
+					zero_user_page(prepared_pages[0],
+						       block_start,
+						       from - block_start);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -1237,13 +1225,8 @@ static int reiserfs_prepare_file_region_
 					ll_rw_block(READ, 1, &bh);
 					*wait_bh++ = bh;
 				} else {	/* Not mapped, zero it */
-					char *kaddr =
-					    kmap_atomic(prepared_pages
-							[num_pages - 1],
-							KM_USER0);
-					memset(kaddr + to, 0, block_end - to);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(prepared_pages[num_pages - 1]);
+					zero_user_page(prepared_pages[num_pages-1],
+							to, block_end - to);
 					set_buffer_uptodate(bh);
 				}
 			}
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiserfs/inode.c linux-2.6.21-rc6-mm1-test/fs/reiserfs/inode.c
--- linux-2.6.21-rc6-mm1/fs/reiserfs/inode.c	2007-04-09 10:41:47.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiserfs/inode.c	2007-04-09 18:18:23.000000000 -0700
@@ -2148,13 +2148,8 @@ int reiserfs_truncate_file(struct inode 
 		length = offset & (blocksize - 1);
 		/* if we are not on a block boundary */
 		if (length) {
-			char *kaddr;
-
 			length = blocksize - length;
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr + offset, 0, length);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			zero_user_page(page, offset, length);
 			if (buffer_mapped(bh) && bh->b_blocknr != 0) {
 				mark_buffer_dirty(bh);
 			}
@@ -2370,7 +2365,6 @@ static int reiserfs_write_full_page(stru
 	 ** last byte in the file
 	 */
 	if (page->index >= end_index) {
-		char *kaddr;
 		unsigned last_offset;
 
 		last_offset = inode->i_size & (PAGE_CACHE_SIZE - 1);
@@ -2379,10 +2373,7 @@ static int reiserfs_write_full_page(stru
 			unlock_page(page);
 			return 0;
 		}
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + last_offset, 0, PAGE_CACHE_SIZE - last_offset);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, last_offset, PAGE_CACHE_SIZE - last_offset);
 	}
 	bh = head;
 	block = page->index << (PAGE_CACHE_SHIFT - s->s_blocksize_bits);
