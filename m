Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677Ab0A1LOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0A1LOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543Ab0A1LOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:14:22 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34536 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab0A1LOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:14:19 -0500
Date: Thu, 28 Jan 2010 16:44:15 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 2/2 v2] Return proper code to notifier chain in
	hw_breakpoint_handler
Message-ID: <20100128111415.GC13935@in.ibm.com>
References: <20100128110936.399448739@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=fix_notify_code_02
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Processing of debug exceptions (in do_debug()) can stop if it originated from
a hw-breakpoint exception (return NOTIFY_STOP). For certain cases such as
a) user-space breakpoints with pending SIGTRAP signal delivery (as in the case
of ptrace induced breakpoints) and b) exceptions due to multiple causes (other
than breakpoints) we will continue to process the exception (by returning
NOTIFY_DONE).

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/hw_breakpoint.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6-tip.bugfix_perf_hbkpt/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.bugfix_perf_hbkpt.orig/arch/x86/kernel/hw_breakpoint.c
+++ linux-2.6-tip.bugfix_perf_hbkpt/arch/x86/kernel/hw_breakpoint.c
@@ -502,8 +502,6 @@ static int __kprobes hw_breakpoint_handl
 		rcu_read_lock();
 
 		bp = per_cpu(bp_per_reg[i], cpu);
-		if (bp)
-			rc = NOTIFY_DONE;
 		/*
 		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
 		 * exception handling
@@ -522,7 +520,13 @@ static int __kprobes hw_breakpoint_handl
 
 		rcu_read_unlock();
 	}
-	if (dr6 & (~DR_TRAP_BITS))
+	/*
+	 * Further processing in do_debug() is needed for a) user-space
+	 * breakpoints (to generate signals) and b) when the system has
+	 * taken exception due to multiple causes
+	 */
+	if ((current->thread.debugreg6 & DR_TRAP_BITS) ||
+	    (dr6 & (~DR_TRAP_BITS)))
 		rc = NOTIFY_DONE;
 
 	set_debugreg(dr7, 7);

