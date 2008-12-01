Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbYLADTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbYLADTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 22:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYLADTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 22:19:35 -0500
Received: from mga14.intel.com ([143.182.124.37]:26352 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbYLADTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 22:19:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,692,1220252400"; 
   d="scan'208";a="84691709"
Date: Mon, 1 Dec 2008 11:19:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Subject: [PATCH] nfs: remove redundant tests on reading new pages
Message-ID: <20081201031922.GA31077@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aops->readpages() and its NFS helper readpage_async_filler() will only
be called to do readahead I/O for newly allocated pages. So it's not
necessary to test for the always 0 dirty/uptodate page flags.

The removal of nfs_wb_page() call also fixes a readahead bug: the NFS
readahead has been synchronous since 2.6.23, because that call will
clear PG_readahead, which is the reminder for asynchronous readahead.

More background: the PG_readahead page flag is shared with PG_reclaim,
one for read path and the other for write path. clear_page_dirty_for_io()
unconditionally clears PG_readahead to prevent possible readahead residuals,
assuming itself to be always called in the write path. However, NFS is one
and the only exception in that it _always_ calls clear_page_dirty_for_io()
in the read path, i.e. for readpages()/readpage().

Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
---
 fs/nfs/read.c |    6 ------
 1 file changed, 6 deletions(-)

This bug was found when playing with my readahead tracing module posted at
http://lkml.org/lkml/2008/11/27/373 and confirmed to work.

The NFS readahead traces are now

[   59.972526] readahead-initial0(pid=3646(dd), dev=00:0f(0:f), ino=293189(1G), req=0+25, ra=0+60-30, async=0) = 60
[   59.992734] readahead-subsequent(pid=3646(dd), dev=00:0f(0:f), ino=293189(1G), req=30+20, ra=60+30-30, async=1) = 30
[   60.030900] readahead-subsequent(pid=3646(dd), dev=00:0f(0:f), ino=293189(1G), req=60+15, ra=90+30-30, async=1) = 30
[   60.031687] readahead-subsequent(pid=3646(dd), dev=00:0f(0:f), ino=293189(1G), req=90+10, ra=120+30-30, async=1) = 30

The async field was always 0 before this patch.

--- linux-2.6.orig/fs/nfs/read.c
+++ linux-2.6/fs/nfs/read.c
@@ -533,12 +533,6 @@ readpage_async_filler(void *data, struct
 	unsigned int len;
 	int error;
 
-	error = nfs_wb_page(inode, page);
-	if (error)
-		goto out_unlock;
-	if (PageUptodate(page))
-		goto out_unlock;
-
 	len = nfs_page_length(page);
 	if (len == 0)
 		return nfs_return_empty_page(page);
