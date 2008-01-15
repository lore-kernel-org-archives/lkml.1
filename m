Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYAOMse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYAOMse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYAOMsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:10 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:47977 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753162AbYAOMsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:07 -0500
Message-ID: <400401292.20625@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115124759.770126448@mail.ustc.edu.cn>
References: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:42 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/13] writeback: merge duplicate code into writeback_some_pages()
Content-Disposition: inline; filename=writeback-writeback_some_pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge duplicate code from background_writeout() and wb_kupdate() into
writeback_some_pages().

The pages_skipped in background_writeout() is ignored.  The inode cannot be
written now will be retried in the next run of pdflush, typically in 5s.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/page-writeback.c |   43 +++++++++++++++++++++---------------------
 1 files changed, 22 insertions(+), 21 deletions(-)

--- linux-mm.orig/mm/page-writeback.c
+++ linux-mm/mm/page-writeback.c
@@ -543,6 +543,24 @@ void throttle_vm_writeout(gfp_t gfp_mask
 }
 
 /*
+ * writeback up to @nr dirty pages.
+ * return true if there's more work.
+ */
+static int writeback_some_pages(struct writeback_control *wbc, int nr)
+{
+	wbc->more_io = 0;
+	wbc->encountered_congestion = 0;
+	wbc->nr_to_write = nr;
+
+	writeback_inodes(wbc);
+
+	if (wbc->encountered_congestion)
+		congestion_wait(WRITE, HZ/10);
+
+	return	wbc->more_io || wbc->encountered_congestion;
+}
+
+/*
  * writeback at least _min_pages, and keep writing until the amount of dirty
  * memory is less than the background threshold, or until we're all clean.
  */
@@ -553,7 +571,6 @@ static void background_writeout(unsigned
 		.bdi		= NULL,
 		.sync_mode	= WB_SYNC_NONE,
 		.older_than_this = NULL,
-		.nr_to_write	= 0,
 		.nonblocking	= 1,
 		.range_cyclic	= 1,
 	};
@@ -567,17 +584,9 @@ static void background_writeout(unsigned
 			global_page_state(NR_UNSTABLE_NFS) < background_thresh
 				&& min_pages <= 0)
 			break;
-		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
-		wbc.pages_skipped = 0;
-		writeback_inodes(&wbc);
+		if (!writeback_some_pages(&wbc, MAX_WRITEBACK_PAGES))
+			break;
 		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
-			/* Wrote less than expected */
-			congestion_wait(WRITE, HZ/10);
-			if (!wbc.encountered_congestion)
-				break;
-		}
 	}
 }
 
@@ -625,7 +634,6 @@ static void wb_kupdate(unsigned long arg
 		.bdi		= NULL,
 		.sync_mode	= WB_SYNC_NONE,
 		.older_than_this = &oldest_jif,
-		.nr_to_write	= 0,
 		.nonblocking	= 1,
 		.for_kupdate	= 1,
 		.range_cyclic	= 1,
@@ -640,15 +648,8 @@ static void wb_kupdate(unsigned long arg
 			global_page_state(NR_UNSTABLE_NFS) +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 	while (nr_to_write > 0) {
-		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
-		writeback_inodes(&wbc);
-		if (wbc.nr_to_write > 0) {
-			if (wbc.encountered_congestion)
-				congestion_wait(WRITE, HZ/10);
-			else
-				break;	/* All the old data is written */
-		}
+		if (!writeback_some_pages(&wbc, MAX_WRITEBACK_PAGES))
+			break;
 		nr_to_write -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 	}
 	if (time_before(next_jif, jiffies + HZ))

-- 
