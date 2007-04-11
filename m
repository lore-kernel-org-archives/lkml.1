Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbXDKQHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbXDKQHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 12:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbXDKQHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 12:07:08 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:46146 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbXDKQHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 12:07:06 -0400
Date: Wed, 11 Apr 2007 12:01:27 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/4] UML - Don't try to handle signals on initial process stack
Message-ID: <20070411160127.GA6334@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Code running on the initial UML stack can't receive or process signals
since current must be valid when IRQs are handled, and there is no
current for this stack.

So, instead of using UML_LONGJMP and UML_SETJMP, which are careful
to save and restore signal state, and, as a side-effect, handle any
deferred signals, start_idle_thread must use the bare equivalents,
which don't do anything with signals.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/skas/process.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6.21-mm/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/process.c	2007-04-10 20:21:06.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/process.c	2007-04-10 20:21:12.000000000 -0400
@@ -494,7 +494,15 @@ int start_idle_thread(void *stack, jmp_b
 		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGALRM,
 		    SIGVTALRM, -1);
 
-	n = UML_SETJMP(&initial_jmpbuf);
+	/*
+	 * Can't use UML_SETJMP or UML_LONGJMP here because they save
+	 * and restore signals, with the possible side-effect of
+	 * trying to handle any signals which came when they were
+	 * blocked, which can't be done on this stack.
+	 * Signals must be blocked when jumping back here and restored
+	 * after returning to the jumper.
+	 */
+	n = setjmp(initial_jmpbuf);
 	switch(n){
 	case INIT_JMP_NEW_THREAD:
 		(*switch_buf)[0].JB_IP = (unsigned long) new_thread_handler;
@@ -504,7 +512,7 @@ int start_idle_thread(void *stack, jmp_b
 		break;
 	case INIT_JMP_CALLBACK:
 		(*cb_proc)(cb_arg);
-		UML_LONGJMP(cb_back, 1);
+		longjmp(*cb_back, 1);
 		break;
 	case INIT_JMP_HALT:
 		kmalloc_ok = 0;
@@ -515,7 +523,7 @@ int start_idle_thread(void *stack, jmp_b
 	default:
 		panic("Bad sigsetjmp return in start_idle_thread - %d\n", n);
 	}
-	UML_LONGJMP(switch_buf, 1);
+	longjmp(*switch_buf, 1);
 }
 
 void initial_thread_cb_skas(void (*proc)(void *), void *arg)
