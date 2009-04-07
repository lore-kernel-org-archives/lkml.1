Return-Path: <linux-kernel-owner+w=401wt.eu-S1757765AbZDGNQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbZDGNQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZDGNOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:14:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:59418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbZDGNOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:14:11 -0400
Date: Tue, 7 Apr 2009 13:13:28 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1238619188-6109-1-git-send-email-fweisbec@gmail.com>
References: <1238619188-6109-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/urgent] tracing/ftrace: alloc the started cpumask for the trace file
Message-ID: <tip-b0dfa978c7a1699fb3506fbfcba0b6a5c4bd17ae@git.kernel.org>
Git-Commit-ID: b0dfa978c7a1699fb3506fbfcba0b6a5c4bd17ae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 13:13:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0dfa978c7a1699fb3506fbfcba0b6a5c4bd17ae
Gitweb:     http://git.kernel.org/tip/b0dfa978c7a1699fb3506fbfcba0b6a5c4bd17ae
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 1 Apr 2009 22:53:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 14:02:03 +0200

tracing/ftrace: alloc the started cpumask for the trace file

Impact: fix a crash while cat trace file

Currently we are using a cpumask to remind each cpu where a
trace occured. It lets us notice the user that a cpu just had
its first trace.

But on latest -tip we have the following crash once we cat the trace
file:

IP: [<c0270c4a>] print_trace_fmt+0x45/0xe7
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/class/net/eth0/carrier
Pid: 3897, comm: cat Not tainted (2.6.29-tip-02825-g0f22972-dirty #81)
EIP: 0060:[<c0270c4a>] EFLAGS: 00010297 CPU: 0
EIP is at print_trace_fmt+0x45/0xe7
EAX: 00000000 EBX: 00000000 ECX: c12d9e98 EDX: ccdb7010
ESI: d31f4000 EDI: 00322401 EBP: d31f3f10 ESP: d31f3efc
DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process cat (pid: 3897, ti=d31f2000 task=d3b3cf20 task.ti=d31f2000)
Stack:
d31f4080 ccdb7010 d31f4000 d691fe70 ccdb7010 d31f3f24 c0270e5c d31f4000
d691fe70 d31f4000 d31f3f34 c02718e8 c12d9e98 d691fe70 d31f3f70 c02bfc33
00001000 09130000 d3b46e00 d691fe98 00000000 00000079 00000001 00000000
Call Trace:
[<c0270e5c>] ? print_trace_line+0x170/0x17c
[<c02718e8>] ? s_show+0xa7/0xbd
[<c02bfc33>] ? seq_read+0x24a/0x327
[<c02bf9e9>] ? seq_read+0x0/0x327
[<c02ab18b>] ? vfs_read+0x86/0xe1
[<c02ab289>] ? sys_read+0x40/0x65
[<c0202d8f>] ? sysenter_do_call+0x12/0x3c
Code: 00 00 00 89 45 ec f7 c7 00 20 00 00 89 55 f0 74 4e f6 86 98 10 00 00 02 74 45 8b 86 8c 10 00 00 8b 9e a8 10 00 00 e8 52 f3 ff ff <0f> a3 03 19 c0 85 c0 75 2b 8b 86 8c 10 00 00 8b 9e a8 10 00 00
EIP: [<c0270c4a>] print_trace_fmt+0x45/0xe7 SS:ESP 0068:d31f3efc
CR2: 0000000000000000
---[ end trace aa9cf38e5ebed9dd ]---

This is because we alloc the iter->started cpumask on tracing_pipe_open but
not on tracing_open.

It hadn't been noticed until now because we need to have ring buffer overruns
to activate the starting of cpu buffer detection.

Also, we need a check to not print the messagge for the first trace on the file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1238619188-6109-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2230b46..fc8c7d6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1632,7 +1632,11 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 		return;
 
 	cpumask_set_cpu(iter->cpu, iter->started);
-	trace_seq_printf(s, "##### CPU %u buffer started ####\n", iter->cpu);
+
+	/* Don't print started cpu buffer for the first entry of the trace */
+	if (iter->idx > 1)
+		trace_seq_printf(s, "##### CPU %u buffer started ####\n",
+				iter->cpu);
 }
 
 static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
@@ -1867,6 +1871,11 @@ __tracing_open(struct inode *inode, struct file *file)
 	if (current_trace)
 		*iter->trace = *current_trace;
 
+	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL))
+		goto fail;
+
+	cpumask_clear(iter->started);
+
 	if (current_trace && current_trace->print_max)
 		iter->tr = &max_tr;
 	else
@@ -1917,6 +1926,7 @@ __tracing_open(struct inode *inode, struct file *file)
 		if (iter->buffer_iter[cpu])
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
 	}
+	free_cpumask_var(iter->started);
  fail:
 	mutex_unlock(&trace_types_lock);
 	kfree(iter->trace);
@@ -1960,6 +1970,7 @@ static int tracing_release(struct inode *inode, struct file *file)
 
 	seq_release(inode, file);
 	mutex_destroy(&iter->mutex);
+	free_cpumask_var(iter->started);
 	kfree(iter->trace);
 	kfree(iter);
 	return 0;
