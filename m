Return-Path: <linux-kernel-owner+w=401wt.eu-S1161205AbXDKF4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161205AbXDKF4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 01:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030818AbXDKF4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 01:56:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60769 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030784AbXDKF4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 01:56:45 -0400
Date: Tue, 10 Apr 2007 22:56:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nate Diller <nate.diller@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/13] fs: convert core functions to zero_user_page
Message-Id: <20070410225638.476cf89b.akpm@linux-foundation.org>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
References: <20070411033600.11000.38285.patchbomb.py@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 20:36:00 -0700 Nate Diller <nate.diller@gmail.com> wrote:

> It's very common for file systems to need to zero part or all of a page, the
> simplist way is just to use kmap_atomic() and memset().  There's actually a
> library function in include/linux/highmem.h that does exactly that, but it's
> confusingly named memclear_highpage_flush(), which is descriptive of *how*
> it does the work rather than what the *purpose* is.  So this patchset
> renames the function to zero_user_page(), and calls it from the various
> places that currently open code it.
> 
> This first patch introduces the new function call, and converts all the core
> kernel callsites, both the open-coded ones and the old
> memclear_highpage_flush() ones.  Following this patch is a series of
> conversions for each file system individually, per AKPM, and finally a patch
> deprecating the old call.

For the reasons Anton identified, I think it is better design while we're here
to force callers to pass in the kmap-type which they wish to use for the atomic
kmap.  It makes the programmer think about what he wants to happen.  The price
of getting this wrong tends to be revoltingly rare file corruption.

But we cannot make this change in the obvious fashion, because the KM_FOO
identifiers are undefined if CONFIG_HIGHMEM=n.  So

	zero_user_page(page, 1, 2, KM_USER0);

won't compile on non-highmem.

So we are forced to use a macro, like below.

Also, you forgot to mark memclear_highpage_flush() __deprecated.

And I'm surprised that this:

+static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
+{
+	return zero_user_page(page, offset, size);
+}

compiled.  zero_user_page() returns void...


 drivers/block/loop.c    |    2 +-
 fs/buffer.c             |   21 ++++++++++++---------
 fs/direct-io.c          |    2 +-
 fs/mpage.c              |    6 ++++--
 include/linux/highmem.h |   29 +++++++++++++++++------------
 mm/filemap_xip.c        |    2 +-
 6 files changed, 36 insertions(+), 26 deletions(-)

