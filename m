Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbYARCAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbYARCAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbYARCAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:00:21 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:39335 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbYARCAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:00:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uX4GsZ6NWY0bvRz+ltYFLqsOybFqEJqo9WamVS+f1NH9mt9VzakFHJu/tQdiqO36az+zMLfDhw3M2bLINJRp6MnE3vhIDjHEnOXY6U3YZnXcpPbl6SN+EkdX4jbF5TaJhwgh1JqhJuckbwdTMGb5lt+SXOL0cbiCGJ64Vg92lrg=
Subject: [PATCH 2/2] x86: Cleanup ptrace.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 18:00:19 -0800
Message-Id: <1200621619.5724.94.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leave definition of pt_regs in its own section, move all kernel
code to section afterwards, unify prototype definitions, has some
conditional prototypes to make it clear what was only defined in
32 and 64 bit.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/ptrace.h |   43 ++++++++++++++++---------------------------
 1 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 0ad9a2b..79d5b8f 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -7,17 +7,6 @@
 
 #ifndef __ASSEMBLY__
 
-#ifdef __KERNEL__
-
-/* the DS BTS struct is used for ptrace as well */
-#include <asm/ds.h>
-
-struct task_struct;
-extern void ptrace_bts_take_timestamp(struct task_struct *, enum bts_qualifier);
-
-#endif /* __KERNEL__ */
-
-
 #ifdef __i386__
 /* this struct defines the way the registers are stored on the
    stack during a system call. */
@@ -69,16 +58,6 @@ struct pt_regs {
 #include <asm/vm86.h>
 #include <asm/segment.h>
 
-struct task_struct;
-
-extern unsigned long
-convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
-
-extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code);
-
-#define regs_return_value(regs) ((regs)->ax)
-
-extern unsigned long profile_pc(struct pt_regs *regs);
 #endif /* __KERNEL__ */
 
 #else /* __i386__ */
@@ -143,20 +122,30 @@ struct pt_regs {
 /* top of stack page */
 };
 
-#define regs_return_value(regs) ((regs)->ax)
+#endif /* __KERNEL__ */
+#endif /* !__i386__ */
 
-extern unsigned long profile_pc(struct pt_regs *regs);
-void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
+#ifdef __KERNEL__
+
+/* the DS BTS struct is used for ptrace as well */
+#include <asm/ds.h>
 
 struct task_struct;
 
+extern void ptrace_bts_take_timestamp(struct task_struct *, enum bts_qualifier);
+
+extern unsigned long profile_pc(struct pt_regs *regs);
+
 extern unsigned long
 convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 
-#endif /* __KERNEL__ */
-#endif /* !__i386__ */
+#ifdef CONFIG_X86_32
+extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code);
+#else
+void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
+#endif
 
-#ifdef __KERNEL__
+#define regs_return_value(regs) ((regs)->ax)
 
 /*
  * user_mode_vm(regs) determines whether a register set came from user mode.
-- 
1.5.4.rc2.1164.g6451

