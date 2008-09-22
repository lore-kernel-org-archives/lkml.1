Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbYIVKcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbYIVKcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYIVKcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:32:13 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:40597 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751570AbYIVKcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:32:12 -0400
From: Srinivasa Ds <srinivasa@in.ibm.com>
Organization: IBM
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, paulus@samba.org,
       roland@redhat.com, linuxppc-dev@ozlabs.org, mingo@elte.hu,
       linux-parisc@vger.kernel.org
Subject: [RFC][PATCH] Demultiplexing SIGTRAP signal
Date: Mon, 22 Sep 2008 16:02:32 +0530
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809221602.32616.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a SIGTRAP signal can denote any one of below reasons.
	- Breakpoint hit
	- H/W debug register hit
	- Single step
	- SIGTRAP signal sent through kill() or rasie()

Architectures like powerpc/parisc provides infrastructure to demultiplex
SIGTRAP signal by passing down the information for receiving SIGTRAP through
si_code of siginfot_t structure. Here is an attempt is generalise this 
infrastructure by extending it to x86 and x86_64 archs. 

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>



---
 arch/ia64/include/asm/siginfo.h    |    5 -----
 arch/powerpc/include/asm/siginfo.h |    5 -----
 arch/x86/kernel/traps_32.c         |   19 +++++++++++++++++--
 arch/x86/kernel/traps_64.c         |    7 ++++++-
 include/asm-generic/siginfo.h      |    2 ++
 include/asm-parisc/siginfo.h       |    5 -----
 6 files changed, 25 insertions(+), 18 deletions(-)

Index: linux-2.6.27-rc7/arch/ia64/include/asm/siginfo.h
===================================================================
--- linux-2.6.27-rc7.orig/arch/ia64/include/asm/siginfo.h
+++ linux-2.6.27-rc7/arch/ia64/include/asm/siginfo.h
@@ -113,11 +113,6 @@ typedef struct siginfo {
 #undef NSIGSEGV
 #define NSIGSEGV	3
 
-/*
- * SIGTRAP si_codes
- */
-#define TRAP_BRANCH	(__SI_FAULT|3)	/* process taken branch trap */
-#define TRAP_HWBKPT	(__SI_FAULT|4)	/* hardware breakpoint or watchpoint */
 #undef NSIGTRAP
 #define NSIGTRAP	4
 
Index: linux-2.6.27-rc7/arch/powerpc/include/asm/siginfo.h
===================================================================
--- linux-2.6.27-rc7.orig/arch/powerpc/include/asm/siginfo.h
+++ linux-2.6.27-rc7/arch/powerpc/include/asm/siginfo.h
@@ -15,11 +15,6 @@
 
 #include <asm-generic/siginfo.h>
 
-/*
- * SIGTRAP si_codes
- */
-#define TRAP_BRANCH	(__SI_FAULT|3)	/* process taken branch trap */
-#define TRAP_HWBKPT	(__SI_FAULT|4)	/* hardware breakpoint or watchpoint */
 #undef NSIGTRAP
 #define NSIGTRAP	4
 
Index: linux-2.6.27-rc7/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6.27-rc7.orig/arch/x86/kernel/traps_32.c
+++ linux-2.6.27-rc7/arch/x86/kernel/traps_32.c
@@ -890,6 +890,7 @@ void __kprobes do_int3(struct pt_regs *r
 void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
+	struct siginfo info;
 	unsigned int condition;
 
 	trace_hardirqs_fixup();
@@ -935,8 +936,22 @@ void __kprobes do_debug(struct pt_regs *
 			goto clear_TF_reenable;
 	}
 
-	/* Ok, finally something we can handle */
-	send_sigtrap(tsk, regs, error_code);
+	tsk->thread.trap_no = 1;
+	tsk->thread.error_code = error_code;
+
+	memset(&info, 0, sizeof(info));
+	info.si_signo = SIGTRAP;
+	if (condition & DR_STEP)
+		info.si_code = TRAP_TRACE;
+	else if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
+		info.si_code = TRAP_HWBKPT;
+	else
+		info.si_code = TRAP_BRKPT;
+	/* User-mode ip? */
+	info.si_addr = user_mode_vm(regs) ? (void __user *) regs->ip : NULL;
+
+	/* Send us the fake SIGTRAP */
+	force_sig_info(SIGTRAP, &info, tsk);
 
 	/*
 	 * Disable additional traps. They'll be re-enabled when
Index: linux-2.6.27-rc7/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6.27-rc7.orig/arch/x86/kernel/traps_64.c
+++ linux-2.6.27-rc7/arch/x86/kernel/traps_64.c
@@ -936,7 +936,12 @@ asmlinkage void __kprobes do_debug(struc
 	tsk->thread.error_code = error_code;
 	info.si_signo = SIGTRAP;
 	info.si_errno = 0;
-	info.si_code = TRAP_BRKPT;
+	if (condition & DR_STEP)
+		info.si_code = TRAP_TRACE;
+	else if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
+		info.si_code = TRAP_HWBKPT;
+	else
+		info.si_code = TRAP_BRKPT;
 	info.si_addr = user_mode(regs) ? (void __user *)regs->ip : NULL;
 	force_sig_info(SIGTRAP, &info, tsk);
 
Index: linux-2.6.27-rc7/include/asm-generic/siginfo.h
===================================================================
--- linux-2.6.27-rc7.orig/include/asm-generic/siginfo.h
+++ linux-2.6.27-rc7/include/asm-generic/siginfo.h
@@ -199,6 +199,8 @@ typedef struct siginfo {
  */
 #define TRAP_BRKPT	(__SI_FAULT|1)	/* process breakpoint */
 #define TRAP_TRACE	(__SI_FAULT|2)	/* process trace trap */
+#define TRAP_BRANCH     (__SI_FAULT|3)  /* process taken branch trap */
+#define TRAP_HWBKPT     (__SI_FAULT|4)  /* hardware breakpoint or watchpoint 
*/
 #define NSIGTRAP	2
 
 /*
Index: linux-2.6.27-rc7/include/asm-parisc/siginfo.h
===================================================================
--- linux-2.6.27-rc7.orig/include/asm-parisc/siginfo.h
+++ linux-2.6.27-rc7/include/asm-parisc/siginfo.h
@@ -3,11 +3,6 @@
 
 #include <asm-generic/siginfo.h>
 
-/*
- * SIGTRAP si_codes
- */
-#define TRAP_BRANCH	(__SI_FAULT|3)	/* process taken branch trap */
-#define TRAP_HWBKPT	(__SI_FAULT|4)	/* hardware breakpoint or watchpoint */
 #undef NSIGTRAP
 #define NSIGTRAP	4
 
