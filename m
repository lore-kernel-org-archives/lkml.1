Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbZLPRAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbZLPRAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZLPRAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:00:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:54647 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762279AbZLPRAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:00:05 -0500
Message-Id: <20091216165904.831451147@chello.nl>
References: <20091216165553.802559834@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 17:55:54 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] perf: Allow per-task-per-cpu counters
Content-Disposition: inline; filename=perf1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow for per-task-per-cpu counters, useful for
scalability when profiling task hierarchies, we allow installing
events with event->cpu != -1 in task contexts.

__perf_event_sched_in() already skips events where ->cpu mis-matches
the current cpu, fix up __perf_install_in_context() and
__perf_event_enable() to also respect this filter.

This does lead to vary hard to interpret enabled/running times for
such counters, but I don't see a simple solution for that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -782,6 +782,9 @@ static void __perf_install_in_context(vo
 
 	add_event_to_ctx(event, ctx);
 
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		goto unlock;
+
 	/*
 	 * Don't put the event on if it is disabled or if
 	 * it is in a group and the group isn't on.
@@ -925,6 +928,9 @@ static void __perf_event_enable(void *in
 		goto unlock;
 	__perf_event_mark_enabled(event, ctx);
 
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		goto unlock;
+
 	/*
 	 * If the event is in a group and isn't the group leader,
 	 * then don't put it on unless the group is on.
@@ -1595,10 +1601,7 @@ static struct perf_event_context *find_g
 	unsigned long flags;
 	int err;
 
-	/*
-	 * If cpu is not a wildcard then this is a percpu event:
-	 */
-	if (cpu != -1) {
+	if (pid == -1 && cpu != -1) {
 		/* Must be root to operate on a CPU event: */
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);

-- 

