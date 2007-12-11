Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbXLKDP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbXLKDP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 22:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXLKDPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 22:15:20 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:43290 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXLKDPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 22:15:19 -0500
Message-Id: <20071211031458.726479121@goodmis.org>
References: <20071211030033.632581735@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 10 Dec 2007 22:00:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, vatsa@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/4 v2] SCHED - Only adjust overload state when changing
Content-Disposition: inline; filename=sched-only-adjust-overload-state-when-changing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

The overload set/clears were originally idempotent when this logic was first
implemented.  But that is no longer true due to the addition of the atomic
counter and this logic was never updated to work properly with that change.
So only adjust the overload state if it is actually changing to avoid
getting out of sync.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-sched/kernel/sched_rt.c
===================================================================
--- linux-sched.orig/kernel/sched_rt.c	2007-12-10 20:39:17.000000000 -0500
+++ linux-sched/kernel/sched_rt.c	2007-12-10 20:39:19.000000000 -0500
@@ -34,9 +34,11 @@ static inline void rt_clear_overload(str
 static void update_rt_migration(struct rq *rq)
 {
 	if (rq->rt.rt_nr_migratory && (rq->rt.rt_nr_running > 1)) {
-		rt_set_overload(rq);
-		rq->rt.overloaded = 1;
-	} else {
+		if (!rq->rt.overloaded) {
+			rt_set_overload(rq);
+			rq->rt.overloaded = 1;
+		}
+	} else if (rq->rt.overloaded) {
 		rt_clear_overload(rq);
 		rq->rt.overloaded = 0;
 	}

-- 
