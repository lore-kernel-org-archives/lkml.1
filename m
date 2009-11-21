Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZKUNl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZKUNl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbZKUNl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:41:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:60850 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbZKUNlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:41:55 -0500
Date: Sat, 21 Nov 2009 13:41:29 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091120212508.378188589@chello.nl>
References: <20091120212508.378188589@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize perf_swevent_ctx_event()
Message-ID: <tip-81520183878a8813c71c9372de28bb70913ba549@git.kernel.org>
Git-Commit-ID: 81520183878a8813c71c9372de28bb70913ba549
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  81520183878a8813c71c9372de28bb70913ba549
Gitweb:     http://git.kernel.org/tip/81520183878a8813c71c9372de28bb70913ba549
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Nov 2009 22:19:45 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:35 +0100

perf: Optimize perf_swevent_ctx_event()

Remove a rcu_read_{,un}lock() pair and a few conditionals.

We can remove the rcu_read_lock() by increasing the scope of one
in the calling function.

We can do away with the system_state check if the machine still
boots after this patch (seems to be the case).

We can do away with the list_empty() check because the bare
list_for_each_entry_rcu() reduces to that now that we've removed
everything else.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091120212508.378188589@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8e55b44..cda17ac 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3886,15 +3886,10 @@ static void perf_swevent_ctx_event(struct perf_event_context *ctx,
 {
 	struct perf_event *event;
 
-	if (system_state != SYSTEM_RUNNING || list_empty(&ctx->event_list))
-		return;
-
-	rcu_read_lock();
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (perf_swevent_match(event, type, event_id, data, regs))
 			perf_swevent_add(event, nr, nmi, data, regs);
 	}
-	rcu_read_unlock();
 }
 
 static int *perf_swevent_recursion_context(struct perf_cpu_context *cpuctx)
@@ -3926,9 +3921,9 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 	(*recursion)++;
 	barrier();
 
+	rcu_read_lock();
 	perf_swevent_ctx_event(&cpuctx->ctx, type, event_id,
 				 nr, nmi, data, regs);
-	rcu_read_lock();
 	/*
 	 * doesn't really matter which of the child contexts the
 	 * events ends up in.
