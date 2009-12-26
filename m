Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZLZS2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZLZS2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 13:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZLZS2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 13:28:41 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:35223 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZLZS2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 13:28:41 -0500
Date: Sat, 26 Dec 2009 23:58:33 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
	notifier chain in hw_breakpoint_handler
Message-ID: <20091226182833.GC9494@in.ibm.com>
References: <20091226175533.149765731@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=fix_notify_code_02
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hw-breakpoint handler will return NOTIFY_DONE for user-space breakpoints
to generate SIGTRAP signal (and not for kernel-space addresses). 

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/hw_breakpoint.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/hw_breakpoint.c
+++ linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
@@ -502,8 +502,6 @@ static int __kprobes hw_breakpoint_handl
 		rcu_read_lock();
 
 		bp = per_cpu(bp_per_reg[i], cpu);
-		if (bp)
-			rc = NOTIFY_DONE;
 		/*
 		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
 		 * exception handling
@@ -517,6 +515,13 @@ static int __kprobes hw_breakpoint_handl
 			rcu_read_unlock();
 			break;
 		}
+		/*
+		 * Further processing in do_debug() is needed for a) user-space
+		 * breakpoints (to generate signals) and b) when the system has
+		 * taken exception due to multiple causes
+		 */
+		if (bp->attr.bp_addr < TASK_SIZE)
+			rc = NOTIFY_DONE;
 
 		perf_bp_event(bp, args->regs);
 

