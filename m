Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZH1M25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZH1M25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZH1M2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:28:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:55448 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbZH1M2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:28:49 -0400
Date: Fri, 28 Aug 2009 12:27:53 GMT
From: tip-bot for Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: mathieu.desnoyers@polymtl.ca, brueckner@linux.vnet.ibm.com,
       mingo@redhat.com, schwidefsky@de.ibm.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, jbaron@redhat.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jiayingz@google.com,
       lizf@cn.fujitsu.com, lethal@linux-sh.org, mingo@elte.hu,
       mbligh@google.com
Reply-To: mingo@redhat.com, brueckner@linux.vnet.ibm.com,
       mathieu.desnoyers@polymtl.ca, peterz@infradead.org,
       schwidefsky@de.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, jbaron@redhat.com,
       laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       jiayingz@google.com, lizf@cn.fujitsu.com, lethal@linux-sh.org,
       mingo@elte.hu, mbligh@google.com
In-Reply-To: <20090825125027.GE4639@cetus.boeblingen.de.ibm.com>
References: <20090825125027.GE4639@cetus.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Check invalid syscall nr while tracing syscalls
Message-ID: <tip-cd0980fc8add25e8ab12fcf1051c0f20cbc7c0c0@git.kernel.org>
Git-Commit-ID: cd0980fc8add25e8ab12fcf1051c0f20cbc7c0c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 12:27:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd0980fc8add25e8ab12fcf1051c0f20cbc7c0c0
Gitweb:     http://git.kernel.org/tip/cd0980fc8add25e8ab12fcf1051c0f20cbc7c0c0
Author:     Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
AuthorDate: Tue, 25 Aug 2009 14:50:27 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 26 Aug 2009 21:29:48 +0200

tracing: Check invalid syscall nr while tracing syscalls

Most arch syscall_get_nr() implementations returns -1 if the syscall
number is not valid.  Accessing the bit field without a check might
result in a kernel oops (at least I saw it on s390 for ftrace selftest).

Before this change, this problem did not occur, because the invalid
syscall number (-1) caused syscall_nr_to_meta() to return NULL.

There are at least two scenarios where syscall_get_nr() can return -1:

1. For example, ptrace stores an invalid syscall number, and thus,
   tracing code resets it.
   (see do_syscall_trace_enter in arch/s390/kernel/ptrace.c)

2. The syscall_regfunc() (kernel/tracepoint.c) sets the
   TIF_SYSCALL_FTRACE (now: TIF_SYSCALL_TRACEPOINT) flag for all threads
   which include kernel threads.
   However, the ftrace selftest triggers a kernel oops when testing
   syscall trace points:
      - The kernel thread is started as ususal (do_fork()),
      - tracing code sets TIF_SYSCALL_FTRACE,
      - the ret_from_fork() function is triggered and starts
	ftrace_syscall_exit() with an invalid syscall number.

To avoid these scenarios, I suggest to check the syscall_nr.

For instance, the ftrace selftest fails for s390 (with config option
CONFIG_FTRACE_SYSCALLS set) and produces the following kernel oops.

Unable to handle kernel pointer dereference at virtual kernel address 2000000000

Oops: 0038 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 Not tainted 2.6.31-rc6-next-20090819-dirty #18
Process kthreadd (pid: 818, task: 000000003ea207e8, ksp: 000000003e813eb8)
Krnl PSW : 0704100180000000 00000000000ea54c (ftrace_syscall_exit+0x58/0xdc)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
Krnl GPRS: 0000000000000000 00000000000e0000 ffffffffffffffff 20000000008c2650
           0000000000000007 0000000000000000 0000000000000000 0000000000000000
           0000000000000000 0000000000000000 ffffffffffffffff 000000003e813d78
           000000003e813f58 0000000000505ba8 000000003e813e18 000000003e813d78
Krnl Code: 00000000000ea540: e330d0000008       ag      %r3,0(%r13)
           00000000000ea546: a7480007           lhi     %r4,7
           00000000000ea54a: 1442               nr      %r4,%r2
          >00000000000ea54c: e31030000090       llgc    %r1,0(%r3)
           00000000000ea552: 5410d008           n       %r1,8(%r13)
           00000000000ea556: 8a104000           sra     %r1,0(%r4)
           00000000000ea55a: 5410d00c           n       %r1,12(%r13)
           00000000000ea55e: 1211               ltr     %r1,%r1
Call Trace:
([<0000000000000000>] 0x0)
 [<000000000001fa22>] do_syscall_trace_exit+0x132/0x18c
 [<000000000002d0c4>] sysc_return+0x0/0x8
 [<000000000001c738>] kernel_thread_starter+0x0/0xc
Last Breaking-Event-Address:
 [<00000000000ea51e>] ftrace_syscall_exit+0x2a/0xdc

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
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
LKML-Reference: <20090825125027.GE4639@cetus.boeblingen.de.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 kernel/trace/trace_syscalls.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 85291c4..cb7f600 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -227,6 +227,8 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_enter_syscalls))
 		return;
 
@@ -257,6 +259,8 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_exit_syscalls))
 		return;
 
