Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbZIXOmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbZIXOmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZIXOkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:40:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44125 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZIXOkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:40:36 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, shaohua.li@intel.com, chris.mason@oracle.com,
       jack@suse.cz, Dave Chinner <david@fromorbit.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 04/10] writeback: kupdate writeback shall not stop when more io is possible
Date: Thu, 24 Sep 2009 16:40:30 +0200
Message-Id: <1253803236-20760-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-Reply-To: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

Fix the kupdate case, which disregards wbc.more_io and stop writeback
prematurely even when there are more inodes to be synced.

wbc.more_io should always be respected.

Also remove the pages_skipped check. It will set when some page(s) of some
inode(s) cannot be written for now. Such inodes will be delayed for a while.
This variable has nothing to do with whether there are other writeable inodes.

CC: Jan Kara <jack@suse.cz>
CC: Dave Chinner <david@fromorbit.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 476be9b..551684d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -753,8 +753,8 @@ static long wb_writeback(struct bdi_writeback *wb,
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
-- 
1.6.4.1.207.g68ea

