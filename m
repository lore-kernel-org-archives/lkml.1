Return-Path: <linux-kernel-owner+w=401wt.eu-S1762609AbZLPRek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609AbZLPRek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762558AbZLPRei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:34:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:45588 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762581AbZLPRef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:34:35 -0500
Date: Wed, 16 Dec 2009 17:34:02 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091216165904.831451147@chello.nl>
References: <20091216165904.831451147@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf events: Allow per-task-per-cpu counters
Message-ID: <tip-f4c4176f21533e22bcc292030da72bcfa105f5b8@git.kernel.org>
Git-Commit-ID: f4c4176f21533e22bcc292030da72bcfa105f5b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4c4176f21533e22bcc292030da72bcfa105f5b8
Gitweb:     http://git.kernel.org/tip/f4c4176f21533e22bcc292030da72bcfa105f5b8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 17:55:54 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 18:30:11 +0100

perf events: Allow per-task-per-cpu counters

In order to allow for per-task-per-cpu counters, useful for
scalability when profiling task hierarchies, we allow installing
events with event->cpu != -1 in task contexts.

__perf_event_sched_in() already skips events where ->cpu
mis-matches the current cpu, fix up __perf_install_in_context()
and __perf_event_enable() to also respect this filter.

This does lead to vary hard to interpret enabled/running times
for such counters, but I don't see a simple solution for that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: fweisbec@gmail.com
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091216165904.831451147@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0dd8e5d..2e0aaa3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -782,6 +782,9 @@ static void __perf_install_in_context(void *info)
 
 	add_event_to_ctx(event, ctx);
 
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		goto unlock;
+
 	/*
 	 * Don't put the event on if it is disabled or if
 	 * it is in a group and the group isn't on.
@@ -925,6 +928,9 @@ static void __perf_event_enable(void *info)
 		goto unlock;
 	__perf_event_mark_enabled(event, ctx);
 
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		goto unlock;
+
 	/*
 	 * If the event is in a group and isn't the group leader,
 	 * then don't put it on unless the group is on.
@@ -1595,10 +1601,7 @@ static struct perf_event_context *find_get_context(pid_t pid, int cpu)
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
