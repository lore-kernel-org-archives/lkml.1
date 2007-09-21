Return-Path: <linux-kernel-owner+w=401wt.eu-S1764713AbXIUUwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764713AbXIUUwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763364AbXIUUpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758448AbXIUUpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:07 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: jblunck@suse.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [24/45] x86: Introduce frame_pointer() and stack_pointer()
Message-Id: <20070921204506.65C9F14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: jblunck@suse.de
This patch defines frame_pointer() and stack_pointer() similar to the
already defined instruction_pointer(). Thus the oprofile code can be written
in a more readable fashion.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/oprofile/backtrace.c |   12 ++----------
 include/asm-i386/ptrace.h      |    2 ++
 include/asm-x86_64/ptrace.h    |    2 ++
 3 files changed, 6 insertions(+), 10 deletions(-)

Index: linux/arch/i386/oprofile/backtrace.c
===================================================================
--- linux.orig/arch/i386/oprofile/backtrace.c
+++ linux/arch/i386/oprofile/backtrace.c
@@ -76,16 +76,8 @@ dump_user_backtrace(struct frame_head * 
 void
 x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 {
-	struct frame_head *head;
-	unsigned long stack;
-
-#ifdef CONFIG_X86_64
-	head = (struct frame_head *)regs->rbp;
-	stack = regs->rsp;
-#else
-	head = (struct frame_head *)regs->ebp;
-	stack = regs->esp;
-#endif
+	struct frame_head *head = (struct frame_head *)frame_pointer(regs);
+	unsigned long stack = stack_pointer(regs);
 
 	if (!user_mode_vm(regs)) {
 		if (depth)
Index: linux/include/asm-i386/ptrace.h
===================================================================
--- linux.orig/include/asm-i386/ptrace.h
+++ linux/include/asm-i386/ptrace.h
@@ -55,6 +55,8 @@ static inline int v8086_mode(struct pt_r
 }
 
 #define instruction_pointer(regs) ((regs)->eip)
+#define frame_pointer(regs) ((regs)->ebp)
+#define stack_pointer(regs) ((regs)->esp)
 #define regs_return_value(regs) ((regs)->eax)
 
 extern unsigned long profile_pc(struct pt_regs *regs);
Index: linux/include/asm-x86_64/ptrace.h
===================================================================
--- linux.orig/include/asm-x86_64/ptrace.h
+++ linux/include/asm-x86_64/ptrace.h
@@ -40,6 +40,8 @@ struct pt_regs {
 #define user_mode(regs) (!!((regs)->cs & 3))
 #define user_mode_vm(regs) user_mode(regs)
 #define instruction_pointer(regs) ((regs)->rip)
+#define frame_pointer(regs) ((regs)->rbp)
+#define stack_pointer(regs) ((regs)->rsp)
 #define regs_return_value(regs) ((regs)->rax)
 
 extern unsigned long profile_pc(struct pt_regs *regs);
