Return-Path: <linux-kernel-owner+w=401wt.eu-S1761071AbZDHGzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761071AbZDHGzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758420AbZDHGzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:55:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:35362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759264AbZDHGzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:55:36 -0400
Date: Wed, 8 Apr 2009 06:55:15 GMT
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, tglx@linutronix.de
In-Reply-To: <49D1C596.5050203@cn.fujitsu.com>
References: <49D1C596.5050203@cn.fujitsu.com>
Subject: [tip:tracing/core] ftrace: clean up enable logic for sched_switch
Message-ID: <tip-dcef788eb9659b61a2110284fcce3ca6e63480d2@git.kernel.org>
Git-Commit-ID: dcef788eb9659b61a2110284fcce3ca6e63480d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 06:55:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dcef788eb9659b61a2110284fcce3ca6e63480d2
Gitweb:     http://git.kernel.org/tip/dcef788eb9659b61a2110284fcce3ca6e63480d2
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Tue, 31 Mar 2009 15:26:14 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 14:43:09 +0200

ftrace: clean up enable logic for sched_switch

Unify sched_switch and sched_wakeup's action to following logic:
Do record_cmdline when start_cmdline_record() is called.
Start tracing events when the tracer is started.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
LKML-Reference: <49D1C596.5050203@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/trace_sched_switch.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 9117cea..9d8cccd 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -29,13 +29,13 @@ probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 	int cpu;
 	int pc;
 
-	if (!sched_ref || sched_stopped)
+	if (unlikely(!sched_ref))
 		return;
 
 	tracing_record_cmdline(prev);
 	tracing_record_cmdline(next);
 
-	if (!tracer_enabled)
+	if (!tracer_enabled || sched_stopped)
 		return;
 
 	pc = preempt_count();
@@ -56,15 +56,15 @@ probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
 	unsigned long flags;
 	int cpu, pc;
 
-	if (!likely(tracer_enabled))
+	if (unlikely(!sched_ref))
 		return;
 
-	pc = preempt_count();
 	tracing_record_cmdline(current);
 
-	if (sched_stopped)
+	if (!tracer_enabled || sched_stopped)
 		return;
 
+	pc = preempt_count();
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = ctx_trace->data[cpu];
