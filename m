Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZK0LgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZK0LgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZK0LgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:36:14 -0500
Received: from mga14.intel.com ([143.182.124.37]:59064 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbZK0LgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:36:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,300,1257148800"; 
   d="scan'208";a="216271194"
Message-Id: <20091127110408.076200992@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 27 Nov 2009 18:59:14 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 6/6] writeback: introduce wbc.for_background
References: <20091127105908.944744141@intel.com>
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

--- linux.orig/fs/fs-writeback.c	2009-11-27 18:55:11.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-11-27 18:55:17.000000000 +0800
@@ -730,6 +730,7 @@ static long wb_writeback(struct bdi_writ
 		.sync_mode		= args->sync_mode,
 		.older_than_this	= NULL,
 		.for_kupdate		= args->for_kupdate,
+		.for_background		= args->for_background,
 		.range_cyclic		= args->range_cyclic,
 	};
 	unsigned long oldest_jif;
--- linux.orig/include/linux/writeback.h	2009-11-27 16:35:00.000000000 +0800
+++ linux/include/linux/writeback.h	2009-11-27 18:55:17.000000000 +0800
@@ -49,6 +49,7 @@ struct writeback_control {
 	unsigned nonblocking:1;		/* Don't get stuck on request queues */
 	unsigned encountered_congestion:1; /* An output: a queue is full */
 	unsigned for_kupdate:1;		/* A kupdate writeback */
+	unsigned for_background:1;	/* A background writeback */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
--- linux.orig/fs/nfs/write.c	2009-11-19 16:00:50.000000000 +0800
+++ linux/fs/nfs/write.c	2009-11-27 18:55:17.000000000 +0800
@@ -178,7 +178,7 @@ static int wb_priority(struct writeback_
 {
 	if (wbc->for_reclaim)
 		return FLUSH_HIGHPRI | FLUSH_STABLE;
-	if (wbc->for_kupdate)
+	if (wbc->for_kupdate || wbc->for_background)
 		return FLUSH_LOWPRI;
 	return 0;
 }


