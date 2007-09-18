Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbXIRXd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbXIRXd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 19:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbXIRXdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 19:33:53 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48738 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXIRXdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 19:33:52 -0400
Date: Tue, 18 Sep 2007 19:33:36 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] UML - Fix irqstack crash
Message-ID: <20070918233336.GA9746@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a crash caused by an interrupt coming in when an IRQ
stack is being torn down.  When this happens, handle_signal will loop,
setting up the IRQ stack again because the tearing down had finished,
and handling whatever signals had come in.

However, to_irq_stack returns a mask of pending signals to be handled,
plus bit zero is set if the IRQ stack was already active, and thus
shouldn't be torn down.  This causes a problem because when
handle_signal goes around the loop, sig will be zero, and to_irq_stack
will duly set bit zero in the returned mask, faking handle_signal into
believing that it shouldn't tear down the IRQ stack and return
thread_info pointers back to their original values.

This will eventually cause a crash, as the IRQ stack thread_info will
continue pointing to the original task_struct and an interrupt will
look into it after it has been freed.

The fix is to stop passing a signal number into to_irq_stack.  Rather,
the pending signals mask is initialized beforehand with the bit for
sig already set.  References to sig in to_irq_stack can be replaced
with references to the mask.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/kern_util.h |    2 +-
 arch/um/kernel/irq.c        |    7 ++++---
 arch/um/os-Linux/signal.c   |    4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6.17/arch/um/include/kern_util.h
===================================================================
--- linux-2.6.17.orig/arch/um/include/kern_util.h	2007-09-11 10:12:26.000000000 -0400
+++ linux-2.6.17/arch/um/include/kern_util.h	2007-09-18 12:31:28.000000000 -0400
@@ -117,7 +117,7 @@ extern void sigio_handler(int sig, union
 
 extern void copy_sc(union uml_pt_regs *regs, void *from);
 
-unsigned long to_irq_stack(int sig, unsigned long *mask_out);
+extern unsigned long to_irq_stack(unsigned long *mask_out);
 unsigned long from_irq_stack(int nested);
 
 #endif
Index: linux-2.6.17/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.17.orig/arch/um/kernel/irq.c	2007-09-11 10:14:09.000000000 -0400
+++ linux-2.6.17/arch/um/kernel/irq.c	2007-09-18 12:32:08.000000000 -0400
@@ -518,13 +518,13 @@ int init_aio_irq(int irq, char *name, ir
 
 static unsigned long pending_mask;
 
-unsigned long to_irq_stack(int sig, unsigned long *mask_out)
+unsigned long to_irq_stack(unsigned long *mask_out)
 {
 	struct thread_info *ti;
 	unsigned long mask, old;
 	int nested;
 
-	mask = xchg(&pending_mask, 1 << sig);
+	mask = xchg(&pending_mask, *mask_out);
 	if(mask != 0){
 		/* If any interrupts come in at this point, we want to
 		 * make sure that their bits aren't lost by our
@@ -534,7 +534,7 @@ unsigned long to_irq_stack(int sig, unsi
 		 * and pending_mask contains a bit for each interrupt
 		 * that came in.
 		 */
-		old = 1 << sig;
+		old = *mask_out;
 		do {
 			old |= mask;
 			mask = xchg(&pending_mask, old);
@@ -550,6 +550,7 @@ unsigned long to_irq_stack(int sig, unsi
 
 		task = cpu_tasks[ti->cpu].task;
 		tti = task_thread_info(task);
+
 		*ti = *tti;
 		ti->real_thread = tti;
 		task->stack = ti;
Index: linux-2.6.17/arch/um/os-Linux/signal.c
===================================================================
--- linux-2.6.17.orig/arch/um/os-Linux/signal.c	2007-09-09 11:15:37.000000000 -0400
+++ linux-2.6.17/arch/um/os-Linux/signal.c	2007-09-18 12:32:40.000000000 -0400
@@ -119,7 +119,7 @@ void (*handlers[_NSIG])(int sig, struct 
 
 void handle_signal(int sig, struct sigcontext *sc)
 {
-	unsigned long pending = 0;
+	unsigned long pending = 1 << sig;
 
 	do {
 		int nested, bail;
@@ -134,7 +134,7 @@ void handle_signal(int sig, struct sigco
 		 * have to return, and the upper handler will deal
 		 * with this interrupt.
 		 */
-		bail = to_irq_stack(sig, &pending);
+		bail = to_irq_stack(&pending);
 		if(bail)
 			return;
 
