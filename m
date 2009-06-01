Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZFAIUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZFAIUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZFAIUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:20:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:38944 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459AbZFAIUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:20:09 -0400
Date: Mon, 1 Jun 2009 08:19:29 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18979.35052.915728.626374@cargo.ozlabs.ibm.com>
References: <18979.35052.915728.626374@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: Remove unused prev_state field
Message-ID: <tip-4a3b3ef5ba929d2698794984bf9c9b02244c49cd@git.kernel.org>
Git-Commit-ID: 4a3b3ef5ba929d2698794984bf9c9b02244c49cd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 08:19:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a3b3ef5ba929d2698794984bf9c9b02244c49cd
Gitweb:     http://git.kernel.org/tip/4a3b3ef5ba929d2698794984bf9c9b02244c49cd
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 1 Jun 2009 17:53:16 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 1 Jun 2009 10:04:07 +0200

perf_counter: Remove unused prev_state field

This removes the prev_state field of struct perf_counter since
it is now unused.  It was only used by the cpu migration
counter, which doesn't use it any more.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <18979.35052.915728.626374@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    1 -
 kernel/perf_counter.c        |    4 ----
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index e630602..82ab958 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -427,7 +427,6 @@ struct perf_counter {
 	const struct pmu		*pmu;
 
 	enum perf_counter_active_state	state;
-	enum perf_counter_active_state	prev_state;
 	atomic64_t			count;
 
 	/*
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index c7a20fa..d6d2f9d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -570,7 +570,6 @@ group_sched_in(struct perf_counter *group_counter,
 	if (ret)
 		return ret < 0 ? ret : 0;
 
-	group_counter->prev_state = group_counter->state;
 	if (counter_sched_in(group_counter, cpuctx, ctx, cpu))
 		return -EAGAIN;
 
@@ -578,7 +577,6 @@ group_sched_in(struct perf_counter *group_counter,
 	 * Schedule in siblings as one group (if any):
 	 */
 	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
-		counter->prev_state = counter->state;
 		if (counter_sched_in(counter, cpuctx, ctx, cpu)) {
 			partial_group = counter;
 			goto group_error;
@@ -655,7 +653,6 @@ static void add_counter_to_ctx(struct perf_counter *counter,
 			       struct perf_counter_context *ctx)
 {
 	list_add_counter(counter, ctx);
-	counter->prev_state = PERF_COUNTER_STATE_OFF;
 	counter->tstamp_enabled = ctx->time;
 	counter->tstamp_running = ctx->time;
 	counter->tstamp_stopped = ctx->time;
@@ -818,7 +815,6 @@ static void __perf_counter_enable(void *info)
 	ctx->is_active = 1;
 	update_context_time(ctx);
 
-	counter->prev_state = counter->state;
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 		goto unlock;
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
