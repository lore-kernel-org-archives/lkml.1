Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbZJAHrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbZJAHrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbZJAHr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:47:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:51903 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbZJAHr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:47:26 -0400
Date: Thu, 1 Oct 2009 07:46:58 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, xiaoguangrong@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       xiaoguangrong@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4ABC5A55.7000208@cn.fujitsu.com>
References: <4ABC5A55.7000208@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Fix event group handling in __perf_event_sched_*()
Message-ID: <tip-8c9ed8e14c342ec5e7f27e7e498f62409a10eb29@git.kernel.org>
Git-Commit-ID: 8c9ed8e14c342ec5e7f27e7e498f62409a10eb29
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 07:46:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c9ed8e14c342ec5e7f27e7e498f62409a10eb29
Gitweb:     http://git.kernel.org/tip/8c9ed8e14c342ec5e7f27e7e498f62409a10eb29
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Fri, 25 Sep 2009 13:51:17 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Oct 2009 09:30:44 +0200

perf_event: Fix event group handling in __perf_event_sched_*()

Paul Mackerras says:

 "Actually, looking at this more closely, it has to be a group
 leader anyway since it's at the top level of ctx->group_list.  In
 fact I see four places where we do:

  list_for_each_entry(event, &ctx->group_list, group_entry) {
	if (event == event->group_leader)
		...

 or the equivalent, three of which appear to have been introduced
 by afedadf2 ("perf_counter: Optimize sched in/out of counters")
 back in May by Peter Z.

 As far as I can see the if () is superfluous in each case (a
 singleton event will be a group of 1 and will have its
 group_leader pointing to itself)."

 [ See: http://marc.info/?l=linux-kernel&m=125361238901442&w=2 ]

And Peter Zijlstra points out this is a bugfix:

 "The intent was to call event_sched_{in,out}() for single event
  groups because that's cheaper than group_sched_{in,out}(),
  however..

  - as you noticed, I got the condition wrong, it should have read:

      list_empty(&event->sibling_list)

  - it failed to call group_can_go_on() which deals with ->exclusive.

  - it also doesn't call hw_perf_group_sched_in() which might break
    power."

 [ See: http://marc.info/?l=linux-kernel&m=125369523318583&w=2 ]

Changelog v1->v2:

 - Fix the title name according to Peter Zijlstra's suggestion

 - Remove the comments and WARN_ON_ONCE() as Peter Zijlstra's
   suggestion

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4ABC5A55.7000208@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_event.c |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0f86feb..e50543d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1030,14 +1030,10 @@ void __perf_event_sched_out(struct perf_event_context *ctx,
 	update_context_time(ctx);
 
 	perf_disable();
-	if (ctx->nr_active) {
-		list_for_each_entry(event, &ctx->group_list, group_entry) {
-			if (event != event->group_leader)
-				event_sched_out(event, cpuctx, ctx);
-			else
-				group_sched_out(event, cpuctx, ctx);
-		}
-	}
+	if (ctx->nr_active)
+		list_for_each_entry(event, &ctx->group_list, group_entry)
+			group_sched_out(event, cpuctx, ctx);
+
 	perf_enable();
  out:
 	spin_unlock(&ctx->lock);
@@ -1258,12 +1254,8 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 		if (event->cpu != -1 && event->cpu != cpu)
 			continue;
 
-		if (event != event->group_leader)
-			event_sched_in(event, cpuctx, ctx, cpu);
-		else {
-			if (group_can_go_on(event, cpuctx, 1))
-				group_sched_in(event, cpuctx, ctx, cpu);
-		}
+		if (group_can_go_on(event, cpuctx, 1))
+			group_sched_in(event, cpuctx, ctx, cpu);
 
 		/*
 		 * If this pinned group hasn't been scheduled,
@@ -1291,15 +1283,9 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 		if (event->cpu != -1 && event->cpu != cpu)
 			continue;
 
-		if (event != event->group_leader) {
-			if (event_sched_in(event, cpuctx, ctx, cpu))
+		if (group_can_go_on(event, cpuctx, can_add_hw))
+			if (group_sched_in(event, cpuctx, ctx, cpu))
 				can_add_hw = 0;
-		} else {
-			if (group_can_go_on(event, cpuctx, can_add_hw)) {
-				if (group_sched_in(event, cpuctx, ctx, cpu))
-					can_add_hw = 0;
-			}
-		}
 	}
 	perf_enable();
  out:
