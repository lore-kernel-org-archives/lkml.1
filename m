Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbZKHUNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbZKHUNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZKHUNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:13:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:56162 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbZKHUNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:13:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=swHYFKYJrIxiTcZsxzVhIbWn3D2rPiDGyhRhCmUO+KbvYbcMcjsTgMB3Q0qK6Q5g/0
         mJhyHF5eiX6z4EtasCESMWYENpdqzSoPCiToCm1xRJV6+7PcqX9hGC2COk6JKjtjy8Du
         lyV0yi4Pq5GpmSI8tpVghPJ91LEOVIVlsPgIA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 3/4] perf/core: Split up pinned and non pinned processing
Date: Sun,  8 Nov 2009 21:13:25 +0100
Message-Id: <1257711206-12243-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
References: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split up pinned and non-pinned events processing in two helpers
so that it's more flexible to handle them seperately.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/perf_event.c |   51 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0432c1c..50f2997 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1246,25 +1246,11 @@ static void perf_event_cpu_sched_out(struct perf_cpu_context *cpuctx)
 }
 
 static void
-__perf_event_sched_in(struct perf_event_context *ctx,
-			struct perf_cpu_context *cpuctx, int cpu)
+__perf_event_sched_in_pinned(struct perf_event_context *ctx,
+			     struct perf_cpu_context *cpuctx, int cpu)
 {
 	struct perf_event *event;
-	int can_add_hw = 1;
-
-	spin_lock(&ctx->lock);
-	ctx->is_active = 1;
-	if (likely(!ctx->nr_events))
-		goto out;
-
-	ctx->timestamp = perf_clock();
-
-	perf_disable();
 
-	/*
-	 * First go through the list and put on any pinned groups
-	 * in order to give them the best chance of going on.
-	 */
 	list_for_each_entry(event, &ctx->pinned_grp_list, group_entry) {
 		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
@@ -1283,6 +1269,14 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 			event->state = PERF_EVENT_STATE_ERROR;
 		}
 	}
+}
+
+static void
+__perf_event_sched_in_volatile(struct perf_event_context *ctx,
+			       struct perf_cpu_context *cpuctx, int cpu)
+{
+	int can_add_hw = 1;
+	struct perf_event *event;
 
 	list_for_each_entry(event, &ctx->volatile_grp_list, group_entry) {
 		/*
@@ -1303,6 +1297,31 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 			if (group_sched_in(event, cpuctx, ctx, cpu))
 				can_add_hw = 0;
 	}
+}
+
+static void
+__perf_event_sched_in(struct perf_event_context *ctx,
+			struct perf_cpu_context *cpuctx, int cpu)
+{
+	spin_lock(&ctx->lock);
+	ctx->is_active = 1;
+	if (likely(!ctx->nr_events))
+		goto out;
+
+	ctx->timestamp = perf_clock();
+
+	perf_disable();
+
+	/*
+	 * First go through the list and put on any pinned groups
+	 * in order to give them the best chance of going on.
+	 */
+	__perf_event_sched_in_pinned(ctx, cpuctx, cpu);
+
+	/* Then handle the non-pinned groups */
+	__perf_event_sched_in_volatile(ctx, cpuctx, cpu);
+
+
 	perf_enable();
  out:
 	spin_unlock(&ctx->lock);
-- 
1.6.2.3

