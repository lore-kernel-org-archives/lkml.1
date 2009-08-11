Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbZHKStq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbZHKStq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932191AbZHKSto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:49:44 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:32762 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbZHKStl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X0GLOondVseSX4kvp5zwZevj4Kx3/eXV8NVJzpDfNbq0BkuFOYtvtdcBlbr9TVD+aV
         gjwClxaFcw5o/l3gqGaSmqrSJ/EBw1gxJwJhyxKwUs6PmRocCTlLWIQ7UPioIbHpR2sT
         0atK1Rlidax5LYfo19ChIrrrCv0ZlSdkUUAmc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 16/16] tracing: Support for syscall events raw records in perfcounters
Date: Tue, 11 Aug 2009 20:49:05 +0200
Message-Id: <1250016545-6601-17-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bring the support for raw syscall events in perfcounters.
The arguments or exit value are saved as a raw sample using
the PERF_SAMPLE_RAW attribute in a perf counter.

Example (for now you must explicitly set the PERF_SAMPLE_RAW flag
in perf record):

perf record -e syscalls:sys_enter_open -f -F 1 -a
perf report -D

	0x2cbb8 [0x50]: event: 9
	.
	. ... raw event: size 80 bytes
	.  0000:  09 00 00 00 02 00 50 00 20 e9 39 ab 0a 7f 00 00  ......P. .9....
	.  0010:  bc 14 00 00 bc 14 00 00 01 00 00 00 00 00 00 00  ...............
	.  0020:  2c 00 00 00 15 01 01 00 bc 14 00 00 bc 14 00 00  ,..............
                  ^  ^  ^  ^  ^  ^  ^  ..........................
                  Event Size  struct trace_entry

	.  0030:  00 00 00 00 46 98 43 02 00 00 00 00 80 08 00 00  ....F.C........
                  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^
                  ptr to file name        open flags

	.  0040:  00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ...............
                  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^  ^
	.         open mode               padding

	0x2cbb8 [0x50]: PERF_EVENT_SAMPLE (IP, 2): 5308: 0x7f0aab39e920 period: 1

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
---
 kernel/trace/trace_syscalls.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 9ee6386..f837ccc 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -301,6 +301,17 @@ struct trace_event event_syscall_exit = {
 };
 
 #ifdef CONFIG_EVENT_PROFILE
+
+struct syscall_enter_record {
+	struct trace_entry	entry;
+	unsigned long		args[0];
+};
+
+struct syscall_exit_record {
+	struct trace_entry	entry;
+	unsigned long		ret;
+};
+
 static DECLARE_BITMAP(enabled_prof_enter_syscalls, FTRACE_SYSCALL_MAX);
 static DECLARE_BITMAP(enabled_prof_exit_syscalls, FTRACE_SYSCALL_MAX);
 static int sys_prof_refcount_enter;
@@ -308,8 +319,10 @@ static int sys_prof_refcount_exit;
 
 static void prof_syscall_enter(struct pt_regs *regs, long id)
 {
+	struct syscall_enter_record *rec;
 	struct syscall_metadata *sys_data;
 	int syscall_nr;
+	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
 	if (!test_bit(syscall_nr, enabled_prof_enter_syscalls))
@@ -319,7 +332,24 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	if (!sys_data)
 		return;
 
-	perf_tpcounter_event(sys_data->enter_id, 0, 1, NULL, 0);
+	/* get the size after alignment with the u32 buffer size field */
+	size = sizeof(unsigned long) * sys_data->nb_args + sizeof(*rec);
+	size = ALIGN(size + sizeof(u32), sizeof(u64));
+	size -= sizeof(u32);
+
+	do {
+		char raw_data[size];
+
+		/* zero the dead bytes from align to not leak stack to user */
+		*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
+
+		rec = (struct syscall_enter_record *) raw_data;
+		tracing_generic_entry_update(&rec->entry, 0, 0);
+		rec->entry.type = sys_data->enter_id;
+		syscall_get_arguments(current, regs, 0, sys_data->nb_args,
+				       (unsigned long *)&rec->args);
+		perf_tpcounter_event(sys_data->enter_id, 0, 1, rec, size);
+	} while(0);
 }
 
 int reg_prof_syscall_enter(char *name)
@@ -364,6 +394,7 @@ void unreg_prof_syscall_enter(char *name)
 static void prof_syscall_exit(struct pt_regs *regs, long ret)
 {
 	struct syscall_metadata *sys_data;
+	struct syscall_exit_record rec;
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
@@ -374,7 +405,11 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
-	perf_tpcounter_event(sys_data->exit_id, 0, 1, NULL, 0);
+	tracing_generic_entry_update(&rec.entry, 0, 0);
+	rec.entry.type = sys_data->exit_id;
+	rec.ret = syscall_get_return_value(current, regs);
+
+	perf_tpcounter_event(sys_data->exit_id, 0, 1, &rec, sizeof(rec));
 }
 
 int reg_prof_syscall_exit(char *name)
-- 
1.6.2.3

