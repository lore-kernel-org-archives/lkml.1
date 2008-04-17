Return-Path: <linux-kernel-owner+w=401wt.eu-S933743AbYDQBYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743AbYDQBYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760648AbYDQBIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:54 -0400
Received: from sous-sol.org ([216.99.217.87]:58961 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbYDQBIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:53 -0400
Message-Id: <20080417010345.091651392@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:59 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Martin Devera <devik@cdi.cz>, David S Miller <davem@davemloft.net>
Subject: sch_htb: fix "too many events" situation
Content-Disposition: inline; filename=sch_htb-fix-too-many-events-situation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Martin Devera <devik@cdi.cz>

Upstream commit: 8f3ea33a5078a09eba12bfe57424507809367756

HTB is event driven algorithm and part of its work is to apply
scheduled events at proper times. It tried to defend itself from
livelock by processing only limited number of events per dequeue.
Because of faster computers some users already hit this hardcoded
limit.

This patch limits processing up to 2 jiffies (why not 1 jiffie ?
because it might stop prematurely when only fraction of jiffie
remains).

Signed-off-by: Martin Devera <devik@cdi.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/sched/sch_htb.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -708,9 +708,11 @@ static void htb_charge_class(struct htb_
  */
 static psched_time_t htb_do_events(struct htb_sched *q, int level)
 {
-	int i;
-
-	for (i = 0; i < 500; i++) {
+	/* don't run for longer than 2 jiffies; 2 is used instead of
+	   1 to simplify things when jiffy is going to be incremented
+	   too soon */
+	unsigned long stop_at = jiffies + 2;
+	while (time_before(jiffies, stop_at)) {
 		struct htb_class *cl;
 		long diff;
 		struct rb_node *p = rb_first(&q->wait_pq[level]);
@@ -728,9 +730,8 @@ static psched_time_t htb_do_events(struc
 		if (cl->cmode != HTB_CAN_SEND)
 			htb_add_to_wait_tree(q, cl, diff);
 	}
-	if (net_ratelimit())
-		printk(KERN_WARNING "htb: too many events !\n");
-	return q->now + PSCHED_TICKS_PER_SEC / 10;
+	/* too much load - let's continue on next jiffie */
+	return q->now + PSCHED_TICKS_PER_SEC / HZ;
 }
 
 /* Returns class->node+prio from id-tree where classe's id is >= id. NULL

-- 
