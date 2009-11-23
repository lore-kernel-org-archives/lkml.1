Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZKWRoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZKWRoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZKWRoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:44:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:41606 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbZKWRoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:44:21 -0500
Date: Mon, 23 Nov 2009 17:43:49 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <1258987355-8751-3-git-send-email-fweisbec@gmail.com>
References: <1258987355-8751-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add kernel side syscall events support for breakpoints
Message-ID: <tip-f5ffe02e5046003ae7e2ce70d3d1c2a73331268b@git.kernel.org>
Git-Commit-ID: f5ffe02e5046003ae7e2ce70d3d1c2a73331268b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5ffe02e5046003ae7e2ce70d3d1c2a73331268b
Gitweb:     http://git.kernel.org/tip/f5ffe02e5046003ae7e2ce70d3d1c2a73331268b
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 23 Nov 2009 15:42:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 18:18:31 +0100

perf: Add kernel side syscall events support for breakpoints

Add the remaining necessary bits to support breakpoints created
through perf syscall.

We don't use the software counter interface as:

- We don't need to check against recursion, this is already done
  in hardware breakpoints arch level.

- We already know the perf event we are dealing with when the
  event is to be committed.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <1258987355-8751-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0aafe85..9425c96 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3831,6 +3831,20 @@ static int perf_swevent_is_counting(struct perf_event *event)
 static int perf_tp_event_match(struct perf_event *event,
 				struct perf_sample_data *data);
 
+static int perf_exclude_event(struct perf_event *event,
+			      struct pt_regs *regs)
+{
+	if (regs) {
+		if (event->attr.exclude_user && user_mode(regs))
+			return 1;
+
+		if (event->attr.exclude_kernel && !user_mode(regs))
+			return 1;
+	}
+
+	return 0;
+}
+
 static int perf_swevent_match(struct perf_event *event,
 				enum perf_type_id type,
 				u32 event_id,
@@ -3842,16 +3856,12 @@ static int perf_swevent_match(struct perf_event *event,
 
 	if (event->attr.type != type)
 		return 0;
+
 	if (event->attr.config != event_id)
 		return 0;
 
-	if (regs) {
-		if (event->attr.exclude_user && user_mode(regs))
-			return 0;
-
-		if (event->attr.exclude_kernel && !user_mode(regs))
-			return 0;
-	}
+	if (perf_exclude_event(event, regs))
+		return 0;
 
 	if (event->attr.type == PERF_TYPE_TRACEPOINT &&
 	    !perf_tp_event_match(event, data))
@@ -4282,9 +4292,15 @@ static const struct pmu *bp_perf_event_init(struct perf_event *bp)
 	return &perf_ops_bp;
 }
 
-void perf_bp_event(struct perf_event *bp, void *regs)
+void perf_bp_event(struct perf_event *bp, void *data)
 {
-	/* TODO */
+	struct perf_sample_data sample;
+	struct pt_regs *regs = data;
+
+	sample.addr = bp->attr.bp_addr;
+
+	if (!perf_exclude_event(bp, regs))
+		perf_swevent_add(bp, 1, 1, &sample, regs);
 }
 #else
 static void bp_perf_event_destroy(struct perf_event *event)
