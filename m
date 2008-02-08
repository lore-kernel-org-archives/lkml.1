Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYBHFGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYBHFGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYBHFG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:06:27 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:37859 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbYBHFGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:06:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UfSRkqL/BMojwhmfEWf7HghaZxkYVfBwWfIRheL+Uw7/w8pHt1uhqcmxOswplJiSQvrlYJyiQyxtUgeMid90NggX6PznGSQIgfyJ/8EGnnLhuQb6YS8RnslfHiLOOZCJ5JYLZHe6tWEoQg9OR7PJ+hjBtfnui4FVkO+plvXzuYU=
Subject: [PATCH 1/2] x86: make X86_32 pt_regs members unsigned long
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 21:06:22 -0800
Message-Id: <1202447182.31361.41.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to X86_64, move the 32 bit pt_regs to be unsigned long.
Adopt the X86_64-style of casting orig_ax to long in the signal.c
if statements when checking for >=0.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/signal_32.c |    4 ++--
 include/asm-x86/ptrace.h    |    9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 7718395..c1f4ff7 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -527,7 +527,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	int ret;
 
 	/* Are we from a system call? */
-	if (regs->orig_ax >= 0) {
+	if ((long)regs->orig_ax >= 0) {
 		/* If so, check system call restarting.. */
 		switch (regs->ax) {
 		        case -ERESTART_RESTARTBLOCK:
@@ -625,7 +625,7 @@ static void do_signal(struct pt_regs *regs)
 	}
 
 	/* Did we come from a system call? */
-	if (regs->orig_ax >= 0) {
+	if ((long)regs->orig_ax >= 0) {
 		/* Restart the system call - no handlers present */
 		switch (regs->ax) {
 		case -ERESTARTNOHAND:
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 708337a..bc44246 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -42,12 +42,12 @@ struct pt_regs {
 	unsigned long si;
 	unsigned long di;
 	unsigned long bp;
-	long ax;
+	unsigned long ax;
 	unsigned long ds;
 	unsigned long es;
 	unsigned long fs;
 	/* int  gs; */
-	long orig_ax;
+	unsigned long orig_ax;
 	unsigned long ip;
 	unsigned long cs;
 	unsigned long flags;
@@ -145,7 +145,10 @@ extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int erro
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 #endif
 
-#define regs_return_value(regs) ((regs)->ax)
+static inline unsigned long regs_return_value(struct pt_regs *regs)
+{
+	return regs->ax;
+}
 
 /*
  * user_mode_vm(regs) determines whether a register set came from user mode.
-- 
1.5.4.1219.g65b9


