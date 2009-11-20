Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZKTV2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZKTV2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZKTV2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:28:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:48331 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbZKTV21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:27 -0500
Message-Id: <20091120212508.918544317@chello.nl>
References: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:52 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] perf: simplify __perf_event_sync_stat
Content-Disposition: inline; filename=perf-time-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes constraints from __perf_event_read() by leaving it with a
single callsite; this callsite had ctx->lock held, the other one
does not.

Removes some superfluous code from __perf_event_sync_stat().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1061,8 +1061,6 @@ static int context_equiv(struct perf_eve
 		&& !ctx1->pin_count && !ctx2->pin_count;
 }
 
-static void __perf_event_read(void *event);
-
 static void __perf_event_sync_stat(struct perf_event *event,
 				     struct perf_event *next_event)
 {
@@ -1080,8 +1078,8 @@ static void __perf_event_sync_stat(struc
 	 */
 	switch (event->state) {
 	case PERF_EVENT_STATE_ACTIVE:
-		__perf_event_read(event);
-		break;
+		event->pmu->read(event);
+		/* fall-through */
 
 	case PERF_EVENT_STATE_INACTIVE:
 		update_event_times(event);

-- 

