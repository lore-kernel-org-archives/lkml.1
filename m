Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbZKRIb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbZKRIb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZKRIb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:31:56 -0500
Received: from mga14.intel.com ([143.182.124.37]:15558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbZKRIbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830410"
Message-Id: <20091118082846.790387883@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:26:59 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/12] writeback: introduce wbc.for_background
References: <20091118082648.140755818@intel.com>
Content-Disposition: inline; filename=writeback-add-wbc-for_background.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will lower the flush priority for NFS, and maybe more in future.

CC: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    1 +
 fs/nfs/write.c            |    2 +-
 include/linux/writeback.h |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

--- linux.orig/fs/fs-writeback.c	2009-11-18 16:26:04.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-11-18 16:26:07.000000000 +0800
@@ -713,6 +713,7 @@ static long wb_writeback(struct bdi_writ
 		.sync_mode		= args->sync_mode,
 		.older_than_this	= NULL,
 		.for_kupdate		= args->for_kupdate,
+		.for_background		= args->for_background,
 		.range_cyclic		= args->range_cyclic,
 	};
 	unsigned long oldest_jif;
--- linux.orig/include/linux/writeback.h	2009-11-18 16:25:28.000000000 +0800
+++ linux/include/linux/writeback.h	2009-11-18 16:26:07.000000000 +0800
@@ -76,6 +76,7 @@ struct writeback_control {
 	unsigned nonblocking:1;		/* Don't get stuck on request queues */
 	unsigned encountered_congestion:1; /* An output: a queue is full */
 	unsigned for_kupdate:1;		/* A kupdate writeback */
+	unsigned for_background:1;	/* A background writeback */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
--- linux.orig/fs/nfs/write.c	2009-11-18 16:25:28.000000000 +0800
+++ linux/fs/nfs/write.c	2009-11-18 16:26:07.000000000 +0800
@@ -178,7 +178,7 @@ static int wb_priority(struct writeback_
 {
 	if (wbc->for_reclaim)
 		return FLUSH_HIGHPRI | FLUSH_STABLE;
-	if (wbc->for_kupdate)
+	if (wbc->for_kupdate || wbc->for_background)
 		return FLUSH_LOWPRI;
 	return 0;
 }


