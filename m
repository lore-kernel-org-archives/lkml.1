Return-Path: <linux-kernel-owner+w=401wt.eu-S1763416AbYCUWz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763416AbYCUWz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762881AbYCUWuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:50:09 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59115 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763661AbYCUWuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:01 -0400
Message-Id: <20080321224345.135865014@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:08 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Aurelien Jarno <aurelien@aurel32.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 18/76] x86: Clear DF before calling signal handler
Content-Disposition: inline; filename=x86-clear-df-before-calling-signal-handler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Aurelien Jarno <aurelien@aurel32.net>

x86: Clear DF before calling signal handler

The Linux kernel currently does not clear the direction flag before
calling a signal handler, whereas the x86/x86-64 ABI requires that.
This become a real problem with gcc version 4.3, which assumes that
the direction flag is correctly cleared at the entry of a function.

This patches changes the setup_frame() functions to clear the
direction before entering the signal handler.

This is a backport of patch e40cd10ccff3d9fbffd57b93780bee4b7b9bff51
("x86: clear DF before calling signal handler") that has been applied
in 2.6.25-rc.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/ia32/ia32_signal.c |    4 ++--
 arch/x86/kernel/signal_32.c |    4 ++--
 arch/x86/kernel/signal_64.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -494,7 +494,7 @@ int ia32_setup_frame(int sig, struct k_s
 	regs->ss = __USER32_DS; 
 
 	set_fs(USER_DS);
-	regs->eflags &= ~TF_MASK;
+	regs->eflags &= ~(TF_MASK | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
@@ -600,7 +600,7 @@ int ia32_setup_rt_frame(int sig, struct 
 	regs->ss = __USER32_DS; 
 
 	set_fs(USER_DS);
-	regs->eflags &= ~TF_MASK;
+	regs->eflags &= ~(TF_MASK | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -396,7 +396,7 @@ static int setup_frame(int sig, struct k
 	 * The tracer may want to single-step inside the
 	 * handler too.
 	 */
-	regs->eflags &= ~TF_MASK;
+	regs->eflags &= ~(TF_MASK | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
@@ -489,7 +489,7 @@ static int setup_rt_frame(int sig, struc
 	 * The tracer may want to single-step inside the
 	 * handler too.
 	 */
-	regs->eflags &= ~TF_MASK;
+	regs->eflags &= ~(TF_MASK | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -295,7 +295,7 @@ static int setup_rt_frame(int sig, struc
 	   see include/asm-x86_64/uaccess.h for details. */
 	set_fs(USER_DS);
 
-	regs->eflags &= ~TF_MASK;
+	regs->eflags &= ~(TF_MASK | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 #ifdef DEBUG_SIG

-- 
