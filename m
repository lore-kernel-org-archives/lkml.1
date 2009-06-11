Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbZFKAng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbZFKAng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 20:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbZFKAn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 20:43:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:59577 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756440AbZFKAn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 20:43:27 -0400
Date: Thu, 11 Jun 2009 00:42:49 GMT
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
Subject: [tip:perfcounters/core] perf_counter: Annotate exit ctx recursion
Message-ID: <tip-66fff22483d8542dfb4d61a28d21277bbde321e8@git.kernel.org>
Git-Commit-ID: 66fff22483d8542dfb4d61a28d21277bbde321e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 11 Jun 2009 00:42:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66fff22483d8542dfb4d61a28d21277bbde321e8
Gitweb:     http://git.kernel.org/tip/66fff22483d8542dfb4d61a28d21277bbde321e8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 10 Jun 2009 22:53:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Jun 2009 02:39:01 +0200

perf_counter: Annotate exit ctx recursion

Ever since Paul fixed it to unclone the context before taking the
ctx->lock this became a false positive, annotate it away.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 51c571e..ae591a1 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3879,7 +3879,18 @@ void perf_counter_exit_task(struct task_struct *child)
 	spin_unlock(&child_ctx->lock);
 	local_irq_restore(flags);
 
-	mutex_lock(&child_ctx->mutex);
+	/*
+	 * We can recurse on the same lock type through:
+	 *
+	 *   __perf_counter_exit_task()
+	 *     sync_child_counter()
+	 *       fput(parent_counter->filp)
+	 *         perf_release()
+	 *           mutex_lock(&ctx->mutex)
+	 *
+	 * But since its the parent context it won't be the same instance.
+	 */
+	mutex_lock_nested(&child_ctx->mutex, SINGLE_DEPTH_NESTING);
 
 again:
 	list_for_each_entry_safe(child_counter, tmp, &child_ctx->counter_list,
