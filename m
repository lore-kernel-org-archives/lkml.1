Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbZH0Ro5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbZH0Ro5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZH0Roy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:44:54 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:25378 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZH0Rnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iz/g5k5K29ay7AyKlq2LhbXR3Ltb1wdmJSv8FQYxDs6oeCFm9d3Btiqd/J0N0ZLiiz
         LWOezho0pNTT0Zt8a3NkP2fcJLoBrp5aMnbGdaPTyKwVgzqGzvgasaiPUdRTsnAhij0E
         eg0mnqGiSEad7UsQ/X4Kidp/BW36fmIpOYW5k=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 1/7] tracing: Add syscall tracepoints - s390 arch update
Date: Thu, 27 Aug 2009 19:43:29 +0200
Message-Id: <1251395015-6329-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
References: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

This patch includes s390 arch updates to synchronize with latest
core changes in the syscalls tracing area.

- tracing: Map syscall name to number (syscall_name_to_nr())
- tracing: Call arch_init_ftrace_syscalls at boot
- tracing: add support tracepoint ids (set_syscall_{enter,exit}_id())

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
LKML-Reference: <20090825123111.GD4639@cetus.boeblingen.de.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/s390/kernel/ftrace.c |   36 +++++++++++++++++++++++++++---------
 1 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 3e298e6..57bdcb1 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -220,6 +220,29 @@ struct syscall_metadata *syscall_nr_to_meta(int nr)
 	return syscalls_metadata[nr];
 }
 
+int syscall_name_to_nr(char *name)
+{
+	int i;
+
+	if (!syscalls_metadata)
+		return -1;
+	for (i = 0; i < NR_syscalls; i++)
+		if (syscalls_metadata[i])
+			if (!strcmp(syscalls_metadata[i]->name, name))
+				return i;
+	return -1;
+}
+
+void set_syscall_enter_id(int num, int id)
+{
+	syscalls_metadata[num]->enter_id = id;
+}
+
+void set_syscall_exit_id(int num, int id)
+{
+	syscalls_metadata[num]->exit_id = id;
+}
+
 static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 {
 	struct syscall_metadata *start;
@@ -237,24 +260,19 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 	return NULL;
 }
 
-void arch_init_ftrace_syscalls(void)
+static int __init arch_init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;
 	int i;
-	static atomic_t refs;
-
-	if (atomic_inc_return(&refs) != 1)
-		goto out;
 	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) * NR_syscalls,
 				    GFP_KERNEL);
 	if (!syscalls_metadata)
-		goto out;
+		return -ENOMEM;
 	for (i = 0; i < NR_syscalls; i++) {
 		meta = find_syscall_meta((unsigned long)sys_call_table[i]);
 		syscalls_metadata[i] = meta;
 	}
-	return;
-out:
-	atomic_dec(&refs);
+	return 0;
 }
+arch_initcall(arch_init_ftrace_syscalls);
 #endif
-- 
1.6.2.3

