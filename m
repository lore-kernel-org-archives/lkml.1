Return-Path: <linux-kernel-owner+w=401wt.eu-S1762547AbZCTK1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762547AbZCTK1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762287AbZCTKZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:25:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:35202 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762265AbZCTKZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:25:52 -0400
Date: Fri, 20 Mar 2009 10:25:08 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319194233.652078652@chello.nl>
References: <20090319194233.652078652@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: fix up counter free paths
Message-ID: <tip-789ce7d327a1548779d8b3ca15f244e17c899fe8@git.kernel.org>
Git-Commit-ID: 789ce7d327a1548779d8b3ca15f244e17c899fe8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:25:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  789ce7d327a1548779d8b3ca15f244e17c899fe8
Gitweb:     http://git.kernel.org/tip/789ce7d327a1548779d8b3ca15f244e17c899fe8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 19 Mar 2009 20:26:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:15:12 +0100

perf_counter: fix up counter free paths

Impact: fix crash during perfcounters use

I found another counter free path, create a free_counter() call to
accomodate generic tear-down.

Fixes an RCU bug.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090319194233.652078652@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 99d5930..97f891f 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1150,6 +1150,11 @@ static void free_counter_rcu(struct rcu_head *head)
 	kfree(counter);
 }
 
+static void free_counter(struct perf_counter *counter)
+{
+	call_rcu(&counter->rcu_head, free_counter_rcu);
+}
+
 /*
  * Called when the last reference to the file is gone.
  */
@@ -1168,7 +1173,7 @@ static int perf_release(struct inode *inode, struct file *file)
 	mutex_unlock(&counter->mutex);
 	mutex_unlock(&ctx->mutex);
 
-	call_rcu(&counter->rcu_head, free_counter_rcu);
+	free_counter(counter);
 	put_context(ctx);
 
 	return 0;
@@ -2128,10 +2133,10 @@ __perf_counter_exit_task(struct task_struct *child,
 					 list_entry) {
 			if (sub->parent) {
 				sync_child_counter(sub, sub->parent);
-				kfree(sub);
+				free_counter(sub);
 			}
 		}
-		kfree(child_counter);
+		free_counter(child_counter);
 	}
 }
 
