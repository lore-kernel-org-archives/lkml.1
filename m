Return-Path: <linux-kernel-owner+w=401wt.eu-S1751556AbZKZRwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbZKZRwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZKZRwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:52:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:46840 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZKZRwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:52:09 -0500
Date: Thu, 26 Nov 2009 17:51:35 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4b0eb9ce.0508d00a.573b.ffffeab6@mx.google.com>
References: <4b0eb9ce.0508d00a.573b.ffffeab6@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix read() bogus counts when in error state
Message-ID: <tip-b2e74a265ded1a185f762ebaab967e9e0d008dd8@git.kernel.org>
Git-Commit-ID: b2e74a265ded1a185f762ebaab967e9e0d008dd8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2e74a265ded1a185f762ebaab967e9e0d008dd8
Gitweb:     http://git.kernel.org/tip/b2e74a265ded1a185f762ebaab967e9e0d008dd8
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 26 Nov 2009 09:24:30 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 18:49:59 +0100

perf_events: Fix read() bogus counts when in error state

When a pinned group cannot be scheduled it goes into error state.

Normally a group cannot go out of error state without being
explicitly re-enabled or disabled. There was a bug in per-thread
mode, whereby upon termination of the thread, the group would
transition from error to off leading to bogus counts and timing
information returned by read().

Fix it by clearing the error state.

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: perfmon2-devel@lists.sourceforge.net
LKML-Reference: <4b0eb9ce.0508d00a.573b.ffffeab6@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f8c7939..0b9ca2d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -338,7 +338,16 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 		event->group_leader->nr_siblings--;
 
 	update_event_times(event);
-	event->state = PERF_EVENT_STATE_OFF;
+
+	/*
+	 * If event was in error state, then keep it
+	 * that way, otherwise bogus counts will be
+	 * returned on read(). The only way to get out
+	 * of error state is by explicit re-enabling
+	 * of the event
+	 */
+	if (event->state > PERF_EVENT_STATE_OFF)
+		event->state = PERF_EVENT_STATE_OFF;
 
 	/*
 	 * If this was a group event with sibling events then
