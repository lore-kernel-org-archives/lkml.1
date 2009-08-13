Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbZHMLCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbZHMLCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZHMLCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:02:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:35609 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbZHMLBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:01:51 -0400
Date: Thu, 13 Aug 2009 11:00:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, eranian@googlemail.com, cjashfor@us.ibm.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, cjashfor@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090813103655.244097721@chello.nl>
References: <20090813103655.244097721@chello.nl>
Subject: [tip:perfcounters/urgent] perf_counter: Fix an ipi-deadlock
Message-ID: <tip-970892a9031a5dc7217bd394fb9d89fa75a4a7bc@git.kernel.org>
Git-Commit-ID: 970892a9031a5dc7217bd394fb9d89fa75a4a7bc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Aug 2009 11:01:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  970892a9031a5dc7217bd394fb9d89fa75a4a7bc
Gitweb:     http://git.kernel.org/tip/970892a9031a5dc7217bd394fb9d89fa75a4a7bc
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 13 Aug 2009 11:47:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 13 Aug 2009 12:58:05 +0200

perf_counter: Fix an ipi-deadlock

perf_pending_counter() is called from IRQ context and will call
perf_counter_disable(), however perf_counter_disable() uses
smp_call_function_single() which doesn't fancy being used with
IRQs disabled due to IPI deadlocks.

Fix this by making it use the local __perf_counter_disable()
call and teaching the counter_sched_out() code about pending
disables as well.

This should cover the case where a counter migrates before the
pending queue gets processed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey J Ashford <cjashfor@us.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>
LKML-Reference: <20090813103655.244097721@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b8c6b97..3f841be 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -307,6 +307,10 @@ counter_sched_out(struct perf_counter *counter,
 		return;
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	if (counter->pending_disable) {
+		counter->pending_disable = 0;
+		counter->state = PERF_COUNTER_STATE_OFF;
+	}
 	counter->tstamp_stopped = ctx->time;
 	counter->pmu->disable(counter);
 	counter->oncpu = -1;
@@ -2343,7 +2347,7 @@ static void perf_pending_counter(struct perf_pending_entry *entry)
 
 	if (counter->pending_disable) {
 		counter->pending_disable = 0;
-		perf_counter_disable(counter);
+		__perf_counter_disable(counter);
 	}
 
 	if (counter->pending_wakeup) {
