Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZBDIDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZBDIDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZBDICu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:02:50 -0500
Received: from leb.cs.unibo.it ([130.136.1.102]:36398 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbZBDICt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:02:49 -0500
Date: Wed, 4 Feb 2009 09:02:48 +0100
From: Renzo Davoli <renzo@cs.unibo.it>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090204080248.GB17452@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the new PTRACE_VM_SKIPCALL and PTRACE_VM_SKIPEXIT
tags for ptrace's addr parameter.
In this way it is possible to (eventually) get rid of PTRACE_SYSEMU
PTRACE_SYSEMU_SINGLESTEP, while providing not only the same features
but a more general support for Virtual Machines.
Part#1: tracehook based architecture independent support

renzo

Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
---
diff -Naur linux-2.6.28.2/include/linux/ptrace.h linux-2.6.28.2-vm/include/linux/ptrace.h
--- linux-2.6.28.2/include/linux/ptrace.h	2009-01-25 01:42:07.000000000 +0100
+++ linux-2.6.28.2-vm/include/linux/ptrace.h	2009-02-02 14:31:42.000000000 +0100
@@ -46,6 +46,11 @@
 #define PTRACE_EVENT_VFORK_DONE	5
 #define PTRACE_EVENT_EXIT	6
 
+/* options for new PTRACE_SYSCALL syntax*/
+#define PTRACE_SYSCALL_SKIPEXIT  0x2
+#define PTRACE_SYSCALL_SKIPCALL  0x6
+#define PTRACE_SYSCALL_MASK    0x00000006
+
 #include <asm/ptrace.h>
 
 #ifdef __KERNEL__
@@ -68,6 +73,10 @@
 #define PT_TRACE_VFORK_DONE	0x00000100
 #define PT_TRACE_EXIT	0x00000200
 
+#define PT_SYSCALL_SKIPEXIT  0x60000000
+#define PT_SYSCALL_SKIPCALL  0x40000000
+#define PT_SYSCALL_MASK      0x60000000
+
 #define PT_TRACE_MASK	0x000003f4
 
 /* single stepping state bits (used on ARM and PA-RISC) */
diff -Naur linux-2.6.28.2/include/linux/tracehook.h linux-2.6.28.2-vm/include/linux/tracehook.h
--- linux-2.6.28.2/include/linux/tracehook.h	2009-01-25 01:42:07.000000000 +0100
+++ linux-2.6.28.2-vm/include/linux/tracehook.h	2009-02-02 14:45:13.000000000 +0100
@@ -112,7 +112,7 @@
 	struct pt_regs *regs)
 {
 	ptrace_report_syscall(regs);
-	return 0;
+	return (task_ptrace(current) & PT_SYSCALL_SKIPCALL)?1:0;
 }
 
 /**
@@ -134,7 +134,8 @@
  */
 static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 {
-	ptrace_report_syscall(regs);
+	if (!(task_ptrace(current) & PT_SYSCALL_SKIPEXIT))
+		ptrace_report_syscall(regs);
 }
 
 /**
diff -Naur linux-2.6.28.2/kernel/ptrace.c linux-2.6.28.2-vm/kernel/ptrace.c
--- linux-2.6.28.2/kernel/ptrace.c	2009-01-25 01:42:07.000000000 +0100
+++ linux-2.6.28.2-vm/kernel/ptrace.c	2009-02-02 14:31:43.000000000 +0100
@@ -367,7 +367,7 @@
 #define is_sysemu_singlestep(request)	0
 #endif
 
-static int ptrace_resume(struct task_struct *child, long request, long data)
+static int ptrace_resume(struct task_struct *child, long request, long addr, long data)
 {
 	if (!valid_signal(data))
 		return -EIO;
@@ -396,6 +396,9 @@
 	else
 		user_disable_single_step(child);
 
+	child->ptrace &= ~PT_SYSCALL_MASK;
+	child->ptrace |= (addr & PTRACE_SYSCALL_MASK) << 28;
+
 	child->exit_code = data;
 	wake_up_process(child);
 
@@ -457,12 +460,12 @@
 #endif
 	case PTRACE_SYSCALL:
 	case PTRACE_CONT:
-		return ptrace_resume(child, request, data);
+		return ptrace_resume(child, request, addr, data);
 
 	case PTRACE_KILL:
 		if (child->exit_state)	/* already dead */
 			return 0;
-		return ptrace_resume(child, request, SIGKILL);
+		return ptrace_resume(child, request, addr, SIGKILL);
 
 	default:
 		break;
