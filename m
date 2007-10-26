Return-Path: <linux-kernel-owner+w=401wt.eu-S1765036AbXJZVf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765036AbXJZVf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbXJZVfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:35:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757745AbXJZVfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:35:12 -0400
Date: Fri, 26 Oct 2007 14:34:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Karl Schendel <kschendel@datallegro.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Leonid Ananiev <leonid.i.ananiev@linux.intel.com>
Subject: Re: [PATCH] Fix bad data from non-direct-io read after direct-io
 write
In-Reply-To: <47225835.4050309@datallegro.com>
Message-ID: <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org>
References: <47225835.4050309@datallegro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm. If I read this right, this bug seems to have been introduced by 
commit 65b8291c4000e5f38fc94fb2ca0cb7e8683c8a1b ("dio: invalidate clean 
pages before dio write") back in March.

Before that, we'd call invalidate_inode_pages2_range() unconditionally 
after the call mapping->a_ops->direct_IO() if it was a write and there 
were cached pages in the mapping (well, "unconditionally" in the sense 
that it didn't depend on the return value of the ->direct_IO() call).

However, with both the old and the new code _and_ with your patch, the 
return code - in case the invalidate failed - was corrupted. So we may 
actually end up doing some IO, but then returning the "wrong" error code 
from the invalidate. Hmm?

Somebody who cares about direct-IO and who - unlike me - doesn't think 
it's a total and idiotic crock should think hard about this. I'm including 
Karl's email, but also an alternate patch for consideration.

And maybe some day we can all agree that direct_IO is crap and should not 
be done.

		Linus

--
diff --git a/mm/filemap.c b/mm/filemap.c
index 5209e47..032371a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2510,22 +2510,17 @@ generic_file_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	}
 
 	retval = mapping->a_ops->direct_IO(rw, iocb, iov, offset, nr_segs);
-	if (retval)
+	if (retval < 0)
 		goto out;
 
 	/*
 	 * Finally, try again to invalidate clean pages which might have been
 	 * faulted in by get_user_pages() if the source of the write was an
 	 * mmap()ed region of the file we're writing.  That's a pretty crazy
-	 * thing to do, so we don't support it 100%.  If this invalidation
-	 * fails and we have -EIOCBQUEUED we ignore the failure.
+	 * thing to do, so we don't support it 100%.
 	 */
-	if (rw == WRITE && mapping->nrpages) {
-		int err = invalidate_inode_pages2_range(mapping,
-					      offset >> PAGE_CACHE_SHIFT, end);
-		if (err && retval >= 0)
-			retval = err;
-	}
+	if (rw == WRITE && mapping->nrpages)
+		invalidate_inode_pages2_range(mapping, offset >> PAGE_CACHE_SHIFT, end);
 out:
 	return retval;
 }

On Fri, 26 Oct 2007, Karl Schendel wrote:
>
> This patch fixes a race between direct IO writes and non-direct IO
> reads on the same file.  The symptom is a stale file page seen by
> any non-direct-IO reader, which persists until the page is invalidated
> somehow (e.g. page rewritten again, or memory pressure, or reboot).
> 
> An improper return test caused direct-IO's after-write page invalidations
> to be skipped.  If we're writing page N, and the reader is reading
> page N-x for small x, and the read code decides to readahead, it's
> not too hard to cause a race that leaves an old, stale copy of the
> page in the page cache.  Retval is usually +nonzero after the
> mapping->a_ops->direct_IO call!
> 
> Signed-off-by: Karl Schendel <kschendel@datallegro.com>
> 
> ---
> 
> By the way, I agree that the userland situation is stupid, and I'm
> addressing that in the application (happens to be the Ingres DBMS).
> However, the kernel shouldn't compound the stupidity.
> 
> I'll try to watch for replies, but it would be very useful to
> cc me at kschendel@datallegro.com if any discussion is needed;
> I'm not subscribed to lkml.
> 
> 
> --- linux-2.6.23.1-base/mm/filemap.c	2007-10-12 12:43:44.000000000 -0400
> +++ linux-2.6.23.1/mm/filemap.c	2007-10-26 16:12:08.000000000 -0400
> @@ -2194,7 +2194,7 @@ generic_file_direct_IO(int rw, struct ki
>  	}
> 
>  	retval = mapping->a_ops->direct_IO(rw, iocb, iov, offset, nr_segs);
> -	if (retval)
> +	if (retval < 0)
>  		goto out;
> 
>  	/*
> 
