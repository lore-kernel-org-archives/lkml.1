Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbYDQBNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbYDQBNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbYDQBH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:29 -0400
Received: from sous-sol.org ([216.99.217.87]:58846 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758793AbYDQBH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:27 -0400
Message-Id: <20080417010344.527179466@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:58 -0700
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
       Herbert Xu <herbert@gondor.apana.org.au>,
       David S Miller <davem@davemloft.net>
Subject: NET: Add preemption point in qdisc_run
Content-Disposition: inline; filename=net-add-preemption-point-in-qdisc_run.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

Upstream commit: 2ba2506ca7ca62c56edaa334b0fe61eb5eab6ab0

The qdisc_run loop is currently unbounded and runs entirely in a
softirq.  This is bad as it may create an unbounded softirq run.

This patch fixes this by calling need_resched and breaking out if
necessary.

It also adds a break out if the jiffies value changes since that would
indicate we've been transmitting for too long which starves other
softirqs.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/sched/sch_generic.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -178,10 +178,22 @@ static inline int qdisc_restart(struct n
 
 void __qdisc_run(struct net_device *dev)
 {
-	do {
-		if (!qdisc_restart(dev))
+	unsigned long start_time = jiffies;
+
+	while (qdisc_restart(dev)) {
+		if (netif_queue_stopped(dev))
+			break;
+
+		/*
+		 * Postpone processing if
+		 * 1. another process needs the CPU;
+		 * 2. we've been doing it for too long.
+		 */
+		if (need_resched() || jiffies != start_time) {
+			netif_schedule(dev);
 			break;
-	} while (!netif_queue_stopped(dev));
+		}
+	}
 
 	clear_bit(__LINK_STATE_QDISC_RUNNING, &dev->state);
 }

-- 
