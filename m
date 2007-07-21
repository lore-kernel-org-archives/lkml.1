Return-Path: <linux-kernel-owner+w=401wt.eu-S1762569AbXGUD7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762569AbXGUD7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 23:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbXGUD65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:58:57 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54710 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755422AbXGUD6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:58:54 -0400
Message-ID: <384990325.22666@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070721035852.104255316@mail.ustc.edu.cn>
References: <20070721035733.951838089@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 11:57:41 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 8/8] basic support of interleaved reads
Content-Disposition: inline; filename=readahead-interleaved-reads.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simplified version of the pagecache context based readahead.
It handles the case of multiple threads reading on the same fd and invalidating
each others' readahead state. It does the trick by scanning the pagecache and
recovering the current read stream's readahead status.

The algorithm works in a opportunistic way, in that it do not try to detect
interleaved reads _actively_, which requires a probe into the page cache(which
means a little more overheads for random reads). It only tries to handle a
previously started sequential readahead whose state was overwritten by
another concurrent stream, and it can do this job pretty well.

Negative and positive examples(or what you can expect from it):

1) it cannot detect and serve perfect request-by-request interleaved reads
   right:
	time	stream 1  stream 2
	0 	1         
	1 	          1001
	2 	2
	3 	          1002
	4 	3
	5 	          1003
	6 	4
	7 	          1004
	8 	5
	9	          1005
Here no single readahead will be carried out.

2) However, if it's two concurrent reads by two threads, the chance of the
   initial sequential readahead be started is huge. Once the first sequential
   readahead is started for a stream, this patch will ensure that the readahead
   window continues to rampup and won't be disturbed by other streams.

	time	stream 1  stream 2
	0 	1         
	1 	2
	2 	          1001
	3 	3
	4 	          1002
	5 	          1003
	6 	4
	7 	5
	8 	          1004
	9 	6
	10	          1005
	11	7
	12	          1006
	13	          1007
Here steam 1 will start a readahead at page 2, and stream 2 will start its
first readahead at page 1003. From then on the two streams will be served right.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- linux-2.6.22-git15.orig/mm/readahead.c
+++ linux-2.6.22-git15/mm/readahead.c
@@ -371,6 +371,29 @@ ondemand_readahead(struct address_space 
 	}
 
 	/*
+	 * Hit a marked page without valid readahead state.
+	 * E.g. interleaved reads.
+	 * Query the pagecache for async_size, which normally equals to
+	 * readahead size. Ramp it up and use it as the new readahead size.
+	 */
+	if (hit_readahead_marker) {
+		pgoff_t start;
+
+		read_lock_irq(&mapping->tree_lock);
+		start = radix_tree_scan_hole(&mapping->page_tree, offset, max+1);
+		read_unlock_irq(&mapping->tree_lock);
+
+		if (!start || start - offset > max)
+			return 0;
+
+		ra->start = start;
+		ra->size = start - offset;	/* old async_size */
+		ra->size = get_next_ra_size(ra, max);
+		ra->async_size = ra->size;
+		goto readit;
+	}
+
+	/*
 	 * It may be one of
 	 * 	- first read on start of file
 	 * 	- sequential cache miss
@@ -381,16 +404,6 @@ ondemand_readahead(struct address_space 
 	ra->size = get_init_ra_size(req_size, max);
 	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
 
-	/*
-	 * Hit on a marked page without valid readahead state.
-	 * E.g. interleaved reads.
-	 * Not knowing its readahead pos/size, bet on the minimal possible one.
-	 */
-	if (hit_readahead_marker) {
-		ra->start++;
-		ra->size = get_next_ra_size(ra, max);
-	}
-
 readit:
 	return ra_submit(ra, mapping, filp);
 }

--
