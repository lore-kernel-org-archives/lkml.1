Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbZGXO2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbZGXO2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZGXO2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:28:39 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:60126 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798AbZGXO2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:28:39 -0400
Subject: [RFC][PATCH] mm: reorder balance_dirty_pages to improve (some)
 write performance
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 15:28:37 +0100
Message-Id: <1248445717.19856.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder balance_dirty_pages to do less work in the default case &
improve write performance in some cases.

Running simple fio mmap write tests on x86_64 with 3gb of memory on
2.6.31-rc3 where each test was run 10 times, dropping the slowest &
fastest results the average write speeds are

size rc3 | +patch  difference
     MiB/s (s.d.)

400m 374.75  ( 8.15) | 382.575 ( 8.24)  + 7.825
500m 363.625 (10.91) | 378.375 (10.86)  +14.75
600m 308.875 (10.86) | 374.25  ( 7.91)  +65.375
700m 188     ( 4.75) | 209     ( 7.23)  +21
800m 140.375 ( 2.56) | 154.5   ( 2.98)  +14.275
900m 124.875 ( 0.99) | 125.5   ( 9.62)  +0.625


This patch helps write performance when the test size is close to the
allowed number of dirty pages (approx 600m on this machine). Once the
test size becomes larger than 900m there is no significant difference.


Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----

This change only make a difference to workloads where the number of
dirty pages is close to (dirty_ratio * memory size). Once a test writes
more than that the speed of the disk is the most important factor so any
effect of this patch is lost.
I've only tried this on my desktop, so it really needs testing on
different hardware.
Does anyone feel like trying it ? 

regards
Richard


diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 81627eb..1b42ed4 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -514,23 +514,26 @@ static void balance_dirty_pages(struct address_space *mapping)
 		get_dirty_limits(&background_thresh, &dirty_thresh,
 				&bdi_thresh, bdi);
 
-		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-					global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK);
-
 		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
 		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
 
-		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
+		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
+					global_page_state(NR_UNSTABLE_NFS);
+
+		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh) {
+			if (bdi->dirty_exceeded)
+				bdi->dirty_exceeded = 0;
 			break;
+		}
 
+		nr_writeback = global_page_state(NR_WRITEBACK);
 		/*
 		 * Throttle it only when the background writeback cannot
 		 * catch-up. This avoids (excessively) small writeouts
 		 * when the bdi limits are ramping up.
 		 */
 		if (nr_reclaimable + nr_writeback <
-				(background_thresh + dirty_thresh) / 2)
+		    (background_thresh + dirty_thresh) / 2)
 			break;
 
 		if (!bdi->dirty_exceeded)
@@ -578,10 +581,6 @@ static void balance_dirty_pages(struct address_space *mapping)
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 
-	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
-			bdi->dirty_exceeded)
-		bdi->dirty_exceeded = 0;
-
 	if (writeback_in_progress(bdi))
 		return;		/* pdflush is already working this queue */
 
@@ -594,9 +593,8 @@ static void balance_dirty_pages(struct address_space *mapping)
 	 * background_thresh, to keep the amount of dirty memory low.
 	 */
 	if ((laptop_mode && pages_written) ||
-			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
-					  + global_page_state(NR_UNSTABLE_NFS)
-					  > background_thresh)))
+			(!laptop_mode && nr_reclaimable
+					  > background_thresh))
 		pdflush_operation(background_writeout, 0);
 }
 


