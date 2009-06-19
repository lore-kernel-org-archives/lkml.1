Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbZFSQ2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbZFSQ2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 12:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbZFSQ21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 12:28:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:58870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbZFSQ20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 12:28:26 -0400
Date: Fri, 19 Jun 2009 16:27:37 GMT
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
Subject: [tip:perfcounters/core] perf_counter: Close race in perf_lock_task_context()
Message-ID: <tip-b49a9e7e72103ea91946453c19703a4dfa1994fe@git.kernel.org>
Git-Commit-ID: b49a9e7e72103ea91946453c19703a4dfa1994fe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 19 Jun 2009 16:27:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b49a9e7e72103ea91946453c19703a4dfa1994fe
Gitweb:     http://git.kernel.org/tip/b49a9e7e72103ea91946453c19703a4dfa1994fe
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 19 Jun 2009 17:39:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 19 Jun 2009 17:57:36 +0200

perf_counter: Close race in perf_lock_task_context()

perf_lock_task_context() is buggy because it can return a dead
context.

the RCU read lock in perf_lock_task_context() only guarantees
the memory won't get freed, it doesn't guarantee the object is
valid (in our case refcount > 0).

Therefore we can return a locked object that can get freed the
moment we release the rcu read lock.

perf_pin_task_context() then increases the refcount and does an
unlock on freed memory.

That increased refcount will cause a double free, in case it
started out with 0.

Ammend this by including the get_ctx() functionality in
perf_lock_task_context() (all users already did this later
anyway), and return a NULL context when the found one is
already dead.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 8d4f0dd..adb6ae5 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -175,6 +175,11 @@ perf_lock_task_context(struct task_struct *task, unsigned long *flags)
 			spin_unlock_irqrestore(&ctx->lock, *flags);
 			goto retry;
 		}
+
+		if (!atomic_inc_not_zero(&ctx->refcount)) {
+			spin_unlock_irqrestore(&ctx->lock, *flags);
+			ctx = NULL;
+		}
 	}
 	rcu_read_unlock();
 	return ctx;
@@ -193,7 +198,6 @@ static struct perf_counter_context *perf_pin_task_context(struct task_struct *ta
 	ctx = perf_lock_task_context(task, &flags);
 	if (ctx) {
 		++ctx->pin_count;
-		get_ctx(ctx);
 		spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 	return ctx;
@@ -1459,11 +1463,6 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 			put_ctx(parent_ctx);
 			ctx->parent_ctx = NULL;		/* no longer a clone */
 		}
-		/*
-		 * Get an extra reference before dropping the lock so that
-		 * this context won't get freed if the task exits.
-		 */
-		get_ctx(ctx);
 		spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
