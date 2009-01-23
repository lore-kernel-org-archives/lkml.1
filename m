Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbZAWB2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbZAWB2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZAWBPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:42 -0500
Received: from kroah.org ([198.145.64.141]:50857 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758682AbZAWBPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:21 -0500
Date: Thu, 22 Jan 2009 17:13:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>
Subject: [patch 43/46] mm: direct IO starvation improvement
Message-ID: <20090123011309.GR19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-direct-io-starvation-improvement.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 48b47c561e41525061b5bc0cfd67d6367fd11dc4 upstream.

Direct IO can invalidate and sync a lot of pagecache pages in the mapping.
 A 4K direct IO will actually try to sync and/or invalidate the pagecache
of the entire file, for example (which might be many GB or TB large).

Improve this by doing range syncs.  Also, memory no longer has to be
unmapped to catch the dirty bits for syncing, as dirty bits would remain
coherent due to dirty mmap accounting.

This fixes the immediate DM deadlocks when doing direct IO reads to block
device with a mounted filesystem, if only by papering over the problem
somewhat rather than addressing the fsync starvation cases.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/filemap.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1317,7 +1317,8 @@ generic_file_aio_read(struct kiocb *iocb
 			goto out; /* skip atime */
 		size = i_size_read(inode);
 		if (pos < size) {
-			retval = filemap_write_and_wait(mapping);
+			retval = filemap_write_and_wait_range(mapping, pos,
+					pos + iov_length(iov, nr_segs) - 1);
 			if (!retval) {
 				retval = mapping->a_ops->direct_IO(READ, iocb,
 							iov, pos, nr_segs);
@@ -2067,18 +2068,10 @@ generic_file_direct_write(struct kiocb *
 	if (count != ocount)
 		*nr_segs = iov_shorten((struct iovec *)iov, *nr_segs, count);
 
-	/*
-	 * Unmap all mmappings of the file up-front.
-	 *
-	 * This will cause any pte dirty bits to be propagated into the
-	 * pageframes for the subsequent filemap_write_and_wait().
-	 */
 	write_len = iov_length(iov, *nr_segs);
 	end = (pos + write_len - 1) >> PAGE_CACHE_SHIFT;
-	if (mapping_mapped(mapping))
-		unmap_mapping_range(mapping, pos, write_len, 0);
 
-	written = filemap_write_and_wait(mapping);
+	written = filemap_write_and_wait_range(mapping, pos, pos + write_len - 1);
 	if (written)
 		goto out;
 
@@ -2298,7 +2291,8 @@ generic_file_buffered_write(struct kiocb
 	 * the file data here, to try to honour O_DIRECT expectations.
 	 */
 	if (unlikely(file->f_flags & O_DIRECT) && written)
-		status = filemap_write_and_wait(mapping);
+		status = filemap_write_and_wait_range(mapping,
+					pos, pos + written - 1);
 
 	return written ? written : status;
 }

