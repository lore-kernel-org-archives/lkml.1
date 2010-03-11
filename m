Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab0CKG0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 01:26:45 -0500
Received: from smtp-out.google.com ([216.239.44.51]:23637 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0CKG0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 01:26:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=qWrOZtfQ/j1SRAbS72hZjTomoXny5MPod8vUxUh6aDhFKcNN7xGGnLQOg3Pgx+d3C
	VZ8l46o3T0POloFJ2Lj8g==
From: eranian@google.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, fweisbec@gmail.com,
       robert.richter@amd.com, davem@davemloft.net,
       perfmon2-devel@lists.sf.net
Subject: [PATCH] perf_events: improve task_sched_in()
Date: Wed, 10 Mar 2010 22:26:05 -0800
Message-Id: <1268288765-5326-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is an optimization in perf_event_task_sched_in() to avoid scheduling
the events twice in a row. Without it, the perf_disable()/perf_enable() pair
is invoked twice, thereby pinned events counts while scheduling flexible events
and we go throuh hw_perf_enable() twice. By encapsulating, the whole sequence
into perf_disable()/perf_enable() we ensure, hw_perf_enable() is going to be
invoked only once because of the refcount protection.

	Signed-off-by: Stephane Eranian <eranian@google.com>
--
 perf_event.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1382,6 +1382,8 @@ void perf_event_task_sched_in(struct task_struct *task)
 	if (cpuctx->task_ctx == ctx)
 		return;
 
+	perf_disable();
+
 	/*
 	 * We want to keep the following priority order:
 	 * cpu pinned (that don't need to move), task pinned,
@@ -1394,6 +1396,8 @@ void perf_event_task_sched_in(struct task_struct *task)
 	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
 
 	cpuctx->task_ctx = ctx;
+
+	perf_enable();
 }
 
 #define MAX_INTERRUPTS (~0ULL)
