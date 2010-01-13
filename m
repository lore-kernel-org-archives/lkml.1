Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949Ab0AMPpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0AMPpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314Ab0AMPpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:45:45 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50449 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0AMPpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:45:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p6/eyoxGWprTifgCII2n+OxhEUF0RmwXsnlcsM7BNxo0VnqnIy7oFKAyLEqwCV2C9n
         tseeNnRb3CwYFO2sEZ1MJgVzX3QTTiLDfiNNJr0j7JFC7y4itwfhJSCiT4fvDpISLlqe
         ckEst8LfMrb55jHob3B7E3v4BAYuSOKYmDxnA=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Merge show_regs()
Date: Wed, 13 Jan 2010 10:45:55 -0500
Message-Id: <1263397555-27695-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kernel_stack_pointer() allows 32-bit and 64-bit versions to
be merged.  This is more correct for 64-bit, since the old %rsp is
always saved on the stack.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/process.c    |    7 +++++++
 arch/x86/kernel/process_32.c |    6 ------
 arch/x86/kernel/process_64.c |    6 ------
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c6ee241..cbdbbdb 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -92,6 +92,13 @@ void exit_thread(void)
 	}
 }
 
+void show_regs(struct pt_regs *regs)
+{
+	show_registers(regs);
+	show_trace(NULL, regs, (unsigned long *)kernel_stack_pointer(regs),
+		   regs->bp);
+}
+
 void show_regs_common(void)
 {
 	const char *board, *product;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 37ad1e0..f6c6266 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -174,12 +174,6 @@ void __show_regs(struct pt_regs *regs, int all)
 			d6, d7);
 }
 
-void show_regs(struct pt_regs *regs)
-{
-	show_registers(regs);
-	show_trace(NULL, regs, &regs->sp, regs->bp);
-}
-
 void release_thread(struct task_struct *dead_task)
 {
 	BUG_ON(dead_task->mm);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index f9e0331..ff5830b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -211,12 +211,6 @@ void __show_regs(struct pt_regs *regs, int all)
 	printk(KERN_DEFAULT "DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
 }
 
-void show_regs(struct pt_regs *regs)
-{
-	show_registers(regs);
-	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
-}
-
 void release_thread(struct task_struct *dead_task)
 {
 	if (dead_task->mm) {
-- 
1.6.5.2

