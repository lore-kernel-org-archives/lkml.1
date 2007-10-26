Return-Path: <linux-kernel-owner+w=401wt.eu-S1764323AbXJZX23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764323AbXJZX23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbXJZX2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:28:22 -0400
Received: from mail2.opus-i.net ([209.10.181.134]:44808 "EHLO
	FPNYEXCFE01.opus-i.corp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752640AbXJZX2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:28:21 -0400
Message-ID: <47227813.7040604@datallegro.com>
Date: Fri, 26 Oct 2007 19:28:19 -0400
From: Karl Schendel <kschendel@datallegro.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Leonid Ananiev <leonid.i.ananiev@linux.intel.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix bad data from non-direct-io read after direct-io
 write
References: <47225835.4050309@datallegro.com> <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org> <47226A75.1020008@oracle.com> <alpine.LFD.0.999.0710261541410.30120@woody.linux-foundation.org> <47227015.6060708@oracle.com> <alpine.LFD.0.999.0710261611511.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710261611511.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2007 23:28:20.0245 (UTC) FILETIME=[E4DBA450:01C81827]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 26 Oct 2007, Zach Brown wrote:
>> I can throw together a patch if you haven't already committed one by the
>> time you read this ;).
> 
> I'm not touching that code except to send out possible patches for others 
> to test and comment on. I have no test-cases, nor any real interest in it. 
> So yeah, please send me a tested and thought-through patch.
> 
> It sounded like Karl actually had a test-case to trigger this...

Yes, I do - I'd been tripping over it once every couple weeks,
and I finally figured out how to hold my mouth right so that it
fails (almost) every time.

The below 3rd try takes on your suggestion of just invalidating
no matter what the retval from the direct_IO call.  I ran it
thru the test-case several times and it has worked every time.
The post-invalidate is probably still too early for async-directio,
but I don't have a testcase for that;  just sync.  And, this
won't be any worse in the async case.

Karl

---

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
