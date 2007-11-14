Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbXKNTWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbXKNTWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761975AbXKNTVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:21:10 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44252 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762472AbXKNTVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:21:07 -0500
Date: Wed, 14 Nov 2007 14:20:49 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Karol Swietlicki <magotari@gmail.com>
Subject: [PATCH 2/4] UML - Remove unused variables in the context switcher
Message-ID: <20071114192049.GA9083@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a variable which was not used in two functions.
Yet another code cleanup, nothing really significant.

Please note that I could not test this on x86_64. I don't have the
hardware for it.

[ jdike - Bits of tidying around the affected code.  Also, it's fine on
x86_64 ]

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/process.c      |   19 ++++++++-----------
 arch/um/sys-i386/ptrace.c     |    6 +++---
 arch/um/sys-i386/tls.c        |    2 +-
 arch/um/sys-x86_64/syscalls.c |    2 +-
 4 files changed, 13 insertions(+), 16 deletions(-)

Index: linux-2.6.22/arch/um/kernel/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/process.c	2007-11-14 13:29:51.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/process.c	2007-11-14 13:38:36.000000000 -0500
@@ -82,12 +82,12 @@ static inline void set_current(struct ta
 		{ external_pid(task), task });
 }
 
-extern void arch_switch_to(struct task_struct *from, struct task_struct *to);
+extern void arch_switch_to(struct task_struct *to);
 
 void *_switch_to(void *prev, void *next, void *last)
 {
 	struct task_struct *from = prev;
-	struct task_struct *to= next;
+	struct task_struct *to = next;
 
 	to->thread.prev_sched = from;
 	set_current(to);
@@ -95,16 +95,15 @@ void *_switch_to(void *prev, void *next,
 	do {
 		current->thread.saved_task = NULL;
 
-		switch_threads(&from->thread.switch_buf,
-			       &to->thread.switch_buf);
+		switch_threads(&from->thread.switch_buf, &to->thread.switch_buf);
 
-		arch_switch_to(current->thread.prev_sched, current);
+		arch_switch_to(current);
 
 		if (current->thread.saved_task)
 			show_regs(&(current->thread.regs));
-		next= current->thread.saved_task;
-		prev= current;
-	} while(current->thread.saved_task);
+		next = current->thread.saved_task;
+		prev = current;
+	} while (current->thread.saved_task);
 
 	return current->thread.prev_sched;
 
@@ -162,8 +161,6 @@ void new_thread_handler(void)
 void fork_handler(void)
 {
 	force_flush_all();
-	if (current->thread.prev_sched == NULL)
-		panic("blech");
 
 	schedule_tail(current->thread.prev_sched);
 
@@ -172,7 +169,7 @@ void fork_handler(void)
 	 * arch_switch_to isn't needed. We could want to apply this to
 	 * improve performance. -bb
 	 */
-	arch_switch_to(current->thread.prev_sched, current);
+	arch_switch_to(current);
 
 	current->thread.prev_sched = NULL;
 
Index: linux-2.6.22/arch/um/sys-i386/ptrace.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/ptrace.c	2007-11-14 13:29:51.000000000 -0500
+++ linux-2.6.22/arch/um/sys-i386/ptrace.c	2007-11-14 13:37:30.000000000 -0500
@@ -8,11 +8,11 @@
 #include "asm/uaccess.h"
 #include "skas.h"
 
-extern int arch_switch_tls(struct task_struct *from, struct task_struct *to);
+extern int arch_switch_tls(struct task_struct *to);
 
-void arch_switch_to(struct task_struct *from, struct task_struct *to)
+void arch_switch_to(struct task_struct *to)
 {
-	int err = arch_switch_tls(from, to);
+	int err = arch_switch_tls(to);
 	if (!err)
 		return;
 
Index: linux-2.6.22/arch/um/sys-i386/tls.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/tls.c	2007-11-14 13:29:51.000000000 -0500
+++ linux-2.6.22/arch/um/sys-i386/tls.c	2007-11-14 13:37:30.000000000 -0500
@@ -172,7 +172,7 @@ void clear_flushed_tls(struct task_struc
  * SKAS patch.
  */
 
-int arch_switch_tls(struct task_struct *from, struct task_struct *to)
+int arch_switch_tls(struct task_struct *to)
 {
 	if (!host_supports_tls)
 		return 0;
Index: linux-2.6.22/arch/um/sys-x86_64/syscalls.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-x86_64/syscalls.c	2007-11-14 13:29:51.000000000 -0500
+++ linux-2.6.22/arch/um/sys-x86_64/syscalls.c	2007-11-14 13:37:30.000000000 -0500
@@ -105,7 +105,7 @@ long sys_clone(unsigned long clone_flags
 	return ret;
 }
 
-void arch_switch_to(struct task_struct *from, struct task_struct *to)
+void arch_switch_to(struct task_struct *to)
 {
 	if ((to->thread.arch.fs == 0) || (to->mm == NULL))
 		return;
