Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZELNe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZELNe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZELNeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:34:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:54286 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbZELNeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:34:18 -0400
Date: Tue, 12 May 2009 13:33:31 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18953.25733.53359.147452@cargo.ozlabs.ibm.com>
References: <18953.25733.53359.147452@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: call hw_perf_save_disable/restore around group_sched_in
Message-ID: <tip-e758a33d6fc5b9d6a3ae489863d04fcecad8120b@git.kernel.org>
Git-Commit-ID: e758a33d6fc5b9d6a3ae489863d04fcecad8120b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 13:33:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e758a33d6fc5b9d6a3ae489863d04fcecad8120b
Gitweb:     http://git.kernel.org/tip/e758a33d6fc5b9d6a3ae489863d04fcecad8120b
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Tue, 12 May 2009 21:59:01 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 12 May 2009 15:31:06 +0200

perf_counter: call hw_perf_save_disable/restore around group_sched_in

I noticed that when enabling a group via the PERF_COUNTER_IOC_ENABLE
ioctl on the group leader, the counters weren't enabled and counting
immediately on return from the ioctl, but did start counting a little
while later (presumably after a context switch).

The reason was that __perf_counter_enable calls group_sched_in which
calls hw_perf_group_sched_in, which on powerpc assumes that the caller
has called hw_perf_save_disable already.  Until commit 46d686c6
("perf_counter: put whole group on when enabling group leader") it was
true that all callers of group_sched_in had called
hw_perf_save_disable first, and the powerpc hw_perf_group_sched_in
relies on that (there isn't an x86 version).

This fixes the problem by putting calls to hw_perf_save_disable /
hw_perf_restore around the calls to group_sched_in and
counter_sched_in in __perf_counter_enable.  Having the calls to
hw_perf_save_disable/restore around the counter_sched_in call is
harmless and makes this call consistent with the other call sites
of counter_sched_in, which have all called hw_perf_save_disable first.

[ Impact: more precise counter group disable/enable functionality ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <18953.25733.53359.147452@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 5ea0240..ff166c1 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -663,6 +663,7 @@ static void __perf_counter_enable(void *info)
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_counter_context *ctx = counter->ctx;
 	struct perf_counter *leader = counter->group_leader;
+	unsigned long pmuflags;
 	unsigned long flags;
 	int err;
 
@@ -689,14 +690,18 @@ static void __perf_counter_enable(void *info)
 	if (leader != counter && leader->state != PERF_COUNTER_STATE_ACTIVE)
 		goto unlock;
 
-	if (!group_can_go_on(counter, cpuctx, 1))
+	if (!group_can_go_on(counter, cpuctx, 1)) {
 		err = -EEXIST;
-	else if (counter == leader)
-		err = group_sched_in(counter, cpuctx, ctx,
-				     smp_processor_id());
-	else
-		err = counter_sched_in(counter, cpuctx, ctx,
-				       smp_processor_id());
+	} else {
+		pmuflags = hw_perf_save_disable();
+		if (counter == leader)
+			err = group_sched_in(counter, cpuctx, ctx,
+					     smp_processor_id());
+		else
+			err = counter_sched_in(counter, cpuctx, ctx,
+					       smp_processor_id());
+		hw_perf_restore(pmuflags);
+	}
 
 	if (err) {
 		/*
