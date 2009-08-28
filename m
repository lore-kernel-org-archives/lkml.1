Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbZH1M2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbZH1M2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZH1M2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:28:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:55436 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbZH1M2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:28:45 -0400
Date: Fri, 28 Aug 2009 12:27:39 GMT
From: tip-bot for Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: mathieu.desnoyers@polymtl.ca, brueckner@linux.vnet.ibm.com,
       mingo@redhat.com, schwidefsky@de.ibm.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, hpa@zytor.com,
       jiayingz@google.com, linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       lethal@linux-sh.org, mingo@elte.hu, mbligh@google.com
Reply-To: mingo@redhat.com, brueckner@linux.vnet.ibm.com,
       mathieu.desnoyers@polymtl.ca, peterz@infradead.org,
       schwidefsky@de.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, laijs@cn.fujitsu.com,
       hpa@zytor.com, jiayingz@google.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, lethal@linux-sh.org, mingo@elte.hu,
       mbligh@google.com
In-Reply-To: <20090825123111.GD4639@cetus.boeblingen.de.ibm.com>
References: <20090825123111.GD4639@cetus.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Add syscall tracepoints - s390 arch update
Message-ID: <tip-7515bf59f87f19b2a17972b74230d2f91756fe3c@git.kernel.org>
Git-Commit-ID: 7515bf59f87f19b2a17972b74230d2f91756fe3c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 12:27:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7515bf59f87f19b2a17972b74230d2f91756fe3c
Gitweb:     http://git.kernel.org/tip/7515bf59f87f19b2a17972b74230d2f91756fe3c
Author:     Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
AuthorDate: Tue, 25 Aug 2009 14:31:11 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 26 Aug 2009 21:29:44 +0200

tracing: Add syscall tracepoints - s390 arch update

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
