Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbZKWOAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbZKWOAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZKWOAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:00:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZKWOAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:00:33 -0500
Subject: [PATCH 9/8] perf_events: Restore sanity to scaling land
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20091123103722.140831906@chello.nl>
References: <20091123103722.140831906@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 15:00:36 +0100
Message-ID: <1258984836.4531.480.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is quite possible to call update_event_times() on a context that
isn't actually running and thereby confuse the thing.

perf stat was reporting !100% scale values for software counters
(2e2af50b perf_events: Disable events when we detach them, solved the
worst of that, but there was still some left).

The thing that happens is that because we are not self-reaping (we have
a caring parent) there is a time between the last schedule (out) and
having do_exit() called which will detach the events.

This period would be accounted as enabled,!running because the
event->state==INACTIVE, even though !event->ctx->is_active.

Similar issues could have been observed by calling read() on a event
while the attached task was not scheduled in.

Solve this by teaching update_event_times() about ctx->is_active.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0b0d5f7..0aafe85 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -274,7 +274,12 @@ static void update_event_times(struct perf_event *event)
 	    event->group_leader->state < PERF_EVENT_STATE_INACTIVE)
 		return;
 
-	event->total_time_enabled = ctx->time - event->tstamp_enabled;
+	if (ctx->is_active)
+		run_end = ctx->time;
+	else
+		run_end = event->tstamp_stopped;
+
+	event->total_time_enabled = run_end - event->tstamp_enabled;
 
 	if (event->state == PERF_EVENT_STATE_INACTIVE)
 		run_end = event->tstamp_stopped;