diff -puN drivers/block/loop.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type drivers/block/loop.c
--- a/drivers/block/loop.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/drivers/block/loop.c
@@ -250,7 +250,7 @@ static int do_lo_send_aops(struct loop_d
 			 */
 			printk(KERN_ERR "loop: transfer error block %llu\n",
 			       (unsigned long long)index);
-			zero_user_page(page, offset, size);
+			zero_user_page(page, offset, size, KM_USER0);
 		}
 		flush_dcache_page(page);
 		ret = aops->commit_write(file, page, offset,
diff -puN fs/buffer.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type fs/buffer.c
--- a/fs/buffer.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/fs/buffer.c
@@ -1855,7 +1855,7 @@ static int __block_prepare_write(struct 
 			break;
 		if (buffer_new(bh)) {
 			clear_buffer_new(bh);
-			zero_user_page(page, block_start, bh->b_size);
+			zero_user_page(page, block_start, bh->b_size, KM_USER0);
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
 		}
@@ -1943,7 +1943,8 @@ int block_read_full_page(struct page *pa
 					SetPageError(page);
 			}
 			if (!buffer_mapped(bh)) {
-				zero_user_page(page, i * blocksize, blocksize);
+				zero_user_page(page, i * blocksize, blocksize,
+						KM_USER0);
 				if (!err)
 					set_buffer_uptodate(bh);
 				continue;
@@ -2107,7 +2108,8 @@ int cont_prepare_write(struct page *page
 						PAGE_CACHE_SIZE, get_block);
 		if (status)
 			goto out_unmap;
-		zero_user_page(page, zerofrom, PAGE_CACHE_SIZE-zerofrom);
+		zero_user_page(page, zerofrom, PAGE_CACHE_SIZE - zerofrom,
+				KM_USER0);
 		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
 		unlock_page(new_page);
 		page_cache_release(new_page);
@@ -2134,7 +2136,7 @@ int cont_prepare_write(struct page *page
 	if (status)
 		goto out1;
 	if (zerofrom < offset) {
-		zero_user_page(page, zerofrom, offset-zerofrom);
+		zero_user_page(page, zerofrom, offset - zerofrom, KM_USER0);
 		__block_commit_write(inode, page, zerofrom, offset);
 	}
 	return 0;
@@ -2333,7 +2335,7 @@ failed:
 	 * Error recovery is pretty slack.  Clear the page and mark it dirty
 	 * so we'll later zero out any blocks which _were_ allocated.
 	 */
-	zero_user_page(page, 0, PAGE_CACHE_SIZE);
+	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	return ret;
@@ -2402,7 +2404,7 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2436,7 +2438,8 @@ int nobh_truncate_page(struct address_sp
 	to = (offset + blocksize) & ~(blocksize - 1);
 	ret = a_ops->prepare_write(NULL, page, offset, to);
 	if (ret == 0) {
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
+		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
+				KM_USER0);
 		/*
 		 * It would be more correct to call aops->commit_write()
 		 * here, but this is more efficient.
@@ -2515,7 +2518,7 @@ int block_truncate_page(struct address_s
 			goto unlock;
 	}
 
-	zero_user_page(page, offset, length);
+	zero_user_page(page, offset, length, KM_USER0);
 	mark_buffer_dirty(bh);
 	err = 0;
 
@@ -2561,7 +2564,7 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
diff -puN fs/direct-io.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type fs/direct-io.c
--- a/fs/direct-io.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/fs/direct-io.c
@@ -888,7 +888,7 @@ do_holes:
 					goto out;
 				}
 				zero_user_page(page, block_in_page << blkbits,
-						1 << blkbits);
+						1 << blkbits, KM_USER0);
 				dio->block_in_file++;
 				block_in_page++;
 				goto next_block;
diff -puN fs/mpage.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type fs/mpage.c
--- a/fs/mpage.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/fs/mpage.c
@@ -285,7 +285,8 @@ do_mpage_readpage(struct bio *bio, struc
 
 	if (first_hole != blocks_per_page) {
 		zero_user_page(page, first_hole << blkbits,
-				PAGE_CACHE_SIZE - (first_hole << blkbits));
+				PAGE_CACHE_SIZE - (first_hole << blkbits),
+				KM_USER0);
 		if (first_hole == 0) {
 			SetPageUptodate(page);
 			unlock_page(page);
@@ -584,7 +585,8 @@ page_is_mapped:
 
 		if (page->index > end_index || !offset)
 			goto confused;
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
+		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
+				KM_USER0);
 	}
 
 	/*
diff -puN include/linux/highmem.h~fs-convert-core-functions-to-zero_user_page-pass-kmap-type include/linux/highmem.h
--- a/include/linux/highmem.h~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/include/linux/highmem.h
@@ -136,22 +136,27 @@ static inline void clear_highpage(struct
 
 /*
  * Same but also flushes aliased cache contents to RAM.
+ *
+ * This must be a macro because KM_USER0 and friends aren't defined if
+ * !CONFIG_HIGHMEM
  */
-static inline void zero_user_page(struct page *page, unsigned int offset, unsigned int size)
-{
-	void *kaddr;
-
-	BUG_ON(offset + size > PAGE_SIZE);
+#define zero_user_page(page, offset, size, km_type)		\
+	do {							\
+		void *kaddr;					\
+								\
+		BUG_ON(offset + size > PAGE_SIZE);		\
+								\
+		kaddr = kmap_atomic(page, km_type);		\
+		memset((char *)kaddr + offset, 0, size);	\
+		flush_dcache_page(page);			\
+		kunmap_atomic(kaddr, km_type);			\
+	} while (0)
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset((char *)kaddr + offset, 0, size);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-}
 
-static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
+static inline void memclear_highpage_flush(struct page *page,
+			unsigned int offset, unsigned int size) __deprecated
 {
-	return zero_user_page(page, offset, size);
+	zero_user_page(page, offset, size);
 }
 
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
diff -puN mm/filemap_xip.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type mm/filemap_xip.c
--- a/mm/filemap_xip.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/mm/filemap_xip.c
@@ -463,7 +463,7 @@ xip_truncate_page(struct address_space *
 		else
 			return PTR_ERR(page);
 	}
-	zero_user_page(page, offset, length);
+	zero_user_page(page, offset, length, KM_USER0);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_truncate_page);
_

