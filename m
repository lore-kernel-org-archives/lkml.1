Return-Path: <linux-kernel-owner+w=401wt.eu-S1762366AbZCTK0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762366AbZCTK0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761319AbZCTKZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:25:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:35170 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759328AbZCTKZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:25:24 -0400
Date: Fri, 20 Mar 2009 10:24:50 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319194233.195392657@chello.nl>
References: <20090319194233.195392657@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: fix uninitialized usage of event_list
Message-ID: <tip-50d8b58c48c7acb4f4ed80c24593ffe2a9c7d1ce@git.kernel.org>
Git-Commit-ID: 50d8b58c48c7acb4f4ed80c24593ffe2a9c7d1ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:24:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50d8b58c48c7acb4f4ed80c24593ffe2a9c7d1ce
Gitweb:     http://git.kernel.org/tip/50d8b58c48c7acb4f4ed80c24593ffe2a9c7d1ce
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 19 Mar 2009 20:26:11 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:15:11 +0100

perf_counter: fix uninitialized usage of event_list

Impact: fix boot crash

When doing the generic context switch event I ran into some early
boot hangs, which were caused by inf func recursion (event, fault,
event, fault).

I eventually tracked it down to event_list not being initialized
at the time of the first event. Fix this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090319194233.195392657@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/init_task.h |    2 ++
 kernel/perf_counter.c     |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 219748d..ca226a9 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -124,6 +124,8 @@ extern struct cred init_cred;
 # define INIT_PERF_COUNTERS(tsk)					\
 	.perf_counter_ctx.counter_list =				\
 		LIST_HEAD_INIT(tsk.perf_counter_ctx.counter_list),	\
+	.perf_counter_ctx.event_list =					\
+		LIST_HEAD_INIT(tsk.perf_counter_ctx.event_list),	\
 	.perf_counter_ctx.lock =					\
 		__SPIN_LOCK_UNLOCKED(tsk.perf_counter_ctx.lock),
 #else
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b39456a..4c4e9eb 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1506,7 +1506,7 @@ static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 {
 	struct perf_counter *counter;
 
-	if (list_empty(&ctx->event_list))
+	if (system_state != SYSTEM_RUNNING || list_empty(&ctx->event_list))
 		return;
 
 	rcu_read_lock();
