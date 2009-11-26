Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbZKZIq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbZKZIq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760069AbZKZIq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:46:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:58885 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760025AbZKZIqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:46:24 -0500
Date: Thu, 26 Nov 2009 08:45:39 GMT
From: tip-bot for Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, fweisbec@gmail.com,
       akpm@linux-foundation.org, tj@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, fweisbec@gmail.com,
       akpm@linux-foundation.org, tj@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <200911260701.nAQ71owx016356@imap1.linux-foundation.org>
References: <200911260701.nAQ71owx016356@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kernel/hw_breakpoint.c: Fix local/global shadowing
Message-ID: <tip-11e6635763bdc0e24b39a38876574660755acffc@git.kernel.org>
Git-Commit-ID: 11e6635763bdc0e24b39a38876574660755acffc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11e6635763bdc0e24b39a38876574660755acffc
Gitweb:     http://git.kernel.org/tip/11e6635763bdc0e24b39a38876574660755acffc
Author:     Andrew Morton <akpm@linux-foundation.org>
AuthorDate: Wed, 25 Nov 2009 23:01:50 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:34:04 +0100

kernel/hw_breakpoint.c: Fix local/global shadowing

If the new percpu tree is combined with the perf events tree
the following new warning triggers:

 kernel/hw_breakpoint.c: In function 'toggle_bp_task_slot':
 kernel/hw_breakpoint.c:151: warning: 'task_bp_pinned' is used uninitialized in this function

Because it's not valid anymore to define a local variable
and a percpu variable (even if it's file scope local) with
the same name.

Rename the local variable to resolve this.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <200911260701.nAQ71owx016356@imap1.linux-foundation.org>
[ v2: added changelog ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/hw_breakpoint.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index dd3fb4a..32e1018 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -121,7 +121,7 @@ static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable)
 	int count = 0;
 	struct perf_event *bp;
 	struct perf_event_context *ctx = tsk->perf_event_ctxp;
-	unsigned int *task_bp_pinned;
+	unsigned int *tsk_pinned;
 	struct list_head *list;
 	unsigned long flags;
 
@@ -146,15 +146,15 @@ static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable)
 	if (WARN_ONCE(count < 0, "No breakpoint counter found in the counter list"))
 		return;
 
-	task_bp_pinned = per_cpu(task_bp_pinned, cpu);
+	tsk_pinned = per_cpu(task_bp_pinned, cpu);
 	if (enable) {
-		task_bp_pinned[count]++;
+		tsk_pinned[count]++;
 		if (count > 0)
-			task_bp_pinned[count-1]--;
+			tsk_pinned[count-1]--;
 	} else {
-		task_bp_pinned[count]--;
+		tsk_pinned[count]--;
 		if (count > 0)
-			task_bp_pinned[count-1]++;
+			tsk_pinned[count-1]++;
 	}
 }
 
