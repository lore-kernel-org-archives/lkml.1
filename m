Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbZE2RQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbZE2RQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 13:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761363AbZE2RQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 13:16:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:57523 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761301AbZE2RQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 13:16:42 -0400
Date: Fri, 29 May 2009 17:16:09 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Fix COMM and MMAP events for cpu wide counters
Message-ID: <tip-efb3d17240d80e27508d238809168120fe4b93a4@git.kernel.org>
Git-Commit-ID: efb3d17240d80e27508d238809168120fe4b93a4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 17:16:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  efb3d17240d80e27508d238809168120fe4b93a4
Gitweb:     http://git.kernel.org/tip/efb3d17240d80e27508d238809168120fe4b93a4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 29 May 2009 14:25:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 16:21:51 +0200

perf_counter: Fix COMM and MMAP events for cpu wide counters

Commit a63eaf34ae6 ("perf_counter: Dynamically allocate tasks'
perf_counter_context struct") broke COMM and MMAP notification for
cpu wide counters by dropping out early if there was no task context,
thereby also not iterating the cpu context.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 616c524..58d6d19 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2443,9 +2443,9 @@ static void perf_counter_comm_event(struct perf_comm_event *comm_event)
 
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_counter_comm_ctx(&cpuctx->ctx, comm_event);
+	if (cpuctx->task_ctx)
+		perf_counter_comm_ctx(cpuctx->task_ctx, comm_event);
 	put_cpu_var(perf_cpu_context);
-
-	perf_counter_comm_ctx(current->perf_counter_ctxp, comm_event);
 }
 
 void perf_counter_comm(struct task_struct *task)
@@ -2454,8 +2454,6 @@ void perf_counter_comm(struct task_struct *task)
 
 	if (!atomic_read(&nr_comm_tracking))
 		return;
-	if (!current->perf_counter_ctxp)
-		return;
 
 	comm_event = (struct perf_comm_event){
 		.task	= task,
@@ -2570,10 +2568,10 @@ got_name:
 
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_counter_mmap_ctx(&cpuctx->ctx, mmap_event);
+	if (cpuctx->task_ctx)
+		perf_counter_mmap_ctx(cpuctx->task_ctx, mmap_event);
 	put_cpu_var(perf_cpu_context);
 
-	perf_counter_mmap_ctx(current->perf_counter_ctxp, mmap_event);
-
 	kfree(buf);
 }
 
@@ -2584,8 +2582,6 @@ void perf_counter_mmap(unsigned long addr, unsigned long len,
 
 	if (!atomic_read(&nr_mmap_tracking))
 		return;
-	if (!current->perf_counter_ctxp)
-		return;
 
 	mmap_event = (struct perf_mmap_event){
 		.file   = file,
