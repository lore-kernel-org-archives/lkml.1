Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbXJ3Spx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbXJ3Spx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbXJ3Spl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:45:41 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:44374 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbXJ3Spk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:45:40 -0400
Message-ID: <47277BDA.6070702@oracle.com>
Date: Tue, 30 Oct 2007 11:45:46 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Karl Schendel <kschendel@datallegro.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix bad data from non-direct-io read after direct-io
 write
References: <47225835.4050309@datallegro.com> <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org> <47226A75.1020008@oracle.com> <alpine.LFD.0.999.0710261541410.30120@woody.linux-foundation.org> <47227015.6060708@oracle.com> <alpine.LFD.0.999.0710261611511.30120@woody.linux-foundation.org> <47227813.7040604@datallegro.com>
In-Reply-To: <47227813.7040604@datallegro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, I do - I'd been tripping over it once every couple weeks,
> and I finally figured out how to hold my mouth right so that it
> fails (almost) every time.

OK, I tested and verified Karl's fix and wrote some commentary around it.
(Would a aio-dio git repo on kernel.org for these kind of fixes be well
received?)

----
dio: fix cache invalidation after sync writes

Commit commit 65b8291c4000e5f38fc94fb2ca0cb7e8683c8a1b ("dio: invalidate clean
pages before dio write") introduced a bug which stopped dio from ever
invalidating the page cache after writes.  It still invalidated it before
writes so most users were fine.

Karl Schendel reported hitting this bug ( http://lkml.org/lkml/2007/10/26/481 )
when he had a buffered reader immediately reading file data after an O_DIRECT
wirter had written the data.  The kernel issued read-ahead beyond the position
of the reader which overlapped with the O_DIRECT writer.  The failure to
invalidate after writes caused the reader to see stale data from the
read-ahead.

The following patch is originally from Karl.  The following commentary is his:

	The below 3rd try takes on your suggestion of just invalidating
	no matter what the retval from the direct_IO call.  I ran it
	thru the test-case several times and it has worked every time.
	The post-invalidate is probably still too early for async-directio,
	but I don't have a testcase for that;  just sync.  And, this
	won't be any worse in the async case.

I added a test to the aio-dio-regress repository which mimics Karl's IO
pattern.  It verifed the bad behaviour and that the patch fixed it.  I agree
with Karl, this still doesn't help the case where a buffered reader follows an
AIO O_DIRECT writer.  That will require a bit more work.

This gives up on the idea of returning EIO to indicate to userspace that stale
data remains if the invalidation failed.

Signed-off-by: Zach Brown <zach.brown@oracle.com>

--- linux-2.6.23.1-base/mm/filemap.c	2007-10-12 12:43:44.000000000 -0400
+++ linux-2.6.23.1/mm/filemap.c	2007-10-26 19:21:20.000000000 -0400
@@ -2194,21 +2194,17 @@ generic_file_direct_IO(int rw, struct ki
 	}

 	retval = mapping->a_ops->direct_IO(rw, iocb, iov, offset, nr_segs);
-	if (retval)
-		goto out;

 	/*
 	 * Finally, try again to invalidate clean pages which might have been
-	 * faulted in by get_user_pages() if the source of the write was an
-	 * mmap()ed region of the file we're writing.  That's a pretty crazy
-	 * thing to do, so we don't support it 100%.  If this invalidation
-	 * fails and we have -EIOCBQUEUED we ignore the failure.
+	 * cached by non-direct readahead, or faulted in by get_user_pages()
+	 * if the source of the write was an mmap'ed region of the file
+	 * we're writing.  Either one is a pretty crazy thing to do,
+	 * so we don't support it 100%.  If this invalidation
+	 * fails, tough, the write still worked...
 	 */
 	if (rw == WRITE && mapping->nrpages) {
-		int err = invalidate_inode_pages2_range(mapping,
-					      offset >> PAGE_CACHE_SHIFT, end);
-		if (err && retval >= 0)
-			retval = err;
+		invalidate_inode_pages2_range(mapping, offset >> PAGE_CACHE_SHIFT, end);
 	}
 out:
 	return retval;

