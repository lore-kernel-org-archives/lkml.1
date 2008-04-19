Return-Path: <linux-kernel-owner+w=401wt.eu-S1762630AbYDSV2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762630AbYDSV2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 17:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYDSV23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 17:28:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYDSV22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 17:28:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86 signals: lift set_fs
In-Reply-To: Roland McGrath's message of  Saturday, 19 April 2008 14:26:54 -0700 <20080419212654.9971827037C@magilla.localdomain>
X-Fcc: ~/Mail/linus
References: <20080419212654.9971827037C@magilla.localdomain>
X-Shopping-List: (1) Precious griddles
   (2) Whimsical tension breath
   (3) Wine-making checks
   (4) Maternity reservation distenders
   (5) Nice lips
Message-Id: <20080419212756.ABAF227037C@magilla.localdomain>
Date: Sat, 19 Apr 2008 14:27:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lifts the set_fs(USER_DS) call for signal handler setup out of the
three places copying the same code into the one place that calls them
all.  There is no change in what it does.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ia32_signal.c |    4 ----
 arch/x86/kernel/signal_64.c |   11 +++++++----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 0866104..bbed3a2 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -499,8 +499,6 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	regs->cs = __USER32_CS;
 	regs->ss = __USER32_DS;
 
-	set_fs(USER_DS);
-
 #if DEBUG_SIG
 	printk(KERN_DEBUG "SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
 	       current->comm, current->pid, frame, regs->ip, frame->pretcode);
@@ -596,8 +594,6 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->cs = __USER32_CS;
 	regs->ss = __USER32_DS;
 
-	set_fs(USER_DS);
-
 #if DEBUG_SIG
 	printk(KERN_DEBUG "SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
 	       current->comm, current->pid, frame, regs->ip, frame->pretcode);
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 3a76702..ccb2a45 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -285,10 +285,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	   even if the handler happens to be interrupting 32-bit code. */
 	regs->cs = __USER_CS;
 
-	/* This, by contrast, has nothing to do with segment registers -
-	   see include/asm-x86_64/uaccess.h for details. */
-	set_fs(USER_DS);
-
 	return 0;
 
 give_sigsegv:
@@ -377,6 +373,13 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 
 	if (ret == 0) {
 		/*
+		 * This has nothing to do with segment registers,
+		 * despite the name.  This magic affects uaccess.h
+		 * macros' behavior.  Reset it to the normal setting.
+		 */
+		set_fs(USER_DS);
+
+		/*
 		 * Clear the direction flag as per the ABI for function entry.
 		 */
 		regs->flags &= ~X86_EFLAGS_DF;
