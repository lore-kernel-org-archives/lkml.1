Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZIIPIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZIIPIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZIIPIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:08:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:65365 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbZIIPIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:08:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185728218"
Message-Id: <20090909150601.042115851@intel.com>
References: <20090909145141.293229693@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Sep 2009 22:51:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Hellwig <hch@infradead.org>
CC: jack@suse.cz
CC: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>
Subject: [RFC][PATCH 6/7] writeback: dont abort inode on congestion
Content-Disposition: inline; filename=writeback-requeue-congestion.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retry writeback of the current inode when encountered congestion,
instead of redirting it, which may have the problems
- slow down writeback pace
- lead to small writeback io

Cc: Martin Bligh <mbligh@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Chad Talbott <ctalbott@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-09 21:55:19.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-09 22:04:23.000000000 +0800
@@ -460,9 +460,11 @@ writeback_single_inode(struct inode *ino
 			 * sometimes bales out without doing anything.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
-			if (wbc->nr_to_write <= 0) {
+			if (wbc->encountered_congestion ||
+			    wbc->nr_to_write <= 0) {
 				/*
-				 * slice used up: queue for next turn
+				 * if slice used up, queue for next round;
+				 * otherwise continue this inode after return
 				 */
 				requeue_partial_io(wbc, inode);
 			} else {

-- 

