Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYKONiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYKONiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 08:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbYKONiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 08:38:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58877 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbYKONiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 08:38:03 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20081115237.317953894@firstfloor.org>
In-Reply-To: <20081115237.317953894@firstfloor.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH REPOST] [1/3] SCHED: cache task_hot result
Message-Id: <20081115133800.550253E6619@basil.firstfloor.org>
Date: Sat, 15 Nov 2008 14:38:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Minor scheduler optimization: cache the result of task_hot() in 
can migrate task instead of computing it three times.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sched.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6.28-rc4-test/kernel/sched.c
===================================================================
--- linux-2.6.28-rc4-test.orig/kernel/sched.c	2008-11-10 08:50:24.000000000 +0100
+++ linux-2.6.28-rc4-test/kernel/sched.c	2008-11-12 12:32:52.000000000 +0100
@@ -2907,6 +2907,8 @@
 		     struct sched_domain *sd, enum cpu_idle_type idle,
 		     int *all_pinned)
 {
+	int hot;
+
 	/*
 	 * We do not migrate tasks that are:
 	 * 1) running (obviously), or
@@ -2930,10 +2932,11 @@
 	 * 2) too many balance attempts have failed.
 	 */
 
-	if (!task_hot(p, rq->clock, sd) ||
-			sd->nr_balance_failed > sd->cache_nice_tries) {
+	hot = task_hot(p, rq->clock, sd);
+
+	if (!hot || sd->nr_balance_failed > sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
-		if (task_hot(p, rq->clock, sd)) {
+		if (hot) {
 			schedstat_inc(sd, lb_hot_gained[idle]);
 			schedstat_inc(p, se.nr_forced_migrations);
 		}
@@ -2941,7 +2944,7 @@
 		return 1;
 	}
 
-	if (task_hot(p, rq->clock, sd)) {
+	if (hot) {
 		schedstat_inc(p, se.nr_failed_migrations_hot);
 		return 0;
 	}
