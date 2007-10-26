Return-Path: <linux-kernel-owner+w=401wt.eu-S1765866AbXJZV2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765866AbXJZV2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759349AbXJZV2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:28:40 -0400
Received: from mail2.opus-i.net ([209.10.181.134]:26591 "EHLO
	FPNYEXCFE01.opus-i.corp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757718AbXJZV2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:28:39 -0400
Message-ID: <47225835.4050309@datallegro.com>
Date: Fri, 26 Oct 2007 17:12:21 -0400
From: Karl Schendel <kschendel@datallegro.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org
Subject: [PATCH] Fix bad data from non-direct-io read after direct-io write
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2007 21:12:22.0628 (UTC) FILETIME=[E68A1240:01C81814]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a race between direct IO writes and non-direct IO
reads on the same file.  The symptom is a stale file page seen by
any non-direct-IO reader, which persists until the page is invalidated
somehow (e.g. page rewritten again, or memory pressure, or reboot).

An improper return test caused direct-IO's after-write page invalidations
to be skipped.  If we're writing page N, and the reader is reading
page N-x for small x, and the read code decides to readahead, it's
not too hard to cause a race that leaves an old, stale copy of the
page in the page cache.  Retval is usually +nonzero after the
mapping->a_ops->direct_IO call!

Signed-off-by: Karl Schendel <kschendel@datallegro.com>

---

By the way, I agree that the userland situation is stupid, and I'm
addressing that in the application (happens to be the Ingres DBMS).
However, the kernel shouldn't compound the stupidity.

I'll try to watch for replies, but it would be very useful to
cc me at kschendel@datallegro.com if any discussion is needed;
I'm not subscribed to lkml.


--- linux-2.6.23.1-base/mm/filemap.c	2007-10-12 12:43:44.000000000 -0400
+++ linux-2.6.23.1/mm/filemap.c	2007-10-26 16:12:08.000000000 -0400
@@ -2194,7 +2194,7 @@ generic_file_direct_IO(int rw, struct ki
 	}

 	retval = mapping->a_ops->direct_IO(rw, iocb, iov, offset, nr_segs);
-	if (retval)
+	if (retval < 0)
 		goto out;

 	/*
