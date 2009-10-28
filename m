Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbZJ1QAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbZJ1QAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZJ1QAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:00:51 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:42999 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbZJ1QAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:00:51 -0400
Date: Wed, 28 Oct 2009 21:29:57 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [RFC Patch 3/4] PERF-HW_BKPT: Fix traceback seen when resuming
	after suspend-to-ram
Message-ID: <20091028155957.GD8604@in.ibm.com>
References: <20091028155449.979239874@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="s2r_patch.txt"
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load the debug registers (when a CPU turns online) through a tasklet. This
helps to keep routines (using protected hw-breakpoint data) to be invoked
only from non-interrupt context, thus making the spin_lock_bh() locking
sufficient.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/hw_breakpoint.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

Index: linux-2.6-tip.perf_hbkpt/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.perf_hbkpt.orig/kernel/hw_breakpoint.c
+++ linux-2.6-tip.perf_hbkpt/kernel/hw_breakpoint.c
@@ -23,6 +23,7 @@
  * This file contains the arch-independent routines.
  */
 
+#include <linux/interrupt.h>
 #include <linux/irqflags.h>
 #include <linux/kallsyms.h>
 #include <linux/notifier.h>
@@ -69,20 +70,19 @@ unsigned int hbp_user_refcount[HBP_NUM];
 static DEFINE_PER_CPU(int, hbp_consumed);
 
 /*
- * Load the debug registers during startup of a CPU.
+ * A tasklet to populate the debug register's values from the
+ * breakpoint structure
  */
-void load_debug_registers(void)
+static struct tasklet_struct hbp_tasklet;
+
+/* Tasklet function that populates the debug registers */
+void hbp_tasklet_function(unsigned long unused)
 {
-	unsigned long flags;
 	struct task_struct *tsk = current;
 
 	spin_lock_bh(&hw_breakpoint_lock);
 
-	/* Prevent IPIs for new kernel breakpoint updates */
-	local_irq_save(flags);
 	arch_update_kernel_hw_breakpoint(NULL);
-	local_irq_restore(flags);
-
 	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
 		arch_install_thread_hw_breakpoint(tsk);
 
@@ -90,6 +90,18 @@ void load_debug_registers(void)
 }
 
 /*
+ * Load the debug registers during startup of a CPU.
+ */
+void load_debug_registers(void)
+{
+	unsigned long flags;
+
+	if (!hbp_tasklet.func)
+		tasklet_init(&hbp_tasklet, &hbp_tasklet_function, 0UL);
+	tasklet_schedule(&hbp_tasklet);
+}
+
+/*
  * Erase all the hardware breakpoint info associated with a thread.
  *
  * If tsk != current then tsk must not be usable (for example, a


