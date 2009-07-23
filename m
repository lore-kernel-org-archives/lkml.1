Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZGWTXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZGWTXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZGWTWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:22:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZGWTVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:13 -0400
Message-Id: <20090723191956.847364023@chello.nl>
References: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:45 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 03/13] perf record: Update for the new FORK/EXIT events
Content-Disposition: inline; filename=perf-counter-tools-exit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since FORK is now also issued for threads, detect those by comparing
the parent and child PID.

Teach it about EXIT events and ignore them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/builtin-report.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

Index: linux-2.6/tools/perf/builtin-report.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-report.c
+++ linux-2.6/tools/perf/builtin-report.c
@@ -99,6 +99,7 @@ struct comm_event {
 struct fork_event {
 	struct perf_event_header header;
 	u32 pid, ppid;
+	u32 tid, ptid;
 };
 
 struct lost_event {
@@ -1608,15 +1609,27 @@ process_comm_event(event_t *event, unsig
 }
 
 static int
-process_fork_event(event_t *event, unsigned long offset, unsigned long head)
+process_task_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct thread *thread = threads__findnew(event->fork.pid);
 	struct thread *parent = threads__findnew(event->fork.ppid);
 
-	dprintf("%p [%p]: PERF_EVENT_FORK: %d:%d\n",
+	dprintf("%p [%p]: PERF_EVENT_%s: (%d:%d):(%d:%d)\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
-		event->fork.pid, event->fork.ppid);
+		event->header.type == PERF_EVENT_FORK ? "FORK" : "EXIT",
+		event->fork.pid, event->fork.tid,
+		event->fork.ppid, event->fork.ptid);
+
+	/*
+	 * A thread clone will have the same PID for both
+	 * parent and child.
+	 */
+	if (thread == parent)
+		return 0;
+
+	if (event->header.type == PERF_EVENT_EXIT)
+		return 0;
 
 	if (!thread || !parent || thread__fork(thread, parent)) {
 		dprintf("problem processing PERF_EVENT_FORK, skipping event.\n");
@@ -1706,7 +1719,8 @@ process_event(event_t *event, unsigned l
 		return process_comm_event(event, offset, head);
 
 	case PERF_EVENT_FORK:
-		return process_fork_event(event, offset, head);
+	case PERF_EVENT_EXIT:
+		return process_task_event(event, offset, head);
 
 	case PERF_EVENT_LOST:
 		return process_lost_event(event, offset, head);

-- 

