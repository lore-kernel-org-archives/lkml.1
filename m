Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbZCBQ6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbZCBQ6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbZCBQ5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:57:48 -0500
Received: from mx1.emlix.com ([193.175.82.87]:48385 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbZCBQ5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:57:47 -0500
References: <20090302164257.477296438@emlix.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 17:43:01 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 4/7] xtensa: use correct stack pointer for stack traces
Content-Disposition: inline; filename=xtensa-use-correct-stack-for-backtrace.patch
Message-Id: <E1LeBSa-0003Z1-Vb@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, the xtensa stacktrace code reads the _current_ kernel stack
pointer if nothing is supplied.  With debugging facilities like sysrq
this means that the backtrace of the sysrq-handler is printed instead
of a trace of the given task's stack.

When no stack pointer is specified in show_trace() and show_stack(),
use the stack pointer that comes with the handed in task descriptor to
make stack traces more useful.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/kernel/traps.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -372,11 +372,10 @@ void show_trace(struct task_struct *task
 	unsigned long a0, a1, pc;
 	unsigned long sp_start, sp_end;
 
-	a1 = (unsigned long)sp;
-
-	if (a1 == 0)
-		__asm__ __volatile__ ("mov %0, a1\n" : "=a"(a1));
-
+	if (sp)
+		a1 = (unsigned long)sp;
+	else
+		a1 = task->thread.sp;
 
 	sp_start = a1 & ~(THREAD_SIZE-1);
 	sp_end = sp_start + THREAD_SIZE;
@@ -418,9 +417,8 @@ void show_stack(struct task_struct *task
 	int i = 0;
 	unsigned long *stack;
 
-	if (sp == 0)
-		__asm__ __volatile__ ("mov %0, a1\n" : "=a"(sp));
-
+	if (!sp)
+		sp = (unsigned long *)task->thread.sp;
  	stack = sp;
 
 	printk("\nStack: ");

-- 

