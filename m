Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbZE2M2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbZE2M2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZE2M2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:28:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:51739 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbZE2M2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:28:15 -0400
Date: Fri, 29 May 2009 12:27:46 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
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
Subject: [tip:perfcounters/core] perf_counter: Robustify counter-free logic
Message-ID: <tip-012b84dae17126d8b5d159173091eb3db5a2bc43@git.kernel.org>
Git-Commit-ID: 012b84dae17126d8b5d159173091eb3db5a2bc43
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 12:27:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  012b84dae17126d8b5d159173091eb3db5a2bc43
Gitweb:     http://git.kernel.org/tip/012b84dae17126d8b5d159173091eb3db5a2bc43
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 17 May 2009 11:08:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 14:28:37 +0200

perf_counter: Robustify counter-free logic

This fixes a nasty crash and highlights a bug that we were
freeing failed-fork() counters incorrectly.

(the fix for that will come separately)

[ Impact: fix crashes/lockups with inherited counters ]

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index eb34604..616c524 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1004,6 +1004,10 @@ static void __perf_counter_task_sched_out(struct perf_counter_context *ctx)
 
 	if (!cpuctx->task_ctx)
 		return;
+
+	if (WARN_ON_ONCE(ctx != cpuctx->task_ctx))
+		return;
+
 	__perf_counter_sched_out(ctx, cpuctx);
 	cpuctx->task_ctx = NULL;
 }
