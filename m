Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbZFWKEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbZFWKEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZFWKEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:04:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:33667 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757368AbZFWKE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:04:29 -0400
Date: Tue, 23 Jun 2009 10:03:59 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter: Push inherit into perf_counter_alloc()
Message-ID: <tip-b84fbc9fb1d943e2c5f4efe52ed0e3c93a4bdb6a@git.kernel.org>
Git-Commit-ID: b84fbc9fb1d943e2c5f4efe52ed0e3c93a4bdb6a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 23 Jun 2009 10:04:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b84fbc9fb1d943e2c5f4efe52ed0e3c93a4bdb6a
Gitweb:     http://git.kernel.org/tip/b84fbc9fb1d943e2c5f4efe52ed0e3c93a4bdb6a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 22 Jun 2009 13:57:40 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Jun 2009 11:42:45 +0200

perf_counter: Push inherit into perf_counter_alloc()

Teach perf_counter_alloc() about inheritance so that we can
optimize the inherit path in the next patch.

Remove the child_counter->atrr.inherit = 1 line because the
only way to get there is if parent_counter->attr.inherit == 1
and we copy the attrs.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 7515c76..0a45490 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3568,6 +3568,7 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 		   int cpu,
 		   struct perf_counter_context *ctx,
 		   struct perf_counter *group_leader,
+		   struct perf_counter *parent_counter,
 		   gfp_t gfpflags)
 {
 	const struct pmu *pmu;
@@ -3603,6 +3604,8 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	counter->ctx		= ctx;
 	counter->oncpu		= -1;
 
+	counter->parent		= parent_counter;
+
 	counter->ns		= get_pid_ns(current->nsproxy->pid_ns);
 	counter->id		= atomic64_inc_return(&perf_counter_id);
 
@@ -3827,7 +3830,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 	}
 
 	counter = perf_counter_alloc(&attr, cpu, ctx, group_leader,
-				     GFP_KERNEL);
+				     NULL, GFP_KERNEL);
 	ret = PTR_ERR(counter);
 	if (IS_ERR(counter))
 		goto err_put_context;
@@ -3893,7 +3896,8 @@ inherit_counter(struct perf_counter *parent_counter,
 
 	child_counter = perf_counter_alloc(&parent_counter->attr,
 					   parent_counter->cpu, child_ctx,
-					   group_leader, GFP_KERNEL);
+					   group_leader, parent_counter,
+					   GFP_KERNEL);
 	if (IS_ERR(child_counter))
 		return child_counter;
 	get_ctx(child_ctx);
@@ -3916,12 +3920,6 @@ inherit_counter(struct perf_counter *parent_counter,
 	 */
 	add_counter_to_ctx(child_counter, child_ctx);
 
-	child_counter->parent = parent_counter;
-	/*
-	 * inherit into child's child as well:
-	 */
-	child_counter->attr.inherit = 1;
-
 	/*
 	 * Get a reference to the parent filp - we will fput it
 	 * when the child counter exits. This is safe to do because
