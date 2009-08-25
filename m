Return-Path: <linux-kernel-owner+w=401wt.eu-S1751267AbZHYMuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbZHYMuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 08:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbZHYMuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 08:50:18 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:44420 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZHYMuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 08:50:17 -0400
Date: Tue, 25 Aug 2009 14:50:27 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090825125027.GE4639@cetus.boeblingen.de.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
	fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
	rostedt@goodmis.org, peterz@infradead.org,
	mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
	mbligh@google.com, lizf@cn.fujitsu.com,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <cover.1249932670.git.jbaron@redhat.com> <aa785a0431b72327d288ef9b921e824d7f494de2.1249932670.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa785a0431b72327d288ef9b921e824d7f494de2.1249932670.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 04:52:47PM -0400, Jason Baron wrote:
> +void ftrace_syscall_enter(struct pt_regs *regs, long id)
>  {
>  	struct syscall_trace_enter *entry;
>  	struct syscall_metadata *sys_data;
> @@ -150,6 +105,8 @@ void ftrace_syscall_enter(struct pt_regs *regs)
>  	int syscall_nr;
> 
>  	syscall_nr = syscall_get_nr(current, regs);
> +	if (!test_bit(syscall_nr, enabled_enter_syscalls))
> +		return;
> 
>  	sys_data = syscall_nr_to_meta(syscall_nr);
>  	if (!sys_data)

> +void ftrace_syscall_exit(struct pt_regs *regs, long ret)
>  {
>  	struct syscall_trace_exit *entry;
>  	struct syscall_metadata *sys_data;
> @@ -178,6 +135,8 @@ void ftrace_syscall_exit(struct pt_regs *regs)
>  	int syscall_nr;
> 
>  	syscall_nr = syscall_get_nr(current, regs);
> +	if (!test_bit(syscall_nr, enabled_exit_syscalls))
> +		return;
Most arch syscall_get_nr() implementations returns -1 if the syscall
number is not valid.  Accessing the bit field without a check might
result in a kernel oops (at least I saw it on s390 for ftrace selftest).

Before this change, this problem did not occur, because the invalid
syscall number (-1) caused syscall_nr_to_meta() to return NULL.

There are at least two scenarios where syscall_get_nr() can return -1:

1. For example, ptrace stores an invalid syscall number, and thus,
   tracing code resets it.
   (see do_syscall_trace_enter in arch/s390/kernel/ptrace.c)

2. The syscall_regfunc() (kernel/tracepoint.c) sets the TIF_SYSCALL_FTRACE
   (now: TIF_SYSCALL_TRACEPOINT) flag for all threads which includes
   kernel threads.
   However, the ftrace selftest triggers a kernel oops when testing syscall
   trace points:
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
---
 kernel/trace/trace_syscalls.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -224,6 +224,8 @@ void ftrace_syscall_enter(struct pt_regs
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_enter_syscalls))
 		return;
 
@@ -254,6 +256,8 @@ void ftrace_syscall_exit(struct pt_regs 
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_exit_syscalls))
 		return;
 
