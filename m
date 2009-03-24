Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbZCXXUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbZCXXUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbZCXXT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:19:57 -0400
Received: from leb.cs.unibo.it ([130.136.1.102]:54105 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbZCXXT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:19:56 -0400
Date: Wed, 25 Mar 2009 00:19:50 +0100
From: Renzo Davoli <renzo@cs.unibo.it>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090324231950.GF22695@cs.unibo.it>
References: <20090204080248.GB17452@cs.unibo.it> <20090310214450.GD5213@cs.unibo.it> <20090311134103.GC12753@cs.unibo.it> <20090316075113.GD3360@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316075113.GD3360@hack>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch #1. Rebased on 2.6.29 and Cong's objections fixed.

	renzo 

Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
---
diff -Naur linux-2.6.29/include/linux/ptrace.h linux-2.6.29-vm/include/linux/ptrace.h
--- linux-2.6.29/include/linux/ptrace.h	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-vm/include/linux/ptrace.h	2009-03-24 22:10:23.000000000 +0100
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
@@ -68,6 +73,11 @@
 #define PT_TRACE_VFORK_DONE	0x00000100
 #define PT_TRACE_EXIT	0x00000200
 
+#define PT_SYSCALL_SKIPEXIT  0x60000000
+#define PT_SYSCALL_SKIPCALL  0x40000000
+#define PT_SYSCALL_MASK      0x60000000
+#define PTRACE2PT_SYSCALL(X)	(((X) & PTRACE_SYSCALL_MASK) << 28)
+
 #define PT_TRACE_MASK	0x000003f4
 
 /* single stepping state bits (used on ARM and PA-RISC) */
diff -Naur linux-2.6.29/include/linux/tracehook.h linux-2.6.29-vm/include/linux/tracehook.h
--- linux-2.6.29/include/linux/tracehook.h	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-vm/include/linux/tracehook.h	2009-03-24 22:04:39.000000000 +0100
@@ -112,7 +112,7 @@
 	struct pt_regs *regs)
 {
 	ptrace_report_syscall(regs);
-	return 0;
+	return (task_ptrace(current) & PT_SYSCALL_SKIPCALL) ? 1 : 0;
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
diff -Naur linux-2.6.29/kernel/ptrace.c linux-2.6.29-vm/kernel/ptrace.c
--- linux-2.6.29/kernel/ptrace.c	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-vm/kernel/ptrace.c	2009-03-24 22:09:46.000000000 +0100
@@ -396,7 +396,8 @@
 #define is_sysemu_singlestep(request)	0
 #endif
 
-static int ptrace_resume(struct task_struct *child, long request, long data)
+static int ptrace_resume(struct task_struct *child, long request, 
+		   long addr, long data)
 {
 	if (!valid_signal(data))
 		return -EIO;
@@ -425,6 +426,9 @@
 	else
 		user_disable_single_step(child);
 
+	child->ptrace &= ~PT_SYSCALL_MASK;
+	child->ptrace |= PTRACE2PT_SYSCALL(addr);
+
 	child->exit_code = data;
 	wake_up_process(child);
 
@@ -486,12 +490,12 @@
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
