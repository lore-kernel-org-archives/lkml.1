Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbXHSHRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbXHSHRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbXHSHPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:15:24 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53673 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753462AbXHSHOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:14:49 -0400
Message-ID: <387507685.84790@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070819071444.878093599@mail.ustc.edu.cn>
References: <20070819065349.160284305@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 19 Aug 2007 14:53:53 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Ken Chen <kenchen@google.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] writeback: introduce writeback_control.more_io to indicate more io
Content-Disposition: inline; filename=writeback-more-data.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After making dirty a 100M file, the normal behavior is to
start the writeback for all data after 30s delays. But
sometimes the following happens instead:

	- after 30s:    ~4M
	- after 5s:     ~4M
	- after 5s:     all remaining 92M

Some analyze shows that the internal io dispatch queues goes like this:

		s_io            s_more_io
		-------------------------
	1)	100M,1K         0
	2)	1K              96M
	3)	0               96M

1) initial state with a 100M file and a 1K file
2) 4M written, nr_to_write <= 0, so write more
3) 1K written, nr_to_write > 0, no more writes(BUG)

nr_to_write > 0 in (3) fools the upper layer to think that data have all been
written out. The big dirty file is actually still sitting in s_more_io. We
cannot simply splice s_more_io back to s_io as soon as s_io becomes empty, and
let the loop in generic_sync_sb_inodes() continue: this may starve newly
expired inodes in s_dirty.  It is also not an option to draw inodes from both
s_more_io and s_dirty, an let the loop go on: this might lead to live locks,
and might also starve other superblocks in sync time(well kupdate may still
starve some superblocks, that's another bug).

We have to return when a full scan of s_io completes. So nr_to_write > 0 does
not necessarily mean that "all data are written". This patch introduces a flag
writeback_control.more_io to indicate this situation. With it the big dirty file
no longer has to wait for the next kupdate invocation 5s later.

Cc: David Chinner <dgc@sgi.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c         |    2 ++
 include/linux/writeback.h |    1 +
 mm/page-writeback.c       |    9 ++++++---
 3 files changed, 9 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc2-mm2/fs/fs-writeback.c
@@ -472,6 +472,8 @@ sync_sb_inodes(struct super_block *sb, s
 		if (wbc->nr_to_write <= 0)
 			break;
 	}
+	if (!list_empty(&sb->s_more_io))
+		wbc->more_io = 1;
 
 	return;		/* Leave any unwritten inodes on s_io */
 }
--- linux-2.6.23-rc2-mm2.orig/include/linux/writeback.h
+++ linux-2.6.23-rc2-mm2/include/linux/writeback.h
@@ -61,6 +61,7 @@ struct writeback_control {
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
+	unsigned more_io:1;		/* more io to be dispatched */
 
 	void *fs_private;		/* For use by ->writepages() */
 };
--- linux-2.6.23-rc2-mm2.orig/mm/page-writeback.c
+++ linux-2.6.23-rc2-mm2/mm/page-writeback.c
@@ -382,6 +382,7 @@ static void background_writeout(unsigned
 			global_page_state(NR_UNSTABLE_NFS) < background_thresh
 				&& min_pages <= 0)
 			break;
+		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
@@ -389,8 +390,9 @@ static void background_writeout(unsigned
 		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
 			/* Wrote less than expected */
-			congestion_wait(WRITE, HZ/10);
-			if (!wbc.encountered_congestion)
+			if (wbc.encountered_congestion || wbc.more_io)
+				congestion_wait(WRITE, HZ/10);
+			else
 				break;
 		}
 	}
@@ -455,11 +457,12 @@ static void wb_kupdate(unsigned long arg
 			global_page_state(NR_UNSTABLE_NFS) +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 	while (nr_to_write > 0) {
+		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		writeback_inodes(&wbc);
 		if (wbc.nr_to_write > 0) {
-			if (wbc.encountered_congestion)
+			if (wbc.encountered_congestion || wbc.more_io)
 				congestion_wait(WRITE, HZ/10);
 			else
 				break;	/* All the old data is written */

-- 
