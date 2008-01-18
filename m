Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbYARB76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbYARB76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYARB7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:59:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:39335 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYARB7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:59:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=x8CliC9SDJBUqvptkHq/4ySgULb3tZWGRrKP9NMNy+vdS5GVJx9iwt6v7weX//fMfmLzIOwzgpk3ofKWW5oUb7lIFlremdMBz5UyTQR7CstZUUbVrgKC1n9uCS1kR87w6k3WObMREJcYlwkBz3hMYPQ5KkDjsbACVxTVmK920j4=
Subject: [PATCH 1/2] x86: unify pt_regs accessors ptrace.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 17:59:49 -0800
Message-Id: <1200621589.5724.92.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify the definiton of:
v8086_mode
user_mode
user_mode_vm
stack_pointer
instruction_pointer
frame_pointer

in ptrace.h to make it clear where the differences are between
32 and 64 bit.  Changes macros to static inlines as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/ptrace.h |   84 +++++++++++++++++++++++++++++----------------
 1 files changed, 54 insertions(+), 30 deletions(-)

diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index ee4b595..0ad9a2b 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -76,30 +76,6 @@ convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code);
 
-/*
- * user_mode_vm(regs) determines whether a register set came from user mode.
- * This is true if V8086 mode was enabled OR if the register set was from
- * protected mode with RPL-3 CS value.  This tricky test checks that with
- * one comparison.  Many places in the kernel can bypass this full check
- * if they have already ruled out V8086 mode, so user_mode(regs) can be used.
- */
-static inline int user_mode(struct pt_regs *regs)
-{
-	return (regs->cs & SEGMENT_RPL_MASK) == USER_RPL;
-}
-static inline int user_mode_vm(struct pt_regs *regs)
-{
-	return ((regs->cs & SEGMENT_RPL_MASK) |
-		(regs->flags & VM_MASK)) >= USER_RPL;
-}
-static inline int v8086_mode(struct pt_regs *regs)
-{
-	return (regs->flags & VM_MASK);
-}
-
-#define instruction_pointer(regs) ((regs)->ip)
-#define frame_pointer(regs) ((regs)->bp)
-#define stack_pointer(regs) ((unsigned long)(regs))
 #define regs_return_value(regs) ((regs)->ax)
 
 extern unsigned long profile_pc(struct pt_regs *regs);
@@ -167,12 +143,6 @@ struct pt_regs {
 /* top of stack page */
 };
 
-#define user_mode(regs) (!!((regs)->cs & 3))
-#define user_mode_vm(regs) user_mode(regs)
-#define v8086_mode(regs) 0	/* No V86 mode support in long mode */
-#define instruction_pointer(regs) ((regs)->ip)
-#define frame_pointer(regs) ((regs)->bp)
-#define stack_pointer(regs) ((regs)->sp)
 #define regs_return_value(regs) ((regs)->ax)
 
 extern unsigned long profile_pc(struct pt_regs *regs);
@@ -189,6 +159,60 @@ convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 #ifdef __KERNEL__
 
 /*
+ * user_mode_vm(regs) determines whether a register set came from user mode.
+ * This is true if V8086 mode was enabled OR if the register set was from
+ * protected mode with RPL-3 CS value.  This tricky test checks that with
+ * one comparison.  Many places in the kernel can bypass this full check
+ * if they have already ruled out V8086 mode, so user_mode(regs) can be used.
+ */
+static inline int user_mode(struct pt_regs *regs)
+{
+#ifdef CONFIG_X86_32
+	return (regs->cs & SEGMENT_RPL_MASK) == USER_RPL;
+#else
+	return !!(regs->cs & 3);
+#endif
+}
+
+static inline int user_mode_vm(struct pt_regs *regs)
+{
+#ifdef CONFIG_X86_32
+	return ((regs->cs & SEGMENT_RPL_MASK) |
+		(regs->flags & VM_MASK)) >= USER_RPL;
+#else
+	return user_mode(regs);
+#endif
+}
+
+static inline int v8086_mode(struct pt_regs *regs)
+{
+#ifdef CONFIG_X86_32
+	return (regs->flags & VM_MASK);
+#else
+	return 0;	/* No V86 mode support in long mode */
+#endif
+}
+
+static inline unsigned long stack_pointer(struct pt_regs *regs)
+{
+#ifdef CONFIG_X86_32
+	return (unsigned long)regs;
+#else
+	return regs->sp;
+#endif
+}
+
+static inline unsigned long instruction_pointer(struct pt_regs *regs)
+{
+	return regs->ip;
+}
+
+static inline unsigned long frame_pointer(struct pt_regs *regs)
+{
+	return regs->bp;
+}
+
+/*
  * These are defined as per linux/ptrace.h, which see.
  */
 #define arch_has_single_step()	(1)
-- 
1.5.4.rc2.1164.g6451


