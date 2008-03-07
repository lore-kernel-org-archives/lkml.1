Return-Path: <linux-kernel-owner+w=401wt.eu-S1762292AbYCGWFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762292AbYCGWFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYCGWE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:04:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270AbYCGWEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:04:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 7 March 2008 14:02:55 -0800 <20080307220255.1BEE826F990@magilla.localdomain>
References: <20080307220255.1BEE826F990@magilla.localdomain>
Subject: [PATCH 2/2] x86 signals: lift set_fs
Emacs: where editing text is like playing Paganini on a glass harmonica.
Message-Id: <20080307220419.C7A7B26F990@magilla.localdomain>
Date: Fri,  7 Mar 2008 14:04:19 -0800 (PST)
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
index e5e4b00..101b4b8 100644
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
index 6c3f5f1..3aa36c6 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -291,10 +291,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	   even if the handler happens to be interrupting 32-bit code. */
 	regs->cs = __USER_CS;
 
-	/* This, by contrast, has nothing to do with segment registers -
-	   see include/asm-x86_64/uaccess.h for details. */
-	set_fs(USER_DS);
-
 #ifdef DEBUG_SIG
 	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%p\n",
 		current->comm, current->pid, frame, regs->ip, frame->pretcode);
@@ -394,6 +390,13 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 
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
