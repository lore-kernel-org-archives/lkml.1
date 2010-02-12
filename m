Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab0BLJQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:16:15 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47220 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab0BLJQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:16:12 -0500
Date: Fri, 12 Feb 2010 10:16:09 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, jack@suse.cz,
       jengelh@medozas.de, stable@kernel.org, gregkh@suse.de
Subject: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100212091609.GB1025@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="phCU5ROyZO6kBE05"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--phCU5ROyZO6kBE05
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

There's currently a writeback bug in the 2.6.32 and 2.6.33-rc kernels
that prevent proper writeback when sync(1) is being run. Instead of
flushing everything older than the sync run, it will do chunks of normal
MAX_WRITEBACK_PAGES writeback and restart over and over. This results in
very suboptimal writeback for many files, see the initial report from
Jan Engelhardt:

http://lkml.org/lkml/2010/1/22/382

This fixes it by using the passed in page writeback count, instead of
doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
(Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
finish properly even when new pages are being dirted.

Thanks to Jan Kara <jack@suse.cz> for spotting this problem!

Cc: stable@kernel.org
Reported-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

---

I'm sending this out as a patch on the list instead since I'll be going
away for a week skiing very shortly, a mail+patch is easier to discuss
here.

Greg, I'm attaching a 2.6.32 based patch as well, since this one will
not apply to 2.6.32.

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1a7c42c..55aeea9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -749,6 +749,8 @@ static long wb_writeback(struct bdi_writeback *wb,
 	}
 
 	for (;;) {
+		long to_write = 0;
+
 		/*
 		 * Stop writeback when nr_pages has been consumed
 		 */
@@ -762,12 +764,17 @@ static long wb_writeback(struct bdi_writeback *wb,
 		if (args->for_background && !over_bground_thresh())
 			break;
 
+		if (args->sync_mode == WB_SYNC_ALL)
+			to_write = args->nr_pages;
+		if (!to_write)
+			to_write = MAX_WRITEBACK_PAGES;
+
 		wbc.more_io = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
+		wbc.nr_to_write = to_write;
 		wbc.pages_skipped = 0;
 		writeback_inodes_wb(wb, &wbc);
-		args->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		args->nr_pages -= to_write - wbc.nr_to_write;
+		wrote += to_write - wbc.nr_to_write;
 
 		/*
 		 * If we consumed everything, see if we have more
@@ -782,7 +789,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 		/*
 		 * Did we write something? Try for more
 		 */
-		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
+		if (wbc.nr_to_write < to_write)
 			continue;
 		/*
 		 * Nothing written. Wait for some inode to

-- 
Jens Axboe


--phCU5ROyZO6kBE05
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="writeback-fix-broken-sync-2.6.32.patch"

commit 057226ca7447880e4e766a82cf32197e492ba963
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Feb 12 10:14:34 2010 +0100

    writeback: Fix broken sync writeback
    
    There's currently a writeback bug in the 2.6.32 and 2.6.33-rc kernels
    that prevent proper writeback when sync(1) is being run. Instead of
    flushing everything older than the sync run, it will do chunks of normal
    MAX_WRITEBACK_PAGES writeback and restart over and over. This results in
    very suboptimal writeback for many files, see the initial report from
    Jan Engelhardt:
    
    http://lkml.org/lkml/2010/1/22/382
    
    This fixes it by using the passed in page writeback count, instead of
    doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
    (Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
    finish properly even when new pages are being dirted.
    
    Thanks to Jan Kara <jack@suse.cz> for spotting this problem!
    
    Cc: stable@kernel.org
    Reported-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9d5360c..8a46c67 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -773,6 +773,8 @@ static long wb_writeback(struct bdi_writeback *wb,
 	}
 
 	for (;;) {
+		long to_write = 0;
+
 		/*
 		 * Stop writeback when nr_pages has been consumed
 		 */
@@ -786,13 +788,18 @@ static long wb_writeback(struct bdi_writeback *wb,
 		if (args->for_background && !over_bground_thresh())
 			break;
 
+		if (args->sync_mode == WB_SYNC_ALL)
+			to_write = args->nr_pages;
+		if (!to_write)
+			to_write = MAX_WRITEBACK_PAGES;
+
 		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
+		wbc.nr_to_write = to_write;
 		wbc.pages_skipped = 0;
 		writeback_inodes_wb(wb, &wbc);
-		args->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		args->nr_pages -= to_write - wbc.nr_to_write;
+		wrote += to_write - wbc.nr_to_write;
 
 		/*
 		 * If we consumed everything, see if we have more
@@ -807,7 +814,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 		/*
 		 * Did we write something? Try for more
 		 */
-		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
+		if (wbc.nr_to_write < to_write)
 			continue;
 		/*
 		 * Nothing written. Wait for some inode to

--phCU5ROyZO6kBE05--
