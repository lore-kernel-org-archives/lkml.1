Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZKWRnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZKWRnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbZKWRnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:43:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:41554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbZKWRni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:43:38 -0500
Date: Mon, 23 Nov 2009 17:42:51 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258984836.4531.480.camel@laptop>
References: <1258984836.4531.480.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Restore sanity to scaling land
Message-ID: <tip-acd1d7c1f8f3d848a3c5327dc09f8c1efb971678@git.kernel.org>
Git-Commit-ID: acd1d7c1f8f3d848a3c5327dc09f8c1efb971678
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acd1d7c1f8f3d848a3c5327dc09f8c1efb971678
Gitweb:     http://git.kernel.org/tip/acd1d7c1f8f3d848a3c5327dc09f8c1efb971678
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 23 Nov 2009 15:00:36 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 15:22:19 +0100

perf_events: Restore sanity to scaling land

It is quite possible to call update_event_times() on a context
that isn't actually running and thereby confuse the thing.

perf stat was reporting !100% scale values for software counters
(2e2af50b perf_events: Disable events when we detach them,
solved the worst of that, but there was still some left).

The thing that happens is that because we are not self-reaping
(we have a caring parent) there is a time between the last
schedule (out) and having do_exit() called which will detach the
events.

This period would be accounted as enabled,!running because the
event->state==INACTIVE, even though !event->ctx->is_active.

Similar issues could have been observed by calling read() on a
event while the attached task was not scheduled in.

Solve this by teaching update_event_times() about
ctx->is_active.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1258984836.4531.480.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
