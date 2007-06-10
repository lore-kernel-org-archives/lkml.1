Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbXFJJep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbXFJJep (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXFJJbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:31:15 -0400
Received: from www.osadl.org ([213.239.205.134]:43077 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753618AbXFJJbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:31:02 -0400
Message-Id: <20070610092446.773377570@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 10 Jun 2007 09:44:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 11/23] hrtimer: speedup hrtimer_enqueue
Content-Disposition: inline; filename=hrtimer-speedup-enqueue.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Speedup hrtimer_enqueue by evaluating the rbtree insertion result.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/hrtimer.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc4-mm/kernel/hrtimer.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/kernel/hrtimer.c	2007-06-10 10:44:39.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/hrtimer.c	2007-06-10 10:44:39.000000000 +0200
@@ -686,6 +686,7 @@ static void enqueue_hrtimer(struct hrtim
 	struct rb_node **link = &base->active.rb_node;
 	struct rb_node *parent = NULL;
 	struct hrtimer *entry;
+	int leftmost = 1;
 
 	/*
 	 * Find the right place in the rbtree:
@@ -697,18 +698,19 @@ static void enqueue_hrtimer(struct hrtim
 		 * We dont care about collisions. Nodes with
 		 * the same expiry time stay together.
 		 */
-		if (timer->expires.tv64 < entry->expires.tv64)
+		if (timer->expires.tv64 < entry->expires.tv64) {
 			link = &(*link)->rb_left;
-		else
+		} else {
 			link = &(*link)->rb_right;
+			leftmost = 0;
+		}
 	}
 
 	/*
 	 * Insert the timer to the rbtree and check whether it
 	 * replaces the first pending timer
 	 */
-	if (!base->first || timer->expires.tv64 <
-	    rb_entry(base->first, struct hrtimer, node)->expires.tv64) {
+	if (leftmost) {
 		/*
 		 * Reprogram the clock event device. When the timer is already
 		 * expired hrtimer_enqueue_reprogram has either called the

-- 

