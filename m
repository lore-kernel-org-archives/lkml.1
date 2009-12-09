Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZLIRed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZLIRed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbZLIReW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:34:22 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:47810 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbZLIReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:34:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BUicGnlul4+gu/67LSxXekTxAXGvNsqooAzI1/P2cUXsqTw4L8ZPcZRSlN3fvCRl7L
         iBzRLtnPG/X1AfqusXL7rz0YhGO8YtxZJrFblefCSUxyGd9QcvdYcgLMR9R/aR/bhpZi
         IChYc6VASPYMCmMxy7D0fK+DaIGTxWScZUgiM=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86, 32-bit: Use same regs as 64-bit for kernel_thread_helper
Date: Wed,  9 Dec 2009 12:34:42 -0500
Message-Id: <1260380084-3707-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260380084-3707-1-git-send-email-brgerst@gmail.com>
References: <1260380084-3707-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arg should be in %eax, but that is clobbered by the return value
of clone.  The function pointer can be in any register.  Also, don't
push args onto the stack, since regparm(3) is the normal calling
convention now.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/entry_32.S   |    8 ++------
 arch/x86/kernel/process_32.c |    8 ++++----
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 50b9c22..0507b02 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1008,12 +1008,8 @@ END(spurious_interrupt_bug)
 ENTRY(kernel_thread_helper)
 	pushl $0		# fake return address for unwinder
 	CFI_STARTPROC
-	movl %edx,%eax
-	push %edx
-	CFI_ADJUST_CFA_OFFSET 4
-	call *%ebx
-	push %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	movl %edi,%eax
+	call *%esi
 	call do_exit
 	ud2			# padding for call trace
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 075580b..ee0d4bc 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -193,8 +193,8 @@ void show_regs(struct pt_regs *regs)
 }
 
 /*
- * This gets run with %bx containing the
- * function to call, and %dx containing
+ * This gets run with %si containing the
+ * function to call, and %di containing
  * the "args".
  */
 extern void kernel_thread_helper(void);
@@ -208,8 +208,8 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 
 	memset(&regs, 0, sizeof(regs));
 
-	regs.bx = (unsigned long) fn;
-	regs.dx = (unsigned long) arg;
+	regs.si = (unsigned long) fn;
+	regs.di = (unsigned long) arg;
 
 	regs.ds = __USER_DS;
 	regs.es = __USER_DS;
-- 
1.6.5.2

