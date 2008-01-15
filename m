Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYAOMuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYAOMuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYAOMsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:23 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:47882 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751417AbYAOMsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:08 -0500
Message-ID: <400401290.18034@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115124758.142052041@mail.ustc.edu.cn>
References: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:38 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/13] writeback: revert 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b
Content-Disposition: inline; filename=revert-more_io.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
fs/fs-writeback.c         |    2 --
 include/linux/writeback.h |    1 -
 mm/page-writeback.c       |    9 +++------
 3 files changed, 3 insertions(+), 9 deletions(-)

Index: linux-mm/include/linux/writeback.h
===================================================================
--- linux-mm.orig/include/linux/writeback.h
+++ linux-mm/include/linux/writeback.h
@@ -62,7 +62,6 @@ struct writeback_control {
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
-	unsigned more_io:1;		/* more io to be dispatched */
 };
 
 /*
Index: linux-mm/fs/fs-writeback.c
===================================================================
--- linux-mm.orig/fs/fs-writeback.c
+++ linux-mm/fs/fs-writeback.c
@@ -475,8 +475,6 @@ int generic_sync_sb_inodes(struct super_
 		if (wbc->nr_to_write <= 0)
 			break;
 	}
-	if (!list_empty(&sb->s_more_io))
-		wbc->more_io = 1;
 	spin_unlock(&inode_lock);
 	return ret;		/* Leave any unwritten inodes on s_io */
 }
Index: linux-mm/mm/page-writeback.c
===================================================================
--- linux-mm.orig/mm/page-writeback.c
+++ linux-mm/mm/page-writeback.c
@@ -567,7 +567,6 @@ static void background_writeout(unsigned
 			global_page_state(NR_UNSTABLE_NFS) < background_thresh
 				&& min_pages <= 0)
 			break;
-		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
@@ -575,9 +574,8 @@ static void background_writeout(unsigned
 		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
 			/* Wrote less than expected */
-			if (wbc.encountered_congestion || wbc.more_io)
-				congestion_wait(WRITE, HZ/10);
-			else
+			congestion_wait(WRITE, HZ/10);
+			if (!wbc.encountered_congestion)
 				break;
 		}
 	}
@@ -642,12 +640,11 @@ static void wb_kupdate(unsigned long arg
 			global_page_state(NR_UNSTABLE_NFS) +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 	while (nr_to_write > 0) {
-		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		writeback_inodes(&wbc);
 		if (wbc.nr_to_write > 0) {
-			if (wbc.encountered_congestion || wbc.more_io)
+			if (wbc.encountered_congestion)
 				congestion_wait(WRITE, HZ/10);
 			else
 				break;	/* All the old data is written */

-- 
