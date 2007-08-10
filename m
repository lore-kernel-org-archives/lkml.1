Return-Path: <linux-kernel-owner+w=401wt.eu-S937749AbXHJNio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937749AbXHJNio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937787AbXHJNhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:37:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:48714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937791AbXHJNhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:37:43 -0400
Message-Id: <20070810133636.037056892@suse.de>
References: <20070810133528.883477787@suse.de>
User-Agent: quilt/0.46-62.2
Date: Fri, 10 Aug 2007 15:35:30 +0200
From: jblunck@suse.de
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de
Subject: [PATCH 2/2] i386/x86_64: Introduce frame_pointer() and stack_pointer()
Content-Disposition: inline; filename=patches.fixes/x86-introduce-stack_frame_pointer.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines frame_pointer() and stack_pointer() similar to the
already defined instruction_pointer(). Thus the oprofile code can be written
in a more readable fashion.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 arch/i386/oprofile/backtrace.c |   12 ++----------
 include/asm-i386/ptrace.h      |    2 ++
 include/asm-x86_64/ptrace.h    |    2 ++
 3 files changed, 6 insertions(+), 10 deletions(-)

--- a/arch/i386/oprofile/backtrace.c
+++ b/arch/i386/oprofile/backtrace.c
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
--- a/include/asm-i386/ptrace.h
+++ b/include/asm-i386/ptrace.h
@@ -78,6 +78,8 @@ static inline int v8086_mode(struct pt_r
 }
 
 #define instruction_pointer(regs) ((regs)->eip)
+#define frame_pointer(regs) ((regs)->ebp)
+#define stack_pointer(regs) ((regs)->esp)
 #define regs_return_value(regs) ((regs)->eax)
 
 extern unsigned long profile_pc(struct pt_regs *regs);
--- a/include/asm-x86_64/ptrace.h
+++ b/include/asm-x86_64/ptrace.h
@@ -39,6 +39,8 @@ struct pt_regs {
 #define user_mode(regs) (!!((regs)->cs & 3))
 #define user_mode_vm(regs) user_mode(regs)
 #define instruction_pointer(regs) ((regs)->rip)
+#define frame_pointer(regs) ((regs)->rbp)
+#define stack_pointer(regs) ((regs)->rsp)
 #define regs_return_value(regs) ((regs)->rax)
 
 extern unsigned long profile_pc(struct pt_regs *regs);

-- 

