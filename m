Return-Path: <linux-kernel-owner+w=401wt.eu-S935337AbYBHULk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935337AbYBHULk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934862AbYBHULT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:11:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:28994 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934703AbYBHULS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:11:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=h7ywWMaGHhMwZvi4C5bow3VINW/lVpH0VDh+VcFzMxDu3k5+ZKY1u4pVcIkpIs+rf6MV6S2hcU90kHEXp/6t210dAo9bR20aeZd4T4rhNamLdUAvh/RW4YBdnmrXRuQcZoiyb7Iaw8XpkUPRtfanODEONOGiG9tGUaYUYozEYHg=
Subject: [PATCH 2/9] x86: make X86_32 pt_regs members unsigned long
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 12:09:57 -0800
Message-Id: <1202501397.12966.21.camel@brick>
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


