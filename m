Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYHNWFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYHNWFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYHNWFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:05:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYHNWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:05:09 -0400
Date: Thu, 14 Aug 2008 18:05:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com
Subject: [PATCH] ftrace: use only 5 byte nops for x86
Message-ID: <alpine.DEB.1.10.0808141755030.2911@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mathieu Desnoyers revealed a bug in the original code. The nop that is
used to relpace the mcount caller can be a two part nop. This runs the
risk where a process can be preempted after executing the first nop, but
before the second part of the nop.

The ftrace code calls kstop_machine to keep multiple CPUs from executing
code that is being modified, but it does not protect against a task preempting
in the middle of a two part nop.

If the above preemption happens and the tracer is enabled, after the
kstop_machine runs, all those nops will be calls to the trace function.
If the preempted process that was preempted between the two nops is executed
again, it will execute half of the call to the trace function, and this
might crash the system.

This patch instead uses what both the latest Intel and AMD spec suggests.
That is the P6_NOP5 sequence of "0x0f 0x1f 0x44 0x00 0x00".
Note, some older CPUs and QEMU might fault on this nop, so this nop
is executed with fault handling first. If it detects a fault, it will then
use the code "0x66 0x66 0x66 0x66 0x90". If that faults, it will then
default to a simple "jmp 1f; .byte 0x00 0x00 0x00; 1:". The jmp is
not optimal but will do if the first two can not be executed.

TODO: Examine the cpuid to determine the nop to use.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |   66 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 6 deletions(-)

Index: linux-tip.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/ftrace.c	2008-08-14 15:24:01.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/ftrace.c	2008-08-14 17:37:55.000000000 -0400
@@ -16,8 +16,8 @@
 #include <linux/init.h>
 #include <linux/list.h>
 
-#include <asm/alternative.h>
 #include <asm/ftrace.h>
+#include <asm/nops.h>
 
 
 /* Long is fine, even if it is only 4 bytes ;-) */
@@ -119,13 +119,67 @@ notrace int ftrace_mcount_set(unsigned l
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	const unsigned char *const *noptable = find_nop_table();
-
-	/* This is running in kstop_machine */
+	extern const unsigned char ftrace_test_p6nop[];
+	extern const unsigned char ftrace_test_nop5[];
+	extern const unsigned char ftrace_test_jmp[];
+	int faulted = 0;
 
-	ftrace_mcount_set(data);
+	/*
+	 * There is no good nop for all x86 archs.
+	 * We will default to using the P6_NOP5, but first we
+	 * will test to make sure that the nop will actually
+	 * work on this CPU. If it faults, we will then
+	 * go to a lesser efficient 5 byte nop. If that fails
+	 * we then just use a jmp as our nop. This isn't the most
+	 * efficient nop, but we can not use a multi part nop
+	 * since we would then risk being preempted in the middle
+	 * of that nop, and if we enabled tracing then, it might
+	 * cause a system crash.
+	 *
+	 * TODO: check the cpuid to determine the best nop.
+	 */
+	asm volatile (
+		"jmp ftrace_test_jmp\n"
+		/* This code needs to stay around */
+		".section .text, \"ax\"\n"
+		"ftrace_test_jmp:"
+		"jmp ftrace_test_p6nop\n"
+		".byte 0x00,0x00,0x00\n"  /* 2 byte jmp + 3 bytes */
+		"ftrace_test_p6nop:"
+		P6_NOP5
+		"jmp 1f\n"
+		"ftrace_test_nop5:"
+		".byte 0x66,0x66,0x66,0x66,0x90\n"
+		"jmp 1f\n"
+		".previous\n"
+		"1:"
+		".section .fixup, \"ax\"\n"
+		"2:	movl $1, %0\n"
+		"	jmp ftrace_test_nop5\n"
+		"3:	movl $2, %0\n"
+		"	jmp 1b\n"
+		".previous\n"
+		_ASM_EXTABLE(ftrace_test_p6nop, 2b)
+		_ASM_EXTABLE(ftrace_test_nop5, 3b)
+		: "=r"(faulted) : "0" (faulted));
+
+	switch (faulted) {
+	case 0:
+		pr_info("ftrace: converting mcount calls to 0f 1f 44 00 00\n");
+		ftrace_nop = (unsigned long *)ftrace_test_p6nop;
+		break;
+	case 1:
+		pr_info("ftrace: converting mcount calls to 66 66 66 66 90\n");
+		ftrace_nop = (unsigned long *)ftrace_test_nop5;
+		break;
+	case 2:
+		pr_info("ftrace: converting mcount calls to jmp 1f\n");
+		ftrace_nop = (unsigned long *)ftrace_test_jmp;
+		break;
+	}
 
-	ftrace_nop = (unsigned long *)noptable[MCOUNT_INSN_SIZE];
+	/* The return code is retured via data */
+	*(unsigned long *)data = 0;
 
 	return 0;
 }

