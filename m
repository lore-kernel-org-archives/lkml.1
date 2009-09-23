Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbZIWMpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbZIWMpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZIWMpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:45:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:41517 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbZIWMnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:43:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,438,1249282800"; 
   d="scan'208";a="190735400"
Message-Id: <20090923124027.780327270@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 23 Sep 2009 20:33:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] writeback: kupdate writeback shall not stop when more io is possible
References: <20090923123337.990689487@intel.com>
Content-Disposition: inline; filename=writeback-more-io.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the kupdate case, which disregards wbc.more_io and stop writeback
prematurely even when there are more inodes to be synced.

wbc.more_io should always be respected.

Also remove the pages_skipped check. It will set when some page(s) of some
inode(s) cannot be written for now. Such inodes will be delayed for a while.
This variable has nothing to do with whether there are other writeable inodes.

CC: Jan Kara <jack@suse.cz>
CC: Dave Chinner <david@fromorbit.com>
CC: Jens Axboe <jens.axboe@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-23 18:13:36.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-23 18:33:17.000000000 +0800
@@ -756,8 +756,8 @@ static long wb_writeback(struct bdi_writ
 		/*
 		 * If we ran out of stuff to write, bail unless more_io got set
 		 */
-		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
-			if (wbc.more_io && !wbc.for_kupdate) {
+		if (wbc.nr_to_write > 0) {
+			if (wbc.more_io) {
 				if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
 					continue;
 				/*


