Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZIVIry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZIVIry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZIVIry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:47:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55330 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZIVIrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:47:53 -0400
Message-ID: <4AB88F06.10900@cn.fujitsu.com>
Date: Tue, 22 Sep 2009 16:47:02 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf_counter: cleanup for __perf_event_sched_in()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It must be a group leader if event->attr.pinned is "1"

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/perf_event.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 76ac4db..fdd9c94 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1258,12 +1258,11 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 		if (event->cpu != -1 && event->cpu != cpu)
 			continue;
 
-		if (event != event->group_leader)
-			event_sched_in(event, cpuctx, ctx, cpu);
-		else {
-			if (group_can_go_on(event, cpuctx, 1))
-				group_sched_in(event, cpuctx, ctx, cpu);
-		}
+		/* Only a group leader can be pinned */
+		BUG_ON(event != event->group_leader);
+
+		if (group_can_go_on(event, cpuctx, 1))
+			group_sched_in(event, cpuctx, ctx, cpu);
 
 		/*
 		 * If this pinned group hasn't been scheduled,
-- 
1.6.1.2

