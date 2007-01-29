Return-Path: <linux-kernel-owner+w=401wt.eu-S933143AbXA2Kdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbXA2Kdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933022AbXA2KdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:33:12 -0500
Received: from ns2.suse.de ([195.135.220.15]:34809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbXA2Kcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:32:42 -0500
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>
Message-Id: <20070129082000.23584.99758.sendpatchset@linux.site>
In-Reply-To: <20070129081905.23584.97878.sendpatchset@linux.site>
References: <20070129081905.23584.97878.sendpatchset@linux.site>
Subject: [patch 6/9] mm: be sure to trim blocks
Date: Mon, 29 Jan 2007 11:32:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If prepare_write fails with AOP_TRUNCATED_PAGE, or if commit_write fails, then
we may have failed the write operation despite prepare_write having
instantiated blocks past i_size. Fix this, and consolidate the trimming into
one place.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -1911,22 +1911,9 @@ generic_file_buffered_write(struct kiocb
 		}
 
 		status = a_ops->prepare_write(file, page, offset, offset+bytes);
-		if (unlikely(status)) {
-			loff_t isize = i_size_read(inode);
+		if (unlikely(status))
+			goto fs_write_aop_error;
 
-			if (status != AOP_TRUNCATED_PAGE)
-				unlock_page(page);
-			page_cache_release(page);
-			if (status == AOP_TRUNCATED_PAGE)
-				continue;
-			/*
-			 * prepare_write() may have instantiated a few blocks
-			 * outside i_size.  Trim these off again.
-			 */
-			if (pos + bytes > isize)
-				vmtruncate(inode, isize);
-			break;
-		}
 		if (likely(nr_segs == 1))
 			copied = filemap_copy_from_user(page, offset,
 							buf, bytes);
@@ -1935,40 +1922,53 @@ generic_file_buffered_write(struct kiocb
 						cur_iov, iov_offset, bytes);
 		flush_dcache_page(page);
 		status = a_ops->commit_write(file, page, offset, offset+bytes);
-		if (status == AOP_TRUNCATED_PAGE) {
-			page_cache_release(page);
-			continue;
+		if (unlikely(status < 0))
+			goto fs_write_aop_error;
+		if (unlikely(copied != bytes)) {
+			status = -EFAULT;
+			goto fs_write_aop_error;
 		}
-		if (likely(copied > 0)) {
-			if (!status)
-				status = copied;
+		if (unlikely(status > 0)) /* filesystem did partial write */
+			copied = status;
 
-			if (status >= 0) {
-				written += status;
-				count -= status;
-				pos += status;
-				buf += status;
-				if (unlikely(nr_segs > 1)) {
-					filemap_set_next_iovec(&cur_iov,
-							&iov_offset, status);
-					if (count)
-						buf = cur_iov->iov_base +
-							iov_offset;
-				} else {
-					iov_offset += status;
-				}
+		if (likely(copied > 0)) {
+			written += copied;
+			count -= copied;
+			pos += copied;
+			buf += copied;
+			if (unlikely(nr_segs > 1)) {
+				filemap_set_next_iovec(&cur_iov,
+						&iov_offset, copied);
+				if (count)
+					buf = cur_iov->iov_base + iov_offset;
+			} else {
+				iov_offset += copied;
 			}
 		}
-		if (unlikely(copied != bytes))
-			if (status >= 0)
-				status = -EFAULT;
 		unlock_page(page);
 		mark_page_accessed(page);
 		page_cache_release(page);
-		if (status < 0)
-			break;
 		balance_dirty_pages_ratelimited(mapping);
 		cond_resched();
+		continue;
+
+fs_write_aop_error:
+		if (status != AOP_TRUNCATED_PAGE)
+			unlock_page(page);
+		page_cache_release(page);
+
+		/*
+		 * prepare_write() may have instantiated a few blocks
+		 * outside i_size.  Trim these off again. Don't need
+		 * i_size_read because we hold i_mutex.
+		 */
+		if (pos + bytes > inode->i_size)
+			vmtruncate(inode, inode->i_size);
+		if (status == AOP_TRUNCATED_PAGE)
+			continue;
+		else
+			break;
+
 	} while (count);
 	*ppos = pos;
 
