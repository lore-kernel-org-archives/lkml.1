Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYCESP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYCESP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 13:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbYCESPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 13:15:09 -0500
Received: from hall.aurel32.net ([88.191.38.19]:37070 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYCESPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 13:15:08 -0500
Date: Wed, 5 Mar 2008 19:14:24 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Clear DF before calling signal handler
Message-ID: <20080305181424.GA12678@hall.aurel32.net>
Mail-Followup-To: Aurelien Jarno <aurelien@aurel32.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
References: <20080305153020.GA24631@volta.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080305153020.GA24631@volta.aurel32.net>
X-Mailer: Mutt 1.5.13 (2006-08-11)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel currently does not clear the direction flag before
calling a signal handler, whereas the x86/x86-64 ABI requires that.
This become a real problem with gcc version 4.3, which assumes that
the direction flag is correctly cleared at the entry of a function.

This patches changes the setup_frame() functions to clear the
direction before entering the signal handler.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
---
 arch/x86/ia32/ia32_signal.c |    4 ++--
 arch/x86/kernel/signal_32.c |    4 ++--
 arch/x86/kernel/signal_64.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 1c0503b..5e7771a 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -500,7 +500,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	regs->ss = __USER32_DS;
 
 	set_fs(USER_DS);
-	regs->flags &= ~X86_EFLAGS_TF;
+	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
@@ -600,7 +600,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->ss = __USER32_DS;
 
 	set_fs(USER_DS);
-	regs->flags &= ~X86_EFLAGS_TF;
+	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index caee1f0..0157a6f 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -407,7 +407,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	 * The tracer may want to single-step inside the
 	 * handler too.
 	 */
-	regs->flags &= ~TF_MASK;
+	regs->flags &= ~(TF_MASK | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
@@ -500,7 +500,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * The tracer may want to single-step inside the
 	 * handler too.
 	 */
-	regs->flags &= ~TF_MASK;
+	regs->flags &= ~(TF_MASK | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 7347bb1..56b72fb 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -295,7 +295,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	   see include/asm-x86_64/uaccess.h for details. */
 	set_fs(USER_DS);
 
-	regs->flags &= ~X86_EFLAGS_TF;
+	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 #ifdef DEBUG_SIG
-- 
1.5.4.3


-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
