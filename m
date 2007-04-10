Return-Path: <linux-kernel-owner+w=401wt.eu-S1030342AbXDJEdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342AbXDJEdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 00:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030351AbXDJEdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 00:33:17 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:55967 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030352AbXDJEdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 00:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=NUxcXaGWLbnROm6sKIV5O5BALF27/78sa3y2W0DMiZgaWA7XOKJXlNA/YFQbKfu2agoF4TodoDKgbAcIfNjmTpqeZQszy+E21iJRUYpOm5bGaZnRLbLdmno3TV3ISdhwq8Ou4jOsErc/kzlsNhZF+2DPpefmBfNChBUhcxXUQLk=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Mon, 09 Apr 2007 21:31:37 -0700
Message-Id: <20070410043137.19370.15007.patchbomb.py@localhost>
In-Reply-To: <20070410043137.19370.2295.patchbomb.py@localhost>
Subject: [PATCH 2/2] fs: use simple_prepare_write to zero page data
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's common for file systems to need to zero data on either side of a write,
if a page is not Uptodate during prepare_write.  It just so happens that
simple_prepare_write() in libfs.c does exactly that, so we can avoid
duplication and just call that function to zero page data.

Compile tested on x86_64.

signed-off-by: Nate Diller <nate.diller@gmail.com>

---

 cifs/file.c                           |    9 +--------
 ext4/writeback.c                      |   17 +----------------
 reiser4/plugin/item/extent_file_ops.c |   13 +++----------
 3 files changed, 5 insertions(+), 34 deletions(-)

---

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/cifs/file.c linux-2.6.21-rc6-mm1-test/fs/cifs/file.c
--- linux-2.6.21-rc6-mm1/fs/cifs/file.c	2007-04-09 18:25:37.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/cifs/file.c	2007-04-09 18:23:16.000000000 -0700
@@ -1955,14 +1955,7 @@ static int cifs_prepare_write(struct fil
 		 * We don't need to read data beyond the end of the file.
 		 * zero it, and set the page uptodate
 		 */
-		void *kaddr = kmap_atomic(page, KM_USER0);
-
-		if (from)
-			memset(kaddr, 0, from);
-		if (to < PAGE_CACHE_SIZE)
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		simple_prepare_write(file, page, from, to);
 		SetPageUptodate(page);
 	} else if ((file->f_flags & O_ACCMODE) != O_WRONLY) {
 		/* might as well read a page, it is fast enough */
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ext4/writeback.c linux-2.6.21-rc6-mm1-test/fs/ext4/writeback.c
--- linux-2.6.21-rc6-mm1/fs/ext4/writeback.c	2007-04-09 18:32:52.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ext4/writeback.c	2007-04-09 18:23:16.000000000 -0700
@@ -819,21 +819,6 @@ int ext4_wb_writepages(struct address_sp
 	return 0;
 }
 
-static void ext4_wb_clear_page(struct page *page, int from, int to)
-{
-	void *kaddr;
-
-	if (to < PAGE_CACHE_SIZE || from > 0) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		if (PAGE_CACHE_SIZE > to)
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-		if (0 < from)
-			memset(kaddr, 0, from);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
-	}
-}
-
 int ext4_wb_prepare_write(struct file *file, struct page *page,
 			      unsigned from, unsigned to)
 {
@@ -863,7 +848,7 @@ int ext4_wb_prepare_write(struct file *f
 			/* this block isn't allocated yet, reserve space */
 			wb_debug("reserve space for new block\n");
 			page->private = 1;
-			ext4_wb_clear_page(page, from, to);
+			simple_prepare_write(file, page, from, to);
 			ClearPageMappedToDisk(page);
 		} else { 
 			/* block is already mapped, so no need to reserve */
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/extent_file_ops.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/extent_file_ops.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/extent_file_ops.c	2007-04-09 18:32:52.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/extent_file_ops.c	2007-04-09 18:31:34.000000000 -0700
@@ -1040,16 +1040,9 @@ ssize_t reiser4_write_extent(struct file
 		BUG_ON(get_current_context()->trans->atom != NULL);
 
 		lock_page(page);
-		if (!PageUptodate(page) && to_page != PAGE_CACHE_SIZE) {
-			void *kaddr;
-
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr, 0, page_off);
-			memset(kaddr + page_off + to_page, 0,
-			       PAGE_CACHE_SIZE - (page_off + to_page));
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
-		}
+		if (!PageUptodate(page) && to_page != PAGE_CACHE_SIZE)
+			simple_prepare_write(file, page, page_off,
+					     page_off + to_page);
 
 		written = filemap_copy_from_user(page, page_off, buf, to_page);
 		flush_dcache_page(page);
