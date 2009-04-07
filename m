Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZDGKtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZDGKtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZDGKs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:48:56 -0400
Received: from mx1.emlix.com ([193.175.82.87]:40870 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbZDGKs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:48:56 -0400
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] xtensa: always use correct stack pointer for stack traces
Date: Tue,  7 Apr 2009 12:50:27 +0200
Message-Id: <1239101428-29312-1-git-send-email-jw@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit '28a0ce7 xtensa: use correct stack pointer for stack traces'
changed the stack tracer from always reading the stack pointer
register to always using the saved value in the task descriptor.

The author was too dense to consider the fact that the saved stack
value is stale for a running process und thus unusable for 'current'.

What we do now is to use the stack pointer register (a1) for when the
task is unknown - we can't help it then - or when the task is
'current'.  For everything else use the saved stack pointer value
contained in the task descriptor.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/kernel/traps.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 9f0b711..ba9ab93 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -369,6 +369,18 @@ void show_regs(struct pt_regs * regs)
 		       regs->syscall);
 }
 
+static __always_inline unsigned long *stack_pointer(struct task_struct *task)
+{
+	unsigned long *sp;
+
+	if (!task || task == current)
+		__asm__ __volatile__ ("mov %0, a1\n" : "=a"(sp));
+	else
+		sp = (unsigned long *)task->thread.sp;
+
+	return sp;
+}
+
 void show_trace(struct task_struct *task, unsigned long *sp)
 {
 	unsigned long a0, a1, pc;
@@ -377,7 +389,7 @@ void show_trace(struct task_struct *task, unsigned long *sp)
 	if (sp)
 		a1 = (unsigned long)sp;
 	else
-		a1 = task->thread.sp;
+		a1 = (unsigned long)stack_pointer(task);
 
 	sp_start = a1 & ~(THREAD_SIZE-1);
 	sp_end = sp_start + THREAD_SIZE;
@@ -420,7 +432,7 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 	unsigned long *stack;
 
 	if (!sp)
-		sp = (unsigned long *)task->thread.sp;
+		sp = stack_pointer(task);
  	stack = sp;
 
 	printk("\nStack: ");
-- 
1.6.2.107.ge47ee

