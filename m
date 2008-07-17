Return-Path: <linux-kernel-owner+w=401wt.eu-S1760683AbYGQHuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbYGQHuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbYGQHuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:50:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812AbYGQHuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:50:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 4/6] x86 signals: use asm/syscall.h
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:45:50 -0700 <20080717074550.EE1E215411D@magilla.localdomain>
References: <20080717074550.EE1E215411D@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080717074942.15B5D15411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:49:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace local inlines with the asm/syscall.h
interfaces that do the same things.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/signal_64.c |   38 +++++---------------------------------
 1 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 5d6c237..e78b97f 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -27,6 +27,7 @@
 #include <asm/proto.h>
 #include <asm/ia32_unistd.h>
 #include <asm/mce.h>
+#include <asm/syscall.h>
 #include "sigframe.h"
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
@@ -294,35 +295,6 @@ give_sigsegv:
 }
 
 /*
- * Return -1L or the syscall number that @regs is executing.
- */
-static long current_syscall(struct pt_regs *regs)
-{
-	/*
-	 * We always sign-extend a -1 value being set here,
-	 * so this is always either -1L or a syscall number.
-	 */
-	return regs->orig_ax;
-}
-
-/*
- * Return a value that is -EFOO if the system call in @regs->orig_ax
- * returned an error.  This only works for @regs from @current.
- */
-static long current_syscall_ret(struct pt_regs *regs)
-{
-#ifdef CONFIG_IA32_EMULATION
-	if (test_thread_flag(TIF_IA32))
-		/*
-		 * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
-		 * and will match correctly in comparisons.
-		 */
-		return (int) regs->ax;
-#endif
-	return regs->ax;
-}
-
-/*
  * OK, we're invoking a handler
  */	
 
@@ -333,9 +305,9 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	int ret;
 
 	/* Are we from a system call? */
-	if (current_syscall(regs) >= 0) {
+	if (syscall_get_nr(current, regs) >= 0) {
 		/* If so, check system call restarting.. */
-		switch (current_syscall_ret(regs)) {
+		switch (syscall_get_error(current, regs)) {
 		case -ERESTART_RESTARTBLOCK:
 		case -ERESTARTNOHAND:
 			regs->ax = -EINTR;
@@ -458,9 +430,9 @@ static void do_signal(struct pt_regs *regs)
 	}
 
 	/* Did we come from a system call? */
-	if (current_syscall(regs) >= 0) {
+	if (syscall_get_nr(current, regs) >= 0) {
 		/* Restart the system call - no handlers present */
-		switch (current_syscall_ret(regs)) {
+		switch (syscall_get_error(current, regs)) {
 		case -ERESTARTNOHAND:
 		case -ERESTARTSYS:
 		case -ERESTARTNOINTR:
