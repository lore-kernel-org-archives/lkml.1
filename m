Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYABUJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYABUJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYABUJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:09:05 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:55679 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYABUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:09:01 -0500
Date: Wed, 2 Jan 2008 15:08:53 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/7] UML - Signal handling tidying
Message-ID: <20080102200853.GA7954@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tidies the signal handling code slightly.

pending is renamed to signals_pending for symmetry with signals_enabled.

remove_sigstack was unused, so can be deleted.

The value of change_sig was never used, so it is now void and the
return value is not calculated any more.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/signal.c |   31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

Index: linux-2.6-git/arch/um/os-Linux/signal.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/signal.c	2007-12-14 10:29:21.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/signal.c	2007-12-14 10:41:00.000000000 -0500
@@ -63,7 +63,7 @@ static void sig_handler_common(int sig, 
 #define SIGVTALRM_MASK (1 << SIGVTALRM_BIT)
 
 static int signals_enabled;
-static unsigned int pending;
+static unsigned int signals_pending;
 
 void sig_handler(int sig, struct sigcontext *sc)
 {
@@ -71,7 +71,7 @@ void sig_handler(int sig, struct sigcont
 
 	enabled = signals_enabled;
 	if (!enabled && (sig == SIGIO)) {
-		pending |= SIGIO_MASK;
+		signals_pending |= SIGIO_MASK;
 		return;
 	}
 
@@ -99,7 +99,7 @@ void alarm_handler(int sig, struct sigco
 
 	enabled = signals_enabled;
 	if (!signals_enabled) {
-		pending |= SIGVTALRM_MASK;
+		signals_pending |= SIGVTALRM_MASK;
 		return;
 	}
 
@@ -125,16 +125,6 @@ void set_sigstack(void *sig_stack, int s
 		panic("enabling signal stack failed, errno = %d\n", errno);
 }
 
-void remove_sigstack(void)
-{
-	stack_t stack = ((stack_t) { .ss_flags	= SS_DISABLE,
-				     .ss_sp	= NULL,
-				     .ss_size	= 0 });
-
-	if (sigaltstack(&stack, NULL) != 0)
-		panic("disabling signal stack failed, errno = %d\n", errno);
-}
-
 void (*handlers[_NSIG])(int sig, struct sigcontext *sc);
 
 void handle_signal(int sig, struct sigcontext *sc)
@@ -213,13 +203,14 @@ void set_handler(int sig, void (*handler
 
 int change_sig(int signal, int on)
 {
-	sigset_t sigset, old;
+	sigset_t sigset;
 
 	sigemptyset(&sigset);
 	sigaddset(&sigset, signal);
-	if (sigprocmask(on ? SIG_UNBLOCK : SIG_BLOCK, &sigset, &old) < 0)
+	if (sigprocmask(on ? SIG_UNBLOCK : SIG_BLOCK, &sigset, NULL) < 0)
 		return -errno;
-	return !sigismember(&old, signal);
+
+	return 0;
 }
 
 void block_signals(void)
@@ -244,26 +235,26 @@ void unblock_signals(void)
 	/*
 	 * We loop because the IRQ handler returns with interrupts off.  So,
 	 * interrupts may have arrived and we need to re-enable them and
-	 * recheck pending.
+	 * recheck signals_pending.
 	 */
 	while(1) {
 		/*
 		 * Save and reset save_pending after enabling signals.  This
-		 * way, pending won't be changed while we're reading it.
+		 * way, signals_pending won't be changed while we're reading it.
 		 */
 		signals_enabled = 1;
 
 		/*
-		 * Setting signals_enabled and reading pending must
+		 * Setting signals_enabled and reading signals_pending must
 		 * happen in this order.
 		 */
 		barrier();
 
-		save_pending = pending;
+		save_pending = signals_pending;
 		if (save_pending == 0)
 			return;
 
-		pending = 0;
+		signals_pending = 0;
 
 		/*
 		 * We have pending interrupts, so disable signals, as the
