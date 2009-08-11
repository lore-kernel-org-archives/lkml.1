Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbZHKStR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbZHKStR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZHKStP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:49:15 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:48086 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbZHKStM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qPf11YMx7lREWg0SdCT1ht15ZIzYwMHPfRclLHsND1VR7m8rs3UdTbnybqg+cDpFFj
         6Q5WcvIvjfWhvvfl+5cCb6LeyKupvRCMsVS3T7EbafEgZD5bR6xIYKpZerFbjoDYi+nM
         MoJTk8XfIgEVfWcyFRsF465NwlZCeIsde/e9Q=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/16] tracing: Call arch_init_ftrace_syscalls at boot
Date: Tue, 11 Aug 2009 20:48:52 +0200
Message-Id: <1250016545-6601-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Call arch_init_ftrace_syscalls at boot, so we can determine early the
set of syscalls for the syscall trace events.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ftrace.c      |   15 ++++-----------
 include/trace/syscall.h       |    1 -
 kernel/trace/trace_syscalls.c |    1 -
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index afb31d7..0d93d40 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -516,31 +516,24 @@ int syscall_name_to_nr(char *name)
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
1.6.2.3

