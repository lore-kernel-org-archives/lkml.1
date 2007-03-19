Return-Path: <linux-kernel-owner+w=401wt.eu-S1030656AbXCSVpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030656AbXCSVpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030619AbXCSVnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:43:09 -0400
Received: from mx1.suse.de ([195.135.220.2]:56051 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965138AbXCSVmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:42:50 -0400
Date: Mon, 19 Mar 2007 14:41:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Zach Brown <zach.brown@oracle.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Leonid Ananiev <leonid.i.ananiev@linux.intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [patch 28/31] dio: invalidate clean pages before dio write
Message-ID: <20070319214101.GD9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dio-invalidate-clean-pages-before-dio-write.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zach Brown <zach.brown@oracle.com>

[PATCH] dio: invalidate clean pages before dio write

This patch fixes a user-triggerable oops that was reported by Leonid
Ananiev as archived at http://lkml.org/lkml/2007/2/8/337.

dio writes invalidate clean pages that intersect the written region so that
subsequent buffered reads go to disk to read the new data.  If this fails
the interface tries to tell the caller that the cache is inconsistent by
returning EIO.

Before this patch we had the problem where this invalidation failure would
clobber -EIOCBQUEUED as it made its way from fs/direct-io.c to fs/aio.c.
Both fs/aio.c and bio completion call aio_complete() and we reference freed
memory, usually oopsing.

This patch addresses this problem by invalidating before the write so that
we can cleanly return -EIO before ->direct_IO() has had a chance to return
-EIOCBQUEUED.

There is a compromise here.  During the dio write we can fault in mmap()ed
pages which intersect the written range with get_user_pages() if the user
provided them for the source buffer.  This is a crazy thing to do, but we
can make it mostly work in most cases by trying the invalidation again.
The compromise is that we won't return an error if this second invalidation
fails if it's an AIO write and we have -EIOCBQUEUED.

This was tested by having two processes race performing large O_DIRECT and
buffered ordered writes.  Within minutes ext3 would see a race between
ext3_releasepage() and jbd holding a reference on ordered data buffers and
would cause invalidation to fail, panicing the box.  The test can be found
in the 'aio_dio_bugs' test group in test.kernel.org/autotest.  After this
patch the test passes.

Signed-off-by: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Leonid Ananiev <leonid.i.ananiev@linux.intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/filemap.c |   46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2393,7 +2393,8 @@ generic_file_direct_IO(int rw, struct ki
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	ssize_t retval;
-	size_t write_len = 0;
+	size_t write_len;
+	pgoff_t end = 0; /* silence gcc */
 
 	/*
 	 * If it's a write, unmap all mmappings of the file up-front.  This
@@ -2402,23 +2403,46 @@ generic_file_direct_IO(int rw, struct ki
 	 */
 	if (rw == WRITE) {
 		write_len = iov_length(iov, nr_segs);
+		end = (offset + write_len - 1) >> PAGE_CACHE_SHIFT;
 	       	if (mapping_mapped(mapping))
 			unmap_mapping_range(mapping, offset, write_len, 0);
 	}
 
 	retval = filemap_write_and_wait(mapping);
-	if (retval == 0) {
-		retval = mapping->a_ops->direct_IO(rw, iocb, iov,
-						offset, nr_segs);
-		if (rw == WRITE && mapping->nrpages) {
-			pgoff_t end = (offset + write_len - 1)
-						>> PAGE_CACHE_SHIFT;
-			int err = invalidate_inode_pages2_range(mapping,
+	if (retval)
+		goto out;
+
+	/*
+	 * After a write we want buffered reads to be sure to go to disk to get
+	 * the new data.  We invalidate clean cached page from the region we're
+	 * about to write.  We do this *before* the write so that we can return
+	 * -EIO without clobbering -EIOCBQUEUED from ->direct_IO().
+	 */
+	if (rw == WRITE && mapping->nrpages) {
+		retval = invalidate_inode_pages2_range(mapping,
 					offset >> PAGE_CACHE_SHIFT, end);
-			if (err)
-				retval = err;
-		}
+		if (retval)
+			goto out;
+	}
+
+	retval = mapping->a_ops->direct_IO(rw, iocb, iov, offset, nr_segs);
+	if (retval)
+		goto out;
+
+	/*
+	 * Finally, try again to invalidate clean pages which might have been
+	 * faulted in by get_user_pages() if the source of the write was an
+	 * mmap()ed region of the file we're writing.  That's a pretty crazy
+	 * thing to do, so we don't support it 100%.  If this invalidation
+	 * fails and we have -EIOCBQUEUED we ignore the failure.
+	 */
+	if (rw == WRITE && mapping->nrpages) {
+		int err = invalidate_inode_pages2_range(mapping,
+					      offset >> PAGE_CACHE_SHIFT, end);
+		if (err && retval >= 0)
+			retval = err;
 	}
+out:
 	return retval;
 }
 

-- 
