Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZCPIUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZCPIUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZCPITu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:19:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:44668 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbZCPITs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:19:48 -0400
Date: Mon, 16 Mar 2009 08:18:41 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237151439-6755-1-git-send-email-fweisbec@gmail.com>
References: <1237151439-6755-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/syscalls] tracing/syscalls: fix missing release of tracing
Message-ID: <tip-ac99c58c9e56967037382e31f865b72b10127965@git.kernel.org>
Git-Commit-ID: ac99c58c9e56967037382e31f865b72b10127965
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 08:18:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac99c58c9e56967037382e31f865b72b10127965
Gitweb:     http://git.kernel.org/tip/ac99c58c9e56967037382e31f865b72b10127965
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 15 Mar 2009 22:10:35 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Mar 2009 09:13:15 +0100

tracing/syscalls: fix missing release of tracing

Impact: fix 'stuck' syscall tracer

The syscall tracer uses a refcounter to enable several users
simultaneously.

But the refcounter did not behave correctly and always restored
its value to 0 after calling start_syscall_tracing(). Therefore,
stop_syscall_tracing() couldn't release correctly the tasks from
tracing.

Also the tracer forgot to reset the buffer when it is released.

Drop the pointless refcount decrement on start_syscall_tracing()
and reset the buffer when we release the tracer.

This fixes two reported issue:

- when we switch from syscall tracer to another tracer, syscall
  tracing continued.

- incorrect use of the refcount.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237151439-6755-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_syscalls.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index c72e599..c5fc1d8 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -96,8 +96,9 @@ void start_ftrace_syscalls(void)
 	unsigned long flags;
 	struct task_struct *g, *t;
 
+	/* Don't enable the flag on the tasks twice */
 	if (atomic_inc_return(&refcount) != 1)
-		goto out;
+		return;
 
 	arch_init_ftrace_syscalls();
 	read_lock_irqsave(&tasklist_lock, flags);
@@ -107,8 +108,6 @@ void start_ftrace_syscalls(void)
 	} while_each_thread(g, t);
 
 	read_unlock_irqrestore(&tasklist_lock, flags);
-out:
-	atomic_dec(&refcount);
 }
 
 void stop_ftrace_syscalls(void)
@@ -116,8 +115,9 @@ void stop_ftrace_syscalls(void)
 	unsigned long flags;
 	struct task_struct *g, *t;
 
+	/* There are perhaps still some users */
 	if (atomic_dec_return(&refcount))
-		goto out;
+		return;
 
 	read_lock_irqsave(&tasklist_lock, flags);
 
@@ -126,8 +126,6 @@ void stop_ftrace_syscalls(void)
 	} while_each_thread(g, t);
 
 	read_unlock_irqrestore(&tasklist_lock, flags);
-out:
-	atomic_inc(&refcount);
 }
 
 void ftrace_syscall_enter(struct pt_regs *regs)
@@ -201,6 +199,7 @@ static int init_syscall_tracer(struct trace_array *tr)
 static void reset_syscall_tracer(struct trace_array *tr)
 {
 	stop_ftrace_syscalls();
+	tracing_reset_online_cpus(tr);
 }
 
 static struct trace_event syscall_enter_event = {
