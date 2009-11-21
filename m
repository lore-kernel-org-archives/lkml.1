Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbZKUNn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbZKUNn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbZKUNnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:43:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:60956 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054AbZKUNnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:43:35 -0500
Date: Sat, 21 Nov 2009 13:43:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091120212508.918544317@chello.nl>
References: <20091120212508.918544317@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Simplify __perf_event_sync_stat
Message-ID: <tip-3dbebf15c5d3e265f751eec72c1538a00da4be27@git.kernel.org>
Git-Commit-ID: 3dbebf15c5d3e265f751eec72c1538a00da4be27
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3dbebf15c5d3e265f751eec72c1538a00da4be27
Gitweb:     http://git.kernel.org/tip/3dbebf15c5d3e265f751eec72c1538a00da4be27
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Nov 2009 22:19:52 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:39 +0100

perf: Simplify __perf_event_sync_stat

Removes constraints from __perf_event_read() by leaving it with
a single callsite; this callsite had ctx->lock held, the other
one does not.

Removes some superfluous code from __perf_event_sync_stat().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091120212508.918544317@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index e66f6c4..af150bb 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1061,8 +1061,6 @@ static int context_equiv(struct perf_event_context *ctx1,
 		&& !ctx1->pin_count && !ctx2->pin_count;
 }
 
-static void __perf_event_read(void *event);
-
 static void __perf_event_sync_stat(struct perf_event *event,
 				     struct perf_event *next_event)
 {
@@ -1080,8 +1078,8 @@ static void __perf_event_sync_stat(struct perf_event *event,
 	 */
 	switch (event->state) {
 	case PERF_EVENT_STATE_ACTIVE:
-		__perf_event_read(event);
-		break;
+		event->pmu->read(event);
+		/* fall-through */
 
 	case PERF_EVENT_STATE_INACTIVE:
 		update_event_times(event);
