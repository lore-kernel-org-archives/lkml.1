Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbYABUKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbYABUKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYABUJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:09:07 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:55687 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbYABUJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:09:06 -0500
Date: Wed, 2 Jan 2008 15:08:54 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 6/7] UML - Remove init_irq_signals
Message-ID: <20080102200854.GA7964@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_irq_signals doesn't need to be called from the context of a new
process.  It initializes handlers, which are useless in process
context.  With that call gone, init_irq_signals has only one caller,
so it can be inlined into init_new_thread_signals.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/os.h       |    1 -
 arch/um/os-Linux/irq.c     |   11 -----------
 arch/um/os-Linux/process.c |    5 ++++-
 3 files changed, 4 insertions(+), 13 deletions(-)

Index: linux-2.6-git/arch/um/include/os.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/os.h	2007-12-13 12:43:29.000000000 -0500
+++ linux-2.6-git/arch/um/include/os.h	2007-12-13 17:48:06.000000000 -0500
@@ -285,7 +285,6 @@ extern void os_free_irq_later(struct irq
 extern int os_get_pollfd(int i);
 extern void os_set_pollfd(int i, int fd);
 extern void os_set_ioignore(void);
-extern void init_irq_signals(int on_sigstack);
 
 /* sigio.c */
 extern int add_sigio_fd(int fd);
Index: linux-2.6-git/arch/um/os-Linux/irq.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/irq.c	2007-12-13 12:43:21.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/irq.c	2007-12-13 17:48:06.000000000 -0500
@@ -136,14 +136,3 @@ void os_set_ioignore(void)
 {
 	signal(SIGIO, SIG_IGN);
 }
-
-void init_irq_signals(int on_sigstack)
-{
-	int flags;
-
-	flags = on_sigstack ? SA_ONSTACK : 0;
-
-	set_handler(SIGIO, (__sighandler_t) sig_handler, flags | SA_RESTART,
-		    SIGUSR1, SIGIO, SIGWINCH, SIGVTALRM, -1);
-	signal(SIGWINCH, SIG_IGN);
-}
Index: linux-2.6-git/arch/um/os-Linux/process.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/process.c	2007-12-13 12:42:57.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/process.c	2007-12-13 17:48:06.000000000 -0500
@@ -249,7 +249,10 @@ void init_new_thread_signals(void)
 		    SIGUSR1, SIGIO, SIGWINCH, SIGVTALRM, -1);
 	signal(SIGHUP, SIG_IGN);
 
-	init_irq_signals(1);
+	set_handler(SIGIO, (__sighandler_t) sig_handler,
+		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH, SIGALRM,
+		    SIGVTALRM, -1);
+	signal(SIGWINCH, SIG_IGN);
 }
 
 int run_kernel_thread(int (*fn)(void *), void *arg, jmp_buf **jmp_ptr)
