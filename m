Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbZETRTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbZETRTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbZETRTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:19:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:48371 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbZETRTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:19:40 -0400
Date: Wed, 20 May 2009 17:19:09 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090520102553.388185031@chello.nl>
References: <20090520102553.388185031@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Optimize disable of time based sw counters
Message-ID: <tip-b986d7ec0f8b7ea3cc7366d80a137fbe839df227@git.kernel.org>
Git-Commit-ID: b986d7ec0f8b7ea3cc7366d80a137fbe839df227
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 20 May 2009 17:19:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b986d7ec0f8b7ea3cc7366d80a137fbe839df227
Gitweb:     http://git.kernel.org/tip/b986d7ec0f8b7ea3cc7366d80a137fbe839df227
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 20 May 2009 12:21:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 May 2009 12:43:33 +0200

perf_counter: Optimize disable of time based sw counters

Currently we call hrtimer_cancel() unconditionally on disable of time based
software counters. Avoid when possible.

[ Impact: micro-optimize the code ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090520102553.388185031@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index db02eb1..473ed2c 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2716,7 +2716,8 @@ static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
 
 static void cpu_clock_perf_counter_disable(struct perf_counter *counter)
 {
-	hrtimer_cancel(&counter->hw.hrtimer);
+	if (counter->hw.irq_period)
+		hrtimer_cancel(&counter->hw.hrtimer);
 	cpu_clock_perf_counter_update(counter);
 }
 
@@ -2767,7 +2768,8 @@ static int task_clock_perf_counter_enable(struct perf_counter *counter)
 
 static void task_clock_perf_counter_disable(struct perf_counter *counter)
 {
-	hrtimer_cancel(&counter->hw.hrtimer);
+	if (counter->hw.irq_period)
+		hrtimer_cancel(&counter->hw.hrtimer);
 	task_clock_perf_counter_update(counter, counter->ctx->time);
 
 }
