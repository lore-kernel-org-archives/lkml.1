Return-Path: <linux-kernel-owner+w=401wt.eu-S934008AbZJGIB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbZJGIB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933984AbZJGIBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:9396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933982AbZJGIBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971670"
Message-Id: <20091007074905.265923767@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 32/45] writeback: update kupdate expire timestamp on each scan of b_io
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-moving-expired.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents it to stuck with some very old but busy inodes,
and to give newer expired inodes a fair chance.

CC: Jan Kara <jack@suse.cz> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:39:31.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:39:32.000000000 +0800
@@ -829,6 +829,9 @@ static long wb_writeback(struct bdi_writ
 		args->nr_pages -= nr;
 		wrote += nr;
 
+		if (args->for_kupdate && list_empty(&wb->b_io))
+			oldest_jif = jiffies - expire_interval;
+
 		if (args->for_background && expire_interval &&
 		    ++fg_rounds && list_empty(&wb->b_io)) {
 			if (fg_rounds < 10)


