Return-Path: <linux-kernel-owner+w=401wt.eu-S1758484AbZDYAKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbZDYAKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757829AbZDYAKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:10:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757626AbZDYAKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:10:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 03/17] arm: tracehook_report_syscall
Message-Id: <20090425000842.DDDE3FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:08:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes arm use the standard tracehook_report_syscall_entry()
and tracehook_report_syscall_exit() hooks in <linux/tracehook.h>.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/kernel/ptrace.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 93d7822..effada1 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -14,6 +14,7 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/user.h>
 #include <linux/security.h>
 #include <linux/init.h>
@@ -811,8 +812,6 @@ asmlinkage int syscall_trace(int why, struct pt_regs *regs, int scno)
 
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return scno;
-	if (!(current->ptrace & PT_PTRACED))
-		return scno;
 
 	/*
 	 * Save IP.  IP is used to denote syscall entry/exit:
@@ -823,19 +822,16 @@ asmlinkage int syscall_trace(int why, struct pt_regs *regs, int scno)
 
 	current_thread_info()->syscall = scno;
 
-	/* the 0x80 provides a way for the tracing parent to distinguish
-	   between a syscall stop and SIGTRAP delivery */
-	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
-				 ? 0x80 : 0));
 	/*
-	 * this isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
+	 * Report the system call for tracing.  Entry tracing can
+	 * decide to abort the call.  We handle that by setting an
+	 * invalid syscall number (-1) to force an ENOSYS error.
 	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
+	if (why)
+		tracehook_report_syscall_exit(regs, 0);
+	else if (tracehook_report_syscall_entry(regs))
+		current_thread_info()->syscall = -1;
+
 	regs->ARM_ip = ip;
 
 	return current_thread_info()->syscall;
