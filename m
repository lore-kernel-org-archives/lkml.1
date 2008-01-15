Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbYAOUva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbYAOUva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbYAOUue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:34 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:44070 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYAOUua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:30 -0500
Message-Id: <20080115205022.748615235@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 09/30 v3] mcount tracer show task comm and pid
Content-Disposition: inline; filename=mcount-tracer-add-pid-comm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the task comm and pid to the trace output. This gives the
output like:

CPU 0: sshd:2605 [<ffffffff80251858>] remove_wait_queue+0xc/0x4a <-- [<ffffffff802ad7be>] free_poll_entry+0x1e/0x2a
CPU 2: bash:2610 [<ffffffff8038c3aa>] tty_check_change+0x9/0xb6 <-- [<ffffffff8038d295>] tty_ioctl+0x59f/0xcdd
CPU 0: sshd:2605 [<ffffffff80491ec6>] _spin_lock_irqsave+0xe/0x81 <-- [<ffffffff80251863>] remove_wait_queue+0x17/0x4a
CPU 2: bash:2610 [<ffffffff8024e2f7>] find_vpid+0x9/0x24 <-- [<ffffffff8038d325>] tty_ioctl+0x62f/0xcdd
CPU 0: sshd:2605 [<ffffffff804923ec>] _spin_unlock_irqrestore+0x9/0x3a <-- [<ffffffff80251891>] remove_wait_queue+0x45/0x4a
CPU 0: sshd:2605 [<ffffffff802a18b3>] fput+0x9/0x1b <-- [<ffffffff802ad7c6>] free_poll_entry+0x26/0x2a


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/tracer.c |    6 +++++-
 lib/tracing/tracer.h |    3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-compile.git/lib/tracing/tracer.c
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.c	2008-01-14 13:14:13.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.c	2008-01-14 14:57:57.000000000 -0500
@@ -35,6 +35,7 @@ mctracer_add_trace_entry(struct mctracer
 {
 	unsigned long idx, idx_next;
 	struct mctracer_entry *entry;
+	struct task_struct *tsk = current;
 
 	idx = tr->trace_idx[cpu];
 	idx_next = idx + 1;
@@ -53,6 +54,8 @@ mctracer_add_trace_entry(struct mctracer
 	entry->idx	 = atomic_inc_return(&tr->cnt);
 	entry->ip	 = ip;
 	entry->parent_ip = parent_ip;
+	entry->pid	 = tsk->pid;
+	memcpy(entry->comm, tsk->comm, TASK_COMM_LEN);
 }
 
 static notrace void trace_function(const unsigned long ip,
@@ -227,7 +230,8 @@ static int s_show(struct seq_file *m, vo
 	if (iter->ent == NULL) {
 		seq_printf(m, "mctracer:\n");
 	} else {
-		seq_printf(m, "  CPU %d:  ", iter->cpu);
+		seq_printf(m, "CPU %d: ", iter->cpu);
+		seq_printf(m, "%s:%d ", iter->ent->comm, iter->ent->pid);
 		seq_print_ip_sym(m, iter->ent->ip);
 		if (iter->ent->parent_ip) {
 			seq_printf(m, " <-- ");
Index: linux-compile.git/lib/tracing/tracer.h
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.h	2008-01-14 13:14:13.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.h	2008-01-14 14:57:57.000000000 -0500
@@ -2,11 +2,14 @@
 #define _LINUX_MCOUNT_TRACER_H
 
 #include <asm/atomic.h>
+#include <linux/sched.h>
 
 struct mctracer_entry {
 	unsigned long idx;
 	unsigned long ip;
 	unsigned long parent_ip;
+	char comm[TASK_COMM_LEN];
+	pid_t pid;
 };
 
 struct mctracer_trace {

-- 
