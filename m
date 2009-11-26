Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbZKZIQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbZKZIQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759487AbZKZIQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:16:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:35468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759480AbZKZIQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:16:20 -0500
Date: Thu, 26 Nov 2009 08:15:52 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: dumpstack: Clean up the x86_stack_ids[][] initalization and other details
Message-ID: <tip-b803090615ccec669681ff85ce28671e7bfefa3d@git.kernel.org>
Git-Commit-ID: b803090615ccec669681ff85ce28671e7bfefa3d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b803090615ccec669681ff85ce28671e7bfefa3d
Gitweb:     http://git.kernel.org/tip/b803090615ccec669681ff85ce28671e7bfefa3d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 26 Nov 2009 08:17:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 08:24:33 +0100

x86: dumpstack: Clean up the x86_stack_ids[][] initalization and other details

Make the initialization more readable, plus tidy up a few small
visual details as well.

No change in functionality.

LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/dumpstack_32.c |    9 ++++-----
 arch/x86/kernel/dumpstack_64.c |   25 +++++++++++++------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index f7dd2a7..e0ed4c7 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -10,9 +10,9 @@
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/kexec.h>
+#include <linux/sysfs.h>
 #include <linux/bug.h>
 #include <linux/nmi.h>
-#include <linux/sysfs.h>
 
 #include <asm/stacktrace.h>
 
@@ -35,6 +35,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 	if (!stack) {
 		unsigned long dummy;
+
 		stack = &dummy;
 		if (task && task != current)
 			stack = (unsigned long *)task->thread.sp;
@@ -57,8 +58,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 		context = (struct thread_info *)
 			((unsigned long)stack & (~(THREAD_SIZE - 1)));
-		bp = print_context_stack(context, stack, bp, ops,
-					 data, NULL, &graph);
+		bp = print_context_stack(context, stack, bp, ops, data, NULL, &graph);
 
 		stack = (unsigned long *)context->previous_esp;
 		if (!stack)
@@ -72,7 +72,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *sp, unsigned long bp, char *log_lvl)
+		   unsigned long *sp, unsigned long bp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -156,4 +156,3 @@ int is_valid_bugaddr(unsigned long ip)
 
 	return ud2 == 0x0b0f;
 }
-
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index a071e6b..cfec478 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -10,26 +10,28 @@
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/kexec.h>
+#include <linux/sysfs.h>
 #include <linux/bug.h>
 #include <linux/nmi.h>
-#include <linux/sysfs.h>
 
 #include <asm/stacktrace.h>
 
 #include "dumpstack.h"
 
+#define N_EXCEPTION_STACKS_END \
+		(N_EXCEPTION_STACKS + DEBUG_STKSZ/EXCEPTION_STKSZ - 2)
 
 static char x86_stack_ids[][8] = {
-		[DEBUG_STACK - 1] = "#DB",
-		[NMI_STACK - 1] = "NMI",
-		[DOUBLEFAULT_STACK - 1] = "#DF",
-		[STACKFAULT_STACK - 1] = "#SS",
-		[MCE_STACK - 1] = "#MC",
+		[ DEBUG_STACK-1			]	= "#DB",
+		[ NMI_STACK-1			]	= "NMI",
+		[ DOUBLEFAULT_STACK-1		]	= "#DF",
+		[ STACKFAULT_STACK-1		]	= "#SS",
+		[ MCE_STACK-1			]	= "#MC",
 #if DEBUG_STKSZ > EXCEPTION_STKSZ
-		[N_EXCEPTION_STACKS ...
-			N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"
+		[ N_EXCEPTION_STACKS ...
+		  N_EXCEPTION_STACKS_END	]	= "#DB[?]"
 #endif
-	};
+};
 
 int x86_is_stack_id(int id, char *name)
 {
@@ -37,7 +39,7 @@ int x86_is_stack_id(int id, char *name)
 }
 
 static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
-					unsigned *usedp, char **idp)
+					 unsigned *usedp, char **idp)
 {
 	unsigned k;
 
@@ -202,7 +204,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *sp, unsigned long bp, char *log_lvl)
+		   unsigned long *sp, unsigned long bp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -303,4 +305,3 @@ int is_valid_bugaddr(unsigned long ip)
 
 	return ud2 == 0x0b0f;
 }
-
