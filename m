Return-Path: <linux-kernel-owner+w=401wt.eu-S1030761AbXDKDmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030761AbXDKDmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030758AbXDKDmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:42:44 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:15843 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbXDKDi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=D2RYQpMyy3nLwy1xgSfI90vAKecZztflOiEtQYCjYoqhWhINpxSBvl+6E0lgvSmYuWEz0efh+byCak+PjjPKKERlo1LlBmvVPaXgpR9geq5/N2JKxTm1NMIdx0QSI4ss/N0cRGGF1LDmslh+7+xdwRq34qd9gVv8aBMYTb0VPgQ=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.54035.patchbomb.py@localhost>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 5/13] ext4: use zero_user_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use zero_user_page() instead of open-coding it. 

Signed-off-by: Nate Diller <nate.diller@gmail.com>

--- 

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ext4/inode.c linux-2.6.21-rc6-mm1-test/fs/ext4/inode.c
--- linux-2.6.21-rc6-mm1/fs/ext4/inode.c	2007-04-10 17:15:04.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ext4/inode.c	2007-04-10 18:33:04.000000000 -0700
@@ -1791,7 +1791,6 @@ int ext4_block_truncate_page(handle_t *h
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
 	int err = 0;
-	void *kaddr;
 
 	if ((EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) &&
 			test_opt(inode->i_sb, EXTENTS) &&
@@ -1808,10 +1807,7 @@ int ext4_block_truncate_page(handle_t *h
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext4_should_writeback_data(inode) && PageUptodate(page)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, length);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, offset, length);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1864,11 +1860,7 @@ int ext4_block_truncate_page(handle_t *h
 			goto unlock;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-
+	zero_user_page(page, offset, length);
 	BUFFER_TRACE(bh, "zeroed end of block");
 
 	err = 0;
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ext4/writeback.c linux-2.6.21-rc6-mm1-test/fs/ext4/writeback.c
--- linux-2.6.21-rc6-mm1/fs/ext4/writeback.c	2007-04-10 18:05:52.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ext4/writeback.c	2007-04-10 18:33:04.000000000 -0700
@@ -961,7 +961,6 @@ int ext4_wb_writepage(struct page *page,
 	loff_t i_size = i_size_read(inode);
 	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	void *kaddr;
 
 	wb_debug("writepage %lu from inode %lu\n", page->index, inode->i_ino);
 
@@ -1011,10 +1010,7 @@ int ext4_wb_writepage(struct page *page,
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
 	return ext4_wb_write_single_page(page, wbc);
 }
 
@@ -1065,7 +1061,6 @@ int ext4_wb_block_truncate_page(handle_t
 	struct inode *inode = mapping->host;
 	struct buffer_head bh, *bhw = &bh;
 	unsigned blocksize, length;
-	void *kaddr;
 	int err = 0;
 
 	wb_debug("partial truncate from %lu on page %lu from inode %lu\n",
@@ -1104,10 +1099,7 @@ int ext4_wb_block_truncate_page(handle_t
 		}
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, length);
 	SetPageUptodate(page);
 	__set_page_dirty_nobuffers(page);
 
