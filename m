Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbXKBPlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbXKBPlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbXKBPlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:41:13 -0400
Received: from [198.99.130.12] ([198.99.130.12]:60094 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbXKBPlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:41:10 -0400
Date: Fri, 2 Nov 2007 11:40:14 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Karol Swietlicki <magotari@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/6] UML - Improve detection of host cmov
Message-ID: <20071102154014.GA10263@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karol Swietlicki <magotari@gmail.com>

This patch introduces a new way of checking for the cmov instruction.
I use signal handling instead of reading /proc/cpuinfo.

[ jdike - Fiddled the asm to make it obvious that it didn't mess with
any in-use registers and made test_for_host_cmov void ]

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/sys-i386/bugs.c |   41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

Index: linux-2.6.22/arch/um/sys-i386/bugs.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/bugs.c	2007-10-30 12:31:35.000000000 -0400
+++ linux-2.6.22/arch/um/sys-i386/bugs.c	2007-10-31 11:24:45.000000000 -0400
@@ -10,11 +10,42 @@
 #include "os.h"
 #include "task.h"
 #include "user.h"
+#include "sysdep/archsetjmp.h"
 
 #define MAXTOKEN 64
 
 /* Set during early boot */
 int host_has_cmov = 1;
+static jmp_buf cmov_test_return;
+
+static void cmov_sigill_test_handler(int sig)
+{
+	host_has_cmov = 0;
+	longjmp(cmov_test_return, 1);
+}
+
+static void test_for_host_cmov(void)
+{
+	struct sigaction old, new;
+
+	printk(UM_KERN_INFO "Checking for host processor cmov support...");
+	new.sa_handler = cmov_sigill_test_handler;
+
+	/* Make sure that SIGILL is enabled after the handler longjmps back */
+	new.sa_flags = SA_NODEFER;
+	sigemptyset(&new.sa_mask);
+	sigaction(SIGILL, &new, &old);
+
+	if (setjmp(cmov_test_return) == 0) {
+		unsigned long foo = 0;
+		__asm__ __volatile__("cmovz %0, %1" : "=r" (foo) : "0" (foo));
+		printk("Yes\n");
+	}
+	else
+		printk("No\n");
+
+	sigaction(SIGILL, &old, &new);
+}
 
 static char token(int fd, char *buf, int len, char stop)
 {
@@ -153,15 +184,7 @@ void arch_init_thread(void)
 
 void arch_check_bugs(void)
 {
-	int have_it;
-
-	if (os_access("/proc/cpuinfo", OS_ACC_R_OK) < 0) {
-		printk(UM_KERN_ERR "/proc/cpuinfo not available - skipping CPU "
-		       "capability checks\n");
-		return;
-	}
-	if (check_cpu_flag("cmov", &have_it))
-		host_has_cmov = have_it;
+	test_for_host_cmov();
 }
 
 int arch_handle_signal(int sig, struct uml_pt_regs *regs)
