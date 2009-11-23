Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZKWOnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZKWOnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbZKWOmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:42:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60467 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbZKWOmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:42:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=f+iLWlyn9QZ6yTc3EuttDBYGK7d5QHQEFpdB450TqyDd/3lFEX1ZUi4+HA/2Rigzo+
         PvF4P+yVcupj3Uh7UvN5Nk6a69MJRWuOhctlHeBhrqTw47kg/Z1Ol3cHPvAAPOlqM83I
         4F+3b5YzCLbtOasavU6Gf+/Sw8qe2uurAWhoE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 3/4] perf: Add kernel side syscall events support for breakpoints
Date: Mon, 23 Nov 2009 15:42:34 +0100
Message-Id: <1258987355-8751-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1258987355-8751-1-git-send-email-fweisbec@gmail.com>
References: <1258987355-8751-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the remaining necessary bits to support breakpoints created through
perf syscall.

We don't use the software counter interface as:

- We don't need to check against recursion, this is already done in
hardware breakpoints arch level.

- We already know the perf event we are dealing with when the event
is to be committed.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/perf_event.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0b0d5f7..5fbca43 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3826,6 +3826,20 @@ static int perf_swevent_is_counting(struct perf_event *event)
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
@@ -3837,16 +3851,12 @@ static int perf_swevent_match(struct perf_event *event,
 
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
@@ -4277,9 +4287,15 @@ static const struct pmu *bp_perf_event_init(struct perf_event *bp)
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
-- 
1.6.2.3

