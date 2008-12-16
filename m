Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbYLPOtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbYLPOtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYLPOsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:48:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:7838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbYLPOsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:48:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,231,1228118400"; 
   d="scan'208";a="371330237"
Date: Tue, 16 Dec 2008 15:48:42 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com
Subject: [patch 1/3] x86, bts: clear bts bits on fork
Message-ID: <20081216154842.A29980@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear the DS context as well as the bts tracer and corresponding
fields in task_struct on fork.

Correct the CONFIG guard.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
---

Index: ftrace/arch/x86/kernel/process_32.c
===================================================================
--- ftrace.orig/arch/x86/kernel/process_32.c	2008-12-12 14:02:24.000000000 +0100
+++ ftrace/arch/x86/kernel/process_32.c	2008-12-12 14:33:19.000000000 +0100
@@ -251,7 +251,7 @@
 		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
-#ifdef CONFIG_X86_DS
+#ifdef CONFIG_X86_PTRACE_BTS
 	/* Free any BTS tracers that have not been properly released. */
 	if (unlikely(current->bts)) {
 		ds_release_bts(current->bts);
@@ -261,7 +261,7 @@
 		current->bts_buffer = NULL;
 		current->bts_size = 0;
 	}
-#endif /* CONFIG_X86_DS */
+#endif /* CONFIG_X86_PTRACE_BTS */
 }
 
 void flush_thread(void)
@@ -343,6 +343,17 @@
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+
+#ifdef CONFIG_X86_DS
+	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
+	p->thread.ds_ctx = NULL;
+#endif
+#ifdef CONFIG_X86_PTRACE_BTS
+	p->thread.bts_ovfl_signal = 0;
+#endif
+	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
+	p->thread.debugctlmsr = 0;
+
 	return err;
 }
 
Index: ftrace/arch/x86/kernel/process_64.c
===================================================================
--- ftrace.orig/arch/x86/kernel/process_64.c	2008-12-12 14:02:24.000000000 +0100
+++ ftrace/arch/x86/kernel/process_64.c	2008-12-12 14:32:38.000000000 +0100
@@ -248,7 +248,7 @@
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
-#ifdef CONFIG_X86_DS
+#ifdef CONFIG_X86_PTRACE_BTS
 	/* Free any BTS tracers that have not been properly released. */
 	if (unlikely(current->bts)) {
 		ds_release_bts(current->bts);
@@ -258,7 +258,7 @@
 		current->bts_buffer = NULL;
 		current->bts_size = 0;
 	}
-#endif /* CONFIG_X86_DS */
+#endif /* CONFIG_X86_PTRACE_BTS */
 }
 
 void flush_thread(void)
@@ -388,6 +388,17 @@
 		if (err)
 			goto out;
 	}
+
+#ifdef CONFIG_X86_DS
+	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
+	p->thread.ds_ctx = NULL;
+#endif
+#ifdef CONFIG_X86_PTRACE_BTS
+	p->thread.bts_ovfl_signal = 0;
+#endif
+	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
+	p->thread.debugctlmsr = 0;
+
 	err = 0;
 out:
 	if (err && p->thread.io_bitmap_ptr) {
Index: ftrace/kernel/fork.c
===================================================================
--- ftrace.orig/kernel/fork.c	2008-12-12 14:02:24.000000000 +0100
+++ ftrace/kernel/fork.c	2008-12-12 14:29:43.000000000 +0100
@@ -1102,7 +1102,11 @@
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
-
+#ifdef CONFIG_X86_PTRACE_BTS
+	p->bts = NULL;
+	p->bts_buffer = NULL;
+	p->bts_size = 0;
+#endif
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
 
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

