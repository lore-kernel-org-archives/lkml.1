Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbZGVPMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbZGVPMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZGVPMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:12:17 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:38805 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZGVPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:12:16 -0400
Date: Wed, 22 Jul 2009 20:41:23 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Fix traceback seen when resuming after suspend-to-ram
Message-ID: <20090722151123.GA4934@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
	Please accept a patch that fixes the warning message and traceback
seen upon a resume after suspend-to-ram.

The warning message is emitted because
spin_unlock_bh()<--load_debug_registers() is invoked with interrupts
disabled upon 'resume' unlike when invoked at boot-time, and was
reported on LKML here: http://lkml.org/lkml/2009/7/18/145.

This patch modifies load_debug_registers() to block all interrupts and not
just bottom-halves (bottom-halves were blocked in load_debug_registers()
prevent flush_thread_hw_breakpoint() from interfering when invoked from
SoftIRQ context).

Fix traceback seen when resuming after suspend-to-ram

This patch fixes a traceback when resuming after a suspend-to-ram operation.
The traceback warns about entering slowpatch due to a spin_unlock_bh() done
from interrupt context.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/hw_breakpoint.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.orig/kernel/hw_breakpoint.c
+++ linux-2.6-tip/kernel/hw_breakpoint.c
@@ -80,17 +80,15 @@ void load_debug_registers(void)
 	unsigned long flags;
 	struct task_struct *tsk = current;
 
-	spin_lock_bh(&hw_breakpoint_lock);
-
 	/* Prevent IPIs for new kernel breakpoint updates */
-	local_irq_save(flags);
+	spin_lock_irqsave(&hw_breakpoint_lock, flags);
+
 	arch_update_kernel_hw_breakpoint(NULL);
-	local_irq_restore(flags);
 
 	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
 		arch_install_thread_hw_breakpoint(tsk);
 
-	spin_unlock_bh(&hw_breakpoint_lock);
+	spin_unlock_irqrestore(&hw_breakpoint_lock, flags);
 }
 
 /*
