Return-Path: <linux-kernel-owner+w=401wt.eu-S1030580AbXDJORp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030580AbXDJORp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030576AbXDJORp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:17:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030524AbXDJORl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:17:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] freezer: Fix racy usage of try_to_freeze in kswapd
Date: Tue, 10 Apr 2007 16:21:16 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704101621.16744.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently we can miss freeze_process()->signal_wake_up() in kswapd() if it
happens between try_to_freeze() and prepare_to_wait().  To prevent this from
happening we should check freezing(current) before calling schedule().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 mm/vmscan.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6.21-rc6/mm/vmscan.c
===================================================================
--- linux-2.6.21-rc6.orig/mm/vmscan.c
+++ linux-2.6.21-rc6/mm/vmscan.c
@@ -1323,8 +1323,6 @@ static int kswapd(void *p)
 	for ( ; ; ) {
 		unsigned long new_order;
 
-		try_to_freeze();
-
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 		new_order = pgdat->kswapd_max_order;
 		pgdat->kswapd_max_order = 0;
@@ -1335,12 +1333,19 @@ static int kswapd(void *p)
 			 */
 			order = new_order;
 		} else {
-			schedule();
+			if (!freezing(current))
+				schedule();
+
 			order = pgdat->kswapd_max_order;
 		}
 		finish_wait(&pgdat->kswapd_wait, &wait);
 
-		balance_pgdat(pgdat, order);
+		if (!try_to_freeze()) {
+			/* We can speed up thawing tasks if we don't call
+			 * balance_pgdat after returning from the refrigerator
+			 */
+			balance_pgdat(pgdat, order);
+		}
 	}
 	return 0;
 }
