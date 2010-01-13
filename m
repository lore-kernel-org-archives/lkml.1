Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266Ab0AMSg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab0AMSg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086Ab0AMSg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:36:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:56975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab0AMSgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:36:55 -0500
Date: Wed, 13 Jan 2010 18:36:32 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1263397555-27695-1-git-send-email-brgerst@gmail.com>
References: <1263397555-27695-1-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Merge show_regs()
Message-ID: <tip-3bef444797f7624f8fbd27f4e0334ce96a108725@git.kernel.org>
Git-Commit-ID: 3bef444797f7624f8fbd27f4e0334ce96a108725
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 18:36:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bef444797f7624f8fbd27f4e0334ce96a108725
Gitweb:     http://git.kernel.org/tip/3bef444797f7624f8fbd27f4e0334ce96a108725
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 13 Jan 2010 10:45:55 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 13 Jan 2010 09:23:15 -0800

x86: Merge show_regs()

Using kernel_stack_pointer() allows 32-bit and 64-bit versions to
be merged.  This is more correct for 64-bit, since the old %rsp is
always saved on the stack.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1263397555-27695-1-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/process.c    |    7 +++++++
 arch/x86/kernel/process_32.c |    6 ------
 arch/x86/kernel/process_64.c |    6 ------
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 98c2cde..cf1e04b 100644
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
index 9c517b5..fe6a34e 100644
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
index 52fbd0c..418f860 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -211,12 +211,6 @@ void __show_regs(struct pt_regs *regs, int all)
 	printk(KERN_INFO "DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
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
