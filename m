Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbXJZWK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbXJZWK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763510AbXJZWKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:10:46 -0400
Received: from mail3.opus-i.net ([209.10.181.135]:42121 "EHLO
	FPNYEXCFE02.opus-i.corp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763129AbXJZWKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:10:45 -0400
Message-ID: <472265E2.2060509@datallegro.com>
Date: Fri, 26 Oct 2007 18:10:42 -0400
From: Karl Schendel <kschendel@datallegro.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Leonid Ananiev <leonid.i.ananiev@linux.intel.com>
Subject: Re: [PATCH] Fix bad data from non-direct-io read after direct-io
 write
References: <47225835.4050309@datallegro.com> <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2007 22:10:43.0870 (UTC) FILETIME=[0D7133E0:01C8181D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> .... So we may
> actually end up doing some IO, but then returning the "wrong" error code
> from the invalidate. Hmm?
>

A point.  In an all-seeing, all-caring universe, it would be the read
hitting the cached page that couldn't be invalidated that would get
the error, not the write.  I can't get too worked up over that, though.

In any case, as you say, if the write worked it should report as such.
Perhaps this equivalent but slightly cleaned-up patch instead?

Karl

--- linux-2.6.23.1-base/mm/filemap.c	2007-10-12 12:43:44.000000000 -0400
+++ linux-2.6.23.1/mm/filemap.c	2007-10-26 18:00:00.000000000 -0400
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
-	if (rw == WRITE && mapping->nrpages) {
-		int err = invalidate_inode_pages2_range(mapping,
-					      offset >> PAGE_CACHE_SHIFT, end);
-		if (err && retval >= 0)
-			retval = err;
+	if (retval >= 0 && rw == WRITE && mapping->nrpages) {
+		invalidate_inode_pages2_range(mapping, offset >> PAGE_CACHE_SHIFT, end);
 	}
 out:
 	return retval;
