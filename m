Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZDNJkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZDNJkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbZDNJjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:39:43 -0400
Received: from mx1.emlix.com ([193.175.82.87]:50643 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZDNJjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:39:42 -0400
From: Johannes Weiner <jw@emlix.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org
Subject: [patch 01/12] xtensa: always use correct stack pointer for stack traces
Date: Tue, 14 Apr 2009 11:41:09 +0200
Message-Id: <1239702080-14355-2-git-send-email-jw@emlix.com>
In-Reply-To: <1239702080-14355-1-git-send-email-jw@emlix.com>
References: <1239702080-14355-1-git-send-email-jw@emlix.com>
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

