Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZKUNmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZKUNmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZKUNmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:42:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:60888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbZKUNmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:42:36 -0500
Date: Sat, 21 Nov 2009 13:42:10 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091120212508.606459548@chello.nl>
References: <20091120212508.606459548@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize perf_event_mmap_ctx()
Message-ID: <tip-f6d9dd237da400effb265f3554c64413f8a3e7b4@git.kernel.org>
Git-Commit-ID: f6d9dd237da400effb265f3554c64413f8a3e7b4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6d9dd237da400effb265f3554c64413f8a3e7b4
Gitweb:     http://git.kernel.org/tip/f6d9dd237da400effb265f3554c64413f8a3e7b4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Nov 2009 22:19:48 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:37 +0100

perf: Optimize perf_event_mmap_ctx()

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
LKML-Reference: <20091120212508.606459548@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 4deefaa..68fbf4f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3493,15 +3493,10 @@ static void perf_event_mmap_ctx(struct perf_event_context *ctx,
 {
 	struct perf_event *event;
 
-	if (system_state != SYSTEM_RUNNING || list_empty(&ctx->event_list))
-		return;
-
-	rcu_read_lock();
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (perf_event_mmap_match(event, mmap_event))
 			perf_event_mmap_output(event, mmap_event);
 	}
-	rcu_read_unlock();
 }
 
 static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
@@ -3557,11 +3552,11 @@ got_name:
 
 	mmap_event->event_id.header.size = sizeof(mmap_event->event_id) + size;
 
+	rcu_read_lock();
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_mmap_ctx(&cpuctx->ctx, mmap_event);
 	put_cpu_var(perf_cpu_context);
 
-	rcu_read_lock();
 	/*
 	 * doesn't really matter which of the child contexts the
 	 * events ends up in.
