Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbXBDIwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbXBDIwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 03:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXBDIuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 03:50:44 -0500
Received: from mx1.suse.de ([195.135.220.2]:51390 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbXBDIuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 03:50:14 -0500
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>
Message-Id: <20070204063735.23659.95941.sendpatchset@linux.site>
In-Reply-To: <20070204063707.23659.20741.sendpatchset@linux.site>
References: <20070204063707.23659.20741.sendpatchset@linux.site>
Subject: [patch 3/9] mm: revert "generic_file_buffered_write(): deadlock on vectored write"
Date: Sun,  4 Feb 2007 09:50:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@osdl.org>

Revert 6527c2bdf1f833cc18e8f42bd97973d583e4aa83

This patch fixed the following bug:

  When prefaulting in the pages in generic_file_buffered_write(), we only
  faulted in the pages for the firts segment of the iovec.  If the second of
  successive segment described a mmapping of the page into which we're
  write()ing, and that page is not up-to-date, the fault handler tries to lock
  the already-locked page (to bring it up to date) and deadlocks.

  An exploit for this bug is in writev-deadlock-demo.c, in
  http://www.zip.com.au/~akpm/linux/patches/stuff/ext3-tools.tar.gz.

  (These demos assume blocksize < PAGE_CACHE_SIZE).

The problem with this fix is that it takes the kernel back to doing a single
prepare_write()/commit_write() per iovec segment.  So in the worst case we'll
run prepare_write+commit_write 1024 times where we previously would have run
it once. The other problem with the fix is that it fix all the locking problems.


<insert numbers obtained via ext3-tools's writev-speed.c here>

And apparently this change killed NFS overwrite performance, because, I
suppose, it talks to the server for each prepare_write+commit_write.

So just back that patch out - we'll be fixing the deadlock by other means.

Signed-off-by: Andrew Morton <akpm@osdl.org>

Nick says: also it only ever actually papered over the bug, because after
faulting in the pages, they might be unmapped or reclaimed.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -2090,21 +2090,14 @@ generic_file_buffered_write(struct kiocb
 	do {
 		unsigned long index;
 		unsigned long offset;
+		unsigned long maxlen;
 		size_t copied;
 
 		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
 		index = pos >> PAGE_CACHE_SHIFT;
 		bytes = PAGE_CACHE_SIZE - offset;
-
-		/* Limit the size of the copy to the caller's write size */
-		bytes = min(bytes, count);
-
-		/*
-		 * Limit the size of the copy to that of the current segment,
-		 * because fault_in_pages_readable() doesn't know how to walk
-		 * segments.
-		 */
-		bytes = min(bytes, cur_iov->iov_len - iov_base);
+		if (bytes > count)
+			bytes = count;
 
 		/*
 		 * Bring in the user page that we will copy from _first_.
@@ -2112,7 +2105,10 @@ generic_file_buffered_write(struct kiocb
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		fault_in_pages_readable(buf, bytes);
+		maxlen = cur_iov->iov_len - iov_base;
+		if (maxlen > bytes)
+			maxlen = bytes;
+		fault_in_pages_readable(buf, maxlen);
 
 		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
 		if (!page) {
