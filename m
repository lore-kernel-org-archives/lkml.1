Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbZCPIVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbZCPIVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbZCPIUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:20:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:44692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513AbZCPIUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:20:04 -0400
Date: Mon, 16 Mar 2009 08:18:59 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237151439-6755-3-git-send-email-fweisbec@gmail.com>
References: <1237151439-6755-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/syscalls] tracing/syscalls: protect thread flag toggling from races
Message-ID: <tip-5be71b61f17b0e3bc8ad0b1a1b7b53ab7d574ebb@git.kernel.org>
Git-Commit-ID: 5be71b61f17b0e3bc8ad0b1a1b7b53ab7d574ebb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 08:19:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5be71b61f17b0e3bc8ad0b1a1b7b53ab7d574ebb
Gitweb:     http://git.kernel.org/tip/5be71b61f17b0e3bc8ad0b1a1b7b53ab7d574ebb
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 15 Mar 2009 22:10:37 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Mar 2009 09:13:16 +0100

tracing/syscalls: protect thread flag toggling from races

Impact: fix syscall tracer enable/disable race

The current thread flag toggling is racy as shown in the following
scenario:

- task A is the last user of syscall tracing, it releases the
  TIF_SYSCALL_FTRACE on each tasks

- at the same time task B start syscall tracing. refcount == 0 so
  it sets up TIF_SYSCALL_FTRACE on each tasks.

The effect of the mixup is unpredictable.
So this fix adds a mutex on {start,stop}_syscall_tracing().

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1237151439-6755-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_syscalls.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 26f9a86..a2a3af2 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -5,7 +5,11 @@
 #include "trace_output.h"
 #include "trace.h"
 
-static atomic_t refcount;
+/* Keep a counter of the syscall tracing users */
+static int refcount;
+
+/* Prevent from races on thread flags toggling */
+static DEFINE_MUTEX(syscall_trace_lock);
 
 /* Option to display the parameters types */
 enum {
@@ -96,9 +100,11 @@ void start_ftrace_syscalls(void)
 	unsigned long flags;
 	struct task_struct *g, *t;
 
+	mutex_lock(&syscall_trace_lock);
+
 	/* Don't enable the flag on the tasks twice */
-	if (atomic_inc_return(&refcount) != 1)
-		return;
+	if (++refcount != 1)
+		goto unlock;
 
 	arch_init_ftrace_syscalls();
 	read_lock_irqsave(&tasklist_lock, flags);
@@ -108,6 +114,9 @@ void start_ftrace_syscalls(void)
 	} while_each_thread(g, t);
 
 	read_unlock_irqrestore(&tasklist_lock, flags);
+
+unlock:
+	mutex_unlock(&syscall_trace_lock);
 }
 
 void stop_ftrace_syscalls(void)
@@ -115,9 +124,11 @@ void stop_ftrace_syscalls(void)
 	unsigned long flags;
 	struct task_struct *g, *t;
 
+	mutex_lock(&syscall_trace_lock);
+
 	/* There are perhaps still some users */
-	if (atomic_dec_return(&refcount))
-		return;
+	if (--refcount)
+		goto unlock;
 
 	read_lock_irqsave(&tasklist_lock, flags);
 
@@ -126,6 +137,9 @@ void stop_ftrace_syscalls(void)
 	} while_each_thread(g, t);
 
 	read_unlock_irqrestore(&tasklist_lock, flags);
+
+unlock:
+	mutex_unlock(&syscall_trace_lock);
 }
 
 void ftrace_syscall_enter(struct pt_regs *regs)
