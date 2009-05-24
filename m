Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZEXHCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZEXHCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbZEXHCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:02:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:35678 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZEXHCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:02:04 -0400
Date: Sun, 24 May 2009 07:01:05 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090523163012.476197912@chello.nl>
References: <20090523163012.476197912@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Fix dynamic irq_period logging
Message-ID: <tip-e220d2dcb944c5c488b6855d15ec66d76900514f@git.kernel.org>
Git-Commit-ID: e220d2dcb944c5c488b6855d15ec66d76900514f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 24 May 2009 07:01:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e220d2dcb944c5c488b6855d15ec66d76900514f
Gitweb:     http://git.kernel.org/tip/e220d2dcb944c5c488b6855d15ec66d76900514f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 23 May 2009 18:28:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 23 May 2009 19:37:44 +0200

perf_counter: Fix dynamic irq_period logging

We call perf_adjust_freq() from perf_counter_task_tick() which
is is called under the rq->lock causing lock recursion.
However, it's no longer required to be called under the
rq->lock, so remove it from under it.

Also, fix up some related comments.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090523163012.476197912@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    1 +
 kernel/perf_counter.c        |    3 ++-
 kernel/sched.c               |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 2eedae8..23ddd29 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -260,6 +260,7 @@ enum perf_event_type {
 	/*
 	 * struct {
 	 * 	struct perf_event_header	header;
+	 * 	u64				time;
 	 * 	u64				irq_period;
 	 * };
 	 */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index c100554..2f410ea 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2559,7 +2559,8 @@ void perf_counter_munmap(unsigned long addr, unsigned long len,
 }
 
 /*
- *
+ * Log irq_period changes so that analyzing tools can re-normalize the
+ * event flow.
  */
 
 static void perf_log_period(struct perf_counter *counter, u64 period)
diff --git a/kernel/sched.c b/kernel/sched.c
index 4c0d58b..ad079f0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4875,9 +4875,10 @@ void scheduler_tick(void)
 	update_rq_clock(rq);
 	update_cpu_load(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
-	perf_counter_task_tick(curr, cpu);
 	spin_unlock(&rq->lock);
 
+	perf_counter_task_tick(curr, cpu);
+
 #ifdef CONFIG_SMP
 	rq->idle_at_tick = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);
