Return-Path: <linux-kernel-owner+w=401wt.eu-S965627AbXFGCJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965627AbXFGCJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 22:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965062AbXFGCJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 22:09:47 -0400
Received: from mx1.suse.de ([195.135.220.2]:54208 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965032AbXFGCJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 22:09:46 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 7 Jun 2007 11:46:53 +1000
Message-Id: <1070607014653.27304@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [PATCH 001 of 2] Fix read/truncate race.
References: <20070607114043.26967.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


do_generic_mapping_read currently samples the i_size at the start
and doesn't do so again unless it needs to call ->readpage to load
a page.  After ->readpage it has to re-sample i_size as a truncate
may have caused that page to be filled with zeros, and the read()
call should not see these.

However there are other activities that might cause ->readpage to be
called on a page between the time that do_generic_mapping_read
samples i_size and when it finds that it has an uptodate page.  These
include at least read-ahead and possibly another thread performing a
read.

So do_generic_mapping_read must sample i_size *after* it has an
uptodate page.  Thus the current sampling at the start and after a read
can be replaced with a sampling before the copy-out.

The same change applied to __generic_file_splice_read.

Note that this fixes any race with truncate_complete_page, but does
not fix a possible race with truncate_partial_page.  If a partial
truncate happens after do_generic_mapping_read samples i_size and
before the copy_out, the nuls that truncate_partial_page place in the
page could be copied out incorrectly.

I think the best fix for that is to *not* zero out parts of the page
in truncate_partial_page, but rather to zero out the tail of a page
when increasing i_size.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>

Acked-by: Nick Piggin <npiggin@suse.de>
   (for the do_generic_mapping_read part)

### Diffstat output
 ./fs/splice.c  |   43 +++++++++++++++++-----------------
 ./mm/filemap.c |   72 ++++++++++++++++++++++-----------------------------------
 2 files changed, 50 insertions(+), 65 deletions(-)

diff .prev/fs/splice.c ./fs/splice.c
--- .prev/fs/splice.c	2007-06-07 11:34:16.000000000 +1000
+++ ./fs/splice.c	2007-06-07 11:34:23.000000000 +1000
@@ -412,31 +412,32 @@ __generic_file_splice_read(struct file *
 				break;
 			}
 
-			/*
-			 * i_size must be checked after ->readpage().
-			 */
-			isize = i_size_read(mapping->host);
-			end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
-			if (unlikely(!isize || index > end_index))
-				break;
+		}
+	fill_it:
+		/*
+		 * i_size must be checked after PageUptodate.
+		 */
+		isize = i_size_read(mapping->host);
+		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		if (unlikely(!isize || index > end_index))
+			break;
 
+		/*
+		 * if this is the last page, see if we need to shrink
+		 * the length and stop
+		 */
+		if (end_index == index) {
+			loff = PAGE_CACHE_SIZE - (isize & ~PAGE_CACHE_MASK);
+			if (total_len + loff > isize)
+				break;
 			/*
-			 * if this is the last page, see if we need to shrink
-			 * the length and stop
+			 * force quit after adding this page
 			 */
-			if (end_index == index) {
-				loff = PAGE_CACHE_SIZE - (isize & ~PAGE_CACHE_MASK);
-				if (total_len + loff > isize)
-					break;
-				/*
-				 * force quit after adding this page
-				 */
-				len = this_len;
-				this_len = min(this_len, loff);
-				loff = 0;
-			}
+			len = this_len;
+			this_len = min(this_len, loff);
+			loff = 0;
 		}
-fill_it:
+
 		partial[page_nr].offset = loff;
 		partial[page_nr].len = this_len;
 		len -= this_len;

diff .prev/mm/filemap.c ./mm/filemap.c
--- .prev/mm/filemap.c	2007-06-07 11:34:16.000000000 +1000
+++ ./mm/filemap.c	2007-06-07 11:34:24.000000000 +1000
@@ -871,13 +871,11 @@ void do_generic_mapping_read(struct addr
 {
 	struct inode *inode = mapping->host;
 	unsigned long index;
-	unsigned long end_index;
 	unsigned long offset;
 	unsigned long last_index;
 	unsigned long next_index;
 	unsigned long prev_index;
 	unsigned int prev_offset;
-	loff_t isize;
 	int error;
 	struct file_ra_state ra = *_ra;
 
@@ -888,27 +886,12 @@ void do_generic_mapping_read(struct addr
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
-	isize = i_size_read(inode);
-	if (!isize)
-		goto out;
-
-	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
 	for (;;) {
 		struct page *page;
+		unsigned long end_index;
+		loff_t isize;
 		unsigned long nr, ret;
 
-		/* nr is the maximum number of bytes to copy from this page */
-		nr = PAGE_CACHE_SIZE;
-		if (index >= end_index) {
-			if (index > end_index)
-				goto out;
-			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
-			if (nr <= offset) {
-				goto out;
-			}
-		}
-		nr = nr - offset;
-
 		cond_resched();
 find_page:
 		page = find_get_page(mapping, index);
@@ -928,6 +911,32 @@ find_page:
 		if (!PageUptodate(page))
 			goto page_not_up_to_date;
 page_ok:
+		/*
+		 * i_size must be checked after we know the page is Uptodate.
+		 *
+		 * Checking i_size after the check allows us to calculate
+		 * the correct value for "nr", which means the zero-filled
+		 * part of the page is not copied back to userspace (unless
+		 * another truncate extends the file - this is desired though).
+		 */
+
+		isize = i_size_read(inode);
+		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		if (unlikely(!isize || index > end_index)) {
+			page_cache_release(page);
+			goto out;
+		}
+
+		/* nr is the maximum number of bytes to copy from this page */
+		nr = PAGE_CACHE_SIZE;
+		if (index == end_index) {
+			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
+			if (nr <= offset) {
+				page_cache_release(page);
+				goto out;
+			}
+		}
+		nr = nr - offset;
 
 		/* If users can be writing to this page using arbitrary
 		 * virtual addresses, take care about potential aliasing
@@ -1014,31 +1023,6 @@ readpage:
 			unlock_page(page);
 		}
 
-		/*
-		 * i_size must be checked after we have done ->readpage.
-		 *
-		 * Checking i_size after the readpage allows us to calculate
-		 * the correct value for "nr", which means the zero-filled
-		 * part of the page is not copied back to userspace (unless
-		 * another truncate extends the file - this is desired though).
-		 */
-		isize = i_size_read(inode);
-		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
-		if (unlikely(!isize || index > end_index)) {
-			page_cache_release(page);
-			goto out;
-		}
-
-		/* nr is the maximum number of bytes to copy from this page */
-		nr = PAGE_CACHE_SIZE;
-		if (index == end_index) {
-			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
-			if (nr <= offset) {
-				page_cache_release(page);
-				goto out;
-			}
-		}
-		nr = nr - offset;
 		goto page_ok;
 
 readpage_error:
