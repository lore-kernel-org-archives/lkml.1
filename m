Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZC0Je1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZC0Je1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbZC0JdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:33:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:49663 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626AbZC0JdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:33:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,431,1233561600"; 
   d="scan'208";a="501272179"
Date: Fri, 27 Mar 2009 09:46:26 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 1/14] x86, ptrace: add arch_ptrace_report_exit
Message-ID: <20090327094626.A11002@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an arch_ variant to report a task exit.
Move the ptrace report exit code from tracehook.h to ptrace.h.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/include/linux/ptrace.h
===================================================================
--- git-tip.orig/include/linux/ptrace.h	2009-03-23 10:45:30.000000000 +0100
+++ git-tip/include/linux/ptrace.h	2009-03-23 11:31:21.000000000 +0100
@@ -335,6 +335,23 @@ static inline void user_enable_block_ste
 #define arch_ptrace_fork(child, clone_flags)	do { } while (0)
 #endif
 
+#ifndef arch_ptrace_report_exit
+/**
+ * arch_ptrace_report_exit - Do machine specific work for exiting ptraced tasks
+ * @exit_code:	current->exit_code value
+ *
+ * This is called early from do_exit() with no locks held after we notified the
+ * ptracer.
+ */
+#define arch_ptrace_report_exit(exit_code)	do { } while (0)
+#endif
+
+static inline void ptrace_report_exit(long *exit_code)
+{
+	ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
+	arch_ptrace_report_exit(*exit_code);
+}
+
 extern int task_current_syscall(struct task_struct *target, long *callno,
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
Index: git-tip/include/linux/tracehook.h
===================================================================
--- git-tip.orig/include/linux/tracehook.h	2009-03-23 10:45:30.000000000 +0100
+++ git-tip/include/linux/tracehook.h	2009-03-23 11:31:21.000000000 +0100
@@ -211,7 +211,7 @@ static inline void tracehook_report_exec
  */
 static inline void tracehook_report_exit(long *exit_code)
 {
-	ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
+	ptrace_report_exit(exit_code);
 }
 
 /**
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

