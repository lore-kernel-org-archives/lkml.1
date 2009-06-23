Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZFWSal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZFWSal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbZFWSaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:30:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37993 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbZFWSaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:30:22 -0400
Date: Tue, 23 Jun 2009 14:29:00 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com, lizf@cn.fujitsu.com
Message-Id: <da41dae6a808be0814e807eb8753ca26d9e54d13.1245770664.git.jbaron@redhat.com>
In-Reply-To: <cover.1245770664.git.jbaron@redhat.com>
References: <cover.1245770664.git.jbaron@redhat.com>
Subject: [PATCH 2/7] V2 add syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Call arch_init_ftrace_syscalls at boot, so we can determine the set of syscalls
for the syscall trace events.


Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 arch/x86/kernel/ftrace.c      |   15 ++++-----------
 include/trace/syscall.h       |    1 -
 kernel/trace/trace_syscalls.c |    1 -
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index b2374db..f877ae4 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -518,31 +518,24 @@ int syscall_name_to_nr(char *name)
 	return -1;
 }
 
-void arch_init_ftrace_syscalls(void)
+static int __init arch_init_ftrace_syscalls(void)
 {
 	int i;
 	struct syscall_metadata *meta;
 	unsigned long **psys_syscall_table = &sys_call_table;
-	static atomic_t refs;
-
-	if (atomic_inc_return(&refs) != 1)
-		goto end;
 
 	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
 					FTRACE_SYSCALL_MAX, GFP_KERNEL);
 	if (!syscalls_metadata) {
 		WARN_ON(1);
-		return;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
 		meta = find_syscall_meta(psys_syscall_table[i]);
 		syscalls_metadata[i] = meta;
 	}
-	return;
-
-	/* Paranoid: avoid overflow */
-end:
-	atomic_dec(&refs);
+	return 0;
 }
+arch_initcall(arch_init_ftrace_syscalls);
 #endif
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 8cfe515..c55fcce 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -19,7 +19,6 @@ struct syscall_metadata {
 };
 
 #ifdef CONFIG_FTRACE_SYSCALLS
-extern void arch_init_ftrace_syscalls(void);
 extern struct syscall_metadata *syscall_nr_to_meta(int nr);
 extern void start_ftrace_syscalls(void);
 extern void stop_ftrace_syscalls(void);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5e57964..08aed43 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -106,7 +106,6 @@ void start_ftrace_syscalls(void)
 	if (++refcount != 1)
 		goto unlock;
 
-	arch_init_ftrace_syscalls();
 	read_lock_irqsave(&tasklist_lock, flags);
 
 	do_each_thread(g, t) {
-- 
1.6.0.6

