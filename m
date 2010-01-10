Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593Ab0AJBi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0AJBi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 20:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496Ab0AJBir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 20:38:47 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:49789 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab0AJBic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 20:38:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bZbFgLQ9kdg7aAYHgWayxVLwXSylyN6DXVe7m9TDRE5fAn7J2rJ4ne9RJ9U3U2/xS5
         Mv5xf14plPkb69ialAJCuaV4CWnMOwGqSvSs5AuYgojduXX6m2tiviwqQPM/uB2yBLNF
         bodLLuffMdsB1iQl+M984Yw5Cx43DjscA2fjc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 6/6] perf: Increase round-robin fairness of flexible events
Date: Sun, 10 Jan 2010 02:38:20 +0100
Message-Id: <1263087500-14215-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group of flexible events are round-robined in each tick so that
each group has its chance to be scheduled. But the fairness
per group granularity doesn't propagate inside the groups
themselves.

If only the first events of each groups have a chance to make
their way, the remaining ones will never be scheduled.

Hence this patch propagates the round-robin to the events
inside the groups.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_event.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 584e854..407137a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1446,16 +1446,21 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
  */
 static void rotate_ctx(struct perf_event_context *ctx)
 {
+	struct perf_event *leader;
+
 	if (!ctx->nr_events)
 		return;
 
 	raw_spin_lock(&ctx->lock);
 	/*
 	 * Rotate the first entry last of non-pinned groups
+	 * and events inside these groups
 	 */
 	perf_disable();
 
 	list_rotate_left(&ctx->flexible_groups);
+	list_for_each_entry(leader, &ctx->flexible_groups, group_entry)
+		list_rotate_left(&leader->sibling_list);
 
 	perf_enable();
 
-- 
1.6.2.3

