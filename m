Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbZIYFwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbZIYFwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 01:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZIYFwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 01:52:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58829 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZIYFwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 01:52:11 -0400
Message-ID: <4ABC5A55.7000208@cn.fujitsu.com>
Date: Fri, 25 Sep 2009 13:51:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2 v2] perf_counter: fix for __perf_event_sched_*()
References: <4AB88F06.10900@cn.fujitsu.com>	 <19128.39768.149110.673711@cargo.ozlabs.ibm.com>	 <4AB98BB0.6020202@cn.fujitsu.com>	 <19129.38627.94363.857137@cargo.ozlabs.ibm.com>	 <4AB9D7FA.5040707@cn.fujitsu.com> <1253695230.7695.122.camel@twins>
In-Reply-To: <1253695230.7695.122.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras says:
"Actually, looking at this more closely, it has to be a group leader
anyway since it's at the top level of ctx->group_list.  In fact I see
four places where we do:

  list_for_each_entry(event, &ctx->group_list, group_entry) {
	if (event == event->group_leader)
		...

or the equivalent, three of which appear to have been introduced by
afedadf2 ("perf_counter: Optimize sched in/out of counters") back in
May by Peter Z.

As far as I can see the if () is superfluous in each case (a singleton
event will be a group of 1 and will have its group_leader pointing to
itself)."
[Can be found at http://marc.info/?l=linux-kernel&m=125361238901442&w=2]

And Peter Zijlstra point out this is an bugfix:
"The intent was to call event_sched_{in,out}() for single counter groups
because that's cheaper than group_sched_{in,out}(), however..

 - as you noticed, I got the condition wrong, it should have read:

     list_empty(&event->sibling_list)

 - it failed to call group_can_go_on() which deals with ->exclusive.

 - it also doesn't call hw_perf_group_sched_in() which might break
   power."
[Can be found at http://marc.info/?l=linux-kernel&m=125369523318583&w=2]

Changelog v1->v2:
- fix the title name as Peter Zijlstra's suggestion
- remove the comments and WARN_ON_ONCE() as Peter Zijlstra's suggestion

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/perf_event.c |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 76ac4db..2a15cd6 100644
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
-- 
1.6.1.2

