Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbZE0LSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbZE0LSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762199AbZE0LNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:13:52 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49608 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762095AbZE0LNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:13:49 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:06:59 +0300
Message-Id: <20090527130659.4913.68260.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/19] write-back: introduce a helper function
X-OriginalArrivalTime: 27 May 2009 11:13:01.0798 (UTC) FILETIME=[19642060:01C9DEBC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] write-back: introduce a helper function

This patch is just a clean up and a preparation for the
following periodic write-back optimization patches. It
introduces a helper 'setup_wb_timer()' function which
sets up the periodic write-back timer to the specified
value, or to the default value. The code just looks
neater with this helper.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 mm/page-writeback.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 30351f0..8a213a9 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -738,6 +738,21 @@ static DEFINE_TIMER(wb_timer, wb_timer_fn, 0, 0);
 static DEFINE_TIMER(laptop_mode_wb_timer, laptop_timer_fn, 0, 0);
 
 /*
+ * Setup the periodic write-back timer to expires at @expires jiffies. If
+ * @expires is zero, the timer is set up to the default interval.
+ */
+static void setup_wb_timer(unsigned long expires)
+{
+	if (!expires) {
+		/* Setup to the default wake-up period value */
+		expires = jiffies;
+		expires += msecs_to_jiffies(dirty_writeback_interval * 10);
+	}
+
+	mod_timer(&wb_timer, expires);
+}
+
+/*
  * Periodic writeback of "old" data.
  *
  * Define "old": the first time one of an inode's pages is dirtied, we mark the
@@ -792,7 +807,7 @@ static void wb_kupdate(unsigned long arg)
 	if (time_before(next_jif, jiffies + HZ))
 		next_jif = jiffies + HZ;
 	if (dirty_writeback_interval)
-		mod_timer(&wb_timer, next_jif);
+		setup_wb_timer(next_jif);
 }
 
 /*
@@ -803,8 +818,7 @@ int dirty_writeback_centisecs_handler(ctl_table *table, int write,
 {
 	proc_dointvec(table, write, file, buffer, length, ppos);
 	if (dirty_writeback_interval)
-		mod_timer(&wb_timer, jiffies +
-			msecs_to_jiffies(dirty_writeback_interval * 10));
+		setup_wb_timer(0);
 	else
 		del_timer(&wb_timer);
 	return 0;
@@ -813,7 +827,7 @@ int dirty_writeback_centisecs_handler(ctl_table *table, int write,
 static void wb_timer_fn(unsigned long unused)
 {
 	if (pdflush_operation(wb_kupdate, 0) < 0)
-		mod_timer(&wb_timer, jiffies + HZ); /* delay 1 second */
+		setup_wb_timer( jiffies + HZ); /* delay 1 second */
 }
 
 static void laptop_flush(unsigned long unused)
@@ -906,8 +920,7 @@ void __init page_writeback_init(void)
 {
 	int shift;
 
-	mod_timer(&wb_timer,
-		  jiffies + msecs_to_jiffies(dirty_writeback_interval * 10));
+	setup_wb_timer(0);
 	writeback_set_ratelimit();
 	register_cpu_notifier(&ratelimit_nb);
 
-- 
1.6.0.6

