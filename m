Return-Path: <linux-kernel-owner+w=401wt.eu-S934240AbXILVVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240AbXILVVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765597AbXILVRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:17:10 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55986 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765038AbXILVRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:17:04 -0400
Date: Wed, 12 Sep 2007 17:16:46 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/11] UML - Move timer signal initialization
Message-ID: <20070912211646.GA10287@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move timer signal initialization from init_irq_signals to a new
function, timer_init.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/os.h      |    1 +
 arch/um/kernel/time.c     |    2 ++
 arch/um/os-Linux/irq.c    |    4 ----
 arch/um/os-Linux/signal.c |   10 ++++++++++
 4 files changed, 13 insertions(+), 4 deletions(-)

Index: linux-2.6.22/arch/um/kernel/time.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/time.c	2007-09-09 11:51:19.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/time.c	2007-09-12 14:55:39.000000000 -0400
@@ -97,6 +97,8 @@ static void register_timer(void)
 {
 	int err;
 
+	timer_init();
+
 	err = request_irq(TIMER_IRQ, um_timer, IRQF_DISABLED, "timer", NULL);
 	if (err != 0)
 		printk(KERN_ERR "register_timer : request_irq failed - "
Index: linux-2.6.22/arch/um/os-Linux/irq.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/irq.c	2007-09-09 10:23:31.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/irq.c	2007-09-12 14:50:58.000000000 -0400
@@ -145,10 +145,6 @@ void init_irq_signals(int on_sigstack)
 
 	flags = on_sigstack ? SA_ONSTACK : 0;
 
-	set_handler(SIGVTALRM, (__sighandler_t) alarm_handler,
-		    flags | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH, SIGALRM, -1);
-	set_handler(SIGALRM, (__sighandler_t) alarm_handler,
-		    flags | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH, SIGALRM, -1);
 	set_handler(SIGIO, (__sighandler_t) sig_handler, flags | SA_RESTART,
 		    SIGUSR1, SIGIO, SIGWINCH, SIGALRM, SIGVTALRM, -1);
 	signal(SIGWINCH, SIG_IGN);
Index: linux-2.6.22/arch/um/include/os.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/os.h	2007-09-12 14:53:25.000000000 -0400
+++ linux-2.6.22/arch/um/include/os.h	2007-09-12 14:56:15.000000000 -0400
@@ -227,6 +227,7 @@ extern int set_umid(char *name);
 extern char *get_umid(void);
 
 /* signal.c */
+extern void timer_init(void);
 extern void set_sigstack(void *sig_stack, int size);
 extern void remove_sigstack(void);
 extern void set_handler(int sig, void (*handler)(int), int flags, ...);
Index: linux-2.6.22/arch/um/os-Linux/signal.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/signal.c	2007-09-11 20:28:13.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/signal.c	2007-09-12 14:55:18.000000000 -0400
@@ -85,6 +85,16 @@ void alarm_handler(int sig, struct sigco
 	set_signals(enabled);
 }
 
+void timer_init(void)
+{
+	set_handler(SIGVTALRM, (__sighandler_t) alarm_handler,
+		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH,
+		    SIGALRM, -1);
+	set_handler(SIGALRM, (__sighandler_t) alarm_handler,
+		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH,
+		    SIGALRM, -1);
+}
+
 void set_sigstack(void *sig_stack, int size)
 {
 	stack_t stack = ((stack_t) { .ss_flags	= 0,
