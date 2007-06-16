Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbXFPK3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbXFPK3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbXFPKYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:24:25 -0400
Received: from www.osadl.org ([213.239.205.134]:37216 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754570AbXFPKYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:24:20 -0400
Message-Id: <20070616101636.950766932@inhelltoy.tec.linutronix.de>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 16 Jun 2007 10:36:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch-mm 11/25] hrtimer: speedup hrtimer_enqueue
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
--- linux-2.6.22-rc4-mm.orig/kernel/hrtimer.c	2007-06-16 12:10:23.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/hrtimer.c	2007-06-16 12:10:23.000000000 +0200
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

