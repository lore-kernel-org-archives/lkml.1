Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbZEKWUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbZEKWUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZEKWUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:20:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52416 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbZEKWUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:20:00 -0400
Date: Mon, 11 May 2009 18:16:59 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Message-ID: <20090511221659.GA3223@redhat.com>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509083737.GE3656@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 10:37:37AM +0200, Ingo Molnar wrote:
> I'm not sure about the implementation as you've posted it though:
> 
> Firstly, it adds two new tracepoints to every system call. That is 
> unnecessary - we already have the TIF flag based callbacks, and we 
> can use the existing syscall attributes table to get to tracepoints 
> - without slow down (or impacting) the fast path in any way.
> 
> Secondly, we should reuse the information we get in SYSCALL_DEFINE, 
> to construct the TRACE_EVENT tracepoints directly - without having 
> to list all syscalls again in a separate file.
> 
> 	Ingo

ok, i've been playing around with this a bit...by adding a few macros to
include/trace/syscalls.h (conceptually in addition to the previous patch i
posted), I can address #1. For example, for getpid() I did:

+#define MAX_SYS_ARGS 10
+
+#define create_syscall_case_args0(sysnr, regs, sysname) \
+	case sysnr:					\
+		trace_sysenter_##sysname();		\
+		break;					
+
+#define create_syscall_case_args1(sysnr, regs, sysname) \
+	case sysnr:					\
+		syscall_get_arguments(current, regs, 0, 1, sys_args); \
+		trace_sysenter_#sysname((meta->types[0])sys_args[0]); \
+		break;
+
+#define define_syscall_tracepoints()				\
+	DEFINE_TRACE(sysenter_getpid);
+
+#define wrapper_syscall_tracepoints_enter(regs) 		\
+do {								\
+	int syscall_nr;						\
+	long sys_args[MAX_SYS_ARGS];				\
+	struct syscall_metadata *meta;				\
+								\
+	syscall_nr = syscall_get_nr(current, regs);		\
+	meta = syscall_nr_to_meta(syscall_nr);			\
+	switch (syscall_nr) {					\
+		create_syscall_case_args0(__NR_getpid, regs, getpid);\
+	}							\
+} while (0)


This should extend to the rest of the syscalls.

Then, in arch/x86/kernel/ptrace.c, i just add:

 	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_enter(regs);
+		wrapper_syscall_tracepoints_enter(regs);


Regarding issue #2, the '__SYSCALL_DEFINEx()' macros are expanding in
the context of the various .c source files that define the system calls.
Thus, I'm not sure how we are going to reference them in
arch/x86/kernel/ptrace.c. Also, by not defining the tracepoints in a .h
file, modules and other code that want to make use of these tracepoints
are going to have a harder time. Further, there has been mention in this
thread of exceptions that some of the syscalls are going to create. I
think it would be easier to follow the exceptions if they are contained
in 1 file, rather than scattered around the code.

thanks,

-Jason




